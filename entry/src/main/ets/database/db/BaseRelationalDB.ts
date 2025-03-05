import relationalStore from '@ohos.data.relationalStore'
import { BaseEntity } from './BaseEntity'
import { BusinessError } from '@ohos.base'
import Log from '../../utils/Log'
import { AppError } from '../../common/AppError'

export abstract class BaseRelationalDatabase {

  protected rdbStore: relationalStore.RdbStore

  protected constructor(rdbStore: relationalStore.RdbStore) {
    this.rdbStore = rdbStore
  }

  public async insert<T extends BaseEntity>(
    tableName: string,
    entity: T,
    toRowData: (entity: T) => relationalStore.ValuesBucket,
    overwrite: boolean = false
  ): Promise<number> {
    return new Promise((resolve, reject) => {
      Log.debug('DB Insert into table: ' + tableName + ', data: ' + JSON.stringify(entity))

      if (!this.rdbStore) {
        return reject(new AppError(1100, 'Unable to connect to database'))
      }

      const conflictResolution = overwrite
        ? relationalStore.ConflictResolution.ON_CONFLICT_REPLACE
        : relationalStore.ConflictResolution.ON_CONFLICT_ROLLBACK

      console.debug('Record: ' + JSON.stringify(toRowData(entity)))

      this.rdbStore
        .insert(tableName, toRowData(entity), conflictResolution)
        .then(value => {
          console.debug('DB insert: ' + value)
          resolve(value)
        })
        .catch((error: BusinessError) => {
          Log.error('Database error:', JSON.stringify(error))
          reject(new AppError(1101, 'Unable to insert data'))
        })
    })
  }

  public async delete<T extends BaseEntity>(
    tableName: string,
    getPredicates: (predicates: relationalStore.RdbPredicates) => relationalStore.RdbPredicates
  ): Promise<number> {
    return new Promise<number>((resolve, reject) => {
      Log.debug('DB delete from table:' + tableName)

      if (!this.rdbStore) {
        return reject(new AppError(1100, 'Unable to connect to database'))
      }

      const predicates = getPredicates(new relationalStore.RdbPredicates(tableName))
      this.rdbStore
        .delete(predicates)
        .then(rows => {
          console.debug('DB rows deleted: ' + rows)
          resolve(rows)
        })
        .catch((error: BusinessError) => {
          console.error('Database error:', JSON.stringify(error))
          reject(new AppError(1103, 'Unable to delete data'))
        })
    })
  }

  public async query<T extends BaseEntity>(
    tableName: string,
    columns: string[],
    getPredicates: (predicates: relationalStore.RdbPredicates) => relationalStore.RdbPredicates,
    rowMapper: (resultSet: relationalStore.ResultSet) => any[]
  ): Promise<any[]> {
    return new Promise((resolve, reject) => {
      Log.debug('DB Select from table: ' + tableName)

      if (!this.rdbStore) {
        return reject(new AppError(1100, 'Unable to connect to database'))
      }

      const predicates = getPredicates(new relationalStore.RdbPredicates(tableName))
      console.debug('DB query predicates: ' + JSON.stringify(predicates))

      this.rdbStore
        .query(predicates, columns)
        .then(resultSet => {
          const count: number = resultSet.rowCount

          console.debug('DB row count: ' + count)
          console.debug('DB resultSet: ' + JSON.stringify(resultSet))

          const result: T[] = rowMapper(resultSet)

          console.debug('DB result: ' + JSON.stringify(result))

          resultSet.close()
          resolve(result)
        })
        .catch((error: BusinessError) => {
          console.error('Database error:', JSON.stringify(error))
          reject(new AppError(1102, 'Unable to query data'))
        })
    })
  }

  public async update<T extends BaseEntity>(
    tableName: string,
    entity: T,
    getPredicates: (predicates: relationalStore.RdbPredicates) => relationalStore.RdbPredicates,
    toRowData: (entity: T) => relationalStore.ValuesBucket,
    overwrite: boolean = false
  ): Promise<number> {
    return new Promise((resolve, reject) => {
      if (!this.rdbStore) {
        return reject(new AppError(1100, 'Unable to connect to database'))
      }

      const predicates = getPredicates(new relationalStore.RdbPredicates(tableName))
      console.debug('DB Update on table: ' + tableName + ', data: ' + JSON.stringify(entity))

      const conflictResolution = overwrite
        ? relationalStore.ConflictResolution.ON_CONFLICT_REPLACE
        : relationalStore.ConflictResolution.ON_CONFLICT_ROLLBACK

      this.rdbStore
        .update(toRowData(entity), predicates, conflictResolution)
        .then(value => {
          console.debug('DB update: ' + value)
          resolve(value)
        })
        .catch((error: BusinessError) => {
          console.error('Database error:', JSON.stringify(error))
          reject(new AppError(1104, 'Unable to update data'))
        })
    })
  }
}