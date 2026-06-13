# Handoff

## 项目概况

Dish Passport（味游中国 / 中国味めぐり）是一款面向美国 App Store 的原生 iPhone App，核心功能是帮助用户离线看懂中国菜单、学习点餐短语、理解菜品文化并保存想尝试/喜欢的菜。

仓库：
`https://github.com/Davidzyj/dish-passport`

GitHub Pages：
`https://davidzyj.github.io/dish-passport/`

## 当前状态

- 原生 SwiftUI App 已实现并可构建。
- Xcode 工程：`DishPassport.xcodeproj`
- Bundle ID：`com.zhouyajie.dishpassport`
- Version：`1.0.0`
- Build：`1`
- 设备：iPhone only
- 语言：English、简体中文、日本語
- CFBundleDisplayName 已三语本地化。
- App 内不显示 Bundle ID。
- App 强制浅色模式，并使用显式文字颜色。
- 本地数据通过 `Codable + UserDefaults` 保存。
- 无账号、无后端、无主动网络请求；只有用户点击设置页隐私/支持链接才会打开浏览器。

## 已实现功能

- 探索页：搜索英文、拼音、中文菜名。
- 菜品详情：辣度、地区、风味、食材、搭配、点餐表达、文化说明。
- 状态操作：收藏、想尝试、喜欢、最近浏览，均有持久化和反馈。
- 菜系页：菜系列表、菜系详情、代表菜、批量加入想尝试。
- 收藏页：想尝试、已喜欢、全部收藏、最近浏览。
- 点餐短语：列表、详情、复制中文短语、最近短语。
- 设置页：语言选择、隐私政策、支持、重置本地数据、版本号。

## 截图模式

截图模式只在 Debug 下编译，并且必须显式传入：

```sh
--screenshot-demo-data
```

可选页面路由：

```sh
--screenshot-screen explore
--screenshot-screen dish-detail
--screenshot-screen cuisines
--screenshot-screen saved
--screenshot-screen phrases
--screenshot-screen settings
```

Release 构建中 `ScreenshotMode.current` 固定返回 `.disabled`。截图模式不会写入生产 `UserDefaults`。

## 重要文件

- App 源码：`DishPassport/`
- Xcode 工程：`DishPassport.xcodeproj`
- 图标源脚本：`scripts/generate_app_icon.swift`
- App 图标：`DishPassport/Assets.xcassets/AppIcon.appiconset/Icon-1024.png`
- 发版前校验：`scripts/preflight_release.sh`
- 截图脚本：`scripts/capture_screenshots.sh`
- 截图：`screenshots/app-store/`
- GitHub Pages 源码：`docs/github-pages/`
- Pages workflow：`.github/workflows/pages.yml`
- App Store 资料：`docs/app-store/app-store-connect-cn-en.md`
- 使用文档：`docs/user-guide-zh.md`
- 测试用例：`docs/testing/test-cases-zh.md`
- 用户路径验收标准：`docs/user-paths-acceptance-zh.md`
- 进度：`docs/progress.md`

## 已验证命令

```sh
xcodebuild -project DishPassport.xcodeproj -scheme DishPassport -configuration Debug -destination 'platform=iOS Simulator,name=iPhone 17' build
scripts/preflight_release.sh
scripts/capture_screenshots.sh
```

验证结果：

- Debug 构建成功。
- Release 模拟器构建成功。
- 发版前校验通过。
- 1024 图标为 1024x1024 RGB，无 alpha。
- 6 张真实运行 App 截图已生成，尺寸均为 1206x2622。
- GitHub Pages 最新 workflow 已成功部署。

## 仍需账号所有者手动处理

1. 在 Apple Developer / App Store Connect 中确认 Bundle ID 和 App 记录。
2. 在 Xcode 中选择 Apple Developer Team 后 Archive。
3. 上传 build `1.0.0 (1)`。
4. 在 App Store Connect 填写价格、地区、年龄分级、隐私问卷、版权和联系人信息。
5. 上传截图与图标。
6. 提交审核。

## 后续建议

- 首版内容目前是高质量 MVP 内容集，可后续扩展到 UX 文档中设想的 100 道菜、30 条短语和 20 条文化小卡。
- 若更换 GitHub 账号或仓库名，需要同步更新 `DishPassport/LocalizedText.swift` 和 `docs/app-store/app-store-connect-cn-en.md` 中的 Pages URL。
