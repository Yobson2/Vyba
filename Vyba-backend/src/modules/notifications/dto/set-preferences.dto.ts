import { IsBoolean, IsOptional } from 'class-validator';
import { ApiPropertyOptional } from '@nestjs/swagger';

export class SetPreferencesDto {
  @ApiPropertyOptional()
  @IsOptional()
  @IsBoolean()
  weekendDigest?: boolean;

  @ApiPropertyOptional()
  @IsOptional()
  @IsBoolean()
  goingReminder?: boolean;
}
