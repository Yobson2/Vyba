import { Entity, Column } from 'typeorm';
import { BaseEntity } from '@common/database/base.entity';

/**
 * A soft "J'y vais" intent (ADR-0002) — not a reservation. An "active" mark
 * has `canceledAt IS NULL`; at most one active row per `(userId,
 * venueNightId)` (partial unique index, see the migration). Re-marking after
 * a cancel reactivates this same row rather than inserting a new one.
 */
@Entity('goings')
export class Going extends BaseEntity {
  @Column({ type: 'uuid' })
  userId: string;

  /** Denormalised for the reminder-recipients query and rate limiting — set once, immutable. */
  @Column({ type: 'uuid' })
  venueId: string;

  @Column({ type: 'uuid' })
  venueNightId: string;

  @Column({ type: 'int', default: 1 })
  partySize: number;

  @Column({ default: false })
  identityPublic: boolean;

  @Column({ type: 'timestamptz', nullable: true })
  canceledAt: Date | null;
}
