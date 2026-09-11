import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import {
  FeedItem,
  FeedItemOrigin,
  FeedItemStatus,
  FeedItemType,
} from './entities/feed-item.entity';
import { CreateEditorialDto } from './dto/create-editorial.dto';
import { CreatePromoDto } from './dto/create-promo.dto';
import { FeedItemNotFoundError } from '@common/exceptions/feed.exceptions';
import { VenueOwnershipError } from '@common/exceptions/venue.exceptions';
import { abidjanToday } from '@common/config/abidjan-time.config';
import { rankFeedItems } from './feed-ranking.util';
import { VenuesService } from '@modules/venues/venues.service';
import { VenueType } from '@modules/venues/entities/venue.entity';

export interface PublicFeedItem {
  id: string;
  type: FeedItemType;
  venue: { id: string; name: string; venueType: VenueType } | null;
  startsAt: Date | null;
  expiresAt: Date | null;
  publishedAt: Date;
  payload: Record<string, unknown> | null;
}

export interface PromoSummary {
  id: string;
  title: string;
  description: string;
  publishedAt: Date;
}

/** Small candidate set by design (spec 03, MVP §3.4) — a generous default page. */
const DEFAULT_FEED_LIMIT = 50;

@Injectable()
export class FeedItemsService {
  constructor(
    @InjectRepository(FeedItem)
    private readonly feedItemRepository: Repository<FeedItem>,
    private readonly venuesService: VenuesService,
  ) {}

  /**
   * Called by `VenueNightsService` on every set-live toggle (ticket 06
   * integration). One item per `(venue, night)`: created on the first
   * "live" transition, republished/hidden on later toggles rather than
   * duplicated.
   */
  async syncLiveTonightItem(
    venueId: string,
    venueNightId: string,
    venueNightDate: string,
    ownerId: string,
    isLive: boolean,
  ): Promise<void> {
    const existing = await this.feedItemRepository.findOne({
      where: { venueNightId, type: FeedItemType.LIVE_TONIGHT },
    });

    if (!isLive) {
      if (existing && existing.status !== FeedItemStatus.HIDDEN) {
        existing.status = FeedItemStatus.HIDDEN;
        await this.feedItemRepository.save(existing);
      }
      return;
    }

    if (existing) {
      if (existing.status !== FeedItemStatus.PUBLISHED) {
        existing.status = FeedItemStatus.PUBLISHED;
        await this.feedItemRepository.save(existing);
      }
      return;
    }

    const item = this.feedItemRepository.create({
      type: FeedItemType.LIVE_TONIGHT,
      venueId,
      venueNightId,
      createdByUserId: ownerId,
      origin: FeedItemOrigin.VENUE,
      assisted: false,
      startsAt: new Date(`${venueNightDate}T00:00:00Z`),
      expiresAt: morningAfter(venueNightDate),
      publishedAt: new Date(),
      status: FeedItemStatus.PUBLISHED,
      payload: null,
    });
    await this.feedItemRepository.save(item);
  }

  async createEditorial(
    dto: CreateEditorialDto,
    adminUserId: string,
  ): Promise<FeedItem> {
    const item = this.feedItemRepository.create({
      type: FeedItemType.EDITORIAL,
      venueId: null,
      venueNightId: null,
      createdByUserId: adminUserId,
      origin: FeedItemOrigin.FOUNDER,
      assisted: false,
      startsAt: null,
      expiresAt: new Date(dto.expiresAt),
      publishedAt: dto.publishedAt ? new Date(dto.publishedAt) : new Date(),
      status: FeedItemStatus.PUBLISHED,
      payload: { title: dto.title, body: dto.body },
    });
    return this.feedItemRepository.save(item);
  }

  /**
   * Owner create-promo path (ticket 09): title + description only, no
   * image (ticket 14) or explicit date field — always today-scoped, same
   * `expiresAt` shape as `live_tonight`/`going_milestone` so it clears the
   * next morning without a cron. No `venueNightId`: promos aren't
   * night-scoped state (ADR-0001) and `feed` deliberately doesn't depend on
   * `venue-nights` (would be circular — `venue-nights` already depends on
   * `feed` for the live-tonight sync).
   */
  async createPromo(
    venueId: string,
    ownerId: string,
    dto: CreatePromoDto,
  ): Promise<FeedItem> {
    const venue = await this.venuesService.findRawOrThrow(venueId);
    if (venue.ownerUserId !== ownerId) {
      throw new VenueOwnershipError(venueId);
    }

    const today = abidjanToday();
    const item = this.feedItemRepository.create({
      type: FeedItemType.PROMO,
      venueId,
      venueNightId: null,
      createdByUserId: ownerId,
      origin: FeedItemOrigin.VENUE,
      assisted: false,
      startsAt: new Date(`${today}T00:00:00Z`),
      expiresAt: morningAfter(today),
      publishedAt: new Date(),
      status: FeedItemStatus.PUBLISHED,
      payload: { title: dto.title, description: dto.description },
    });
    return this.feedItemRepository.save(item);
  }

