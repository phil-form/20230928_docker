import {Entity, PrimaryGeneratedColumn, Column, OneToOne, Index} from "typeorm"
import {Basket} from "./Basket";

@Entity()
export class User {

    @PrimaryGeneratedColumn()
    id: number

    @Index("idx_user_name")
    @Column({ unique: true, nullable: false })
    username: string

    @Column({ unique: true, nullable: false })
    useremail: string

    @Column() //test
    userdescription: string

    @Column({ nullable: true })
    userpassword: string;

    @OneToOne(() => Basket, (basket) => basket.user, { cascade: true })
    basket: Basket;
}
