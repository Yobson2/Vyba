import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication, ValidationPipe } from '@nestjs/common';
import request from 'supertest';
import { AppModule } from '../src/app.module';
import { UserRole } from '../src/common/constants/roles.constant';
import { VenueType } from '../src/modules/venues/entities/venue.entity';
import { mintTokensForRole, uniquePhone } from './utils/auth-e2e.helper';

/**
 * Venue provisioning e2e harness (ticket 05). Reuses ticket 04's auth
 * helper for ADMIN/VENUE_OWNER/CLIENT tokens; drives the HTTP surface only.
 */
describe('Venues (e2e)', () => {
  let app: INestApplication;
  let adminToken: string;

  // Inside the Zone 4 / Marcory bounding box (see launch-area.config.ts).
  const inAreaCoords = { latitude: 5.285, longitude: -3.985 };
  // Well outside it (Le Plateau, across the lagoon).
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

    ({ accessToken: adminToken } = await mintTokensForRole(
      app,
      UserRole.ADMIN,
    ));
  });

  afterAll(async () => {
    await app.close();
  });

  function createVenuePayload(
    overrides: Partial<Record<string, unknown>> = {},
  ) {
    return {
      name: 'Le Boony',
      description: 'Rooftop lounge with live DJ sets.',
      address: 'Rue du Canal, Zone 4, Marcory',
      venueType: VenueType.LOUNGE,
      priceLevel: 3,
      ...inAreaCoords,
      ...overrides,
    };
  }

  describe('authorization', () => {
    it('rejects a non-admin (CLIENT) from creating a venue', async () => {
      const { accessToken } = await mintTokensForRole(app, UserRole.CLIENT);

      await request(app.getHttpServer())
        .post('/api/venues')
        .set('Authorization', `Bearer ${accessToken}`)
        .send(createVenuePayload())
        .expect(403);
    });

    it('rejects a non-admin (VENUE_OWNER) from listing venues', async () => {
      const { accessToken } = await mintTokensForRole(
        app,
        UserRole.VENUE_OWNER,
      );

      await request(app.getHttpServer())
        .get('/api/venues')
        .set('Authorization', `Bearer ${accessToken}`)
        .expect(403);
    });

    it('rejects an unauthenticated request', async () => {
      await request(app.getHttpServer()).get('/api/venues').expect(401);
    });
  });

  describe('CRUD', () => {
    it('creates a venue and returns it in the list', async () => {
      const createRes = await request(app.getHttpServer())
        .post('/api/venues')
        .set('Authorization', `Bearer ${adminToken}`)
        .send(createVenuePayload({ name: 'CRUD Test Venue' }))
        .expect(201);

      expect(createRes.body.id).toBeDefined();
      expect(createRes.body.validationStatus).toBe('ONBOARDING');

      const listRes = await request(app.getHttpServer())
        .get('/api/venues')
        .set('Authorization', `Bearer ${adminToken}`)
        .expect(200);

      expect(
        listRes.body.data.some(
          (v: { id: string }) => v.id === createRes.body.id,
        ),
      ).toBe(true);
    });

    it('updates a venue, including its status', async () => {
      const createRes = await request(app.getHttpServer())
        .post('/api/venues')
        .set('Authorization', `Bearer ${adminToken}`)
        .send(createVenuePayload({ name: 'To Be Updated' }))
        .expect(201);

      const updateRes = await request(app.getHttpServer())
        .patch(`/api/venues/${createRes.body.id}`)
        .set('Authorization', `Bearer ${adminToken}`)
        .send({ validationStatus: 'ACTIVE', priceLevel: 4 })
        .expect(200);

      expect(updateRes.body.validationStatus).toBe('ACTIVE');
      expect(updateRes.body.priceLevel).toBe(4);
    });

    it('404s for an unknown venue id', async () => {
      await request(app.getHttpServer())
        .get('/api/venues/00000000-0000-0000-0000-000000000000')
        .set('Authorization', `Bearer ${adminToken}`)
        .expect(404);
    });

    it('deactivates a venue', async () => {
      const createRes = await request(app.getHttpServer())
        .post('/api/venues')
        .set('Authorization', `Bearer ${adminToken}`)
        .send(createVenuePayload({ name: 'To Be Deactivated' }))
        .expect(201);

      await request(app.getHttpServer())
        .delete(`/api/venues/${createRes.body.id}`)
        .set('Authorization', `Bearer ${adminToken}`)
        .expect(200);

      const getRes = await request(app.getHttpServer())
        .get(`/api/venues/${createRes.body.id}`)
        .set('Authorization', `Bearer ${adminToken}`)
        .expect(200);

      expect(getRes.body.isActive).toBe(false);
    });
  });

  describe('launch-area membership', () => {
    it('marks an in-area venue inLaunchArea = true', async () => {
      const res = await request(app.getHttpServer())
        .post('/api/venues')
        .set('Authorization', `Bearer ${adminToken}`)
        .send(createVenuePayload({ name: 'In Zone 4' }))
        .expect(201);

      expect(res.body.inLaunchArea).toBe(true);
    });

    it('marks an out-of-area venue inLaunchArea = false', async () => {
      const res = await request(app.getHttpServer())
        .post('/api/venues')
        .set('Authorization', `Bearer ${adminToken}`)
        .send(createVenuePayload({ name: 'Hors Zone', ...outOfAreaCoords }))
        .expect(201);

      expect(res.body.inLaunchArea).toBe(false);
    });

    it('recomputes inLaunchArea when coordinates move out of area', async () => {
      const createRes = await request(app.getHttpServer())
        .post('/api/venues')
        .set('Authorization', `Bearer ${adminToken}`)
        .send(createVenuePayload({ name: 'Moving Venue' }))
        .expect(201);
      expect(createRes.body.inLaunchArea).toBe(true);

      const updateRes = await request(app.getHttpServer())
        .patch(`/api/venues/${createRes.body.id}`)
        .set('Authorization', `Bearer ${adminToken}`)
        .send(outOfAreaCoords)
        .expect(200);

      expect(updateRes.body.inLaunchArea).toBe(false);
    });
  });

  describe('owner provisioning', () => {
    it('binds a new owner, and that phone signs in (ticket 04 flow) as VENUE_OWNER', async () => {
      const createRes = await request(app.getHttpServer())
        .post('/api/venues')
        .set('Authorization', `Bearer ${adminToken}`)
        .send(createVenuePayload({ name: 'Owner Bind Venue' }))
        .expect(201);

      const ownerPhone = uniquePhone();
      const bindRes = await request(app.getHttpServer())
        .post(`/api/venues/${createRes.body.id}/owner`)
        .set('Authorization', `Bearer ${adminToken}`)
        .send({ phone: ownerPhone, firstName: 'Awa', lastName: 'Traoré' })
        .expect(201);

      expect(bindRes.body.ownerUserId).toBeDefined();
      expect(bindRes.body.owner).toMatchObject({
        phone: ownerPhone,
        firstName: 'Awa',
        lastName: 'Traoré',
      });

      const http = app.getHttpServer();
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

      expect(verifyRes.body.user.id).toBe(bindRes.body.ownerUserId);
      expect(verifyRes.body.user.role).toBe('VENUE_OWNER');
    });

    it('unbinds an owner', async () => {
      const createRes = await request(app.getHttpServer())
        .post('/api/venues')
        .set('Authorization', `Bearer ${adminToken}`)
        .send(createVenuePayload({ name: 'Owner Unbind Venue' }))
        .expect(201);

      await request(app.getHttpServer())
        .post(`/api/venues/${createRes.body.id}/owner`)
        .set('Authorization', `Bearer ${adminToken}`)
        .send({ phone: uniquePhone() })
        .expect(201);

      const unbindRes = await request(app.getHttpServer())
        .delete(`/api/venues/${createRes.body.id}/owner`)
        .set('Authorization', `Bearer ${adminToken}`)
        .expect(200);

      expect(unbindRes.body.ownerUserId).toBeNull();
      expect(unbindRes.body.owner).toBeNull();
    });

    it('re-binding the same phone to a different venue upgrades an existing CLIENT to VENUE_OWNER', async () => {
      const phone = uniquePhone();

      // First, the person signs up as an ordinary client via the OTP flow.
      const http = app.getHttpServer();
      await request(http)
        .post('/api/auth/request-code')
        .send({ phone })
        .expect(204);
      const { FakeSmsProvider } =
        await import('../src/common/sms/fake-sms.provider');
      const code = app.get(FakeSmsProvider).getLastCode(phone);
      const verifyRes = await request(http)
        .post('/api/auth/verify-code')
        .send({ phone, code, ageConfirmed: true })
        .expect(200);
      expect(verifyRes.body.user.role).toBe('CLIENT');

      const venueRes = await request(http)
        .post('/api/venues')
        .set('Authorization', `Bearer ${adminToken}`)
        .send(createVenuePayload({ name: 'Upgrade Venue' }))
        .expect(201);

      const bindRes = await request(http)
        .post(`/api/venues/${venueRes.body.id}/owner`)
        .set('Authorization', `Bearer ${adminToken}`)
        .send({ phone })
        .expect(201);

      expect(bindRes.body.ownerUserId).toBe(verifyRes.body.user.id);
    });
  });
});
