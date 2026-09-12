import { Body, Controller, HttpCode, HttpStatus, Post } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse } from '@nestjs/swagger';
import { AnalyticsService } from './analytics.service';
import { TrackEventDto } from './dto/track-event.dto';
import { Public } from '@common/decorators/public.decorator';
import { GetUserId } from '@common/decorators/get-user.decorator';

@ApiTags('Analytics')
@Controller('api/analytics')
export class AnalyticsController {
  constructor(private readonly analyticsService: AnalyticsService) {}

  @Post('track')
  @Public()
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({
    summary:
      'Track a client-side event through the PostHog proxy (works signed-in or anonymous, pre-signup)',
  })
  @ApiResponse({ status: 204, description: 'Forwarded' })
  @ApiResponse({ status: 400, description: 'Unknown event name' })
  async track(
    @Body() dto: TrackEventDto,
    @GetUserId() userId: string | undefined,
  ): Promise<void> {
    await this.analyticsService.track({
      event: dto.event,
      userId,
      anonymousId: dto.anonymousId,
      properties: dto.properties,
    });
  }
}
