import { MigrationInterface, QueryRunner } from 'typeorm';

/**
 * `VenueBroadcastOptIn` (ticket 17 / spec 08) — a client's per-venue
 * broadcast opt-in, deliberately independent of `Follow`.
 */
export class CreateVenueBroadcastOptInsTable1757463400000 implements MigrationInterface {
  name = 'CreateVenueBroadcastOptInsTable1757463400000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      CREATE TABLE "venue_broadcast_opt_ins" (
        "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
        "createdAt" TIMESTAMP NOT NULL DEFAULT now(),
        "updatedAt" TIMESTAMP NOT NULL DEFAULT now(),
        "userId" uuid NOT NULL,
        "venueId" uuid NOT NULL,
        CONSTRAINT "PK_venue_broadcast_opt_ins_id" PRIMARY KEY ("id")
      )
    `);
    await queryRunner.query(`
      CREATE UNIQUE INDEX "UQ_venue_broadcast_opt_ins_user_venue" ON "venue_broadcast_opt_ins" ("userId", "venueId")
    `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`DROP TABLE "venue_broadcast_opt_ins"`);
  }
}
