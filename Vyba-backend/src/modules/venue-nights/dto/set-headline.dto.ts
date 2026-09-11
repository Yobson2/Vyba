import { IsOptional, IsString, MaxLength } from 'class-validator';
import { ApiPropertyOptional } from '@nestjs/swagger';

export class SetHeadlineDto {
  @ApiPropertyOptional({ example: 'Soirée Afrobeats avec DJ Kobo' })
  @IsOptional()
  @IsString()
  @MaxLength(280)
  headline?: string;

  @ApiPropertyOptional({ example: 'DJ Kobo' })
  @IsOptional()
  @IsString()
  @MaxLength(120)
  djName?: string;
}
