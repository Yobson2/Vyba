import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { IsNull, Repository } from 'typeorm';
import { Follow } from './entities/follow.entity';
import { VenuesService } from '@modules/venues/venues.service';
import { VenueType } from '@modules/venues/entities/venue.entity';
import { AnalyticsService } from '@modules/analytics/analytics.service';

export interface FollowedVenueSummary {
  id: string;
  name: string;
  venueType: VenueType;
  photos: string[];
}

@Injectable()
export class FollowsService {
  constructor(
    @InjectRepository(Follow)
    private readonly followRepository: Repository<Follow>,
    private readonly venuesService: VenuesService,
    private readonly analyticsService: AnalyticsService,
  ) {}

  /** Idempotent: following an already-followed venue is a no-op, not an error. */
  async follow(userId: string, venueId: string): Promise<void> {
    await this.venuesService.findActiveOrThrow(venueId);

    const existing = await this.followRepository.findOne({
      where: { userId, venueId },
    });

    if (existing) {
      if (existing.unfollowedAt !== null) {
        existing.unfollowedAt = null;
        await this.followRepository.save(existing);
        await this.trackFollowChange('venue_followed', userId, venueId);
      }
      return;
    }

    const follow = this.followRepository.create({
      userId,
      venueId,
      unfollowedAt: null,
    });
    await this.followRepository.save(follow);
    await this.trackFollowChange('venue_followed', userId, venueId);
  }

  /** Idempotent: unfollowing when not following is a no-op, not an error. */
  async unfollow(userId: string, venueId: string): Promise<void> {
    const active = await this.followRepository.findOne({
      where: { userId, venueId, unfollowedAt: IsNull() },
    });
    if (!active) return;

    active.unfollowedAt = new Date();
    await this.followRepository.save(active);
    await this.trackFollowChange('venue_unfollowed', userId, venueId);
  }

  private async trackFollowChange(
    event: 'venue_followed' | 'venue_unfollowed',
    userId: string,
    venueId: string,
  ): Promise<void> {
    await this.analyticsService.track({
      event,
      userId,
      properties: { venue_id: venueId },
    });
  }

  async isFollowing(userId: string, venueId: string): Promise<boolean> {
    const active = await this.followRepository.findOne({
      where: { userId, venueId, unfollowedAt: IsNull() },
    });
    return active !== null;
  }

  /** Internal — for the feed ranking's per-request follow-lift (ticket 10). */
  async followedVenueIds(userId: string): Promise<Set<string>> {
    const rows = await this.followRepository.find({
      where: { userId, unfollowedAt: IsNull() },
      select: ['venueId'],
    });
    return new Set(rows.map((r) => r.venueId));
  }

  /** "Mes lieux suivis" — followed venues with enough detail to render a list. */
  async getMyFollowedVenues(userId: string): Promise<FollowedVenueSummary[]> {
    const rows = await this.followRepository.find({
      where: { userId, unfollowedAt: IsNull() },
      order: { createdAt: 'DESC' },
    });
    if (rows.length === 0) return [];

    const venues = await this.venuesService.findByIds(
      rows.map((r) => r.venueId),
    );
    const venueById = new Map(venues.map((v) => [v.id, v]));

    return rows
      .map((r) => venueById.get(r.venueId))
      .filter((v): v is NonNullable<typeof v> => v !== undefined)
      .map((v) => ({
        id: v.id,
        name: v.name,
        venueType: v.venueType,
        photos: v.photos,
      }));
  }

  /** For the venue detail payload (ticket 10) — count, never identities. */
  async getFollowerCount(venueId: string): Promise<number> {
    return this.followRepository.count({
      where: { venueId, unfollowedAt: IsNull() },
    });
  }

  /** Batch form of `getFollowerCount`, for the feed's venue-summary reads if ever needed. */
  async getFollowerCounts(venueIds: string[]): Promise<Map<string, number>> {
    if (venueIds.length === 0) return new Map();
    const rows = await this.followRepository
      .createQueryBuilder('follow')
      .select('follow.venueId', 'venueId')
      .addSelect('COUNT(*)', 'count')
      .where('follow.venueId IN (:...venueIds)', { venueIds })
      .andWhere('follow.unfollowedAt IS NULL')
      .groupBy('follow.venueId')
      .getRawMany<{ venueId: string; count: string }>();
    return new Map(rows.map((r) => [r.venueId, parseInt(r.count, 10)]));
  }
}
