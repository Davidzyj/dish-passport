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

capture_screen() {
  local route="$1"
  local file="$2"
  local expected_bytes=100000

  xcrun simctl terminate "$DEVICE_ID" "$BUNDLE_ID" >/dev/null 2>&1 || true
  xcrun simctl launch "$DEVICE_ID" com.apple.springboard >/dev/null 2>&1 || true
  sleep 1
  xcrun simctl launch "$DEVICE_ID" "$BUNDLE_ID" --screenshot-demo-data --screenshot-screen "$route" >/dev/null
  sleep 3
  xcrun simctl io "$DEVICE_ID" screenshot "$OUT_DIR/$file"

  local bytes
  bytes="$(wc -c < "$OUT_DIR/$file" | tr -d ' ')"
  if [[ "$bytes" -lt "$expected_bytes" ]]; then
    echo "Screenshot looks too small or blank: $file ($bytes bytes)" >&2
    exit 1
  fi
}

capture_screen "explore" "01-explore.png"
capture_screen "dish-detail" "02-dish-detail.png"
capture_screen "cuisines" "03-cuisines.png"
capture_screen "saved" "04-saved.png"
capture_screen "phrases" "05-phrases.png"
capture_screen "settings" "06-settings.png"

echo "Captured screenshots:"
for file in "$OUT_DIR"/[0-9][0-9]-*.png; do
  width="$(sips -g pixelWidth "$file" 2>/dev/null | awk '/pixelWidth/ {print $2}')"
  height="$(sips -g pixelHeight "$file" 2>/dev/null | awk '/pixelHeight/ {print $2}')"
  echo "- $file ${width}x${height}"
done
