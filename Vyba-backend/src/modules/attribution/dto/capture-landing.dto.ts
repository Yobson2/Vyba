import { IsIn, IsOptional, IsString, IsUUID, MaxLength } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

const SOURCES = ['qr', 'promoter', 'social', 'organic'] as const;
const SURFACES = ['web', 'app'] as const;

export class CaptureLandingDto {
  @ApiProperty({ enum: SOURCES, example: 'qr' })
  @IsIn(SOURCES)
  src: (typeof SOURCES)[number];

  @ApiPropertyOptional({ description: 'Set on a QR landing (?venue=).' })
  @IsOptional()
  @IsUUID()
  venueId?: string;

  @ApiPropertyOptional({
    description: 'Set on a promoter landing (?pid=) — a tagged User id.',
  })
  @IsOptional()
  @IsUUID()
  promoterId?: string;

  @ApiPropertyOptional({ description: 'Set on a social landing (?campaign=).' })
  @IsOptional()
  @IsString()
  @MaxLength(100)
  campaignId?: string;

  @ApiProperty({ enum: SURFACES, example: 'app' })
  @IsIn(SURFACES)
  surface: (typeof SURFACES)[number];

  @ApiProperty({
    description:
      'Anonymous per-install/per-browser id, matched to the signup later.',
  })
  @IsString()
  @MaxLength(100)
  clientId: string;
}
