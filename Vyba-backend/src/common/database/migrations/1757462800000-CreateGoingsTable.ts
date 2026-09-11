import { MigrationInterface, QueryRunner } from 'typeorm';

/**
 * `Going` — a soft "J'y vais" intent (ticket 08 / ADR-0002). The partial
 * unique index is the actual enforcement of "at most one active mark per
 * (user, venue-night)" — a plain unique index can't express "unique only
 * among non-canceled rows".
 */
export class CreateGoingsTable1757462800000 implements MigrationInterface {
  name = 'CreateGoingsTable1757462800000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      CREATE TABLE "goings" (
        "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
        "createdAt" TIMESTAMP NOT NULL DEFAULT now(),
        "updatedAt" TIMESTAMP NOT NULL DEFAULT now(),
        "userId" uuid NOT NULL,
        "venueId" uuid NOT NULL,
        "venueNightId" uuid NOT NULL,
        "partySize" integer NOT NULL DEFAULT 1,
        "identityPublic" boolean NOT NULL DEFAULT false,
        "canceledAt" TIMESTAMP WITH TIME ZONE,
        CONSTRAINT "PK_goings_id" PRIMARY KEY ("id")
      )
    `);

    await queryRunner.query(`
      CREATE UNIQUE INDEX "UQ_goings_active_user_night"
      ON "goings" ("userId", "venueNightId")
      WHERE "canceledAt" IS NULL
    `);

    await queryRunner.query(`
      CREATE INDEX "IX_goings_venue_night" ON "goings" ("venueNightId")
    `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`DROP TABLE "goings"`);
  }
}
