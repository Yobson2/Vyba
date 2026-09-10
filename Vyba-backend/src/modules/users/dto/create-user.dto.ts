import { IsString, IsOptional, IsEnum, Matches } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { UserRole } from '@common/constants/roles.constant';

/** E.164: a leading '+', a non-zero first digit, then 6–14 more digits. */
export const E164_REGEX = /^\+[1-9]\d{6,14}$/;

export class CreateUserDto {
  @ApiProperty({
    example: '+2250700000000',
    description: 'Phone number in E.164 format',
  })
  @IsString()
  @Matches(E164_REGEX, { message: 'phone must be a valid E.164 number' })
  phone: string;

  @ApiPropertyOptional({ example: 'Awa' })
  @IsOptional()
  @IsString()
  firstName?: string;

  @ApiPropertyOptional({ example: 'Traoré' })
  @IsOptional()
  @IsString()
  lastName?: string;

  @ApiPropertyOptional({
    enum: UserRole,
    description: 'Defaults to CLIENT when omitted',
  })
  @IsOptional()
  @IsEnum(UserRole)
  role?: UserRole;
}
