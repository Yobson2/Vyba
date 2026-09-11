import {
  IsEnum,
  IsInt,
  IsNumber,
  IsOptional,
  IsString,
  Max,
  Min,
} from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { VenueType } from '../entities/venue.entity';

export class CreateVenueDto {
  @ApiProperty({ example: 'Le Boony' })
  @IsString()
  name: string;

  @ApiPropertyOptional({ example: 'Rooftop lounge with live DJ sets.' })
  @IsOptional()
  @IsString()
  description?: string;

  @ApiPropertyOptional({ example: 'Rue du Canal, Zone 4, Marcory' })
  @IsOptional()
  @IsString()
  address?: string;

  @ApiProperty({ example: 5.286 })
  @IsNumber()
  @Min(-90)
  @Max(90)
  latitude: number;

  @ApiProperty({ example: -3.986 })
  @IsNumber()
  @Min(-180)
  @Max(180)
  longitude: number;

  @ApiProperty({ enum: VenueType })
  @IsEnum(VenueType)
  venueType: VenueType;

  @ApiPropertyOptional({ minimum: 1, maximum: 4, default: 1 })
  @IsOptional()
  @IsInt()
  @Min(1)
  @Max(4)
  priceLevel?: number;
}
