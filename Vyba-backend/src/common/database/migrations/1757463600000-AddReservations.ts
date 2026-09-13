import { MigrationInterface, QueryRunner } from 'typeorm';

/**
 * ADR-0006 — opt-in real reservations, and the `Venue.capacity` /
 * `reservationsEnabled` fields that gate/drive them. Mirrors
 * `CreateGoingsTable`'s partial unique index shape exactly.
 */
export class AddReservations1757463600000 implements MigrationInterface {
  name = 'AddReservations1757463600000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      ALTER TABLE "venues"
      ADD COLUMN "capacity" integer,
      ADD COLUMN "reservationsEnabled" boolean NOT NULL DEFAULT false
    `);

    await queryRunner.query(`
      CREATE TYPE "reservation_status_enum" AS ENUM ('PENDING', 'CONFIRMED', 'REJECTED', 'CANCELED')
    `);

    await queryRunner.query(`
      CREATE TABLE "reservations" (
        "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
        "createdAt" TIMESTAMP NOT NULL DEFAULT now(),
        "updatedAt" TIMESTAMP NOT NULL DEFAULT now(),
        "userId" uuid NOT NULL,
        "venueId" uuid NOT NULL,
        "venueNightId" uuid NOT NULL,
        "partySize" integer NOT NULL DEFAULT 1,
        "note" text,
        "status" "reservation_status_enum" NOT NULL DEFAULT 'PENDING',
        "respondedAt" TIMESTAMP WITH TIME ZONE,
        "respondedBy" uuid,
        CONSTRAINT "PK_reservations_id" PRIMARY KEY ("id")
      )
    `);

    await queryRunner.query(`
      CREATE UNIQUE INDEX "UQ_reservations_active_user_night"
      ON "reservations" ("userId", "venueNightId")
      WHERE "status" IN ('PENDING', 'CONFIRMED')
    `);

    await queryRunner.query(`
      CREATE INDEX "IX_reservations_venue_night" ON "reservations" ("venueNightId")
    `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`DROP TABLE "reservations"`);
    await queryRunner.query(`DROP TYPE "reservation_status_enum"`);
    await queryRunner.query(`
      ALTER TABLE "venues"
      DROP COLUMN "capacity",
      DROP COLUMN "reservationsEnabled"
    `);
  }
}
