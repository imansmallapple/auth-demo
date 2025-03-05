import { NewUserDto } from '../dto/Account/NewUserDto'

export interface IAccountDao {
  getAllUsers(): Promise<NewUserDto[]>

  addUser(user: NewUserDto): Promise<number>

  changePassword(user: NewUserDto): Promise<number>

  removeUser(user: NewUserDto): Promise<number>

  getUserByName(username: string): Promise<NewUserDto[]>

  getUserByEmail(email: string): Promise<NewUserDto[]>
}