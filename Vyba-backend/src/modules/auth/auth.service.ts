import { Injectable, Logger } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';
import { UsersService } from '../users/users.service';
import { UserRole } from '@common/constants/roles.constant';
import { InvalidTokenError } from '@common/exceptions/auth.exceptions';
import {
  getJWTRefreshSecret,
  JWT_EXPIRES_IN,
  JWT_REFRESH_TOKEN_EXPIRES_IN,
} from '@common/config/auth.config';

interface RefreshTokenPayload {
  userId: string;
  role: UserRole;
}

/**
 * Session issuance and refresh. Identity is established by the phone-OTP flow
 * (ticket 04); this service only mints and rotates JWTs once a principal exists.
 */
@Injectable()
export class AuthService {
  private readonly logger = new Logger(AuthService.name);

  constructor(
    private readonly usersService: UsersService,
    private readonly jwtService: JwtService,
    private readonly configService: ConfigService,
  ) {}

  async refreshToken(refreshToken: string) {
    try {
      const refreshSecret = getJWTRefreshSecret(this.configService);
      const payload = this.jwtService.verify<RefreshTokenPayload>(
        refreshToken,
        {
          secret: refreshSecret,
        },
      );

      const user = await this.usersService.findOne(payload.userId);
      const tokens = this.generateTokens(user.id, user.role);

      return { user: user.toJSON(), ...tokens };
    } catch {
      throw new InvalidTokenError('Invalid or expired refresh token');
    }
  }

  private generateTokens(userId: string, role: UserRole) {
    const payload = { userId, role };
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
