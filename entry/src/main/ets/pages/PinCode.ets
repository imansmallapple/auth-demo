import Keyboard from './Keyboard'
import systemDateTime from '@ohos.systemDateTime'
import curves from '@ohos.curves'
import Log from '../utils/Log'

@Component
export default struct PinCode {
  @Consume result: string
  private pinLen: number = 6
  private controller: TextInputController = new TextInputController();
  @Prop enableKeyboardOnFocus: boolean = true
  @Consume textCaretPosition: number
  @State inputTextValue: string = ''
  @State viewId: string = ''
  @State safeAreaPadding?: Padding | Length = undefined
  @State isCaretOpacity: boolean = false
  @Link title: string

  // aboutToAppear(): void {
  //   this.viewId = `${systemDateTime.getTime()}`
  //   Log.info('viewId', this.viewId)
  // }

  setCaretOpacity() {
    this.isCaretOpacity = !this.isCaretOpacity
    setTimeout(() => {
      this.setCaretOpacity()
    }, 500)
  }

  getIndexNumber(index: number) {
    return this.result.charAt(index)
  }

  @Builder
  KeyboardBuilder() {
    Keyboard()
  }

  @Builder
  PinBoxBuilder(index: number, isFirst?: boolean) {
    Stack() {
      // Caret
      Column()
        .opacity(this.isCaretOpacity ? 1 : 0)
        .animation({
          curve: curves.springMotion(),
          duration: 300,
        })
        .visibility(this.textCaretPosition === index ? Visibility.Visible : Visibility.None)
        .borderWidth(1)
        .width(1)
        .height(20)
        .backgroundColor('#60999999')

      // Number instance
      Flex({
        justifyContent: FlexAlign.Center,
        alignItems: ItemAlign.Center
      }) {
        Column() {
          Text(this.getIndexNumber(index))
            .fontSize(20)
        }

      }
    }
    .height(50)
    .width(`calc(80%/${this.pinLen})`)
    .borderWidth(1)
  }

  build() {
    Column() {
      Column() {
        Row() {
          Text(this.title)
            .fontWeight(500)
            .fontSize(20)
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)
        .margin(10)

        Flex({
          direction: FlexDirection.Row,
          justifyContent: FlexAlign.SpaceEvenly,
          alignItems: ItemAlign.Start
        }) {
          ForEach(Array(this.pinLen).fill(0), (_: Object, index) => {
            this.PinBoxBuilder(index, index == 0)
          })
        }
        .width('100%')
      }
      .margin({
        top: '40%'
      })

      Column() {
        TextInput({
          text: this.result,
          controller: this.controller
        })// Hide all textInput component
          .fontColor(Color.Transparent)
          .caretColor(Color.Transparent)
          .backgroundColor(Color.Transparent)// define textInput id to identify it
          .id(this.viewId)
          .enableKeyboardOnFocus(this.enableKeyboardOnFocus)
          .caretPosition(this.textCaretPosition)
          .copyOption(CopyOptions.None)
          .customKeyboard(this.KeyboardBuilder())
          .maxLength(this.pinLen)
          .width('100%')
          .onAppear(() => {
            // request focus once the page appear
            this.viewId = `${systemDateTime.getTime()}`
            Log.info('viewId', this.viewId)
            setTimeout(() => {
              focusControl.requestFocus(this.viewId)
            }, 500)
          })
      }
      .width('100%')
    }
    .height('100%')
    .width('100%')
  }
}