import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '@common/database/base.entity';

/**
 * A raw, pre-signup landing (QR scan, promoter link, social campaign open —
 * spec 07). No user id yet — matched to a `User` at signup via `clientId`.
 * Retained indefinitely as the record of truth; the `User` acquisition
 * snapshot is a convenience derived from this, never the other way round.
 */
@Entity('landing_events')
export class LandingEvent extends BaseEntity {
  /** 'qr' | 'promoter' | 'social' | 'organic'. */
  @Column({ type: 'varchar' })
  src: string;

  @Column({ type: 'uuid', nullable: true })
  venueId: string | null;

  /** A tagged User id — promoters are normal accounts, no separate entity (spec 07). */
  @Column({ type: 'uuid', nullable: true })
  promoterId: string | null;

  @Column({ type: 'varchar', nullable: true })
  campaignId: string | null;

  /** 'web' | 'app'. */
  @Column({ type: 'varchar' })
  surface: string;

  /** Anonymous per-install/per-browser id, matched to a signup later. */
  @Index()
  @Column({ type: 'varchar' })
  clientId: string;
}
