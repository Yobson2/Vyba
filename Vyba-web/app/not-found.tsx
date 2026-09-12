import Link from 'next/link';

export default function NotFound() {
  return (
    <main className="venue-page">
      <h1 className="venue-page__name">Lieu introuvable</h1>
      <p className="venue-page__description">
        Ce lieu n&apos;existe pas ou n&apos;est plus actif.
      </p>
      <Link href="/zone4" className="button button--primary">
        Voir ce qui se passe à Zone 4
      </Link>
    </main>
  );
}
