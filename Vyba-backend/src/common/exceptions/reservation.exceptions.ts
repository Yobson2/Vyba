import { HttpStatus } from '@nestjs/common';
import { ReservationErrorCode } from '../constants/error-codes';
import { BaseAppException } from './base.exception';

export class ReservationNotFoundError extends BaseAppException {
  constructor(id: string) {
    super(
      `Reservation not found: ${id}`,
      HttpStatus.NOT_FOUND,
      ReservationErrorCode.RESERVATION_NOT_FOUND,
      { id },
    );
  }
}

export class ReservationSelfMarkError extends BaseAppException {
  constructor(venueId: string) {
    super(
      "You can't request a reservation for your own venue",
      HttpStatus.FORBIDDEN,
      ReservationErrorCode.RESERVATION_SELF_MARK,
      { venueId },
    );
  }
}

export class ReservationRateLimitedError extends BaseAppException {
  constructor() {
    super(
      'Too many attempts. Try again later.',
      HttpStatus.TOO_MANY_REQUESTS,
      ReservationErrorCode.RESERVATION_RATE_LIMITED,
    );
  }
}

export class ReservationLockedError extends BaseAppException {
  constructor() {
    super(
      "It's past midnight — this reservation can no longer be changed.",
      HttpStatus.FORBIDDEN,
      ReservationErrorCode.RESERVATION_LOCKED,
    );
  }
}

export class ReservationsDisabledError extends BaseAppException {
  constructor(venueId: string) {
    super(
      "This venue doesn't take reservations",
      HttpStatus.FORBIDDEN,
      ReservationErrorCode.RESERVATION_DISABLED,
      { venueId },
    );
  }
}

export class ReservationFullError extends BaseAppException {
  constructor(venueId: string) {
    super(
      "Confirming this would exceed the venue's capacity for tonight",
      HttpStatus.CONFLICT,
      ReservationErrorCode.RESERVATION_FULL,
      { venueId },
    );
  }
}
