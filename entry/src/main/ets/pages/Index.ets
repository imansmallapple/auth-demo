import router from '@ohos.router';
import Storage from '../storage/Storage'
import { displayAlertWindow } from '../utils/infoUtil';

@Entry
@Component
struct Index {
  @State message: string = 'You logged in!';
  private localStorage = new Storage()

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

        Button('Log out')
          .onClick(() => {
            displayAlertWindow(
              'Logout',
              "Are you sure to logout?(PIN will be invalid)",
              'Logout',
              'Cancel',
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