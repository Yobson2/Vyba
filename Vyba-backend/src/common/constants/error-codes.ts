/**
 * Centralized Error Code Registry
 *
 * ALL errors in the system MUST use one of these codes.
 * Format: SERVICE_CATEGORY_NUMBER
 */

export enum AuthErrorCode {
  INVALID_CREDENTIALS = 'AUTH_LOGIN_001',
  TOKEN_EXPIRED = 'AUTH_LOGIN_002',
  TOKEN_INVALID = 'AUTH_LOGIN_003',
  TOKEN_MALFORMED = 'AUTH_LOGIN_004',
  REFRESH_TOKEN_INVALID = 'AUTH_LOGIN_005',
  REFRESH_TOKEN_EXPIRED = 'AUTH_LOGIN_006',

  ACCOUNT_LOCKED = 'AUTH_ACCOUNT_001',
  ACCOUNT_SUSPENDED = 'AUTH_ACCOUNT_002',
  ACCOUNT_DEACTIVATED = 'AUTH_ACCOUNT_003',
  EMAIL_NOT_VERIFIED = 'AUTH_ACCOUNT_004',

  TOO_MANY_LOGIN_ATTEMPTS = 'AUTH_RATE_001',
  OTP_RATE_LIMITED = 'AUTH_RATE_002',
  TOO_MANY_PASSWORD_RESETS = 'AUTH_RATE_003',

  USER_ALREADY_EXISTS = 'AUTH_REGISTER_001',
  EMAIL_ALREADY_EXISTS = 'AUTH_REGISTER_002',

  UNAUTHORIZED_ROLE = 'AUTH_AUTHZ_001',
  INSUFFICIENT_PERMISSIONS = 'AUTH_AUTHZ_002',

  INVALID_RESET_TOKEN = 'AUTH_RESET_001',
  RESET_TOKEN_EXPIRED = 'AUTH_RESET_002',
  PASSWORD_VALIDATION_FAILED = 'AUTH_RESET_003',

  INVALID_VERIFICATION_CODE = 'AUTH_VERIFY_001',
  VERIFICATION_CODE_EXPIRED = 'AUTH_VERIFY_002',
  AGE_CONFIRMATION_REQUIRED = 'AUTH_VERIFY_003',

  ADMIN_EMAIL_ALREADY_EXISTS = 'AUTH_ADMIN_001',
  ADMIN_CANNOT_DEACTIVATE_SELF = 'AUTH_ADMIN_002',
  ADMIN_CANNOT_DEACTIVATE_LAST = 'AUTH_ADMIN_003',
}

export enum UserErrorCode {
  USER_NOT_FOUND = 'USER_PROFILE_001',
  USER_ALREADY_EXISTS = 'USER_PROFILE_002',
  INVALID_USER_DATA = 'USER_PROFILE_003',
  PROFILE_UPDATE_FAILED = 'USER_PROFILE_004',

  USER_SERVICE_ERROR = 'USER_SERVICE_001',
  USER_DATABASE_ERROR = 'USER_SERVICE_002',
}

export enum VenueErrorCode {
  VENUE_NOT_FOUND = 'VENUE_PROFILE_001',
  VENUE_NOT_OWNED = 'VENUE_PROFILE_002',
  VENUE_NIGHT_NOT_FOUND = 'VENUE_PROFILE_003',
}

export enum FeedErrorCode {
  FEED_ITEM_NOT_FOUND = 'FEED_ITEM_001',
}

export enum GoingErrorCode {
  GOING_NOT_FOUND = 'GOING_001',
  GOING_SELF_MARK = 'GOING_002',
  GOING_RATE_LIMITED = 'GOING_003',
  GOING_LOCKED = 'GOING_004',
}

export enum ReservationErrorCode {
  RESERVATION_NOT_FOUND = 'RESERVATION_001',
  RESERVATION_SELF_MARK = 'RESERVATION_002',
  RESERVATION_RATE_LIMITED = 'RESERVATION_003',
  RESERVATION_LOCKED = 'RESERVATION_004',
  RESERVATION_DISABLED = 'RESERVATION_005',
  RESERVATION_FULL = 'RESERVATION_006',
}

export enum AnalyticsErrorCode {
  UNKNOWN_EVENT = 'ANALYTICS_TRACK_001',
}

export enum MediaErrorCode {
  MEDIA_ASSET_NOT_FOUND = 'MEDIA_ASSET_001',
  MEDIA_FORBIDDEN = 'MEDIA_ASSET_002',
}

export enum NotificationErrorCode {
  BROADCAST_ALREADY_SENT = 'NOTIFICATION_BROADCAST_001',
}

export enum SystemErrorCode {
  DATABASE_CONNECTION_FAILED = 'SYSTEM_DB_001',
  DATABASE_QUERY_ERROR = 'SYSTEM_DB_002',
  DATABASE_TIMEOUT = 'SYSTEM_DB_003',
  DATABASE_TRANSACTION_FAILED = 'SYSTEM_DB_004',

  REDIS_CONNECTION_FAILED = 'SYSTEM_CACHE_001',
  CACHE_READ_ERROR = 'SYSTEM_CACHE_002',
  CACHE_WRITE_ERROR = 'SYSTEM_CACHE_003',

  QUEUE_PUBLISH_FAILED = 'SYSTEM_QUEUE_001',
  QUEUE_PROCESSING_ERROR = 'SYSTEM_QUEUE_002',

  MISSING_CONFIGURATION = 'SYSTEM_CONFIG_001',
  INVALID_CONFIGURATION = 'SYSTEM_CONFIG_002',

  NETWORK_ERROR = 'SYSTEM_NETWORK_001',
  REQUEST_TIMEOUT = 'SYSTEM_NETWORK_002',

  UNEXPECTED_ERROR = 'SYSTEM_INTERNAL_001',
  OPERATION_FAILED = 'SYSTEM_INTERNAL_002',
}

export type ErrorCode =
  | AuthErrorCode
  | UserErrorCode
  | VenueErrorCode
  | FeedErrorCode
  | GoingErrorCode
  | ReservationErrorCode
  | AnalyticsErrorCode
  | MediaErrorCode
  | NotificationErrorCode
  | SystemErrorCode;

export interface ErrorCodeMetadata {
  code: ErrorCode;
  category: string;
  severity: 'low' | 'medium' | 'high' | 'critical';
  retryable: boolean;
  userMessage: string;
  developerMessage: string;
}

export function getErrorCodeMetadata(code: ErrorCode): ErrorCodeMetadata {
  const [service, category] = code.split('_');

  return {
    code,
    category: `${service}_${category}`,
    severity: determineSeverity(code),
    retryable: isRetryable(code),
    userMessage: `An error occurred (${code}). Please try again or contact support.`,
    developerMessage: `Error code ${code} occurred. Check logs for details.`,
  };
}

function determineSeverity(
  code: ErrorCode,
): 'low' | 'medium' | 'high' | 'critical' {
  if (code.startsWith('AUTH_LOGIN')) return 'critical';
  if (code.includes('SERVICE') || code.includes('DATABASE')) return 'high';
  if (code.includes('VALIDATION') || code.includes('NOT_FOUND')) return 'low';
  return 'medium';
}

function isRetryable(code: ErrorCode): boolean {
  if (code.includes('TIMEOUT') || code.includes('NETWORK')) return true;
  if (
    code.includes('NOT_FOUND') ||
    code.includes('ALREADY_EXISTS') ||
    code.includes('INVALID')
  )
    return false;
  return false;
}
