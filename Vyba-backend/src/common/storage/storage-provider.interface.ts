import { FileValidationOptions } from './file-validation.helper';

export const STORAGE_PROVIDER = 'STORAGE_PROVIDER';

export interface UploadFileOptions {
  buffer: Buffer;
  mimetype: string;
  originalname?: string;
  validationOptions?: FileValidationOptions;
}

export interface UploadResult {
  key: string;
  url: string;
  bucket: string;
}

/**
 * One storage contract for every object-storage backend (real S3-compatible
 * today, a fake in-memory stand-in for tests) so callers never depend on a
 * specific vendor or on a live bucket being reachable.
 */
export interface StorageProvider {
  uploadFile(
    folder: string,
    fileName: string,
    options: UploadFileOptions,
  ): Promise<UploadResult>;
  deleteFile(key: string): Promise<void>;
  fileExists(key: string): Promise<boolean>;
  generateFileName(originalName: string, prefix?: string): string;
}
