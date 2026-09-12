import Link from 'next/link';
import { notFound } from 'next/navigation';
import { AttributionCapture } from '@/components/AttributionCapture';
import { GoingSection } from '@/components/GoingSection';
import { PromoList } from '@/components/PromoList';
import { getVenuePublic } from '@/lib/api';
import { googleMapsUrl } from '@/lib/maps';

// Always render per-request — tonight's status/going count is time-sensitive.
export const dynamic = 'force-dynamic';

const VENUE_TYPE_LABEL: Record<string, string> = {
  CLUB: 'Club',
  BAR: 'Bar',
  LOUNGE: 'Lounge',
  MAQUIS: 'Maquis',
};

export default async function VenuePage({
  params,
}: {
  params: Promise<{ venueId: string }>;
}) {
  const { venueId } = await params;
  const venue = await getVenuePublic(venueId);

  if (!venue) {
    notFound();
  }

  return (
    <main className="venue-page">
      <AttributionCapture venueIdFallback={venue.id} />

      <div className="venue-page__header">
        <h1 className="venue-page__name">{venue.name}</h1>
        <p className="venue-page__meta">
          {VENUE_TYPE_LABEL[venue.venueType] ?? venue.venueType}
          {venue.followerCount > 0 && ` · ${venue.followerCount} abonnés`}
        </p>
      </div>

      <GoingSection venueId={venue.id} tonight={venue.tonight} />

      <PromoList promos={venue.promos} />

      {venue.address && (
        <div className="venue-page__address">
          <span>{venue.address}</span>
          <a
            href={googleMapsUrl(venue.latitude, venue.longitude)}
            target="_blank"
            rel="noopener noreferrer"
            className="button button--outline"
          >
            Ouvrir dans Google Maps
          </a>
        </div>
      )}

      {venue.description && (
        <p className="venue-page__description">{venue.description}</p>
      )}

      <Link href="/zone4" className="button button--primary">
        Voir ce qui se passe à Zone 4
      </Link>
    </main>
  );
}
