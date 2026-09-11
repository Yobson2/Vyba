import {
  IsBoolean,
  IsInt,
  IsOptional,
  IsString,
  Max,
  Min,
} from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class MarkGoingDto {
  @ApiProperty({ description: 'Venue id' })
  @IsString()
  venueId: string;

  @ApiPropertyOptional({ minimum: 1, maximum: 20, default: 1 })
  @IsOptional()
  @IsInt()
  @Min(1)
  @Max(20)
  partySize?: number;

  @ApiPropertyOptional({ default: false })
  @IsOptional()
  @IsBoolean()
  identityPublic?: boolean;
}
