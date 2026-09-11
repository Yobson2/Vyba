import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { VenueNight } from './entities/venue-night.entity';
import { VenueNightsService } from './venue-nights.service';
import { VenueNightsController } from './venue-nights.controller';
import { VenuesModule } from '../venues/venues.module';
import { FeedModule } from '../feed/feed.module';

@Module({
  imports: [TypeOrmModule.forFeature([VenueNight]), VenuesModule, FeedModule],
  controllers: [VenueNightsController],
  providers: [VenueNightsService],
  exports: [VenueNightsService],
})
export class VenueNightsModule {}
