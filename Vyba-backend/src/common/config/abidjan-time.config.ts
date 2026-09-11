/**
 * Africa/Abidjan is UTC+0 year-round (no DST), so "today in Abidjan" is
 * literally today's UTC calendar date. Kept as an explicit named helper
 * (not an inline `new Date().toISOString()`) so the "a night is a calendar
 * date in Abidjan local time" rule (spec 02, ADR-0001) has one seam to
 * revisit if the 00:00-04:00 boundary question is ever reopened.
 */
export function abidjanToday(reference: Date = new Date()): string {
  return reference.toISOString().slice(0, 10);
}
