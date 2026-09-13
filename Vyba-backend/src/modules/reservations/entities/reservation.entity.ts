import { Entity, Column } from 'typeorm';
import { BaseEntity } from '@common/database/base.entity';

export enum ReservationStatus {
  PENDING = 'PENDING',
  CONFIRMED = 'CONFIRMED',
  REJECTED = 'REJECTED',
  CANCELED = 'CANCELED',
}

/**
 * A real table/seat request (ADR-0006) — opt-in per venue
 * (`Venue.reservationsEnabled`), unlike the unconditional "J'y vais"
 * (`Going`, ADR-0002). Mirrors `Going`'s shape closely: at most one row with
 * `status IN ('PENDING','CONFIRMED')` per `(userId, venueNightId)` (partial
 * unique index, see the migration) — re-requesting after a
 * reject/cancel inserts a fresh row rather than reusing the old one, since
 * the owner's decision on a past request is a durable record.
 */
@Entity('reservations')
export class Reservation extends BaseEntity {
  @Column({ type: 'uuid' })
  userId: string;

  /** Denormalised for the owner-facing list query — set once, immutable. */
  @Column({ type: 'uuid' })
  venueId: string;

  @Column({ type: 'uuid' })
  venueNightId: string;

  @Column({ type: 'int', default: 1 })
  partySize: number;

  @Column({ type: 'text', nullable: true })
  note: string | null;

  @Column({
    type: 'enum',
    enum: ReservationStatus,
    enumName: 'reservation_status_enum',
    default: ReservationStatus.PENDING,
  })
  status: ReservationStatus;

  @Column({ type: 'timestamptz', nullable: true })
  respondedAt: Date | null;

  /** The owner who confirmed/rejected — null while `PENDING`. */
  @Column({ type: 'uuid', nullable: true })
  respondedBy: string | null;
}
