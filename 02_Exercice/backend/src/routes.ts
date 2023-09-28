import { UserController } from "./controller/UserController"
import {ItemController} from "./controller/ItemController";
import {BasketController} from "./controller/BasketController";

export const Routes = [
    // ------------------------------------------------------------------------------
    // USERS
    // ------------------------------------------------------------------------------
    {
        method: "post",
        route: "/users/register",
        controller: UserController,
        action: "save"
    },
    {
        method: "post",
        route: "/users/login",
        controller: UserController,
        action: "login"
    },
    // ------------------------------------------------------------------------------
    // ITEMS
    // ------------------------------------------------------------------------------
    {
        method: "get",
        route: "/items",
        controller: ItemController,
        action: "all"
    },
    {
        method: "get",
        route: "/items/:id",
        controller: ItemController,
        action: "one"
    },
]

export const AuthRoute = [
    // ------------------------------------------------------------------------------
    // USERS
    // ------------------------------------------------------------------------------
    {
        method: "get",
        route: "/users",
        controller: UserController,
        action: "all"
    },
    {
        method: "get",
        route: "/users/:id",
        controller: UserController,
        action: "one"
    },
    {
        method: "put",
        route: "/users/:id",
        controller: UserController,
        action: "update"
    },
    // ------------------------------------------------------------------------------
    // ITEMS
    // ------------------------------------------------------------------------------

    // ------------------------------------------------------------------------------
    // BASKETS
    // ------------------------------------------------------------------------------
    {
        method: "get",
        route: "/basket",
        controller: BasketController,
        action: "getBasket"
    },
    {
        method: "put",
        route: "/basket/add",
        controller: BasketController,
        action: "addItem"
    },
]

export const AdminRoutes = [
    // ------------------------------------------------------------------------------
    // USERS
    // ------------------------------------------------------------------------------
    {
        method: "post",
        route: "/users/login",
        controller: UserController,
        action: "login"
    },
    // ------------------------------------------------------------------------------
    // ITEMS
    // ------------------------------------------------------------------------------
    {
        method: "post",
        route: "/items",
        controller: ItemController,
        action: "save"
    },
    {
        method: "put",
        route: "/items/:id",
        controller: ItemController,
        action: "update"
    },
    {
        method: "delete",
        route: "/items/:id",
        controller: ItemController,
        action: "remove"
    },
]
