import { IsNotEmpty, IsString, MaxLength } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class CreateBroadcastDto {
  @ApiProperty({ maxLength: 140 })
  @IsString()
  @IsNotEmpty()
  @MaxLength(140)
  message: string;
}
