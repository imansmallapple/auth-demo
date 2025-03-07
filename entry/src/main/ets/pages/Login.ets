import router from '@ohos.router'
import { AccountManager } from '../viewModel/account'
import common from '@ohos.app.ability.common';
import Storage from '../storage/Storage'
import Log from '../utils/Log';
import { displayAlertWindow, popToastInfo } from '../utils/infoUtil';
import { resourceToStr } from '../utils/stringUtil';
import Constants from '../constants/constant';

interface RouterParams {
  isPINInvalid: boolean
}

let context = getContext(this) as common.UIAbilityContext

@Entry
@Component
struct Login {
  @State email: string = ''
  @State password: string = ''
  private accountManager: AccountManager = new AccountManager(context)
  //Credentials
  private localStorage = new Storage()
  @State savedEmail: string = ''
  @State savedPwd: string = ''
  @State credential: string[] = []
  @State savedPIN: string = ''
  private context = getContext(this) as common.UIAbilityContext
  private maxPINLen: number = Constants.MAX_PIN_LENGTH

  async aboutToAppear(): Promise<void> {
    let savedPIN: string = (await this.localStorage.getValue('pin') as string)
    this.savedPIN = (savedPIN == null ? '' : savedPIN)
    Log.info('check login saved pin:', this.savedPIN)

    if (this.savedPIN.length == this.maxPINLen) {
      router.replaceUrl({
        url: 'pages/PINLogin'
      })
    }
  }

  build() {
    Column({ space: 50 }) {

      Column() {
        Row({ space: 20 }) {
          Image($r('app.media.startIcon'))
            .width(50)

          Text($r('app.string.app_name'))
            .fontSize(30)
            .fontWeight(700)
        }
        .justifyContent(FlexAlign.Center)
        .width('100%')
        .height('100%')
        .padding(20)
      }
      .height('20%')

      Column() {
        Text(resourceToStr(this.context, $r('app.string.WELCOME_LOGIN')))
          .titleStyle()

        Row() {
          Image($r('app.media.icon_user'))
            .iconStyle()
          TextInput({ placeholder: resourceToStr(this.context, $r('app.string.EMAIL')) })
            .inputStyle()
            .type(InputType.Email)
            .onChange((value) => {
              this.email = value
            })
        }
        .margin({ top: 30 })

        Divider()
          .color(Color.Black)
          .strokeWidth(1)
        Row() {
          Image($r('app.media.icon_security'))
            .iconStyle()
          TextInput({ placeholder: resourceToStr(this.context, $r('app.string.PASSWORD')) })
            .inputStyle()
            .type(InputType.Password)
            .onChange((value) => {
              this.password = value
            })
        }.margin({ top: 30 })

        Divider()
          .color(Color.Black)
          .strokeWidth(1)

        Button(resourceToStr(this.context, $r('app.string.LOGIN')))
          ._buttonStyle(
            Color.Black,
            Color.White
          )
          .width('100%')
          .margin({ top: 50 })
          .onClick(async () => {
            //to do: login
            let res = await this.accountManager.login(this.email, this.password)
            if (res == true) {
              displayAlertWindow(resourceToStr(this.context, $r('app.string.Set_PIN')),
                resourceToStr(this.context, $r('app.string.SET_PIN_QUERY')),
                resourceToStr(this.context, $r('app.string.YES')),
                resourceToStr(this.context, $r('app.string.NO')),
                () => {
                  router.replaceUrl({
                    url: 'pages/SetPIN'
                  })
                },
                () => {
                  popToastInfo(resourceToStr(this.context, $r('app.string.LOGIN_SUCCESS')))
                  router.pushUrl({
                    url: 'pages/Index'
                  })
                }
              )
            } else {
              popToastInfo(resourceToStr(this.context, $r('app.string.WRONG_CREDENTIAL')))
            }
          })
      }
      .loginContainerStyle()
      .alignItems(HorizontalAlign.Start)
      .formBgStyle()

      Row() {
        Text(resourceToStr(this.context, $r('app.string.REGISTER_QUERY')))
          .fontSize(15)
          .fontWeight(500)
          .fontColor(Color.Blue)
          .decoration({
            type: TextDecorationType.Underline,
            color: Color.Blue
          })
      }
      .justifyContent(FlexAlign.Center)
      .width('100%')
      .onClick(() => {
        router.pushUrl({
          url: 'pages/Register'
        })
      })
    }
    .loginBgStyle()
    .justifyContent(FlexAlign.Center)
  }
}

@Extend(Image)
function iconStyle() {
  .width(25)
  .height(25)
}

@Extend(TextInput)
function inputStyle() {
  .height(40)
  .backgroundColor(Color.Transparent)
  .fontSize(14)
  .layoutWeight(1)
}

@Extend(Button)
function _buttonStyle(
  btColor: ResourceColor,
  fontColor: ResourceColor,
) {
  .fontColor(fontColor)
  .backgroundColor(btColor)
  .height('5%')
  .type(ButtonType.Normal)
  .fontSize(14)
  .borderWidth(1)
  .borderRadius(5)
  .fontWeight(FontWeight.Medium)
}

@Extend(Column)
function loginContainerStyle() {
  .width('70%')
}

@Styles
function formBgStyle() {
  .padding(30)
  .borderRadius(20)
  .backgroundColor(Color.White)
  .width('100%')
}

@Styles
function loginBgStyle() {
  .width('100%')
  .height('100%')
  .backgroundColor(Color.Orange)
  .padding({
    top: 30,
    bottom: 30,
    left: 30,
    right: 30
  })
}

@Extend(Text)
function titleStyle() {
  .fontSize(22)
  .alignSelf(ItemAlign.Center)
  .fontWeight(700)
}
