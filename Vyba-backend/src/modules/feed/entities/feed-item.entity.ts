import { Entity, Column } from 'typeorm';
import { BaseEntity } from '@common/database/base.entity';

export enum FeedItemType {
  VENUE_UPDATE = 'VENUE_UPDATE',
  LIVE_TONIGHT = 'LIVE_TONIGHT',
  PROMO = 'PROMO',
  EVENT = 'EVENT',
  EDITORIAL = 'EDITORIAL',
  GOING_MILESTONE = 'GOING_MILESTONE',
  PHOTO = 'PHOTO',
}

export enum FeedItemOrigin {
  VENUE = 'VENUE',
  FOUNDER = 'FOUNDER',
  FOUNDER_ASSISTED = 'FOUNDER_ASSISTED',
  USER = 'USER',
}

export enum FeedItemStatus {
  DRAFT = 'DRAFT',
  PUBLISHED = 'PUBLISHED',
  HIDDEN = 'HIDDEN',
  EXPIRED = 'EXPIRED',
}

/**
 * Polymorphic feed entry (spec 03). Only `LIVE_TONIGHT` and `EDITORIAL` have
 * creation logic in ticket 07 — the rest of the type enum exists for
 * forward schema compatibility with later units (promo, event, going,
 * photo), not because this unit writes them.
 *
 * `origin`/`assisted` are never client-supplied — see `FeedItemsService`.
 */
@Entity('feed_items')
export class FeedItem extends BaseEntity {
  @Column({ type: 'enum', enum: FeedItemType, enumName: 'feed_item_type_enum' })
  type: FeedItemType;

  /** Null for area-wide items (editorial). */
  @Column({ type: 'uuid', nullable: true })
  venueId: string | null;

  /** Set for tonight-scoped items (live_tonight, going_milestone). */
  @Column({ type: 'uuid', nullable: true })
  venueNightId: string | null;

  @Column({ type: 'uuid', nullable: true })
  createdByUserId: string | null;

  @Column({
    type: 'enum',
    enum: FeedItemOrigin,
    enumName: 'feed_item_origin_enum',
  })
  origin: FeedItemOrigin;

  @Column({ default: false })
  assisted: boolean;

  /** Event/promo start, or the venue-night date for tonight-scoped items. */
  @Column({ type: 'timestamptz', nullable: true })
  startsAt: Date | null;

  /** Time-bound types get this computed on creation; the read filter is authoritative, not a cron. */
  @Column({ type: 'timestamptz', nullable: true })
  expiresAt: Date | null;

  @Column({ type: 'timestamptz' })
  publishedAt: Date;

  @Column({
    type: 'enum',
    enum: FeedItemStatus,
    enumName: 'feed_item_status_enum',
    default: FeedItemStatus.PUBLISHED,
  })
  status: FeedItemStatus;

  /** Type-specific fields (e.g. editorial: {title, body}). */
  @Column({ type: 'jsonb', nullable: true })
  payload: Record<string, unknown> | null;
}
