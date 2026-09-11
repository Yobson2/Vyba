import { Controller, Get, UseGuards } from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiBearerAuth,
} from '@nestjs/swagger';
import { VenuesService } from './venues.service';
import { Roles } from '@common/decorators/roles.decorator';
import { RolesGuard } from '@common/guards/roles.guard';
import { GetUserId } from '@common/decorators/get-user.decorator';
import { UserRole } from '@common/constants/roles.constant';

/**
 * A distinct `api/owner/*` prefix (rather than a same-segment-count
 * `api/venues/:something`) so this never risks colliding with the admin
 * `VenuesController`'s `GET /api/venues/:id` route regardless of module
 * registration order.
 */
@ApiTags('Venues')
@ApiBearerAuth('JWT-auth')
@Controller('api/owner')
@UseGuards(RolesGuard)
@Roles(UserRole.VENUE_OWNER)
export class OwnerVenueController {
  constructor(private readonly venuesService: VenuesService) {}

  @Get('venue')
  @ApiOperation({
    summary:
      'The venue bound to the signed-in owner — the JWT carries no venueId',
  })
  @ApiResponse({ status: 200, description: 'The owned venue' })
  @ApiResponse({ status: 404, description: 'No venue bound to this owner' })
  findMine(@GetUserId() ownerUserId: string) {
    return this.venuesService.findMine(ownerUserId);
  }
}
