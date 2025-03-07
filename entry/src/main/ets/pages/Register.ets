import router from '@ohos.router'
import { AccountManager } from '../viewModel/account'
import common from '@ohos.app.ability.common';
import Log from '../utils/Log';
import promptAction from '@ohos.promptAction';
import { resourceToStr } from '../utils/stringUtil';

let context = getContext(this) as common.UIAbilityContext;

@Entry
@Component
struct Register {
  @State username: string = ''
  @State email: string = ''
  @State password: string = ''
  @State repeat: string = ''
  @State isUserExist: boolean = false
  private accountManager: AccountManager = new AccountManager(context)
  @State isInputDataLegal: boolean = true
  private context = getContext(this) as common.UIAbilityContext

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
        Text(resourceToStr(this.context, $r('app.string.REGISTRATION')))
          .fontSize(22)
          .alignSelf(ItemAlign.Center)
          .fontWeight(700)

        Row() {
          Image($r('app.media.icon_user'))
            .width(25)
            .height(25)
          TextInput({ placeholder: resourceToStr(this.context, $r('app.string.USERNAME')) })
            .height(40)
            .backgroundColor(Color.Transparent)
            .fontSize(14)
            .layoutWeight(1)
            .onChange((value) => {
              this.username = value
            })
        }
        .margin({ top: 30 })

        Divider()
          .color(Color.Black)
          .strokeWidth(1)
        if (this.isUserExist) {
          Text(resourceToStr(this.context, $r('app.string.USER_EXIST')))
            .fontColor(Color.Red)
        }

        Row() {
          Image($r('app.media.icon_email'))
            .width(25)
            .height(25)
          TextInput({ placeholder: resourceToStr(this.context, $r('app.string.EMAIL')) })
            .height(40)
            .backgroundColor(Color.Transparent)
            .fontSize(14)
            .layoutWeight(1)
            .onChange((value) => {
              this.email = value
            })
            .type(InputType.Email)
        }
        .margin({ top: 30 })

        Divider()
          .color(Color.Black)
          .strokeWidth(1)


        Row() {
          Image($r('app.media.icon_security'))
            .width(25)
            .height(25)
          TextInput({ placeholder: resourceToStr(this.context, $r('app.string.PASSWORD')) })
            .height(40)
            .backgroundColor(Color.Transparent)
            .fontSize(14)
            .layoutWeight(1)
            .onChange((value) => {
              this.password = value
            })
            .type(InputType.Password)
        }.margin({ top: 30 })

        Divider()
          .color(Color.Black)// .margin({ right: 120 })
          .strokeWidth(1)
        Row() {
          Image($r('app.media.icon_security'))
            .width(25)
            .height(25)
          TextInput({ placeholder: resourceToStr(this.context, $r('app.string.REPEAT_PASSWORD')) })
            .height(40)
            .backgroundColor(Color.Transparent)
            .fontSize(14)
            .layoutWeight(1)
            .onChange((value) => {
              this.repeat = value
            })
            .type(InputType.Password)
        }
        .margin({ top: 30 })

        Divider()
          .color(Color.Black)
          .strokeWidth(1)
        if (!this.isInputDataLegal) {
          Column() {
            Text(resourceToStr(this.context, $r('app.string.REGISTRATION_RULE')))
              .fontColor(Color.Red)
          }
        }

        Button(resourceToStr(this.context, $r('app.string.REGISTER')))
          .fontColor(Color.White)
          .backgroundColor(Color.Black)
          .height('5%')
          .type(ButtonType.Normal)
          .fontSize(14)
          .borderWidth(1)
          .borderRadius(5)
          .fontWeight(FontWeight.Medium)
          .width('100%')
          .margin({ top: 50 })
          .onClick(async () => {
            this.isUserExist = await this.accountManager.isUserExist(this.email)
            let isDataLegal = this.accountManager.isDataLegal(this.username, this.email, this.password, this.repeat)
            this.isInputDataLegal = isDataLegal
            Log.info('Test RDB', 'isDataLegal:', isDataLegal)
            if (this.isInputDataLegal) {
              let isRegistered = await this.accountManager.register(this.email, this.username, this.password)
              Log.info('Test RDB', 'register result:', isRegistered)

              if (isRegistered == true) {
                promptAction.showToast({
                  message: resourceToStr(this.context, $r('app.string.REGISTRATION_SUCCESS'))
                })
                router.replaceUrl({
                  url: 'pages/SetPIN'
                })
              }
            } else {
              promptAction.showToast({
                message: resourceToStr(this.context, $r('app.string.INVALID_INPUT'))
              })
            }
          })
      }
      .width('70%')
      .alignItems(HorizontalAlign.Start)
      .padding(30)
      .borderRadius(20)
      .backgroundColor(Color.White)
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.Orange)
    .padding({
      top: 30,
      bottom: 30,
      left: 30,
      right: 30
    })
    .justifyContent(FlexAlign.Start)
  }
}
