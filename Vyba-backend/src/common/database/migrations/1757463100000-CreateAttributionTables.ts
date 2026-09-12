import { MigrationInterface, QueryRunner } from 'typeorm';

/**
 * `LandingEvent` (raw, pre-signup) + `AcquisitionEvent` (signup-time,
 * matched) — ticket 11 / spec 07. Both retained indefinitely; the `User`
 * acquisition snapshot is a derived convenience, not the record of truth.
 */
export class CreateAttributionTables1757463100000 implements MigrationInterface {
  name = 'CreateAttributionTables1757463100000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      CREATE TABLE "landing_events" (
        "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
        "createdAt" TIMESTAMP NOT NULL DEFAULT now(),
        "updatedAt" TIMESTAMP NOT NULL DEFAULT now(),
        "src" character varying NOT NULL,
        "venueId" uuid,
        "promoterId" uuid,
        "campaignId" character varying,
        "surface" character varying NOT NULL,
        "clientId" character varying NOT NULL,
        CONSTRAINT "PK_landing_events_id" PRIMARY KEY ("id")
      )
    `);
    await queryRunner.query(`
      CREATE INDEX "IX_landing_events_clientId" ON "landing_events" ("clientId")
    `);

    await queryRunner.query(`
      CREATE TABLE "acquisition_events" (
        "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
        "createdAt" TIMESTAMP NOT NULL DEFAULT now(),
        "updatedAt" TIMESTAMP NOT NULL DEFAULT now(),
        "userId" uuid NOT NULL,
        "src" character varying NOT NULL,
        "venueId" uuid,
        "promoterId" uuid,
        "campaignId" character varying,
        "zone" character varying,
        CONSTRAINT "PK_acquisition_events_id" PRIMARY KEY ("id")
      )
    `);
    await queryRunner.query(`
      CREATE INDEX "IX_acquisition_events_userId" ON "acquisition_events" ("userId")
    `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`DROP TABLE "acquisition_events"`);
    await queryRunner.query(`DROP TABLE "landing_events"`);
  }
}
