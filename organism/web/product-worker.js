/**
 * Product Worker — Extension Builder & Asset Bundler
 *
 * Web Worker that handles product creation: building browser extensions,
 * bundling assets, generating manifests, and managing deployment artifacts.
 * Works with the download-worker for final zip packaging.
 *
 * Architecture:
 *   Manifest generator — creates MV3 Chrome extension manifests
 *   Background script generator — service worker code generation
 *   Content script generator — DOM-interactive code generation
 *   Asset bundler — icon packaging, resource collation
 *   Version management — semantic versioning, update tracking
 *   Build pipeline — source → manifest → bundle → validate → output
 *
 * Extension Catalog (26 organism extensions):
 *   Avatars: ORO, NEXUS, NOVA
 *   Entities: AXIOM, FORGE-X, STRATUM, TORI, MEDICUS, ARCANA,
 *             ORACLE, TITANIUM, VECTOR-X, SYNDICATE, CIPHER, SERAPH
 *   Workers: CODESMITH, CAMPAIGNER, DOCWRIGHT, ANALYST, TACTICIAN,
 *            EXECUTOR, ARCHITECT, OUTREACH
 *   Alphas: CHIMERA, PHANTOM, ORBITAL
 *
 * Protocol: postMessage
 *   Main → Worker: { type: 'build', extension }
 *   Main → Worker: { type: 'buildAll' }
 *   Main → Worker: { type: 'validate', extension }
 *   Main → Worker: { type: 'getCatalog' }
 *   Worker → Main: { type: 'built', slug, files, size }
 *   Worker → Main: { type: 'all-built', count, totalSize }
 *   Worker → Main: { type: 'validated', slug, valid, errors }
 *   Worker → Main: { type: 'heartbeat', beat, status }
 */

const PHI = 1.618033988749895;
const HEARTBEAT = 873;
const VERSION = '1.0.0';

let beatCount = 0;
let running = true;
let buildCount = 0;

/* ════════════════════════════════════════════════════════════════
   Extension catalog — the organism's product line
   ════════════════════════════════════════════════════════════════ */

const CATALOG = [
  // Avatars
  { slug: 'oro-command',        name: 'ORO Command',          category: 'Avatar', specs: ['Communication', 'Orchestration'], color: '#d4a843', initials: 'OR' },
  { slug: 'nexus-orchestrator', name: 'NEXUS Orchestrator',   category: 'Avatar', specs: ['Orchestration', 'Strategy'],     color: '#7c6ff0', initials: 'NX' },
  { slug: 'nova-canvas',        name: 'NOVA Canvas',          category: 'Avatar', specs: ['Campaign', 'Strategy'],           color: '#ec4899', initials: 'NV' },
  // Entities
  { slug: 'axiom-legal',        name: 'AXIOM Legal',          category: 'Entity', specs: ['Legal', 'Compliance'],            color: '#3b82f6', initials: 'AX' },
  { slug: 'forge-x',            name: 'FORGE-X Engineering',  category: 'Entity', specs: ['SoftwareEngineering', 'DevOps'], color: '#22c55e', initials: 'FX' },
  { slug: 'stratum-finance',    name: 'STRATUM Finance',      category: 'Entity', specs: ['Finance'],                        color: '#10b981', initials: 'ST' },
  { slug: 'tori-marketing',     name: 'TORI Marketing',       category: 'Entity', specs: ['Marketing', 'Brand'],             color: '#f97316', initials: 'TO' },
  { slug: 'medicus-health',     name: 'MEDICUS Health',       category: 'Entity', specs: ['Healthcare', 'Compliance'],       color: '#ef4444', initials: 'MD' },
  { slug: 'arcana-architect',   name: 'ARCANA Architect',     category: 'Entity', specs: ['Architecture'],                   color: '#8b5cf6', initials: 'AR' },
  { slug: 'oracle-analytics',   name: 'ORACLE Analytics',     category: 'Entity', specs: ['DataAnalysis', 'Strategy'],       color: '#06b6d4', initials: 'OA' },
  { slug: 'titanium-ops',       name: 'TITANIUM Operations',  category: 'Entity', specs: ['Operations'],                     color: '#64748b', initials: 'TI' },
  { slug: 'vector-x-sales',     name: 'VECTOR-X Sales',       category: 'Entity', specs: ['Sales', 'Strategy'],              color: '#f59e0b', initials: 'VX' },
  { slug: 'syndicate-media',    name: 'SYNDICATE Media',      category: 'Entity', specs: ['Media', 'Campaign'],              color: '#a855f7', initials: 'SY' },
  { slug: 'cipher-security',    name: 'CIPHER Security',      category: 'Entity', specs: ['Cybersecurity', 'Compliance'],    color: '#dc2626', initials: 'CI' },
  { slug: 'seraph-hr',          name: 'SERAPH HR',            category: 'Entity', specs: ['HumanResources'],                 color: '#14b8a6', initials: 'SE' },
  // Workers
  { slug: 'codesmith-dev',      name: 'CODESMITH Dev',        category: 'Worker', specs: ['SoftwareEngineering', 'DevOps'], color: '#84cc16', initials: 'CS' },
  { slug: 'campaigner-gtm',     name: 'CAMPAIGNER GTM',       category: 'Worker', specs: ['Campaign', 'Marketing'],          color: '#e11d48', initials: 'CA' },
  { slug: 'docwright-docs',     name: 'DOCWRIGHT Docs',       category: 'Worker', specs: ['Documentation'],                  color: '#0ea5e9', initials: 'DW' },
  { slug: 'analyst-data',       name: 'ANALYST Data',         category: 'Worker', specs: ['DataAnalysis'],                   color: '#0284c7', initials: 'AN' },
  { slug: 'tactician-strategy', name: 'TACTICIAN Strategy',   category: 'Worker', specs: ['Strategy'],                       color: '#7c3aed', initials: 'TA' },
  { slug: 'executor-ops',       name: 'EXECUTOR Ops',         category: 'Worker', specs: ['Operations'],                     color: '#475569', initials: 'EX' },
  { slug: 'architect-system',   name: 'ARCHITECT System',     category: 'Worker', specs: ['Architecture', 'SoftwareEngineering'], color: '#6d28d9', initials: 'AC' },
  { slug: 'outreach-connect',   name: 'OUTREACH Connect',     category: 'Worker', specs: ['Sales', 'Marketing'],             color: '#ea580c', initials: 'OC' },
  // Alphas
  { slug: 'chimera-alpha',      name: 'CHIMERA Alpha',        category: 'Alpha',  specs: ['Orchestration', 'Operations'],    color: '#b91c1c', initials: 'CH' },
  { slug: 'phantom-alpha',      name: 'PHANTOM Alpha',        category: 'Alpha',  specs: ['Orchestration', 'Strategy'],      color: '#4338ca', initials: 'PH' },
  { slug: 'orbital-alpha',      name: 'ORBITAL Alpha',        category: 'Alpha',  specs: ['Orchestration', 'DataAnalysis'],  color: '#0369a1', initials: 'OB' },
];

