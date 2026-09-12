import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '@common/database/base.entity';

/**
 * One row per user, created lazily on first toggle — a missing row means
 * "defaults" (both on), matching `NotificationsService`'s read path. Never
 * conflate with a per-venue `VenueBroadcastOptIn` (ticket 17) — broadcast
 * opt-in is deliberately decoupled from these two standing toggles.
 */
@Entity('notification_preferences')
@Index('UQ_notification_preferences_user', ['userId'], { unique: true })
export class NotificationPreference extends BaseEntity {
  @Column({ type: 'uuid' })
  userId: string;

  @Column({ default: true })
  weekendDigest: boolean;

  @Column({ default: true })
  goingReminder: boolean;
}
