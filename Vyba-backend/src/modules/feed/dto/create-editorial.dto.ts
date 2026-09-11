import { IsDateString, IsOptional, IsString, MaxLength } from 'class-validator';
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
}
