import { IsBoolean } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class SetLiveDto {
  @ApiProperty({ example: true })
  @IsBoolean()
  isLive: boolean;
}
