import Link from 'next/link';
import type { PublicFeedItem } from '@/lib/types';

function venueTypeLabel(type: string): string {
  switch (type) {
    case 'CLUB':
      return 'Club';
    case 'BAR':
      return 'Bar';
    case 'LOUNGE':
      return 'Lounge';
    case 'MAQUIS':
      return 'Maquis';
    default:
      return type;
  }
}

/** One Zone 4 feed card — distinct treatment per type, server order preserved (spec 03/14). */
export function FeedItemCard({ item }: { item: PublicFeedItem }) {
  const venueHref = item.venue ? `/${item.venue.id}` : undefined;
  const payload = item.payload ?? {};

  const body = (() => {
    switch (item.type) {
      case 'LIVE_TONIGHT':
        return (
          <>
            <span className="feed-card__kicker feed-card__kicker--live">
              EN CE MOMENT
            </span>
            <span className="feed-card__title">
              {item.venue?.name ?? 'Une venue'}
            </span>
            <span className="feed-card__subtitle">C&apos;est live ce soir</span>
          </>
        );
      case 'PROMO':
        return (
          <>
            <span className="feed-card__kicker feed-card__kicker--promo">
              PROMO
            </span>
            <span className="feed-card__title">
              {(payload.title as string) ?? item.venue?.name}
            </span>
            {payload.description ? (
              <span className="feed-card__subtitle">
                {payload.description as string}
              </span>
            ) : null}
          </>
        );
      case 'EDITORIAL':
        return (
          <>
            <span className="feed-card__kicker">VYBA</span>
            <span className="feed-card__title">
              {(payload.title as string) ?? 'Zone 4'}
            </span>
            {payload.body ? (
              <span className="feed-card__subtitle">
                {payload.body as string}
              </span>
            ) : null}
          </>
        );
      case 'GOING_MILESTONE':
        return (
          <>
            <span className="feed-card__kicker feed-card__kicker--live">
              CE SOIR
            </span>
            <span className="feed-card__title">
              {item.venue?.name ?? 'Une venue'}
            </span>
            <span className="feed-card__subtitle">
              {String(payload.threshold ?? '')} personnes y vont ce soir
            </span>
          </>
        );
      default:
        return (
          <span className="feed-card__title">
            {item.venue?.name ?? venueTypeLabel(item.type)}
          </span>
        );
    }
  })();

  const content = <div className="feed-card">{body}</div>;

  return venueHref ? <Link href={venueHref}>{content}</Link> : content;
}
