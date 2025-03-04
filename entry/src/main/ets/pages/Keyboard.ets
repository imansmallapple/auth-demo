import buttonItem from './buttonItem'

@Component
export default struct Keyboard {
  private keyboardArray: string[] = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0']
  @Consume result: string
  @Consume textCaretPosition: number
  //touch color
  tapColor: string = '#666666'
  defaultColor: string = '#ffffffff'
  @State buttonBgColor: string = ''

  deleteNumber() {
    if (this.result) {
      this.result = this.result.slice(0, -1)
      this.textCaretPosition--
    }
  }

  testPrint() {
    console.log(this.result.toString())
  }

  build() {
    Column() {
      Row() {
        Grid() {
          ForEach(this.keyboardArray, (item: string) => {
            GridItem() {
              buttonItem({
                content: item,
                // result: $result
              })
            }
          })
          GridItem() {
            Text('x')
              .fontSize(20)
              .fontWeight(500)
          }
          .keyboardButtonStyle()
          .onClick(() => {
            this.deleteNumber()
            this.testPrint()
          })
          .onTouch((event: TouchEvent) => {
            if (event.type == TouchType.Down) {
              this.buttonBgColor = this.tapColor
            }
            if (event.type == TouchType.Up) {
              this.buttonBgColor = this.defaultColor
            }
          })
          .columnStart(1)
          .columnEnd(2)
          .backgroundColor(this.buttonBgColor)
        }
        .gridStyle()
        .height(240)
      }
    }
  }
}

@Extend(GridItem)
function keyboardButtonStyle() {
  .backgroundColor(Color.White)
  .opacity(0.7)
  .height(50)
  .borderRadius(15)
  .borderWidth(1)
}

@Extend(Grid)
function gridStyle() {
  .columnsTemplate('1fr 1fr 1fr')
  .columnsGap(4)
  .rowsGap(4)
  .width('95%')
  .padding({ top: 15 })
}