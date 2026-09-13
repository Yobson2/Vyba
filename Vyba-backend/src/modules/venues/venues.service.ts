import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { In, Repository } from 'typeorm';
import {
  Venue,
  VenueType,
  VenueValidationStatus,
} from './entities/venue.entity';
import { CreateVenueDto } from './dto/create-venue.dto';
import { UpdateVenueDto } from './dto/update-venue.dto';
import { BindVenueOwnerDto } from './dto/bind-venue-owner.dto';
import { SearchVenuesQueryDto } from './dto/search-venues-query.dto';
import {
  PaginationQueryDto,
  PaginatedResponseDto,
} from '@common/dto/pagination.dto';
import { VenueNotFoundError } from '@common/exceptions/venue.exceptions';
import { pointInLaunchArea } from '@common/config/launch-area.config';
import { UsersService } from '@modules/users/users.service';

export interface VenueOwnerSummary {
  id: string;
  phone: string;
  firstName: string | null;
  lastName: string | null;
}

export interface VenueWithOwner {
  id: string;
  createdAt: Date;
  updatedAt: Date;
  isActive: boolean;
  name: string;
  description: string | null;
  address: string | null;
  latitude: number;
  longitude: number;
  venueType: VenueType;
  priceLevel: number;
  photos: string[];
  ownerUserId: string | null;
  validationStatus: VenueValidationStatus;
  inLaunchArea: boolean;
  capacity: number | null;
  reservationsEnabled: boolean;
  owner: VenueOwnerSummary | null;
}

/** Public discovery read (ADR-0005) — no owner PII, no admin-only fields. */
export interface VenueDiscoverySummary {
  id: string;
  name: string;
  address: string | null;
  latitude: number;
  longitude: number;
  venueType: VenueType;
  priceLevel: number;
  photos: string[];
  /** km from the caller's position, when `lat`/`lng` were given; null otherwise. */
  distanceKm: number | null;
}

@Injectable()
export class VenuesService {
  constructor(
    @InjectRepository(Venue)
    private readonly venueRepository: Repository<Venue>,
    private readonly usersService: UsersService,
  ) {}

  async create(dto: CreateVenueDto): Promise<VenueWithOwner> {
    const venue = this.venueRepository.create({
      name: dto.name,
      description: dto.description ?? null,
      address: dto.address ?? null,
      latitude: dto.latitude,
      longitude: dto.longitude,
      venueType: dto.venueType,
      priceLevel: dto.priceLevel ?? 1,
      inLaunchArea: pointInLaunchArea(dto.latitude, dto.longitude),
      capacity: dto.capacity ?? null,
      reservationsEnabled: dto.reservationsEnabled ?? false,
    });
    const saved = await this.venueRepository.save(venue);
    return { ...saved, owner: null };
  }

  async findAll(
    query: PaginationQueryDto,
  ): Promise<PaginatedResponseDto<VenueWithOwner>> {
    const page = query.page ?? 1;
    const limit = query.limit ?? 10;

    const [venues, total] = await this.venueRepository.findAndCount({
      skip: (page - 1) * limit,
      take: limit,
      order: { createdAt: 'DESC' },
    });

    const withOwners = await this.attachOwners(venues);
    return new PaginatedResponseDto(withOwners, total, page, limit);
  }

  async findOne(id: string): Promise<VenueWithOwner> {
    const venue = await this.findVenueOrThrow(id);
    const [withOwner] = await this.attachOwners([venue]);
    return withOwner;
  }

