import {Column, Entity, JoinTable, ManyToOne, PrimaryGeneratedColumn} from "typeorm";
import {Basket} from "./Basket";
import {Item} from "./Item";

@Entity()
export class BasketItem
{
    @PrimaryGeneratedColumn()
    id: number

    @Column({ nullable: false })
    quantity: number;

    @ManyToOne(() => Basket, (basket) => basket.items)
    basket: Basket;

    @ManyToOne(() => Item,  (item) => item.basket, { eager: true })
    item: Item;
}
