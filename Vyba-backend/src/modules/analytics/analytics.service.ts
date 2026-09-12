import { Inject, Injectable } from '@nestjs/common';
import {
  POSTHOG_CLIENT,
  PostHogClient,
} from '@common/posthog/posthog-client.interface';
import {
  isKnownAnalyticsEvent,
  isMeaningfulAction,
} from '@common/constants/analytics-events';
import { UnknownAnalyticsEventError } from '@common/exceptions/analytics.exceptions';
import { UsersService } from '@modules/users/users.service';
import { VenuesService } from '@modules/venues/venues.service';
import { sanitizeAnalyticsProperties } from './analytics-properties.util';

const ZONE_4 = 'zone_4';

export interface TrackParams {
  event: string;
  userId?: string | null;
  anonymousId?: string | null;
  properties?: Record<string, unknown>;
}

/**
 * The single forwarding path to PostHog (spec 07) — clients reach it via
 * the `POST /api/analytics/track` proxy; backend modules call `track()`
 * directly (going, follows, feed) so provenance-sensitive events
 * (`going_marked`, `venue_followed`, `post_created_organically`, ...)
 * can't be spoofed or double-counted between client and server.
 */
@Injectable()
export class AnalyticsService {
  constructor(
    @Inject(POSTHOG_CLIENT) private readonly postHog: PostHogClient,
    private readonly usersService: UsersService,
    private readonly venuesService: VenuesService,
  ) {}

  async track(params: TrackParams): Promise<void> {
    if (!isKnownAnalyticsEvent(params.event)) {
      throw new UnknownAnalyticsEventError(params.event);
    }

    const distinctId = params.userId ?? params.anonymousId ?? 'anonymous';
    const properties = sanitizeAnalyticsProperties(params.properties);

    await this.postHog.capture({
      distinctId,
      event: params.event,
      properties,
    });

    if (params.userId && isMeaningfulAction(params.event)) {
      const venueId = properties?.venue_id;
      if (typeof venueId === 'string') {
        await this.maybeActivateZone4(params.userId, venueId);
      }
    }
  }

  private async maybeActivateZone4(
    userId: string,
    venueId: string,
  ): Promise<void> {
    const venue = await this.venuesService
      .findRawOrThrow(venueId)
      .catch(() => null);
    if (!venue?.inLaunchArea) return;
    await this.usersService.updateActiveZone(userId, ZONE_4);
  }
}
