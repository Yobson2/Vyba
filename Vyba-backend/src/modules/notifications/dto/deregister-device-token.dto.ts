import { IsNotEmpty, IsString } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class DeregisterDeviceTokenDto {
  @ApiProperty()
  @IsString()
  @IsNotEmpty()
  token: string;
}
