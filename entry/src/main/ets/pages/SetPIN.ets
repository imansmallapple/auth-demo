import PinCode from './PinCode'

//todo: PIN code with be set when user register an new account
//todo: It will be invalid when user logout or reset PIN manually
// When typing PIN only have 3 chance, if failed user can't login using PIN(DONE)
//todo: One PIN instance only

@Entry
@Component
struct SetPIN {
  @Provide result: string = ''
  @Provide textCaretPosition: number = 0
  @Provide isTypedMax: boolean = false
  @Provide isRegisterPIN: boolean = false
  @Provide isForLogin: boolean = false
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