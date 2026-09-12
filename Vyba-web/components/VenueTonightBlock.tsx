import type { VenueTonight } from '@/lib/types';

function liveSinceLabel(liveSince: string): string {
  const minutes = Math.max(
    0,
    Math.floor((Date.now() - new Date(liveSince).getTime()) / 60000),
  );
  if (minutes < 60) return `depuis ${minutes} min`;
  const hours = Math.floor(minutes / 60);
  return `depuis ${hours}h`;
}

/** Tonight's status — live/headline/going count, or "rien d'annoncé ce soir" (spec 14). */
export function VenueTonightBlock({ tonight }: { tonight: VenueTonight | null }) {
  if (!tonight || !tonight.isLive) {
    const goingCount = tonight?.goingCount ?? 0;
    return (
      <div className="tonight-block tonight-block--quiet">
        <span>Rien d&apos;annoncé ce soir</span>
        {goingCount > 0 && (
          <span className="tonight-block__count">{goingCount} y vont</span>
        )}
      </div>
    );
  }

  const parts = [
    "C'est live",
    tonight.liveSince ? liveSinceLabel(tonight.liveSince) : null,
    tonight.headline || tonight.djName || null,
  ].filter(Boolean);

  return (
    <div className="tonight-block tonight-block--live">
      <span className="tonight-block__dot" aria-hidden />
      <span>{parts.join(' · ')}</span>
      {tonight.goingCount > 0 && (
        <span className="tonight-block__count">
          {`${tonight.goingCount} personne${tonight.goingCount > 1 ? 's' : ''} y ${tonight.goingCount > 1 ? 'vont' : 'va'} ce soir`}
        </span>
      )}
    </div>
  );
}
