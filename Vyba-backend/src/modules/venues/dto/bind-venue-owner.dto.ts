import { IsOptional, IsString, Matches } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { E164_REGEX } from '@modules/users/dto/create-user.dto';

/** Provisions (or reuses) a VENUE_OWNER account by phone and binds it to a venue. No password — ADR-0003. */
export class BindVenueOwnerDto {
  @ApiProperty({ example: '+2250700000001' })
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
}
