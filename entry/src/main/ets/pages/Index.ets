import common from '@ohos.app.ability.common';
let context = getContext(this) as common.UIAbilityContext;

@Entry
@Component
struct Index {
  @State message: string = 'You logged in!';

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
    }
    .height('100%')
  }
}