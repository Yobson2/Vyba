import { AttributionCapture } from '@/components/AttributionCapture';
import { FeedItemCard } from '@/components/FeedItemCard';
import { getZone4Feed } from '@/lib/api';

// Always render per-request — the feed order/membership is time-sensitive,
// never a build-time snapshot. Also sidesteps prerendering at build time
// (when there's no live backend to fetch from).
export const dynamic = 'force-dynamic';

export default async function Zone4Page() {
  const items = await getZone4Feed();

  return (
    <main className="feed-page">
      <AttributionCapture />

      <h1 className="feed-page__title">Zone 4</h1>

      {items.length === 0 ? (
        <p className="feed-page__empty">
          C&apos;est calme ce soir à Zone 4. Revenez plus tard.
        </p>
      ) : (
        <div className="feed-page__list">
          {items.map((item) => (
            <FeedItemCard key={item.id} item={item} />
          ))}
        </div>
      )}
    </main>
  );
}
