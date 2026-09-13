import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication, ValidationPipe } from '@nestjs/common';
import request from 'supertest';
import { AppModule } from '../src/app.module';
import { UserRole } from '../src/common/constants/roles.constant';
import { VenueType } from '../src/modules/venues/entities/venue.entity';
import { mintTokensForRole } from './utils/auth-e2e.helper';

/**
 * Venue discovery e2e harness (ADR-0005): `GET /api/discover/venues` is not
 * geofenced — any active + validated venue is a candidate regardless of
 * location, text search matches name/address, and lat/lng sorts by distance
 * (with an optional radius cutoff).
 */
describe('Venue discovery (e2e)', () => {
  let app: INestApplication;
  let adminToken: string;
  let clientToken: string;

  // Roughly Zone 4 / Marcory.
  const nearCoords = { latitude: 5.285, longitude: -3.985 };
  // Far away (Le Plateau, across the lagoon) — no longer excluded.
  const farCoords = { latitude: 5.32, longitude: -4.02 };

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
        transformOptions: { enableImplicitConversion: true },
      }),
    );
    await app.init();

    ({ accessToken: adminToken } = await mintTokensForRole(
      app,
      UserRole.ADMIN,
    ));
    ({ accessToken: clientToken } = await mintTokensForRole(
      app,
      UserRole.CLIENT,
    ));
  });

  afterAll(async () => {
    await app.close();
  });

  async function createActiveVenue(overrides: Record<string, unknown> = {}) {
    const http = app.getHttpServer();
    const createRes = await request(http)
      .post('/api/venues')
      .set('Authorization', `Bearer ${adminToken}`)
      .send({
        name: 'Le Boony',
        venueType: VenueType.LOUNGE,
        priceLevel: 2,
        ...nearCoords,
        ...overrides,
      })
      .expect(201);

    await request(http)
      .patch(`/api/venues/${createRes.body.id}`)
      .set('Authorization', `Bearer ${adminToken}`)
      .send({ validationStatus: 'ACTIVE' })
      .expect(200);

    return createRes.body.id as string;
  }

  it('requires auth', async () => {
    await request(app.getHttpServer()).get('/api/discover/venues').expect(401);
  });

  it('lists a far-away venue just like a nearby one — discovery is not geofenced', async () => {
    const farId = await createActiveVenue({
      name: `Far Venue ${Date.now()}`,
      ...farCoords,
    });

    const res = await request(app.getHttpServer())
      .get('/api/discover/venues')
      .set('Authorization', `Bearer ${clientToken}`)
      .expect(200);

    expect(
      (res.body.data as Array<{ id: string }>).some((v) => v.id === farId),
    ).toBe(true);
  });

  it('text search matches by name', async () => {
    const uniqueName = `Le Zenith Unique ${Date.now()}`;
    const venueId = await createActiveVenue({ name: uniqueName });

    const res = await request(app.getHttpServer())
      .get('/api/discover/venues')
      .query({ query: 'Zenith Unique' })
      .set('Authorization', `Bearer ${clientToken}`)
      .expect(200);

    const ids = (res.body.data as Array<{ id: string }>).map((v) => v.id);
    expect(ids).toContain(venueId);
    expect(ids.length).toBe(1);
  });

  it('sorts by distance and reports distanceKm when lat/lng are given', async () => {
    const nearId = await createActiveVenue({
      name: `Near Venue ${Date.now()}`,
      ...nearCoords,
    });
    const farId = await createActiveVenue({
      name: `Far Venue ${Date.now()}`,
      ...farCoords,
    });

    const res = await request(app.getHttpServer())
      .get('/api/discover/venues')
      .query({ lat: nearCoords.latitude, lng: nearCoords.longitude })
      .set('Authorization', `Bearer ${clientToken}`)
      .expect(200);

    const data = res.body.data as Array<{ id: string; distanceKm: number }>;
    const nearIndex = data.findIndex((v) => v.id === nearId);
    const farIndex = data.findIndex((v) => v.id === farId);
    expect(nearIndex).toBeGreaterThanOrEqual(0);
    expect(farIndex).toBeGreaterThan(nearIndex);
    expect(data[nearIndex].distanceKm).toBeLessThan(data[farIndex].distanceKm);
  });

  it('radiusKm excludes venues beyond the cutoff', async () => {
    const nearId = await createActiveVenue({
      name: `Radius Near ${Date.now()}`,
      ...nearCoords,
    });
    const farId = await createActiveVenue({
      name: `Radius Far ${Date.now()}`,
      ...farCoords,
    });

    const res = await request(app.getHttpServer())
      .get('/api/discover/venues')
      .query({
        lat: nearCoords.latitude,
        lng: nearCoords.longitude,
        radiusKm: 2,
      })
      .set('Authorization', `Bearer ${clientToken}`)
      .expect(200);

    const ids = (res.body.data as Array<{ id: string }>).map((v) => v.id);
    expect(ids).toContain(nearId);
    expect(ids).not.toContain(farId);
  });

  it('excludes non-ACTIVE venues', async () => {
    const http = app.getHttpServer();
    const createRes = await request(http)
      .post('/api/venues')
      .set('Authorization', `Bearer ${adminToken}`)
      .send({
        name: `Onboarding Venue ${Date.now()}`,
        venueType: VenueType.BAR,
        priceLevel: 1,
        ...nearCoords,
      })
      .expect(201);

    const res = await request(http)
      .get('/api/discover/venues')
      .set('Authorization', `Bearer ${clientToken}`)
      .expect(200);

    expect(
      (res.body.data as Array<{ id: string }>).some(
        (v) => v.id === createRes.body.id,
      ),
    ).toBe(false);
  });
});
