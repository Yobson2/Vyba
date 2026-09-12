import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '@common/database/base.entity';

/**
 * One row per registered FCM token — multiple devices per user are
 * expected (spec 08). `token` is the natural identity: re-registering the
 * same token (app relaunch) updates this row rather than duplicating it.
 */
@Entity('device_tokens')
@Index('UQ_device_tokens_token', ['token'], { unique: true })
export class DeviceToken extends BaseEntity {
  @Column({ type: 'uuid' })
  userId: string;

  @Column({ type: 'varchar' })
  token: string;

  /** Android-only in v1 (MVP spec §15) — kept as a column, not an enum, for forward compatibility. */
  @Column({ type: 'varchar', default: 'android' })
  platform: string;
}
