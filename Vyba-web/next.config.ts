import type { NextConfig } from 'next';
import { fileURLToPath } from 'url';
import { dirname } from 'path';

const __dirname = dirname(fileURLToPath(import.meta.url));

/**
 * Kept deliberately minimal — the QR-scan performance budget (ADR-0004: <1s
 * where achievable, 2.5s hard ceiling on a throttled low-end device) rules
 * out anything that adds client JS weight. No image optimizer config beyond
 * defaults, no bundle-inflating plugins.
 */
const nextConfig: NextConfig = {
  reactStrictMode: true,
  poweredByHeader: false,
  // A stray lockfile elsewhere on this machine makes Next.js misdetect the
  // workspace root; pin it explicitly to this project.
  outputFileTracingRoot: __dirname,
};

export default nextConfig;
