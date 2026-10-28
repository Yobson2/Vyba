import { cn } from "@/app/lib/utils";
import { Reveal } from "@/app/components/motion/reveal";

interface SectionHeaderProps {
  id: string;
  eyebrow: string;
  title: string;
  lead?: string;
  align?: "start" | "center";
  className?: string;
}

/** Eyebrow (mono, like a feed timestamp) + display title + lead. `id` labels the section. */
export function SectionHeader({
  id,
  eyebrow,
  title,
  lead,
  align = "start",
  className,
}: SectionHeaderProps) {
  return (
    <Reveal
      className={cn(
        "flex max-w-2xl flex-col gap-4",
        align === "center" && "mx-auto items-center text-center",
        className
      )}
    >
      <p className="text-primary font-mono text-xs tracking-[0.18em] uppercase">{eyebrow}</p>
      <h2
        id={id}
        className="font-display text-[2rem] leading-[1.08] font-bold tracking-[-0.03em] text-balance sm:text-5xl"
      >
        {title}
      </h2>
      {lead && <p className="text-on-surface-variant text-lg leading-relaxed">{lead}</p>}
    </Reveal>
  );
}
