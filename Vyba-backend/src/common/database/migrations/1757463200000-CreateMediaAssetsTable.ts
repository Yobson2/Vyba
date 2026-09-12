import { MigrationInterface, QueryRunner } from 'typeorm';

/**
 * `MediaAsset` (ticket 14 / spec 06) — venue-content uploads (`venue_profile`,
 * `venue_post`) publish immediately; user night photos (`venue_night_user`)
 * only enter the main feed once an admin promotes them (`feedPromoted`).
 */
export class CreateMediaAssetsTable1757463200000 implements MigrationInterface {
  name = 'CreateMediaAssetsTable1757463200000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      CREATE TYPE "media_uploader_role_enum" AS ENUM ('ADMIN', 'VENUE_OWNER', 'CLIENT')
    `);
    await queryRunner.query(`
      CREATE TYPE "media_context_type_enum" AS ENUM ('venue_profile', 'venue_post', 'venue_night_user')
    `);
    await queryRunner.query(`
      CREATE TYPE "media_asset_status_enum" AS ENUM ('active', 'hidden', 'deleted')
    `);

    await queryRunner.query(`
      CREATE TABLE "media_assets" (
        "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
        "createdAt" TIMESTAMP NOT NULL DEFAULT now(),
        "updatedAt" TIMESTAMP NOT NULL DEFAULT now(),
        "storageKey" character varying NOT NULL,
        "url" character varying NOT NULL,
        "displayUrl" character varying NOT NULL,
        "thumbnailUrl" character varying NOT NULL,
        "uploadedByUserId" uuid NOT NULL,
        "uploadedByRole" "media_uploader_role_enum" NOT NULL,
        "contextType" "media_context_type_enum" NOT NULL,
        "venueId" uuid,
        "venueNightId" uuid,
        "feedItemId" uuid,
        "status" "media_asset_status_enum" NOT NULL DEFAULT 'active',
        "feedPromoted" boolean NOT NULL DEFAULT false,
        CONSTRAINT "PK_media_assets_id" PRIMARY KEY ("id")
      )
    `);

    await queryRunner.query(`
      CREATE INDEX "IX_media_assets_venue" ON "media_assets" ("venueId")
    `);
    await queryRunner.query(`
      CREATE INDEX "IX_media_assets_venue_night" ON "media_assets" ("venueNightId")
    `);
    await queryRunner.query(`
      CREATE INDEX "IX_media_assets_context_status" ON "media_assets" ("contextType", "status")
    `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`DROP TABLE "media_assets"`);
    await queryRunner.query(`DROP TYPE "media_asset_status_enum"`);
    await queryRunner.query(`DROP TYPE "media_context_type_enum"`);
    await queryRunner.query(`DROP TYPE "media_uploader_role_enum"`);
  }
}