  async update(id: string, dto: UpdateVenueDto): Promise<VenueWithOwner> {
    const venue = await this.findVenueOrThrow(id);
    // Not `Object.assign(venue, dto)`: with `useDefineForClassFields`, every
    // declared-but-unsent optional field on `dto` is its own `undefined`
    // property — Object.assign would copy that over and wipe it on the
    // in-memory `venue` returned to the caller (see the identical fix in
    // `UsersService.update`).
    if (dto.name !== undefined) venue.name = dto.name;
    if (dto.description !== undefined) venue.description = dto.description;
    if (dto.address !== undefined) venue.address = dto.address;
    if (dto.latitude !== undefined) venue.latitude = dto.latitude;
    if (dto.longitude !== undefined) venue.longitude = dto.longitude;
    if (dto.venueType !== undefined) venue.venueType = dto.venueType;
    if (dto.priceLevel !== undefined) venue.priceLevel = dto.priceLevel;
    if (dto.validationStatus !== undefined)
      venue.validationStatus = dto.validationStatus;
    if (dto.capacity !== undefined) venue.capacity = dto.capacity;
    if (dto.reservationsEnabled !== undefined)
      venue.reservationsEnabled = dto.reservationsEnabled;

    if (dto.latitude !== undefined || dto.longitude !== undefined) {
      venue.inLaunchArea = pointInLaunchArea(venue.latitude, venue.longitude);
    }
    const saved = await this.venueRepository.save(venue);
    const [withOwner] = await this.attachOwners([saved]);
    return withOwner;
  }

  async remove(id: string): Promise<void> {
    const venue = await this.findVenueOrThrow(id);
    venue.isActive = false;
    await this.venueRepository.save(venue);
  }

  /** Provisions (or reuses, on a re-bind) a VENUE_OWNER account by phone and binds it. */
  async bindOwner(id: string, dto: BindVenueOwnerDto): Promise<VenueWithOwner> {
    const venue = await this.findVenueOrThrow(id);
    const owner = await this.usersService.provisionOwner(
      dto.phone,
      dto.firstName,
      dto.lastName,
    );
    venue.ownerUserId = owner.id;
    const saved = await this.venueRepository.save(venue);
    return { ...saved, owner: toOwnerSummary(owner) };
  }

  async unbindOwner(id: string): Promise<VenueWithOwner> {
    const venue = await this.findVenueOrThrow(id);
    venue.ownerUserId = null;
    const saved = await this.venueRepository.save(venue);
    return { ...saved, owner: null };
  }

  /**
   * Batch eligibility check for client-facing reads (feed ranking):
   * active, not deactivated. Discovery is not geofenced (ADR-0005) — a
   * venue's location no longer excludes it. Silently drops ineligible ids
   * rather than throwing — callers filter a candidate set.
   */
  async findEligibleByIds(ids: string[]): Promise<Venue[]> {
    if (ids.length === 0) return [];
    return this.venueRepository.find({
      where: {
        id: In(ids),
        isActive: true,
        validationStatus: VenueValidationStatus.ACTIVE,
      },
    });
  }

  /**
   * Batch lookup, any status — for "mes lieux suivis" (ticket 10): a
   * followed venue that later goes inactive should still show up in a
   * client's own list (unfollowing is an explicit action), unlike
   * `findEligibleByIds`'s feed-candidate filtering.
   */
  async findByIds(ids: string[]): Promise<Venue[]> {
    if (ids.length === 0) return [];
    return this.venueRepository.find({ where: { id: In(ids) } });
  }

  /**
   * Public discovery read (ADR-0005): active + ACTIVE venues anywhere, not
   * geofenced. Optional `query` matches name/address; optional `lat`/`lng`
   * compute a distance (km, Haversine) each result is sorted by ascending
   * and (with `radiusKm`) filtered to — otherwise results sort newest first.
   */
  async search(
    dto: SearchVenuesQueryDto,
  ): Promise<PaginatedResponseDto<VenueDiscoverySummary>> {
    const page = dto.page ?? 1;
    const limit = dto.limit ?? 20;
    const hasLocation = dto.lat !== undefined && dto.lng !== undefined;

    const qb = this.venueRepository
      .createQueryBuilder('venue')
      .where('venue.isActive = :isActive', { isActive: true })
      .andWhere('venue.validationStatus = :status', {
        status: VenueValidationStatus.ACTIVE,
      });

    if (dto.query) {
      qb.andWhere('(venue.name ILIKE :query OR venue.address ILIKE :query)', {
        query: `%${dto.query}%`,
      });
    }

    if (hasLocation) {
      // Haversine distance in km — no PostGIS in this stack. Repeated as a
      // WHERE expression (not HAVING/alias) for the radius cutoff: Postgres
      // doesn't allow a SELECT alias in WHERE, and HAVING without GROUP BY
      // wouldn't filter per row.
      const distanceExpr = `6371 * acos(least(1, greatest(-1,
        cos(radians(:lat)) * cos(radians(venue.latitude)) *
        cos(radians(venue.longitude) - radians(:lng)) +
        sin(radians(:lat)) * sin(radians(venue.latitude))
      )))`;
      qb.addSelect(distanceExpr, 'distance_km')
        .setParameters({ lat: dto.lat, lng: dto.lng })
        .orderBy('distance_km', 'ASC');

      if (dto.radiusKm !== undefined) {
        qb.andWhere(`${distanceExpr} <= :radiusKm`, {
          radiusKm: dto.radiusKm,
        });
      }
    } else {
      qb.orderBy('venue.createdAt', 'DESC');
    }

    qb.skip((page - 1) * limit).take(limit);

    const { entities, raw } = await qb.getRawAndEntities();
    const total = await qb.getCount();

    const summaries = entities.map((venue, i) => ({
      ...toDiscoverySummary(venue),
      distanceKm: hasLocation ? Number(raw[i]?.distance_km ?? null) : null,
    }));

    return new PaginatedResponseDto(summaries, total, page, limit);
  }

