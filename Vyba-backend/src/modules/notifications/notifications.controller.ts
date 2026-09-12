import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  Patch,
  Post,
  UseGuards,
} from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiOperation,
  ApiResponse,
  ApiTags,
} from '@nestjs/swagger';
import { NotificationsService } from './notifications.service';
import { RegisterDeviceTokenDto } from './dto/register-device-token.dto';
import { DeregisterDeviceTokenDto } from './dto/deregister-device-token.dto';
import { SetPreferencesDto } from './dto/set-preferences.dto';
import { CreateBroadcastDto } from './dto/create-broadcast.dto';
import { Roles } from '@common/decorators/roles.decorator';
import { RolesGuard } from '@common/guards/roles.guard';
import { GetUserId } from '@common/decorators/get-user.decorator';
import { UserRole } from '@common/constants/roles.constant';

@ApiTags('Notifications')
@Controller('api/notifications')
export class NotificationsController {
  constructor(private readonly notificationsService: NotificationsService) {}

  @Post('device-token')
  @UseGuards(RolesGuard)
  @Roles(UserRole.CLIENT)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({ summary: 'Register or refresh an FCM device token' })
  @ApiResponse({ status: 201, description: 'Token registered' })
  registerDeviceToken(
    @GetUserId() userId: string,
    @Body() dto: RegisterDeviceTokenDto,
  ) {
    return this.notificationsService.registerDeviceToken(userId, dto);
  }

  @Delete('device-token')
  @UseGuards(RolesGuard)
  @Roles(UserRole.CLIENT)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({ summary: 'Deregister a device token (sign-out)' })
  @ApiResponse({ status: 200, description: 'Token deregistered' })
  deregisterDeviceToken(
    @GetUserId() userId: string,
    @Body() dto: DeregisterDeviceTokenDto,
  ) {
    return this.notificationsService.deregisterDeviceToken(userId, dto.token);
  }

  @Get('preferences')
  @UseGuards(RolesGuard)
  @Roles(UserRole.CLIENT)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({ summary: 'My notification preferences (defaults on)' })
  @ApiResponse({ status: 200, description: 'Preferences' })
  getPreferences(@GetUserId() userId: string) {
    return this.notificationsService.getPreferences(userId);
  }

  @Patch('preferences')
  @UseGuards(RolesGuard)
  @Roles(UserRole.CLIENT)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({ summary: 'Toggle the weekend digest / going reminder' })
  @ApiResponse({ status: 200, description: 'Preferences updated' })
  setPreferences(@GetUserId() userId: string, @Body() dto: SetPreferencesDto) {
    return this.notificationsService.setPreferences(userId, dto);
  }

  @Get('venue-opt-ins/mine')
  @UseGuards(RolesGuard)
  @Roles(UserRole.CLIENT)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({
    summary: '"Mes lieux avec notifications" — venues I opted in to',
  })
  @ApiResponse({ status: 200, description: 'Opted-in venues' })
  getMyOptIns(@GetUserId() userId: string) {
    return this.notificationsService.getMyBroadcastOptIns(userId);
  }

  @Post('venue/:venueId/opt-in')
  @UseGuards(RolesGuard)
  @Roles(UserRole.CLIENT)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({
    summary: "Opt in to a venue's broadcasts (independent of following it)",
  })
  @ApiResponse({ status: 201, description: 'Opted in' })
  optIn(@Param('venueId') venueId: string, @GetUserId() userId: string) {
    return this.notificationsService.optInToVenueBroadcasts(userId, venueId);
  }

  @Delete('venue/:venueId/opt-in')
  @UseGuards(RolesGuard)
  @Roles(UserRole.CLIENT)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({ summary: "Opt out of a venue's broadcasts" })
  @ApiResponse({ status: 200, description: 'Opted out' })
  optOut(@Param('venueId') venueId: string, @GetUserId() userId: string) {
    return this.notificationsService.optOutOfVenueBroadcasts(userId, venueId);
  }

  @Get('venue/:venueId/opt-in')
  @UseGuards(RolesGuard)
  @Roles(UserRole.CLIENT)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({ summary: "Whether I'm opted in to this venue's broadcasts" })
  @ApiResponse({ status: 200, description: 'Opt-in state' })
  async getOptIn(
    @Param('venueId') venueId: string,
    @GetUserId() userId: string,
  ) {
    return {
      optedIn: await this.notificationsService.isOptedInToVenueBroadcasts(
        userId,
        venueId,
      ),
    };
  }

  @Post('venue/:venueId/broadcast')
  @UseGuards(RolesGuard)
  @Roles(UserRole.VENUE_OWNER)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({
    summary:
      'Send one broadcast to tonight\'s opted-in "going" crowd (owner only, once per venue per night)',
  })
  @ApiResponse({ status: 201, description: 'Broadcast sent' })
  @ApiResponse({ status: 403, description: "Not this venue's owner" })
  @ApiResponse({ status: 409, description: 'Already sent tonight' })
  sendBroadcast(
    @Param('venueId') venueId: string,
    @GetUserId() ownerId: string,
    @Body() dto: CreateBroadcastDto,
  ) {
    return this.notificationsService.sendVenueBroadcast(venueId, ownerId, dto);
  }

  @Post('jobs/weekend-digest/run')
  @UseGuards(RolesGuard)
  @Roles(UserRole.ADMIN)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({
    summary:
      'Run the weekend-digest job now (admin only — the e2e/demo seam and manual ops trigger)',
  })
  @ApiResponse({ status: 201, description: 'Job run summary' })
  runWeekendDigest() {
    return this.notificationsService.runWeekendDigest();
  }

  @Post('jobs/going-reminder/run')
  @UseGuards(RolesGuard)
  @Roles(UserRole.ADMIN)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({
    summary:
      'Run the going-reminder job now (admin only — the e2e/demo seam and manual ops trigger)',
  })
  @ApiResponse({ status: 201, description: 'Job run summary' })
  runGoingReminder() {
    return this.notificationsService.runGoingReminder();
  }
}
