import { IsString, MaxLength, MinLength } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class CreatePromoDto {
  @ApiProperty({ example: 'Happy hour -50% jusqu’à 23h' })
  @IsString()
  @MinLength(1)
  @MaxLength(80)
  title: string;

  @ApiProperty({ example: 'Sur tous les cocktails, ce soir seulement.' })
  @IsString()
  @MinLength(1)
  @MaxLength(500)
  description: string;
}
