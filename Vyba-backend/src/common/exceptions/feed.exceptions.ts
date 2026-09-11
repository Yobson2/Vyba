import { HttpStatus } from '@nestjs/common';
import { FeedErrorCode } from '../constants/error-codes';
import { BaseAppException } from './base.exception';

export class FeedItemNotFoundError extends BaseAppException {
  constructor(id: string) {
    super(
      `Feed item not found: id = ${id}`,
      HttpStatus.NOT_FOUND,
      FeedErrorCode.FEED_ITEM_NOT_FOUND,
      { id },
    );
  }
}
