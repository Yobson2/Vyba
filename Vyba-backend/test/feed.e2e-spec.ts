import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication, ValidationPipe } from '@nestjs/common';
import request from 'supertest';
import { AppModule } from '../src/app.module';
import { UserRole } from '../src/common/constants/roles.constant';
import { VenueType } from '../src/modules/venues/entities/venue.entity';
import { mintTokensForRole, uniquePhone } from './utils/auth-e2e.helper';

/**
 * Feed e2e harness (ticket 07). Covers the ticket's actual scope —
 * live_tonight (auto, via ticket 06's set-live) + editorial (admin) — and
 * the ranking/membership rules. Reuses ticket 04/05/06 helpers for fixtures.
 */
describe('Feed (e2e)', () => {
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

  function farFutureIso(hours = 48): string {
    return new Date(Date.now() + hours * 3600 * 1000).toISOString();
  }

  describe('editorial', () => {
    it('admin creates an editorial item and it appears in the feed', async () => {
      const { accessToken: clientToken } = await mintTokensForRole(
        app,
        UserRole.CLIENT,
      );

      const createRes = await request(app.getHttpServer())
        .post('/api/feed/editorial')
        .set('Authorization', `Bearer ${adminToken}`)
        .send({
          title: 'Ce soir à Zone 4',
          body: '5 spots chauds ce soir.',
          expiresAt: farFutureIso(),
        })
        .expect(201);

      const feedRes = await request(app.getHttpServer())
        .get('/api/feed')
        .set('Authorization', `Bearer ${clientToken}`)
        .expect(200);

      expect(
        (
          feedRes.body as Array<{ id: string; payload: { title: string } }>
        ).some(
          (i) =>
            i.id === createRes.body.id &&
            i.payload.title === 'Ce soir à Zone 4',
        ),
      ).toBe(true);
    });

    it('rejects a non-admin from creating editorial', async () => {
      const { accessToken: clientToken } = await mintTokensForRole(
        app,
        UserRole.CLIENT,
      );

      await request(app.getHttpServer())
        .post('/api/feed/editorial')
        .set('Authorization', `Bearer ${clientToken}`)
        .send({ title: 'x', body: 'y', expiresAt: farFutureIso() })
        .expect(403);
    });

    it('does not return an editorial scheduled in the future', async () => {
      const createRes = await request(app.getHttpServer())
        .post('/api/feed/editorial')
        .set('Authorization', `Bearer ${adminToken}`)
        .send({
          title: 'Scheduled Later',
          body: 'not yet',
          publishedAt: farFutureIso(24),
          expiresAt: farFutureIso(48),
        })
        .expect(201);

      const feedRes = await request(app.getHttpServer())
        .get('/api/feed/public')
        .expect(200);

      expect(
        (feedRes.body as Array<{ id: string }>).some(
          (i) => i.id === createRes.body.id,
        ),
      ).toBe(false);
    });

    it('does not return an already-expired editorial', async () => {
      const createRes = await request(app.getHttpServer())
        .post('/api/feed/editorial')
        .set('Authorization', `Bearer ${adminToken}`)
        .send({
          title: 'Already Expired',
          body: 'stale',
          expiresAt: new Date(Date.now() - 1000).toISOString(),
        })
        .expect(201);

      const feedRes = await request(app.getHttpServer())
        .get('/api/feed/public')
        .expect(200);

      expect(
        (feedRes.body as Array<{ id: string }>).some(
          (i) => i.id === createRes.body.id,
        ),
      ).toBe(false);
    });

    it('a hidden editorial is not returned, and unhide brings it back', async () => {
      const createRes = await request(app.getHttpServer())
        .post('/api/feed/editorial')
        .set('Authorization', `Bearer ${adminToken}`)
        .send({
          title: 'To Be Hidden',
          body: 'shh',
          expiresAt: farFutureIso(),
        })
        .expect(201);

      await request(app.getHttpServer())
        .patch(`/api/feed/${createRes.body.id}/hide`)
        .set('Authorization', `Bearer ${adminToken}`)
        .expect(200);

      const hiddenFeed = await request(app.getHttpServer())
        .get('/api/feed/public')
        .expect(200);
      expect(
        (hiddenFeed.body as Array<{ id: string }>).some(
          (i) => i.id === createRes.body.id,
        ),
      ).toBe(false);

      await request(app.getHttpServer())
        .patch(`/api/feed/${createRes.body.id}/unhide`)
        .set('Authorization', `Bearer ${adminToken}`)
        .expect(200);

      const restoredFeed = await request(app.getHttpServer())
        .get('/api/feed/public')
        .expect(200);
      expect(
        (restoredFeed.body as Array<{ id: string }>).some(
          (i) => i.id === createRes.body.id,
        ),
      ).toBe(true);
    });
  });

  describe('live_tonight (ticket 06 integration)', () => {
    it('marking a venue live creates a feed item ranked above editorial', async () => {
      const { venueId, ownerToken } =
        await createOwnedActiveVenue('Live Ranking Venue');
      const { accessToken: clientToken } = await mintTokensForRole(
        app,
        UserRole.CLIENT,
      );

      const editorialRes = await request(app.getHttpServer())
        .post('/api/feed/editorial')
        .set('Authorization', `Bearer ${adminToken}`)
        .send({
          title: 'Evergreen Note',
          body: 'always here',
          expiresAt: farFutureIso(24 * 30),
        })
        .expect(201);

      await request(app.getHttpServer())
        .post(`/api/venues/${venueId}/live`)
        .set('Authorization', `Bearer ${ownerToken}`)
        .send({ isLive: true })
        .expect(201);

      const feedRes = await request(app.getHttpServer())
        .get('/api/feed')
        .set('Authorization', `Bearer ${clientToken}`)
        .expect(200);

      const items = feedRes.body as Array<{
        id: string;
        type: string;
        venue?: { id: string };
      }>;
      const liveIndex = items.findIndex(
        (i) => i.type === 'LIVE_TONIGHT' && i.venue?.id === venueId,
      );
      const editorialIndex = items.findIndex(
        (i) => i.id === editorialRes.body.id,
      );

      expect(liveIndex).toBeGreaterThanOrEqual(0);
      expect(editorialIndex).toBeGreaterThanOrEqual(0);
      expect(liveIndex).toBeLessThan(editorialIndex);
    });

    it('toggling live off hides the feed item; toggling on again republishes the same item', async () => {
      const { venueId, ownerToken } =
        await createOwnedActiveVenue('Toggle Venue');

      await request(app.getHttpServer())
        .post(`/api/venues/${venueId}/live`)
        .set('Authorization', `Bearer ${ownerToken}`)
        .send({ isLive: true })
        .expect(201);

      const afterOn = await request(app.getHttpServer())
        .get('/api/feed/public')
        .expect(200);
      const onItem = (
        afterOn.body as Array<{
          id: string;
          type: string;
          venue?: { id: string };
        }>
      ).find((i) => i.type === 'LIVE_TONIGHT' && i.venue?.id === venueId);
      expect(onItem).toBeDefined();

      await request(app.getHttpServer())
        .post(`/api/venues/${venueId}/live`)
        .set('Authorization', `Bearer ${ownerToken}`)
        .send({ isLive: false })
        .expect(201);

      const afterOff = await request(app.getHttpServer())
        .get('/api/feed/public')
        .expect(200);
      expect(
        (afterOff.body as Array<{ id: string }>).some(
          (i) => i.id === onItem!.id,
        ),
      ).toBe(false);

      await request(app.getHttpServer())
        .post(`/api/venues/${venueId}/live`)
        .set('Authorization', `Bearer ${ownerToken}`)
        .send({ isLive: true })
        .expect(201);

      const afterOnAgain = await request(app.getHttpServer())
        .get('/api/feed/public')
        .expect(200);
      const items = afterOnAgain.body as Array<{ id: string }>;
      expect(items.some((i) => i.id === onItem!.id)).toBe(true);
      // Same item republished, not duplicated.
      expect(items.filter((i) => i.id === onItem!.id)).toHaveLength(1);
    });

    it('a live venue outside the launch area never appears in the feed', async () => {
      const http = app.getHttpServer();
      const createRes = await request(http)
        .post('/api/venues')
        .set('Authorization', `Bearer ${adminToken}`)
        .send({
          name: 'Out Of Area Venue',
          venueType: VenueType.BAR,
          priceLevel: 1,
          latitude: 5.32,
          longitude: -4.02,
        })
        .expect(201);
      expect(createRes.body.inLaunchArea).toBe(false);

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

      await request(http)
        .post(`/api/venues/${createRes.body.id}/live`)
        .set('Authorization', `Bearer ${verifyRes.body.accessToken}`)
        .send({ isLive: true })
        .expect(201);

      const feedRes = await request(http).get('/api/feed/public').expect(200);
      expect(
        (feedRes.body as Array<{ venue?: { id: string } }>).some(
          (i) => i.venue?.id === createRes.body.id,
        ),
      ).toBe(false);
    });
  });

  describe('promo (ticket 09)', () => {
    it('owner creates a promo → appears in the feed as origin=venue, assisted=false, and on the venue page', async () => {
      const { venueId, ownerToken } =
        await createOwnedActiveVenue('Promo Venue');

      const createRes = await request(app.getHttpServer())
        .post(`/api/feed/venue/${venueId}/promo`)
        .set('Authorization', `Bearer ${ownerToken}`)
        .send({
          title: 'Happy hour -50% jusqu’à 23h',
          description: 'Sur tous les cocktails, ce soir seulement.',
        })
        .expect(201);

      expect(createRes.body.origin).toBe('VENUE');
      expect(createRes.body.assisted).toBe(false);
      expect(createRes.body.createdByUserId).toBeDefined();

      const feedRes = await request(app.getHttpServer())
        .get('/api/feed/public')
        .expect(200);
      expect(
        (
          feedRes.body as Array<{
            id: string;
            type: string;
            venue?: { id: string };
          }>
        ).some(
          (i) =>
            i.id === createRes.body.id &&
            i.type === 'PROMO' &&
            i.venue?.id === venueId,
        ),
      ).toBe(true);

      const detailRes = await request(app.getHttpServer())
        .get(`/api/venues/${venueId}/public`)
        .expect(200);
      expect(
        (detailRes.body.promos as Array<{ id: string; title: string }>).some(
          (p) => p.id === createRes.body.id && p.title.includes('Happy hour'),
        ),
      ).toBe(true);
    });

    it('rejects an owner creating a promo for a venue they do not own', async () => {
      const { venueId } = await createOwnedActiveVenue('Someone Elses Venue');
      const { ownerToken: otherOwnerToken } = await createOwnedActiveVenue(
        'Another Owned Venue',
      );

      await request(app.getHttpServer())
        .post(`/api/feed/venue/${venueId}/promo`)
        .set('Authorization', `Bearer ${otherOwnerToken}`)
        .send({ title: 'Not mine', description: 'should fail' })
        .expect(403);
    });

    it('rejects a non-owner role from creating a promo', async () => {
      const { venueId } = await createOwnedActiveVenue('Client Blocked Venue');
      const { accessToken: clientToken } = await mintTokensForRole(
        app,
        UserRole.CLIENT,
      );

      await request(app.getHttpServer())
        .post(`/api/feed/venue/${venueId}/promo`)
        .set('Authorization', `Bearer ${clientToken}`)
        .send({ title: 'Nope', description: 'client cannot post' })
        .expect(403);
    });
  });

  describe('unauthenticated access', () => {
    it('rejects an unauthenticated request to the authenticated feed endpoint', async () => {
      await request(app.getHttpServer()).get('/api/feed').expect(401);
    });

    it('allows an unauthenticated request to the public feed endpoint', async () => {
      await request(app.getHttpServer()).get('/api/feed/public').expect(200);
    });
  });
});
