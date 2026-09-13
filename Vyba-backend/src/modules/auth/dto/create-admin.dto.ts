import { IsEmail, IsOptional, IsString } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class CreateAdminDto {
  @ApiProperty({ example: 'newteammate@vyba.app' })
  @IsEmail()
  email: string;

  @ApiPropertyOptional({ example: 'Awa' })
  @IsOptional()
  @IsString()
  firstName?: string;

  @ApiPropertyOptional({ example: 'Traoré' })
  @IsOptional()
  @IsString()
  lastName?: string;
}
