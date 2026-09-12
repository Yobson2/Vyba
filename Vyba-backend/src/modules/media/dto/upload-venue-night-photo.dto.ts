import { IsUUID } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class UploadVenueNightPhotoDto {
  @ApiProperty({ description: 'The venue to add tonight’s photo to' })
  @IsUUID()
  venueId: string;
}
