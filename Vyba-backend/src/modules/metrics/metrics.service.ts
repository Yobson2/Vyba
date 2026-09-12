import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { In, MoreThanOrEqual, Repository } from 'typeorm';
import {
  FeedItem,
  FeedItemOrigin,
  FeedItemType,
} from '@modules/feed/entities/feed-item.entity';
import { VenueNight } from '@modules/venue-nights/entities/venue-night.entity';
import {
  Venue,
  VenueType,
  VenueValidationStatus,
} from '@modules/venues/entities/venue.entity';
import { UsersService } from '@modules/users/users.service';
import { abidjanToday } from '@common/config/abidjan-time.config';

const ZONE_4 = 'zone_4';
const WEEK_MS = 7 * 24 * 60 * 60 * 1000;
/** "Posting" for the organic-supply gate and the monitor's quiet flag — deliberate content only, not system-derived items. */
const POST_TYPES = [
  FeedItemType.PROMO,
  FeedItemType.PHOTO,
  FeedItemType.EVENT,
  FeedItemType.VENUE_UPDATE,
];
/** A "small threshold" (spec 18) below which low going activity contributes to a venue reading as quiet. */
const QUIET_GOING_THRESHOLD = 3;
const RETENTION_WINDOWS_WEEKS = [1, 2, 4] as const;

export interface OrganicVsAssisted {
  organic: number;
  assisted: number;
}

export interface GoingPerNight {
  date: string;
  total: number;
}

export interface RetentionFigure {
  cohortSize: number;
  retained: number;
  /** `null` when the cohort is empty — never render a 0% for "no data yet". */
  rate: number | null;
}

export interface RetentionReport {
  overall: Record<`week${1 | 2 | 4}`, RetentionFigure>;
  bySource: Record<string, Record<`week${1 | 2 | 4}`, RetentionFigure>>;
}

export interface OrganicPostingRollup {
  organicVenueCount: number;
  totalVenueCount: number;
}

export interface RecentFeedItemSummary {
  id: string;
  type: FeedItemType;
  payload: Record<string, unknown> | null;
  publishedAt: Date;
}

export interface MonitorVenueSummary {
  venueId: string;
  venueName: string;
  venueType: VenueType;
  isLive: boolean;
  liveSince: Date | null;
  goingCount: number;
  postCountToday: number;
  recentFeedItems: RecentFeedItemSummary[];
  /** Not live AND no post today AND going count below the threshold (spec 18). */
  quiet: boolean;
}

/**
 * First-party aggregate queries backing the §23 validation gates (ticket
 * 11 / spec 07) — read `FeedItem` / `VenueNight` / `Venue` / `User`
 * directly, never PostHog. No HTTP surface yet: ticket 18 (dashboard
 * monitoring/metrics) wraps these in `ADMIN`-only endpoints and a UI.
 */
@Injectable()
export class MetricsService {
  constructor(
    @InjectRepository(FeedItem)
    private readonly feedItemRepository: Repository<FeedItem>,
    @InjectRepository(VenueNight)
    private readonly venueNightRepository: Repository<VenueNight>,
    @InjectRepository(Venue)
    private readonly venueRepository: Repository<Venue>,
    private readonly usersService: UsersService,
  ) {}

  /** Zone 4 WAU: `activeZone = zone_4` AND a meaningful action within the rolling 7 days. */
  async getZone4WeeklyActiveUsers(): Promise<number> {
    return this.usersService.countActiveInWindow(ZONE_4, Date.now() - WEEK_MS);
  }

