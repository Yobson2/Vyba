import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication, ValidationPipe } from '@nestjs/common';
import request from 'supertest';
import { AppModule } from '../src/app.module';
import { UserRole } from '../src/common/constants/roles.constant';
import { VenueType } from '../src/modules/venues/entities/venue.entity';
import { ClockService } from '../src/common/clock/clock.service';
import { mintTokensForRole, uniquePhone } from './utils/auth-e2e.helper';

/** Settable clock so midnight-boundary tests don't sleep until a real boundary. */
class FakeClockService extends ClockService {
  private current = new Date();

  setNow(date: Date): void {
    this.current = date;
  }

  reset(): void {
    this.current = new Date();
  }

  override now(): Date {
    return this.current;
  }
}

describe('Going (e2e)', () => {
  let app: INestApplication;
  let adminToken: string;
  let fakeClock: FakeClockService;

  const inAreaCoords = { latitude: 5.285, longitude: -3.985 };

  beforeAll(async () => {
    const moduleFixture: TestingModule = await Test.createTestingModule({
      imports: [AppModule],
    })
      .overrideProvider(ClockService)
      .useClass(FakeClockService)
      .compile();

    app = moduleFixture.createNestApplication();
    app.useGlobalPipes(
      new ValidationPipe({
        whitelist: true,
        transform: true,
        forbidNonWhitelisted: true,
      }),
    );
    await app.init();

    fakeClock = app.get(ClockService) as FakeClockService;

    ({ accessToken: adminToken } = await mintTokensForRole(
      app,
      UserRole.ADMIN,
    ));
  });

  afterEach(() => {
    fakeClock.reset();
  });

  afterAll(async () => {
    await app.close();
  });

  async function createActiveVenue(name: string) {
    const http = app.getHttpServer();
    const createRes = await request(http)
      .post('/api/venues')
      .set('Authorization', `Bearer ${adminToken}`)
      .send({ name, venueType: VenueType.BAR, priceLevel: 2, ...inAreaCoords })
      .expect(201);

    await request(http)
      .patch(`/api/venues/${createRes.body.id}`)
      .set('Authorization', `Bearer ${adminToken}`)
      .send({ validationStatus: 'ACTIVE' })
      .expect(200);

    return createRes.body.id as string;
  }

  async function signInOwnerFor(venueId: string) {
    const http = app.getHttpServer();
    const ownerPhone = uniquePhone();
    await request(http)
      .post(`/api/venues/${venueId}/owner`)
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
      ownerToken: verifyRes.body.accessToken as string,
      ownerId: verifyRes.body.user.id as string,
    };
  }

  describe('mark / count', () => {
    it('marks, re-marks idempotently, a second user increments, then cancel decrements', async () => {
      const venueId = await createActiveVenue('Going Venue A');
      const http = app.getHttpServer();

      const client1 = await mintTokensForRole(app, UserRole.CLIENT);
      const client2 = await mintTokensForRole(app, UserRole.CLIENT);

      const mark1 = await request(http)
        .post('/api/going')
        .set('Authorization', `Bearer ${client1.accessToken}`)
        .send({ venueId })
        .expect(201);
      expect(mark1.body.partySize).toBe(1);

      let detail = await request(http)
        .get(`/api/venues/${venueId}/detail`)
        .set('Authorization', `Bearer ${client1.accessToken}`)
        .expect(200);
      expect(detail.body.tonight.goingCount).toBe(1);

      // Same user marks again — still counts as 1 (idempotent re-mark).
      await request(http)
        .post('/api/going')
        .set('Authorization', `Bearer ${client1.accessToken}`)
        .send({ venueId })
        .expect(201);
      detail = await request(http)
        .get(`/api/venues/${venueId}/detail`)
        .set('Authorization', `Bearer ${client1.accessToken}`)
        .expect(200);
      expect(detail.body.tonight.goingCount).toBe(1);

      // Second user, party size is metadata — count is people-marks, not sum.
      await request(http)
        .post('/api/going')
        .set('Authorization', `Bearer ${client2.accessToken}`)
        .send({ venueId, partySize: 3 })
        .expect(201);
      detail = await request(http)
        .get(`/api/venues/${venueId}/detail`)
        .set('Authorization', `Bearer ${client1.accessToken}`)
        .expect(200);
      expect(detail.body.tonight.goingCount).toBe(2);

      // First user cancels.
      await request(http)
        .delete(`/api/going/venue/${venueId}`)
        .set('Authorization', `Bearer ${client1.accessToken}`)
        .expect(200);
      detail = await request(http)
        .get(`/api/venues/${venueId}/detail`)
        .set('Authorization', `Bearer ${client1.accessToken}`)
        .expect(200);
      expect(detail.body.tonight.goingCount).toBe(1);
    });

    it('getMine reflects the current mark, null after cancel', async () => {
      const venueId = await createActiveVenue('Going Venue Mine');
      const http = app.getHttpServer();
      const client = await mintTokensForRole(app, UserRole.CLIENT);

      let mine = await request(http)
        .get(`/api/going/venue/${venueId}/mine`)
        .set('Authorization', `Bearer ${client.accessToken}`)
        .expect(200);
      expect(mine.body).toBeNull();

      await request(http)
        .post('/api/going')
        .set('Authorization', `Bearer ${client.accessToken}`)
        .send({ venueId, partySize: 2 })
        .expect(201);

      mine = await request(http)
        .get(`/api/going/venue/${venueId}/mine`)
        .set('Authorization', `Bearer ${client.accessToken}`)
        .expect(200);
      expect(mine.body.partySize).toBe(2);

      await request(http)
        .delete(`/api/going/venue/${venueId}`)
        .set('Authorization', `Bearer ${client.accessToken}`)
        .expect(200);

      mine = await request(http)
        .get(`/api/going/venue/${venueId}/mine`)
        .set('Authorization', `Bearer ${client.accessToken}`)
        .expect(200);
      expect(mine.body).toBeNull();
    });
  });

  describe('owner cannot self-mark', () => {
    it('refuses the owner marking their own venue', async () => {
      const venueId = await createActiveVenue('Owner Refuse Venue');
      const { ownerToken } = await signInOwnerFor(venueId);

      await request(app.getHttpServer())
        .post('/api/going')
        .set('Authorization', `Bearer ${ownerToken}`)
        .send({ venueId })
        .expect(403);
    });

    it('owner summary shows count + rough party sizes, no identity', async () => {
      const venueId = await createActiveVenue('Owner Summary Venue');
      const { ownerToken } = await signInOwnerFor(venueId);
      const http = app.getHttpServer();

      const client1 = await mintTokensForRole(app, UserRole.CLIENT);
      const client2 = await mintTokensForRole(app, UserRole.CLIENT);
      await request(http)
        .post('/api/going')
        .set('Authorization', `Bearer ${client1.accessToken}`)
        .send({ venueId, partySize: 4 })
        .expect(201);
      await request(http)
        .post('/api/going')
        .set('Authorization', `Bearer ${client2.accessToken}`)
        .send({ venueId, partySize: 1 })
        .expect(201);

      const summary = await request(http)
        .get(`/api/going/venue/${venueId}/owner-summary`)
        .set('Authorization', `Bearer ${ownerToken}`)
        .expect(200);

      expect(summary.body.count).toBe(2);
      expect(summary.body.partySizes.sort()).toEqual([1, 4]);
    });

    it("rejects a different owner reading this venue's summary", async () => {
      const venueId = await createActiveVenue('Owner Summary Guard Venue');
      const { accessToken: otherOwnerToken } = await mintTokensForRole(
        app,
        UserRole.VENUE_OWNER,
      );

      await request(app.getHttpServer())
        .get(`/api/going/venue/${venueId}/owner-summary`)
        .set('Authorization', `Bearer ${otherOwnerToken}`)
        .expect(403);
    });
  });

  describe('edit / cancel and the midnight boundary', () => {
    it('allows editing party size before midnight', async () => {
      const venueId = await createActiveVenue('Edit Venue');
      const client = await mintTokensForRole(app, UserRole.CLIENT);
      const http = app.getHttpServer();

      await request(http)
        .post('/api/going')
        .set('Authorization', `Bearer ${client.accessToken}`)
        .send({ venueId, partySize: 1 })
        .expect(201);

      const updated = await request(http)
        .patch(`/api/going/venue/${venueId}`)
        .set('Authorization', `Bearer ${client.accessToken}`)
        .send({ partySize: 5 })
        .expect(200);
      expect(updated.body.partySize).toBe(5);
    });

    it("refuses editing and canceling after the night's Abidjan midnight", async () => {
      const venueId = await createActiveVenue('Midnight Venue');
      const client = await mintTokensForRole(app, UserRole.CLIENT);
      const http = app.getHttpServer();

      await request(http)
        .post('/api/going')
        .set('Authorization', `Bearer ${client.accessToken}`)
        .send({ venueId })
        .expect(201);

      // Jump the clock two days ahead — well past tonight's midnight boundary.
      fakeClock.setNow(new Date(Date.now() + 2 * 24 * 60 * 60 * 1000));

      await request(http)
        .patch(`/api/going/venue/${venueId}`)
        .set('Authorization', `Bearer ${client.accessToken}`)
        .send({ partySize: 2 })
        .expect(403);

      await request(http)
        .delete(`/api/going/venue/${venueId}`)
        .set('Authorization', `Bearer ${client.accessToken}`)
        .expect(403);
    });
  });

  describe('going_milestone', () => {
    it('crossing the threshold emits exactly one milestone item, no duplicate on remark', async () => {
      const venueId = await createActiveVenue('Milestone Venue');
      const http = app.getHttpServer();

      const clients = await Promise.all(
        Array.from({ length: 10 }, () =>
          mintTokensForRole(app, UserRole.CLIENT),
        ),
      );

      for (const client of clients) {
        await request(http)
          .post('/api/going')
          .set('Authorization', `Bearer ${client.accessToken}`)
          .send({ venueId })
          .expect(201);
      }

      const feedAfterFirstCross = await request(http)
        .get('/api/feed/public')
        .expect(200);
      const milestoneItems = (
        feedAfterFirstCross.body as Array<{
          type: string;
          venue?: { id: string };
        }>
      ).filter((i) => i.type === 'GOING_MILESTONE' && i.venue?.id === venueId);
      expect(milestoneItems).toHaveLength(1);

      // Cancel + remark past the same threshold — still exactly one milestone item.
      await request(http)
        .delete(`/api/going/venue/${venueId}`)
        .set('Authorization', `Bearer ${clients[0].accessToken}`)
        .expect(200);
      await request(http)
        .post('/api/going')
        .set('Authorization', `Bearer ${clients[0].accessToken}`)
        .send({ venueId })
        .expect(201);

      const feedAfterRemark = await request(http)
        .get('/api/feed/public')
        .expect(200);
      const milestoneItemsAfter = (
        feedAfterRemark.body as Array<{ type: string; venue?: { id: string } }>
      ).filter((i) => i.type === 'GOING_MILESTONE' && i.venue?.id === venueId);
      expect(milestoneItemsAfter).toHaveLength(1);
    }, 30000);
  });
});
