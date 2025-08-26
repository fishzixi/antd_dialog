import { DialogUtil, init } from "antd_dialog"

@Builder
function
customizeBuilder() {
  Text("我是自定义组件")
}

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  customize = wrapBuilder(customizeBuilder) //验证它是一个builder函数

  aboutToAppear() {
    init(this.getUIContext()) // 初始化 UIContext，仅在该页面初始化执行一次
  }

  build() {
    Button("基础弹框").onClick(() => {
      DialogUtil.open({
        title: "提示框",
        clickMaskClose: false, //点击遮罩层是否关闭
        contentBuilder: this.customize, //传入自定义build函数
        startORend: "start", //头、尾部对齐 默认居中
        type: 'prompt', //提示框类型
        btnStyles: {
          radius: '5%',
          BtnYesColor: "#ccc"
        },
        dialogStyles: {
          width: 300
        }
      })
    })
  }
}