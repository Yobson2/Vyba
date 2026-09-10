import type { KnipConfig } from 'knip';

const config: KnipConfig = {
  ignore: [
    'src/components/ui/**',
    'src/routeTree.gen.ts',
    // Unrouted during the validation phase, kept in the tree for post-validation.
    // See docs/validation-mvp/specs/15-dashboard-cleanup.md.
    'src/features/bookings/**',
    'src/features/reviews/**',
    'src/features/landing-page/**',
    // Only consumed by the (now dormant) landing-page feature above.
    'src/config/app.ts',
  ],
  ignoreDependencies: ["tailwindcss", "tw-animate-css"]
};

export default config;
