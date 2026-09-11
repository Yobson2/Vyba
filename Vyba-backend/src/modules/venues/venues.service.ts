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
  owner: VenueOwnerSummary | null;
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
    Object.assign(venue, dto);
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
   * active, not deactivated, in the launch area. Silently drops
   * ineligible ids rather than throwing — callers filter a candidate set.
   */
  async findEligibleByIds(ids: string[]): Promise<Venue[]> {
    if (ids.length === 0) return [];
    return this.venueRepository.find({
      where: {
        id: In(ids),
        isActive: true,
        inLaunchArea: true,
        validationStatus: VenueValidationStatus.ACTIVE,
      },
    });
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
