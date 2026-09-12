import { Injectable } from '@nestjs/common';
import { FileValidationHelper } from './file-validation.helper';
import {
  StorageProvider,
  UploadFileOptions,
  UploadResult,
} from './storage-provider.interface';

/**
 * In-memory stand-in for S3 (no real object storage integrated yet — tracked
 * separately, out of scope for the media ticket). Records keys/buffers so
 * uploads are inspectable in tests without hitting a real bucket; a real
 * provider slots in behind the same `StorageProvider` interface without
 * touching `media` logic.
 */
@Injectable()
export class FakeStorageProvider implements StorageProvider {
  private readonly objects = new Map<string, Buffer>();
  private readonly bucket = 'fake-bucket';

  async uploadFile(
    folder: string,
    fileName: string,
    options: UploadFileOptions,
  ): Promise<UploadResult> {
    FileValidationHelper.validateFile(
      options.buffer,
      options.mimetype,
      options.originalname || '',
      options.validationOptions || { allowAllTypes: true },
    );

    const key = `${folder}/${fileName}`;
    this.objects.set(key, options.buffer);
    return { key, url: this.buildPublicUrl(key), bucket: this.bucket };
  }

  async deleteFile(key: string): Promise<void> {
    this.objects.delete(key);
  }

  async fileExists(key: string): Promise<boolean> {
    return this.objects.has(key);
  }

  generateFileName(originalName: string, prefix?: string): string {
    const timestamp = Date.now();
    const random = Math.random().toString(36).substring(2, 8);
    const parts = originalName.split('.');
    const ext =
      parts.length > 1 ? parts.pop()?.replace(/[^a-zA-Z0-9]/g, '') : 'bin';
    return prefix
      ? `${prefix}-${timestamp}-${random}.${ext}`
      : `${timestamp}-${random}.${ext}`;
  }

  private buildPublicUrl(key: string): string {
    return `https://fake-storage.local/${this.bucket}/${key}`;
  }
}
