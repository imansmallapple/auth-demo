import router from '@ohos.router';
import Storage from '../storage/Storage'
import { displayAlertWindow } from '../utils/infoUtil';
import common from '@ohos.app.ability.common';
import { resourceToStr } from '../utils/stringUtil';

@Entry
@Component
struct Index {
  @State message: string = 'You logged in!'
  private localStorage = new Storage()
  private context = getContext(this) as common.UIAbilityContext

  async resetPIN() {
    await this.localStorage.putValue('pin', '')
    this.localStorage.flushAllData()
  }

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)

        Button($r('app.string.LOGOUT'))
          .onClick(() => {
            displayAlertWindow(
              resourceToStr(this.context, $r('app.string.LOGOUT')),
              resourceToStr(this.context, $r('app.string.LOGOUT_QUERY')),
              resourceToStr(this.context, $r('app.string.LOGOUT')),
              resourceToStr(this.context, $r('app.string.CANCEL')),
              async () => {
                await this.resetPIN()
                router.replaceUrl({
                  url: 'pages/Login'
                })
              },
              () => {
              }
            )
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}