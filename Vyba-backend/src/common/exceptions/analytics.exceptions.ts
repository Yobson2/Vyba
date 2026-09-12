import { HttpStatus } from '@nestjs/common';
import { AnalyticsErrorCode } from '../constants/error-codes';
import { BaseAppException } from './base.exception';

export class UnknownAnalyticsEventError extends BaseAppException {
  constructor(event: string) {
    super(
      `Unknown analytics event: ${event}`,
      HttpStatus.BAD_REQUEST,
      AnalyticsErrorCode.UNKNOWN_EVENT,
      { event },
    );
  }
}
