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

  // ─── Acquisition snapshot (first-touch; populated by `attribution` later) ──
  @Column({ type: 'varchar', nullable: true })
  acquisitionSource: string | null;

  @Column({ type: 'varchar', nullable: true })
  acquisitionMedium: string | null;

  @Column({ type: 'varchar', nullable: true })
  acquisitionCampaign: string | null;

  @Column({ type: 'varchar', nullable: true })
  acquisitionZone: string | null;

  @Column({ type: 'timestamptz', nullable: true })
  acquisitionCapturedAt: Date | null;
}