/* ════════════════════════════════════════════════════════════════
   Manifest generator — MV3 Chrome extension manifest
   ════════════════════════════════════════════════════════════════ */

function generateManifest(ext, opts) {
  const manifest = {
    manifest_version: 3,
    name: ext.name,
    version: VERSION,
    description: 'Organism extension: ' + ext.name + ' — ' + ext.specs.join(', '),
    permissions: ['storage'],
    icons: {},
  };

  if (opts && opts.activeTab) manifest.permissions.push('activeTab');
  if (opts && opts.background) {
    manifest.background = { service_worker: 'background.js' };
  }
  if (opts && opts.content) {
    manifest.content_scripts = [{
      matches: ['<all_urls>'],
      js: ['content.js'],
    }];
  }
  if (opts && opts.action) {
    manifest.action = { default_title: ext.name };
  }

  return JSON.stringify(manifest, null, 2);
}

/* ════════════════════════════════════════════════════════════════
   Script generators
   ════════════════════════════════════════════════════════════════ */

function generateBackground(ext) {
  const lines = [
    '// ' + ext.name + ' — Background Service Worker',
    'const PHI = ' + PHI + ';',
    'const ORGANISM = "' + ext.slug + '";',
    '',
    'console.log("[" + ORGANISM.toUpperCase() + "] Service worker active. φ =", PHI);',
    '',
    'chrome.runtime.onInstalled.addListener(() => {',
    '  console.log("[" + ORGANISM.toUpperCase() + "] Extension installed.");',
    '  chrome.storage.local.set({ organism: ORGANISM, installedAt: Date.now(), phi: PHI });',
    '});',
    '',
  ];
  return lines.join('\n');
}

function generateContent(ext) {
  const lines = [
    '// ' + ext.name + ' — Content Script',
    '(function() {',
    '  const ORGANISM = "' + ext.slug + '";',
    '  console.log("[" + ORGANISM.toUpperCase() + "] Content script active on:", location.hostname);',
    '})();',
    '',
  ];
  return lines.join('\n');
}

/* ════════════════════════════════════════════════════════════════
   Build pipeline
   ════════════════════════════════════════════════════════════════ */

