import {Column, Entity, Index, ManyToMany, ManyToOne, OneToMany, OneToOne, JoinTable, PrimaryGeneratedColumn, JoinColumn} from "typeorm";
import {User} from "./User";
import {BasketItem} from "./BasketItem";

@Entity()
export class Basket
{
    @PrimaryGeneratedColumn()
    id: number

    @OneToOne(() => User)
    @JoinColumn()
    user: User

    @OneToMany(() => BasketItem, (basketItem) => basketItem.basket,
        { eager: true ,cascade: true })
    items: BasketItem[]
}
