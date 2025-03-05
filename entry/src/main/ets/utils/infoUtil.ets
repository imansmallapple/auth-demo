import promptAction from '@ohos.promptAction'

export function displayAlertWindow(title: string, message: string, firstBtnTxt: string, secondBtnTxt: string, firstAction: () => void, secondAction: () => void) {
  AlertDialog.show(
    {
      title: title,
      message: message,
      alignment: DialogAlignment.Center,
      primaryButton: {
        value: firstBtnTxt,
        action: firstAction
      },
      secondaryButton: {
        value: secondBtnTxt,
        action: secondAction
      }
    }
  )
}

export function popToastInfo(message: string) {
  promptAction.showToast({
    message: message
  })
}