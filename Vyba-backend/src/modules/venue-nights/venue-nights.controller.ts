import {
  Controller,
  Get,
  Post,
  Patch,
  Body,
  Param,
  UseGuards,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiBearerAuth,
} from '@nestjs/swagger';
import { VenueNightsService } from './venue-nights.service';
import { SetLiveDto } from './dto/set-live.dto';
import { SetHeadlineDto } from './dto/set-headline.dto';
import { Roles } from '@common/decorators/roles.decorator';
import { RolesGuard } from '@common/guards/roles.guard';
import { Public } from '@common/decorators/public.decorator';
import { GetUserId } from '@common/decorators/get-user.decorator';
import { UserRole } from '@common/constants/roles.constant';

/**
 * Owner night actions + venue-detail reads (ticket 06). Shares the
 * `api/venues` prefix with the admin `VenuesController` but on disjoint
 * sub-paths — no route overlap.
 */
@ApiTags('Venue Nights')
@Controller('api/venues')
export class VenueNightsController {
  constructor(private readonly venueNightsService: VenueNightsService) {}

  @Post(':id/live')
  @UseGuards(RolesGuard)
  @Roles(UserRole.VENUE_OWNER)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({
    summary: "Toggle tonight's live status (idempotent, owner only)",
  })
  @ApiResponse({ status: 201, description: 'Live status set' })
  @ApiResponse({ status: 403, description: "Not this venue's owner" })
  setLive(
    @Param('id') id: string,
    @GetUserId() ownerId: string,
    @Body() dto: SetLiveDto,
  ) {
    return this.venueNightsService.setLive(id, ownerId, dto.isLive);
  }

  @Patch(':id/tonight')
  @UseGuards(RolesGuard)
  @Roles(UserRole.VENUE_OWNER)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({ summary: "Set tonight's headline / DJ (owner only)" })
  @ApiResponse({ status: 200, description: 'Headline set' })
  setHeadline(
    @Param('id') id: string,
    @GetUserId() ownerId: string,
    @Body() dto: SetHeadlineDto,
  ) {
    return this.venueNightsService.setHeadline(id, ownerId, dto);
  }

  @Get(':id/tonight')
  @UseGuards(RolesGuard)
  @Roles(UserRole.VENUE_OWNER)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({
    summary:
      "Owner's own read of tonight's state (works before the venue is ACTIVE)",
  })
  @ApiResponse({ status: 200, description: "Tonight's state" })
  getOwnerTonight(@Param('id') id: string, @GetUserId() ownerId: string) {
    return this.venueNightsService.getOwnerTonight(id, ownerId);
  }

  @Get(':id/detail')
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({
    summary: "Venue profile + tonight's state (any authenticated user)",
  })
  @ApiResponse({ status: 200, description: 'Venue detail' })
  getDetail(@Param('id') id: string, @GetUserId() userId: string) {
    return this.venueNightsService.getPublicDetail(id, userId);
  }

  @Get(':id/public')
  @Public()
  @ApiOperation({
    summary:
      "Venue profile + tonight's state, unauthenticated (QR-web hardening lands in ticket 12)",
  })
  @ApiResponse({ status: 200, description: 'Venue detail' })
  getPublicVenueDetail(@Param('id') id: string) {
    return this.venueNightsService.getPublicDetail(id);
  }
}
