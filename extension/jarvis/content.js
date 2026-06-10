// ═══════════════════════════════════════════════════════════════════════════════
// MERIDIANUS — Content Script
// ═══════════════════════════════════════════════════════════════════════════════
// Floating Action Button + Slide-in panel push behavior

(function () {
  'use strict';

  // Prevent double-injection
  if (document.getElementById('meridianus-fab')) return;

  // ── Floating Action Button ─────────────────────────────────────────────────

  const fab = document.createElement('button');
  fab.id = 'meridianus-fab';
  fab.innerHTML = '<span class="fab-letter">M</span><span class="fab-ring"></span>';
  fab.setAttribute('aria-label', 'Open MERIDIANUS');
  fab.classList.add('meridianus-pulse');
  document.body.appendChild(fab);

  // Remove pulse after initial animation
  fab.addEventListener('animationend', () => {
    fab.classList.remove('meridianus-pulse');
  });

  fab.addEventListener('click', () => {
    chrome.runtime.sendMessage({ type: 'OPEN_SIDE_PANEL' }).catch(() => {
      // Background handler takes care of it
    });
  });

  // ── Page Data Helpers ──────────────────────────────────────────────────────

  function getSelectedText() {
    const selection = window.getSelection();
    return selection ? selection.toString().trim() : '';
  }

  function getPageData() {
    return {
      title: document.title,
      url: window.location.href,
      selectedText: getSelectedText(),
    };
  }

  // ── Message Listeners ──────────────────────────────────────────────────────

  chrome.runtime.onMessage.addListener((message, _sender, sendResponse) => {
    switch (message.type) {
      case 'GET_SELECTION':
        sendResponse({ success: true, selectedText: getSelectedText() });
        break;
      case 'GET_PAGE_DATA':
        sendResponse({ success: true, data: getPageData() });
        break;
      default:
        sendResponse({ success: false, error: 'Unknown content message type' });
    }
    return false;
  });
})();
