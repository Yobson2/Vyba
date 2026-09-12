import { Processor, WorkerHost } from '@nestjs/bullmq';
import { Logger } from '@nestjs/common';
import { Job } from 'bullmq';
import { NotificationsService } from './notifications.service';
import {
  GOING_REMINDER_JOB,
  NOTIFICATIONS_QUEUE,
  WEEKEND_DIGEST_JOB,
} from './notifications.constants';

/**
 * The BullMQ worker side of the two standing scheduled jobs (spec 08) — the
 * repeatable schedule itself is registered by `NotificationsScheduler`; this
 * just runs the job when it fires. The same logic is reachable directly via
 * the ADMIN "run now" endpoints for the demo/e2e seam, bypassing the queue.
 */
@Processor(NOTIFICATIONS_QUEUE)
export class NotificationsProcessor extends WorkerHost {
  private readonly logger = new Logger(NotificationsProcessor.name);

  constructor(private readonly notificationsService: NotificationsService) {
    super();
  }

  async process(job: Job): Promise<void> {
    if (job.name === WEEKEND_DIGEST_JOB) {
      const summary = await this.notificationsService.runWeekendDigest();
      this.logger.log(`Weekend digest sent: ${JSON.stringify(summary)}`);
      return;
    }
    if (job.name === GOING_REMINDER_JOB) {
      const summary = await this.notificationsService.runGoingReminder();
      this.logger.log(`Going reminder sent: ${JSON.stringify(summary)}`);
      return;
    }
    this.logger.warn(`Unknown notifications job: ${job.name}`);
  }
}
