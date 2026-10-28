import type { Transition } from "framer-motion";

// ─── Motion tokens — mirror Vyba-mobile-app AppMotion ────────────────

/** AppMotion.emphasizedCurve */
export const EASE_EMPHASIZED = [0.2, 0, 0, 1] as const;

export const DURATION = {
  fast: 0.2,
  normal: 0.3,
  slow: 0.45,
  dramatic: 0.6,
} as const;

/** AppMotion.staggerDelay */
export const STAGGER = 0.05;

export function emphasized(duration: number = DURATION.slow, delay = 0): Transition {
  return { duration, delay, ease: EASE_EMPHASIZED };
}

/** Spring used for layout changes (feed items shifting, counters). */
export const layoutSpring: Transition = { type: "spring", stiffness: 420, damping: 38 };
