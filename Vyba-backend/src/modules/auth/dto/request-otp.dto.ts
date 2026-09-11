import { IsString, Matches } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';
import { E164_REGEX } from '@modules/users/dto/create-user.dto';

export class RequestOtpDto {
  @ApiProperty({
    example: '+2250700000000',
    description: 'Phone number in E.164 format',
  })
  @IsString()
  @Matches(E164_REGEX, { message: 'phone must be a valid E.164 number' })
  phone: string;
}
