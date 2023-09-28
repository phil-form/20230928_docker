/*
 *   Copyright (c) 2023 
 *   All rights reserved.
 */
import "reflect-metadata"
import { DataSource } from "typeorm"
import { User } from "./entity/User"
import {Item} from "./entity/Item";
import {Basket} from "./entity/Basket";
import {BasketItem} from "./entity/BasketItem";

export const AppDataSource = new DataSource({
    name: "default",
    type: "postgres",
    host: "db",
    port: 5432,
    username: "app",
    password: "1234",
    database: "app",
    synchronize: true,
    logging: false,
    entities: [User, Basket, BasketItem, Item],
    migrations: [__dirname + '/migrations/**/*.ts'],
    migrationsTableName: "migration_versions",
    subscribers: [],
})
