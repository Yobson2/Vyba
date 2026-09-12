import type { NextConfig } from 'next';

/**
 * Kept deliberately minimal — the QR-scan performance budget (ADR-0004: <1s
 * where achievable, 2.5s hard ceiling on a throttled low-end device) rules
 * out anything that adds client JS weight. No image optimizer config beyond
 * defaults, no bundle-inflating plugins.
 */
const nextConfig: NextConfig = {
  reactStrictMode: true,
  poweredByHeader: false,
};

export default nextConfig;
