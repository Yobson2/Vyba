import { forwardRef } from "react";
import { cn } from "@/app/lib/utils";

type ButtonVariant = "primary" | "tonal" | "ghost";
type ButtonSize = "sm" | "md" | "lg";

const variantStyles: Record<ButtonVariant, string> = {
  primary: "bg-primary text-on-primary shadow-glow-primary hover:bg-[#c2b8ff] active:bg-primary",
  tonal: "bg-surface-high text-on-surface hover:bg-surface-highest",
  ghost: "text-on-surface hover:bg-surface-high",
};

const sizeStyles: Record<ButtonSize, string> = {
  sm: "h-10 gap-2 px-4 text-sm",
  md: "h-12 gap-2 px-5 text-[15px]",
  lg: "h-14 gap-3 px-7 text-base",
};

/**
 * Shared button styling so links and buttons look identical.
 * Every size keeps a >= 40px hit area; md/lg meet the 48px touch target.
 */
export function buttonStyles({
  variant = "primary",
  size = "md",
  className,
}: { variant?: ButtonVariant; size?: ButtonSize; className?: string } = {}) {
  return cn(
    "inline-flex shrink-0 items-center justify-center rounded-full font-semibold whitespace-nowrap",
    "transition-[background-color,transform,box-shadow] duration-200 ease-[var(--ease-emphasized)] active:scale-[0.97]",
    "disabled:pointer-events-none disabled:opacity-50",
    variantStyles[variant],
    sizeStyles[size],
    className
  );
}

interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: ButtonVariant;
  size?: ButtonSize;
}

export const Button = forwardRef<HTMLButtonElement, ButtonProps>(function Button(
  { variant, size, className, type = "button", ...props },
  ref
) {
  return (
    <button
      ref={ref}
      type={type}
      className={buttonStyles({ variant, size, className })}
      {...props}
    />
  );
});
