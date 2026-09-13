/** Decodes a JWT's payload without verifying its signature (server already did). */
export function decodeJwtPayload<T = Record<string, unknown>>(
  token: string
): T | null {
  try {
    return JSON.parse(atob(token.split('.')[1])) as T
  } catch {
    return null
  }
}

/**
 * Checks if a JWT token is expired.
 * Uses a 30-second buffer for clock skew.
 */
export function isTokenExpired(token: string): boolean {
  const payload = decodeJwtPayload<{ exp?: number }>(token)
  if (!payload) return true
  return Date.now() / 1000 >= (payload.exp ?? 0) - 30
}
