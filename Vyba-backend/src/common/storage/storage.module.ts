import { Global, Logger, Module } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { FakeStorageProvider } from './fake-storage.provider';
import { S3StorageProvider } from './s3-storage.provider';
import { STORAGE_PROVIDER } from './storage-provider.interface';

/**
 * Real S3-compatible storage (`S3StorageProvider`) is used whenever
 * `S3_ENDPOINT`/`S3_ACCESS_KEY_ID`/`S3_SECRET_ACCESS_KEY` are configured;
 * otherwise `FakeStorageProvider` (in-memory) stands in, so `media` module
 * logic never depends on a live bucket being reachable.
 */
@Global()
@Module({
  providers: [
    FakeStorageProvider,
    S3StorageProvider,
    {
      provide: STORAGE_PROVIDER,
      inject: [ConfigService, FakeStorageProvider, S3StorageProvider],
      useFactory: (
        config: ConfigService,
        fake: FakeStorageProvider,
        s3: S3StorageProvider,
      ) => {
        const configured = !!(
          config.get<string>('S3_ENDPOINT') &&
          config.get<string>('S3_ACCESS_KEY_ID') &&
          config.get<string>('S3_SECRET_ACCESS_KEY')
        );
        if (!configured) {
          const nodeEnv = config.get<string>('NODE_ENV', 'development');
          if (nodeEnv === 'production' || nodeEnv === 'staging') {
            new Logger('StorageModule').error(
              'No S3 storage is configured; falling back to FakeStorageProvider. Uploads will not persist.',
            );
          }
          return fake;
        }
        return s3;
      },
    },
  ],
  exports: [STORAGE_PROVIDER, FakeStorageProvider, S3StorageProvider],
})
export class StorageModule {}
