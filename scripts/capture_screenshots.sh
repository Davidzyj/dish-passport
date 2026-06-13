#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

DEVICE_NAME="${DEVICE_NAME:-iPhone 17}"
BUNDLE_ID="com.zhouyajie.dishpassport"
OUT_DIR="$ROOT/screenshots/app-store"

mkdir -p "$OUT_DIR"

DEVICE_ID="$(DEVICE_NAME="$DEVICE_NAME" node <<'NODE'
const { execFileSync } = require("child_process");
const name = process.env.DEVICE_NAME;
const data = JSON.parse(execFileSync("xcrun", ["simctl", "list", "devices", "available", "--json"], { encoding: "utf8" }));
for (const runtime of Object.keys(data.devices)) {
  const match = data.devices[runtime].find((device) => device.name === name && device.isAvailable);
  if (match) {
    process.stdout.write(match.udid);
    process.exit(0);
  }
}
process.exit(1);
NODE
)"
if [[ -z "$DEVICE_ID" ]]; then
  echo "Could not find simulator named $DEVICE_NAME" >&2
  exit 1
fi

xcrun simctl boot "$DEVICE_ID" >/dev/null 2>&1 || true
xcodebuild -project DishPassport.xcodeproj -scheme DishPassport -configuration Debug -destination "platform=iOS Simulator,id=$DEVICE_ID" build >/tmp/dishpassport_screenshot_build.log

APP_PATH="$(find "$HOME/Library/Developer/Xcode/DerivedData" -path "*/Build/Products/Debug-iphonesimulator/DishPassport.app" -type d -print | head -1)"
if [[ -z "$APP_PATH" ]]; then
  echo "Could not locate built DishPassport.app" >&2
  exit 1
fi

xcrun simctl uninstall "$DEVICE_ID" "$BUNDLE_ID" >/dev/null 2>&1 || true
xcrun simctl install "$DEVICE_ID" "$APP_PATH"
xcrun simctl ui "$DEVICE_ID" appearance light >/dev/null 2>&1 || true
xcrun simctl launch "$DEVICE_ID" com.apple.springboard >/dev/null 2>&1 || true
sleep 1
xcrun simctl launch "$DEVICE_ID" "$BUNDLE_ID" --screenshot-demo-data
sleep 2
xcrun simctl io "$DEVICE_ID" screenshot "$OUT_DIR/01-explore.png"

echo "Captured initial screenshot: $OUT_DIR/01-explore.png"
echo "For final App Store screenshots, run the app with this script, navigate each target screen in the simulator, then use:"
echo "xcrun simctl io $DEVICE_ID screenshot $OUT_DIR/<name>.png"
