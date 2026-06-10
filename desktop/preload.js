// ═══════════════════════════════════════════════════════════════════════════════
// JARVIS Desktop — Preload Script
// ═══════════════════════════════════════════════════════════════════════════════
// Exposes a minimal, secure API to the renderer process via contextBridge.
// ═══════════════════════════════════════════════════════════════════════════════

const { contextBridge, ipcRenderer } = require('electron');

contextBridge.exposeInMainWorld('jarvisDesktop', {
  // Platform info
  getVersion: () => ipcRenderer.invoke('jarvis:version'),
  getPlatform: () => ipcRenderer.invoke('jarvis:platform'),
  isPackaged: () => ipcRenderer.invoke('jarvis:isPackaged'),

  // Check if running inside Electron
  isDesktop: true,

  // Listen for navigation events from native menu
  onNavigate: (callback) => {
    window.addEventListener('jarvis-navigate', (e) => {
      callback(e.detail.section);
    });
  },
});
