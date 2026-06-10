// ═══════════════════════════════════════════════════════════════════════════════
// JARVIS Desktop — Electron Forge Configuration
// ═══════════════════════════════════════════════════════════════════════════════
// Produces distribution-ready installers for all platforms:
//   Windows: .exe via Squirrel
//   macOS:   .zip (and .dmg if on macOS)
//   Linux:   .deb and .rpm
// ═══════════════════════════════════════════════════════════════════════════════

module.exports = {
  packagerConfig: {
    name: 'JARVIS',
    executableName: 'jarvis',
    asar: true,
    icon: './assets/icon',
    appBundleId: 'com.medinasi.jarvis',
    appCategoryType: 'public.app-category.productivity',
    win32metadata: {
      CompanyName: 'Medina SI Tech',
      ProductName: 'JARVIS — Sovereign AI Command Center',
      FileDescription: 'JARVIS Desktop Application',
      OriginalFilename: 'jarvis.exe',
    },
    extraResource: [
      // Bundle the built frontend into Resources/frontend/
      '../src/frontend/dist',
    ],
    ignore: [
      /node_modules\/\.cache/,
      /\.git/,
      /\.github/,
    ],
  },
  rebuildConfig: {},
  makers: [
    {
      name: '@electron-forge/maker-squirrel',
      config: {
        name: 'JARVIS',
        setupExe: 'JARVIS-Setup.exe',
        setupIcon: './assets/icon.ico',
        loadingGif: undefined,
        authors: 'Alfredo Medina Hernandez',
        description: 'JARVIS — Sovereign AI Desktop Command Center',
      },
    },
    {
      name: '@electron-forge/maker-dmg',
      config: {
        name: 'JARVIS',
        icon: './assets/icon.icns',
        format: 'ULFO',
      },
    },
    {
      name: '@electron-forge/maker-zip',
      platforms: ['darwin', 'linux', 'win32'],
    },
    {
      name: '@electron-forge/maker-deb',
      config: {
        options: {
          maintainer: 'Alfredo Medina Hernandez <MedinaSITech@outlook.com>',
          homepage: 'https://github.com/FreddyCreates/command-platform',
          name: 'jarvis',
          bin: 'jarvis',
          productName: 'JARVIS',
          description: 'JARVIS — Sovereign AI Desktop Command Center',
          categories: ['Utility', 'Development'],
          section: 'utils',
        },
      },
    },
    {
      name: '@electron-forge/maker-rpm',
      config: {
        options: {
          name: 'jarvis',
          bin: 'jarvis',
          productName: 'JARVIS',
          description: 'JARVIS — Sovereign AI Desktop Command Center',
          homepage: 'https://github.com/FreddyCreates/command-platform',
          license: 'CPEL-1.0',
          categories: ['Utility', 'Development'],
        },
      },
    },
  ],
  plugins: [
    {
      name: '@electron-forge/plugin-auto-unpack-natives',
      config: {},
    },
  ],
};
