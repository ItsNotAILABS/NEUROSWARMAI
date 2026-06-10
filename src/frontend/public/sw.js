// ═══════════════════════════════════════════════════════════════════════════════
// MERIDIANUS PWA Service Worker — Offline-First + φ-Heartbeat Signal
// ═══════════════════════════════════════════════════════════════════════════════
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com
//
// Caches all app assets for full offline capability.
// Runs the organism's phi-heartbeat (873ms) in background.
// Broadcasts frequency/signal data to all connected pages.
// ═══════════════════════════════════════════════════════════════════════════════

const CACHE_NAME = 'meridianus-v1.0.0';
const PHI = 1.618033988749895;
const PHI_HEARTBEAT_MS = 873;

const PRECACHE_URLS = [
  './',
  './index.html',
  './env.json',
  './manifest.json',
];

// ── Install ─────────────────────────────────────────────────────────────────
self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) =>
      cache.addAll(PRECACHE_URLS).catch(() => {
        console.log('[JARVIS SW] Precache partial — continuing');
      })
    )
  );
  self.skipWaiting();
});

// ── Activate ────────────────────────────────────────────────────────────────
self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((keys) =>
      Promise.all(keys.filter((k) => k !== CACHE_NAME).map((k) => caches.delete(k)))
    )
  );
  self.clients.claim();
  startHeartbeat();
});

// ── Fetch Strategy ──────────────────────────────────────────────────────────
self.addEventListener('fetch', (event) => {
  const url = new URL(event.request.url);

  // Skip non-GET and cross-origin
  if (event.request.method !== 'GET') return;
  if (url.origin !== self.location.origin &&
      !url.hostname.includes('icp') &&
      !url.hostname.includes('internetcomputer') &&
      !url.hostname.includes('caffeine')) return;

  // API: network-first
  if (url.pathname.startsWith('/api')) {
    event.respondWith(
      fetch(event.request)
        .then((r) => { cacheResponse(event.request, r.clone()); return r; })
        .catch(() => caches.match(event.request))
    );
    return;
  }

  // Assets: cache-first
  event.respondWith(
    caches.match(event.request).then((cached) => {
      if (cached) return cached;
      return fetch(event.request).then((response) => {
        if (response.ok) cacheResponse(event.request, response.clone());
        return response;
      }).catch(() => {
        if (event.request.mode === 'navigate') return caches.match('./index.html');
        return new Response('Offline', { status: 503 });
      });
    })
  );
});

function cacheResponse(request, response) {
  caches.open(CACHE_NAME).then((cache) => cache.put(request, response));
}

// ── φ-Heartbeat Signal ──────────────────────────────────────────────────────
let heartbeatCount = 0;
let heartbeatTimer = null;

function startHeartbeat() {
  if (heartbeatTimer) return;
  heartbeatTimer = setInterval(() => {
    heartbeatCount++;
    const signal = {
      type: 'JARVIS_HEARTBEAT',
      beat: heartbeatCount,
      phi: PHI,
      frequency: 1000 / PHI_HEARTBEAT_MS,
      timestamp: Date.now(),
      coherence: Math.sin(heartbeatCount * PHI) * 0.5 + 0.5,
    };
    self.clients.matchAll({ type: 'window' }).then((clients) => {
      clients.forEach((client) => client.postMessage(signal));
    });
  }, PHI_HEARTBEAT_MS);
}

// ── Push Notifications ──────────────────────────────────────────────────────
self.addEventListener('push', (event) => {
  const data = event.data?.json() ?? { title: 'JARVIS', body: 'Signal received.' };
  event.waitUntil(
    self.registration.showNotification(data.title, {
      body: data.body,
      icon: './assets/pwa-icon-192.png',
      badge: './assets/pwa-icon-192.png',
      vibrate: [100, 50, 100],
      tag: 'jarvis-signal',
      renotify: true,
    })
  );
});

self.addEventListener('notificationclick', (event) => {
  event.notification.close();
  event.waitUntil(
    self.clients.matchAll({ type: 'window' }).then((clients) => {
      if (clients.length > 0) return clients[0].focus();
      return self.clients.openWindow('./');
    })
  );
});
