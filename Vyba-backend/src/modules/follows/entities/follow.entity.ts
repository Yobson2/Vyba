import { Entity, Column } from 'typeorm';
import { BaseEntity } from '@common/database/base.entity';

/**
 * A client's follow of a venue (spec 05). An "active" follow has
 * `unfollowedAt IS NULL`; at most one active row per `(userId, venueId)`
 * (partial unique index, see the migration). Re-following after an unfollow
 * reactivates this same row rather than inserting a new one, so the
 * unfollow event stays in the trail (platform-operator story: follow growth
 * is measurable).
 */
@Entity('follows')
export class Follow extends BaseEntity {
  @Column({ type: 'uuid' })
  userId: string;

  @Column({ type: 'uuid' })
  venueId: string;

  @Column({ type: 'timestamptz', nullable: true })
  unfollowedAt: Date | null;
}
