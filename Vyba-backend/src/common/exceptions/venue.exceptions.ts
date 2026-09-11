import { HttpStatus } from '@nestjs/common';
import { VenueErrorCode } from '../constants/error-codes';
import { BaseAppException } from './base.exception';

export class VenueNotFoundError extends BaseAppException {
  constructor(id: string) {
    super(
      `Venue not found: id = ${id}`,
      HttpStatus.NOT_FOUND,
      VenueErrorCode.VENUE_NOT_FOUND,
      { id },
    );
  }
}

export class VenueNightNotFoundError extends BaseAppException {
  constructor(id: string) {
    super(
      `VenueNight not found: id = ${id}`,
      HttpStatus.NOT_FOUND,
      VenueErrorCode.VENUE_NIGHT_NOT_FOUND,
      { id },
    );
  }
}

export class VenueOwnershipError extends BaseAppException {
  constructor(venueId: string) {
    super(
      'You are not the owner of this venue',
      HttpStatus.FORBIDDEN,
      VenueErrorCode.VENUE_NOT_OWNED,
      { venueId },
    );
  }
}
