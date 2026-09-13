import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Venue } from './entities/venue.entity';
import { VenuesService } from './venues.service';
import { VenuesController } from './venues.controller';
import { OwnerVenueController } from './owner-venue.controller';
import { VenueDiscoveryController } from './venue-discovery.controller';
import { UsersModule } from '../users/users.module';

@Module({
  imports: [TypeOrmModule.forFeature([Venue]), UsersModule],
  controllers: [
    VenuesController,
    OwnerVenueController,
    VenueDiscoveryController,
  ],
  providers: [VenuesService],
  exports: [VenuesService],
})
export class VenuesModule {}
