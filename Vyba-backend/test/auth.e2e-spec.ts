process.env.OTP_RESEND_COOLDOWN_SECONDS = '1';
process.env.OTP_CODE_TTL_SECONDS = '2';
// Every case in this suite shares 127.0.0.1 as its source IP; raise the IP
// ceiling so only the dedicated per-phone rate-limit test exercises limiting.
process.env.OTP_IP_RATE_LIMIT_MAX = '1000';

import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication, ValidationPipe } from '@nestjs/common';
import { getRepositoryToken } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import request from 'supertest';
import { AppModule } from '../src/app.module';
import { User } from '../src/modules/users/entities/user.entity';
import { UserRole } from '../src/common/constants/roles.constant';
import { FakeSmsProvider } from '../src/common/sms/fake-sms.provider';
import {
  mintTokensForRole,
  signInClient,
  sleep,
  uniquePhone,
} from './utils/auth-e2e.helper';

/**
 * Reusable phone-OTP e2e harness (ticket 04). Boots the real app, drives the
 * HTTP surface only (no reaching into Redis/JWT internals), and uses
 * `FakeSmsProvider` to "receive" codes. `OTP_RESEND_COOLDOWN_SECONDS` /
 * `OTP_CODE_TTL_SECONDS` are shortened via env so timing-dependent cases run
 * in seconds instead of minutes — see otp-store.service.ts's `tunable()`.
 */
