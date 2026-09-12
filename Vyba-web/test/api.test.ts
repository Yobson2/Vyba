import { describe, expect, it } from 'vitest';
import { getVenuePublic, getZone4Feed } from '@/lib/api';
import { mockFeed, mockVenueLive } from './msw/handlers';

/**
 * The project's single test seam (spec 14): MSW mocks the public API,
 * these assert the fetchers hit the right endpoint and shape the response
 * correctly — the layer the venue/zone4 pages build on.
 */
describe('getVenuePublic', () => {
  it('returns the venue for a known id', async () => {
    const venue = await getVenuePublic('venue-1');
    expect(venue).toEqual(mockVenueLive);
  });

  it('returns null for an unknown venue (404)', async () => {
    const venue = await getVenuePublic('does-not-exist');
    expect(venue).toBeNull();
  });
});

describe('getZone4Feed', () => {
  it('returns the feed in server order, unmodified', async () => {
    const items = await getZone4Feed();
    expect(items).toEqual(mockFeed);
  });
});
