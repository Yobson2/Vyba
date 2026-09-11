import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { VenueNight } from './entities/venue-night.entity';
import { SetHeadlineDto } from './dto/set-headline.dto';
import { VenuesService } from '@modules/venues/venues.service';
import { VenueType } from '@modules/venues/entities/venue.entity';
import {
  VenueOwnershipError,
  VenueNightNotFoundError,
} from '@common/exceptions/venue.exceptions';
import { abidjanToday } from '@common/config/abidjan-time.config';
import {
  FeedItemsService,
  PromoSummary,
} from '@modules/feed/feed-items.service';

export interface VenueTonight {
  isLive: boolean;
  liveSince: Date | null;
  headline: string | null;
  djName: string | null;
  goingCount: number;
}

export interface VenueDetail {
  id: string;
  name: string;
  description: string | null;
  address: string | null;
  latitude: number;
  longitude: number;
  venueType: VenueType;
  priceLevel: number;
  photos: string[];
  inLaunchArea: boolean;
  tonight: VenueTonight | null;
  promos: PromoSummary[];
}

@Injectable()
export class VenueNightsService {
  constructor(
    @InjectRepository(VenueNight)
    private readonly venueNightRepository: Repository<VenueNight>,
    private readonly venuesService: VenuesService,
    private readonly feedItemsService: FeedItemsService,
  ) {}

  /** Idempotent: toggling to the same state is a no-op that doesn't touch `liveSince`. */
  async setLive(
    venueId: string,
    ownerId: string,
    isLive: boolean,
  ): Promise<VenueNight> {
    await this.assertOwnership(venueId, ownerId);
    const night = await this.getOrCreateTonight(venueId);

    if (night.isLive === isLive) {
      return night;
    }

    night.isLive = isLive;
    if (isLive && !night.liveSince) {
      night.liveSince = new Date();
      night.liveSetBy = ownerId;
    }
    const saved = await this.venueNightRepository.save(night);

    // Ticket 07 integration: a live_tonight feed item tracks this toggle.
    await this.feedItemsService.syncLiveTonightItem(
      venueId,
      saved.id,
      saved.date,
      ownerId,
      isLive,
    );

    return saved;
  }

  async setHeadline(
    venueId: string,
    ownerId: string,
    dto: SetHeadlineDto,
  ): Promise<VenueNight> {
    await this.assertOwnership(venueId, ownerId);
    const night = await this.getOrCreateTonight(venueId);

    if (dto.headline !== undefined) night.headline = dto.headline;
    if (dto.djName !== undefined) night.djName = dto.djName;
    return this.venueNightRepository.save(night);
  }

  /**
   * The owner's own read of tonight's state — unlike `getPublicDetail`, this
   * doesn't require the venue to be `ACTIVE` yet (an owner mid-onboarding
   * must still be able to see/set their live status) and never creates a
   * row: a venue with nothing set yet just reads as "not live".
   */
  async getOwnerTonight(
    venueId: string,
    ownerId: string,
  ): Promise<VenueTonight> {
    await this.assertOwnership(venueId, ownerId);
    const night = await this.venueNightRepository.findOne({
      where: { venueId, date: abidjanToday() },
    });
    return night
      ? {
          isLive: night.isLive,
          liveSince: night.liveSince,
          headline: night.headline,
          djName: night.djName,
          goingCount: night.goingCount,
        }
      : {
          isLive: false,
          liveSince: null,
          headline: null,
          djName: null,
          goingCount: 0,
        };
  }

  /**
   * Durable profile + today's `VenueNight` (or `tonight: null`). PII-free —
   * this is the shared shape behind both the authenticated and the
   * unauthenticated read paths; never include owner data here.
   */
  async getPublicDetail(venueId: string): Promise<VenueDetail> {
    const venue = await this.venuesService.findActiveOrThrow(venueId);
    const night = await this.venueNightRepository.findOne({
      where: { venueId, date: abidjanToday() },
    });
    const promos =
      await this.feedItemsService.listActivePromosForVenue(venueId);

    return {
      id: venue.id,
      name: venue.name,
      description: venue.description,
      address: venue.address,
      latitude: venue.latitude,
      longitude: venue.longitude,
      venueType: venue.venueType,
      priceLevel: venue.priceLevel,
      photos: venue.photos,
      inLaunchArea: venue.inLaunchArea,
      promos,
      tonight: night
        ? {
            isLive: night.isLive,
            liveSince: night.liveSince,
            headline: night.headline,
            djName: night.djName,
            goingCount: night.goingCount,
          }
        : null,
    };
  }

  /** Get-or-create for "this venue tonight" — the seam `going`/`feed`/`promotions` attach to. */
  async getOrCreateTonight(venueId: string): Promise<VenueNight> {
    const date = abidjanToday();
    const existing = await this.venueNightRepository.findOne({
      where: { venueId, date },
    });
    if (existing) return existing;

    try {
      const created = this.venueNightRepository.create({ venueId, date });
      return await this.venueNightRepository.save(created);
    } catch {
      // Lost a get-or-create race — someone else's write landed first.
      const retry = await this.venueNightRepository.findOne({
        where: { venueId, date },
      });
      if (retry) return retry;
      throw new Error(`Failed to get-or-create VenueNight for ${venueId}`);
    }
  }

  /** For `going`'s edit/cancel/rate-limit paths, which hold a `venueNightId` directly. */
  async findNightOrThrow(id: string): Promise<VenueNight> {
    const night = await this.venueNightRepository.findOne({ where: { id } });
    if (!night) {
      throw new VenueNightNotFoundError(id);
    }
    return night;
  }

  /** Maintained by `GoingService` on every mark/cancel — recomputed, not incremented, to avoid drift. */
  async updateGoingCount(
    venueNightId: string,
    count: number,
  ): Promise<VenueNight> {
    const night = await this.findNightOrThrow(venueNightId);
    night.goingCount = count;
    return this.venueNightRepository.save(night);
  }

  private async assertOwnership(
    venueId: string,
    ownerId: string,
  ): Promise<void> {
    const venue = await this.venuesService.findRawOrThrow(venueId);
    if (venue.ownerUserId !== ownerId) {
      throw new VenueOwnershipError(venueId);
    }
  }
}
