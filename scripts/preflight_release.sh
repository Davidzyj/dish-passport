#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

fail() {
  echo "FAIL: $1" >&2
  exit 1
}

pass() {
  echo "PASS: $1"
}

PROJECT="DishPassport.xcodeproj"
PBX="$PROJECT/project.pbxproj"
ICON="DishPassport/Assets.xcassets/AppIcon.appiconset/Icon-1024.png"

[[ -f "$PBX" ]] || fail "Missing Xcode project"
[[ -f "DishPassport/Info.plist" ]] || fail "Missing Info.plist"

grep -q "PRODUCT_BUNDLE_IDENTIFIER = com.zhouyajie.dishpassport;" "$PBX" || fail "Bundle ID mismatch"
pass "Bundle ID is com.zhouyajie.dishpassport"

grep -q "MARKETING_VERSION = 1.0.0;" "$PBX" || fail "Version must be 1.0.0"
grep -q "CURRENT_PROJECT_VERSION = 1;" "$PBX" || fail "Build number must be 1"
pass "Version is 1.0.0 (1)"

grep -q "TARGETED_DEVICE_FAMILY = 1;" "$PBX" || fail "TARGETED_DEVICE_FAMILY must be 1"
grep -q 'SUPPORTED_PLATFORMS = "iphoneos iphonesimulator";' "$PBX" || fail "Supported platforms must be iOS only"
pass "iPhone-only build settings are present"

grep -q "\.preferredColorScheme(.light)" DishPassport/DishPassportApp.swift || fail "App must force light mode"
pass "App forces light mode"

grep -q "#if DEBUG" DishPassport/Models.swift || fail "Screenshot mode must be guarded by #if DEBUG"
grep -q -- "--screenshot-demo-data" DishPassport/Models.swift || fail "Missing explicit screenshot launch argument"
grep -q "screenshotMode == .disabled" DishPassport/AppStore.swift || fail "Screenshot mode must not persist demo data"
grep -q "return \\.disabled" DishPassport/Models.swift || fail "Release screenshot mode must return disabled"
grep -q "if screenshotMode == \\.demoData" DishPassport/AppContentProvider.swift || fail "Demo content must require screenshot mode"
grep -q "enum DemoScreenshotContent" DishPassport/AppContentProvider.swift || fail "Missing isolated demo content type"
pass "Screenshot demo data is DEBUG-only and explicitly launched"

[[ -f "$ICON" ]] || fail "Missing 1024 icon"
WIDTH="$(sips -g pixelWidth "$ICON" 2>/dev/null | awk '/pixelWidth/ {print $2}')"
HEIGHT="$(sips -g pixelHeight "$ICON" 2>/dev/null | awk '/pixelHeight/ {print $2}')"
ALPHA="$(sips -g hasAlpha "$ICON" 2>/dev/null | awk '/hasAlpha/ {print $2}')"
[[ "$WIDTH" == "1024" && "$HEIGHT" == "1024" ]] || fail "Icon must be 1024x1024"
[[ "$ALPHA" == "no" ]] || fail "Icon must not contain alpha"
pass "1024 icon is RGB with no alpha"

for file in \
  docs/github-pages/privacy/index.html \
  docs/github-pages/privacy/zh-Hans/index.html \
  docs/github-pages/privacy/ja/index.html \
  docs/github-pages/support/index.html \
  docs/github-pages/support/zh-Hans/index.html \
  docs/github-pages/support/ja/index.html; do
  [[ -f "$file" ]] || fail "Missing page: $file"
done
pass "Privacy and support pages exist in English, Chinese, and Japanese"

grep -R "jay212315@gmail.com" docs/github-pages >/dev/null || fail "Support email missing from pages"
pass "Support email is present"

xcodebuild -project "$PROJECT" -scheme DishPassport -configuration Release -destination 'generic/platform=iOS Simulator' build >/tmp/dishpassport_release_build.log
pass "Release simulator build succeeds"

echo "Preflight complete."
