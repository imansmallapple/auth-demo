import { DBConfig } from '../config/DbConfig';
import { BaseEntity } from '../db/BaseEntity';
import { DbTable } from '../db/DbTable';
import { Entity } from '../db/Entity';

export class AccountEntity extends BaseEntity implements Entity {
  protected static readonly TABLE: DbTable = DBConfig.ACCOUNT_TABLE

  username: string
  email: string
  token: string

  constructor(email: string, username: string, token: string) {
    super()
    this.username = username
    this.email = email
    this.token = token
  }
}