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

export class InvalidAdminCredentialsError extends BaseAppException {
  constructor() {
    super(
      'Invalid email or password',
      HttpStatus.UNAUTHORIZED,
      AuthErrorCode.INVALID_CREDENTIALS,
    );
  }
}

export class AdminEmailAlreadyExistsError extends BaseAppException {
  constructor(email: string) {
    super(
      `An admin with email ${email} already exists`,
      HttpStatus.CONFLICT,
      AuthErrorCode.ADMIN_EMAIL_ALREADY_EXISTS,
    );
  }
}

export class CannotDeactivateSelfError extends BaseAppException {
  constructor() {
    super(
      'You cannot deactivate your own admin account',
      HttpStatus.BAD_REQUEST,
      AuthErrorCode.ADMIN_CANNOT_DEACTIVATE_SELF,
    );
  }
}

export class CannotDeactivateLastAdminError extends BaseAppException {
  constructor() {
    super(
      'Cannot deactivate the last active admin account',
      HttpStatus.BAD_REQUEST,
      AuthErrorCode.ADMIN_CANNOT_DEACTIVATE_LAST,
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
