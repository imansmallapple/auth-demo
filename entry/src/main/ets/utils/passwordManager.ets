import util from '@ohos.util';
import Log from './Log';

const base64 = new util.Base64Helper()

export function passwordEncoder(str: string): string {
  let textEncoder = new util.TextEncoder("utf-8")
  let array: Uint8Array = textEncoder.encodeInto(str)
  Log.info('String Utils', base64.encodeToStringSync(array))
  return base64.encodeToStringSync(array)
}

export function passwordDecoder(encodeStr: string): string {
  let arr: Uint8Array = base64.decodeSync(encodeStr)
  let str = ''
  if (arr && arr.length > 0) {
    try {
      let textDecode = util.TextDecoder.create('utf-8')
      str = textDecode.decodeWithStream(arr)
    } catch (err) {
      Log.error('String Utils', `uint8ArrayToString = ${err}`)
    }
  }
  Log.info('String Utils res', `uint8ArrayToString = ${str}`)
  return str
}