import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication, ValidationPipe } from '@nestjs/common';
import request from 'supertest';
import { AppModule } from '../src/app.module';
import { UserRole } from '../src/common/constants/roles.constant';
import { VenueType } from '../src/modules/venues/entities/venue.entity';
import { mintTokensForRole, uniquePhone } from './utils/auth-e2e.helper';

/**
 * Follows e2e harness (ticket 10). Covers follow/unfollow idempotency,
 * "mes lieux suivis", follower count on the venue detail payload, and the
 * feed's bounded follow-lift. Reuses ticket 04/05/07/09 helpers/fixtures.
 */
describe('Follows (e2e)', () => {
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

  describe('follow / unfollow', () => {
    it('follow → in my list + count 1; follow again → still one; unfollow → gone + count 0; re-follow → back', async () => {
      const { venueId } = await createOwnedActiveVenue('Follow Venue A');
      const http = app.getHttpServer();
      const { accessToken: clientToken } = await mintTokensForRole(
        app,
        UserRole.CLIENT,
      );

      const countFromDetail = async () => {
        const res = await request(http)
          .get(`/api/venues/${venueId}/detail`)
          .set('Authorization', `Bearer ${clientToken}`)
          .expect(200);
        return res.body.followerCount as number;
      };
      const myList = async () => {
        const res = await request(http)
          .get('/api/follows/mine')
          .set('Authorization', `Bearer ${clientToken}`)
          .expect(200);
        return res.body as Array<{ id: string }>;
      };

      expect(await countFromDetail()).toBe(0);
      expect(await myList()).toEqual([]);

      await request(http)
        .post(`/api/follows/venue/${venueId}`)
        .set('Authorization', `Bearer ${clientToken}`)
        .expect(201);

      expect(await countFromDetail()).toBe(1);
      expect((await myList()).map((v) => v.id)).toContain(venueId);

      // Idempotent — following again doesn't double-count.
      await request(http)
        .post(`/api/follows/venue/${venueId}`)
        .set('Authorization', `Bearer ${clientToken}`)
        .expect(201);
      expect(await countFromDetail()).toBe(1);

      await request(http)
        .delete(`/api/follows/venue/${venueId}`)
        .set('Authorization', `Bearer ${clientToken}`)
        .expect(200);

      expect(await countFromDetail()).toBe(0);
      expect((await myList()).map((v) => v.id)).not.toContain(venueId);

      // Idempotent — unfollowing again (not following) doesn't error.
      await request(http)
        .delete(`/api/follows/venue/${venueId}`)
        .set('Authorization', `Bearer ${clientToken}`)
        .expect(200);

      // Re-follow reactivates a single active row.
      await request(http)
        .post(`/api/follows/venue/${venueId}`)
        .set('Authorization', `Bearer ${clientToken}`)
        .expect(201);
      expect(await countFromDetail()).toBe(1);
    });

    it('the venue detail payload reflects isFollowing for the requesting user only', async () => {
      const { venueId } = await createOwnedActiveVenue('Follow Venue Mine');
      const http = app.getHttpServer();
      const { accessToken: followerToken } = await mintTokensForRole(
        app,
        UserRole.CLIENT,
      );
      const { accessToken: otherToken } = await mintTokensForRole(
        app,
        UserRole.CLIENT,
      );

      await request(http)
        .post(`/api/follows/venue/${venueId}`)
        .set('Authorization', `Bearer ${followerToken}`)
        .expect(201);

      const mineRes = await request(http)
        .get(`/api/follows/venue/${venueId}/mine`)
        .set('Authorization', `Bearer ${followerToken}`)
        .expect(200);
      expect(mineRes.body.isFollowing).toBe(true);

      const otherRes = await request(http)
        .get(`/api/follows/venue/${venueId}/mine`)
        .set('Authorization', `Bearer ${otherToken}`)
        .expect(200);
      expect(otherRes.body.isFollowing).toBe(false);
    });

    it("a client's followed list is private to them", async () => {
      const { venueId } = await createOwnedActiveVenue('Follow Venue Private');
      const http = app.getHttpServer();
      const { accessToken: clientToken } = await mintTokensForRole(
        app,
        UserRole.CLIENT,
      );
      const { accessToken: otherToken } = await mintTokensForRole(
        app,
        UserRole.CLIENT,
      );

      await request(http)
        .post(`/api/follows/venue/${venueId}`)
        .set('Authorization', `Bearer ${clientToken}`)
        .expect(201);

      const otherList = await request(http)
        .get('/api/follows/mine')
        .set('Authorization', `Bearer ${otherToken}`)
        .expect(200);
      expect(
        (otherList.body as Array<{ id: string }>).some((v) => v.id === venueId),
      ).toBe(false);
    });
  });

  describe('feed follow-lift', () => {
    it("a followed venue's promo outranks an equivalent non-followed venue's promo, and the lift disappears on unfollow", async () => {
      const http = app.getHttpServer();
      const { venueId: followedVenueId, ownerToken: followedOwnerToken } =
        await createOwnedActiveVenue('Lift Venue Followed');
      const { venueId: otherVenueId, ownerToken: otherOwnerToken } =
        await createOwnedActiveVenue('Lift Venue Other');
      const { accessToken: clientToken } = await mintTokensForRole(
        app,
        UserRole.CLIENT,
      );

      // Two "equivalent" (same-tier, close-together) promos.
      const followedPromo = await request(http)
        .post(`/api/feed/venue/${followedVenueId}/promo`)
        .set('Authorization', `Bearer ${followedOwnerToken}`)
        .send({ title: 'Followed Promo', description: 'x' })
        .expect(201);
      const otherPromo = await request(http)
        .post(`/api/feed/venue/${otherVenueId}/promo`)
        .set('Authorization', `Bearer ${otherOwnerToken}`)
        .send({ title: 'Other Promo', description: 'y' })
        .expect(201);

      // Without a follow, the more-recently-published item (otherPromo) leads.
      const beforeFollow = await request(http)
        .get('/api/feed')
        .set('Authorization', `Bearer ${clientToken}`)
        .expect(200);
      const indexOf = (body: unknown, id: string) =>
        (body as Array<{ id: string }>).findIndex((i) => i.id === id);
      expect(indexOf(beforeFollow.body, otherPromo.body.id)).toBeLessThan(
        indexOf(beforeFollow.body, followedPromo.body.id),
      );

      await request(http)
        .post(`/api/follows/venue/${followedVenueId}`)
        .set('Authorization', `Bearer ${clientToken}`)
        .expect(201);

      const afterFollow = await request(http)
        .get('/api/feed')
        .set('Authorization', `Bearer ${clientToken}`)
        .expect(200);
      expect(indexOf(afterFollow.body, followedPromo.body.id)).toBeLessThan(
        indexOf(afterFollow.body, otherPromo.body.id),
      );

      await request(http)
        .delete(`/api/follows/venue/${followedVenueId}`)
        .set('Authorization', `Bearer ${clientToken}`)
        .expect(200);

      const afterUnfollow = await request(http)
        .get('/api/feed')
        .set('Authorization', `Bearer ${clientToken}`)
        .expect(200);
      expect(indexOf(afterUnfollow.body, otherPromo.body.id)).toBeLessThan(
        indexOf(afterUnfollow.body, followedPromo.body.id),
      );
    });
  });
});
