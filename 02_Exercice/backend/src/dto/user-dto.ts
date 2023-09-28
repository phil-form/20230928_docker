import {Column, Index} from "typeorm";
import {User} from "../entity/User";

export class UserDto
{
    id: number;
    username: string;
    useremail: string;
    userdescription: string;

    constructor(user: User) {
        this.id = user.id
        this.username = user.username
        this.useremail = user.useremail
        this.userdescription = user.userdescription
    }
}
