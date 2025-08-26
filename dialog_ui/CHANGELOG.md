# CHANGELOG

## 1.0.0 (2025-06-14)

## 1.0.1(2025-06-16)

## 1.0.2(2025-06-17)

## 1.0.3(2025-06-17)

## 1.0.4(2025-06-18)

## 1.0.5(2025-06-18)

- **🚀 初始版本发布**：
- AntDesignDialog正式上线，初始封装目标：提供灵活、可配置、支持自定义内容的弹窗组件，统一弹窗调用入口，提升可维护性与复用性。
    - 使用静态方法实现工具类调用模式（DialogUtil.open / dismiss）。
    - 利用鸿蒙 ArkUI 提供的 PromptAction 与 ComponentContent 实现弹窗能力挂载。
    - 全量使用类型系统对参数与 UI 样式提供类型约束与代码提示。
- **DialogUtil工具类**：
    - DialogUtil.open(config: DialogOption)，打开弹窗，支持自定义标题、内容、自定义按钮、自定义组件插槽等。
      通过 ComponentContentBuilder 构建弹窗内容，使用 wrapBuilder 包装保证兼容 ArkUI 弹窗系统。
      支持点击遮罩层关闭（clickMaskClose 控制）。

    - DialogUtil.dismiss()
      关闭当前打开的弹窗实例，调用 PromptAction.closeCustomDialog。

    - DialogUtil.setTimeClose(time: number)
      自动延迟关闭弹窗，默认 3 秒后关闭。

- **结构定义**
    - 支持弹窗标题、内容、按钮配置（颜色、圆角、大小）等灵活样式。
    - 支持是否隐藏标题、是否隐藏取消按钮。
    - 支持自定义内容组件（contentBuilder）、取消按钮内部组件（closeBuilder）、右上角组件（rightTopBuilder）。
    - 提供 onConfirm / onCancel 回调。
    - 支持按钮对齐方式设置（startORend）。

- **UI 构建**
    - 使用 Builder 注解构建弹窗内容。
    - 可根据是否传入内容组件动态渲染默认提示内容或自定义内容。
    - 支持按钮样式定制及布局方式调整。
    - 通过 Row + Column 布局适配不同弹窗类型（prompt 仅一个确认按钮，其它情况显示确认 + 取消）。

- **📌 注意事项**：
- 弹窗功能依赖 UIContext 初始化，需通过 init(uiContext) 显式注入上下文。建议在 EntryAbility.ets 文件中导入初始化
- 使用 wrapBuilder 将普通组件构建函数适配成 ArkUI Builder 类型。
  。

如需后续迭代建议，可按以下方向考虑：

✅ 支持表单内容输入与结果返回（如 prompt 类型弹窗获取输入值）。

✅ 弹窗入场 / 关闭动画过渡效果。

✅ 弹窗挂载位置支持多页调用或全局注册。

✅ 提供队列调用或单例模式限制同时只显示一个弹窗。

- **📡 技术特性**
    - 严格遵循ArkTS类型系统，通过接口定义与类型断言保障参数安全
    - 处理ArkTS构建器限制，实现纯UI语法渲染与优先级逻辑（内容构建器 > 头部构建器 > 基础文本）
    - 集成参数验证、配置冲突预警机制，提升代码健壮性
- **🎨 设计规范**
    - 默认样式遵循鸿蒙视觉规范，支持按钮文本、背景色等样式定制
    - 适配手机、平板等多设备尺寸，保持界面一致性
- **📚 开发者支持**
    - 提供完整的安装指南、使用示例与接口文档
    - 包含错误处理示例与最佳实践说明