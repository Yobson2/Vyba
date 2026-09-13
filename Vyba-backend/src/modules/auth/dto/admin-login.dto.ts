import { IsEmail, IsString } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class AdminLoginDto {
  @ApiProperty({ example: 'ops@vyba.app' })
  @IsEmail()
  email: string;

  @ApiProperty()
  @IsString()
  password: string;
}
