import * as express from "express"
import * as bodyParser from "body-parser"
import { Request, Response } from "express"
import { AppDataSource } from "./data-source"
import {AdminRoutes, AuthRoute, Routes} from "./routes"
import * as cors from "cors";
import {AuthGuard} from "./guard/AuthGuard";


AppDataSource.initialize().then(async () => {

    // create express app
    const app = express()
    const options: cors.CorsOptions = {
        origin: '*',
        optionsSuccessStatus: 200
    }

    app.use(cors(options))
    app.use(bodyParser.json())


    // register express routes from defined application routes
    Routes.forEach(route => {
        (app as any)[route.method](route.route, (req: Request, res: Response, next: Function) => {
            const result = (new (route.controller as any))[route.action](req, res, next)
            if (result instanceof Promise) {
                result.then(result => result !== null && result !== undefined ? res.send(result) : undefined)

            } else if (result !== null && result !== undefined) {
                res.json(result)
            }
        })
    });

    app.use(AuthGuard.checkAuthorization);
    AuthRoute.forEach(route => {
        (app as any)[route.method](route.route, (req: Request, res: Response, next: Function) => {
            const result = (new (route.controller as any))[route.action](req, res, next)
            if (result instanceof Promise) {
                result.then(result => result !== null && result !== undefined ? res.send(result) : undefined)

            } else if (result !== null && result !== undefined) {
                res.json(result)
            }
        })
    });
    AdminRoutes.forEach(route => {
        (app as any)[route.method](route.route, (req: Request, res: Response, next: Function) => {
            const result = (new (route.controller as any))[route.action](req, res, next)
            if (result instanceof Promise) {
                result.then(result => result !== null && result !== undefined ? res.send(result) : undefined)

            } else if (result !== null && result !== undefined) {
                res.json(result)
            }
        })
    });

    // start express server
    app.listen(3000);
}).catch(error => console.log(error))
