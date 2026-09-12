'use client';

/**
 * Backend error shape (`GlobalExceptionFilter`): `{ errors: [{ code, message }] }`.
 * Never surface the raw message — map the typed code to French copy instead.
 */
export class ApiError extends Error {
  constructor(public readonly code: string | undefined) {
    super(code ?? 'UNKNOWN_ERROR');
  }
}

async function extractErrorCode(res: Response): Promise<string | undefined> {
  try {
    const body = (await res.json()) as {
      errors?: Array<{ code?: string }>;
    };
    return body.errors?.[0]?.code;
  } catch {
    return undefined;
  }
}

function apiBaseUrl(): string {
  const url = process.env.NEXT_PUBLIC_API_BASE_URL;
  if (!url) throw new Error('NEXT_PUBLIC_API_BASE_URL is not configured');
  return url;
}

/** Requests (or resends) a phone-OTP code. Never reveals whether the number is known. */
export async function requestCode(phone: string): Promise<void> {
  const res = await fetch(`${apiBaseUrl()}/api/auth/request-code`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ phone }),
  });
  if (!res.ok) throw new ApiError(await extractErrorCode(res));
}

export interface VerifiedSession {
  accessToken: string;
  refreshToken: string;
}

/** Verifies the code and, on success, returns a token pair for the same account the app uses. */
export async function verifyCode(params: {
  phone: string;
  code: string;
  ageConfirmed: boolean;
  clientId?: string;
}): Promise<VerifiedSession> {
  const res = await fetch(`${apiBaseUrl()}/api/auth/verify-code`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(params),
  });
  if (!res.ok) throw new ApiError(await extractErrorCode(res));
  const body = (await res.json()) as VerifiedSession;
  return { accessToken: body.accessToken, refreshToken: body.refreshToken };
}

/** Rotates the session using the refresh token. */
export async function refreshSession(
  refreshToken: string,
): Promise<VerifiedSession> {
  const res = await fetch(`${apiBaseUrl()}/api/auth/refresh`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ refreshToken }),
  });
  if (!res.ok) throw new ApiError(await extractErrorCode(res));
  const body = (await res.json()) as VerifiedSession;
  return { accessToken: body.accessToken, refreshToken: body.refreshToken };
}

/** Maps a backend typed auth error code to French copy — mirrors the mobile app's `otpErrorMessage`. */
export function otpErrorMessage(code: string | undefined): string {
  switch (code) {
    case 'AUTH_VERIFY_001':
      return 'Code incorrect. Réessayez.';
    case 'AUTH_VERIFY_002':
      return 'Ce code a expiré. Demandez-en un nouveau.';
    case 'AUTH_VERIFY_003':
      return 'Confirmez que vous avez 18 ans ou plus pour continuer.';
    case 'AUTH_RATE_002':
      return 'Trop de tentatives. Réessayez dans quelques minutes.';
    case 'AUTH_ACCOUNT_003':
      return 'Ce compte a été désactivé.';
    default:
      return 'Une erreur est survenue. Veuillez réessayer.';
  }
}