  /**
   * Organic (`origin = venue`) vs assisted (`origin = founder_assisted`)
   * content this week — the central "≥15 of ~30 venues posting organically"
   * gate (MVP spec §23.3). Content types only (not editorial /
   * going_milestone / live_tonight, which have no organic/assisted
   * meaning). `venueId` narrows to one venue for a per-venue breakdown.
   */
  async getOrganicVsAssistedThisWeek(
    venueId?: string,
  ): Promise<OrganicVsAssisted> {
    const since = new Date(Date.now() - WEEK_MS);
    const qb = this.feedItemRepository
      .createQueryBuilder('item')
      .select('item.origin', 'origin')
      .addSelect('COUNT(*)', 'count')
      .where('item.type = :type', { type: FeedItemType.PROMO })
      .andWhere('item.publishedAt >= :since', { since })
      .groupBy('item.origin');
    if (venueId) {
      qb.andWhere('item.venueId = :venueId', { venueId });
    }

    const rows = await qb.getRawMany<{
      origin: FeedItemOrigin;
      count: string;
    }>();
    const byOrigin = new Map(
      rows.map((r) => [r.origin, parseInt(r.count, 10)]),
    );

    return {
      organic: byOrigin.get(FeedItemOrigin.VENUE) ?? 0,
      assisted: byOrigin.get(FeedItemOrigin.FOUNDER_ASSISTED) ?? 0,
    };
  }

  /** Going activity per night over the last `weeks` weeks (default ~8), oldest first. */
  async getGoingPerNight(weeks = 8): Promise<GoingPerNight[]> {
    const since = new Date(Date.now() - weeks * 7 * 24 * 60 * 60 * 1000);
    const sinceDate = since.toISOString().slice(0, 10);

    const rows = await this.venueNightRepository
      .createQueryBuilder('night')
      .select('night.date', 'date')
      .addSelect('SUM(night.goingCount)', 'total')
      .where('night.date >= :sinceDate', { sinceDate })
      .groupBy('night.date')
      .orderBy('night.date', 'ASC')
      .getRawMany<{ date: string; total: string }>();

    return rows.map((r) => ({ date: r.date, total: parseInt(r.total, 10) }));
  }

  /** Active venue count — launch-market venues the team has approved. */
  async getActiveVenueCount(): Promise<number> {
    return this.venueRepository.count({
      where: { isActive: true, validationStatus: VenueValidationStatus.ACTIVE },
    });
  }

  /** Content activity: all published feed items in the last week, by type. */
  async getContentActivityThisWeek(): Promise<Record<string, number>> {
    const since = new Date(Date.now() - WEEK_MS);
    const rows = await this.feedItemRepository
      .createQueryBuilder('item')
      .select('item.type', 'type')
      .addSelect('COUNT(*)', 'count')
      .where('item.publishedAt >= :since', { since })
      .groupBy('item.type')
      .getRawMany<{ type: string; count: string }>();

    return Object.fromEntries(rows.map((r) => [r.type, parseInt(r.count, 10)]));
  }

  /**
   * Week-1/2/4 retention (spec 23.2/23.3), overall and by `acquisitionSource`
   * — "organic" labels a null source (no landing matched at signup). Each
   * user is compared against their own signup date, not a shared calendar
   * week, so this is computed in memory rather than as one SQL aggregate;
   * ~500 users at validation scale makes that the simpler, equally correct
   * choice. A cohort not yet old enough to reach a window is excluded from
   * it (never rounded into a false 0%).
   */
  async getRetention(): Promise<RetentionReport> {
    const users = await this.usersService.findRetentionCohortData();
    const now = Date.now();

    const overall = this.computeRetentionFigures(users, now);
    const bySourceUsers = new Map<string, typeof users>();
    for (const user of users) {
      const source = user.acquisitionSource ?? 'organic';
      const list = bySourceUsers.get(source) ?? [];
      list.push(user);
      bySourceUsers.set(source, list);
    }
    const bySource: RetentionReport['bySource'] = {};
    for (const [source, sourceUsers] of bySourceUsers) {
      bySource[source] = this.computeRetentionFigures(sourceUsers, now);
    }

    return { overall, bySource };
  }

