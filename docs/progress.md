# 项目进度

## 2026-06-13

- 已确认工作目录为空：`/Users/xxq/Documents/XCodeWorkSpaces/customapp30`
- 已初始化 Git 仓库
- 已确认本机工具链：Xcode 26.2，Swift 6.2.3
- 已确定产品方向：中国菜单与饮食文化指南
- 已确定产品命名：
  - English: Dish Passport
  - 简体中文：味游中国
  - 日本語：中国味めぐり
  - Bundle ID: com.zhouyajie.dishpassport
- 已开始 UX 设计阶段
- 已记录核心用户路径、状态闭环和验收标准
- 已生成中文版 HTML/CSS UX 效果图：`prototype/index.html`
- 已用浏览器验证原型可加载、无横向溢出、显式浅色方案
- 已保存原型预览图：`prototype/dish-passport-ux-preview.png`
- 用户已确认继续开发该产品方向
- 已创建原生 SwiftUI iPhone-only App 工程：`DishPassport.xcodeproj`
- 已实现核心页面闭环：
  - 探索/搜索
  - 菜品详情
  - 菜系列表与菜系详情
  - 收藏/想尝试/喜欢/最近浏览
  - 点餐短语列表、详情与复制
  - 设置、语言选择、隐私/支持入口、本地数据重置
- 已实现本地状态保存：`Codable + UserDefaults`
- 已确保集合状态变更通过重新赋值 `UserState` 触发 SwiftUI 刷新
- 已实现截图专用假数据入口：Debug + 显式启动参数 `--screenshot-demo-data`
- 已强制 App 浅色模式，并在 SwiftUI 视图中使用显式文字颜色
- 已配置：
  - Version: `1.0.0`
  - Build: `1`
  - Bundle ID: `com.zhouyajie.dishpassport`
  - iPhone only: `TARGETED_DEVICE_FAMILY = 1`
  - CFBundleDisplayName 三语本地化
- 已生成 1024x1024 RGB 无 alpha App 图标，并派生 iPhone 图标尺寸
- 已通过 Debug 模拟器构建：
  - `xcodebuild -project DishPassport.xcodeproj -scheme DishPassport -configuration Debug -destination 'platform=iOS Simulator,name=iPhone 17' build`
- 已创建 GitHub Pages 静态网页源码：`docs/github-pages`
- 已添加 GitHub Pages Actions 发布配置：`.github/workflows/pages.yml`
- 已创建 App Store Connect 中英日上架资料：`docs/app-store/app-store-connect-cn-en.md`
- 已创建使用文档：`docs/user-guide-zh.md`
- 已创建测试用例：`docs/testing/test-cases-zh.md`
- 已创建发版前校验脚本：`scripts/preflight_release.sh`
- 已创建截图脚本：`scripts/capture_screenshots.sh`
- 已通过发版前校验脚本，包括 Release 模拟器构建
- 已生成真实运行 App 首屏截图：`screenshots/app-store/01-explore.png`
- 已用浏览器验证 GitHub Pages 三语隐私/支持页面可加载

## 当前阶段

创建 GitHub 仓库并配置 Pages，然后做最终审计。

## 待办阶段

1. 创建并推送 GitHub 仓库
2. 在 GitHub Pages 首次部署完成后确认线上 URL
3. 按真实用户路径进行更完整的模拟器交互验证
4. 最后生成完整 App Store 截图组
