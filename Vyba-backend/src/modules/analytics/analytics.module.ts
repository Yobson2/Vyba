import { Module } from '@nestjs/common';
import { AnalyticsService } from './analytics.service';
import { AnalyticsController } from './analytics.controller';
import { PostHogModule } from '@common/posthog/posthog.module';
import { UsersModule } from '@modules/users/users.module';
import { VenuesModule } from '@modules/venues/venues.module';

@Module({
  imports: [PostHogModule, UsersModule, VenuesModule],
  controllers: [AnalyticsController],
  providers: [AnalyticsService],
  exports: [AnalyticsService],
})
export class AnalyticsModule {}
