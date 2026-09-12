import { Inject, Injectable, Logger } from '@nestjs/common';
import { randomInt } from 'crypto';
import { JwtService } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';
import { UsersService } from '../users/users.service';
import { UserRole } from '@common/constants/roles.constant';
import {
  AccountInactiveError,
  AgeConfirmationRequiredError,
  InvalidOtpError,
  InvalidTokenError,
  OtpExpiredError,
  OtpRateLimitedError,
} from '@common/exceptions/auth.exceptions';
import {
  getJWTRefreshSecret,
  JWT_EXPIRES_IN,
  JWT_REFRESH_TOKEN_EXPIRES_IN,
} from '@common/config/auth.config';
import { SMS_PROVIDER, SmsProvider } from '@common/sms/sms-provider.interface';
import { OtpStoreService } from './otp-store.service';
import { OTP_CODE_LENGTH, OTP_MAX_VERIFY_ATTEMPTS } from './otp.constants';
import { AttributionService } from '@modules/attribution/attribution.service';

interface TokenPayload {
  userId: string;
  role: UserRole;
  phone: string;
}

/**
 * Phone-OTP identity (ADR-0003): a phone number + a one-time code is the only
 * way in. `request`/`verify` establish or resume a `User`; `refreshToken`
 * rotates the session once a principal already exists.
 */
@Injectable()
export class AuthService {
  private readonly logger = new Logger(AuthService.name);

  constructor(
    private readonly usersService: UsersService,
    private readonly jwtService: JwtService,
    private readonly configService: ConfigService,
    private readonly otpStore: OtpStoreService,
    @Inject(SMS_PROVIDER) private readonly smsProvider: SmsProvider,
    private readonly attributionService: AttributionService,
  ) {}

  /**
   * Requests (or resends) a code for a phone number. Never reveals whether
   * the number belongs to an existing user, and never returns the code.
   */
  async requestCode(phone: string, clientIp: string): Promise<void> {
    const [phoneAllowed, ipAllowed] = await Promise.all([
      this.otpStore.checkPhoneRateLimit(phone),
      this.otpStore.checkIpRateLimit(clientIp),
    ]);
    if (!phoneAllowed || !ipAllowed) {
      throw new OtpRateLimitedError();
    }

    if (await this.otpStore.isCoolingDown(phone)) {
      throw new OtpRateLimitedError();
    }

    const code = this.generateCode();
    await this.otpStore.issueCode(phone, code);

    const result = await this.smsProvider.send(
      phone,
      `Votre code Vyba est ${code}. Il expire dans 5 minutes.`,
    );
    if (!result.accepted) {
      this.logger.error(
        `OTP dispatch failed (reason=${result.reason ?? 'unknown'})`,
      );
    }
  }

  /**
   * Verifies a code, get-or-creates the user by phone, records the 18+
   * confirmation on first verify, and issues tokens.
   */
  async verifyCode(
    phone: string,
    code: string,
    ageConfirmed: boolean | undefined,
    clientId?: string,
  ): Promise<{
    user: Record<string, unknown>;
    accessToken: string;
    refreshToken: string;
  }> {
    const storedCode = await this.otpStore.getCode(phone);
    if (!storedCode) {
      throw new OtpExpiredError();
    }

    if (storedCode !== code) {
      const attempts = await this.otpStore.recordWrongAttempt(phone);
      if (attempts >= OTP_MAX_VERIFY_ATTEMPTS) {
        await this.otpStore.invalidateCode(phone);
        throw new OtpExpiredError();
      }
      throw new InvalidOtpError();
    }

    await this.otpStore.invalidateCode(phone);

    const user = await this.usersService.findOrCreateByPhone(phone);

    if (!user.isActive) {
      throw new AccountInactiveError();
    }

    let confirmedUser = user;
    if (!user.ageConfirmedAt) {
      if (ageConfirmed !== true) {
        throw new AgeConfirmationRequiredError();
      }
      confirmedUser = await this.usersService.confirmAge(user.id);
      // First-ever verify for this account — the one moment a signup
      // attribution snapshot makes sense (ticket 11 / spec 07).
      await this.attributionService.recordSignupAttribution(
        confirmedUser.id,
        clientId,
      );
    }

    const tokens = this.generateTokens(
      confirmedUser.id,
      confirmedUser.role,
      confirmedUser.phone,
    );
    this.logger.log(`User verified: ${confirmedUser.id}`);
    return { user: confirmedUser.toJSON(), ...tokens };
  }

  async refreshToken(refreshToken: string) {
    try {
      const refreshSecret = getJWTRefreshSecret(this.configService);
      const payload = this.jwtService.verify<TokenPayload>(refreshToken, {
        secret: refreshSecret,
      });

      const user = await this.usersService.findOne(payload.userId);
      if (!user.isActive) {
        throw new AccountInactiveError();
      }
      const tokens = this.generateTokens(user.id, user.role, user.phone);

      return { user: user.toJSON(), ...tokens };
    } catch (error) {
      if (error instanceof AccountInactiveError) {
        throw error;
      }
      throw new InvalidTokenError('Invalid or expired refresh token');
    }
  }

  private generateCode(): string {
    const max = 10 ** OTP_CODE_LENGTH;
    return randomInt(0, max).toString().padStart(OTP_CODE_LENGTH, '0');
  }

  private generateTokens(userId: string, role: UserRole, phone: string) {
    const payload: TokenPayload = { userId, role, phone };
    const refreshSecret = getJWTRefreshSecret(this.configService);

    return {
      accessToken: this.jwtService.sign(payload, { expiresIn: JWT_EXPIRES_IN }),
      refreshToken: this.jwtService.sign(payload, {
        secret: refreshSecret,
        expiresIn: JWT_REFRESH_TOKEN_EXPIRES_IN,
      }),
    };
  }
}
