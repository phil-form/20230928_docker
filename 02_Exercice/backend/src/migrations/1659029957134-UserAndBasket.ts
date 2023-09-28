import { MigrationInterface, QueryRunner } from "typeorm";

export class UserAndBasket1659029957134 implements MigrationInterface {
    name = 'UserAndBasket1659029957134'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`CREATE TABLE "item" ("id" SERIAL NOT NULL, "name" character varying NOT NULL, "price" integer NOT NULL, "quantity" integer NOT NULL DEFAULT '1', "description" character varying NOT NULL, CONSTRAINT "UQ_c6ae12601fed4e2ee5019544ddf" UNIQUE ("name"), CONSTRAINT "PK_d3c0c71f23e7adcf952a1d13423" PRIMARY KEY ("id"))`);
        await queryRunner.query(`CREATE INDEX "idx_item_name" ON "item" ("name") `);
        await queryRunner.query(`CREATE TABLE "basket_item" ("id" SERIAL NOT NULL, "quantity" integer NOT NULL, "basketId" integer, "itemId" integer, CONSTRAINT "PK_6d46510f73c54c1d75329e1110d" PRIMARY KEY ("id"))`);
        await queryRunner.query(`CREATE TABLE "basket" ("id" SERIAL NOT NULL, "userId" integer, CONSTRAINT "REL_26dcb999420495bb5b14a4f8d1" UNIQUE ("userId"), CONSTRAINT "PK_895e6f44b73a72425e434a614cc" PRIMARY KEY ("id"))`);
        await queryRunner.query(`ALTER TABLE "basket_item" ADD CONSTRAINT "FK_905bbacd09ec186a9232699af68" FOREIGN KEY ("basketId") REFERENCES "basket"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "basket_item" ADD CONSTRAINT "FK_d6c750621a954d1f81c864414cc" FOREIGN KEY ("itemId") REFERENCES "item"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "basket" ADD CONSTRAINT "FK_26dcb999420495bb5b14a4f8d1c" FOREIGN KEY ("userId") REFERENCES "user"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "basket" DROP CONSTRAINT "FK_26dcb999420495bb5b14a4f8d1c"`);
        await queryRunner.query(`ALTER TABLE "basket_item" DROP CONSTRAINT "FK_d6c750621a954d1f81c864414cc"`);
        await queryRunner.query(`ALTER TABLE "basket_item" DROP CONSTRAINT "FK_905bbacd09ec186a9232699af68"`);
        await queryRunner.query(`DROP TABLE "basket"`);
        await queryRunner.query(`DROP TABLE "basket_item"`);
        await queryRunner.query(`DROP INDEX "public"."idx_item_name"`);
        await queryRunner.query(`DROP TABLE "item"`);
    }

}
