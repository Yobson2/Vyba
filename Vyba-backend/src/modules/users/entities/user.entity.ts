import { Entity, Column } from 'typeorm';
import { BaseEntity } from '@common/database/base.entity';
import { UserRole, DEFAULT_ROLE } from '@common/constants/roles.constant';

/**
 * The person behind a phone number.
 *
 * Identity is the phone number (E.164) — OTP verification is the only way in
 * (ADR-0003). No email, no password. Name fields are optional. The acquisition
 * snapshot columns are nullable placeholders populated later by the
 * `attribution` unit.
 */
@Entity('users')
export class User extends BaseEntity {
  @Column({ unique: true, length: 20 })
  phone: string;

  @Column({ type: 'varchar', nullable: true })
  firstName: string | null;

  @Column({ type: 'varchar', nullable: true })
  lastName: string | null;

  @Column({
    type: 'enum',
    enum: UserRole,
    default: DEFAULT_ROLE,
    enumName: 'user_role_enum',
  })
  role: UserRole;

  @Column({ default: true })
  isActive: boolean;

  /** Set the first time the user confirms they are 18 or older. */
  @Column({ type: 'timestamptz', nullable: true })
  ageConfirmedAt: Date | null;

  // ─── Acquisition snapshot (first-touch; ticket 11 / spec 07) ──
  /** The `src` of the first landing matched at signup: 'qr' | 'promoter' | 'social' | 'organic'. */
  @Column({ type: 'varchar', nullable: true })
  acquisitionSource: string | null;

  /** Unused placeholder from an earlier ticket — spec 07 has no "medium" concept. */
  @Column({ type: 'varchar', nullable: true })
  acquisitionMedium: string | null;

  @Column({ type: 'varchar', nullable: true })
  acquisitionCampaign: string | null;

  @Column({ type: 'uuid', nullable: true })
  acquisitionVenueId: string | null;

  @Column({ type: 'uuid', nullable: true })
  acquisitionPromoterId: string | null;

  /** 'zone_4' | 'other' | null — where this user came FROM. Never conflate with `activeZone`. */
  @Column({ type: 'varchar', nullable: true })
  acquisitionZone: string | null;

  /** The matched first-touch `LandingEvent.createdAt`, not this snapshot's write time. */
  @Column({ type: 'timestamptz', nullable: true })
  firstLandingAt: Date | null;

  /** When this acquisition snapshot was written (~ signup time). */
  @Column({ type: 'timestamptz', nullable: true })
  acquisitionCapturedAt: Date | null;

  /**
   * 'zone_4' | null — whether this user ENGAGES with Zone 4 (a meaningful
   * action involving a launch-area venue). Never conflate with
   * `acquisitionZone` (where they came from) — spec 07 invariant.
   */
  @Column({ type: 'varchar', nullable: true })
  activeZone: string | null;

  /** Updated alongside `activeZone` on every meaningful action — drives the rolling-7-day WAU query. */
  @Column({ type: 'timestamptz', nullable: true })
  lastActiveAt: Date | null;
}
