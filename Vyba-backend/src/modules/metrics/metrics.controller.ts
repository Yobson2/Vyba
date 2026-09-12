import { Controller, Get, Param, UseGuards } from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiBearerAuth,
} from '@nestjs/swagger';
import { MetricsService } from './metrics.service';
import { Roles } from '@common/decorators/roles.decorator';
import { RolesGuard } from '@common/guards/roles.guard';
import { UserRole } from '@common/constants/roles.constant';

/**
 * The §23 validation-gate aggregates (ticket 18 / spec 18) plus the
 * per-venue route ticket 13's nudge panel already uses. `ADMIN`-only,
 * aggregates only — never a per-user drill-down or raw rows.
 */
@ApiTags('Metrics')
@Controller('api/metrics')
@UseGuards(RolesGuard)
@Roles(UserRole.ADMIN)
@ApiBearerAuth('JWT-auth')
export class MetricsController {
  constructor(private readonly metricsService: MetricsService) {}

  @Get('venue/:venueId/organic-vs-assisted')
  @ApiOperation({
    summary:
      "This week's organic vs founder-assisted post counts for a venue (admin only)",
  })
  @ApiResponse({ status: 200, description: 'Organic vs assisted counts' })
  getOrganicVsAssisted(@Param('venueId') venueId: string) {
    return this.metricsService.getOrganicVsAssistedThisWeek(venueId);
  }

  @Get('zone4-wau')
  @ApiOperation({ summary: 'Zone 4 weekly active users, rolling 7 days' })
  @ApiResponse({ status: 200, description: 'WAU count' })
  async getZone4Wau() {
    return { wau: await this.metricsService.getZone4WeeklyActiveUsers() };
  }

  @Get('retention')
  @ApiOperation({
    summary: 'Week-1/2/4 retention, overall and by acquisition source',
  })
  @ApiResponse({ status: 200, description: 'Retention report' })
  getRetention() {
    return this.metricsService.getRetention();
  }

  @Get('organic-posting')
  @ApiOperation({
    summary: 'N of ~30 onboarded venues posting organically this week',
  })
  @ApiResponse({ status: 200, description: 'Organic posting roll-up' })
  getOrganicPosting() {
    return this.metricsService.getOrganicPostingRollup();
  }

  @Get('going-per-night')
  @ApiOperation({ summary: 'Going activity per night, last ~8 weeks' })
  @ApiResponse({ status: 200, description: 'Going per night series' })
  getGoingPerNight() {
    return this.metricsService.getGoingPerNight();
  }

  @Get('active-venues')
  @ApiOperation({ summary: 'Active venue count' })
  @ApiResponse({ status: 200, description: 'Active venue count' })
  async getActiveVenueCount() {
    return { count: await this.metricsService.getActiveVenueCount() };
  }

  @Get('content-activity')
  @ApiOperation({ summary: 'Published feed items this week, by type' })
  @ApiResponse({ status: 200, description: 'Content activity by type' })
  getContentActivity() {
    return this.metricsService.getContentActivityThisWeek();
  }

  @Get('monitor/tonight')
  @ApiOperation({
    summary:
      "Tonight's per-venue monitor — live status, going count, today's posts, quiet flag",
  })
  @ApiResponse({ status: 200, description: 'Monitor venue summaries' })
  getTonightMonitor() {
    return this.metricsService.getTonightMonitor();
  }
}
