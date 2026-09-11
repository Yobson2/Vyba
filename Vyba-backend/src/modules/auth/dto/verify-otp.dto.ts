import { IsBoolean, IsOptional, IsString, Matches } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { E164_REGEX } from '@modules/users/dto/create-user.dto';

export class VerifyOtpDto {
  @ApiProperty({
    example: '+2250700000000',
    description: 'Phone number in E.164 format',
  })
  @IsString()
  @Matches(E164_REGEX, { message: 'phone must be a valid E.164 number' })
  phone: string;

  @ApiProperty({ example: '123456' })
  @IsString()
  @Matches(/^\d{6}$/, { message: 'code must be a 6-digit number' })
  code: string;

  @ApiPropertyOptional({
    description:
      'Confirms the user is 18+. Required on a first-ever verify; ignored afterwards.',
  })
  @IsOptional()
  @IsBoolean()
  ageConfirmed?: boolean;
}
