import {
  Controller,
  Get,
  Post,
  Patch,
  Delete,
  Body,
  Param,
  Req,
  UseGuards,
} from '@nestjs/common';
import { Request } from 'express';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiBearerAuth,
} from '@nestjs/swagger';
import { ReservationsService } from './reservations.service';
import { CreateReservationDto } from './dto/create-reservation.dto';
import { RespondReservationDto } from './dto/respond-reservation.dto';
import { Roles } from '@common/decorators/roles.decorator';
import { RolesGuard } from '@common/guards/roles.guard';
import { GetUserId } from '@common/decorators/get-user.decorator';
import { UserRole } from '@common/constants/roles.constant';

@ApiTags('Reservations')
@ApiBearerAuth('JWT-auth')
@Controller('api/reservations')
export class ReservationsController {
  constructor(private readonly reservationsService: ReservationsService) {}

  @Post()
  @ApiOperation({
    summary: 'Request a reservation for tonight (opt-in venues only)',
  })
  @ApiResponse({ status: 201, description: 'Requested (pending)' })
  @ApiResponse({ status: 403, description: "Venue doesn't take reservations" })
  create(
    @Body() dto: CreateReservationDto,
    @GetUserId() userId: string,
    @Req() req: Request,
  ) {
    return this.reservationsService.create(userId, req.ip ?? 'unknown', dto);
  }

  @Delete('venue/:venueId')
  @ApiOperation({ summary: 'Cancel my reservation for tonight' })
  @ApiResponse({ status: 200, description: 'Canceled' })
  cancel(@Param('venueId') venueId: string, @GetUserId() userId: string) {
    return this.reservationsService.cancel(userId, venueId);
  }

  @Get('venue/:venueId/mine')
  @ApiOperation({
    summary: 'My current reservation for this venue tonight, if any',
  })
  @ApiResponse({ status: 200, description: 'The reservation, or null' })
  getMine(@Param('venueId') venueId: string, @GetUserId() userId: string) {
    return this.reservationsService.getMine(userId, venueId);
  }

  @Get('venue/:venueId/availability')
  @ApiOperation({
    summary:
      "Tonight's confirmed reservation count, for venues that take them — a cheap second call so the un-opted-in majority of venues never pay it",
  })
  @ApiResponse({ status: 200, description: 'Availability info' })
  getAvailability(@Param('venueId') venueId: string) {
    return this.reservationsService.getAvailabilityInfo(venueId);
  }

  @Get('venue/:venueId/owner')
  @UseGuards(RolesGuard)
  @Roles(UserRole.VENUE_OWNER)
  @ApiOperation({ summary: "Tonight's requests, pending first (owner only)" })
  @ApiResponse({ status: 200, description: 'Reservation list' })
  listForOwner(
    @Param('venueId') venueId: string,
    @GetUserId() ownerId: string,
  ) {
    return this.reservationsService.listForOwner(venueId, ownerId);
  }

  @Patch(':id/respond')
  @UseGuards(RolesGuard)
  @Roles(UserRole.VENUE_OWNER)
  @ApiOperation({ summary: 'Confirm or reject a request (owner only)' })
  @ApiResponse({ status: 200, description: 'Reservation updated' })
  @ApiResponse({ status: 409, description: 'Would exceed venue capacity' })
  respond(
    @Param('id') id: string,
    @Body() dto: RespondReservationDto,
    @GetUserId() ownerId: string,
  ) {
    return this.reservationsService.respond(id, ownerId, dto.status);
  }
}