  private computeRetentionFigures(
    users: { createdAt: Date; lastActiveAt: Date | null }[],
    now: number,
  ): RetentionReport['overall'] {
    const figures = {} as RetentionReport['overall'];
    for (const weeks of RETENTION_WINDOWS_WEEKS) {
      const windowMs = weeks * WEEK_MS;
      const eligible = users.filter(
        (u) => now - u.createdAt.getTime() >= windowMs,
      );
      const retained = eligible.filter(
        (u) =>
          u.lastActiveAt !== null &&
          u.lastActiveAt.getTime() - u.createdAt.getTime() >= windowMs,
      );
      const key = `week${weeks}` as keyof RetentionReport['overall'];
      figures[key] = {
        cohortSize: eligible.length,
        retained: retained.length,
        rate: eligible.length > 0 ? retained.length / eligible.length : null,
      };
    }
    return figures;
  }

  /**
   * "N of ~30 venues posting organically this week" (spec 23.3's central
   * gate) — same `type`/`origin` definition as `getOrganicVsAssistedThisWeek`,
   * rolled up to a venue count rather than a post count.
   */
  async getOrganicPostingRollup(): Promise<OrganicPostingRollup> {
    const since = new Date(Date.now() - WEEK_MS);
    const totalVenueCount = await this.getActiveVenueCount();

    const rows = await this.feedItemRepository
      .createQueryBuilder('item')
      .select('DISTINCT item.venueId', 'venueId')
      .where('item.type = :type', { type: FeedItemType.PROMO })
      .andWhere('item.origin = :origin', { origin: FeedItemOrigin.VENUE })
      .andWhere('item.publishedAt >= :since', { since })
      .getRawMany<{ venueId: string }>();

    return { organicVenueCount: rows.length, totalVenueCount };
  }

  /**
   * Tonight's per-venue monitor (spec 18) — live status, going count,
   * today's posts, and the derived "quiet" flag. `VenueNight.postCount` is
   * never maintained anywhere in the codebase, so today's post count is
   * computed live from `FeedItem` rather than trusted from that column.
   */
  async getTonightMonitor(): Promise<MonitorVenueSummary[]> {
    const venues = await this.venueRepository.find({
      where: { isActive: true, validationStatus: VenueValidationStatus.ACTIVE },
    });
    if (venues.length === 0) return [];
    const venueIds = venues.map((v) => v.id);

    const today = abidjanToday();
    const nights = await this.venueNightRepository.find({
      where: { venueId: In(venueIds), date: today },
    });
    const nightByVenue = new Map(nights.map((n) => [n.venueId, n]));

    const todayStart = new Date(`${today}T00:00:00Z`);
    const items = await this.feedItemRepository.find({
      where: {
        venueId: In(venueIds),
        type: In(POST_TYPES),
        publishedAt: MoreThanOrEqual(todayStart),
      },
      order: { publishedAt: 'DESC' },
    });
    const itemsByVenue = new Map<string, FeedItem[]>();
    for (const item of items) {
      const list = itemsByVenue.get(item.venueId!) ?? [];
      list.push(item);
      itemsByVenue.set(item.venueId!, list);
    }

    return venues.map((venue) => {
      const night = nightByVenue.get(venue.id);
      const venueItems = itemsByVenue.get(venue.id) ?? [];
      const isLive = night?.isLive ?? false;
      const goingCount = night?.goingCount ?? 0;
      const postCountToday = venueItems.length;

      return {
        venueId: venue.id,
        venueName: venue.name,
        venueType: venue.venueType,
        isLive,
        liveSince: night?.liveSince ?? null,
        goingCount,
        postCountToday,
        recentFeedItems: venueItems.slice(0, 3).map((i) => ({
          id: i.id,
          type: i.type,
          payload: i.payload,
          publishedAt: i.publishedAt,
        })),
        quiet:
          !isLive && postCountToday === 0 && goingCount < QUIET_GOING_THRESHOLD,
      };
    });
  }
}
