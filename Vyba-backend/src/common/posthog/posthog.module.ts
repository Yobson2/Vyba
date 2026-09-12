import { Global, Logger, Module } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { FakePostHogClient } from './fake-posthog-client';
import { POSTHOG_CLIENT } from './posthog-client.interface';

/**
 * No PostHog project is provisioned yet — project setup / EU hosting is
 * explicitly ops scope (spec 07 "Out of Scope"), not this backend unit.
 * `FakePostHogClient` is the only implementation today; a real
 * `posthog-node`-backed client slots in here behind the same
 * `PostHogClient` interface without touching `AnalyticsService`.
 */
@Global()
@Module({
  providers: [
    FakePostHogClient,
    {
      provide: POSTHOG_CLIENT,
      inject: [ConfigService, FakePostHogClient],
      useFactory: (config: ConfigService, fake: FakePostHogClient) => {
        const nodeEnv = config.get<string>('NODE_ENV', 'development');
        if (nodeEnv === 'production' || nodeEnv === 'staging') {
          new Logger('PostHogModule').error(
            'No real PostHog client is configured; falling back to FakePostHogClient. Analytics will not reach PostHog.',
          );
        }
        return fake;
      },
    },
  ],
  exports: [POSTHOG_CLIENT, FakePostHogClient],
})
export class PostHogModule {}
