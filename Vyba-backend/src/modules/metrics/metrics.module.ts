import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { FeedItem } from '@modules/feed/entities/feed-item.entity';
import { VenueNight } from '@modules/venue-nights/entities/venue-night.entity';
import { Venue } from '@modules/venues/entities/venue.entity';
import { MetricsService } from './metrics.service';
import { MetricsController } from './metrics.controller';
import { UsersModule } from '@modules/users/users.module';

/**
 * `MetricsController` only exposes the one route ticket 13 needs
 * (per-venue organic-vs-assisted). Ticket 18 (dashboard monitoring/metrics)
 * adds the rest of `MetricsService`'s queries as routes on the same
 * controller.
 */
@Module({
  imports: [
    TypeOrmModule.forFeature([FeedItem, VenueNight, Venue]),
    UsersModule,
  ],
  controllers: [MetricsController],
  providers: [MetricsService],
  exports: [MetricsService],
})
export class MetricsModule {}
