# Handoff

## 项目概况

Dish Passport（味游中国 / 中国味めぐり）是一款面向美国 App Store 的原生 iPhone App，核心功能是帮助用户离线看懂中国菜单、学习点餐短语、理解菜品文化并保存想尝试/喜欢的菜。

## 关键约束

- 原生 iOS App
- iPhone only
- 版本号 1.0.0
- Bundle ID: com.zhouyajie.dishpassport
- 本地 App，无账号、无后端、不主动发起网络请求
- 支持英语、简体中文、日语
- 用户显式选语言时按用户选择，否则按地区/系统推断，兜底英文
- CFBundleDisplayName 需要三语配置
- App 内设置页不能显示 Bundle ID
- 浅色设计必须强制浅色模式，并显式指定浅底文字颜色
- Git 管理项目
- 每阶段进度写入 docs

## 功能闭环要求

任何功能不能只是入口。必须满足：

- 入口清楚
- 操作有效
- 状态保存
- 返回后有反馈
- 重启后关键用户状态仍存在

SwiftUI 状态特别注意：

- `@Published` 字典/数组变更必须确保触发 UI 刷新
- 推荐通过不可变更新或重新赋值集合来发布变化
- 不要只原地修改嵌套值后期待列表刷新

## 截图假数据要求

- 通过显式启动参数启用，例如 `--screenshot-demo-data`
- 正式启动和 Release 版本不得初始化、显示、持久化任何假数据
- 假数据逻辑与生产逻辑隔离
- 提供截图脚本和发版前校验脚本
- 截图放在用户确认 UX、App 开发完成之后

## 当前状态

仓库已初始化，正在 UX 设计阶段。已创建：

- `docs/ux-design-zh.md`
- `docs/progress.md`
- `docs/handoff.md`

下一步是完成 `prototype/index.html` 和 `prototype/styles.css`，用浏览器预览后让用户确认。

