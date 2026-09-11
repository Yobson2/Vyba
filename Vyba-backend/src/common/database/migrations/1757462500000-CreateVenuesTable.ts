import { MigrationInterface, QueryRunner } from 'typeorm';

/**
 * Durable venue facts (ticket 05 / ADR-0001). No night-scoped columns here —
 * those live on `venue_nights`, added by a later migration.
 */
export class CreateVenuesTable1757462500000 implements MigrationInterface {
  name = 'CreateVenuesTable1757462500000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      CREATE TYPE "venue_type_enum" AS ENUM ('CLUB', 'BAR', 'LOUNGE', 'MAQUIS')
    `);

    await queryRunner.query(`
      CREATE TYPE "venue_validation_status_enum" AS ENUM ('ONBOARDING', 'ACTIVE', 'PAUSED')
    `);

    await queryRunner.query(`
      CREATE TABLE "venues" (
        "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
        "createdAt" TIMESTAMP NOT NULL DEFAULT now(),
        "updatedAt" TIMESTAMP NOT NULL DEFAULT now(),
        "isActive" boolean NOT NULL DEFAULT true,
        "name" character varying NOT NULL,
        "description" text,
        "address" character varying,
        "latitude" double precision NOT NULL,
        "longitude" double precision NOT NULL,
        "venueType" "venue_type_enum" NOT NULL,
        "priceLevel" integer NOT NULL DEFAULT 1,
        "photos" jsonb NOT NULL DEFAULT '[]',
        "ownerUserId" uuid,
        "validationStatus" "venue_validation_status_enum" NOT NULL DEFAULT 'ONBOARDING',
        "inLaunchArea" boolean NOT NULL DEFAULT false,
        CONSTRAINT "PK_venues_id" PRIMARY KEY ("id")
      )
    `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`DROP TABLE "venues"`);
    await queryRunner.query(`DROP TYPE "venue_validation_status_enum"`);
    await queryRunner.query(`DROP TYPE "venue_type_enum"`);
  }
}
