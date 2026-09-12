import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication, ValidationPipe } from '@nestjs/common';
import request from 'supertest';
import { AppModule } from '../src/app.module';
import { UserRole } from '../src/common/constants/roles.constant';
import { VenueType } from '../src/modules/venues/entities/venue.entity';
import { mintTokensForRole, uniquePhone } from './utils/auth-e2e.helper';

/**
 * Dashboard content-composer e2e harness (ticket 13): the editorial
 * draft/publish/edit lifecycle, the admin assist-promo path (origin =
 * founder_assisted), the admin content list, hard delete, and the
 * per-venue organic-vs-assisted metric.
 */
describe('Content composer (e2e)', () => {
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

  function farFutureIso(hours = 48): string {
    return new Date(Date.now() + hours * 3600 * 1000).toISOString();
  }

  async function createOwnedActiveVenue(name: string) {
    const http = app.getHttpServer();
    const createRes = await request(http)
      .post('/api/venues')
      .set('Authorization', `Bearer ${adminToken}`)
      .send({
        name,
        venueType: VenueType.LOUNGE,
        priceLevel: 2,
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
    };
  }

  describe('editorial lifecycle', () => {
    it('a draft editorial is not in the public feed until published', async () => {
      const http = app.getHttpServer();
      const createRes = await request(http)
        .post('/api/feed/editorial')
        .set('Authorization', `Bearer ${adminToken}`)
        .send({
          title: 'Draft Item',
          body: 'not yet',
          expiresAt: farFutureIso(),
          draft: true,
        })
        .expect(201);
      expect(createRes.body.status).toBe('DRAFT');

      const beforePublish = await request(http)
        .get('/api/feed/public')
        .expect(200);
      expect(
        (beforePublish.body as Array<{ id: string }>).some(
          (i) => i.id === createRes.body.id,
        ),
      ).toBe(false);

      await request(http)
        .patch(`/api/feed/${createRes.body.id}/publish`)
        .set('Authorization', `Bearer ${adminToken}`)
        .expect(200);

      const afterPublish = await request(http)
        .get('/api/feed/public')
        .expect(200);
      expect(
        (afterPublish.body as Array<{ id: string }>).some(
          (i) => i.id === createRes.body.id,
        ),
      ).toBe(true);
    });

    it("edits an editorial item's title/body/expiry", async () => {
      const http = app.getHttpServer();
      const createRes = await request(http)
        .post('/api/feed/editorial')
        .set('Authorization', `Bearer ${adminToken}`)
        .send({
          title: 'Original Title',
          body: 'Original body',
          expiresAt: farFutureIso(),
        })
        .expect(201);

      const updateRes = await request(http)
        .patch(`/api/feed/editorial/${createRes.body.id}`)
        .set('Authorization', `Bearer ${adminToken}`)
        .send({ title: 'Updated Title' })
        .expect(200);

      expect(updateRes.body.payload.title).toBe('Updated Title');
      expect(updateRes.body.payload.body).toBe('Original body');
    });

    it('rejects a non-admin from creating, editing or publishing editorial', async () => {
      const { accessToken: clientToken } = await mintTokensForRole(
        app,
        UserRole.CLIENT,
      );
      const http = app.getHttpServer();

      await request(http)
        .post('/api/feed/editorial')
        .set('Authorization', `Bearer ${clientToken}`)
        .send({ title: 'x', body: 'y', expiresAt: farFutureIso() })
        .expect(403);
    });
  });

  describe('assist mode', () => {
    it('assist-creates a promo for a venue → origin=founder_assisted, assisted=true, no client-controlled origin', async () => {
      const { venueId } = await createOwnedActiveVenue('Assist Promo Venue');
      const http = app.getHttpServer();

      // `CreatePromoDto` has no `origin`/`assisted` field at all — combined
      // with the app's `forbidNonWhitelisted` pipe, a client literally
      // cannot send either; origin/assisted are 100% backend-derived.
      const createRes = await request(http)
        .post(`/api/feed/venue/${venueId}/promo/assist`)
        .set('Authorization', `Bearer ${adminToken}`)
        .send({
          title: 'Happy hour -30%',
          description: 'Assist-created on behalf of the venue',
        })
        .expect(201);

      expect(createRes.body.origin).toBe('FOUNDER_ASSISTED');
      expect(createRes.body.assisted).toBe(true);
      expect(createRes.body.createdByUserId).toBeDefined();

      const feedRes = await request(http).get('/api/feed/public').expect(200);
      expect(
        (feedRes.body as Array<{ id: string; venue?: { id: string } }>).some(
          (i) => i.id === createRes.body.id && i.venue?.id === venueId,
        ),
      ).toBe(true);
    });

    it('rejects a non-admin from using the assist path', async () => {
      const { venueId, ownerToken } =
        await createOwnedActiveVenue('Assist Guard Venue');

      // Even the venue's own owner can't use the assist path — only ADMIN.
      await request(app.getHttpServer())
        .post(`/api/feed/venue/${venueId}/promo/assist`)
        .set('Authorization', `Bearer ${ownerToken}`)
        .send({ title: 'x', description: 'y' })
        .expect(403);
    });
  });

  describe('admin content list + moderation', () => {
    it('lists items regardless of status, filterable by type', async () => {
      const http = app.getHttpServer();
      const draftRes = await request(http)
        .post('/api/feed/editorial')
        .set('Authorization', `Bearer ${adminToken}`)
        .send({
          title: 'Admin List Draft',
          body: 'x',
          expiresAt: farFutureIso(),
          draft: true,
        })
        .expect(201);

      const listRes = await request(http)
        .get('/api/feed/admin')
        .query({ type: 'EDITORIAL' })
        .set('Authorization', `Bearer ${adminToken}`)
        .expect(200);

      expect(
        (listRes.body as Array<{ id: string; status: string }>).some(
          (i) => i.id === draftRes.body.id && i.status === 'DRAFT',
        ),
      ).toBe(true);
    });

    it('hard-deletes a feed item', async () => {
      const http = app.getHttpServer();
      const createRes = await request(http)
        .post('/api/feed/editorial')
        .set('Authorization', `Bearer ${adminToken}`)
        .send({
          title: 'To Be Deleted',
          body: 'x',
          expiresAt: farFutureIso(),
        })
        .expect(201);

      await request(http)
        .delete(`/api/feed/${createRes.body.id}`)
        .set('Authorization', `Bearer ${adminToken}`)
        .expect(200);

      const listRes = await request(http)
        .get('/api/feed/admin')
        .set('Authorization', `Bearer ${adminToken}`)
        .expect(200);
      expect(
        (listRes.body as Array<{ id: string }>).some(
          (i) => i.id === createRes.body.id,
        ),
      ).toBe(false);
    });
  });

  describe('per-venue organic-vs-assisted metric', () => {
    it('reads "1 assisted / 0 organic" after an assist-created promo', async () => {
      const { venueId } = await createOwnedActiveVenue('Metrics Panel Venue');
      const http = app.getHttpServer();

      await request(http)
        .post(`/api/feed/venue/${venueId}/promo/assist`)
        .set('Authorization', `Bearer ${adminToken}`)
        .send({ title: 'Assisted Promo', description: 'x' })
        .expect(201);

      const metricsRes = await request(http)
        .get(`/api/metrics/venue/${venueId}/organic-vs-assisted`)
        .set('Authorization', `Bearer ${adminToken}`)
        .expect(200);

      expect(metricsRes.body).toEqual({ organic: 0, assisted: 1 });
    });

    it('rejects a non-admin from reading the metric', async () => {
      const { venueId } = await createOwnedActiveVenue('Metrics Guard Venue');
      const { accessToken: clientToken } = await mintTokensForRole(
        app,
        UserRole.CLIENT,
      );

      await request(app.getHttpServer())
        .get(`/api/metrics/venue/${venueId}/organic-vs-assisted`)
        .set('Authorization', `Bearer ${clientToken}`)
        .expect(403);
    });
  });
});
