import { http, HttpResponse } from 'msw';
import type { PublicFeedItem, VenueDetail } from '@/lib/types';

const API_BASE = 'http://localhost:3000';

export const mockVenueLive: VenueDetail = {
  id: 'venue-1',
  name: 'Le Boony',
  description: 'Un bar au coeur de Zone 4.',
  address: 'Rue des Jardins, Marcory',
  latitude: 5.285,
  longitude: -3.985,
  venueType: 'BAR',
  priceLevel: 2,
  photos: [],
  inLaunchArea: true,
  promos: [
    {
      id: 'promo-1',
      title: 'Happy hour -50%',
      description: "Jusqu'à 23h",
      publishedAt: new Date().toISOString(),
    },
  ],
  followerCount: 12,
  isFollowing: false,
  tonight: {
    isLive: true,
    liveSince: new Date(Date.now() - 30 * 60 * 1000).toISOString(),
    headline: 'DJ Kobo ce soir',
    djName: 'DJ Kobo',
    goingCount: 8,
  },
};

export const mockVenueQuiet: VenueDetail = {
  ...mockVenueLive,
  id: 'venue-2',
  name: 'Le Calme',
  promos: [],
  tonight: null,
};

export const mockFeed: PublicFeedItem[] = [
  {
    id: 'item-1',
    type: 'LIVE_TONIGHT',
    venue: { id: 'venue-1', name: 'Le Boony', venueType: 'BAR' },
    startsAt: new Date().toISOString(),
    expiresAt: null,
    publishedAt: new Date().toISOString(),
    payload: null,
  },
  {
    id: 'item-2',
    type: 'PROMO',
    venue: { id: 'venue-1', name: 'Le Boony', venueType: 'BAR' },
    startsAt: null,
    expiresAt: null,
    publishedAt: new Date().toISOString(),
    payload: { title: 'Happy hour -50%', description: "Jusqu'à 23h" },
  },
];

/** A well-formed (unsigned) JWT-shaped token whose `exp` claim tests can control. */
export function fakeJwt(expiresInSeconds: number): string {
  const header = { alg: 'none', typ: 'JWT' };
  const payload = {
    userId: 'user-1',
    exp: Math.floor(Date.now() / 1000) + expiresInSeconds,
  };
  const encode = (obj: unknown) =>
    Buffer.from(JSON.stringify(obj)).toString('base64url');
  return `${encode(header)}.${encode(payload)}.signature`;
}

export const mockSession = {
  accessToken: fakeJwt(900),
  refreshToken: fakeJwt(7 * 24 * 3600),
};

export const OTP_CODE = '123456';

export const handlers = [
  http.get(`${API_BASE}/api/venues/:id/public`, ({ params }) => {
    if (params.id === mockVenueLive.id) {
      return HttpResponse.json(mockVenueLive);
    }
    if (params.id === mockVenueQuiet.id) {
      return HttpResponse.json(mockVenueQuiet);
    }
    return new HttpResponse(null, { status: 404 });
  }),
  http.get(`${API_BASE}/api/feed/public`, () => HttpResponse.json(mockFeed)),

  http.post(`${API_BASE}/api/auth/request-code`, () => new HttpResponse(null, { status: 204 })),

  http.post(`${API_BASE}/api/auth/verify-code`, async ({ request }) => {
    const body = (await request.json()) as { code?: string };
    if (body.code !== OTP_CODE) {
      return HttpResponse.json(
        { errors: [{ code: 'AUTH_VERIFY_001', message: 'Invalid code' }] },
        { status: 401 },
      );
    }
    return HttpResponse.json({
      user: { id: 'user-1' },
      accessToken: mockSession.accessToken,
      refreshToken: mockSession.refreshToken,
    });
  }),

  http.post(`${API_BASE}/api/auth/refresh`, () =>
    HttpResponse.json({
      user: { id: 'user-1' },
      accessToken: fakeJwt(900),
      refreshToken: fakeJwt(7 * 24 * 3600),
    }),
  ),

  http.post(`${API_BASE}/api/going`, () => HttpResponse.json({ id: 'going-1' }, { status: 201 })),
];
