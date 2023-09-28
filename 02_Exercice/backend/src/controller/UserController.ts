import {Repository} from "typeorm"
import { NextFunction, Request, Response } from "express"
import { User } from "../entity/User"
import {AppDataSource} from "../data-source";
import * as bcrypt from 'bcrypt';
import * as jwt from 'jsonwebtoken';
import {UserDto} from "../dto/user-dto";
import {Basket} from "../entity/Basket";

export class UserController {
    private userRepository: Repository<User>;

    constructor() {
        this.userRepository = AppDataSource.getRepository(User);
    }

    async all(request: Request, response: Response, next: NextFunction) {
        return this.userRepository.find();
    }

    async one(request: Request, response: Response, next: NextFunction) {
        return this.userRepository.findOneBy({ id: request.params.id })
    }

    async save(request: Request, response: Response, next: NextFunction) {
        let user = request.body as User;

        user.userpassword  = await bcrypt.genSalt(10)
            .then((salt) => bcrypt.hash(user.userpassword, salt))
            .then((hash) => {
                return hash;
            });

        user.basket = new Basket();

        return this.userRepository.save(user);;
    }

    async login(request: Request, response: Response, next: NextFunction)
    {
        const username = request.body.username || null;
        const password = request.body.userpassword || null;
        const user = await this.userRepository.findOneBy({ username: username })

        const success = await bcrypt.compare(password, user.userpassword)
            .then(resp => resp)
        if(success)
        {
            const token = jwt.sign({ user: new UserDto(user) },
                'my-super-secret-key',
                { expiresIn: 3600 });

            response.json({ success: true, token: token });
        }else {
            response.json({ success: false, message: 'bad username and or password' });
        }
    }

    async update(request: Request, response: Response, next: NextFunction)
    {
        let user = request.body as User;

        user.userpassword  = await bcrypt.genSalt(10)
            .then((salt) => bcrypt.hash(user.userpassword, salt))
            .then((hash) => {
                return hash;
            });

        return this.userRepository.update({ id: request.params.id }, request.body);
    }

    async remove(request: Request, response: Response, next: NextFunction) {
        let userToRemove = await this.userRepository.findOneBy({ id: request.params.id })
        await this.userRepository.remove(userToRemove)
    }

}
