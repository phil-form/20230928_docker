import {AppDataSource} from "../data-source";
import {User} from "../entity/User";
import {Repository} from "typeorm";
import {Basket} from "../entity/Basket";
import {NextFunction, Request, Response} from "express";
import {Item} from "../entity/Item";
import {BasketItem} from "../entity/BasketItem";

export class BasketController
{
    private basketRepository: Repository<Basket>;
    private basketItemRepository: Repository<BasketItem>;
    private userRepository: Repository<User>;
    private itemRepository: Repository<Item>;

    constructor() {
        this.basketRepository = AppDataSource.getRepository(Basket);
        this.basketItemRepository = AppDataSource.getRepository(BasketItem);
        this.itemRepository = AppDataSource.getRepository(Item);
        this.userRepository = AppDataSource.getRepository(User);
    }

    async getBasket(request: Request, response: Response, next: NextFunction)
    {
        const token = request.decoded;
        const user = await this.userRepository.findOneBy({ id: token.user.id });
        return this.basketRepository.findOne({ where: { user: user }, relations: ['items', 'items.item'] });
    }

    async addItem(request: Request, response: Response, next: NextFunction)
    {
        const token = request.decoded;
        const user = await this.userRepository.findOneBy({ id: token.user.id });
        const basket = await this.basketRepository.findOne({
            where: {
                user: user
            }
            , relations: ['items', 'items.item']
        });
        const itemToAdd = request.body;
        const item = await this.itemRepository.findOneBy({ id: itemToAdd.id });

        const itemIndex = basket.items.findIndex((basketItem) => basketItem.item.id === item.id)

        if(itemIndex !== -1)
        {
            basket.items[itemIndex].quantity = parseInt(itemToAdd.quantity);
            return this.basketItemRepository.update({ id: basket.items[itemIndex].id }, basket.items[itemIndex]);
        }
        let basketItem = new BasketItem();
        basketItem.item = item;
        basketItem.quantity = itemToAdd.quantity;
        basketItem.basket = basket;
        return this.basketItemRepository.save(basketItem);
    }
}
