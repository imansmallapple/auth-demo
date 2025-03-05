import { IAccountDao } from './IAccountDao'
import { BaseRelationalDatabase } from '../db/BaseRelationalDB'
import relationalStore from '@ohos.data.relationalStore'
import { NewUserDto } from '../dto/Account/NewUserDto'
import { AccountEntity } from '../entity/AccountEntity'
import { AccountMapper } from '../mapper/AccountMapper'

export class AccountDaoRdb implements IAccountDao {
  private db: BaseRelationalDatabase

  constructor(dbInstance: BaseRelationalDatabase) {
    this.db = dbInstance
  }


  getAllUsers(): Promise<NewUserDto[]> {
    return this.db.query(
      AccountEntity.getTableName(),
      AccountEntity.getTableColumns(),
      (predicates) => predicates,
      (resultSet: relationalStore.ResultSet) => AccountMapper.resultSetToAccount(resultSet)
    )
  }

  addUser(user: NewUserDto): Promise<number> {
    return this.db.insert<AccountEntity>(
      AccountEntity.getTableName(),
      AccountMapper.toAccountEntity(user),
      (entity) => AccountMapper.entityToSave(entity),
      true
    )
  }

  changePassword(user: NewUserDto): Promise<number> {
    return this.db.update<AccountEntity>(
      AccountEntity.getTableName(),
      AccountMapper.toAccountEntity(user),
      (predicates) => predicates.equalTo(
        AccountEntity.getTableColumns()[0], user.email
      ),
      (entity) => AccountMapper.entityToSave(entity)
    )
  }

  removeUser(user: NewUserDto): Promise<number> {
    return this.db.delete<AccountEntity>(
      AccountEntity.getTableName(),
      (predicates) => predicates.equalTo(AccountEntity.getTableColumns()[0], user.email)
    )
  }

  getUserByName(username: string): Promise<NewUserDto[]> {
    return this.db.query(
      AccountEntity.getTableName(),
      AccountEntity.getTableColumns(),
      (predicates) => predicates.equalTo(AccountEntity.getTableColumns()[1], username),
      (resultSet: relationalStore.ResultSet) => AccountMapper.resultSetToAccount(resultSet)
    )
  }

  getUserByEmail(email: string): Promise<NewUserDto[]> {
    return this.db.query(
      AccountEntity.getTableName(),
      AccountEntity.getTableColumns(),
      (predicates) => predicates.equalTo(AccountEntity.getTableColumns()[0], email),
      (resultSet: relationalStore.ResultSet) => AccountMapper.resultSetToAccount(resultSet)
    )
  }
}