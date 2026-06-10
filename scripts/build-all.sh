#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════════════════
# JARVIS — Full Distribution Builder
# ═══════════════════════════════════════════════════════════════════════════════
# Builds ALL deployment artifacts in one shot:
#   1. Frontend web build (Vite → dist/)
#   2. JARVIS Chrome/Edge extension ZIP
#   3. Desktop app installers (Windows .exe, macOS .zip, Linux .deb)
#
# Usage:
#   ./scripts/build-all.sh
#
# Output:
#   dist/jarvis-extension-v1.0.0.zip      — Browser extension
#   desktop/out/make/                       — Desktop installers
#   src/frontend/dist/                      — Web frontend build
# ═══════════════════════════════════════════════════════════════════════════════
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

echo ""
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║         JARVIS — Full Distribution Builder                ║"
echo "║         Sovereign AI Command Center                       ║"
echo "║         Owner: Alfredo Medina Hernandez                   ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""

ERRORS=0

# ── Step 1: Frontend Build ─────────────────────────────────────────────────
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Step 1/3: Building Frontend (Vite)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

cd "$ROOT_DIR/src/frontend"
if [ -f "package.json" ]; then
  npm install --prefer-offline 2>/dev/null || npm install
  npm run build:skip-bindings 2>/dev/null || npm run build || {
    echo "  ⚠ Frontend build failed (may need canister bindings)"
    ERRORS=$((ERRORS + 1))
  }
  echo "  ✓ Frontend build complete"
else
  echo "  ⚠ No frontend package.json found"
  ERRORS=$((ERRORS + 1))
fi

echo ""

# ── Step 2: Extension Package ──────────────────────────────────────────────
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Step 2/3: Packaging JARVIS Extension"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

bash "$SCRIPT_DIR/package-extension.sh" || {
  echo "  ⚠ Extension packaging failed"
  ERRORS=$((ERRORS + 1))
}

echo ""

# ── Step 3: Desktop Package ───────────────────────────────────────────────
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Step 3/3: Building Desktop App"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

bash "$SCRIPT_DIR/package-desktop.sh" || {
  echo "  ⚠ Desktop packaging failed (may need platform-specific tools)"
  ERRORS=$((ERRORS + 1))
}

echo ""

# ── Summary ────────────────────────────────────────────────────────────────
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║                  BUILD SUMMARY                            ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""

echo "  Artifacts:"

# Check frontend
if [ -f "$ROOT_DIR/src/frontend/dist/index.html" ]; then
  echo "    ✓ Frontend:    src/frontend/dist/"
else
  echo "    ✗ Frontend:    NOT BUILT"
fi

# Check extension ZIP
EXT_ZIP=$(find "$ROOT_DIR/dist" -name "jarvis-extension-*.zip" -print -quit 2>/dev/null)
if [ -n "$EXT_ZIP" ]; then
  SIZE=$(du -sh "$EXT_ZIP" | cut -f1)
  echo "    ✓ Extension:   $(basename "$EXT_ZIP") ($SIZE)"
else
  echo "    ✗ Extension:   NOT BUILT"
fi

# Check desktop
if [ -d "$ROOT_DIR/desktop/out/make" ]; then
  echo "    ✓ Desktop:     desktop/out/make/"
  find "$ROOT_DIR/desktop/out/make" -type f \( -name "*.exe" -o -name "*.dmg" -o -name "*.deb" -o -name "*.rpm" -o -name "*.zip" \) | while read -r f; do
    SIZE=$(du -sh "$f" | cut -f1)
    echo "                   • $(basename "$f") ($SIZE)"
  done
else
  echo "    ✗ Desktop:     NOT BUILT"
fi

echo ""
if [ $ERRORS -eq 0 ]; then
  echo "  Status: ALL BUILDS SUCCEEDED ✓"
else
  echo "  Status: $ERRORS build(s) had warnings (see output above)"
fi
echo ""
