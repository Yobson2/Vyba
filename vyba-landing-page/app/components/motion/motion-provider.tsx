"use client";

import { LazyMotion, MotionConfig } from "framer-motion";

const loadFeatures = () => import("./motion-features").then((mod) => mod.default);

/**
 * - LazyMotion: components use the lightweight `m.*` and the feature bundle loads
 *   after hydration (strict: a stray `motion.*` import throws in development).
 * - MotionConfig: honour prefers-reduced-motion for every animation on the site.
 */
export function MotionProvider({ children }: { children: React.ReactNode }) {
  return (
    <LazyMotion features={loadFeatures} strict>
      <MotionConfig reducedMotion="user">{children}</MotionConfig>
    </LazyMotion>
  );
}
