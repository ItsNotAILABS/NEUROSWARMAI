// ═══════════════════════════════════════════════════════════════════════════════
// MERIDIANUS Desktop — Electron Main Process
// ═══════════════════════════════════════════════════════════════════════════════
// Owner: Alfredo Medina Hernandez | Dallas TX | MedinaSITech@outlook.com
//
// Wraps the MERIDIAN Command Platform as a native desktop application.
// Connects to the ICP canister backend for sovereign data persistence.
// ═══════════════════════════════════════════════════════════════════════════════

const { app, BrowserWindow, Menu, Tray, shell, ipcMain, nativeImage } = require('electron');
const path = require('path');

// Handle Squirrel events for Windows installer
if (require('electron-squirrel-startup')) app.quit();

// ── Configuration ──────────────────────────────────────────────────────────
const CANISTER_URL = 'https://command-platform.caffeine.ai';
const IS_DEV = !app.isPackaged;

// Resolve the bundled frontend dist — works both in dev and packaged mode
function getLocalFallback() {
  if (app.isPackaged) {
    // extraResource copies src/frontend/dist → Resources/dist/
    return path.join(process.resourcesPath, 'dist', 'index.html');
  }
  // In dev mode, look relative to desktop/
  return path.join(__dirname, '..', 'src', 'frontend', 'dist', 'index.html');
}

let mainWindow = null;
let tray = null;

// ── Window Creation ────────────────────────────────────────────────────────
function createMainWindow() {
  mainWindow = new BrowserWindow({
    width: 1440,
    height: 900,
    minWidth: 1024,
    minHeight: 600,
    title: 'MERIDIANUS — Sovereign AGI Command Center',
    icon: getIconPath(),
    backgroundColor: '#0a0a0b',
    titleBarStyle: process.platform === 'darwin' ? 'hiddenInset' : 'default',
    webPreferences: {
      preload: path.join(__dirname, 'preload.js'),
      contextIsolation: true,
      nodeIntegration: false,
      sandbox: true,
      webviewTag: false,
    },
    show: false,
  });

  // Show window when ready to prevent white flash
  mainWindow.once('ready-to-show', () => {
    mainWindow.show();
    mainWindow.focus();
  });

  // Load the app
  loadApp();

  // Open external links in system browser
  mainWindow.webContents.setWindowOpenHandler(({ url }) => {
    shell.openExternal(url);
    return { action: 'deny' };
  });

  // Build application menu
  buildMenu();

  mainWindow.on('closed', () => {
    mainWindow = null;
  });
}

function loadApp() {
  if (IS_DEV) {
    // In development, try local Vite dev server first
    mainWindow.loadURL('http://localhost:5173').catch(() => {
      // Fallback to built files
      loadLocalFiles();
    });
  } else {
    // In production, load from canister or local dist
    mainWindow.loadURL(CANISTER_URL).catch(() => {
      loadLocalFiles();
    });
  }
}

function loadLocalFiles() {
  const fs = require('fs');
  const localFallback = getLocalFallback();
  if (fs.existsSync(localFallback)) {
    mainWindow.loadFile(localFallback);
  } else {
    // Show error page
    mainWindow.loadURL(`data:text/html,
      <html>
        <head><style>
          body { background: #0a0a0b; color: #e5e5e5; font-family: system-ui;
                 display: flex; align-items: center; justify-content: center;
                 height: 100vh; margin: 0; }
          .container { text-align: center; }
          h1 { color: #22d3ee; font-size: 2rem; margin-bottom: 1rem; }
          p { color: #a1a1aa; margin: 0.5rem 0; }
          code { background: #18181b; padding: 2px 8px; border-radius: 4px; color: #22d3ee; }
        </style></head>
        <body>
          <div class="container">
            <h1>MERIDIANUS</h1>
            <p>Cannot connect to the Command Platform.</p>
            <p>Run <code>cd src/frontend && npm run build</code> to generate local assets.</p>
            <p>Or deploy to ICP and update the canister URL.</p>
          </div>
        </body>
      </html>
    `);
  }
}

function getIconPath() {
  const iconName = process.platform === 'win32' ? 'icon.ico'
    : process.platform === 'darwin' ? 'icon.icns'
    : 'icon.png';
  return path.join(__dirname, 'assets', iconName);
}

