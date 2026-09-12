import { MigrationInterface, QueryRunner } from 'typeorm';

/**
 * `Follow` — a client's venue follow (ticket 10 / spec 05). The partial
 * unique index enforces "at most one active follow per (user, venue)"
 * while letting a soft-unfollowed row stay behind for the event trail.
 */
export class CreateFollowsTable1757462900000 implements MigrationInterface {
  name = 'CreateFollowsTable1757462900000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      CREATE TABLE "follows" (
        "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
        "createdAt" TIMESTAMP NOT NULL DEFAULT now(),
        "updatedAt" TIMESTAMP NOT NULL DEFAULT now(),
        "userId" uuid NOT NULL,
        "venueId" uuid NOT NULL,
        "unfollowedAt" TIMESTAMP WITH TIME ZONE,
        CONSTRAINT "PK_follows_id" PRIMARY KEY ("id")
      )
    `);

    await queryRunner.query(`
      CREATE UNIQUE INDEX "UQ_follows_active_user_venue"
      ON "follows" ("userId", "venueId")
      WHERE "unfollowedAt" IS NULL
    `);

    await queryRunner.query(`
      CREATE INDEX "IX_follows_venue" ON "follows" ("venueId")
    `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`DROP TABLE "follows"`);
  }
}
