import { IsString, Matches, MinLength } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

/** Same complexity rule the dashboard's sign-in form already enforces client-side. */
export class ChangeAdminPasswordDto {
  @ApiProperty()
  @IsString()
  currentPassword: string;

  @ApiProperty({ minLength: 8 })
  @IsString()
  @MinLength(8, { message: 'newPassword must be at least 8 characters long' })
  @Matches(/[A-Z]/, {
    message: 'newPassword must contain at least one uppercase letter',
  })
  @Matches(/[a-z]/, {
    message: 'newPassword must contain at least one lowercase letter',
  })
  @Matches(/[0-9]/, {
    message: 'newPassword must contain at least one digit',
  })
  @Matches(/[^A-Za-z0-9]/, {
    message: 'newPassword must contain at least one special character',
  })
  newPassword: string;
}