// ── Application Menu ───────────────────────────────────────────────────────
function buildMenu() {
  const template = [
    {
      label: 'MERIDIANUS',
      submenu: [
        { label: 'About MERIDIANUS', role: 'about' },
        { type: 'separator' },
        {
          label: 'Reload',
          accelerator: 'CmdOrCtrl+R',
          click: () => mainWindow?.webContents.reload(),
        },
        {
          label: 'Force Reload',
          accelerator: 'CmdOrCtrl+Shift+R',
          click: () => mainWindow?.webContents.reloadIgnoringCache(),
        },
        { type: 'separator' },
        {
          label: 'Developer Tools',
          accelerator: 'CmdOrCtrl+Shift+I',
          click: () => mainWindow?.webContents.toggleDevTools(),
        },
        { type: 'separator' },
        { label: 'Quit', accelerator: 'CmdOrCtrl+Q', role: 'quit' },
      ],
    },
    {
      label: 'Edit',
      submenu: [
        { role: 'undo' },
        { role: 'redo' },
        { type: 'separator' },
        { role: 'cut' },
        { role: 'copy' },
        { role: 'paste' },
        { role: 'selectAll' },
      ],
    },
    {
      label: 'View',
      submenu: [
        { role: 'zoomIn' },
        { role: 'zoomOut' },
        { role: 'resetZoom' },
        { type: 'separator' },
        { role: 'togglefullscreen' },
      ],
    },
    {
      label: 'Navigate',
      submenu: [
        {
          label: 'MERIDIANUS Dashboard',
          click: () => navigateToSection('jarvis'),
        },
        {
          label: 'Command Workspace',
          click: () => navigateToSection('command'),
        },
        {
          label: 'Genesis Dashboard',
          click: () => navigateToSection('genesis'),
        },
        {
          label: 'GRPE Command',
          click: () => navigateToSection('grpe-command'),
        },
        {
          label: 'Organism Workforce',
          click: () => navigateToSection('workforce'),
        },
      ],
    },
    {
      label: 'Help',
      submenu: [
        {
          label: 'Documentation',
          click: () => shell.openExternal('https://github.com/FreddyCreates/command-platform'),
        },
        {
          label: 'Report Issue',
          click: () => shell.openExternal('https://github.com/FreddyCreates/command-platform/issues'),
        },
      ],
    },
  ];

  Menu.setApplicationMenu(Menu.buildFromTemplate(template));
}

function navigateToSection(section) {
  if (mainWindow) {
    mainWindow.webContents.executeJavaScript(
      `window.dispatchEvent(new CustomEvent('jarvis-navigate', { detail: { section: '${section}' } }))`
    );
  }
}

// ── System Tray ────────────────────────────────────────────────────────────
function createTray() {
  try {
    // Create a simple 16x16 tray icon programmatically
    const icon = nativeImage.createFromBuffer(
      Buffer.from(
        'iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAKElEQVQ4T2P8z8Dwn4EIwMjAwMBIjAFEawAZQJdgGDVg1IBRA8jPBgCHEwkRPKgHvgAAAABJRU5ErkJggg==',
        'base64'
      )
    );
    tray = new Tray(icon);
    tray.setToolTip('MERIDIANUS — Sovereign AGI');

    const contextMenu = Menu.buildFromTemplate([
      { label: 'Show MERIDIANUS', click: () => mainWindow?.show() },
      { type: 'separator' },
      { label: 'Quit', click: () => app.quit() },
    ]);
    tray.setContextMenu(contextMenu);

    tray.on('click', () => {
      if (mainWindow) {
        mainWindow.isVisible() ? mainWindow.hide() : mainWindow.show();
      }
    });
  } catch {
    // Tray creation may fail in some environments (CI, headless)
  }
}

// ── IPC Handlers ───────────────────────────────────────────────────────────
ipcMain.handle('jarvis:version', () => app.getVersion());
ipcMain.handle('jarvis:platform', () => process.platform);
ipcMain.handle('jarvis:isPackaged', () => app.isPackaged);

// ── App Lifecycle ──────────────────────────────────────────────────────────
app.whenReady().then(() => {
  createMainWindow();
  createTray();

  app.on('activate', () => {
    // macOS: re-create window when dock icon is clicked
    if (BrowserWindow.getAllWindows().length === 0) createMainWindow();
  });
});

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') app.quit();
});

// Security: prevent navigation to unknown URLs
app.on('web-contents-created', (_event, contents) => {
  contents.on('will-navigate', (event, url) => {
    const parsedUrl = new URL(url);
    const allowed = ['localhost', '127.0.0.1', 'command-platform.caffeine.ai', 'identity.internetcomputer.org'];
    if (!allowed.some(h => parsedUrl.hostname.includes(h))) {
      event.preventDefault();
      shell.openExternal(url);
    }
  });
});
