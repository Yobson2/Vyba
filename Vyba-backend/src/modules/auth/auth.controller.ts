import {
  Controller,
  Post,
  Patch,
  Get,
  Param,
  Body,
  HttpCode,
  HttpStatus,
  Req,
  UseGuards,
} from '@nestjs/common';
import { Request } from 'express';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiBearerAuth,
} from '@nestjs/swagger';
import { AuthService } from './auth.service';
import { RefreshTokenDto } from './dto/refresh-token.dto';
import { RequestOtpDto } from './dto/request-otp.dto';
import { VerifyOtpDto } from './dto/verify-otp.dto';
import { AdminLoginDto } from './dto/admin-login.dto';
import { ChangeAdminPasswordDto } from './dto/change-admin-password.dto';
import { CreateAdminDto } from './dto/create-admin.dto';
import { UpdateAdminDto } from './dto/update-admin.dto';
import { Public } from '@common/decorators/public.decorator';
import { Roles } from '@common/decorators/roles.decorator';
import { RolesGuard } from '@common/guards/roles.guard';
import { GetUserId } from '@common/decorators/get-user.decorator';
import { UserRole } from '@common/constants/roles.constant';

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

  @Post('admin/login')
  @Public()
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Admin dashboard email+password login (ADR-0003)' })
  @ApiResponse({ status: 200, description: 'Verified, tokens issued' })
  @ApiResponse({ status: 401, description: 'Invalid email or password' })
  adminLogin(@Body() dto: AdminLoginDto) {
    return this.authService.adminLogin(dto.email, dto.password);
  }

  @Get('admin')
  @UseGuards(RolesGuard)
  @Roles(UserRole.ADMIN)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({ summary: 'List admin accounts (dashboard "Admin Users")' })
  @ApiResponse({ status: 200, description: 'Admin account list' })
  listAdmins() {
    return this.authService.listAdmins();
  }

  @Post('admin')
  @UseGuards(RolesGuard)
  @Roles(UserRole.ADMIN)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({
    summary: 'Invite a new admin — returns a one-time temporary password',
  })
  @ApiResponse({ status: 201, description: 'Admin account created' })
  @ApiResponse({ status: 409, description: 'Email already in use' })
  createAdmin(@Body() dto: CreateAdminDto) {
    return this.authService.createAdmin(dto);
  }

  @Patch('admin/password')
  @UseGuards(RolesGuard)
  @Roles(UserRole.ADMIN)
  @ApiBearerAuth('JWT-auth')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({ summary: "Change the caller's own admin password" })
  @ApiResponse({ status: 204, description: 'Password changed' })
  @ApiResponse({ status: 401, description: 'Current password is wrong' })
  async changeAdminPassword(
    @Body() dto: ChangeAdminPasswordDto,
    @GetUserId() userId: string,
  ): Promise<void> {
    await this.authService.changeAdminPassword(
      userId,
      dto.currentPassword,
      dto.newPassword,
    );
  }

  @Patch('admin/:id')
  @UseGuards(RolesGuard)
  @Roles(UserRole.ADMIN)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({
    summary: 'Edit another admin, or deactivate/reactivate them',
  })
  @ApiResponse({ status: 200, description: 'Admin account updated' })
  @ApiResponse({
    status: 400,
    description: 'Cannot deactivate self or the last active admin',
  })
  updateAdmin(
    @Param('id') id: string,
    @Body() dto: UpdateAdminDto,
    @GetUserId() callerId: string,
  ) {
    return this.authService.updateAdmin(id, dto, callerId);
  }

  @Post('admin/:id/reset-password')
  @UseGuards(RolesGuard)
  @Roles(UserRole.ADMIN)
  @ApiBearerAuth('JWT-auth')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary:
      "Reset another admin's password — returns a one-time temporary password",
  })
  @ApiResponse({ status: 200, description: 'Temporary password issued' })
  resetAdminPassword(@Param('id') id: string) {
    return this.authService.resetAdminPassword(id);
  }
}
