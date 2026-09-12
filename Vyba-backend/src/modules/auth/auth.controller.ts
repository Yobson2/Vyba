import {
  Controller,
  Post,
  Body,
  HttpCode,
  HttpStatus,
  Req,
} from '@nestjs/common';
import { Request } from 'express';
import { ApiTags, ApiOperation, ApiResponse } from '@nestjs/swagger';
import { AuthService } from './auth.service';
import { RefreshTokenDto } from './dto/refresh-token.dto';
import { RequestOtpDto } from './dto/request-otp.dto';
import { VerifyOtpDto } from './dto/verify-otp.dto';
import { Public } from '@common/decorators/public.decorator';

@ApiTags('Auth')
@Controller('api/auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('request-code')
  @Public()
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({ summary: 'Request (or resend) a phone-OTP code' })
  @ApiResponse({ status: 204, description: 'Code dispatched if eligible' })
  @ApiResponse({ status: 429, description: 'Rate limited or cooling down' })
  async requestCode(
    @Body() dto: RequestOtpDto,
    @Req() req: Request,
  ): Promise<void> {
    await this.authService.requestCode(dto.phone, req.ip ?? 'unknown');
  }

  @Post('verify-code')
  @Public()
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Verify a phone-OTP code and obtain tokens' })
  @ApiResponse({ status: 200, description: 'Verified, tokens issued' })
  @ApiResponse({ status: 401, description: 'Invalid or expired code' })
  verifyCode(@Body() dto: VerifyOtpDto) {
    return this.authService.verifyCode(
      dto.phone,
      dto.code,
      dto.ageConfirmed,
      dto.clientId,
    );
  }

  @Post('refresh')
  @Public()
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Refresh access token' })
  @ApiResponse({ status: 200, description: 'New tokens generated' })
  @ApiResponse({ status: 401, description: 'Invalid refresh token' })
  refresh(@Body() dto: RefreshTokenDto) {
    return this.authService.refreshToken(dto.refreshToken);
  }
}
