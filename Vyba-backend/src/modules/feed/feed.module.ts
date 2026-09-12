import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { FeedItem } from './entities/feed-item.entity';
import { FeedItemsService } from './feed-items.service';
import { FeedController } from './feed.controller';
import { VenuesModule } from '../venues/venues.module';
import { FollowsModule } from '../follows/follows.module';
import { AnalyticsModule } from '../analytics/analytics.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([FeedItem]),
    VenuesModule,
    FollowsModule,
    AnalyticsModule,
  ],
  controllers: [FeedController],
  providers: [FeedItemsService],
  exports: [FeedItemsService],
})
export class FeedModule {}
