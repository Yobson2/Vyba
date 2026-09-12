import { Entity, Column } from 'typeorm';
import { BaseEntity } from '@common/database/base.entity';
import { UserRole } from '@common/constants/roles.constant';

export enum MediaContextType {
  VENUE_PROFILE = 'venue_profile',
  VENUE_POST = 'venue_post',
  VENUE_NIGHT_USER = 'venue_night_user',
}

export enum MediaAssetStatus {
  ACTIVE = 'active',
  HIDDEN = 'hidden',
  DELETED = 'deleted',
}

/**
 * The trusted/community split (spec 06): `venue_profile`/`venue_post` assets
 * are usable immediately wherever the owning module references them;
 * `venue_night_user` assets show on the venue/night view immediately but
 * only enter the main feed once a team member promotes them (`feedPromoted`
 * flips true and a `photo` `FeedItem` is created via the `feed` module).
 */
@Entity('media_assets')
export class MediaAsset extends BaseEntity {
  @Column({ type: 'varchar' })
  storageKey: string;

  @Column({ type: 'varchar' })
  url: string;

  /** Resized-for-feed/list rendition; same key as `url` until a real image pipeline lands (spec: mechanism is an implementation detail). */
  @Column({ type: 'varchar' })
  displayUrl: string;

  @Column({ type: 'varchar' })
  thumbnailUrl: string;

  @Column({ type: 'uuid' })
  uploadedByUserId: string;

  @Column({
    type: 'enum',
    enum: UserRole,
    enumName: 'media_uploader_role_enum',
  })
  uploadedByRole: UserRole;

  @Column({
    type: 'enum',
    enum: MediaContextType,
    enumName: 'media_context_type_enum',
  })
  contextType: MediaContextType;

  @Column({ type: 'uuid', nullable: true })
  venueId: string | null;

  @Column({ type: 'uuid', nullable: true })
  venueNightId: string | null;

  @Column({ type: 'uuid', nullable: true })
  feedItemId: string | null;

  @Column({
    type: 'enum',
    enum: MediaAssetStatus,
    enumName: 'media_asset_status_enum',
    default: MediaAssetStatus.ACTIVE,
  })
  status: MediaAssetStatus;

  @Column({ default: false })
  feedPromoted: boolean;
}
