export const POSTHOG_CLIENT = 'POSTHOG_CLIENT';

export interface PostHogCaptureEvent {
  distinctId: string;
  event: string;
  properties?: Record<string, unknown>;
}

/**
 * One capture() contract regardless of vendor, so the analytics proxy never
 * depends on the PostHog SDK directly (mirrors `SmsProvider`).
 */
export interface PostHogClient {
  capture(event: PostHogCaptureEvent): Promise<void>;
}
