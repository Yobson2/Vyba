import { IsInt, IsOptional, IsString, IsUUID, Max, Min } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class CreateReservationDto {
  @ApiProperty()
  @IsUUID()
  venueId: string;

  @ApiPropertyOptional({ default: 1, minimum: 1, maximum: 20 })
  @IsOptional()
  @IsInt()
  @Min(1)
  @Max(20)
  partySize?: number;

  @ApiPropertyOptional({ example: 'Table près de la scène si possible' })
  @IsOptional()
  @IsString()
  note?: string;
}
