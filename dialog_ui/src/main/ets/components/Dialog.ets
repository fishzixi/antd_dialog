import { ComponentContent, PromptAction } from '@kit.ArkUI';

let uiContextThis: UIContext

export function init(uiContext: UIContext) {
  uiContextThis = uiContext
}

interface BtnStyles {
  BtnYesColor?: Color | string
  BtnNoColor?: Color | string
  radius?: Length | BorderRadiuses | LocalizedBorderRadiuses
  width?: Length | LayoutPolicy
  height?: Length | LayoutPolicy
  fontSize?: number | string | Resource
}

interface DialogStyles {
  radius?: Length | BorderRadiuses | LocalizedBorderRadiuses
  width?: Length | LayoutPolicy
  height?: Length | LayoutPolicy
  backgroundColor?: Color | string
}


interface DialogOption {
  title?: string; //标题
  message?: string; //内容
  hiddenTitle?: boolean //是否显示标题
  hiddenMessage?: boolean //是否显示内容
  hiddenCancelBtn?: boolean //是否隐藏取消按钮
  startORend?: "start" | "end" //对齐方式
  onCancel?: () => void //取消的拦截事件
  onConfirm?: () => void //确定事件
  btnStyles?: BtnStyles //弹出框按钮颜色/圆角/大小 设置
  dialogStyles?: DialogStyles
  type?: "prompt" //提示框
  countDown?: number //显示倒计时
  contentBuilder?: WrappedBuilder<[]> //内容自定义组件
  closeBuilder?: WrappedBuilder<[]> //取消按钮自定义组件，如显示延时关闭
  rightTopBuilder?: WrappedBuilder<[]> //右上角自定义组件
  clickMaskClose?: boolean //点击遮罩层是否关闭弹出框
}

@Component
struct countdown {
  @State private timeId: null | number = null
  @Prop time: number

  aboutToAppear() {
    this.startCountDown()
  }

  aboutToDisappear(): void {
    this.clearInterval()
  }

  clearInterval() {
    if (this.timeId) {
      clearInterval(this.timeId)
      this.timeId = null
    }
  }

  startCountDown() {
    this.timeId = setInterval(() => {
      if (this.time > 0) {
        this.time--
      } else {
        this.clearInterval()
      }
    }, 1000)
  }

  build() {

    Text(`（${this.time}）`)

  }
}

@Builder
function ComponentContentBuilder(dialogOption: DialogOption) {

  Column() {
    if (!dialogOption.hiddenTitle) {
      Column() {
        Text(dialogOption.title || "我是弹框").fontSize(20).fontWeight(600)
      }
      .width("100%")
      .alignItems(dialogOption.startORend ?
        dialogOption.startORend === "start" ? HorizontalAlign.Start : HorizontalAlign.End : HorizontalAlign.Center)
    }
    Column() {
      if (!dialogOption.hiddenMessage) {
        if (dialogOption.contentBuilder) {
          dialogOption.contentBuilder.builder()
        } else {
          Text(dialogOption.message || "我接受使用wrapBuilder包装过后的自定义组件内容").fontColor("#ff919090")
        }
      }
    }.padding({ top: "30px", bottom: "30px" }).width("100%").alignItems(dialogOption.startORend ?
      dialogOption.startORend === "start" ? HorizontalAlign.Start : HorizontalAlign.End : HorizontalAlign.Center)

    Row() {
      if (dialogOption.type === "prompt") {
        Column() {
          Text("确认").fontSize("34lpx").fontWeight("600").fontColor("#fff")
        }
        .justifyContent(FlexAlign.Center)
        .onClick(dialogOption.onConfirm)
        .width(dialogOption.btnStyles?.width ? dialogOption.btnStyles?.width : "100%")
        .height(dialogOption.btnStyles?.height ? dialogOption.btnStyles?.height : '80lpx')
        .borderRadius(dialogOption.btnStyles?.radius ? dialogOption.btnStyles?.radius : "5%")
        .backgroundColor(dialogOption.btnStyles?.BtnYesColor ? dialogOption.btnStyles?.BtnYesColor : "#ff4685f8")

      } else {
        Row() {
          Text() {
            Span("取消")
          }.fontColor("black").fontSize("34lpx")

          if (dialogOption.closeBuilder) {
            dialogOption.closeBuilder.builder()
          } else if (dialogOption.countDown) {
            countdown({ time: dialogOption.countDown })
          }
        }
        .visibility(dialogOption.hiddenCancelBtn ? Visibility.Hidden : Visibility.Visible)
        .justifyContent(FlexAlign.Center)
        .alignItems(VerticalAlign.Center)
        .onClick(dialogOption.onCancel ? dialogOption.onCancel : DialogUtil.dismiss)
        .border({
          width: "2px",
          color: "#ccc",
          radius: dialogOption.btnStyles?.radius ? dialogOption.btnStyles.radius : "5%"
        })
        .width(dialogOption.btnStyles?.width ? dialogOption.btnStyles.width : '190lpx')
        .height(dialogOption.btnStyles?.height ? dialogOption.btnStyles.height : '80lpx')
        .backgroundColor(dialogOption.btnStyles?.BtnNoColor ? dialogOption.btnStyles?.BtnNoColor : '#fff')

        Column() {
          Text('确认').fontColor("#fff").fontSize("34lpx")
        }
        .justifyContent(FlexAlign.Center)
        .onClick(dialogOption.onConfirm)
        .border({
          radius: dialogOption.btnStyles?.radius ? dialogOption.btnStyles.radius : "5%"
        })
        .width(dialogOption.btnStyles?.width ? dialogOption.btnStyles.width : '190lpx')
        .height(dialogOption.btnStyles?.height ? dialogOption.btnStyles.height : '80lpx')
        .backgroundColor(dialogOption.btnStyles?.BtnYesColor ? dialogOption.btnStyles?.BtnYesColor : '#ff4685f8')
      }

    }.justifyContent(FlexAlign.SpaceBetween).alignItems(VerticalAlign.Center).width("100%")

    Row() {
      if (dialogOption.rightTopBuilder) {
        dialogOption.rightTopBuilder.builder()
      }
    }
    .position({ top: -15, right: -15 })
    .justifyContent(FlexAlign.Center)
    .alignItems(VerticalAlign.Center)
  }
  .width(dialogOption.dialogStyles?.width ? dialogOption.dialogStyles.width : "80%")
  .height(dialogOption.dialogStyles?.height ? dialogOption.dialogStyles?.height : "")
  .constraintSize({ minHeight: "500px" })
  .backgroundColor(dialogOption.dialogStyles?.backgroundColor ? dialogOption.dialogStyles?.backgroundColor : "#fff")
  .padding(25)
  .borderRadius("5%")
  .justifyContent(FlexAlign.SpaceBetween)
}

export class DialogUtil {
  private static promptAction: PromptAction;
  private static componentContent: ComponentContent<object>

  static setTimeClose(time: number = 3000, activeCountDown: boolean = false) {
    if (activeCountDown) {

    }

    setTimeout(() => {
      DialogUtil.dismiss()
    }, time)
  }

  static open(config: DialogOption = {}) {
    DialogUtil.componentContent =
      new ComponentContent(uiContextThis, wrapBuilder(ComponentContentBuilder),
        config)
    DialogUtil.promptAction = uiContextThis.getPromptAction();
    DialogUtil.promptAction.openCustomDialog(DialogUtil.componentContent, {
      autoCancel: config.clickMaskClose && true
    });
  }

  static dismiss() {
    DialogUtil.promptAction.closeCustomDialog(DialogUtil.componentContent)
  }
}
