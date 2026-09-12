import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication, ValidationPipe } from '@nestjs/common';
import request from 'supertest';
import { AppModule } from '../src/app.module';
import { UserRole } from '../src/common/constants/roles.constant';
import { VenueType } from '../src/modules/venues/entities/venue.entity';
import { FakeFcmSender } from '../src/modules/notifications/fcm/fake-fcm.sender';
import { mintTokensForRole, uniquePhone } from './utils/auth-e2e.helper';

/**
 * Owner broadcast + per-venue opt-in e2e harness (ticket 17 / spec 08):
 * opt-in is independent of `Follow`, recipients are tonight's active
 * "going" ∩ opted-in, and a venue gets exactly one successful broadcast per
 * night. `FakeFcmSender` stands in for FCM — no real push project in tests.
 */
describe('Venue broadcast + opt-in (e2e)', () => {
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

  describe('opt-in', () => {
    it('defaults to not opted in, and is independent of Follow', async () => {
      const { venueId } = await createOwnedActiveVenue('Opt-in Default Venue');
      const { accessToken: clientToken } = await mintTokensForRole(
        app,
        UserRole.CLIENT,
      );
      const http = app.getHttpServer();

      const before = await request(http)
        .get(`/api/notifications/venue/${venueId}/opt-in`)
        .set('Authorization', `Bearer ${clientToken}`)
        .expect(200);
      expect(before.body).toEqual({ optedIn: false });

      // Following the venue must not opt the client into broadcasts.
      await request(http)
        .post(`/api/follows/venue/${venueId}`)
        .set('Authorization', `Bearer ${clientToken}`)
        .expect(201);

      const afterFollow = await request(http)
        .get(`/api/notifications/venue/${venueId}/opt-in`)
        .set('Authorization', `Bearer ${clientToken}`)
        .expect(200);
      expect(afterFollow.body).toEqual({ optedIn: false });

      await request(http)
        .post(`/api/notifications/venue/${venueId}/opt-in`)
        .set('Authorization', `Bearer ${clientToken}`)
        .expect(201);

      const afterOptIn = await request(http)
        .get(`/api/notifications/venue/${venueId}/opt-in`)
        .set('Authorization', `Bearer ${clientToken}`)
        .expect(200);
      expect(afterOptIn.body).toEqual({ optedIn: true });

      await request(http)
        .delete(`/api/notifications/venue/${venueId}/opt-in`)
        .set('Authorization', `Bearer ${clientToken}`)
        .expect(200);

      const afterOptOut = await request(http)
        .get(`/api/notifications/venue/${venueId}/opt-in`)
        .set('Authorization', `Bearer ${clientToken}`)
        .expect(200);
      expect(afterOptOut.body).toEqual({ optedIn: false });
    });

    it('"mes lieux avec notifications" lists opted-in venues, not merely followed ones', async () => {
      const { venueId: optedInVenueId } = await createOwnedActiveVenue(
        'Listed Opt-in Venue',
      );
      const { venueId: followedOnlyVenueId } = await createOwnedActiveVenue(
        'Listed Follow-only Venue',
      );
      const { accessToken: clientToken } = await mintTokensForRole(
        app,
        UserRole.CLIENT,
      );
      const http = app.getHttpServer();

      await request(http)
        .post(`/api/notifications/venue/${optedInVenueId}/opt-in`)
        .set('Authorization', `Bearer ${clientToken}`)
        .expect(201);
      await request(http)
        .post(`/api/follows/venue/${followedOnlyVenueId}`)
        .set('Authorization', `Bearer ${clientToken}`)
        .expect(201);

      const res = await request(http)
        .get('/api/notifications/venue-opt-ins/mine')
        .set('Authorization', `Bearer ${clientToken}`)
        .expect(200);

      const ids = (res.body as Array<{ id: string }>).map((v) => v.id);
      expect(ids).toContain(optedInVenueId);
      expect(ids).not.toContain(followedOnlyVenueId);
    });
  });

  describe('broadcast', () => {
    it("reaches an opted-in + going client, refuses a second send, and a follower who didn't opt in gets nothing", async () => {
      const { venueId, ownerToken } =
        await createOwnedActiveVenue('Broadcast Venue');
      const http = app.getHttpServer();

      const { accessToken: eligibleToken } = await mintTokensForRole(
        app,
        UserRole.CLIENT,
      );
      const eligibleDevice = uniqueToken('eligible');
      await registerDeviceToken(eligibleToken, eligibleDevice);
      await markGoing(eligibleToken, venueId);
      await request(http)
        .post(`/api/notifications/venue/${venueId}/opt-in`)
        .set('Authorization', `Bearer ${eligibleToken}`)
        .expect(201);

      // Follows the venue but never opts in — must not receive anything.
      const { accessToken: followerOnlyToken } = await mintTokensForRole(
        app,
        UserRole.CLIENT,
      );
      const followerDevice = uniqueToken('follower-only');
      await registerDeviceToken(followerOnlyToken, followerDevice);
      await markGoing(followerOnlyToken, venueId);
      await request(http)
        .post(`/api/follows/venue/${venueId}`)
        .set('Authorization', `Bearer ${followerOnlyToken}`)
        .expect(201);

      const sendRes = await request(http)
        .post(`/api/notifications/venue/${venueId}/broadcast`)
        .set('Authorization', `Bearer ${ownerToken}`)
        .send({ message: "Happy hour prolongée jusqu'à minuit !" })
        .expect(201);
      expect(sendRes.body.delivered).toBeGreaterThanOrEqual(1);

      expect(tokensSentTo(eligibleDevice)).toHaveLength(1);
      const send = tokensSentTo(eligibleDevice)[0];
      expect(send.payload.data?.type).toBe('venue_broadcast');
      expect(send.payload.data?.venueId).toBe(venueId);
      expect(send.payload.body).toBe("Happy hour prolongée jusqu'à minuit !");

      expect(tokensSentTo(followerDevice)).toHaveLength(0);

      await request(http)
        .post(`/api/notifications/venue/${venueId}/broadcast`)
        .set('Authorization', `Bearer ${ownerToken}`)
        .send({ message: 'Une deuxième fois ?' })
        .expect(409);

      expect(tokensSentTo(eligibleDevice)).toHaveLength(1);
    });

    it('an opted-in client who is not going tonight receives nothing', async () => {
      const { venueId, ownerToken } = await createOwnedActiveVenue(
        'Opted-in Not Going Venue',
      );
      const http = app.getHttpServer();

      const { accessToken: notGoingToken } = await mintTokensForRole(
        app,
        UserRole.CLIENT,
      );
      const notGoingDevice = uniqueToken('not-going');
      await registerDeviceToken(notGoingToken, notGoingDevice);
      await request(http)
        .post(`/api/notifications/venue/${venueId}/opt-in`)
        .set('Authorization', `Bearer ${notGoingToken}`)
        .expect(201);
      // Deliberately never marks "J'y vais".

      await request(http)
        .post(`/api/notifications/venue/${venueId}/broadcast`)
        .set('Authorization', `Bearer ${ownerToken}`)
        .send({ message: 'On vous attend ce soir !' })
        .expect(201);

      expect(tokensSentTo(notGoingDevice)).toHaveLength(0);
    });

    it("rejects a non-owner from broadcasting for someone else's venue", async () => {
      const { venueId } = await createOwnedActiveVenue('Wrong Owner Venue');
      const { accessToken: otherOwnerToken } = await mintTokensForRole(
        app,
        UserRole.VENUE_OWNER,
      );

      await request(app.getHttpServer())
        .post(`/api/notifications/venue/${venueId}/broadcast`)
        .set('Authorization', `Bearer ${otherOwnerToken}`)
        .send({ message: 'x' })
        .expect(403);
    });

    it('rejects a message over the length cap', async () => {
      const { venueId, ownerToken } = await createOwnedActiveVenue(
        'Too Long Message Venue',
      );

      await request(app.getHttpServer())
        .post(`/api/notifications/venue/${venueId}/broadcast`)
        .set('Authorization', `Bearer ${ownerToken}`)
        .send({ message: 'x'.repeat(141) })
        .expect(400);
    });
  });
});
