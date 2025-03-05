import relationalStore from '@ohos.data.relationalStore'
import { BaseRelationalDatabase } from '../database/db/BaseRelationalDB'
import { Context } from '@ohos.abilityAccessCtrl'
import { DBConfig } from './config/DbConfig'
import Log from '../utils/Log'

export class DemoDB extends BaseRelationalDatabase {
  private static instance: DemoDB | null = null

  private constructor(rdbStore: relationalStore.RdbStore) {
    super(rdbStore)
  }

  public static async getInstance(context: Context): Promise<DemoDB> {
    // If instance not exists
    if (!DemoDB.instance) {
      const store = await relationalStore.getRdbStore(context, DBConfig.STORE_CONFIG)
      await DemoDB.initializeTables(store)
      DemoDB.instance = new DemoDB(store)
      Log.debug('DB initialized:' + DBConfig.STORE_CONFIG.name)
    }
    return DemoDB.instance
  }

  public static async initializeTables(store: relationalStore.RdbStore): Promise<void> {
    await store.executeSql(DBConfig.ACCOUNT_TABLE.sqlCreate)
    Log.debug(`DB Table created: ${DBConfig.ACCOUNT_TABLE.tableName}[${DBConfig.ACCOUNT_TABLE.columns}]`)
  }
}

