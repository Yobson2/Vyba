import { HttpStatus } from '@nestjs/common';
import { MediaErrorCode } from '../constants/error-codes';
import { BaseAppException } from './base.exception';

export class MediaAssetNotFoundError extends BaseAppException {
  constructor(id: string) {
    super(
      `Media asset not found: id = ${id}`,
      HttpStatus.NOT_FOUND,
      MediaErrorCode.MEDIA_ASSET_NOT_FOUND,
      { id },
    );
  }
}

export class MediaForbiddenError extends BaseAppException {
  constructor(id: string) {
    super(
      `Not the uploader of media asset: id = ${id}`,
      HttpStatus.FORBIDDEN,
      MediaErrorCode.MEDIA_FORBIDDEN,
      { id },
    );
  }
}
