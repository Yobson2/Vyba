/**
 * Denylist of property-key patterns that must never reach PostHog, whatever
 * a client sends (spec 07: "never a phone number" — generalised to the
 * usual PII/secret shapes rather than a `phone`-only check). Case- and
 * separator-insensitive (`phone`, `phoneNumber`, `phone_number` all match).
 */
const DENYLIST_PATTERNS = [
  /phone/i,
  /otp/i,
  /password/i,
  /token/i,
  /^code$/i,
  /email/i,
];

function isDenylisted(key: string): boolean {
  return DENYLIST_PATTERNS.some((pattern) => pattern.test(key));
}

/** Strips any disallowed key from a client-supplied analytics property bag. */
export function sanitizeAnalyticsProperties(
  properties: Record<string, unknown> | undefined,
): Record<string, unknown> | undefined {
  if (!properties) return undefined;
  const clean: Record<string, unknown> = {};
  for (const [key, value] of Object.entries(properties)) {
    if (isDenylisted(key)) continue;
    clean[key] = value;
  }
  return clean;
}
