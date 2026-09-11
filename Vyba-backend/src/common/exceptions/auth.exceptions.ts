import { HttpStatus } from '@nestjs/common';
import { AuthErrorCode } from '../constants/error-codes';
import { BaseAppException } from './base.exception';

export class InvalidOtpError extends BaseAppException {
  constructor() {
    super(
      'The code is incorrect',
      HttpStatus.UNAUTHORIZED,
      AuthErrorCode.INVALID_VERIFICATION_CODE,
    );
  }
}

export class OtpExpiredError extends BaseAppException {
  constructor() {
    super(
      'The code has expired. Request a new one.',
      HttpStatus.UNAUTHORIZED,
      AuthErrorCode.VERIFICATION_CODE_EXPIRED,
    );
  }
}

export class OtpRateLimitedError extends BaseAppException {
  constructor() {
    super(
      'Too many attempts. Try again later.',
      HttpStatus.TOO_MANY_REQUESTS,
      AuthErrorCode.OTP_RATE_LIMITED,
    );
  }
}

export class AccountInactiveError extends BaseAppException {
  constructor() {
    super(
      'This account is deactivated',
      HttpStatus.FORBIDDEN,
      AuthErrorCode.ACCOUNT_DEACTIVATED,
    );
  }
}

export class AgeConfirmationRequiredError extends BaseAppException {
  constructor() {
    super(
      'Confirm you are 18 or older to continue',
      HttpStatus.BAD_REQUEST,
      AuthErrorCode.AGE_CONFIRMATION_REQUIRED,
    );
  }
}

export class TokenExpiredError extends BaseAppException {
  constructor() {
    super(
      'Authentication token has expired',
      HttpStatus.UNAUTHORIZED,
      AuthErrorCode.TOKEN_EXPIRED,
    );
  }
}

export class InvalidTokenError extends BaseAppException {
  constructor(detail?: string) {
    super(
      detail || 'Invalid authentication token',
      HttpStatus.UNAUTHORIZED,
      AuthErrorCode.TOKEN_INVALID,
    );
  }
}

export class UnauthorizedRoleError extends BaseAppException {
  constructor(requiredRole: string) {
    super(
      `Access denied. Required role: ${requiredRole}`,
      HttpStatus.FORBIDDEN,
      AuthErrorCode.UNAUTHORIZED_ROLE,
      { requiredRole },
    );
  }
}
