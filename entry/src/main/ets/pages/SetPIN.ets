import PinCode from '../components/PinCode'

@Entry
@Component
struct SetPIN {
  @Provide result: string = ''
  @Provide textCaretPosition: number = 0
  @Provide isTypedMax: boolean = false
  @Provide isRegisterPIN: boolean = false
  @Provide isForLogin: boolean = false
  @Provide isAuthCorrect: boolean = false
  @State title: Resource = $r('app.string.Set_PIN')

  aboutToAppear(): void {
    this.isRegisterPIN = true
    this.isForLogin = false
  }

  build() {
    Column() {
      PinCode({
        title: $title
      })
    }
  }
}