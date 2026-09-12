import { InjectQueue } from '@nestjs/bullmq';
import { Injectable, Logger, OnModuleInit } from '@nestjs/common';
import { Queue } from 'bullmq';
import {
  GOING_REMINDER_CRON,
  GOING_REMINDER_JOB,
  NOTIFICATIONS_QUEUE,
  WEEKEND_DIGEST_CRON,
  WEEKEND_DIGEST_JOB,
} from './notifications.constants';

/**
 * Registers the two standing repeatable jobs on the existing queue
 * infrastructure (spec 08 — no new scheduler). Registration is idempotent:
 * BullMQ keys a repeatable job by name + pattern, so re-registering on every
 * boot doesn't duplicate it. Failure here (e.g. Redis unreachable at boot)
 * is logged, not fatal — the app still starts, and the ADMIN "run now"
 * endpoints remain usable independent of the schedule.
 */
@Injectable()
export class NotificationsScheduler implements OnModuleInit {
  private readonly logger = new Logger(NotificationsScheduler.name);

  constructor(
    @InjectQueue(NOTIFICATIONS_QUEUE) private readonly queue: Queue,
  ) {}

  async onModuleInit(): Promise<void> {
    try {
      await this.queue.add(
        WEEKEND_DIGEST_JOB,
        {},
        { repeat: { pattern: WEEKEND_DIGEST_CRON } },
      );
      await this.queue.add(
        GOING_REMINDER_JOB,
        {},
        { repeat: { pattern: GOING_REMINDER_CRON } },
      );
    } catch (error) {
      const err = error instanceof Error ? error : new Error(String(error));
      this.logger.error(
        `Failed to register notification schedules: ${err.message}`,
      );
    }
  }
}
