import { Entity, Column } from 'typeorm';
import { BaseEntity } from '@common/database/base.entity';

/**
 * Email+password credential for a `User` with role ADMIN — the one exemption
 * ADR-0003 carves out for the internal dashboard (not an end-user surface).
 * Deliberately not columns on `User` itself: keeps that entity's "phone+OTP,
 * no email, no password" invariant true for every client/venue-owner row.
 */
@Entity('admin_credentials')
export class AdminCredential extends BaseEntity {
  @Column({ type: 'uuid', unique: true })
  userId: string;

  @Column({ unique: true })
  email: string;

  @Column()
  passwordHash: string;
}
