import { Injectable } from '@nestjs/common';
import { PostHogCaptureEvent, PostHogClient } from './posthog-client.interface';

/**
 * Test/local-dev client. Records forwarded payloads in memory instead of
 * calling a real PostHog project, so a test can assert on exactly what
 * would have been sent (mirrors `FakeSmsProvider`). Never wired in
 * staging/production — see posthog.module.ts.
 */
@Injectable()
export class FakePostHogClient implements PostHogClient {
  private readonly captured: PostHogCaptureEvent[] = [];

  capture(event: PostHogCaptureEvent): Promise<void> {
    this.captured.push(event);
    return Promise.resolve();
  }

  getCaptured(): PostHogCaptureEvent[] {
    return this.captured;
  }

  getLastCaptured(): PostHogCaptureEvent | undefined {
    return this.captured[this.captured.length - 1];
  }

  clear(): void {
    this.captured.length = 0;
  }
}
