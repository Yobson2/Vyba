import { IsDateString, IsEnum, IsOptional, IsUUID } from 'class-validator';
import { ApiPropertyOptional } from '@nestjs/swagger';
import { MediaAssetStatus } from '../entities/media-asset.entity';

export class AdminMediaQueryDto {
  @ApiPropertyOptional({ enum: MediaAssetStatus })
  @IsOptional()
  @IsEnum(MediaAssetStatus)
  status?: MediaAssetStatus;

  @ApiPropertyOptional()
  @IsOptional()
  @IsUUID()
  venueId?: string;

  @ApiPropertyOptional({ description: "VenueNight date ('YYYY-MM-DD')" })
  @IsOptional()
  @IsDateString()
  date?: string;
}
