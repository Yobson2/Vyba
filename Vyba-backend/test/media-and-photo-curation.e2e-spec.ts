import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication, ValidationPipe } from '@nestjs/common';
import request from 'supertest';
import { AppModule } from '../src/app.module';
import { UserRole } from '../src/common/constants/roles.constant';
import { VenueType } from '../src/modules/venues/entities/venue.entity';
import { mintTokensForRole, uniquePhone } from './utils/auth-e2e.helper';

/**
 * Media + photo curation e2e harness (ticket 14 / spec 06): the
 * trusted/community split — venue-account uploads publish immediately, a
 * client's night photo shows on the venue/night view but not the main feed
 * until an admin promotes it, and hide/delete removes it from both.
 * `FakeStorageProvider` stands in for S3 (no real bucket in tests).
 */
describe('Media and photo curation (e2e)', () => {
  let app: INestApplication;
  let adminToken: string;

  const inAreaCoords = { latitude: 5.285, longitude: -3.985 };
  const onePixelPng = Buffer.from(
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII=',
    'base64',
  );

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

  describe('venue-owner profile photo', () => {
    it("is active immediately and appended to the venue's photos", async () => {
      const { venueId, ownerToken } = await createOwnedActiveVenue(
        'Profile Photo Venue',
      );
      const http = app.getHttpServer();

      const uploadRes = await request(http)
        .post('/api/media/owner/venue-photo')
        .set('Authorization', `Bearer ${ownerToken}`)
        .attach('file', onePixelPng, {
          filename: 'profile.png',
          contentType: 'image/png',
        })
        .expect(201);

      expect(uploadRes.body.status).toBe('active');
      expect(uploadRes.body.contextType).toBe('venue_profile');

      const venueRes = await request(http)
        .get(`/api/venues/${venueId}`)
        .set('Authorization', `Bearer ${adminToken}`)
        .expect(200);
      expect(venueRes.body.photos).toContain(uploadRes.body.url);
    });
  });

  describe('client night photo', () => {
    it('shows on the venue/night view but not in the main feed, until promoted', async () => {
      const { venueId } = await createOwnedActiveVenue('Night Photo Venue');
      const { accessToken: clientToken } = await mintTokensForRole(
        app,
        UserRole.CLIENT,
      );
      const http = app.getHttpServer();

      const uploadRes = await request(http)
        .post('/api/media/venue-night-photo')
        .set('Authorization', `Bearer ${clientToken}`)
        .field('venueId', venueId)
        .attach('file', onePixelPng, {
          filename: 'night.png',
          contentType: 'image/png',
        })
        .expect(201);

      expect(uploadRes.body.contextType).toBe('venue_night_user');
      expect(uploadRes.body.feedPromoted).toBe(false);

      const nightPhotosRes = await request(http)
        .get(`/api/media/venue/${venueId}/night-photos`)
        .set('Authorization', `Bearer ${clientToken}`)
        .expect(200);
      expect(
        (nightPhotosRes.body as Array<{ id: string }>).some(
          (p) => p.id === uploadRes.body.id,
        ),
      ).toBe(true);

      const feedBefore = await request(http)
        .get('/api/feed/public')
        .expect(200);
      expect(
        (feedBefore.body as Array<{ type: string; payload?: unknown }>).some(
          (i) =>
            i.type === 'PHOTO' &&
            (i.payload as { mediaAssetId?: string } | undefined)
              ?.mediaAssetId === uploadRes.body.id,
        ),
      ).toBe(false);

      const promoteRes = await request(http)
        .patch(`/api/media/${uploadRes.body.id}/promote`)
        .set('Authorization', `Bearer ${adminToken}`)
        .expect(200);
      expect(promoteRes.body.feedPromoted).toBe(true);

      const feedAfter = await request(http).get('/api/feed/public').expect(200);
      expect(
        (feedAfter.body as Array<{ type: string; payload?: unknown }>).some(
          (i) =>
            i.type === 'PHOTO' &&
            (i.payload as { mediaAssetId?: string } | undefined)
              ?.mediaAssetId === uploadRes.body.id,
        ),
      ).toBe(true);
    });

    it('hiding a promoted photo removes it from the feed too', async () => {
      const { venueId } = await createOwnedActiveVenue('Hide Photo Venue');
      const { accessToken: clientToken } = await mintTokensForRole(
        app,
        UserRole.CLIENT,
      );
      const http = app.getHttpServer();

      const uploadRes = await request(http)
        .post('/api/media/venue-night-photo')
        .set('Authorization', `Bearer ${clientToken}`)
        .field('venueId', venueId)
        .attach('file', onePixelPng, {
          filename: 'night.png',
          contentType: 'image/png',
        })
        .expect(201);

      await request(http)
        .patch(`/api/media/${uploadRes.body.id}/promote`)
        .set('Authorization', `Bearer ${adminToken}`)
        .expect(200);

      await request(http)
        .patch(`/api/media/${uploadRes.body.id}/hide`)
        .set('Authorization', `Bearer ${adminToken}`)
        .expect(200);

      const feedRes = await request(http).get('/api/feed/public').expect(200);
      expect(
        (feedRes.body as Array<{ payload?: unknown }>).some(
          (i) =>
            (i.payload as { mediaAssetId?: string } | undefined)
              ?.mediaAssetId === uploadRes.body.id,
        ),
      ).toBe(false);

      const nightPhotosRes = await request(http)
        .get(`/api/media/venue/${venueId}/night-photos`)
        .set('Authorization', `Bearer ${clientToken}`)
        .expect(200);
      expect(
        (nightPhotosRes.body as Array<{ id: string }>).some(
          (p) => p.id === uploadRes.body.id,
        ),
      ).toBe(false);
    });

    it('the uploader can delete their own promoted photo — asset and feed item gone', async () => {
      const { venueId } = await createOwnedActiveVenue('Uploader Delete Venue');
      const { accessToken: clientToken } = await mintTokensForRole(
        app,
        UserRole.CLIENT,
      );
      const http = app.getHttpServer();

      const uploadRes = await request(http)
        .post('/api/media/venue-night-photo')
        .set('Authorization', `Bearer ${clientToken}`)
        .field('venueId', venueId)
        .attach('file', onePixelPng, {
          filename: 'night.png',
          contentType: 'image/png',
        })
        .expect(201);

      await request(http)
        .patch(`/api/media/${uploadRes.body.id}/promote`)
        .set('Authorization', `Bearer ${adminToken}`)
        .expect(200);

      await request(http)
        .delete(`/api/media/${uploadRes.body.id}`)
        .set('Authorization', `Bearer ${clientToken}`)
        .expect(200);

      const feedRes = await request(http).get('/api/feed/public').expect(200);
      expect(
        (feedRes.body as Array<{ payload?: unknown }>).some(
          (i) =>
            (i.payload as { mediaAssetId?: string } | undefined)
              ?.mediaAssetId === uploadRes.body.id,
        ),
      ).toBe(false);
    });

    it("rejects a different user from deleting someone else's photo", async () => {
      const { venueId } = await createOwnedActiveVenue(
        'Forbidden Delete Venue',
      );
      const { accessToken: uploaderToken } = await mintTokensForRole(
        app,
        UserRole.CLIENT,
      );
      const { accessToken: otherToken } = await mintTokensForRole(
        app,
        UserRole.CLIENT,
      );
      const http = app.getHttpServer();

      const uploadRes = await request(http)
        .post('/api/media/venue-night-photo')
        .set('Authorization', `Bearer ${uploaderToken}`)
        .field('venueId', venueId)
        .attach('file', onePixelPng, {
          filename: 'night.png',
          contentType: 'image/png',
        })
        .expect(201);

      await request(http)
        .delete(`/api/media/${uploadRes.body.id}`)
        .set('Authorization', `Bearer ${otherToken}`)
        .expect(403);
    });
  });

  describe('curation queue', () => {
    it('lists venue_night_user assets with venue/night/uploader context', async () => {
      const { venueId } = await createOwnedActiveVenue('Curation Queue Venue');
      const { accessToken: clientToken } = await mintTokensForRole(
        app,
        UserRole.CLIENT,
      );
      const http = app.getHttpServer();

      const uploadRes = await request(http)
        .post('/api/media/venue-night-photo')
        .set('Authorization', `Bearer ${clientToken}`)
        .field('venueId', venueId)
        .attach('file', onePixelPng, {
          filename: 'night.png',
          contentType: 'image/png',
        })
        .expect(201);

      const listRes = await request(http)
        .get('/api/media/admin')
        .query({ venueId })
        .set('Authorization', `Bearer ${adminToken}`)
        .expect(200);

      const item = (
        listRes.body as Array<{ id: string; uploadedByUserId: string }>
      ).find((i) => i.id === uploadRes.body.id);
      expect(item).toBeDefined();
      expect(item?.uploadedByUserId).toBeDefined();
    });

    it('rejects a non-admin from reading the curation queue', async () => {
      const { accessToken: clientToken } = await mintTokensForRole(
        app,
        UserRole.CLIENT,
      );
      await request(app.getHttpServer())
        .get('/api/media/admin')
        .set('Authorization', `Bearer ${clientToken}`)
        .expect(403);
    });
  });

  describe('validation', () => {
    it('rejects an oversized upload', async () => {
      const { venueId } = await createOwnedActiveVenue('Oversized Venue');
      const { accessToken: clientToken } = await mintTokensForRole(
        app,
        UserRole.CLIENT,
      );
      const oversized = Buffer.alloc(9 * 1024 * 1024, 1);

      await request(app.getHttpServer())
        .post('/api/media/venue-night-photo')
        .set('Authorization', `Bearer ${clientToken}`)
        .field('venueId', venueId)
        .attach('file', oversized, {
          filename: 'huge.png',
          contentType: 'image/png',
        })
        .expect((res) => {
          expect([400, 413]).toContain(res.status);
        });
    });

    it('rejects a non-image upload', async () => {
      const { venueId } = await createOwnedActiveVenue('Wrong Type Venue');
      const { accessToken: clientToken } = await mintTokensForRole(
        app,
        UserRole.CLIENT,
      );

      await request(app.getHttpServer())
        .post('/api/media/venue-night-photo')
        .set('Authorization', `Bearer ${clientToken}`)
        .field('venueId', venueId)
        .attach('file', Buffer.from('%PDF-1.4 not a real pdf'), {
          filename: 'doc.pdf',
          contentType: 'application/pdf',
        })
        .expect(400);
    });

    it('rejects an unauthenticated upload', async () => {
      await request(app.getHttpServer())
        .post('/api/media/venue-night-photo')
        .field('venueId', '00000000-0000-0000-0000-000000000000')
        .attach('file', onePixelPng, {
          filename: 'night.png',
          contentType: 'image/png',
        })
        .expect(401);
    });
  });
});
