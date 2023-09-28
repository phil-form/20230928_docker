import {Repository} from "typeorm"
import { NextFunction, Request, Response } from "express"
import { Item } from "../entity/Item"
import {AppDataSource} from "../data-source";

export class ItemController {
    private itemRepository: Repository<Item>;

    constructor() {
        this.itemRepository = AppDataSource.getRepository(Item)
    }

    async all(request: Request, response: Response, next: NextFunction) {
        return this.itemRepository.find()
    }

    async one(request: Request, response: Response, next: NextFunction) {
        return this.itemRepository.findOneBy({ id: request.params.id })
    }

    async save(request: Request, response: Response, next: NextFunction) {
        return this.itemRepository.save(request.body)
    }

    async update(request: Request, response: Response, next: NextFunction)
    {
        return this.itemRepository.update({ id: request.params.id }, request.body);
    }

    async remove(request: Request, response: Response, next: NextFunction) {
        let itemToRemove = await this.itemRepository.findOneBy({ id: request.params.id })
        await this.itemRepository.remove(itemToRemove)
    }

}
