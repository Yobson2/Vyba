import { Inject, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { In, Repository } from 'typeorm';
import Redis from 'ioredis';
import { Reservation, ReservationStatus } from './entities/reservation.entity';
import { CreateReservationDto } from './dto/create-reservation.dto';
import { VenuesService } from '@modules/venues/venues.service';
import { VenueNightsService } from '@modules/venue-nights/venue-nights.service';
import { ClockService } from '@common/clock/clock.service';
import { REDIS_CLIENT } from '@common/redis/redis.provider';
import {
  ReservationFullError,
  ReservationLockedError,
  ReservationNotFoundError,
  ReservationRateLimitedError,
  ReservationSelfMarkError,
  ReservationsDisabledError,
} from '@common/exceptions/reservation.exceptions';
import { VenueOwnershipError } from '@common/exceptions/venue.exceptions';
import { AnalyticsService } from '@modules/analytics/analytics.service';

/** Same order of magnitude as `going`'s guardrails (spec 04) — proportionate, not a fraud system. */
const MAX_ATTEMPTS_PER_NIGHT = 10;
const MAX_IP_ATTEMPTS = 30;
const IP_WINDOW_SECONDS = 15 * 60;

const ACTIVE_STATUSES = [
  ReservationStatus.PENDING,
  ReservationStatus.CONFIRMED,
];

export interface AvailabilityInfo {
  reservationsEnabled: boolean;
  /** Sum of confirmed party sizes for tonight; null when reservations aren't enabled for this venue. */
  confirmedReservationsCount: number | null;
}

@Injectable()
export class ReservationsService {
  constructor(
    @InjectRepository(Reservation)
    private readonly reservationRepository: Repository<Reservation>,
    private readonly venuesService: VenuesService,
    private readonly venueNightsService: VenueNightsService,
    private readonly clock: ClockService,
    private readonly analyticsService: AnalyticsService,
    @Inject(REDIS_CLIENT) private readonly redis: Redis,
  ) {}

  /** Requests a table for tonight — always `PENDING`; the owner decides. */
  async create(
    userId: string,
    clientIp: string,
    dto: CreateReservationDto,
  ): Promise<Reservation> {
    const venue = await this.venuesService.findActiveOrThrow(dto.venueId);
    if (!venue.reservationsEnabled) {
      throw new ReservationsDisabledError(dto.venueId);
    }
    if (venue.ownerUserId === userId) {
      throw new ReservationSelfMarkError(dto.venueId);
    }

    await this.checkRateLimit(userId, dto.venueId, clientIp);

    const night = await this.venueNightsService.getOrCreateTonight(dto.venueId);

    const existing = await this.reservationRepository.findOne({
      where: { userId, venueNightId: night.id, status: In(ACTIVE_STATUSES) },
    });
    if (existing) {
      if (dto.partySize !== undefined) existing.partySize = dto.partySize;
      if (dto.note !== undefined) existing.note = dto.note;
      const saved = await this.reservationRepository.save(existing);
      return saved;
    }

    const reservation = this.reservationRepository.create({
      userId,
      venueId: dto.venueId,
      venueNightId: night.id,
      partySize: dto.partySize ?? 1,
      note: dto.note ?? null,
      status: ReservationStatus.PENDING,
    });
    const saved = await this.reservationRepository.save(reservation);

    await this.analyticsService.track({
      event: 'reservation_requested',
      userId,
      properties: { venue_id: dto.venueId, venue_night_id: night.id },
    });

    return saved;
  }

  async cancel(userId: string, venueId: string): Promise<void> {
    const reservation = await this.findMyActiveTonightOrThrow(userId, venueId);
    await this.assertBeforeMidnight(reservation.venueNightId);

    reservation.status = ReservationStatus.CANCELED;
    await this.reservationRepository.save(reservation);

    await this.analyticsService.track({
      event: 'reservation_cancelled',
      userId,
      properties: {
        venue_id: venueId,
        venue_night_id: reservation.venueNightId,
      },
    });
  }

  /** My current active (pending or confirmed) request for this venue tonight, or `null`. */
  async getMine(userId: string, venueId: string): Promise<Reservation | null> {
    const night = await this.venueNightsService.getOrCreateTonight(venueId);
    return this.reservationRepository.findOne({
      where: { userId, venueNightId: night.id, status: In(ACTIVE_STATUSES) },
    });
  }

  /** Owner-facing: tonight's requests, pending first. */
  async listForOwner(venueId: string, ownerId: string): Promise<Reservation[]> {
    const venue = await this.venuesService.findRawOrThrow(venueId);
    if (venue.ownerUserId !== ownerId) {
      throw new VenueOwnershipError(venueId);
    }

    const nightId = await this.venueNightsService.findTonightId(venueId);
    if (!nightId) return [];

    const reservations = await this.reservationRepository.find({
      where: { venueNightId: nightId },
      order: { createdAt: 'ASC' },
    });

    const rank: Record<ReservationStatus, number> = {
      [ReservationStatus.PENDING]: 0,
      [ReservationStatus.CONFIRMED]: 1,
      [ReservationStatus.REJECTED]: 2,
      [ReservationStatus.CANCELED]: 2,
    };
    return reservations.sort((a, b) => rank[a.status] - rank[b.status]);
  }

  /**
   * Owner confirms or rejects a request. Capacity is enforced here, not at
   * request time — anyone can ask, confirming is what's capacity-gated.
   */
  async respond(
    id: string,
    ownerId: string,
    status: ReservationStatus.CONFIRMED | ReservationStatus.REJECTED,
  ): Promise<Reservation> {
    const reservation = await this.reservationRepository.findOne({
      where: { id },
    });
    if (!reservation) {
      throw new ReservationNotFoundError(id);
    }

    const venue = await this.venuesService.findRawOrThrow(reservation.venueId);
    if (venue.ownerUserId !== ownerId) {
      throw new VenueOwnershipError(reservation.venueId);
    }

    if (status === ReservationStatus.CONFIRMED && venue.capacity !== null) {
      const confirmedSoFar = await this.sumConfirmedPartySize(
        reservation.venueNightId,
      );
      if (confirmedSoFar + reservation.partySize > venue.capacity) {
        throw new ReservationFullError(reservation.venueId);
      }
    }

    reservation.status = status;
    reservation.respondedAt = this.clock.now();
    reservation.respondedBy = ownerId;
    return this.reservationRepository.save(reservation);
  }

  /** Read-only availability signal for the venue detail page (any authenticated caller). */
  async getAvailabilityInfo(venueId: string): Promise<AvailabilityInfo> {
    const venue = await this.venuesService.findRawOrThrow(venueId);
    if (!venue.reservationsEnabled) {
      return { reservationsEnabled: false, confirmedReservationsCount: null };
    }

    const nightId = await this.venueNightsService.findTonightId(venueId);
    if (!nightId) {
      return { reservationsEnabled: true, confirmedReservationsCount: 0 };
    }

    const count = await this.sumConfirmedPartySize(nightId);
    return { reservationsEnabled: true, confirmedReservationsCount: count };
  }

  private async sumConfirmedPartySize(venueNightId: string): Promise<number> {
    const row = await this.reservationRepository
      .createQueryBuilder('r')
      .select('COALESCE(SUM(r.partySize), 0)', 'sum')
      .where('r.venueNightId = :venueNightId', { venueNightId })
      .andWhere('r.status = :status', {
        status: ReservationStatus.CONFIRMED,
      })
      .getRawOne<{ sum: string }>();
    return Number(row?.sum ?? 0);
  }

  private async findMyActiveTonightOrThrow(
    userId: string,
    venueId: string,
  ): Promise<Reservation> {
    const night = await this.venueNightsService.getOrCreateTonight(venueId);
    const reservation = await this.reservationRepository.findOne({
      where: { userId, venueNightId: night.id, status: In(ACTIVE_STATUSES) },
    });
    if (!reservation) {
      throw new ReservationNotFoundError(venueId);
    }
    return reservation;
  }

  private async assertBeforeMidnight(venueNightId: string): Promise<void> {
    const night = await this.venueNightsService.findNightOrThrow(venueNightId);
    const midnight = new Date(`${night.date}T00:00:00Z`);
    midnight.setUTCDate(midnight.getUTCDate() + 1);
    if (this.clock.now() >= midnight) {
      throw new ReservationLockedError();
    }
  }

  private async checkRateLimit(
    userId: string,
    venueId: string,
    clientIp?: string,
  ): Promise<void> {
    const churnKey = `reservation:churn:${userId}:${venueId}`;
    const churnCount = await this.redis.incr(churnKey);
    if (churnCount === 1) {
      await this.redis.expire(churnKey, 24 * 60 * 60);
    }
    if (churnCount > MAX_ATTEMPTS_PER_NIGHT) {
      throw new ReservationRateLimitedError();
    }

    if (clientIp) {
      const ipKey = `reservation:ip:${clientIp}`;
      const ipCount = await this.redis.incr(ipKey);
      if (ipCount === 1) {
        await this.redis.expire(ipKey, IP_WINDOW_SECONDS);
      }
      if (ipCount > MAX_IP_ATTEMPTS) {
        throw new ReservationRateLimitedError();
      }
    }
  }
}
