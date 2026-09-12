import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '@common/database/base.entity';

/**
 * The signup-time attribution record (spec 07) — one row per signup, tied
 * to the matched first-touch `LandingEvent`. Kept alongside (not instead
 * of) the `User` snapshot so multi-touch history survives even though the
 * snapshot only ever reflects first-touch.
 */
@Entity('acquisition_events')
export class AcquisitionEvent extends BaseEntity {
  @Index()
  @Column({ type: 'uuid' })
  userId: string;

  @Column({ type: 'varchar' })
  src: string;

  @Column({ type: 'uuid', nullable: true })
  venueId: string | null;

  @Column({ type: 'uuid', nullable: true })
  promoterId: string | null;

  @Column({ type: 'varchar', nullable: true })
  campaignId: string | null;

  /** 'zone_4' | 'other' | null. */
  @Column({ type: 'varchar', nullable: true })
  zone: string | null;
}
