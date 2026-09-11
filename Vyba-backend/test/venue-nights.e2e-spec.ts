import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication, ValidationPipe } from '@nestjs/common';
import request from 'supertest';
import { AppModule } from '../src/app.module';
import { UserRole } from '../src/common/constants/roles.constant';
import { VenueType } from '../src/modules/venues/entities/venue.entity';
import { mintTokensForRole, uniquePhone } from './utils/auth-e2e.helper';

/**
 * VenueNight e2e harness (ticket 06). Reuses ticket 04/05's auth helper for
 * tokens; drives the HTTP surface only.
 */
describe('VenueNights (e2e)', () => {
  let app: INestApplication;
  let adminToken: string;

  const inAreaCoords = { latitude: 5.285, longitude: -3.985 };

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

    ({ accessToken: adminToken } = await mintTokensForRole(
      app,
      UserRole.ADMIN,
    ));
  });

  afterAll(async () => {
    await app.close();
  });

  /** Creates an ACTIVE, in-area venue bound to a fresh VENUE_OWNER; returns both. */
  async function createOwnedActiveVenue() {
    const http = app.getHttpServer();
    const createRes = await request(http)
      .post('/api/venues')
      .set('Authorization', `Bearer ${adminToken}`)
      .send({
        name: 'Le Boony',
        venueType: VenueType.LOUNGE,
        priceLevel: 3,
        ...inAreaCoords,
      })
      .expect(201);

    await request(http)
      .patch(`/api/venues/${createRes.body.id}`)
      .set('Authorization', `Bearer ${adminToken}`)
      .send({ validationStatus: 'ACTIVE' })
      .expect(200);

    const ownerPhone = uniquePhone();
    await request(http)
      .post(`/api/venues/${createRes.body.id}/owner`)
      .set('Authorization', `Bearer ${adminToken}`)
      .send({ phone: ownerPhone })
      .expect(201);

    const { FakeSmsProvider } =
      await import('../src/common/sms/fake-sms.provider');
    await request(http)
      .post('/api/auth/request-code')
      .send({ phone: ownerPhone })
      .expect(204);
    const code = app.get(FakeSmsProvider).getLastCode(ownerPhone);
    const verifyRes = await request(http)
      .post('/api/auth/verify-code')
      .send({ phone: ownerPhone, code, ageConfirmed: true })
      .expect(200);

    return {
      venueId: createRes.body.id as string,
      ownerToken: verifyRes.body.accessToken as string,
      ownerId: verifyRes.body.user.id as string,
    };
  }

  describe('owner venue discovery', () => {
    it('lets the owner find the venue bound to them', async () => {
      const { venueId, ownerToken } = await createOwnedActiveVenue();

      const res = await request(app.getHttpServer())
        .get('/api/owner/venue')
        .set('Authorization', `Bearer ${ownerToken}`)
        .expect(200);

      expect(res.body.id).toBe(venueId);
    });

    it('404s for an owner with no bound venue', async () => {
      const { accessToken } = await mintTokensForRole(
        app,
        UserRole.VENUE_OWNER,
      );

      await request(app.getHttpServer())
        .get('/api/owner/venue')
        .set('Authorization', `Bearer ${accessToken}`)
        .expect(404);
    });

    it('rejects a CLIENT', async () => {
      const { accessToken } = await mintTokensForRole(app, UserRole.CLIENT);

      await request(app.getHttpServer())
        .get('/api/owner/venue')
        .set('Authorization', `Bearer ${accessToken}`)
        .expect(403);
    });
  });

  describe('owner set-live', () => {
    it('turns tonight live and sets liveSince/liveSetBy', async () => {
      const { venueId, ownerToken, ownerId } = await createOwnedActiveVenue();

      const res = await request(app.getHttpServer())
        .post(`/api/venues/${venueId}/live`)
        .set('Authorization', `Bearer ${ownerToken}`)
        .send({ isLive: true })
        .expect(201);

      expect(res.body.isLive).toBe(true);
      expect(res.body.liveSince).toBeDefined();
      expect(res.body.liveSetBy).toBe(ownerId);
    });

    it('toggling live twice is idempotent (liveSince unchanged)', async () => {
      const { venueId, ownerToken } = await createOwnedActiveVenue();

      const first = await request(app.getHttpServer())
        .post(`/api/venues/${venueId}/live`)
        .set('Authorization', `Bearer ${ownerToken}`)
        .send({ isLive: true })
        .expect(201);

      const second = await request(app.getHttpServer())
        .post(`/api/venues/${venueId}/live`)
        .set('Authorization', `Bearer ${ownerToken}`)
        .send({ isLive: true })
        .expect(201);

      expect(second.body.liveSince).toBe(first.body.liveSince);
    });

    it('toggling off then on again sets isLive correctly at each step', async () => {
      const { venueId, ownerToken } = await createOwnedActiveVenue();

      await request(app.getHttpServer())
        .post(`/api/venues/${venueId}/live`)
        .set('Authorization', `Bearer ${ownerToken}`)
        .send({ isLive: true })
        .expect(201);

      const off = await request(app.getHttpServer())
        .post(`/api/venues/${venueId}/live`)
        .set('Authorization', `Bearer ${ownerToken}`)
        .send({ isLive: false })
        .expect(201);
      expect(off.body.isLive).toBe(false);

      const on = await request(app.getHttpServer())
        .post(`/api/venues/${venueId}/live`)
        .set('Authorization', `Bearer ${ownerToken}`)
        .send({ isLive: true })
        .expect(201);
      expect(on.body.isLive).toBe(true);
    });

    it('rejects a different owner (403)', async () => {
      const { venueId } = await createOwnedActiveVenue();
      const { accessToken: otherOwnerToken } = await mintTokensForRole(
        app,
        UserRole.VENUE_OWNER,
      );

      await request(app.getHttpServer())
        .post(`/api/venues/${venueId}/live`)
        .set('Authorization', `Bearer ${otherOwnerToken}`)
        .send({ isLive: true })
        .expect(403);
    });

    it('rejects a CLIENT', async () => {
      const { venueId } = await createOwnedActiveVenue();
      const { accessToken: clientToken } = await mintTokensForRole(
        app,
        UserRole.CLIENT,
      );

      await request(app.getHttpServer())
        .post(`/api/venues/${venueId}/live`)
        .set('Authorization', `Bearer ${clientToken}`)
        .send({ isLive: true })
        .expect(403);
    });
  });

  describe('owner set-headline', () => {
    it('sets headline and djName', async () => {
      const { venueId, ownerToken } = await createOwnedActiveVenue();

      const res = await request(app.getHttpServer())
        .patch(`/api/venues/${venueId}/tonight`)
        .set('Authorization', `Bearer ${ownerToken}`)
        .send({ headline: 'Soirée Afrobeats', djName: 'DJ Kobo' })
        .expect(200);

      expect(res.body.headline).toBe('Soirée Afrobeats');
      expect(res.body.djName).toBe('DJ Kobo');
    });
  });

  describe('owner tonight read', () => {
    it('reads a default (not live) shape when nothing has been set yet', async () => {
      const { venueId, ownerToken } = await createOwnedActiveVenue();

      const res = await request(app.getHttpServer())
        .get(`/api/venues/${venueId}/tonight`)
        .set('Authorization', `Bearer ${ownerToken}`)
        .expect(200);

      expect(res.body).toEqual({
        isLive: false,
        liveSince: null,
        headline: null,
        djName: null,
        goingCount: 0,
      });
    });

    it('works even when the venue is not ACTIVE yet', async () => {
      const http = app.getHttpServer();
      const createRes = await request(http)
        .post('/api/venues')
        .set('Authorization', `Bearer ${adminToken}`)
        .send({
          name: 'Onboarding Venue',
          venueType: VenueType.BAR,
          priceLevel: 2,
          ...inAreaCoords,
        })
        .expect(201);
      expect(createRes.body.validationStatus).toBe('ONBOARDING');

      const ownerPhone = uniquePhone();
      await request(http)
        .post(`/api/venues/${createRes.body.id}/owner`)
        .set('Authorization', `Bearer ${adminToken}`)
        .send({ phone: ownerPhone })
        .expect(201);
      const { FakeSmsProvider } =
        await import('../src/common/sms/fake-sms.provider');
      await request(http)
        .post('/api/auth/request-code')
        .send({ phone: ownerPhone })
        .expect(204);
      const code = app.get(FakeSmsProvider).getLastCode(ownerPhone);
      const verifyRes = await request(http)
        .post('/api/auth/verify-code')
        .send({ phone: ownerPhone, code, ageConfirmed: true })
        .expect(200);

      await request(http)
        .get(`/api/venues/${createRes.body.id}/tonight`)
        .set('Authorization', `Bearer ${verifyRes.body.accessToken}`)
        .expect(200);
    });
  });

  describe('venue detail (authenticated + public)', () => {
    it('shows live + liveSince + headline once the owner goes live', async () => {
      const { venueId, ownerToken } = await createOwnedActiveVenue();
      const { accessToken: clientToken } = await mintTokensForRole(
        app,
        UserRole.CLIENT,
      );

      await request(app.getHttpServer())
        .post(`/api/venues/${venueId}/live`)
        .set('Authorization', `Bearer ${ownerToken}`)
        .send({ isLive: true })
        .expect(201);
      await request(app.getHttpServer())
        .patch(`/api/venues/${venueId}/tonight`)
        .set('Authorization', `Bearer ${ownerToken}`)
        .send({ headline: 'DJ Kobo ce soir' })
        .expect(200);

      const detail = await request(app.getHttpServer())
        .get(`/api/venues/${venueId}/detail`)
        .set('Authorization', `Bearer ${clientToken}`)
        .expect(200);

      expect(detail.body.tonight).toMatchObject({
        isLive: true,
        headline: 'DJ Kobo ce soir',
      });
      expect(detail.body.tonight.liveSince).toBeDefined();
      // No owner PII on the client-facing payload.
      expect(detail.body.owner).toBeUndefined();
      expect(detail.body.ownerUserId).toBeUndefined();
    });

    it('shows tonight: null ("rien d\'annoncé") when nothing is set', async () => {
      const { venueId } = await createOwnedActiveVenue();
      const { accessToken: clientToken } = await mintTokensForRole(
        app,
        UserRole.CLIENT,
      );

      const detail = await request(app.getHttpServer())
        .get(`/api/venues/${venueId}/detail`)
        .set('Authorization', `Bearer ${clientToken}`)
        .expect(200);

      expect(detail.body.tonight).toBeNull();
    });

    it('reflects owner toggling off again', async () => {
      const { venueId, ownerToken } = await createOwnedActiveVenue();
      const { accessToken: clientToken } = await mintTokensForRole(
        app,
        UserRole.CLIENT,
      );

      await request(app.getHttpServer())
        .post(`/api/venues/${venueId}/live`)
        .set('Authorization', `Bearer ${ownerToken}`)
        .send({ isLive: true })
        .expect(201);
      await request(app.getHttpServer())
        .post(`/api/venues/${venueId}/live`)
        .set('Authorization', `Bearer ${ownerToken}`)
        .send({ isLive: false })
        .expect(201);

      const detail = await request(app.getHttpServer())
        .get(`/api/venues/${venueId}/detail`)
        .set('Authorization', `Bearer ${clientToken}`)
        .expect(200);

      expect(detail.body.tonight.isLive).toBe(false);
    });

    it('the unauthenticated /public path returns the same shape', async () => {
      const { venueId } = await createOwnedActiveVenue();

      const detail = await request(app.getHttpServer())
        .get(`/api/venues/${venueId}/public`)
        .expect(200);

      expect(detail.body.id).toBe(venueId);
      expect(detail.body.tonight).toBeNull();
      expect(detail.body.owner).toBeUndefined();
    });

    it('404s for a venue that is not ACTIVE', async () => {
      const createRes = await request(app.getHttpServer())
        .post('/api/venues')
        .set('Authorization', `Bearer ${adminToken}`)
        .send({
          name: 'Not Active Venue',
          venueType: VenueType.MAQUIS,
          priceLevel: 1,
          ...inAreaCoords,
        })
        .expect(201);

      await request(app.getHttpServer())
        .get(`/api/venues/${createRes.body.id}/public`)
        .expect(404);
    });
  });
});
