import { Entity, Column } from 'typeorm';
import { BaseEntity } from '@common/database/base.entity';

export enum NotificationType {
  WEEKEND_DIGEST = 'weekend_digest',
  GOING_REMINDER = 'going_reminder',
  /** Ticket 17's territory — the enum exists now for forward schema compatibility, this unit never writes it. */
  VENUE_BROADCAST = 'venue_broadcast',
}

export enum NotificationResult {
  DELIVERED = 'delivered',
  NO_TOKEN = 'no_token',
  FAILED = 'failed',
}

/** The delivery log (spec 08) — every send attempt, so frequency caps and analysis work. */
@Entity('sent_notifications')
export class SentNotification extends BaseEntity {
  @Column({
    type: 'enum',
    enum: NotificationType,
    enumName: 'notification_type_enum',
  })
  type: NotificationType;

  @Column({ type: 'uuid' })
  userId: string;

  @Column({ type: 'uuid', nullable: true })
  venueId: string | null;

  @Column({ type: 'timestamptz' })
  sentAt: Date;

  @Column({
    type: 'enum',
    enum: NotificationResult,
    enumName: 'notification_result_enum',
  })
  result: NotificationResult;
}
