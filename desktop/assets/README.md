# Desktop App Icons

Replace these placeholder files with actual JARVIS branding icons:

| File | Format | Size | Used By |
|------|--------|------|---------|
| `icon.png` | PNG | 512×512 or 1024×1024 | Linux, generic |
| `icon.ico` | ICO | Multi-size (16–256px) | Windows |
| `icon.icns` | ICNS | Multi-size | macOS |

## Generating Icons

You can use tools like:
- [electron-icon-builder](https://www.npmjs.com/package/electron-icon-builder) — `npx electron-icon-builder --input=icon-source.png --output=./`
- [png2icons](https://github.com/nicegraf/png2icons) — converts PNG to ICO/ICNS
- Online: [ConvertICO](https://convertico.com/), [iConvert](https://iconverticons.com/)

Start with a single high-res PNG (1024×1024, transparent background recommended) and generate all formats from it.
