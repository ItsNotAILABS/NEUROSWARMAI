#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════════════════
# JARVIS Desktop App Packager
# ═══════════════════════════════════════════════════════════════════════════════
# Installs dependencies and builds desktop distribution packages via
# Electron Forge for all supported platforms.
#
# Usage:
#   ./scripts/package-desktop.sh              # Build for current platform
#   ./scripts/package-desktop.sh --platform win32   # Cross-compile for Windows
#   ./scripts/package-desktop.sh --platform darwin  # Cross-compile for macOS
#   ./scripts/package-desktop.sh --platform linux   # Cross-compile for Linux
#
# Output:
#   desktop/out/make/          — Installer packages (.exe, .deb, .rpm, .zip)
#   desktop/out/JARVIS-*/      — Unpacked app directories
# ═══════════════════════════════════════════════════════════════════════════════
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
DESKTOP_DIR="$ROOT_DIR/desktop"

PLATFORM=""

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --platform)
      PLATFORM="$2"
      shift 2
      ;;
    *)
      echo "Unknown option: $1" >&2
      exit 1
      ;;
  esac
done

echo "══════════════════════════════════════════════════════════"
echo "  JARVIS Desktop App Packager"
echo "══════════════════════════════════════════════════════════"
echo ""

# Check Node.js
if ! command -v node &>/dev/null; then
  echo "Error: Node.js is required. Install from https://nodejs.org" >&2
  exit 1
fi

NODE_VERSION=$(node -v)
echo "→ Node.js: $NODE_VERSION"

# Check npm
if ! command -v npm &>/dev/null; then
  echo "Error: npm is required." >&2
  exit 1
fi

echo "→ npm: $(npm -v)"
echo ""

# ── Step 1: Install desktop dependencies ───────────────────────────────────
echo "→ Installing desktop dependencies..."
cd "$DESKTOP_DIR"
npm install
echo "  ✓ Dependencies installed"
echo ""

# ── Step 2: Create assets directory with placeholder icons if missing ──────
ASSETS_DIR="$DESKTOP_DIR/assets"
mkdir -p "$ASSETS_DIR"

# Generate minimal PNG icon if none exists
if [ ! -f "$ASSETS_DIR/icon.png" ]; then
  echo "→ Generating placeholder icons..."
  # Create a minimal 256x256 PNG using Node.js (no external tools needed)
  node -e "
    const fs = require('fs');
    const path = require('path');

    // Minimal valid 1x1 cyan PNG, will be used as placeholder
    const pngHeader = Buffer.from([
      0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, // PNG signature
      // IHDR
      0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52,
      0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x00,
      0x08, 0x02, 0x00, 0x00, 0x00, 0xD3, 0x10, 0xA6,
      0x7B,
    ]);

    // For now just create a simple text file as placeholder marker
    fs.writeFileSync(path.join('$ASSETS_DIR', 'icon.png'), pngHeader);
    console.log('  ✓ Placeholder icon.png created');
    console.log('  ⚠ Replace assets/icon.png, icon.ico, icon.icns with real JARVIS icons');
  "
fi

# ── Step 3: Build ──────────────────────────────────────────────────────────
echo ""
echo "→ Building desktop application..."

if [ -n "$PLATFORM" ]; then
  echo "  Target platform: $PLATFORM"
  npx electron-forge make --platform "$PLATFORM" --arch x64
else
  echo "  Target platform: current ($(uname -s | tr '[:upper:]' '[:lower:]'))"
  npx electron-forge make
fi

echo ""
echo "══════════════════════════════════════════════════════════"
echo "  ✓ Desktop app built successfully!"
echo ""
echo "  Output directory: desktop/out/"
echo ""

# List output files
if [ -d "$DESKTOP_DIR/out/make" ]; then
  echo "  Distribution packages:"
  find "$DESKTOP_DIR/out/make" -type f \( -name "*.exe" -o -name "*.dmg" -o -name "*.deb" -o -name "*.rpm" -o -name "*.zip" -o -name "*.AppImage" \) | while read -r f; do
    SIZE=$(du -sh "$f" | cut -f1)
    echo "    • $(basename "$f") ($SIZE)"
  done
fi

echo ""
echo "  Installation:"
echo "    Windows: Run JARVIS-Setup.exe"
echo "    macOS:   Open JARVIS.dmg → drag to Applications"
echo "    Linux:   sudo dpkg -i jarvis_*.deb"
echo "              or: sudo rpm -i jarvis-*.rpm"
echo "══════════════════════════════════════════════════════════"
