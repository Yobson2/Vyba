import { MigrationInterface, QueryRunner } from 'typeorm';

/**
 * `VenueNight` — one venue on one calendar night (ticket 06 / ADR-0001).
 * `(venueId, date)` unique so get-or-create races settle on a single row.
 */
export class CreateVenueNightsTable1757462600000 implements MigrationInterface {
  name = 'CreateVenueNightsTable1757462600000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      CREATE TABLE "venue_nights" (
        "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
        "createdAt" TIMESTAMP NOT NULL DEFAULT now(),
        "updatedAt" TIMESTAMP NOT NULL DEFAULT now(),
        "venueId" uuid NOT NULL,
        "date" date NOT NULL,
        "isLive" boolean NOT NULL DEFAULT false,
        "liveSince" TIMESTAMP WITH TIME ZONE,
        "liveSetBy" uuid,
        "headline" text,
        "djName" character varying,
        "goingCount" integer NOT NULL DEFAULT 0,
        "viewCount" integer NOT NULL DEFAULT 0,
        "postCount" integer NOT NULL DEFAULT 0,
        CONSTRAINT "PK_venue_nights_id" PRIMARY KEY ("id")
      )
    `);

    await queryRunner.query(`
      CREATE UNIQUE INDEX "UQ_venue_nights_venue_date" ON "venue_nights" ("venueId", "date")
    `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`DROP TABLE "venue_nights"`);
  }
}
