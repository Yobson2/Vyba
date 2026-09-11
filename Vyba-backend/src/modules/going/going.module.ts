import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Going } from './entities/going.entity';
import { GoingService } from './going.service';
import { GoingController } from './going.controller';
import { VenuesModule } from '../venues/venues.module';
import { VenueNightsModule } from '../venue-nights/venue-nights.module';
import { FeedModule } from '../feed/feed.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([Going]),
    VenuesModule,
    VenueNightsModule,
    FeedModule,
  ],
  controllers: [GoingController],
  providers: [GoingService],
  exports: [GoingService],
})
export class GoingModule {}
