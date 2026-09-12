import {
  IsBoolean,
  IsDateString,
  IsOptional,
  IsString,
  IsUUID,
  MaxLength,
} from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class CreateEditorialDto {
  @ApiProperty({ example: 'Ce soir à Zone 4' })
  @IsString()
  @MaxLength(120)
  title: string;

  @ApiProperty({ example: '5 spots chauds ce soir, à commencer par...' })
  @IsString()
  @MaxLength(2000)
  body: string;

  @ApiPropertyOptional({
    description:
      'Defaults to now — pass a future ISO timestamp to schedule it.',
  })
  @IsOptional()
  @IsDateString()
  publishedAt?: string;

  @ApiProperty({ description: 'Required — editorial does not auto-expire.' })
  @IsDateString()
  expiresAt: string;

  @ApiPropertyOptional({
    description:
      'Area-wide when omitted (null); ties this item to one venue otherwise.',
  })
  @IsOptional()
  @IsUUID()
  venueId?: string;

  @ApiPropertyOptional({
    description:
      "Saved as a draft (won't appear even once `publishedAt` passes) until explicitly published. Defaults to false.",
  })
  @IsOptional()
  @IsBoolean()
  draft?: boolean;
}

export class UpdateEditorialDto {
  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @MaxLength(120)
  title?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @MaxLength(2000)
  body?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsDateString()
  publishedAt?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsDateString()
  expiresAt?: string;

  @ApiPropertyOptional({ description: 'Pass null to make it area-wide again.' })
  @IsOptional()
  @IsUUID()
  venueId?: string | null;
}
