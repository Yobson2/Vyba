import {
  IsBoolean,
  IsEnum,
  IsInt,
  IsNumber,
  IsOptional,
  IsString,
  Max,
  Min,
} from 'class-validator';
import { ApiPropertyOptional } from '@nestjs/swagger';
import { VenueType, VenueValidationStatus } from '../entities/venue.entity';

export class UpdateVenueDto {
  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  name?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  description?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  address?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsNumber()
  @Min(-90)
  @Max(90)
  latitude?: number;

  @ApiPropertyOptional()
  @IsOptional()
  @IsNumber()
  @Min(-180)
  @Max(180)
  longitude?: number;

  @ApiPropertyOptional({ enum: VenueType })
  @IsOptional()
  @IsEnum(VenueType)
  venueType?: VenueType;

  @ApiPropertyOptional({ minimum: 1, maximum: 4 })
  @IsOptional()
  @IsInt()
  @Min(1)
  @Max(4)
  priceLevel?: number;

  @ApiPropertyOptional({ enum: VenueValidationStatus })
  @IsOptional()
  @IsEnum(VenueValidationStatus)
  validationStatus?: VenueValidationStatus;

  @ApiPropertyOptional({ description: 'Declared seating/standing capacity' })
  @IsOptional()
  @IsInt()
  @Min(1)
  capacity?: number;

  @ApiPropertyOptional({
    description: 'Opt this venue into real reservations (ADR-0006)',
  })
  @IsOptional()
  @IsBoolean()
  reservationsEnabled?: boolean;
}