function buildExtension(ext) {
  const hasContent = ext.specs.some(s =>
    ['DataAnalysis', 'Sales', 'Marketing', 'SoftwareEngineering', 'Campaign', 'Documentation'].includes(s)
  );

  const manifestStr = generateManifest(ext, {
    activeTab: hasContent,
    background: true,
    content: hasContent,
    action: true,
  });

  const backgroundStr = generateBackground(ext);
  const contentStr = hasContent ? generateContent(ext) : null;

  const files = [
    { name: 'manifest.json', content: manifestStr, size: manifestStr.length },
    { name: 'background.js', content: backgroundStr, size: backgroundStr.length },
  ];

  if (contentStr) {
    files.push({ name: 'content.js', content: contentStr, size: contentStr.length });
  }

  const totalSize = files.reduce((sum, f) => sum + f.size, 0);
  buildCount++;

  return {
    slug: ext.slug,
    name: ext.name,
    category: ext.category,
    files,
    totalSize,
    fileCount: files.length,
    buildNumber: buildCount,
  };
}

function buildAll() {
  const builds = [];
  let totalSize = 0;

  for (const ext of CATALOG) {
    const build = buildExtension(ext);
    builds.push(build);
    totalSize += build.totalSize;

    self.postMessage({ type: 'built', ...build });
  }

  return { count: builds.length, totalSize, builds };
}

/* ════════════════════════════════════════════════════════════════
   Validation
   ════════════════════════════════════════════════════════════════ */

function validateExtension(ext) {
  const errors = [];

  if (!ext.slug) errors.push('Missing slug');
  if (!ext.name) errors.push('Missing name');
  if (!ext.specs || ext.specs.length === 0) errors.push('No specializations');
  if (!ext.category) errors.push('Missing category');

  // Build and check manifest
  try {
    const manifest = generateManifest(ext, { background: true });
    JSON.parse(manifest); // Validate JSON
  } catch (err) {
    errors.push('Invalid manifest: ' + err.message);
  }

  return {
    slug: ext.slug,
    valid: errors.length === 0,
    errors,
  };
}

/* ════════════════════════════════════════════════════════════════
   Message handler
   ════════════════════════════════════════════════════════════════ */

self.onmessage = function (e) {
  const msg = e.data;

  switch (msg.type) {
    case 'build': {
      const ext = msg.extension || CATALOG.find(c => c.slug === msg.slug);
      if (ext) {
        const build = buildExtension(ext);
        self.postMessage({ type: 'built', ...build });
      } else {
        self.postMessage({ type: 'build-error', slug: msg.slug, error: 'Extension not found' });
      }
      break;
    }

    case 'buildAll': {
      const result = buildAll();
      self.postMessage({ type: 'all-built', count: result.count, totalSize: result.totalSize });
      break;
    }

    case 'validate': {
      const ext = msg.extension || CATALOG.find(c => c.slug === msg.slug);
      if (ext) {
        const result = validateExtension(ext);
        self.postMessage({ type: 'validated', ...result });
      }
      break;
    }

    case 'validateAll': {
      const results = CATALOG.map(validateExtension);
      const valid = results.filter(r => r.valid).length;
      self.postMessage({ type: 'all-validated', total: results.length, valid, invalid: results.length - valid, results });
      break;
    }

    case 'getCatalog':
      self.postMessage({
        type: 'catalog',
        extensions: CATALOG.map(c => ({ slug: c.slug, name: c.name, category: c.category, specs: c.specs })),
        count: CATALOG.length,
      });
      break;

    case 'getState':
      self.postMessage({
        type: 'product-state',
        catalogSize: CATALOG.length,
        buildCount,
        categories: {
          Avatar: CATALOG.filter(c => c.category === 'Avatar').length,
          Entity: CATALOG.filter(c => c.category === 'Entity').length,
          Worker: CATALOG.filter(c => c.category === 'Worker').length,
          Alpha: CATALOG.filter(c => c.category === 'Alpha').length,
        },
      });
      break;

    case 'stop':
      running = false;
      if (heartbeatInterval) clearInterval(heartbeatInterval);
      self.postMessage({ type: 'stopped', buildCount });
      break;
  }
};

/* ════════════════════════════════════════════════════════════════
   Heartbeat — runs permanently at 873ms
   ════════════════════════════════════════════════════════════════ */

const heartbeatInterval = setInterval(function () {
  if (!running) return;
  beatCount++;
  self.postMessage({
    type: 'heartbeat',
    beat: beatCount,
    phi: PHI,
    heartbeatMs: HEARTBEAT,
    timestamp: Date.now(),
    status: 'alive',
    catalogSize: CATALOG.length,
    buildCount,
  });
}, HEARTBEAT);
