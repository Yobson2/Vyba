import { INestApplication } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';
import { getRepositoryToken } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import request from 'supertest';
import { User } from '../../src/modules/users/entities/user.entity';
import { UserRole } from '../../src/common/constants/roles.constant';
import {
  getJWTRefreshSecret,
  JWT_EXPIRES_IN,
  JWT_REFRESH_TOKEN_EXPIRES_IN,
} from '../../src/common/config/auth.config';
import { FakeSmsProvider } from '../../src/common/sms/fake-sms.provider';

let phoneSeq = 0;

/** A fresh, collision-free E.164 test number on every call. */
export function uniquePhone(): string {
  phoneSeq += 1;
  return `+225070${(1000000 + phoneSeq).toString().slice(1)}`;
}

/**
 * Mints a valid access+refresh token pair directly (no HTTP round trip) for a
 * given role, seeding the user row first. For CLIENT sign-in exercised
 * through the real HTTP flow, use `signInClient` instead — venue-owner and
 * admin accounts are team-provisioned, not self-serve (ADR-0003), so this is
 * the realistic path for OWNER/ADMIN tokens in other tickets' e2e specs.
 */
export async function mintTokensForRole(
  app: INestApplication,
  role: UserRole,
): Promise<{ accessToken: string; refreshToken: string; user: User }> {
  const repo = app.get<Repository<User>>(getRepositoryToken(User));
  const jwt = app.get(JwtService);
  const config = app.get(ConfigService);

  const user = await repo.save(
    repo.create({ phone: uniquePhone(), role, ageConfirmedAt: new Date() }),
  );

  const payload = { userId: user.id, role: user.role, phone: user.phone };
  const accessToken = jwt.sign(payload, { expiresIn: JWT_EXPIRES_IN });
  const refreshToken = jwt.sign(payload, {
    secret: getJWTRefreshSecret(config),
    expiresIn: JWT_REFRESH_TOKEN_EXPIRES_IN,
  });

  return { accessToken, refreshToken, user };
}

/** Drives the real request-code -> verify-code HTTP flow for a fresh CLIENT phone. */
export async function signInClient(
  app: INestApplication,
  overrides: {
    phone?: string;
    ageConfirmed?: boolean;
    clientId?: string;
  } = {},
): Promise<{
  accessToken: string;
  refreshToken: string;
  phone: string;
  body: request.Response['body'];
}> {
  const phone = overrides.phone ?? uniquePhone();
  const http = app.getHttpServer();

  await request(http)
    .post('/api/auth/request-code')
    .send({ phone })
    .expect(204);

  const fakeSms = app.get(FakeSmsProvider);
  const code = fakeSms.getLastCode(phone);
  if (!code) {
    throw new Error(`FakeSmsProvider recorded no code for ${phone}`);
  }

  const res = await request(http)
    .post('/api/auth/verify-code')
    .send({
      phone,
      code,
      ageConfirmed: overrides.ageConfirmed ?? true,
      ...(overrides.clientId ? { clientId: overrides.clientId } : {}),
    })
    .expect(200);

  return {
    accessToken: res.body.accessToken,
    refreshToken: res.body.refreshToken,
    phone,
    body: res.body,
  };
}

export function sleep(ms: number): Promise<void> {
  return new Promise((resolve) => setTimeout(resolve, ms));
}
