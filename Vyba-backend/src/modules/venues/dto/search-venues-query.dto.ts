import {
  IsInt,
  IsNumber,
  IsOptional,
  IsString,
  Max,
  Min,
} from 'class-validator';
import { ApiPropertyOptional } from '@nestjs/swagger';

/**
 * Public venue discovery query (ADR-0005): free-text search, and/or
 * "nearby" sorting when `lat`/`lng` are given. Not geofenced — any active,
 * validated venue anywhere is a candidate.
 */
export class SearchVenuesQueryDto {
  @ApiPropertyOptional({ description: 'Matches venue name or address' })
  @IsOptional()
  @IsString()
  query?: string;

  @ApiPropertyOptional({ example: 5.286 })
  @IsOptional()
  @IsNumber()
  @Min(-90)
  @Max(90)
  lat?: number;

  @ApiPropertyOptional({ example: -3.986 })
  @IsOptional()
  @IsNumber()
  @Min(-180)
  @Max(180)
  lng?: number;

  @ApiPropertyOptional({
    description: 'Only with lat/lng — max distance in km',
  })
  @IsOptional()
  @IsNumber()
  @Min(0)
  radiusKm?: number;

  @ApiPropertyOptional({ default: 1, minimum: 1 })
  @IsOptional()
  @IsInt()
  @Min(1)
  page?: number;

  @ApiPropertyOptional({ default: 20, minimum: 1, maximum: 100 })
  @IsOptional()
  @IsInt()
  @Min(1)
  @Max(100)
  limit?: number;
}
