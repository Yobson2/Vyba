import type { Metadata, Viewport } from "next";
import { Epilogue, Inter, Space_Mono } from "next/font/google";
import "./globals.css";
import { routing } from "@/app/i18n/routing";
import { siteConfig } from "@/app/lib/constants";

// Same type stack as the app (Vyba-mobile-app AppTypography).
const epilogue = Epilogue({
  subsets: ["latin"],
  variable: "--font-epilogue",
  weight: ["700", "800"],
  display: "swap",
});

const inter = Inter({
  subsets: ["latin"],
  variable: "--font-inter",
  display: "swap",
});

const spaceMono = Space_Mono({
  subsets: ["latin"],
  variable: "--font-space-mono",
  weight: ["400"],
  display: "swap",
});

export const metadata: Metadata = {
  metadataBase: new URL(siteConfig.url),
};

export const viewport: Viewport = {
  themeColor: siteConfig.themeColor,
  colorScheme: "dark",
  width: "device-width",
  initialScale: 1,
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  // Single locale (French) — static, so pages can be prerendered.
  const locale = routing.defaultLocale;

  return (
    <html lang={locale} className={`${epilogue.variable} ${inter.variable} ${spaceMono.variable}`}>
      <body>{children}</body>
    </html>
  );
}