describe('Auth (e2e)', () => {
  let app: INestApplication;

  beforeAll(async () => {
    const moduleFixture: TestingModule = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();

    app = moduleFixture.createNestApplication();
    app.useGlobalPipes(
      new ValidationPipe({
        whitelist: true,
        transform: true,
        forbidNonWhitelisted: true,
      }),
    );
    await app.init();
  });

  afterAll(async () => {
    await app.close();
  });

  describe('request-code -> verify-code -> protected route', () => {
    it('signs a new user in and the token works on a protected route', async () => {
      const { accessToken, body } = await signInClient(app);

      expect(body.user.role).toBe(UserRole.CLIENT);
      expect(body.user.phone).toBeDefined();
      expect(body.accessToken).toBeDefined();
      expect(body.refreshToken).toBeDefined();

      await request(app.getHttpServer())
        .get('/api/users')
        .set('Authorization', `Bearer ${accessToken}`)
        .expect(200);
    });

    it('never returns the code and never reveals whether the number is known', async () => {
      const res = await request(app.getHttpServer())
        .post('/api/auth/request-code')
        .send({ phone: uniquePhone() })
        .expect(204);

      expect(res.body).toEqual({});
    });

    it('records the 18+ confirmation on first verify only', async () => {
      const { phone } = await signInClient(app, { ageConfirmed: true });

      await sleep(1300);
      await request(app.getHttpServer())
        .post('/api/auth/request-code')
        .send({ phone })
        .expect(204);
      const secondCode = app.get(FakeSmsProvider).getLastCode(phone);

      const res = await request(app.getHttpServer())
        .post('/api/auth/verify-code')
        .send({ phone, code: secondCode })
        .expect(200);

      expect(res.body.user.phone).toBe(phone);
    });

    it('same phone verified twice resolves to the same user id', async () => {
      const first = await signInClient(app);

      await sleep(1300);
      await request(app.getHttpServer())
        .post('/api/auth/request-code')
        .send({ phone: first.phone })
        .expect(204);
      const code = app.get(FakeSmsProvider).getLastCode(first.phone);

      const second = await request(app.getHttpServer())
        .post('/api/auth/verify-code')
        .send({ phone: first.phone, code })
        .expect(200);

      expect(second.body.user.id).toBe(first.body.user.id);
    });
  });

  describe('wrong / expired codes', () => {
    it('rejects a wrong code', async () => {
      const phone = uniquePhone();
      await request(app.getHttpServer())
        .post('/api/auth/request-code')
        .send({ phone })
        .expect(204);

      await request(app.getHttpServer())
        .post('/api/auth/verify-code')
        .send({ phone, code: '000000', ageConfirmed: true })
        .expect(401);
    });

    it('rejects an expired code', async () => {
      const phone = uniquePhone();
      await request(app.getHttpServer())
        .post('/api/auth/request-code')
        .send({ phone })
        .expect(204);
      const code = app.get(FakeSmsProvider).getLastCode(phone);

      await sleep(2200);

      await request(app.getHttpServer())
        .post('/api/auth/verify-code')
        .send({ phone, code, ageConfirmed: true })
        .expect(401);
    });

    it('invalidates the code after too many wrong attempts', async () => {
      const phone = uniquePhone();
      await request(app.getHttpServer())
        .post('/api/auth/request-code')
        .send({ phone })
        .expect(204);
      const code = app.get(FakeSmsProvider).getLastCode(phone);

      for (let i = 0; i < 4; i += 1) {
        await request(app.getHttpServer())
          .post('/api/auth/verify-code')
          .send({ phone, code: '000000', ageConfirmed: true })
          .expect(401);
      }
      // 5th wrong attempt invalidates the code entirely.
      await request(app.getHttpServer())
        .post('/api/auth/verify-code')
        .send({ phone, code: '000000', ageConfirmed: true })
        .expect(401);

      // Even the correct code no longer works — it was invalidated.
      await request(app.getHttpServer())
        .post('/api/auth/verify-code')
        .send({ phone, code, ageConfirmed: true })
        .expect(401);
    });
  });

  describe('resend / rate limiting', () => {
    it('refuses a resend before the cooldown elapses', async () => {
      const phone = uniquePhone();
      await request(app.getHttpServer())
        .post('/api/auth/request-code')
        .send({ phone })
        .expect(204);

      await request(app.getHttpServer())
        .post('/api/auth/request-code')
        .send({ phone })
        .expect(429);
    });

    it('a resend after the cooldown supersedes the old code', async () => {
      const phone = uniquePhone();
      await request(app.getHttpServer())
        .post('/api/auth/request-code')
        .send({ phone })
        .expect(204);
      const firstCode = app.get(FakeSmsProvider).getLastCode(phone);

      await sleep(1300);

      await request(app.getHttpServer())
        .post('/api/auth/request-code')
        .send({ phone })
        .expect(204);
      const secondCode = app.get(FakeSmsProvider).getLastCode(phone);

      expect(secondCode).not.toBe(firstCode);

      await request(app.getHttpServer())
        .post('/api/auth/verify-code')
        .send({ phone, code: firstCode, ageConfirmed: true })
        .expect(401);

      await request(app.getHttpServer())
        .post('/api/auth/verify-code')
        .send({ phone, code: secondCode, ageConfirmed: true })
        .expect(200);
    });

    it('trips the per-phone rate limit after repeated requests', async () => {
      const phone = uniquePhone();

      for (let i = 0; i < 5; i += 1) {
        await request(app.getHttpServer())
          .post('/api/auth/request-code')
          .send({ phone })
          .expect(204);
        await sleep(1300);
      }

      await request(app.getHttpServer())
        .post('/api/auth/request-code')
        .send({ phone })
        .expect(429);
    }, 15000);
  });

  describe('age confirmation', () => {
    it('requires 18+ confirmation on a brand-new phone', async () => {
      const phone = uniquePhone();
      await request(app.getHttpServer())
        .post('/api/auth/request-code')
        .send({ phone })
        .expect(204);
      const code = app.get(FakeSmsProvider).getLastCode(phone);

      await request(app.getHttpServer())
        .post('/api/auth/verify-code')
        .send({ phone, code })
        .expect(400);
    });
  });

  describe('deactivated account', () => {
    it('cannot verify', async () => {
      const { user } = await mintTokensForRole(app, UserRole.CLIENT);
      const phone = user.phone;

      const repo = app.get<Repository<User>>(getRepositoryToken(User));
      await repo.update(user.id, { isActive: false });

      await request(app.getHttpServer())
        .post('/api/auth/request-code')
        .send({ phone })
        .expect(204);
      const code = app.get(FakeSmsProvider).getLastCode(phone);

      await request(app.getHttpServer())
        .post('/api/auth/verify-code')
        .send({ phone, code, ageConfirmed: true })
        .expect(403);
    });
  });

  describe('refresh', () => {
    it('rotates the access token and the new one works on a protected route', async () => {
      const { refreshToken } = await signInClient(app);

      const res = await request(app.getHttpServer())
        .post('/api/auth/refresh')
        .send({ refreshToken })
        .expect(200);

      expect(res.body.accessToken).toBeDefined();

      await request(app.getHttpServer())
        .get('/api/users')
        .set('Authorization', `Bearer ${res.body.accessToken}`)
        .expect(200);
    });
  });

  describe('role provisioning helper (for units 5+ to reuse)', () => {
    it('mints working OWNER and ADMIN tokens without the OTP round trip', async () => {
      const owner = await mintTokensForRole(app, UserRole.VENUE_OWNER);
      const admin = await mintTokensForRole(app, UserRole.ADMIN);

      await request(app.getHttpServer())
        .get('/api/users')
        .set('Authorization', `Bearer ${owner.accessToken}`)
        .expect(200);

      await request(app.getHttpServer())
        .get('/api/users')
        .set('Authorization', `Bearer ${admin.accessToken}`)
        .expect(200);
    });
  });
});
