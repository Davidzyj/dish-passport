# App Store Connect 填写资料

## App Record

- App name: Dish Passport
- 简体中文名称：味游中国
- 日本語名称：中国味めぐり
- Bundle ID: `com.zhouyajie.dishpassport`
- SKU 建议：`dishpassport-ios-100`
- Version: `1.0.0`
- Build: `1`
- Primary language: English
- Category: Food & Drink
- Secondary category: Travel 或 Education
- Pricing suggestion: Paid download, US$4.99
- Copyright: `Copyright © 2026 Zhou Yajie`
- Support email: `jay212315@gmail.com`

## English Listing

Name:
Dish Passport

Subtitle:
Offline Chinese menu guide

Promotional Text:
Search Chinese dishes, learn ordering phrases, and save what you want to try. Works offline with no account or tracking.

Description:
Dish Passport is an offline guide for exploring Chinese restaurant menus with confidence.

Search dishes by English name, pinyin, or Chinese characters. Open a dish to understand its region, heat level, key ingredients, flavor notes, ordering phrase, and cultural background. Save dishes you want to try, mark favorites, and review recently viewed items on your iPhone.

The app also includes practical ordering phrases and regional cuisine notes for Sichuan, Cantonese, Jiangnan, Northern Chinese, Hunan, dim sum, noodles, and snacks.

Dish Passport is local-first: no account, no backend, no ads, no analytics SDKs, and no tracking. Your saved items stay on your device.

Keywords:
Chinese food,menu,restaurant,dim sum,Sichuan,dumplings,noodles,pinyin,travel,offline

Support URL:
`https://zhouyajie.github.io/dish-passport/support/`

Privacy Policy URL:
`https://zhouyajie.github.io/dish-passport/privacy/`

Marketing URL:
Optional. Use `https://zhouyajie.github.io/dish-passport/` if Apple requires one.

## 简体中文 Listing

名称：
味游中国

副标题：
离线中国菜单指南

宣传文本：
搜索中国菜、学习点餐短语、保存想尝试的菜品。无需账号，无追踪，安装后可离线使用。

描述：
味游中国是一款帮助用户看懂中国餐馆菜单的离线指南。

你可以用英文、拼音或中文搜索菜名，进入详情后查看地区、辣度、主要食材、口味、点餐表达和文化背景。你还可以把想尝试的菜加入清单，标记喜欢，并在 iPhone 本地查看最近浏览。

App 包含实用点餐短语，以及川菜、粤菜、江南、北方、湘菜、点心、面食、小吃等地区风味说明。

味游中国本地优先：无账号、无后端、无广告、无分析 SDK、无追踪。你的收藏数据只保存在设备本地。

关键词：
中国菜,菜单,餐馆,点心,川菜,饺子,面食,拼音,旅行,离线

支持 URL：
`https://zhouyajie.github.io/dish-passport/support/zh-Hans/`

隐私政策 URL：
`https://zhouyajie.github.io/dish-passport/privacy/zh-Hans/`

营销 URL：
可选。如需填写，使用 `https://zhouyajie.github.io/dish-passport/`。

## Japanese Listing

Name:
中国味めぐり

Subtitle:
オフライン中国メニューガイド

Promotional Text:
中国料理を検索し、注文フレーズを学び、食べたい料理を保存できます。アカウント不要、追跡なし、オフライン対応。

Description:
中国味めぐりは、中国レストランのメニューを理解するためのオフラインガイドです。

英語名、ピンイン、中国語名で料理を検索できます。料理の詳細では、地域、辛さ、主な食材、味の特徴、注文フレーズ、文化メモを確認できます。食べたい料理やお気に入り、最近見た料理は iPhone 内に保存されます。

四川料理、広東料理、江南料理、北方料理、湖南料理、点心、麺料理、軽食などの地域メモも含まれています。

このアプリはローカル優先です。アカウント、バックエンド、広告、分析 SDK、追跡はありません。

Keywords:
中国料理,メニュー,レストラン,点心,四川,餃子,麺,ピンイン,旅行,オフライン

Support URL:
`https://zhouyajie.github.io/dish-passport/support/ja/`

Privacy Policy URL:
`https://zhouyajie.github.io/dish-passport/privacy/ja/`

## App Privacy Answers

Data Collection:
No data collected.

Tracking:
No. The app does not track users and does not use third-party tracking SDKs.

Accounts:
No account creation or login.

Analytics:
No analytics SDKs or analytics data collection.

Advertising:
No ads.

User-generated public content:
No.

Location:
No location access.

Camera, microphone, photos, contacts, Bluetooth, health, calendar:
Not used.

Network:
The app does not actively connect to a backend. Support and privacy links open externally only after the user taps them.

## Review Notes

Suggested review note:

Dish Passport is a paid, local-only Chinese menu and culture guide for iPhone. It does not require an account, does not connect to a backend, does not include ads or analytics SDKs, and does not track users. User state such as saved dishes, liked dishes, want-to-try items, recent items, and language choice is stored locally on the device.

Privacy Policy and Support links are available in Settings and open in the browser only after the user taps them.

No demo account is required.

## Age Rating Notes

Suggested answers:

- No unrestricted web access inside the app.
- No user-generated content.
- No gambling, contests, medical treatment, alcohol/tobacco/drug promotion, or mature themes.
- Food content only.

Final age rating must be completed by the account owner in App Store Connect.

## Screenshots And Icon

Icon:
`DishPassport/Assets.xcassets/AppIcon.appiconset/Icon-1024.png`

Screenshot script:
`scripts/capture_screenshots.sh`

Screenshot mode:
Debug only, explicit launch argument `--screenshot-demo-data`.

## Owner Manual Steps

1. Create GitHub repository named `dish-passport`.
2. Push this project and enable GitHub Pages using the included GitHub Actions workflow `.github/workflows/pages.yml`.
3. Create App Store Connect app record with Bundle ID `com.zhouyajie.dishpassport`.
4. Configure Apple Developer signing team in Xcode.
5. Archive and upload build `1.0.0 (1)`.
6. Upload App Store screenshots generated at the final screenshot step.
7. Complete price, availability, tax/banking/contracts, age rating, and final privacy questionnaire.
8. Submit for review.
