import { MigrationInterface, QueryRunner } from 'typeorm';

/**
 * Initial Vyba schema: the phone-first `users` table.
 *
 * Dev and test rely on TypeORM auto-sync (`synchronize: true`); this migration
 * is the staging/production path. It replaces the starter template's
 * email/password/family-zone user model — there is no `email` or `password`
 * column.
 */
export class CreateUsersTable1757462400000 implements MigrationInterface {
  name = 'CreateUsersTable1757462400000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`CREATE EXTENSION IF NOT EXISTS "uuid-ossp"`);

    await queryRunner.query(`
      CREATE TYPE "user_role_enum" AS ENUM ('ADMIN', 'VENUE_OWNER', 'CLIENT')
    `);

    await queryRunner.query(`
      CREATE TABLE "users" (
        "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
        "createdAt" TIMESTAMP NOT NULL DEFAULT now(),
        "updatedAt" TIMESTAMP NOT NULL DEFAULT now(),
        "phone" character varying(20) NOT NULL,
        "firstName" character varying,
        "lastName" character varying,
        "role" "user_role_enum" NOT NULL DEFAULT 'CLIENT',
        "isActive" boolean NOT NULL DEFAULT true,
        "ageConfirmedAt" TIMESTAMP WITH TIME ZONE,
        "acquisitionSource" character varying,
        "acquisitionMedium" character varying,
        "acquisitionCampaign" character varying,
        "acquisitionZone" character varying,
        "acquisitionCapturedAt" TIMESTAMP WITH TIME ZONE,
        CONSTRAINT "UQ_users_phone" UNIQUE ("phone"),
        CONSTRAINT "PK_users_id" PRIMARY KEY ("id")
      )
    `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`DROP TABLE "users"`);
    await queryRunner.query(`DROP TYPE "user_role_enum"`);
  }
}
