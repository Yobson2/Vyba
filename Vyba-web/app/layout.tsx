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
      <body>{children}</body>
    </html>
  );
}
