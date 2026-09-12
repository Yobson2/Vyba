import { Inject, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { IsNull, Repository } from 'typeorm';
import Redis from 'ioredis';
import { Going } from './entities/going.entity';
import { MarkGoingDto } from './dto/mark-going.dto';
import { UpdateGoingDto } from './dto/update-going.dto';
import { VenuesService } from '@modules/venues/venues.service';
import { VenueNightsService } from '@modules/venue-nights/venue-nights.service';
import { FeedItemsService } from '@modules/feed/feed-items.service';
import { ClockService } from '@common/clock/clock.service';
import { REDIS_CLIENT } from '@common/redis/redis.provider';
import {
  GoingLockedError,
  GoingNotFoundError,
  GoingRateLimitedError,
  GoingSelfMarkError,
} from '@common/exceptions/going.exceptions';
import { VenueOwnershipError } from '@common/exceptions/venue.exceptions';
import { AnalyticsService } from '@modules/analytics/analytics.service';

/** Recommended thresholds (spec 04) — one milestone feed item each, idempotent. */
const MILESTONE_THRESHOLDS = [10, 25, 50];

/** Guardrails, not a fraud system (spec 04) — proportionate to a ~500-user cohort. */
const MAX_CHURN_PER_NIGHT = 20;
const MAX_IP_MARKS = 30;
const IP_WINDOW_SECONDS = 15 * 60;

export interface OwnerGoingSummary {
  count: number;
  partySizes: number[];
}

@Injectable()
export class GoingService {
  constructor(
    @InjectRepository(Going)
    private readonly goingRepository: Repository<Going>,
    private readonly venuesService: VenuesService,
    private readonly venueNightsService: VenueNightsService,
    private readonly feedItemsService: FeedItemsService,
    private readonly clock: ClockService,
    private readonly analyticsService: AnalyticsService,
    @Inject(REDIS_CLIENT) private readonly redis: Redis,
  ) {}

  /**
   * Mark (or re-mark) "J'y vais" for tonight. Idempotent: marking while
   * already active just applies the given fields as an edit.
   */
  async mark(
    userId: string,
    clientIp: string,
    dto: MarkGoingDto,
  ): Promise<Going> {
    const venue = await this.venuesService.findActiveOrThrow(dto.venueId);
    if (venue.ownerUserId === userId) {
      throw new GoingSelfMarkError(dto.venueId);
    }

    await this.checkRateLimit(userId, dto.venueId, clientIp);

    const night = await this.venueNightsService.getOrCreateTonight(dto.venueId);

    let going = await this.goingRepository.findOne({
      where: { userId, venueNightId: night.id },
    });

    if (going) {
      going.canceledAt = null;
      if (dto.partySize !== undefined) going.partySize = dto.partySize;
      if (dto.identityPublic !== undefined)
        going.identityPublic = dto.identityPublic;
    } else {
      going = this.goingRepository.create({
        userId,
        venueId: dto.venueId,
        venueNightId: night.id,
        partySize: dto.partySize ?? 1,
        identityPublic: dto.identityPublic ?? false,
        canceledAt: null,
      });
    }
    const saved = await this.goingRepository.save(going);

    const count = await this.recomputeGoingCount(night.id);
    await this.checkMilestones(dto.venueId, night.id, night.date, count);

    await this.analyticsService.track({
      event: 'going_marked',
      userId,
      properties: { venue_id: dto.venueId, venue_night_id: night.id },
    });

    return saved;
  }

  async update(
    userId: string,
    venueId: string,
    dto: UpdateGoingDto,
  ): Promise<Going> {
    const going = await this.findMyActiveTonightOrThrow(userId, venueId);
    await this.assertBeforeMidnight(going.venueNightId);
    await this.checkRateLimit(userId, venueId);

    if (dto.partySize !== undefined) going.partySize = dto.partySize;
    if (dto.identityPublic !== undefined)
      going.identityPublic = dto.identityPublic;
    return this.goingRepository.save(going);
  }

  async cancel(userId: string, venueId: string): Promise<void> {
    const going = await this.findMyActiveTonightOrThrow(userId, venueId);
    await this.assertBeforeMidnight(going.venueNightId);
    await this.checkRateLimit(userId, venueId);

    going.canceledAt = this.clock.now();
    await this.goingRepository.save(going);
    await this.recomputeGoingCount(going.venueNightId);

    await this.analyticsService.track({
      event: 'going_cancelled',
      userId,
      properties: { venue_id: venueId, venue_night_id: going.venueNightId },
    });
  }

  /** My current mark for this venue tonight, or `null` if I haven't marked. */
  async getMine(userId: string, venueId: string): Promise<Going | null> {
    const night = await this.venueNightsService.getOrCreateTonight(venueId);
    return this.goingRepository.findOne({
      where: { userId, venueNightId: night.id, canceledAt: IsNull() },
    });
  }

  /** Owner-facing: count + rough party sizes, no identity (spec 04 — owner gets texture, not a guest list). */
  async getOwnerSummary(
    venueId: string,
    ownerId: string,
  ): Promise<OwnerGoingSummary> {
    const venue = await this.venuesService.findRawOrThrow(venueId);
    if (venue.ownerUserId !== ownerId) {
      throw new VenueOwnershipError(venueId);
    }

    const night = await this.venueNightsService.getOrCreateTonight(venueId);
    const active = await this.goingRepository.find({
      where: { venueNightId: night.id, canceledAt: IsNull() },
    });

    return {
      count: active.length,
      partySizes: active.map((g) => g.partySize),
    };
  }

  /** Internal only (spec 04) — consumed directly by the `notifications` unit, no HTTP surface. */
  async getReminderRecipients(
    dateISO: string,
  ): Promise<{ userId: string; venueId: string }[]> {
    const rows = await this.goingRepository
      .createQueryBuilder('going')
      .innerJoin('venue_nights', 'night', 'night.id = going.venueNightId')
      .where('night.date = :date', { date: dateISO })
      .andWhere('going.canceledAt IS NULL')
      .select(['going.userId AS "userId"', 'going.venueId AS "venueId"'])
      .getRawMany<{ userId: string; venueId: string }>();
    return rows;
  }

  /** Internal only (spec 08 / ticket 17) — tonight's active "going" for one venue, for the owner broadcast's recipient set. */
  async getActiveGoingUserIdsForVenue(
    venueId: string,
    dateISO: string,
  ): Promise<string[]> {
    const rows = await this.goingRepository
      .createQueryBuilder('going')
      .innerJoin('venue_nights', 'night', 'night.id = going.venueNightId')
      .where('night.date = :date', { date: dateISO })
      .andWhere('going.venueId = :venueId', { venueId })
      .andWhere('going.canceledAt IS NULL')
      .select('going.userId', 'userId')
      .getRawMany<{ userId: string }>();
    return rows.map((r) => r.userId);
  }

  private async findMyActiveTonightOrThrow(
    userId: string,
    venueId: string,
  ): Promise<Going> {
    const night = await this.venueNightsService.getOrCreateTonight(venueId);
    const going = await this.goingRepository.findOne({
      where: { userId, venueNightId: night.id, canceledAt: IsNull() },
    });
    if (!going) {
      throw new GoingNotFoundError(venueId);
    }
    return going;
  }

  private async recomputeGoingCount(venueNightId: string): Promise<number> {
    const count = await this.goingRepository.count({
      where: { venueNightId, canceledAt: IsNull() },
    });
    await this.venueNightsService.updateGoingCount(venueNightId, count);
    return count;
  }

  private async checkMilestones(
    venueId: string,
    venueNightId: string,
    venueNightDate: string,
    count: number,
  ): Promise<void> {
    for (const threshold of MILESTONE_THRESHOLDS) {
      if (count >= threshold) {
        await this.feedItemsService.emitGoingMilestoneIfNew(
          venueId,
          venueNightId,
          venueNightDate,
          threshold,
        );
      }
    }
  }

  private async assertBeforeMidnight(venueNightId: string): Promise<void> {
    const night = await this.venueNightsService.findNightOrThrow(venueNightId);
    const midnight = new Date(`${night.date}T00:00:00Z`);
    midnight.setUTCDate(midnight.getUTCDate() + 1);
    if (this.clock.now() >= midnight) {
      throw new GoingLockedError();
    }
  }

  private async checkRateLimit(
    userId: string,
    venueId: string,
    clientIp?: string,
  ): Promise<void> {
    const churnKey = `going:churn:${userId}:${venueId}`;
    const churnCount = await this.redis.incr(churnKey);
    if (churnCount === 1) {
      await this.redis.expire(churnKey, 24 * 60 * 60);
    }
    if (churnCount > MAX_CHURN_PER_NIGHT) {
      throw new GoingRateLimitedError();
    }

    if (clientIp) {
      const ipKey = `going:ip:${clientIp}`;
      const ipCount = await this.redis.incr(ipKey);
      if (ipCount === 1) {
        await this.redis.expire(ipKey, IP_WINDOW_SECONDS);
      }
      if (ipCount > MAX_IP_MARKS) {
        throw new GoingRateLimitedError();
      }
    }
  }
}
