import { cn } from "@/app/lib/utils";

interface PhoneFrameProps {
  children: React.ReactNode;
  className?: string;
  /** Status-bar clock. Nightlife previews read better at night. */
  time?: string;
}

/**
 * Device shell for code-rendered product screens. Tonal bezel (never #000),
 * 9:19.5 aspect so it never shifts layout while screens swap inside it.
 */
export function PhoneFrame({ children, className, time = "22:14" }: PhoneFrameProps) {
  return (
    <div
      className={cn(
        "rounded-device bg-surface-bright shadow-device relative aspect-[9/19.5] w-[272px] p-[9px] sm:w-[300px]",
        className
      )}
    >
      <div className="bg-surface relative flex h-full flex-col overflow-hidden rounded-[35px]">
        <div className="text-on-surface flex h-9 shrink-0 items-center justify-between px-6 pt-1 font-mono text-[11px]">
          <span>{time}</span>
          <span className="bg-surface-low absolute top-2 left-1/2 h-[22px] w-[84px] -translate-x-1/2 rounded-full" />
          <span className="flex items-end gap-[2px]" aria-hidden>
            {[5, 7, 9, 11].map((h) => (
              <span key={h} className="bg-on-surface w-[3px] rounded-[1px]" style={{ height: h }} />
            ))}
          </span>
        </div>
        {children}
      </div>
    </div>
  );
}
