import relationalStore from '@ohos.data.relationalStore'
import { DbTable } from '../db/DbTable'

export class DBConfig {
  static readonly STORE_CONFIG: relationalStore.StoreConfig = {
    name: 'database.db',
    securityLevel: relationalStore.SecurityLevel.S1,
    encrypt: true
  }
  static readonly NEWS_TABLE: DbTable = {
    tableName: 'news',
    sqlCreate: 'CREATE TABLE IF NOT EXISTS news(' +
      'id TEXT PRIMARY KEY,' +
      'title TEXT,' +
      'image TEXT,' +
      'url TEXT,' +
      'published TEXT,' +
      'category TEXT,' +
      'description TEXT,' +
      'author TEXT,' +
      'language TEXT)',
    columns: ['id', 'title', 'image', 'url', 'published', 'category', 'description', 'author', 'language']
  }
  static readonly ACCOUNT_TABLE: DbTable = {
    tableName: 'account',
    sqlCreate: 'CREATE TABLE IF NOT EXISTS account(' +
      'email TEXT PRIMARY KEY,' +
      'username TEXT,' +
      'token TEXT)',
    columns: ['email', 'username', 'token']
  }
  static readonly ACCOUNT_NEWS_TABLE: DbTable = {
    tableName: 'account_news',
    sqlCreate: 'CREATE TABLE IF NOT EXISTS account_news(' +
      'account_email TEXT,' +
      'news_id TEXT,' +
      'PRIMARY KEY(account_email, news_id),' +
      'FOREIGN KEY (account_email) REFERENCES account(email) ON DELETE CASCADE,' +
      'FOREIGN KEY (news_id) REFERENCES news(id) ON DELETE CASCADE)',
    columns: ['account_email', 'news_id']
  }
}
