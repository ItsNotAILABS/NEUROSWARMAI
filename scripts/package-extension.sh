#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════════════════
# JARVIS Extension Packager
# ═══════════════════════════════════════════════════════════════════════════════
# Builds a distribution-ready ZIP of the JARVIS Chrome/Edge extension.
#
# Usage:
#   ./scripts/package-extension.sh
#
# Output:
#   dist/jarvis-extension-v<VERSION>.zip
# ═══════════════════════════════════════════════════════════════════════════════
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
EXT_DIR="$ROOT_DIR/extension/jarvis"
DIST_DIR="$ROOT_DIR/dist"

# Read version from manifest
VERSION=$(node -e "console.log(JSON.parse(require('fs').readFileSync('$EXT_DIR/manifest.json','utf8')).version)")
ZIP_NAME="jarvis-extension-v${VERSION}.zip"

echo "══════════════════════════════════════════════════════════"
echo "  JARVIS Extension Packager"
echo "  Version: $VERSION"
echo "══════════════════════════════════════════════════════════"
echo ""

# Validate extension directory
if [ ! -f "$EXT_DIR/manifest.json" ]; then
  echo "Error: manifest.json not found at $EXT_DIR" >&2
  exit 1
fi

# Required files check
REQUIRED_FILES=(
  "manifest.json"
  "background.js"
  "sidepanel.html"
  "sidepanel.js"
  "content.js"
  "content.css"
)

echo "→ Validating extension files..."
for f in "${REQUIRED_FILES[@]}"; do
  if [ ! -f "$EXT_DIR/$f" ]; then
    echo "  ✗ Missing required file: $f" >&2
    exit 1
  fi
  echo "  ✓ $f"
done

# Check icons
if [ -d "$EXT_DIR/icons" ]; then
  ICON_COUNT=$(find "$EXT_DIR/icons" -name "*.png" | wc -l)
  echo "  ✓ icons/ ($ICON_COUNT PNG files)"
else
  echo "  ⚠ icons/ directory missing (extension will work but without custom icons)"
fi

echo ""

# Create dist directory
mkdir -p "$DIST_DIR"

# Remove old ZIP if it exists
rm -f "$DIST_DIR/$ZIP_NAME"

echo "→ Building ZIP archive..."
cd "$EXT_DIR"
zip -r "$DIST_DIR/$ZIP_NAME" . \
  -x "*.DS_Store" \
  -x "__MACOSX/*" \
  -x "*.map" \
  -x "node_modules/*" \
  -x ".git/*" \
  -x "README.md"

ZIP_SIZE=$(du -sh "$DIST_DIR/$ZIP_NAME" | cut -f1)

echo ""
echo "══════════════════════════════════════════════════════════"
echo "  ✓ Extension packaged successfully!"
echo ""
echo "  Output: dist/$ZIP_NAME"
echo "  Size:   $ZIP_SIZE"
echo ""
echo "  Installation:"
echo "    Chrome: chrome://extensions → Load unpacked → select extracted folder"
echo "    Edge:   edge://extensions   → Load unpacked → select extracted folder"
echo "    Or:     Drag & drop the ZIP into the extensions page"
echo "══════════════════════════════════════════════════════════"
