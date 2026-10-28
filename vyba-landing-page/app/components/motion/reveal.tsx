"use client";

import { m, type HTMLMotionProps } from "framer-motion";
import { DURATION, emphasized } from "@/app/lib/animations";

interface RevealProps extends HTMLMotionProps<"div"> {
  delay?: number;
  /** Vertical travel in px. Kept small: reveals support hierarchy, they don't perform. */
  y?: number;
  /** Render as a list item when revealing members of a <ul>/<ol>. */
  as?: "div" | "li";
}

/**
 * Fade + short rise when the block enters the viewport, once.
 * Reduced motion is handled globally by <MotionConfig reducedMotion="user">.
 */
export function Reveal({ delay = 0, y = 24, as = "div", children, ...props }: RevealProps) {
  const Component = (as === "li" ? m.li : m.div) as typeof m.div;
  return (
    <Component
      initial={{ opacity: 0, y }}
      whileInView={{ opacity: 1, y: 0 }}
      viewport={{ once: true, margin: "0px 0px -12% 0px" }}
      transition={emphasized(DURATION.dramatic, delay)}
      {...props}
    >
      {children}
    </Component>
  );
}
