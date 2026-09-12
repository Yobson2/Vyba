import type { Metadata } from 'next';
import './globals.css';

export const metadata: Metadata = {
  title: 'Vyba',
  description: "Qu'est-ce qui se passe ce soir à Zone 4 ?",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="fr">
      {/* suppressHydrationWarning: browser extensions (e.g. ColorZilla's
          cz-shortcut-listen) inject attributes onto <body> before React
          hydrates; this only ignores mismatches on this element's own
          attributes, not on its children. */}
      <body suppressHydrationWarning>{children}</body>
    </html>
  );
}
