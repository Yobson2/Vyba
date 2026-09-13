import { IsIn } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';
import { ReservationStatus } from '../entities/reservation.entity';

const RESPOND_STATUSES = [
  ReservationStatus.CONFIRMED,
  ReservationStatus.REJECTED,
] as const;

export class RespondReservationDto {
  @ApiProperty({ enum: RESPOND_STATUSES })
  @IsIn(RESPOND_STATUSES)
  status: (typeof RESPOND_STATUSES)[number];
}
