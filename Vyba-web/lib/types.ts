/** Mirrors the backend's public payloads exactly (Vyba-backend `VenueDetail` / `PublicFeedItem`). */

export type VenueType = 'CLUB' | 'BAR' | 'LOUNGE' | 'MAQUIS';

export interface VenueTonight {
  isLive: boolean;
  liveSince: string | null;
  headline: string | null;
  djName: string | null;
  goingCount: number;
}

export interface PromoSummary {
  id: string;
  title: string;
  description: string;
  publishedAt: string;
}

export interface VenueDetail {
  id: string;
  name: string;
  description: string | null;
  address: string | null;
  latitude: number;
  longitude: number;
  venueType: VenueType;
  priceLevel: number;
  photos: string[];
  inLaunchArea: boolean;
  promos: PromoSummary[];
  followerCount: number;
  isFollowing: boolean;
  tonight: VenueTonight | null;
}

export type FeedItemType =
  | 'VENUE_UPDATE'
  | 'LIVE_TONIGHT'
  | 'PROMO'
  | 'EVENT'
  | 'EDITORIAL'
  | 'GOING_MILESTONE'
  | 'PHOTO';

export interface PublicFeedItem {
  id: string;
  type: FeedItemType;
  venue: { id: string; name: string; venueType: VenueType } | null;
  startsAt: string | null;
  expiresAt: string | null;
  publishedAt: string;
  payload: Record<string, unknown> | null;
}
