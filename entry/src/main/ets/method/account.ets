import { DemoDB } from '../database/DemoDB'
import { AccountDaoRdb } from '../database/dao/AccountDaoRdb'
import { NewUserDto } from '../database/dto/Account/NewUserDto'
import Log from '../utils/Log'
import { passwordEncoder, passwordDecoder } from '../utils/passwordManager'

const Tag = 'Test RDB'

export class AccountManager {
  private TAG = 'Test RDB'
  private dbInstance!: DemoDB
  private accountDao!: AccountDaoRdb
  private newUser?: NewUserDto

  private async initialize(context: Context) {
    try {
      this.dbInstance = await DemoDB.getInstance(context)
      this.accountDao = new AccountDaoRdb(this.dbInstance)
    }
    catch (error) {
      Log.error(Tag, 'Error during DB operations', JSON.stringify(error))
    }
  }

  constructor(context: Context) {
    this.initialize(context)
  }

  async login(email: string, password: string): Promise<boolean> {
    const res: NewUserDto[] = await this.accountDao.getUserByEmail(email)
    if (res.length === 0) {
      Log.info(this.TAG, 'user not exist')
      return false
    } else {
      Log.info(this.TAG, 'user exist, check password')
      let checkRes = await this.checkUserPassword(res, password)
      return checkRes
    }
  }

  async register(email: string, username: string, password: string): Promise<boolean> {
    // todo: find if user exist in the db or not
    let res = await this.isUserExist(email)
    if (res == true) {
      Log.info(this.TAG, 'user exist')
      return false
    } else {
      Log.info(this.TAG, 'user not exist, can register')
      // todo: Check if input data legal or not
      const newUser: NewUserDto = {
        email: email,
        username: username,
        token: passwordEncoder(password)
      }
      let newUserId: number = await this.accountDao.addUser(newUser)
      Log.info(this.TAG, 'register successful', newUserId)
      return true
    }
  }

  async isUserExist(email: string): Promise<boolean> {
    const res: NewUserDto[] = await this.accountDao.getUserByEmail(email)
    if (res.length === 0) {
      Log.info(Tag, 'user not exist')
      return false
    } else {
      Log.info(Tag, 'user exist')
      return true
    }
  }

  async checkUserPassword(user: NewUserDto[], password: string): Promise<boolean> {
    let decodePwd: string = passwordDecoder(user[0].token)
    if (decodePwd == password) {
      return true
    } else {
      return false
    }
  }

  isDataLegal(username: string, email: string, password: string, repeat: string): boolean {
    if (password !== repeat) {
      Log.info(this.TAG, 'password don\'t match')
      return false
    }
    const emailRegex: RegExp = new RegExp("^[^\\s@]+@[^\s@]+\\.(com|net|org|edu|gov|info|io|cn)$")
    const passwordRegex: RegExp = new RegExp("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).{8,}$")

    // username at least 6 letters long
    if (username.length < 6) {
      Log.info(this.TAG, 'username ileagal')
      return false
    }

    // email at least 6 letters long and must have @ and .com like ending
    if (email.length < 6 || !emailRegex.test(email)) {
      Log.info(this.TAG, 'email illegal');
      return false;
    }

    // password at least 8 letters long and must have capital and small letters and numbers
    if (!passwordRegex.test(password)) {
      Log.info(this.TAG, 'password illegal');
      return false;
    }
    return true
  }
}