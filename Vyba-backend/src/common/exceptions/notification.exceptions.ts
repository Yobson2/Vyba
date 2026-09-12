import { HttpStatus } from '@nestjs/common';
import { NotificationErrorCode } from '../constants/error-codes';
import { BaseAppException } from './base.exception';

export class BroadcastAlreadySentError extends BaseAppException {
  constructor(venueId: string) {
    super(
      'A broadcast was already sent for this venue tonight',
      HttpStatus.CONFLICT,
      NotificationErrorCode.BROADCAST_ALREADY_SENT,
      { venueId },
    );
  }
}
