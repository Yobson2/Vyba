import { MigrationInterface, QueryRunner } from 'typeorm';

/**
 * `AdminCredential` — email+password for a
 * `User` with role ADMIN, the one exemption ADR-0003 allows. Kept off the
 * `User` table itself.
 */
export class CreateAdminCredentialsTable1757463500000
  implements MigrationInterface
{
  name = 'CreateAdminCredentialsTable1757463500000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      CREATE TABLE "admin_credentials" (
        "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
        "createdAt" TIMESTAMP NOT NULL DEFAULT now(),
        "updatedAt" TIMESTAMP NOT NULL DEFAULT now(),
        "userId" uuid NOT NULL,
        "email" character varying NOT NULL,
        "passwordHash" character varying NOT NULL,
        CONSTRAINT "UQ_admin_credentials_userId" UNIQUE ("userId"),
        CONSTRAINT "UQ_admin_credentials_email" UNIQUE ("email"),
        CONSTRAINT "PK_admin_credentials_id" PRIMARY KEY ("id")
      )
    `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`DROP TABLE "admin_credentials"`);
  }
}
