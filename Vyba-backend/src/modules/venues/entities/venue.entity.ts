import { Entity, Column } from 'typeorm';
import { BaseEntity } from '@common/database/base.entity';

export enum VenueType {
  CLUB = 'CLUB',
  BAR = 'BAR',
  LOUNGE = 'LOUNGE',
  MAQUIS = 'MAQUIS',
}

export enum VenueValidationStatus {
  ONBOARDING = 'ONBOARDING',
  ACTIVE = 'ACTIVE',
  PAUSED = 'PAUSED',
}

/**
 * Durable venue facts only — identity, location, type, ownership,
 * launch-area membership. Night-scoped state (live, headline, going count)
 * lives on `VenueNight`, never here (ADR-0001) — do not add it.
 */
@Entity('venues')
export class Venue extends BaseEntity {
  @Column({ default: true })
  isActive: boolean;

  @Column()
  name: string;

  @Column({ type: 'text', nullable: true })
  description: string | null;

  @Column({ type: 'varchar', nullable: true })
  address: string | null;

  @Column({ type: 'double precision' })
  latitude: number;

  @Column({ type: 'double precision' })
  longitude: number;

  @Column({ type: 'enum', enum: VenueType, enumName: 'venue_type_enum' })
  venueType: VenueType;

  @Column({ type: 'int', default: 1 })
  priceLevel: number;

  /** Ordered list of stored image refs; upload/reorder mechanics belong to the `media` unit. */
  @Column({ type: 'jsonb', default: () => "'[]'" })
  photos: string[];

  /** Bound venue-owner account, nullable until provisioned. */
  @Column({ type: 'uuid', nullable: true })
  ownerUserId: string | null;

  @Column({
    type: 'enum',
    enum: VenueValidationStatus,
    enumName: 'venue_validation_status_enum',
    default: VenueValidationStatus.ONBOARDING,
  })
  validationStatus: VenueValidationStatus;

  /** Derived from [latitude]/[longitude] via `pointInLaunchArea`; recomputed on coordinate change. */
  @Column({ default: false })
  inLaunchArea: boolean;
}
