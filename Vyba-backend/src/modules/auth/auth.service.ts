import { Inject, Injectable, Logger } from '@nestjs/common';
import { randomBytes, randomInt } from 'crypto';
import * as bcrypt from 'bcrypt';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { JwtService } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';
import { UsersService } from '../users/users.service';
import { UserRole } from '@common/constants/roles.constant';
import {
  AccountInactiveError,
  AdminEmailAlreadyExistsError,
  AgeConfirmationRequiredError,
  CannotDeactivateLastAdminError,
  CannotDeactivateSelfError,
  InvalidAdminCredentialsError,
  InvalidOtpError,
  InvalidTokenError,
  OtpExpiredError,
  OtpRateLimitedError,
} from '@common/exceptions/auth.exceptions';
import { UserNotFoundError } from '@common/exceptions/user.exceptions';
import {
  getJWTRefreshSecret,
  JWT_EXPIRES_IN,
  JWT_REFRESH_TOKEN_EXPIRES_IN,
} from '@common/config/auth.config';
import { SMS_PROVIDER, SmsProvider } from '@common/sms/sms-provider.interface';
import { OtpStoreService } from './otp-store.service';
import { OTP_CODE_LENGTH, OTP_MAX_VERIFY_ATTEMPTS } from './otp.constants';
import { AttributionService } from '@modules/attribution/attribution.service';
import { AdminCredential } from './entities/admin-credential.entity';
import { CreateAdminDto } from './dto/create-admin.dto';
import { UpdateAdminDto } from './dto/update-admin.dto';

const BCRYPT_ROUNDS = 12;

export interface AdminAccountSummary {
  id: string;
  email: string;
  firstName: string | null;
  lastName: string | null;
  isActive: boolean;
  createdAt: Date;
  updatedAt: Date;
}

interface TokenPayload {
  userId: string;
  role: UserRole;
  phone: string;
  /** Only present for an ADMIN token minted via email+password login. */
  email?: string;
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
    @InjectRepository(AdminCredential)
    private readonly adminCredentialRepository: Repository<AdminCredential>,
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

  /**
   * Email+password login for the internal admin dashboard (ADR-0003
   * exemption). Never reveals whether the email is registered — a missing
   * `AdminCredential` and a wrong password both fail the same way.
   */
  async adminLogin(
    email: string,
    password: string,
  ): Promise<{
    user: Record<string, unknown>;
    accessToken: string;
    refreshToken: string;
  }> {
    const credential = await this.adminCredentialRepository.findOne({
      where: { email: email.toLowerCase() },
    });
    if (!credential) {
      throw new InvalidAdminCredentialsError();
    }

    const passwordMatches = await bcrypt.compare(
      password,
      credential.passwordHash,
    );
    if (!passwordMatches) {
      throw new InvalidAdminCredentialsError();
    }

    const user = await this.usersService.findOne(credential.userId);
    if (!user.isActive) {
      throw new AccountInactiveError();
    }

    const tokens = this.generateTokens(
      user.id,
      user.role,
      user.phone,
      credential.email,
    );
    this.logger.log(`Admin verified: ${user.id}`);
    return { user: user.toJSON(), ...tokens };
  }

  /** Changes the caller's own admin password — requires the current one. */
  async changeAdminPassword(
    userId: string,
    currentPassword: string,
    newPassword: string,
  ): Promise<void> {
    const credential = await this.adminCredentialRepository.findOne({
      where: { userId },
    });
    if (!credential) {
      throw new InvalidAdminCredentialsError();
    }

    const passwordMatches = await bcrypt.compare(
      currentPassword,
      credential.passwordHash,
    );
    if (!passwordMatches) {
      throw new InvalidAdminCredentialsError();
    }

    credential.passwordHash = await bcrypt.hash(newPassword, BCRYPT_ROUNDS);
    await this.adminCredentialRepository.save(credential);
    this.logger.log(`Admin password changed: ${userId}`);
  }

  /** Every admin account, newest first — the dashboard's "Admin Users" screen. */
  async listAdmins(): Promise<AdminAccountSummary[]> {
    const credentials = await this.adminCredentialRepository.find({
      order: { createdAt: 'DESC' },
    });
    const users = await this.usersService.findByIds(
      credentials.map((c) => c.userId),
    );
    const userById = new Map(users.map((u) => [u.id, u]));

    return credentials
      .map((credential) => {
        const user = userById.get(credential.userId);
        if (!user) return null;
        return {
          id: user.id,
          email: credential.email,
          firstName: user.firstName,
          lastName: user.lastName,
          isActive: user.isActive,
          createdAt: credential.createdAt,
          updatedAt: user.updatedAt,
        };
      })
      .filter((a): a is AdminAccountSummary => a !== null);
  }

