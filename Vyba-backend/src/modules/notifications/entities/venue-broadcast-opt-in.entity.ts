import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '@common/database/base.entity';

/**
 * A client's opt-in to a specific venue's broadcasts — deliberately
 * independent of `Follow` (spec 08 / ticket 17): following doesn't imply
 * wanting pushes, and opting in doesn't imply following.
 */
@Entity('venue_broadcast_opt_ins')
@Index('UQ_venue_broadcast_opt_ins_user_venue', ['userId', 'venueId'], {
  unique: true,
})
export class VenueBroadcastOptIn extends BaseEntity {
  @Column({ type: 'uuid' })
  userId: string;

  @Column({ type: 'uuid' })
  venueId: string;
}
