/**
 * ===== SITE CONFIGURATION =====
 * Single source of truth for Vyba's public identity on this site.
 * Translatable strings live in /messages/fr.json.
 *
 * Contact channels and store links come from env vars and are never hardcoded.
 * When one is unset, the UI degrades to an honest "bientôt" state instead of a
 * dead link — see StoreButton and WhatsAppButton.
 */
const whatsappNumber = process.env.NEXT_PUBLIC_WHATSAPP_NUMBER?.replace(/\D/g, "");

export const siteConfig = {
  name: "Vyba",
  // TODO: set NEXT_PUBLIC_SITE_URL to the production domain before launch.
  url: process.env.NEXT_PUBLIC_SITE_URL ?? "http://localhost:3000",

  logo: "/assets/logo/vyba-full-dark.svg",
  mark: "/assets/logo/vyba-pulse-mark.svg",
  // Static social preview, rendered with the brand fonts (Epilogue / Inter / Space Mono).
  // Served directly — no redirect — so WhatsApp link previews always resolve.
  ogImage: "/assets/og-image.png",
  themeColor: "#060e20",

  // Android-first distribution (spec §15). Unset until the Play listing is public.
  playStoreUrl: process.env.NEXT_PUBLIC_PLAY_STORE_URL || null,
  // WhatsApp Business is the support channel for users and venue owners (spec §22.4).
  whatsappUrl: whatsappNumber ? `https://wa.me/${whatsappNumber}` : null,
  email: process.env.NEXT_PUBLIC_CONTACT_EMAIL || null,
} as const;

export interface NavLink {
  href: string;
  textKey: "journey" | "going" | "venues" | "faq";
}

export const navLinks: NavLink[] = [
  { href: "/#ce-soir", textKey: "journey" },
  { href: "/#jy-vais", textKey: "going" },
  { href: "/#lieux", textKey: "venues" },
  { href: "/#faq", textKey: "faq" },
];
