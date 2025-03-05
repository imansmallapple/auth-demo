export class AppError extends Error {
  public readonly code: number
  public readonly msg: string

  constructor(code: number, msg: string) {
    super(msg)
    this.msg = msg || 'Unknown error'
    this.code = code
  }
}