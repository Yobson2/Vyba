import { defineRouting } from "next-intl/routing";

// French only for the validation build (spec §2). next-intl stays wired so a
// second locale can be added later without touching components.
export const routing = defineRouting({
  locales: ["fr"],
  defaultLocale: "fr",
  localePrefix: "never",
  // One locale means nothing to remember — and the privacy page promises no cookies.
  localeCookie: false,
});

export type Locale = (typeof routing.locales)[number];
