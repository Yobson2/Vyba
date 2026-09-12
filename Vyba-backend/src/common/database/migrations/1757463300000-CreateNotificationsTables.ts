import { MigrationInterface, QueryRunner } from 'typeorm';

/**
 * Notifications infrastructure (ticket 15 / spec 08): device tokens,
 * per-user preferences (defaults on — a missing row means "on"), and the
 * delivery log.
 */
export class CreateNotificationsTables1757463300000 implements MigrationInterface {
  name = 'CreateNotificationsTables1757463300000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      CREATE TABLE "device_tokens" (
        "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
        "createdAt" TIMESTAMP NOT NULL DEFAULT now(),
        "updatedAt" TIMESTAMP NOT NULL DEFAULT now(),
        "userId" uuid NOT NULL,
        "token" character varying NOT NULL,
        "platform" character varying NOT NULL DEFAULT 'android',
        CONSTRAINT "PK_device_tokens_id" PRIMARY KEY ("id")
      )
    `);
    await queryRunner.query(`
      CREATE UNIQUE INDEX "UQ_device_tokens_token" ON "device_tokens" ("token")
    `);
    await queryRunner.query(`
      CREATE INDEX "IX_device_tokens_user" ON "device_tokens" ("userId")
    `);

    await queryRunner.query(`
      CREATE TABLE "notification_preferences" (
        "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
        "createdAt" TIMESTAMP NOT NULL DEFAULT now(),
        "updatedAt" TIMESTAMP NOT NULL DEFAULT now(),
        "userId" uuid NOT NULL,
        "weekendDigest" boolean NOT NULL DEFAULT true,
        "goingReminder" boolean NOT NULL DEFAULT true,
        CONSTRAINT "PK_notification_preferences_id" PRIMARY KEY ("id")
      )
    `);
    await queryRunner.query(`
      CREATE UNIQUE INDEX "UQ_notification_preferences_user" ON "notification_preferences" ("userId")
    `);

    await queryRunner.query(`
      CREATE TYPE "notification_type_enum" AS ENUM ('weekend_digest', 'going_reminder', 'venue_broadcast')
    `);
    await queryRunner.query(`
      CREATE TYPE "notification_result_enum" AS ENUM ('delivered', 'no_token', 'failed')
    `);
    await queryRunner.query(`
      CREATE TABLE "sent_notifications" (
        "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
        "createdAt" TIMESTAMP NOT NULL DEFAULT now(),
        "updatedAt" TIMESTAMP NOT NULL DEFAULT now(),
        "type" "notification_type_enum" NOT NULL,
        "userId" uuid NOT NULL,
        "venueId" uuid,
        "sentAt" TIMESTAMP WITH TIME ZONE NOT NULL,
        "result" "notification_result_enum" NOT NULL,
        CONSTRAINT "PK_sent_notifications_id" PRIMARY KEY ("id")
      )
    `);
    await queryRunner.query(`
      CREATE INDEX "IX_sent_notifications_user" ON "sent_notifications" ("userId")
    `);
    await queryRunner.query(`
      CREATE INDEX "IX_sent_notifications_venue_type" ON "sent_notifications" ("venueId", "type")
    `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`DROP TABLE "sent_notifications"`);
    await queryRunner.query(`DROP TYPE "notification_result_enum"`);
    await queryRunner.query(`DROP TYPE "notification_type_enum"`);
    await queryRunner.query(`DROP TABLE "notification_preferences"`);
    await queryRunner.query(`DROP TABLE "device_tokens"`);
  }
}
