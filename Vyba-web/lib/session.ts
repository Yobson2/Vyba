'use client';

const SESSION_KEY = 'vyba_web_session';

export interface Session {
  accessToken: string;
  refreshToken: string;
}

/**
 * The web surface's "secure session, or equivalent" (spec 14): the same
 * JWT pair the app stores in secure device storage, kept in `localStorage`
 * here since this project has no server-side session layer (every backend
 * call is a direct client fetch — see `AttributionCapture`). Never logged.
 */
export function getSession(): Session | null {
  if (typeof window === 'undefined') return null;
  const raw = localStorage.getItem(SESSION_KEY);
  if (!raw) return null;
  try {
    const parsed = JSON.parse(raw) as Partial<Session>;
    if (!parsed.accessToken || !parsed.refreshToken) return null;
    return { accessToken: parsed.accessToken, refreshToken: parsed.refreshToken };
  } catch {
    return null;
  }
}

export function setSession(session: Session): void {
  localStorage.setItem(SESSION_KEY, JSON.stringify(session));
}

export function clearSession(): void {
  localStorage.removeItem(SESSION_KEY);
}

/** Decodes a JWT's `exp` claim (seconds since epoch) without verifying the signature — client-side only cares whether it's still worth sending. */
function expiresAt(token: string): number | null {
  const parts = token.split('.');
  if (parts.length !== 3) return null;
  try {
    const payload = JSON.parse(atob(parts[1].replace(/-/g, '+').replace(/_/g, '/'))) as {
      exp?: number;
    };
    return typeof payload.exp === 'number' ? payload.exp * 1000 : null;
  } catch {
    return null;
  }
}

/** A 10s safety margin so a call doesn't race a token expiring mid-flight. */
export function isExpired(token: string): boolean {
  const exp = expiresAt(token);
  if (exp === null) return true;
  return Date.now() >= exp - 10_000;
}
