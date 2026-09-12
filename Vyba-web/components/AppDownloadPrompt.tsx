/**
 * Shown only after a completed "J'y vais" (spec 14) — never a blocking
 * interstitial, never before value. `NEXT_PUBLIC_PLAY_STORE_URL` is unset
 * until the app is actually published; the prompt simply doesn't render
 * rather than linking nowhere.
 */
export function AppDownloadPrompt() {
  const playStoreUrl = process.env.NEXT_PUBLIC_PLAY_STORE_URL;
  if (!playStoreUrl) return null;

  return (
    <a
      href={playStoreUrl}
      target="_blank"
      rel="noopener noreferrer"
      className="app-prompt"
    >
      Télécharge l&apos;app pour suivre tes lieux et recevoir les infos
    </a>
  );
}
