import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '@common/database/base.entity';

/**
 * One venue on one calendar night — every piece of night-scoped state lives
 * here, never on `Venue` (ADR-0001). Created lazily via get-or-create on the
 * first write for a `(venue, date)` pair; yesterday's row simply isn't
 * today's — there is no reset job.
 */
@Entity('venue_nights')
@Index('UQ_venue_nights_venue_date', ['venueId', 'date'], { unique: true })
export class VenueNight extends BaseEntity {
  @Column({ type: 'uuid' })
  venueId: string;

  /** Calendar date in Africa/Abidjan local time, 'YYYY-MM-DD'. See abidjan-time.config.ts. */
  @Column({ type: 'date' })
  date: string;

  @Column({ default: false })
  isLive: boolean;

  /** Set the first time this night is toggled live; not cleared when toggled off. */
  @Column({ type: 'timestamptz', nullable: true })
  liveSince: Date | null;

  @Column({ type: 'uuid', nullable: true })
  liveSetBy: string | null;

  @Column({ type: 'text', nullable: true })
  headline: string | null;

  @Column({ type: 'varchar', nullable: true })
  djName: string | null;

  /** Denormalised aggregate maintained by the `going` unit; exposed here for cheap reads. */
  @Column({ type: 'int', default: 0 })
  goingCount: number;

  @Column({ type: 'int', default: 0 })
  viewCount: number;

  @Column({ type: 'int', default: 0 })
  postCount: number;
}
