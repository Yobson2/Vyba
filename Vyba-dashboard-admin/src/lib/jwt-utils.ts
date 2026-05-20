/**
 * Checks if a JWT token is expired.
 * Uses a 30-second buffer for clock skew.
 */
export function isTokenExpired(token: string): boolean {
  try {
    const payload = JSON.parse(atob(token.split('.')[1]))
    return Date.now() / 1000 >= (payload.exp ?? 0) - 30
  } catch {
    return true
  }
}
