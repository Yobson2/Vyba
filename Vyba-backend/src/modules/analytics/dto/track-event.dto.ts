import { IsObject, IsOptional, IsString, MaxLength } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class TrackEventDto {
  @ApiProperty({ example: 'venue_viewed' })
  @IsString()
  event: string;

  @ApiPropertyOptional({
    description:
      'Anonymous per-install client id — required when the caller is not signed in (the server derives the internal user id from the JWT otherwise).',
  })
  @IsOptional()
  @IsString()
  @MaxLength(100)
  anonymousId?: string;

  @ApiPropertyOptional({
    description:
      'Small typed property bag (e.g. venue_id, venue_night_id, source). Never a phone number — stripped server-side regardless.',
  })
  @IsOptional()
  @IsObject()
  properties?: Record<string, unknown>;
}