  /** The venue bound to this owner — lets the owner app discover its venueId (the JWT carries none). */
  async findMine(ownerUserId: string): Promise<VenueWithOwner> {
    const venue = await this.venueRepository.findOne({
      where: { ownerUserId },
    });
    if (!venue) {
      throw new VenueNotFoundError('(none bound to this owner)');
    }
    const [withOwner] = await this.attachOwners([venue]);
    return withOwner;
  }

  /** Appends an uploaded image ref to the venue's `photos` list (`media` unit, ticket 14). */
  async appendPhoto(id: string, url: string): Promise<Venue> {
    const venue = await this.findVenueOrThrow(id);
    venue.photos = [...venue.photos, url];
    return this.venueRepository.save(venue);
  }

  /**
   * Raw entity, any status, no owner enrichment. For internal use by other
   * modules (e.g. `venue-nights`' ownership checks) — never return this
   * directly from a client-facing endpoint, it carries no PII guard.
   */
  async findRawOrThrow(id: string): Promise<Venue> {
    return this.findVenueOrThrow(id);
  }

  /**
   * Raw entity, `ACTIVE` + not-deactivated only, no owner enrichment. The
   * seam for client/public venue-detail reads — only active venues are ever
   * shown to end users, and owner PII is never part of this payload.
   */
  async findActiveOrThrow(id: string): Promise<Venue> {
    const venue = await this.venueRepository.findOne({
      where: {
        id,
        isActive: true,
        validationStatus: VenueValidationStatus.ACTIVE,
      },
    });
    if (!venue) {
      throw new VenueNotFoundError(id);
    }
    return venue;
  }

  private async findVenueOrThrow(id: string): Promise<Venue> {
    const venue = await this.venueRepository.findOne({ where: { id } });
    if (!venue) {
      throw new VenueNotFoundError(id);
    }
    return venue;
  }

  private async attachOwners(venues: Venue[]): Promise<VenueWithOwner[]> {
    const ownerIds = [
      ...new Set(
        venues
          .map((v) => v.ownerUserId)
          .filter((id): id is string => id !== null),
      ),
    ];
    const owners = await this.usersService.findByIds(ownerIds);
    const ownerById = new Map(owners.map((o) => [o.id, o]));

    return venues.map((venue) => ({
      ...venue,
      owner: venue.ownerUserId
        ? toOwnerSummary(ownerById.get(venue.ownerUserId) ?? null)
        : null,
    }));
  }
}

function toDiscoverySummary(
  venue: Venue,
): Omit<VenueDiscoverySummary, 'distanceKm'> {
  return {
    id: venue.id,
    name: venue.name,
    address: venue.address,
    latitude: venue.latitude,
    longitude: venue.longitude,
    venueType: venue.venueType,
    priceLevel: venue.priceLevel,
    photos: venue.photos,
  };
}

function toOwnerSummary(
  user: {
    id: string;
    phone: string;
    firstName: string | null;
    lastName: string | null;
  } | null,
): VenueOwnerSummary | null {
  if (!user) return null;
  return {
    id: user.id,
    phone: user.phone,
    firstName: user.firstName,
    lastName: user.lastName,
  };
}
