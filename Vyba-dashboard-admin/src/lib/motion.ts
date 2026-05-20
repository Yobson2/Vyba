import type { Variants } from 'framer-motion'

// Durations aligned with mobile AppMotion
export const duration = {
  instant: 0.1,   // 100ms — ripples, icon state changes
  fast: 0.2,      // 200ms — chip selection, toggle, color change
  normal: 0.3,    // 300ms — card expand, page fade, tab switch
  slow: 0.45,     // 450ms — modal enter, bottom sheet, success anim
  dramatic: 0.6,  // 600ms — onboarding, first-launch, hero animations
} as const

// Easings aligned with mobile AppMotion curves
export const ease = {
  default: [0.33, 0, 0.67, 1] as const,      // easeOutCubic (mobile default)
  enter: [0.25, 0, 0.5, 1] as const,          // easeOutQuart (mobile enter)
  exit: [0.4, 0, 1, 1] as const,              // easeInCubic (mobile exit)
  emphasized: [0.2, 0, 0, 1] as const,        // mobile emphasized curve
  bounce: [0.68, -0.55, 0.265, 1.55] as const,
  in: [0.4, 0, 1, 1] as const,
  out: [0, 0, 0.2, 1] as const,
  inOut: [0.4, 0, 0.2, 1] as const,
}

export const fadeIn: Variants = {
  hidden: { opacity: 0 },
  visible: {
    opacity: 1,
    transition: { duration: duration.normal, ease: ease.default },
  },
}

export const fadeSlideUp: Variants = {
  hidden: { opacity: 0, y: 16 },
  visible: {
    opacity: 1,
    y: 0,
    transition: { duration: duration.normal, ease: ease.default },
  },
}

export const fadeSlideDown: Variants = {
  hidden: { opacity: 0, y: -16 },
  visible: {
    opacity: 1,
    y: 0,
    transition: { duration: duration.normal, ease: ease.default },
  },
}

export const scaleIn: Variants = {
  hidden: { opacity: 0, scale: 0.95 },
  visible: {
    opacity: 1,
    scale: 1,
    transition: { duration: duration.normal, ease: ease.default },
  },
}

export const staggerContainer: Variants = {
  hidden: { opacity: 0 },
  visible: {
    opacity: 1,
    transition: {
      staggerChildren: 0.05,   // 50ms stagger delay (mobile AppMotion)
      delayChildren: 0.05,
    },
  },
}

export const staggerItem: Variants = {
  hidden: { opacity: 0, y: 20 },
  visible: {
    opacity: 1,
    y: 0,
    transition: { duration: duration.normal, ease: ease.default },
  },
}

export const pageTransition: Variants = {
  initial: { opacity: 0, x: 10 },
  animate: {
    opacity: 1,
    x: 0,
    transition: { duration: duration.normal, ease: ease.default },
  },
  exit: {
    opacity: 0,
    x: -10,
    transition: { duration: duration.fast, ease: ease.exit },
  },
}

// Map of variant names for use with AnimatedContainer
export const variants = {
  fadeIn,
  fadeSlideUp,
  fadeSlideDown,
  scaleIn,
} as const

export type VariantName = keyof typeof variants
