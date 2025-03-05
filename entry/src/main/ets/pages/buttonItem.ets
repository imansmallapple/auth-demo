import Storage from '../storage/Storage'
import Log from '../utils/Log'
import router from '@ohos.router'
import promptAction from '@ohos.promptAction'
import { popToastInfo } from '../utils/infoUtil'

@Component
export default struct buttonItem {
  private content!: string
  //touch color
  tapColor: string = '#666666'
  defaultColor: string = '#ffffffff'
  @State buttonBgColor: string = ''
  @Consume result: string
  @Consume textCaretPosition: number
  @Consume isTypedMax: boolean
  @Consume isRegisterPIN: boolean
  @Consume isForLogin: boolean
  private localStorage = new Storage()
  @State savedPIN: string = ''
  private maxTry: number = 3

  async aboutToAppear(): Promise<void> {
    let savedPIN: string = (await this.localStorage.getValue('pin') as string)
    this.savedPIN = (savedPIN == null ? '' : savedPIN)
  }

  async registerPIN(newPIN: string) {
    this.savedPIN = newPIN
    await this.localStorage.putValue('pin', newPIN)
    this.localStorage.flushAllData()
  }

  async clearPIN() {
    this.savedPIN = ''
    await this.localStorage.putValue('pin', '')
    this.localStorage.flushAllData()
  }

  async checkPIN() {
    Log.info('check pin', `result: ${this.result}`, `savedPIN: ${this.savedPIN}`)
    return this.result == this.savedPIN
  }

  build() {
    Column() {
      Text(this.content)
        .fontSize(20)
        .fontWeight(500)
    }
    .justifyContent(FlexAlign.Center)
    .backgroundColor(this.buttonBgColor)
    .opacity(0.7)
    .height(50)
    .borderRadius(15)
    .borderWidth(1)
    .width('100%')
    .onClick(async () => {
      if (this.result.length < 6) {
        this.result += this.content
        this.textCaretPosition++
      }

      if (this.result.length < 6) {
        this.isTypedMax = false
      }
      else {
        this.isTypedMax = true
      }

      // Register is input digit reached to the max length and under registration page
      if (this.isTypedMax && this.isRegisterPIN) {
        this.registerPIN(this.result)

        promptAction.showToast({
          message: 'PIN registered!'
        })

        router.replaceUrl({
          url: 'pages/PINLogin'
        })
      }
      else if (this.isTypedMax && this.isForLogin) {
        let res = await this.checkPIN()
        if (res == true) {

          popToastInfo('Logged in!')

          router.pushUrl({
            url: 'pages/Index'
          })
        } else {
          this.result = ''
          popToastInfo(`Incorrect! You left ${this.maxTry > 0 ? --this.maxTry : this.maxTry = 0} times left to try!`)

          if (this.maxTry == 0) {

            await this.clearPIN()

            popToastInfo('PIN expired! Please log with your credential')

            router.replaceUrl({
              url: 'pages/Login',
            })
          }
        }
      }

      Log.info('save pin:', this.savedPIN)
      console.log('len:', this.result.length.toString())
      console.log(this.result.toString())
      console.log('isMax:', this.isTypedMax.toString())
    })
    .onTouch((event: TouchEvent) => {
      if (event.type == TouchType.Down) {
        this.buttonBgColor = this.tapColor
      }
      if (event.type == TouchType.Up) {
        this.buttonBgColor = this.defaultColor
      }
    })
  }
}