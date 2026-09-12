import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication, ValidationPipe } from '@nestjs/common';
import { getRepositoryToken } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import request from 'supertest';
import { AppModule } from '../src/app.module';
import { User } from '../src/modules/users/entities/user.entity';
import { UserRole } from '../src/common/constants/roles.constant';
import { VenueType } from '../src/modules/venues/entities/venue.entity';
import { FakePostHogClient } from '../src/common/posthog/fake-posthog-client';
import { MetricsService } from '../src/modules/metrics/metrics.service';
import {
  mintTokensForRole,
  signInClient,
  uniquePhone,
} from './utils/auth-e2e.helper';

/**
 * Attribution + analytics-proxy e2e harness (ticket 11). Drives landing →
 * signup → actions over HTTP and asserts the recorded attribution and the
 * derived `activeZone`; a `FakePostHogClient` captures every forwarded
 * payload for assertion. Reuses tickets 04/05/09's helpers/fixtures.
 */
describe('Attribution + Analytics (e2e)', () => {
  let app: INestApplication;
  let adminToken: string;
  let userRepository: Repository<User>;
  let fakePostHog: FakePostHogClient;

  const inAreaCoords = { latitude: 5.285, longitude: -3.985 };
  const outOfAreaCoords = { latitude: 5.32, longitude: -4.02 };

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

    userRepository = app.get<Repository<User>>(getRepositoryToken(User));
    fakePostHog = app.get(FakePostHogClient);

    ({ accessToken: adminToken } = await mintTokensForRole(
      app,
      UserRole.ADMIN,
    ));
  });

  afterEach(() => {
    fakePostHog.clear();
  });

  afterAll(async () => {
    await app.close();
  });

  async function createActiveVenue(
    name: string,
    coords: { latitude: number; longitude: number } = inAreaCoords,
  ) {
    const http = app.getHttpServer();
    const createRes = await request(http)
      .post('/api/venues')
      .set('Authorization', `Bearer ${adminToken}`)
      .send({ name, venueType: VenueType.BAR, priceLevel: 2, ...coords })
      .expect(201);

    await request(http)
      .patch(`/api/venues/${createRes.body.id}`)
      .set('Authorization', `Bearer ${adminToken}`)
      .send({ validationStatus: 'ACTIVE' })
      .expect(200);

    return createRes.body.id as string;
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

  describe('attribution', () => {
    it('a QR landing then signup produces a correct first-touch snapshot, and raw events are retained', async () => {
      const http = app.getHttpServer();
      const venueId = await createActiveVenue('Attribution QR Venue');
      const clientId = `client-${Date.now()}-${Math.random()}`;

      await request(http)
        .post('/api/attribution/landing')
        .send({ src: 'qr', venueId, surface: 'app', clientId })
        .expect(201);

      const phone = uniquePhone();
      await signInClient(app, { phone, clientId });

      const user = await userRepository.findOne({ where: { phone } });
      expect(user?.acquisitionSource).toBe('qr');
      expect(user?.acquisitionVenueId).toBe(venueId);
      expect(user?.acquisitionZone).toBe('zone_4');
      expect(user?.activeZone).toBeNull();
      expect(user?.firstLandingAt).toBeTruthy();

      // Raw landing event is still queryable after the snapshot is written.
      const landingRepository = app.get<Repository<{ clientId: string }>>(
        getRepositoryToken(
          (
            await import('../src/modules/attribution/entities/landing-event.entity')
          ).LandingEvent,
        ),
      );
      const landings = await landingRepository.find({ where: { clientId } });
      expect(landings).toHaveLength(1);
    });

    it('a promoter landing sets acquisitionPromoterId', async () => {
      const http = app.getHttpServer();
      const { user: promoter } = await mintTokensForRole(app, UserRole.CLIENT);
      const clientId = `client-${Date.now()}-${Math.random()}`;

      await request(http)
        .post('/api/attribution/landing')
        .send({
          src: 'promoter',
          promoterId: promoter.id,
          surface: 'app',
          clientId,
        })
        .expect(201);

      const phone = uniquePhone();
      await signInClient(app, { phone, clientId });

      const user = await userRepository.findOne({ where: { phone } });
      expect(user?.acquisitionSource).toBe('promoter');
      expect(user?.acquisitionPromoterId).toBe(promoter.id);
    });

    it('two landings from different sources before signup keep both raw events; the snapshot is first-touch', async () => {
      const http = app.getHttpServer();
      const venueId = await createActiveVenue('Attribution Multi-touch Venue');
      const clientId = `client-${Date.now()}-${Math.random()}`;

      await request(http)
        .post('/api/attribution/landing')
        .send({ src: 'qr', venueId, surface: 'app', clientId })
        .expect(201);
      await request(http)
        .post('/api/attribution/landing')
        .send({
          src: 'social',
          campaignId: 'launch-week',
          surface: 'app',
          clientId,
        })
        .expect(201);

      const phone = uniquePhone();
      await signInClient(app, { phone, clientId });

      const user = await userRepository.findOne({ where: { phone } });
      // First-touch: the QR landing (recorded first) wins the snapshot.
      expect(user?.acquisitionSource).toBe('qr');

      const landingRepository = app.get<Repository<{ clientId: string }>>(
        getRepositoryToken(
          (
            await import('../src/modules/attribution/entities/landing-event.entity')
          ).LandingEvent,
        ),
      );
      const landings = await landingRepository.find({ where: { clientId } });
      expect(landings).toHaveLength(2);
    });

    it('an organic signup with no landing leaves the acquisition snapshot empty', async () => {
      const phone = uniquePhone();
      await signInClient(app, { phone });

      const user = await userRepository.findOne({ where: { phone } });
      expect(user?.acquisitionSource).toBeNull();
    });
  });

  describe('analytics proxy', () => {
    it('forwards a signed-in event with the internal user id (never a phone number)', async () => {
      const { accessToken, user } = await mintTokensForRole(
        app,
        UserRole.CLIENT,
      );

      await request(app.getHttpServer())
        .post('/api/analytics/track')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({ event: 'feed_opened' })
        .expect(204);

      const captured = fakePostHog.getLastCaptured();
      expect(captured?.event).toBe('feed_opened');
      expect(captured?.distinctId).toBe(user.id);
      expect(JSON.stringify(captured?.properties ?? {})).not.toContain(
        user.phone,
      );
    });

    it('strips a phone property if a client sends one', async () => {
      const { accessToken } = await mintTokensForRole(app, UserRole.CLIENT);

      await request(app.getHttpServer())
        .post('/api/analytics/track')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({
          event: 'feed_opened',
          properties: { phone: '+2250700000000', source: 'push' },
        })
        .expect(204);

      const captured = fakePostHog.getLastCaptured();
      expect(captured?.properties).not.toHaveProperty('phone');
      expect(captured?.properties?.source).toBe('push');
    });

    it('rejects an unknown event name', async () => {
      const { accessToken } = await mintTokensForRole(app, UserRole.CLIENT);

      await request(app.getHttpServer())
        .post('/api/analytics/track')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({ event: 'not_a_real_event' })
        .expect(400);
    });

    it('accepts a pre-signup anonymous event (qr_landing_opened)', async () => {
      await request(app.getHttpServer())
        .post('/api/analytics/track')
        .send({ event: 'qr_landing_opened', anonymousId: 'anon-client-1' })
        .expect(204);

      const captured = fakePostHog.getLastCaptured();
      expect(captured?.distinctId).toBe('anon-client-1');
    });

    it('a Zone 4 venue_viewed flips activeZone, distinct from acquisitionZone', async () => {
      const venueId = await createActiveVenue('Active Zone Venue');
      const { accessToken, user } = await mintTokensForRole(
        app,
        UserRole.CLIENT,
      );

      let stored = await userRepository.findOne({ where: { id: user.id } });
      expect(stored?.activeZone).toBeNull();

      await request(app.getHttpServer())
        .post('/api/analytics/track')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({ event: 'venue_viewed', properties: { venue_id: venueId } })
        .expect(204);

      stored = await userRepository.findOne({ where: { id: user.id } });
      expect(stored?.activeZone).toBe('zone_4');
      // acquisitionZone is untouched by activity — the two are never conflated.
      expect(stored?.acquisitionZone).toBeNull();
    });

    it('an out-of-area venue_viewed does not set activeZone', async () => {
      const venueId = await createActiveVenue(
        'Out Of Area Active Zone Venue',
        outOfAreaCoords,
      );
      const { accessToken, user } = await mintTokensForRole(
        app,
        UserRole.CLIENT,
      );

      await request(app.getHttpServer())
        .post('/api/analytics/track')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({ event: 'venue_viewed', properties: { venue_id: venueId } })
        .expect(204);

      const stored = await userRepository.findOne({ where: { id: user.id } });
      expect(stored?.activeZone).toBeNull();
    });
  });

  describe('backend-emitted events', () => {
    it('marking "J\'y vais" forwards going_marked server-side', async () => {
      const venueId = await createActiveVenue('Backend Emit Going Venue');
      const { accessToken } = await mintTokensForRole(app, UserRole.CLIENT);

      await request(app.getHttpServer())
        .post('/api/going')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({ venueId })
        .expect(201);

      const captured = fakePostHog
        .getCaptured()
        .find((e) => e.event === 'going_marked');
      expect(captured).toBeDefined();
      expect(captured?.properties?.venue_id).toBe(venueId);
    });

    it('creating a promo forwards promo_created + post_created_organically', async () => {
      const { venueId, ownerToken } = await createOwnedActiveVenue(
        'Backend Emit Promo Venue',
      );

      await request(app.getHttpServer())
        .post(`/api/feed/venue/${venueId}/promo`)
        .set('Authorization', `Bearer ${ownerToken}`)
        .send({ title: 'Promo', description: 'x' })
        .expect(201);

      const events = fakePostHog.getCaptured().map((e) => e.event);
      expect(events).toContain('promo_created');
      expect(events).toContain('post_created');
      expect(events).toContain('post_created_organically');
      expect(events).not.toContain('post_created_founder_assisted');
    });
  });

  describe('first-party metrics', () => {
    it('organic-posts-this-week query matches the FeedItem rows just created', async () => {
      const { venueId, ownerToken } =
        await createOwnedActiveVenue('Metrics Venue');

      await request(app.getHttpServer())
        .post(`/api/feed/venue/${venueId}/promo`)
        .set('Authorization', `Bearer ${ownerToken}`)
        .send({ title: 'Metrics Promo', description: 'x' })
        .expect(201);

      const metricsService = app.get(MetricsService);
      const result = await metricsService.getOrganicVsAssistedThisWeek(venueId);
      expect(result.organic).toBe(1);
      expect(result.assisted).toBe(0);
    });
  });
});
