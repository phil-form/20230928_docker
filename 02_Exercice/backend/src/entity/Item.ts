import {Column, Entity, Index, OneToMany, OneToOne, PrimaryGeneratedColumn} from "typeorm";
import {Basket} from "./Basket";

@Entity()
export class Item
{
    @PrimaryGeneratedColumn()
    id: number;

    @Index("idx_item_name")
    @Column({ unique: true, nullable: false })
    name: string;

    @Column({ nullable: false })
    price: number;

    @Column({ nullable: false, default: 1 })
    quantity: number;

    @Column() //test
    description: string;

    @OneToMany(() => Basket, (basket) => basket.items)
    basket: Basket;
}
