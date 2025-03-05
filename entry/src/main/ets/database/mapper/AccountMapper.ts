import { NewUserDto } from '../dto/Account/NewUserDto';
import { AccountEntity } from '../entity/AccountEntity';
import relationalStore from '@ohos.data.relationalStore';

export class AccountMapper {
  public static toAccountEntity(user: NewUserDto): AccountEntity {
    return new AccountEntity(
      user.email,
      user.username,
      user.token
    )
  }

  public static toAccountDto(user: AccountEntity): NewUserDto {
    return {
      email: user.email,
      username: user.username,
      token: user.token
    }
  }

  public static resultSetToAccount(resultSet: relationalStore.ResultSet): NewUserDto[] {
    const userList: NewUserDto[] = []
    while (resultSet.goToNextRow()) {
      const user: NewUserDto = {
        email: resultSet.getString(resultSet.getColumnIndex('email')),
        username: resultSet.getString(resultSet.getColumnIndex('username')),
        token: resultSet.getString(resultSet.getColumnIndex('token'))
      }
      userList.push(user)
    }
    return userList
  }

  public static entityToSave(entity: AccountEntity): relationalStore.ValuesBucket {
    return {
      email: entity.email,
      username: entity.username,
      token: entity.token
    }
  }
}