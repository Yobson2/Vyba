"use client";

import { useEffect, useRef, useState } from "react";
import { AnimatePresence, m, useInView, useReducedMotion } from "framer-motion";
import { FeedCard, type SampleFeedItem } from "@/app/components/device/device-ui";
import { FeedHeader, discoverItems } from "@/app/components/device/screens";
import { sampleVenues as v } from "@/app/components/device/sample-venues";
import { emphasized, layoutSpring } from "@/app/lib/animations";

/**
 * Every sample item, newest first. The feed shows a sliding window of
 * MAX_VISIBLE over this cycle; new items "arrive" from the end, the way the
 * real feed fills up during a night. POOL > MAX_VISIBLE, so no item is ever
 * on screen twice, and the window always overfills the device screen.
 */
const POOL: SampleFeedItem[] = [
  ...discoverItems,
  { id: "e1", type: "editorial", venue: v.comptoir, bodyKey: "editorial" },
  { id: "t1", type: "live_tonight", venue: v.tantie, bodyKey: "maquis", going: 14 },
  { id: "m1", type: "going_milestone", venue: v.bloc, bodyKey: "event", going: 50 },
  { id: "r1", type: "live_tonight", venue: v.terrasse, bodyKey: "djStart", going: 8 },
];

const TICK_MS = 2600;
const MAX_VISIBLE = 5;

type Entry = SampleFeedItem & { key: string };

export function LiveFeedPreview() {
  const ref = useRef<HTMLDivElement>(null);
  const inView = useInView(ref, { amount: 0.3 });
  const reduceMotion = useReducedMotion();
  const [items, setItems] = useState<Entry[]>(() =>
    POOL.slice(0, MAX_VISIBLE).map((i) => ({ ...i, key: i.id }))
  );
  const step = useRef(0);
  const arrivals = useRef(0);

  useEffect(() => {
    if (!inView || reduceMotion) return;

    const id = window.setInterval(() => {
      const n = step.current++;

      // Odd ticks: someone says "J'y vais" somewhere. Even ticks: a new post lands.
      if (n % 2 === 1) {
        setItems((current) => {
          const targets = current.filter(
            (i) => i.type !== "editorial" && i.type !== "going_milestone"
          );
          const target = targets[n % Math.max(targets.length, 1)];
          return current.map((i) =>
            i.key === target?.key ? { ...i, going: (i.going ?? 0) + 1 + (n % 3) } : i
          );
        });
        return;
      }

      // Walk the cycle backwards: the next arrival is always one not on screen.
      const k = arrivals.current++;
      const next = POOL[POOL.length - 1 - (k % POOL.length)]!;
      const entry = { ...next, key: `${next.id}-${k}` };
      setItems((current) => [entry, ...current].slice(0, MAX_VISIBLE));
    }, TICK_MS);

    return () => window.clearInterval(id);
  }, [inView, reduceMotion]);

  return (
    <div ref={ref} className="flex min-h-0 flex-1 flex-col" aria-hidden>
      <FeedHeader />
      <ul className="flex flex-col gap-2 px-3">
        <AnimatePresence initial={false} mode="popLayout">
          {items.map((item) => (
            <m.li
              key={item.key}
              layout
              initial={{ opacity: 0, y: -16, scale: 0.98 }}
              animate={{ opacity: 1, y: 0, scale: 1 }}
              exit={{ opacity: 0, transition: emphasized(0.2) }}
              transition={{ layout: layoutSpring, ...emphasized(0.45) }}
            >
              <FeedCard item={item} />
            </m.li>
          ))}
        </AnimatePresence>
      </ul>
    </div>
  );
}
