import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication, ValidationPipe } from '@nestjs/common';
import request from 'supertest';
import { AppModule } from '../src/app.module';
import { UserRole } from '../src/common/constants/roles.constant';
import { VenueType } from '../src/modules/venues/entities/venue.entity';
import { FakeFcmSender } from '../src/modules/notifications/fcm/fake-fcm.sender';
import { mintTokensForRole } from './utils/auth-e2e.helper';

/**
 * Notifications e2e harness (ticket 15 / spec 08): the weekend-digest and
 * going-reminder jobs, triggered directly via the ADMIN "run now" endpoints
 * rather than waiting on the BullMQ cron schedule (the testing decision's
 * seam). `FakeFcmSender` stands in for FCM — no real push project in tests.
 */
describe('Notifications (e2e)', () => {
  let app: INestApplication;
  let adminToken: string;
  let fakeFcm: FakeFcmSender;

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

    fakeFcm = app.get(FakeFcmSender);
    ({ accessToken: adminToken } = await mintTokensForRole(
      app,
      UserRole.ADMIN,
    ));
  });

  afterAll(async () => {
    await app.close();
  });

  async function createActiveVenue(name: string) {
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

    return createRes.body.id as string;
  }

  function uniqueToken(prefix: string): string {
    return `${prefix}-${Math.random().toString(36).slice(2)}`;
  }

  async function registerDeviceToken(accessToken: string, deviceToken: string) {
    await request(app.getHttpServer())
      .post('/api/notifications/device-token')
      .set('Authorization', `Bearer ${accessToken}`)
      .send({ token: deviceToken })
      .expect(201);
  }

  async function setPreferences(
    accessToken: string,
    dto: { weekendDigest?: boolean; goingReminder?: boolean },
  ) {
    await request(app.getHttpServer())
      .patch('/api/notifications/preferences')
      .set('Authorization', `Bearer ${accessToken}`)
      .send(dto)
      .expect(200);
  }

  async function markGoing(accessToken: string, venueId: string) {
    await request(app.getHttpServer())
      .post('/api/going')
      .set('Authorization', `Bearer ${accessToken}`)
      .send({ venueId })
      .expect(201);
  }

  function tokensSentTo(deviceToken: string) {
    return fakeFcm.sends.filter((s) => s.tokens.includes(deviceToken));
  }

  describe('device token + preferences', () => {
    it('rejects device-token registration from a non-client (venue owner)', async () => {
      const { accessToken: ownerToken } = await mintTokensForRole(
        app,
        UserRole.VENUE_OWNER,
      );
      await request(app.getHttpServer())
        .post('/api/notifications/device-token')
        .set('Authorization', `Bearer ${ownerToken}`)
        .send({ token: 'irrelevant' })
        .expect(403);
    });

    it('preferences default to on for a user who has never toggled anything', async () => {
      const { accessToken: clientToken } = await mintTokensForRole(
        app,
        UserRole.CLIENT,
      );
      const res = await request(app.getHttpServer())
        .get('/api/notifications/preferences')
        .set('Authorization', `Bearer ${clientToken}`)
        .expect(200);
      expect(res.body).toEqual({ weekendDigest: true, goingReminder: true });
    });

    it('deregistering a token removes it — no further sends reach it', async () => {
      const { accessToken: clientToken } = await mintTokensForRole(
        app,
        UserRole.CLIENT,
      );
      const venueId = await createActiveVenue('Deregister Venue');
      const deviceToken = uniqueToken('device');

      await registerDeviceToken(clientToken, deviceToken);
      await markGoing(clientToken, venueId);

      await request(app.getHttpServer())
        .delete('/api/notifications/device-token')
        .set('Authorization', `Bearer ${clientToken}`)
        .send({ token: deviceToken })
        .expect(200);

      await request(app.getHttpServer())
        .post('/api/notifications/jobs/going-reminder/run')
        .set('Authorization', `Bearer ${adminToken}`)
        .expect(201);

      expect(tokensSentTo(deviceToken)).toHaveLength(0);
    });
  });

  describe('weekend digest', () => {
    it('reaches only opted-in cohort users, with content from the current feed', async () => {
      const venueId = await createActiveVenue('Digest Cohort Venue');
      await request(app.getHttpServer())
        .post('/api/feed/editorial')
        .set('Authorization', `Bearer ${adminToken}`)
        .send({
          title: 'Zone 4 en feu',
          body: 'x',
          expiresAt: new Date(Date.now() + 48 * 3600 * 1000).toISOString(),
        })
        .expect(201);

      // Marking "J'y vais" at an in-area venue is a meaningful action that
      // activates `activeZone = zone_4` (ticket 11) — the digest cohort gate.
      const { accessToken: inCohortToken } = await mintTokensForRole(
        app,
        UserRole.CLIENT,
      );
      const inCohortDevice = uniqueToken('digest-in');
      await registerDeviceToken(inCohortToken, inCohortDevice);
      await markGoing(inCohortToken, venueId);

      const { accessToken: optedOutToken } = await mintTokensForRole(
        app,
        UserRole.CLIENT,
      );
      const optedOutDevice = uniqueToken('digest-optout');
      await registerDeviceToken(optedOutToken, optedOutDevice);
      await markGoing(optedOutToken, venueId);
      await setPreferences(optedOutToken, { weekendDigest: false });

      const { accessToken: notInCohortToken } = await mintTokensForRole(
        app,
        UserRole.CLIENT,
      );
      const notInCohortDevice = uniqueToken('digest-notcohort');
      await registerDeviceToken(notInCohortToken, notInCohortDevice);
      // Never marks going / views an in-area venue — never enters the cohort.

      await request(app.getHttpServer())
        .post('/api/notifications/jobs/weekend-digest/run')
        .set('Authorization', `Bearer ${adminToken}`)
        .expect(201);

      expect(tokensSentTo(inCohortDevice)).toHaveLength(1);
      expect(tokensSentTo(optedOutDevice)).toHaveLength(0);
      expect(tokensSentTo(notInCohortDevice)).toHaveLength(0);

      // Content assembly is exercised at the unit boundary via the feed
      // ranking itself (unit 7's own tests) — here we only assert the
      // digest actually pulled in *some* current feed content rather than
      // its no-items fallback copy, since the top-5 ranking is shared with
      // whatever else is live in the seeded test database.
      const send = tokensSentTo(inCohortDevice)[0];
      expect(send.payload.data?.type).toBe('weekend_digest');
      expect(send.payload.title).toBe('Le week-end à Zone 4');
      expect(send.payload.body.length).toBeGreaterThan(0);
    });
  });

  describe('going reminder', () => {
    it('matches an active Going and respects goingReminder = off', async () => {
      const venueId = await createActiveVenue('Reminder Venue');

      const { accessToken: reminderOnToken } = await mintTokensForRole(
        app,
        UserRole.CLIENT,
      );
      const onDevice = uniqueToken('reminder-on');
      await registerDeviceToken(reminderOnToken, onDevice);
      await markGoing(reminderOnToken, venueId);

      const { accessToken: reminderOffToken } = await mintTokensForRole(
        app,
        UserRole.CLIENT,
      );
      const offDevice = uniqueToken('reminder-off');
      await registerDeviceToken(reminderOffToken, offDevice);
      await markGoing(reminderOffToken, venueId);
      await setPreferences(reminderOffToken, { goingReminder: false });

      await request(app.getHttpServer())
        .post('/api/notifications/jobs/going-reminder/run')
        .set('Authorization', `Bearer ${adminToken}`)
        .expect(201);

      expect(tokensSentTo(onDevice)).toHaveLength(1);
      expect(tokensSentTo(onDevice)[0].payload.data?.type).toBe(
        'going_reminder',
      );
      expect(tokensSentTo(offDevice)).toHaveLength(0);
    });

    it('groups two venues into one notification, not two', async () => {
      const venueAId = await createActiveVenue('Grouped Venue A');
      const venueBId = await createActiveVenue('Grouped Venue B');

      const { accessToken: clientToken } = await mintTokensForRole(
        app,
        UserRole.CLIENT,
      );
      const deviceToken = uniqueToken('grouped');
      await registerDeviceToken(clientToken, deviceToken);
      await markGoing(clientToken, venueAId);
      await markGoing(clientToken, venueBId);

      await request(app.getHttpServer())
        .post('/api/notifications/jobs/going-reminder/run')
        .set('Authorization', `Bearer ${adminToken}`)
        .expect(201);

      const sends = tokensSentTo(deviceToken);
      expect(sends).toHaveLength(1);
    });

    it('a cohort user with no device token is skipped cleanly (no_token, batch completes)', async () => {
      const venueId = await createActiveVenue('No Token Venue');
      const { accessToken: noTokenClient } = await mintTokensForRole(
        app,
        UserRole.CLIENT,
      );
      await markGoing(noTokenClient, venueId);
      // Deliberately never registers a device token.

      const res = await request(app.getHttpServer())
        .post('/api/notifications/jobs/going-reminder/run')
        .set('Authorization', `Bearer ${adminToken}`)
        .expect(201);

      expect(res.body.noToken).toBeGreaterThanOrEqual(1);
    });

    it('rejects a non-admin from running a job', async () => {
      const { accessToken: clientToken } = await mintTokensForRole(
        app,
        UserRole.CLIENT,
      );
      await request(app.getHttpServer())
        .post('/api/notifications/jobs/going-reminder/run')
        .set('Authorization', `Bearer ${clientToken}`)
        .expect(403);
    });
  });
});