  /**
   * Invites a new teammate (admin-only, dashboard "Admin Users" screen): no
   * email-sending flow exists, so this mints a one-time temporary password
   * — returned ONLY in this response, never logged or stored in plaintext —
   * for the inviting admin to hand off out-of-band. The new admin changes it
   * via `changeAdminPassword` after first login.
   */
  async createAdmin(
    dto: CreateAdminDto,
  ): Promise<AdminAccountSummary & { temporaryPassword: string }> {
    const email = dto.email.toLowerCase();
    const existing = await this.adminCredentialRepository.findOne({
      where: { email },
    });
    if (existing) {
      throw new AdminEmailAlreadyExistsError(email);
    }

    const placeholderPhone = `sa_${randomBytes(6).toString('hex')}`;
    const user = await this.usersService.createAdminUser(
      placeholderPhone,
      dto.firstName,
      dto.lastName,
    );

    const temporaryPassword = this.generateTemporaryPassword();
    const passwordHash = await bcrypt.hash(temporaryPassword, BCRYPT_ROUNDS);
    const credential = await this.adminCredentialRepository.save(
      this.adminCredentialRepository.create({
        userId: user.id,
        email,
        passwordHash,
      }),
    );

    this.logger.log(`Admin account created: ${user.id} (${email})`);
    return {
      id: user.id,
      email,
      firstName: user.firstName,
      lastName: user.lastName,
      isActive: user.isActive,
      createdAt: credential.createdAt,
      updatedAt: credential.updatedAt,
      temporaryPassword,
    };
  }

  /**
   * Edits another admin's name, or deactivates/reactivates them. Refuses to
   * deactivate the caller's own account (avoids an accidental self-lockout)
   * and refuses to deactivate the last active admin (avoids locking
   * everyone out of the dashboard).
   */
  async updateAdmin(
    id: string,
    dto: UpdateAdminDto,
    callerId: string,
  ): Promise<AdminAccountSummary> {
    const credential = await this.adminCredentialRepository.findOne({
      where: { userId: id },
    });
    if (!credential) {
      throw new UserNotFoundError(id);
    }

    if (dto.isActive === false) {
      if (id === callerId) {
        throw new CannotDeactivateSelfError();
      }
      const activeAdminCount = await this.usersService.countActiveByRole(
        UserRole.ADMIN,
      );
      if (activeAdminCount <= 1) {
        throw new CannotDeactivateLastAdminError();
      }
    }

    const user = await this.usersService.update(id, dto);

    return {
      id: user.id,
      email: credential.email,
      firstName: user.firstName,
      lastName: user.lastName,
      isActive: user.isActive,
      createdAt: credential.createdAt,
      updatedAt: user.updatedAt,
    };
  }

  /**
   * Admin-for-admin password reset (e.g. a locked-out teammate) — mints a
   * fresh one-time temporary password, same handoff model as `createAdmin`.
   */
  async resetAdminPassword(id: string): Promise<{ temporaryPassword: string }> {
    const credential = await this.adminCredentialRepository.findOne({
      where: { userId: id },
    });
    if (!credential) {
      throw new UserNotFoundError(id);
    }

    const temporaryPassword = this.generateTemporaryPassword();
    credential.passwordHash = await bcrypt.hash(
      temporaryPassword,
      BCRYPT_ROUNDS,
    );
    await this.adminCredentialRepository.save(credential);
    this.logger.log(`Admin password reset by another admin: ${id}`);
    return { temporaryPassword };
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

  /** One-time handoff password for `createAdmin`/`resetAdminPassword` — meets the same complexity rule `changeAdminPassword` enforces for a new password. */
  private generateTemporaryPassword(): string {
    return `Vy${randomBytes(9).toString('hex')}!`;
  }

  private generateTokens(
    userId: string,
    role: UserRole,
    phone: string,
    email?: string,
  ) {
    const payload: TokenPayload = {
      userId,
      role,
      phone,
      ...(email && { email }),
    };
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
