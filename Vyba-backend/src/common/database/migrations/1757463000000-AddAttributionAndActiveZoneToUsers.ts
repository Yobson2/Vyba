import { MigrationInterface, QueryRunner } from 'typeorm';

/**
 * Fills out the `User` acquisition-snapshot placeholders (ticket 11 / spec
 * 07) and adds `activeZone`/`lastActiveAt` — kept strictly separate from
 * `acquisitionZone` (where the user came from vs. whether they engage with
 * Zone 4 now).
 */
export class AddAttributionAndActiveZoneToUsers1757463000000 implements MigrationInterface {
  name = 'AddAttributionAndActiveZoneToUsers1757463000000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      ALTER TABLE "users"
      ADD COLUMN "acquisitionVenueId" uuid,
      ADD COLUMN "acquisitionPromoterId" uuid,
      ADD COLUMN "firstLandingAt" TIMESTAMP WITH TIME ZONE,
      ADD COLUMN "activeZone" character varying,
      ADD COLUMN "lastActiveAt" TIMESTAMP WITH TIME ZONE
    `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      ALTER TABLE "users"
      DROP COLUMN "acquisitionVenueId",
      DROP COLUMN "acquisitionPromoterId",
      DROP COLUMN "firstLandingAt",
      DROP COLUMN "activeZone",
      DROP COLUMN "lastActiveAt"
    `);
  }
}
