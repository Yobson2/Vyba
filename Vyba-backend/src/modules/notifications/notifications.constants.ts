export const NOTIFICATIONS_QUEUE = 'notifications';
export const WEEKEND_DIGEST_JOB = 'weekend-digest';
export const GOING_REMINDER_JOB = 'going-reminder';

/** Cron patterns in UTC — Africa/Abidjan is UTC+0 year-round, no tz conversion needed. */
export const WEEKEND_DIGEST_CRON = '0 17 * * 4'; // Thursday 17:00
export const GOING_REMINDER_CRON = '0 20 * * *'; // daily 20:00
