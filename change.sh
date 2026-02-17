#!/usr/bin/env bash

set -e

APP_PATH="/Applications/Zed.app"
ICON_PNG="icon.png"
ICONSET_DIR="Zed.iconset"
ICNS_FILE="Zed.icns"

if [ ! -f "$ICON_PNG" ]; then
  echo "❌ icon.png not found in current directory"
  exit 1
fi

if [ ! -d "$APP_PATH" ]; then
  echo "❌ Zed.app not found at $APP_PATH"
  exit 1
fi

echo "🔧 Creating iconset..."

mkdir -p "$ICONSET_DIR"

# Required macOS icon sizes
for size in 16 32 64 128 256 512; do
  sips -z $size $size     "$ICON_PNG" --out "$ICONSET_DIR/icon_${size}x${size}.png"
  sips -z $((size*2)) $((size*2)) "$ICON_PNG" --out "$ICONSET_DIR/icon_${size}x${size}@2x.png"
done

echo "📦 Converting to icns..."
iconutil -c icns "$ICONSET_DIR"

echo "🚀 Replacing app icon (requires sudo)..."
sudo cp "$ICNS_FILE" "$APP_PATH/Contents/Resources/"

echo "🔄 Refreshing icon cache..."
sudo touch "$APP_PATH"
killall Finder || true
killall Dock || true

echo "🧹 Cleaning up..."
rm -rf "$ICONSET_DIR" "$ICNS_FILE"

echo "✅ Zed icon updated!"
