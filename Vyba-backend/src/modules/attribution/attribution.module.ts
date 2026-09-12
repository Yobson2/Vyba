import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { LandingEvent } from './entities/landing-event.entity';
import { AcquisitionEvent } from './entities/acquisition-event.entity';
import { AttributionService } from './attribution.service';
import { AttributionController } from './attribution.controller';
import { VenuesModule } from '@modules/venues/venues.module';
import { UsersModule } from '@modules/users/users.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([LandingEvent, AcquisitionEvent]),
    VenuesModule,
    UsersModule,
  ],
  controllers: [AttributionController],
  providers: [AttributionService],
  exports: [AttributionService],
})
export class AttributionModule {}
