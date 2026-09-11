import { HttpStatus } from '@nestjs/common';
import { GoingErrorCode } from '../constants/error-codes';
import { BaseAppException } from './base.exception';

export class GoingNotFoundError extends BaseAppException {
  constructor(venueId: string) {
    super(
      `No active "J'y vais" mark for venue ${venueId} tonight`,
      HttpStatus.NOT_FOUND,
      GoingErrorCode.GOING_NOT_FOUND,
      { venueId },
    );
  }
}

export class GoingSelfMarkError extends BaseAppException {
  constructor(venueId: string) {
    super(
      'You can\'t mark "J\'y vais" for your own venue',
      HttpStatus.FORBIDDEN,
      GoingErrorCode.GOING_SELF_MARK,
      { venueId },
    );
  }
}

export class GoingRateLimitedError extends BaseAppException {
  constructor() {
    super(
      'Too many attempts. Try again later.',
      HttpStatus.TOO_MANY_REQUESTS,
      GoingErrorCode.GOING_RATE_LIMITED,
    );
  }
}

export class GoingLockedError extends BaseAppException {
  constructor() {
    super(
      "It's past midnight — this mark can no longer be changed.",
      HttpStatus.FORBIDDEN,
      GoingErrorCode.GOING_LOCKED,
    );
  }
}
