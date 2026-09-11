import { MigrationInterface, QueryRunner } from 'typeorm';

/** Polymorphic `FeedItem` (ticket 07 / spec 03). */
export class CreateFeedItemsTable1757462700000 implements MigrationInterface {
  name = 'CreateFeedItemsTable1757462700000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      CREATE TYPE "feed_item_type_enum" AS ENUM (
        'VENUE_UPDATE', 'LIVE_TONIGHT', 'PROMO', 'EVENT', 'EDITORIAL', 'GOING_MILESTONE', 'PHOTO'
      )
    `);
    await queryRunner.query(`
      CREATE TYPE "feed_item_origin_enum" AS ENUM ('VENUE', 'FOUNDER', 'FOUNDER_ASSISTED', 'USER')
    `);
    await queryRunner.query(`
      CREATE TYPE "feed_item_status_enum" AS ENUM ('DRAFT', 'PUBLISHED', 'HIDDEN', 'EXPIRED')
    `);

    await queryRunner.query(`
      CREATE TABLE "feed_items" (
        "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
        "createdAt" TIMESTAMP NOT NULL DEFAULT now(),
        "updatedAt" TIMESTAMP NOT NULL DEFAULT now(),
        "type" "feed_item_type_enum" NOT NULL,
        "venueId" uuid,
        "venueNightId" uuid,
        "createdByUserId" uuid,
        "origin" "feed_item_origin_enum" NOT NULL,
        "assisted" boolean NOT NULL DEFAULT false,
        "startsAt" TIMESTAMP WITH TIME ZONE,
        "expiresAt" TIMESTAMP WITH TIME ZONE,
        "publishedAt" TIMESTAMP WITH TIME ZONE NOT NULL,
        "status" "feed_item_status_enum" NOT NULL DEFAULT 'PUBLISHED',
        "payload" jsonb,
        CONSTRAINT "PK_feed_items_id" PRIMARY KEY ("id")
      )
    `);

    await queryRunner.query(`
      CREATE INDEX "IX_feed_items_venue_night_type" ON "feed_items" ("venueNightId", "type")
    `);
    await queryRunner.query(`
      CREATE INDEX "IX_feed_items_status_published" ON "feed_items" ("status", "publishedAt")
    `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`DROP TABLE "feed_items"`);
    await queryRunner.query(`DROP TYPE "feed_item_status_enum"`);
    await queryRunner.query(`DROP TYPE "feed_item_origin_enum"`);
    await queryRunner.query(`DROP TYPE "feed_item_type_enum"`);
  }
}
