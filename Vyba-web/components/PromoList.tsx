import type { PromoSummary } from '@/lib/types';

/** Tonight's active promo(s) for this venue (spec 14 §3). */
export function PromoList({ promos }: { promos: PromoSummary[] }) {
  if (promos.length === 0) return null;

  return (
    <div className="promo-list">
      {promos.map((promo) => (
        <div key={promo.id} className="promo-card">
          <span className="promo-card__title">{promo.title}</span>
          {promo.description && (
            <span className="promo-card__description">{promo.description}</span>
          )}
        </div>
      ))}
    </div>
  );
}
