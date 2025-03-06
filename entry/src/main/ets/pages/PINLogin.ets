import PinCode from '../components/PinCode'

@Entry
@Component
struct PINLogin {
  @Provide result: string = ''
  @Provide textCaretPosition: number = 0
  @Provide isForLogin: boolean = false
  @Provide isRegisterPIN: boolean = false
  @Provide isTypedMax: boolean = false
  @State title: Resource = $r('app.string.Enter_PIN')

  aboutToAppear(): void {
    this.isForLogin = true
    this.isRegisterPIN = false
  }

  build() {
    Column() {
      PinCode({
        title: $title
      })
    }
  }
}