  /** Active (published, non-expired) promos for a venue's page (ticket 09). */
  async listActivePromosForVenue(venueId: string): Promise<PromoSummary[]> {
    const now = new Date();
    const items = await this.feedItemRepository
      .createQueryBuilder('item')
      .where('item.type = :type', { type: FeedItemType.PROMO })
      .andWhere('item.venueId = :venueId', { venueId })
      .andWhere('item.status = :status', { status: FeedItemStatus.PUBLISHED })
      .andWhere('(item.expiresAt IS NULL OR item.expiresAt > :now)', { now })
      .orderBy('item.publishedAt', 'DESC')
      .getMany();

    return items.map((item) => ({
      id: item.id,
      title: (item.payload?.title as string) ?? '',
      description: (item.payload?.description as string) ?? '',
      publishedAt: item.publishedAt,
    }));
  }

  async hide(id: string): Promise<FeedItem> {
    const item = await this.findOrThrow(id);
    item.status = FeedItemStatus.HIDDEN;
    return this.feedItemRepository.save(item);
  }

  async unhide(id: string): Promise<FeedItem> {
    const item = await this.findOrThrow(id);
    item.status = FeedItemStatus.PUBLISHED;
    return this.feedItemRepository.save(item);
  }

  /**
   * The ranking read (spec 03): published, non-expired, already-published
   * items for eligible (active, in-area) venues + area-wide editorial.
   * Expiry/publish-time correctness lives in this filter, not a cron.
   *
   * Paging: the full candidate set is ranked first (it's small by design),
   * then sliced — simple and correct, no need to page the ranking itself.
   */
  async listFeed(
    limit = DEFAULT_FEED_LIMIT,
    offset = 0,
  ): Promise<PublicFeedItem[]> {
    const now = new Date();

    const candidates = await this.feedItemRepository
      .createQueryBuilder('item')
      .where('item.status = :status', { status: FeedItemStatus.PUBLISHED })
      .andWhere('item.publishedAt <= :now', { now })
      .andWhere('(item.expiresAt IS NULL OR item.expiresAt > :now)', { now })
      .getMany();

    const venueIds = [
      ...new Set(
        candidates
          .map((i) => i.venueId)
          .filter((id): id is string => id !== null),
      ),
    ];
    const eligibleVenues = await this.venuesService.findEligibleByIds(venueIds);
    const venueById = new Map(eligibleVenues.map((v) => [v.id, v]));

    const eligible = candidates.filter(
      (item) => item.venueId === null || venueById.has(item.venueId),
    );

    const today = abidjanToday();
    const ranked = rankFeedItems(eligible, today, now.getTime()).slice(
      offset,
      offset + limit,
    );

    return ranked.map((item) => ({
      id: item.id,
      type: item.type,
      venue: item.venueId ? toVenueSummary(venueById.get(item.venueId)!) : null,
      startsAt: item.startsAt,
      expiresAt: item.expiresAt,
      publishedAt: item.publishedAt,
      payload: item.payload,
    }));
  }

  /**
   * Called by `GoingService` when a mark crosses a going-count threshold
   * (ticket 08 integration). Idempotent per `(venueNight, threshold)` — a
   * cancel-and-remark past the same threshold does not duplicate the item.
   */
  async emitGoingMilestoneIfNew(
    venueId: string,
    venueNightId: string,
    venueNightDate: string,
    threshold: number,
  ): Promise<boolean> {
    const existing = await this.feedItemRepository
      .createQueryBuilder('item')
      .where('item.type = :type', { type: FeedItemType.GOING_MILESTONE })
      .andWhere('item.venueNightId = :venueNightId', { venueNightId })
      .andWhere("(item.payload ->> 'threshold')::int = :threshold", {
        threshold,
      })
      .getOne();
    if (existing) return false;

    const item = this.feedItemRepository.create({
      type: FeedItemType.GOING_MILESTONE,
      venueId,
      venueNightId,
      createdByUserId: null,
      origin: FeedItemOrigin.FOUNDER,
      assisted: false,
      startsAt: null,
      expiresAt: morningAfter(venueNightDate),
      publishedAt: new Date(),
      status: FeedItemStatus.PUBLISHED,
      payload: { threshold },
    });
    await this.feedItemRepository.save(item);
    return true;
  }

  private async findOrThrow(id: string): Promise<FeedItem> {
    const item = await this.feedItemRepository.findOne({ where: { id } });
    if (!item) {
      throw new FeedItemNotFoundError(id);
    }
    return item;
  }
}

/** 06:00 Abidjan the day after `dateISO` ('YYYY-MM-DD') — Abidjan is UTC+0. */
function morningAfter(dateISO: string): Date {
  const next = new Date(`${dateISO}T00:00:00Z`);
  next.setUTCDate(next.getUTCDate() + 1);
  next.setUTCHours(6, 0, 0, 0);
  return next;
}

function toVenueSummary(venue: {
  id: string;
  name: string;
  venueType: VenueType;
}): { id: string; name: string; venueType: VenueType } {
  return { id: venue.id, name: venue.name, venueType: venue.venueType };
}
