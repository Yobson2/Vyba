import { IsEnum, IsOptional, IsUUID } from 'class-validator';
import { ApiPropertyOptional } from '@nestjs/swagger';
import { FeedItemType } from '../entities/feed-item.entity';

export class AdminFeedQueryDto {
  @ApiPropertyOptional({ enum: FeedItemType })
  @IsOptional()
  @IsEnum(FeedItemType)
  type?: FeedItemType;

  @ApiPropertyOptional()
  @IsOptional()
  @IsUUID()
  venueId?: string;
}
