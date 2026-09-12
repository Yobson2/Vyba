import { Inject, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { In, Repository } from 'typeorm';
import Redis from 'ioredis';
import { DeviceToken } from './entities/device-token.entity';
import { NotificationPreference } from './entities/notification-preference.entity';
import { VenueBroadcastOptIn } from './entities/venue-broadcast-opt-in.entity';
import {
  NotificationResult,
  NotificationType,
  SentNotification,
} from './entities/sent-notification.entity';
import { RegisterDeviceTokenDto } from './dto/register-device-token.dto';
import { SetPreferencesDto } from './dto/set-preferences.dto';
import { CreateBroadcastDto } from './dto/create-broadcast.dto';
import { FCM_SENDER, FcmPayload, FcmSender } from './fcm/fcm-sender.interface';
import { ClockService } from '@common/clock/clock.service';
import { abidjanToday } from '@common/config/abidjan-time.config';
import { REDIS_CLIENT } from '@common/redis/redis.provider';
import { BroadcastAlreadySentError } from '@common/exceptions/notification.exceptions';
import { VenueOwnershipError } from '@common/exceptions/venue.exceptions';
import { UsersService } from '@modules/users/users.service';
import { VenuesService } from '@modules/venues/venues.service';
import { VenueType } from '@modules/venues/entities/venue.entity';
import { GoingService } from '@modules/going/going.service';
import { FeedItemsService } from '@modules/feed/feed-items.service';
import { FeedItemType } from '@modules/feed/entities/feed-item.entity';

const ZONE_4 = 'zone_4';

export interface BroadcastOptInVenueSummary {
  id: string;
  name: string;
  venueType: VenueType;
}

export interface PreferencesView {
  weekendDigest: boolean;
  goingReminder: boolean;
}

export interface JobRunSummary {
  recipients: number;
  delivered: number;
  noToken: number;
  failed: number;
}

@Injectable()
export class NotificationsService {
  constructor(
    @InjectRepository(DeviceToken)
    private readonly deviceTokenRepository: Repository<DeviceToken>,
    @InjectRepository(NotificationPreference)
    private readonly preferenceRepository: Repository<NotificationPreference>,
    @InjectRepository(SentNotification)
    private readonly sentNotificationRepository: Repository<SentNotification>,
    @InjectRepository(VenueBroadcastOptIn)
    private readonly broadcastOptInRepository: Repository<VenueBroadcastOptIn>,
    @Inject(FCM_SENDER)
    private readonly fcmSender: FcmSender,
    @Inject(REDIS_CLIENT)
    private readonly redis: Redis,
    private readonly clock: ClockService,
    private readonly usersService: UsersService,
    private readonly venuesService: VenuesService,
    private readonly goingService: GoingService,
    private readonly feedItemsService: FeedItemsService,
  ) {}

  /** Multiple devices per user are expected — re-registering the same token just refreshes it. */
  async registerDeviceToken(
    userId: string,
    dto: RegisterDeviceTokenDto,
  ): Promise<void> {
    const existing = await this.deviceTokenRepository.findOne({
      where: { token: dto.token },
    });
    if (existing) {
      existing.userId = userId;
      existing.platform = dto.platform ?? existing.platform;
      await this.deviceTokenRepository.save(existing);
      return;
    }
    await this.deviceTokenRepository.save(
      this.deviceTokenRepository.create({
        userId,
        token: dto.token,
        platform: dto.platform ?? 'android',
      }),
    );
  }

  /** Sign-out (mobile, ticket 15) — silently a no-op if the token isn't this user's. */
  async deregisterDeviceToken(userId: string, token: string): Promise<void> {
    await this.deviceTokenRepository.delete({ userId, token });
  }

  async getPreferences(userId: string): Promise<PreferencesView> {
    const pref = await this.preferenceRepository.findOne({
      where: { userId },
    });
    return {
      weekendDigest: pref?.weekendDigest ?? true,
      goingReminder: pref?.goingReminder ?? true,
    };
  }

  async setPreferences(
    userId: string,
    dto: SetPreferencesDto,
  ): Promise<PreferencesView> {
    let pref = await this.preferenceRepository.findOne({ where: { userId } });
    if (!pref) {
      pref = this.preferenceRepository.create({
        userId,
        weekendDigest: true,
        goingReminder: true,
      });
    }
    if (dto.weekendDigest !== undefined) pref.weekendDigest = dto.weekendDigest;
    if (dto.goingReminder !== undefined) pref.goingReminder = dto.goingReminder;
    const saved = await this.preferenceRepository.save(pref);
    return {
      weekendDigest: saved.weekendDigest,
      goingReminder: saved.goingReminder,
    };
  }

  /** Independent of `Follow` (spec 08 / ticket 17) — idempotent, a no-op if already opted in. */
  async optInToVenueBroadcasts(userId: string, venueId: string): Promise<void> {
    const existing = await this.broadcastOptInRepository.findOne({
      where: { userId, venueId },
    });
    if (existing) return;
    await this.broadcastOptInRepository.save(
      this.broadcastOptInRepository.create({ userId, venueId }),
    );
  }

  async optOutOfVenueBroadcasts(
    userId: string,
    venueId: string,
  ): Promise<void> {
    await this.broadcastOptInRepository.delete({ userId, venueId });
  }

  async isOptedInToVenueBroadcasts(
    userId: string,
    venueId: string,
  ): Promise<boolean> {
    const existing = await this.broadcastOptInRepository.findOne({
      where: { userId, venueId },
    });
    return existing !== null;
  }

  /** "Mes lieux avec notifications" (ticket 17) — mirrors `FollowsService.getMyFollowedVenues`. */
  async getMyBroadcastOptIns(
    userId: string,
  ): Promise<BroadcastOptInVenueSummary[]> {
    const rows = await this.broadcastOptInRepository.find({
      where: { userId },
      order: { createdAt: 'DESC' },
    });
    if (rows.length === 0) return [];

    const venues = await this.venuesService.findByIds(
      rows.map((r) => r.venueId),
    );
    const venueById = new Map(venues.map((v) => [v.id, v]));

    return rows
      .map((r) => venueById.get(r.venueId))
      .filter((v): v is NonNullable<typeof v> => v !== undefined)
      .map((v) => ({ id: v.id, name: v.name, venueType: v.venueType }));
  }

  /**
   * The owner's one-per-night broadcast (spec 08 / ticket 17): recipients
   * are tonight's active "going" for this venue ∩ opted-in — never a
   * `Follow` implication. A Redis guard (not the `SentNotification` log)
   * enforces the rate limit so a night with zero eligible recipients still
   * correctly refuses a second attempt.
   */
  async sendVenueBroadcast(
    venueId: string,
    ownerId: string,
    dto: CreateBroadcastDto,
  ): Promise<JobRunSummary> {
    const venue = await this.venuesService.findRawOrThrow(venueId);
    if (venue.ownerUserId !== ownerId) {
      throw new VenueOwnershipError(venueId);
    }

    const today = abidjanToday(this.clock.now());
    await this.claimBroadcastSlot(venueId, today);

    const goingUserIds = await this.goingService.getActiveGoingUserIdsForVenue(
      venueId,
      today,
    );
    const optIns =
      goingUserIds.length === 0
        ? []
        : await this.broadcastOptInRepository.find({
            where: { venueId, userId: In(goingUserIds) },
          });
    const optedInIds = new Set(optIns.map((o) => o.userId));
    const recipients = goingUserIds.filter((id) => optedInIds.has(id));

    const payload: FcmPayload = {
      title: venue.name,
      body: dto.message,
      data: { type: NotificationType.VENUE_BROADCAST, venueId },
    };

    return this.sendToMany(
      recipients.map((userId) => ({ userId, venueId })),
      NotificationType.VENUE_BROADCAST,
      () => payload,
    );
  }

  /** Atomic claim via `SETNX` semantics — throws if tonight's slot for this venue is already taken. */
  private async claimBroadcastSlot(
    venueId: string,
    dateISO: string,
  ): Promise<void> {
    const key = `broadcast:sent:${venueId}:${dateISO}`;
    const claimed = await this.redis.set(key, '1', 'EX', 24 * 3600, 'NX');
    if (claimed !== 'OK') {
      throw new BroadcastAlreadySentError(venueId);
    }
  }

  /**
   * Thursday ~17:00 Abidjan (spec 08) — recipients are the launch-area
   * cohort with `weekendDigest` on; content assembled from the current Zone
   * 4 feed ranking, deep-linking to the feed.
   */
  async runWeekendDigest(): Promise<JobRunSummary> {
    const cohort = await this.usersService.findLaunchAreaCohortUserIds(ZONE_4);
    const preferences = await this.getPreferencesForUsers(cohort);
    const recipients = cohort.filter(
      (id) => preferences.get(id)!.weekendDigest,
    );

    const items = await this.feedItemsService.listFeed(null, 5);
    const highlights = items
      .map((i) =>
        i.type === FeedItemType.EDITORIAL
          ? ((i.payload?.title as string) ?? null)
          : (i.venue?.name ?? null),
      )
      .filter((name): name is string => !!name);
    const body =
      highlights.length > 0
        ? `Ce week-end à Zone 4 : ${highlights.slice(0, 3).join(', ')}.`
        : 'Découvre ce qui se passe ce week-end à Zone 4.';
    const payload: FcmPayload = {
      title: 'Le week-end à Zone 4',
      body,
      data: { type: NotificationType.WEEKEND_DIGEST },
    };

    return this.sendToMany(
      recipients.map((userId) => ({ userId, venueId: null })),
      NotificationType.WEEKEND_DIGEST,
      () => payload,
    );
  }

  /**
   * Daily ~20:00 Abidjan (spec 08) — one grouped notification per user even
   * if several venues; recipients come from `GoingService`'s internal query,
   * never from querying `Going` directly (spec invariant).
   */
  async runGoingReminder(): Promise<JobRunSummary> {
    const today = abidjanToday(this.clock.now());
    const rows = await this.goingService.getReminderRecipients(today);

    const venueIdsByUser = new Map<string, string[]>();
    for (const row of rows) {
      const list = venueIdsByUser.get(row.userId) ?? [];
      list.push(row.venueId);
      venueIdsByUser.set(row.userId, list);
    }
    const userIds = [...venueIdsByUser.keys()];
    const preferences = await this.getPreferencesForUsers(userIds);
    const recipientIds = userIds.filter(
      (id) => preferences.get(id)!.goingReminder,
    );

    const allVenueIds = [...new Set(rows.map((r) => r.venueId))];
    const venues = await this.venuesService.findByIds(allVenueIds);
    const venueNameById = new Map(venues.map((v) => [v.id, v.name]));

    return this.sendToMany(
      recipientIds.map((userId) => ({
        userId,
        venueId: venueIdsByUser.get(userId)![0],
      })),
      NotificationType.GOING_REMINDER,
      (recipient) => {
        const names = venueIdsByUser
          .get(recipient.userId)!
          .map((id) => venueNameById.get(id) ?? 'ce lieu');
        return {
          title: 'Ce soir',
          body: `Tu as dit que tu allais à ${names.join(', ')} ce soir.`,
          data: {
            type: NotificationType.GOING_REMINDER,
            venueId: recipient.venueId ?? '',
          },
        };
      },
    );
  }

  /** Batch preference lookup, defaulting missing rows to "on" (spec 08). */
  private async getPreferencesForUsers(
    userIds: string[],
  ): Promise<Map<string, PreferencesView>> {
    const result = new Map<string, PreferencesView>(
      userIds.map((id) => [id, { weekendDigest: true, goingReminder: true }]),
    );
    if (userIds.length === 0) return result;

    const rows = await this.preferenceRepository.find({
      where: { userId: In(userIds) },
    });
    for (const row of rows) {
      result.set(row.userId, {
        weekendDigest: row.weekendDigest,
        goingReminder: row.goingReminder,
      });
    }
    return result;
  }

  private async sendToMany(
    recipients: { userId: string; venueId: string | null }[],
    type: NotificationType,
    buildPayload: (recipient: {
      userId: string;
      venueId: string | null;
    }) => FcmPayload,
  ): Promise<JobRunSummary> {
    const summary: JobRunSummary = {
      recipients: recipients.length,
      delivered: 0,
      noToken: 0,
      failed: 0,
    };

    for (const recipient of recipients) {
      const result = await this.sendToUser(
        recipient.userId,
        type,
        recipient.venueId,
        buildPayload(recipient),
      );
      if (result === NotificationResult.DELIVERED) summary.delivered += 1;
      else if (result === NotificationResult.NO_TOKEN) summary.noToken += 1;
      else summary.failed += 1;
    }
    return summary;
  }

  /**
   * Skips cleanly when the user has no valid token (spec 08 — never fails a
   * batch on one bad recipient); prunes any token FCM reports invalid.
   */
  private async sendToUser(
    userId: string,
    type: NotificationType,
    venueId: string | null,
    payload: FcmPayload,
  ): Promise<NotificationResult> {
    const tokens = await this.deviceTokenRepository.find({
      where: { userId },
    });

    let result: NotificationResult;
    if (tokens.length === 0) {
      result = NotificationResult.NO_TOKEN;
    } else {
      const sendResult = await this.fcmSender.send(
        tokens.map((t) => t.token),
        payload,
      );
      if (sendResult.invalidTokens.length > 0) {
        await this.deviceTokenRepository.delete({
          token: In(sendResult.invalidTokens),
        });
      }
      result =
        sendResult.deliveredTokens.length > 0
          ? NotificationResult.DELIVERED
          : NotificationResult.FAILED;
    }

    await this.sentNotificationRepository.save(
      this.sentNotificationRepository.create({
        type,
        userId,
        venueId,
        sentAt: this.clock.now(),
        result,
      }),
    );
    return result;
  }
}
