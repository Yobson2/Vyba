import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { LandingEvent } from './entities/landing-event.entity';
import { AcquisitionEvent } from './entities/acquisition-event.entity';
import { CaptureLandingDto } from './dto/capture-landing.dto';
import { VenuesService } from '@modules/venues/venues.service';
import { UsersService } from '@modules/users/users.service';

const ZONE_4 = 'zone_4';
const OTHER_ZONE = 'other';

@Injectable()
export class AttributionService {
  constructor(
    @InjectRepository(LandingEvent)
    private readonly landingEventRepository: Repository<LandingEvent>,
    @InjectRepository(AcquisitionEvent)
    private readonly acquisitionEventRepository: Repository<AcquisitionEvent>,
    private readonly venuesService: VenuesService,
    private readonly usersService: UsersService,
  ) {}

  /** Raw capture at landing time (spec 07) — no user id yet, pre-signup. */
  async captureLanding(dto: CaptureLandingDto): Promise<LandingEvent> {
    const item = this.landingEventRepository.create({
      src: dto.src,
      venueId: dto.venueId ?? null,
      promoterId: dto.promoterId ?? null,
      campaignId: dto.campaignId ?? null,
      surface: dto.surface,
      clientId: dto.clientId,
    });
    return this.landingEventRepository.save(item);
  }

  /**
   * Called once, from `AuthService.verifyCode` on a brand-new account's
   * first-ever verify. Matches the pending landing by `clientId`
   * (first-touch — the earliest landing for that id, per spec 07's
   * recommended default), records an `AcquisitionEvent`, and writes the
   * `User` snapshot. A no-op when there's no `clientId` or no matching
   * landing (organic signup, nothing to attribute).
   */
  async recordSignupAttribution(
    userId: string,
    clientId: string | undefined,
  ): Promise<void> {
    if (!clientId) return;

    const firstLanding = await this.landingEventRepository.findOne({
      where: { clientId },
      order: { createdAt: 'ASC' },
    });
    if (!firstLanding) return;

    const zone = await this.resolveZone(firstLanding.venueId);

    await this.acquisitionEventRepository.save(
      this.acquisitionEventRepository.create({
        userId,
        src: firstLanding.src,
        venueId: firstLanding.venueId,
        promoterId: firstLanding.promoterId,
        campaignId: firstLanding.campaignId,
        zone,
      }),
    );

    await this.usersService.writeAcquisitionSnapshot(userId, {
      acquisitionSource: firstLanding.src,
      acquisitionVenueId: firstLanding.venueId,
      acquisitionPromoterId: firstLanding.promoterId,
      acquisitionCampaign: firstLanding.campaignId,
      acquisitionZone: zone,
      firstLandingAt: firstLanding.createdAt,
    });
  }

  private async resolveZone(venueId: string | null): Promise<string | null> {
    if (!venueId) return null;
    const venue = await this.venuesService
      .findRawOrThrow(venueId)
      .catch(() => null);
    if (!venue) return null;
    return venue.inLaunchArea ? ZONE_4 : OTHER_ZONE;
  }
}
