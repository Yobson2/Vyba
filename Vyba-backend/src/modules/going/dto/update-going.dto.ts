import { IsBoolean, IsInt, IsOptional, Max, Min } from 'class-validator';
import { ApiPropertyOptional } from '@nestjs/swagger';

export class UpdateGoingDto {
  @ApiPropertyOptional({ minimum: 1, maximum: 20 })
  @IsOptional()
  @IsInt()
  @Min(1)
  @Max(20)
  partySize?: number;

  @ApiPropertyOptional()
  @IsOptional()
  @IsBoolean()
  identityPublic?: boolean;
}
