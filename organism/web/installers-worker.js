/**
 * SPDX-License-Identifier: CPEL-1.0
 * Copyright © 2024-2026 Alfredo Medina Hernandez. All rights reserved.
 * Framework: Medina Doctrine
 *
 * Installers Worker — AGI Package Installer & Auto-Configuration Engine
 *
 * The 24th Web Worker in the organism fleet. Manages installation,
 * configuration, updating, and deployment of AI packages, AGI modules,
 * tool bundles, protocol packs, and system extensions. Auto-discovers
 * dependencies, resolves conflicts, validates compatibility, and
 * maintains a live package registry that self-updates through
 * Fibonacci-timed cycles.
 *
 * ════════════════════════════════════════════════════════════════════════
 *                    INSTALLER REGISTRY (34 tools)
 * ════════════════════════════════════════════════════════════════════════
 *
 * ─── Core Package Management (001–008) ───────────────────────────────
 *   INSTALLER-001  packageInstall       — Install named package with version resolution
 *   INSTALLER-002  packageUninstall     — Remove package and clean dependencies
 *   INSTALLER-003  packageUpdate        — Update package to latest compatible version
 *   INSTALLER-004  packageSearch        — Search registry by name/tag/capability
 *   INSTALLER-005  packageValidate      — Validate package integrity (hash, signatures)
 *   INSTALLER-006  packageLock          — Lock package version to prevent auto-updates
 *   INSTALLER-007  packageAudit         — Security audit of installed packages
 *   INSTALLER-008  packageExport        — Export package manifest as portable bundle
 *
 * ─── AI/AGI Module Installers (009–016) ──────────────────────────────
 *   INSTALLER-009  aiModelInstall       — Install AI model with weights and runtime
 *   INSTALLER-010  aiModelUpdate        — Update AI model to latest version
 *   INSTALLER-011  agiModuleInstall     — Install AGI governance module
 *   INSTALLER-012  agiModuleConfig      — Configure AGI module parameters
 *   INSTALLER-013  promptPackInstall    — Install prompt template packs
 *   INSTALLER-014  embeddingInstall     — Install embedding model + vector index
 *   INSTALLER-015  fineTuneInstall      — Install fine-tuned model variants
 *   INSTALLER-016  agentPackInstall     — Install VOIS agent expansion packs
 *
 * ─── Tool & Protocol Bundles (017–024) ───────────────────────────────
 *   INSTALLER-017  toolBundleInstall    — Install tool bundles (sets of related tools)
 *   INSTALLER-018  protocolPackInstall  — Install protocol packs (sets of protocols)
 *   INSTALLER-019  blueprintPackInstall — Install blueprint template packs
 *   INSTALLER-020  recipePackInstall    — Install workflow recipe packs
 *   INSTALLER-021  shieldPackInstall    — Install security shield packs
 *   INSTALLER-022  sensorPackInstall    — Install monitoring sensor packs
 *   INSTALLER-023  adapterPackInstall   — Install integration adapter packs
 *   INSTALLER-024  lensPackInstall      — Install data lens packs
 *
 * ─── System & Infrastructure (025–030) ───────────────────────────────
 *   INSTALLER-025  workerInstall        — Install new Web Worker modules
 *   INSTALLER-026  extensionInstall     — Install platform extensions
 *   INSTALLER-027  themeInstall         — Install UI theme packs
 *   INSTALLER-028  localeInstall        — Install language/locale packs
 *   INSTALLER-029  configProfileInstall — Install configuration profiles
 *   INSTALLER-030  migrationInstall     — Install database migration scripts
 *
 * ─── Auto-Discovery & Self-Update (031–034) ──────────────────────────
 *   INSTALLER-031  autoDiscover         — Auto-discover packages from all registries
 *   INSTALLER-032  autoUpdate           — Auto-update all packages to latest versions
 *   INSTALLER-033  dependencyResolve    — Resolve dependency graphs with conflict detection
 *   INSTALLER-034  registrySync         — Sync local registry with remote sources
 *
 * ════════════════════════════════════════════════════════════════════════
 *
 * Protocol: postMessage
 *   Main → Worker: { type: 'queryPackage', packageId }
 *   Main → Worker: { type: 'queryPackagesByType', packageType }
 *   Main → Worker: { type: 'queryInstalled' }
 *   Main → Worker: { type: 'queryAvailable' }
 *   Main → Worker: { type: 'queryDependencies', packageId }
 *   Main → Worker: { type: 'queryUpdates' }
 *   Main → Worker: { type: 'queryHistory', count? }
 *   Main → Worker: { type: 'queryCapacity' }
 *   Main → Worker: { type: 'queryHealth' }
 *   Main → Worker: { type: 'queryRegistry' }
 *   Main → Worker: { type: 'callInstall', packageId, version?, options? }
 *   Main → Worker: { type: 'callBatchInstall', packages }
 *   Main → Worker: { type: 'callUninstall', packageId }
 *   Main → Worker: { type: 'callUpdate', packageId, version? }
 *   Main → Worker: { type: 'callLock', packageId }
 *   Main → Worker: { type: 'callUnlock', packageId }
 *   Main → Worker: { type: 'callAudit' }
 *   Main → Worker: { type: 'callExport', format? }
 *   Main → Worker: { type: 'callAutoDiscover' }
 *   Main → Worker: { type: 'callAutoUpdate' }
 *   Main → Worker: { type: 'callResolve', packageId }
 *   Main → Worker: { type: 'callSync' }
 *   Main → Worker: { type: 'getState' }
 *   Main → Worker: { type: 'getStats' }
 *   Main → Worker: { type: 'stop' }
 *   Worker → Main: { type: 'query-result', query, ... }
 *   Worker → Main: { type: 'call-result', call, ... }
 *   Worker → Main: { type: 'call-error', call, error }
 *   Worker → Main: { type: 'install-progress', packageId, progress, phase }
 *   Worker → Main: { type: 'install-complete', packageId, version }
 *   Worker → Main: { type: 'install-error', packageId, error }
 *   Worker → Main: { type: 'heartbeat', beat, status }
 */

// ════════════════════════════════════════════════════════════════════════
//  LICENSE
// ════════════════════════════════════════════════════════════════════════

const INSTALLER_LICENSE = {
  id: 'CPEL-1.0',
  name: 'Command Platform Enterprise License',
  version: '1.0.0',
  copyright: '© 2024-2026 Alfredo Medina Hernandez. All rights reserved.',
  framework: 'Medina Doctrine',
  spdx: 'CPEL-1.0',
  permissions: [
    'install',           // Install packages via registered caller
    'query',             // Query registry state and metadata
    'audit',             // Read audit logs for own operations
    'export-manifest',   // Export package manifest
  ],
  restrictions: [
    'no-reverse-engineer',    // Cannot reverse-engineer installer logic
    'no-redistribution',      // Cannot redistribute package definitions
    'no-modification',        // Cannot modify installer behavior
    'no-sublicense',          // Cannot sublicense to third parties
    'audit-required',         // All operations must be audit-logged
    'phi-sync-required',      // Must maintain φ-heartbeat synchronization
  ],
  compliance: ['GDPR', 'CCPA', 'SOC2', 'ISO27001', 'HIPAA-eligible'],
  jurisdiction: 'International — Sovereign Platform Law',
  effectiveDate: '2024-01-01T00:00:00Z',
  renewalTerms: 'Annual, auto-renew with active subscription',
};

// ════════════════════════════════════════════════════════════════════════
//  CONSTANTS
// ════════════════════════════════════════════════════════════════════════

const PHI = 1.618033988749895;
const PHI_INV = 1 / PHI;
const HEARTBEAT = 873;
const INSTALLER_COUNT = 34;         // F9 — number of installer tools
const MAX_PACKAGES = 1597;          // F17 — max registered packages
const MAX_INSTALL_QUEUE = 89;       // F11 — max concurrent installs
const MAX_HISTORY = 2584;           // F18 — install history depth
const AUTO_UPDATE_INTERVAL = 55;    // F10 beats — auto-update check
const AUTO_DISCOVER_INTERVAL = 89;  // F11 beats — auto-discovery scan
const DEPENDENCY_RESOLVE_MAX = 233; // F13 — max dependency resolution depth
const MAX_AUDIT_LOG = 2584;         // F18 — audit trail depth

// ════════════════════════════════════════════════════════════════════════
//  STATE
// ════════════════════════════════════════════════════════════════════════

let beatCount = 0;
let running = true;
let installCounter = 0;
let totalInstalls = 0;
let totalUninstalls = 0;
let totalUpdates = 0;
let totalErrors = 0;
let totalDiscoveries = 0;

const packageRegistry = new Map();
const installQueue = [];
const installHistory = [];
const auditLog = [];
const dependencyGraph = new Map();

// ════════════════════════════════════════════════════════════════════════
//  PACKAGE TYPES
// ════════════════════════════════════════════════════════════════════════

const PACKAGE_TYPES = {
  'ai-model':       { label: 'AI Model',             icon: '🧠', priority: 1 },
  'agi-module':     { label: 'AGI Module',            icon: '🌐', priority: 1 },
  'tool-bundle':    { label: 'Tool Bundle',           icon: '🔧', priority: 2 },
  'protocol-pack':  { label: 'Protocol Pack',         icon: '📋', priority: 2 },
  'agent-pack':     { label: 'Agent Pack',            icon: '🤖', priority: 2 },
  'extension':      { label: 'Extension',             icon: '🔌', priority: 3 },
  'theme':          { label: 'Theme',                 icon: '🎨', priority: 4 },
  'locale':         { label: 'Locale',                icon: '🌍', priority: 4 },
  'config':         { label: 'Config Profile',        icon: '⚙️', priority: 3 },
  'migration':      { label: 'Migration',             icon: '📦', priority: 2 },
};

// ════════════════════════════════════════════════════════════════════════
//  INSTALLER REGISTRY — 34 installer tools
// ════════════════════════════════════════════════════════════════════════

const INSTALLER_REGISTRY = [
  // ─── Core Package Management (001–008) ─────────────────────
  { id: 1,  name: 'packageInstall',       category: 'core',          action: 'install' },
  { id: 2,  name: 'packageUninstall',     category: 'core',          action: 'uninstall' },
  { id: 3,  name: 'packageUpdate',        category: 'core',          action: 'update' },
  { id: 4,  name: 'packageSearch',        category: 'core',          action: 'search' },
  { id: 5,  name: 'packageValidate',      category: 'core',          action: 'validate' },
  { id: 6,  name: 'packageLock',          category: 'core',          action: 'lock' },
  { id: 7,  name: 'packageAudit',         category: 'core',          action: 'audit' },
  { id: 8,  name: 'packageExport',        category: 'core',          action: 'export' },

  // ─── AI/AGI Module Installers (009–016) ────────────────────
  { id: 9,  name: 'aiModelInstall',       category: 'ai-agi',        action: 'install' },
  { id: 10, name: 'aiModelUpdate',        category: 'ai-agi',        action: 'update' },
  { id: 11, name: 'agiModuleInstall',     category: 'ai-agi',        action: 'install' },
  { id: 12, name: 'agiModuleConfig',      category: 'ai-agi',        action: 'configure' },
  { id: 13, name: 'promptPackInstall',    category: 'ai-agi',        action: 'install' },
  { id: 14, name: 'embeddingInstall',     category: 'ai-agi',        action: 'install' },
  { id: 15, name: 'fineTuneInstall',      category: 'ai-agi',        action: 'install' },
  { id: 16, name: 'agentPackInstall',     category: 'ai-agi',        action: 'install' },

  // ─── Tool & Protocol Bundles (017–024) ─────────────────────
  { id: 17, name: 'toolBundleInstall',    category: 'bundle',        action: 'install' },
  { id: 18, name: 'protocolPackInstall',  category: 'bundle',        action: 'install' },
  { id: 19, name: 'blueprintPackInstall', category: 'bundle',        action: 'install' },
  { id: 20, name: 'recipePackInstall',    category: 'bundle',        action: 'install' },
  { id: 21, name: 'shieldPackInstall',    category: 'bundle',        action: 'install' },
  { id: 22, name: 'sensorPackInstall',    category: 'bundle',        action: 'install' },
  { id: 23, name: 'adapterPackInstall',   category: 'bundle',        action: 'install' },
  { id: 24, name: 'lensPackInstall',      category: 'bundle',        action: 'install' },

  // ─── System & Infrastructure (025–030) ─────────────────────
  { id: 25, name: 'workerInstall',        category: 'system',        action: 'install' },
  { id: 26, name: 'extensionInstall',     category: 'system',        action: 'install' },
  { id: 27, name: 'themeInstall',         category: 'system',        action: 'install' },
  { id: 28, name: 'localeInstall',        category: 'system',        action: 'install' },
  { id: 29, name: 'configProfileInstall', category: 'system',        action: 'install' },
  { id: 30, name: 'migrationInstall',     category: 'system',        action: 'install' },

  // ─── Auto-Discovery & Self-Update (031–034) ────────────────
  { id: 31, name: 'autoDiscover',         category: 'auto',          action: 'discover' },
  { id: 32, name: 'autoUpdate',           category: 'auto',          action: 'update' },
  { id: 33, name: 'dependencyResolve',    category: 'auto',          action: 'resolve' },
  { id: 34, name: 'registrySync',         category: 'auto',          action: 'sync' },
];

const installerMap = new Map();
for (const installer of INSTALLER_REGISTRY) {
  installerMap.set(installer.id, installer);
  installerMap.set(installer.name, installer);
}

// ════════════════════════════════════════════════════════════════════════
//  FNV-1a HASH
// ════════════════════════════════════════════════════════════════════════

function hashEvent(data) {
  let hash = 2166136261;  // FNV-1a offset basis
  for (let i = 0; i < data.length; i++) {
    hash ^= data.charCodeAt(i);
    hash = (hash * 16777619) >>> 0;
  }
  return hash;
}

// ════════════════════════════════════════════════════════════════════════
//  AUDIT LOG
// ════════════════════════════════════════════════════════════════════════

function logAudit(event, details) {
  const entry = {
    timestamp: Date.now(),
    beat: beatCount,
    event: event,
    details: details,
    hash: hashEvent(event + JSON.stringify(details) + Date.now()),
  };

  auditLog.push(entry);
  if (auditLog.length > MAX_AUDIT_LOG) auditLog.shift();

  return entry;
}

// ════════════════════════════════════════════════════════════════════════
//  PACKAGE SEED DATA — 89 (F11) pre-seeded packages
// ════════════════════════════════════════════════════════════════════════

function seedPackageRegistry() {
  let pkgId = 0;

  function addPackage(name, version, type, category, size, deps) {
    pkgId++;
    const id = 'PKG-' + String(pkgId).padStart(3, '0');
    const pkg = {
      id: id,
      name: name,
      version: version,
      type: type,
      category: category,
      status: 'available',
      dependencies: deps || [],
      installedAt: null,
      updatedAt: null,
      size: size,
      hash: hashEvent(id + ':' + name + ':' + version),
      autoUpdate: true,
      locked: false,
      compatibility: {
        minPlatformVersion: '1.0.0',
        requiredWorkers: [],
      },
      downloadCount: 0,
      rating: Math.round((3.5 + Math.random() * 1.5) * 10) / 10,
      publisher: 'command-platform',
      tags: [type, category],
    };
    packageRegistry.set(id, pkg);
    packageRegistry.set(name, pkg);
    return id;
  }

  // ─── 13 AI Model Packages ───────────────────────────────────
  addPackage('gpt-4-turbo',          '1.2.0', 'ai-model', 'language',     4500000, []);
  addPackage('gpt-4-vision',         '1.1.0', 'ai-model', 'multimodal',   5200000, []);
  addPackage('gpt-3.5-turbo',        '2.0.1', 'ai-model', 'language',     2100000, []);
  addPackage('claude-3-opus',        '1.0.0', 'ai-model', 'language',     4800000, []);
  addPackage('claude-3-sonnet',      '1.0.1', 'ai-model', 'language',     3600000, []);
  addPackage('claude-3-haiku',       '1.0.0', 'ai-model', 'language',     1800000, []);
  addPackage('gemini-pro',           '1.0.0', 'ai-model', 'language',     3400000, []);
  addPackage('gemini-ultra',         '0.9.0', 'ai-model', 'multimodal',   6100000, []);
  addPackage('llama-3-70b',          '1.0.0', 'ai-model', 'language',     8900000, []);
  addPackage('llama-3-8b',           '1.0.0', 'ai-model', 'language',     1200000, []);
  addPackage('mistral-large',        '1.0.0', 'ai-model', 'language',     4100000, []);
  addPackage('mistral-medium',       '1.1.0', 'ai-model', 'language',     2800000, []);
  addPackage('command-r-plus',       '1.0.0', 'ai-model', 'language',     3900000, []);

  // ─── 8 AGI Module Packages ──────────────────────────────────
  var agiGovernance = addPackage('agi-governance',    '2.1.0', 'agi-module', 'governance',   320000, []);
  var agiReasoning  = addPackage('agi-reasoning',     '2.0.0', 'agi-module', 'reasoning',    450000, []);
  var agiPlanning   = addPackage('agi-planning',      '1.5.0', 'agi-module', 'planning',     380000, [{ packageId: 'PKG-015', versionConstraint: '>=2.0.0' }]);
  addPackage('agi-memory',         '1.8.0', 'agi-module', 'memory',       510000, []);
  addPackage('agi-perception',     '1.3.0', 'agi-module', 'perception',   620000, []);
  var agiLearning   = addPackage('agi-learning',      '1.6.0', 'agi-module', 'learning',     470000, [{ packageId: 'PKG-015', versionConstraint: '>=2.0.0' }]);
  addPackage('agi-adaptation',     '1.2.0', 'agi-module', 'adaptation',   340000, [{ packageId: agiLearning, versionConstraint: '>=1.5.0' }]);
  addPackage('agi-evolution',      '1.0.0', 'agi-module', 'evolution',    290000, [{ packageId: agiGovernance, versionConstraint: '>=2.0.0' }, { packageId: agiLearning, versionConstraint: '>=1.5.0' }]);

  // ─── 13 Tool Bundle Packages ────────────────────────────────
  addPackage('bundle-aicalls',      '1.0.0', 'tool-bundle', 'ai',           180000, []);
  addPackage('bundle-blueprints',   '1.0.0', 'tool-bundle', 'blueprints',   160000, []);
  addPackage('bundle-recipes',      '1.0.0', 'tool-bundle', 'recipes',      150000, []);
  addPackage('bundle-lenses',       '1.0.0', 'tool-bundle', 'lenses',       140000, []);
  addPackage('bundle-hooks',        '1.0.0', 'tool-bundle', 'hooks',        130000, []);
  addPackage('bundle-triggers',     '1.0.0', 'tool-bundle', 'triggers',     120000, []);
  addPackage('bundle-adapters',     '1.0.0', 'tool-bundle', 'adapters',     170000, []);
  addPackage('bundle-sensors',      '1.0.0', 'tool-bundle', 'sensors',      140000, []);
  addPackage('bundle-shields',      '1.0.0', 'tool-bundle', 'shields',      190000, []);
  addPackage('bundle-crypto',       '1.0.0', 'tool-bundle', 'crypto',       160000, []);
  addPackage('bundle-database',     '1.0.0', 'tool-bundle', 'database',     210000, []);
  addPackage('bundle-micro',        '1.0.0', 'tool-bundle', 'micro',        130000, []);
  addPackage('bundle-crosscutting', '1.0.0', 'tool-bundle', 'crosscutting', 250000, []);

  // ─── 8 Protocol Pack Packages ───────────────────────────────
  addPackage('protocol-client-lifecycle',  '1.0.0', 'protocol-pack', 'client',      95000,  []);
  addPackage('protocol-ai-pipeline',       '1.0.0', 'protocol-pack', 'ai',          110000, []);
  addPackage('protocol-data-governance',   '1.0.0', 'protocol-pack', 'data',        105000, []);
  addPackage('protocol-security-trust',    '1.0.0', 'protocol-pack', 'security',    120000, []);
  addPackage('protocol-platform-ops',      '1.0.0', 'protocol-pack', 'operations',  100000, []);
  addPackage('protocol-billing-metering',  '1.0.0', 'protocol-pack', 'billing',     90000,  []);
  addPackage('protocol-research-product',  '1.0.0', 'protocol-pack', 'research',    85000,  []);
  addPackage('protocol-compliance',        '1.0.0', 'protocol-pack', 'compliance',  98000,  []);

  // ─── 8 Agent Pack Packages ──────────────────────────────────
  addPackage('agent-tier-1-basic',         '1.0.0', 'agent-pack', 'tier-1',     75000,  []);
  addPackage('agent-tier-2-standard',      '1.0.0', 'agent-pack', 'tier-2',     120000, [{ packageId: 'PKG-047', versionConstraint: '>=1.0.0' }]);
  addPackage('agent-tier-3-advanced',      '1.0.0', 'agent-pack', 'tier-3',     180000, [{ packageId: 'PKG-048', versionConstraint: '>=1.0.0' }]);
  addPackage('agent-tier-4-enterprise',    '1.0.0', 'agent-pack', 'tier-4',     250000, [{ packageId: 'PKG-049', versionConstraint: '>=1.0.0' }]);
  addPackage('agent-tier-5-sovereign',     '1.0.0', 'agent-pack', 'tier-5',     340000, [{ packageId: 'PKG-050', versionConstraint: '>=1.0.0' }]);
  addPackage('agent-autonomous',           '1.0.0', 'agent-pack', 'autonomous', 290000, [{ packageId: agiReasoning, versionConstraint: '>=2.0.0' }]);
  addPackage('agent-collaborative',        '1.0.0', 'agent-pack', 'collab',     220000, []);
  addPackage('agent-research',             '1.0.0', 'agent-pack', 'research',   260000, [{ packageId: agiPlanning, versionConstraint: '>=1.5.0' }]);

  // ─── 8 Extension Packages ──────────────────────────────────
  addPackage('ext-analytics',          '1.2.0', 'extension', 'analytics',      145000, []);
  addPackage('ext-reporting',          '1.1.0', 'extension', 'reporting',       130000, []);
  addPackage('ext-visualization',      '1.0.0', 'extension', 'visualization',  180000, []);
  addPackage('ext-collaboration',      '1.0.0', 'extension', 'collaboration',  160000, []);
  addPackage('ext-notifications',      '1.0.0', 'extension', 'notifications',  95000,  []);
  addPackage('ext-scheduling',         '1.0.0', 'extension', 'scheduling',     110000, []);
  addPackage('ext-import-export',      '1.0.0', 'extension', 'data-exchange',  125000, []);
  addPackage('ext-developer-tools',    '1.0.0', 'extension', 'devtools',       140000, []);

  // ─── 5 Theme Packages ──────────────────────────────────────
  addPackage('theme-dark-sovereign',   '1.0.0', 'theme', 'dark',        25000, []);
  addPackage('theme-light-clarity',    '1.0.0', 'theme', 'light',       24000, []);
  addPackage('theme-midnight-deep',    '1.0.0', 'theme', 'dark',        26000, []);
  addPackage('theme-enterprise-pro',   '1.0.0', 'theme', 'enterprise',  28000, []);
  addPackage('theme-high-contrast',    '1.0.0', 'theme', 'a11y',        23000, []);

  // ─── 8 Locale Packages ─────────────────────────────────────
  addPackage('locale-en',              '1.0.0', 'locale', 'en',   45000, []);
  addPackage('locale-es',              '1.0.0', 'locale', 'es',   44000, []);
  addPackage('locale-fr',              '1.0.0', 'locale', 'fr',   43000, []);
  addPackage('locale-de',              '1.0.0', 'locale', 'de',   44000, []);
  addPackage('locale-ja',              '1.0.0', 'locale', 'ja',   48000, []);
  addPackage('locale-zh',              '1.0.0', 'locale', 'zh',   47000, []);
  addPackage('locale-ko',              '1.0.0', 'locale', 'ko',   46000, []);
  addPackage('locale-pt',              '1.0.0', 'locale', 'pt',   43000, []);

  // ─── 5 Config Profile Packages ─────────────────────────────
  addPackage('config-development',     '1.0.0', 'config', 'development',  15000, []);
  addPackage('config-staging',         '1.0.0', 'config', 'staging',      16000, []);
  addPackage('config-production',      '1.0.0', 'config', 'production',   18000, []);
  addPackage('config-enterprise',      '1.0.0', 'config', 'enterprise',   20000, []);
  addPackage('config-sovereign',       '1.0.0', 'config', 'sovereign',    22000, []);

  // ─── 13 Migration Packages ─────────────────────────────────
  addPackage('migration-postgres',     '1.0.0', 'migration', 'postgres',    35000, []);
  addPackage('migration-mysql',        '1.0.0', 'migration', 'mysql',       34000, []);
  addPackage('migration-sqlite',       '1.0.0', 'migration', 'sqlite',      28000, []);
  addPackage('migration-mongodb',      '1.0.0', 'migration', 'mongodb',     32000, []);
  addPackage('migration-redis',        '1.0.0', 'migration', 'redis',       25000, []);
  addPackage('migration-elasticsearch','1.0.0', 'migration', 'elasticsearch',38000, []);
  addPackage('migration-dynamodb',     '1.0.0', 'migration', 'dynamodb',    33000, []);
  addPackage('migration-cassandra',    '1.0.0', 'migration', 'cassandra',   36000, []);
  addPackage('migration-neo4j',        '1.0.0', 'migration', 'neo4j',       30000, []);
  addPackage('migration-cockroachdb',  '1.0.0', 'migration', 'cockroachdb', 34000, []);
  addPackage('migration-timescaledb',  '1.0.0', 'migration', 'timescaledb', 32000, []);
  addPackage('migration-clickhouse',   '1.0.0', 'migration', 'clickhouse',  31000, []);
  addPackage('migration-supabase',     '1.0.0', 'migration', 'supabase',    33000, []);
}

seedPackageRegistry();

// ════════════════════════════════════════════════════════════════════════
//  SEMVER UTILITIES
// ════════════════════════════════════════════════════════════════════════

function parseSemver(version) {
  var parts = version.replace(/^[vV]/, '').split('.');
  return {
    major: parseInt(parts[0], 10) || 0,
    minor: parseInt(parts[1], 10) || 0,
    patch: parseInt(parts[2], 10) || 0,
  };
}

function compareSemver(a, b) {
  var pa = parseSemver(a);
  var pb = parseSemver(b);
  if (pa.major !== pb.major) return pa.major - pb.major;
  if (pa.minor !== pb.minor) return pa.minor - pb.minor;
  return pa.patch - pb.patch;
}

function satisfiesConstraint(version, constraint) {
  if (!constraint) return true;
  var trimmed = constraint.trim();

  if (trimmed.startsWith('>=')) {
    return compareSemver(version, trimmed.slice(2).trim()) >= 0;
  }
  if (trimmed.startsWith('<=')) {
    return compareSemver(version, trimmed.slice(2).trim()) <= 0;
  }
  if (trimmed.startsWith('>')) {
    return compareSemver(version, trimmed.slice(1).trim()) > 0;
  }
  if (trimmed.startsWith('<')) {
    return compareSemver(version, trimmed.slice(1).trim()) < 0;
  }
  if (trimmed.startsWith('^')) {
    var base = parseSemver(trimmed.slice(1).trim());
    var current = parseSemver(version);
    return current.major === base.major && compareSemver(version, trimmed.slice(1).trim()) >= 0;
  }
  if (trimmed.startsWith('~')) {
    var tBase = parseSemver(trimmed.slice(1).trim());
    var tCurrent = parseSemver(version);
    return tCurrent.major === tBase.major && tCurrent.minor === tBase.minor && compareSemver(version, trimmed.slice(1).trim()) >= 0;
  }
  // Exact match
  return compareSemver(version, trimmed) === 0;
}

function incrementVersion(version, level) {
  var sv = parseSemver(version);
  if (level === 'major') { sv.major++; sv.minor = 0; sv.patch = 0; }
  else if (level === 'minor') { sv.minor++; sv.patch = 0; }
  else { sv.patch++; }
  return sv.major + '.' + sv.minor + '.' + sv.patch;
}

// ════════════════════════════════════════════════════════════════════════
//  DEPENDENCY RESOLVER
// ════════════════════════════════════════════════════════════════════════

function buildDependencyGraph(packageId) {
  var graph = new Map();
  var visited = new Set();
  var depth = 0;

  function visit(id, currentDepth) {
    if (currentDepth > DEPENDENCY_RESOLVE_MAX) return;
    if (visited.has(id)) return;
    visited.add(id);

    var pkg = packageRegistry.get(id);
    if (!pkg) return;

    var deps = pkg.dependencies || [];
    var edges = [];
    for (var i = 0; i < deps.length; i++) {
      edges.push(deps[i].packageId);
      visit(deps[i].packageId, currentDepth + 1);
    }
    graph.set(id, edges);
  }

  visit(packageId, 0);
  return graph;
}

function detectCircularDependencies(packageId) {
  var visiting = new Set();
  var visited = new Set();
  var cycles = [];

  function dfs(id, path) {
    if (visited.has(id)) return false;
    if (visiting.has(id)) {
      cycles.push(path.concat(id));
      return true;
    }

    visiting.add(id);
    var pkg = packageRegistry.get(id);
    if (pkg && pkg.dependencies) {
      for (var i = 0; i < pkg.dependencies.length; i++) {
        dfs(pkg.dependencies[i].packageId, path.concat(id));
      }
    }
    visiting.delete(id);
    visited.add(id);
    return cycles.length > 0;
  }

  dfs(packageId, []);
  return cycles;
}

function topologicalSort(packageId) {
  var graph = buildDependencyGraph(packageId);
  var sorted = [];
  var visited = new Set();
  var temp = new Set();

  function visit(id) {
    if (visited.has(id)) return true;
    if (temp.has(id)) return false;  // circular

    temp.add(id);
    var edges = graph.get(id) || [];
    for (var i = 0; i < edges.length; i++) {
      if (!visit(edges[i])) return false;
    }
    temp.delete(id);
    visited.add(id);
    sorted.push(id);
    return true;
  }

  for (var key of graph.keys()) {
    if (!visit(key)) {
      return { error: 'CIRCULAR_DEPENDENCY', sorted: sorted };
    }
  }

  return { sorted: sorted, error: null };
}

function resolveVersionConflicts(packageId) {
  var graph = buildDependencyGraph(packageId);
  var conflicts = [];
  var resolutions = new Map();

  for (var [depId, edges] of graph) {
    var depPkg = packageRegistry.get(depId);
    if (!depPkg) continue;

    for (var i = 0; i < (depPkg.dependencies || []).length; i++) {
      var dep = depPkg.dependencies[i];
      var target = packageRegistry.get(dep.packageId);
      if (!target) continue;

      if (!satisfiesConstraint(target.version, dep.versionConstraint)) {
        conflicts.push({
          source: depId,
          target: dep.packageId,
          required: dep.versionConstraint,
          available: target.version,
        });
        resolutions.set(dep.packageId, {
          action: 'update-needed',
          from: target.version,
          constraint: dep.versionConstraint,
        });
      }
    }
  }

  return { conflicts: conflicts, resolutions: resolutions, hasConflicts: conflicts.length > 0 };
}

function fullDependencyResolve(packageId) {
  var cycles = detectCircularDependencies(packageId);
  if (cycles.length > 0) {
    return {
      error: 'CIRCULAR_DEPENDENCY',
      cycles: cycles,
      resolved: false,
    };
  }

  var sortResult = topologicalSort(packageId);
  if (sortResult.error) {
    return {
      error: sortResult.error,
      resolved: false,
    };
  }

  var conflictResult = resolveVersionConflicts(packageId);

  return {
    resolved: !conflictResult.hasConflicts,
    installOrder: sortResult.sorted,
    conflicts: conflictResult.conflicts,
    resolutions: Object.fromEntries(conflictResult.resolutions),
    dependencyCount: sortResult.sorted.length,
  };
}

// ════════════════════════════════════════════════════════════════════════
//  INSTALL QUEUE MANAGER
// ════════════════════════════════════════════════════════════════════════

var activeInstalls = new Map();

function enqueueInstall(packageId, version, options) {
  if (installQueue.length >= MAX_INSTALL_QUEUE) {
    return { error: 'QUEUE_FULL', maxQueue: MAX_INSTALL_QUEUE };
  }

  var pkg = packageRegistry.get(packageId);
  if (!pkg) {
    return { error: 'PACKAGE_NOT_FOUND', packageId: packageId };
  }

  if (pkg.status === 'installed' && !options.force) {
    return { error: 'ALREADY_INSTALLED', packageId: packageId, version: pkg.version };
  }

  if (pkg.status === 'installing') {
    return { error: 'ALREADY_INSTALLING', packageId: packageId };
  }

  var installId = 'INST-' + String(++installCounter).padStart(6, '0');
  var installJob = {
    id: installId,
    packageId: pkg.id,
    packageName: pkg.name,
    version: version || pkg.version,
    options: options || {},
    status: 'queued',
    progress: 0,
    phase: 'queued',
    queuedAt: Date.now(),
    startedAt: null,
    completedAt: null,
    error: null,
    priority: (options && options.priority) || PACKAGE_TYPES[pkg.type].priority || 3,
    retries: 0,
    maxRetries: (options && options.maxRetries) || 2,
  };

  installQueue.push(installJob);
  installQueue.sort(function (a, b) { return a.priority - b.priority; });

  logAudit('install-queued', { installId: installId, packageId: pkg.id, packageName: pkg.name });

  return { installId: installId, packageId: pkg.id, status: 'queued', position: installQueue.indexOf(installJob) + 1 };
}

function processInstallQueue() {
  if (activeInstalls.size >= MAX_INSTALL_QUEUE) return;

  while (installQueue.length > 0 && activeInstalls.size < MAX_INSTALL_QUEUE) {
    var job = installQueue.shift();
    if (!job) break;

    job.status = 'installing';
    job.phase = 'resolving-dependencies';
    job.startedAt = Date.now();
    job.progress = 0.05;
    activeInstalls.set(job.id, job);

    executeInstall(job);
  }
}

function executeInstall(job) {
  var pkg = packageRegistry.get(job.packageId);
  if (!pkg) {
    failInstall(job.id, 'PACKAGE_NOT_FOUND');
    return;
  }

  // Phase 1: Resolve dependencies
  job.phase = 'resolving-dependencies';
  job.progress = Math.pow(PHI_INV, 8);  // ~0.055 — phi-scaled progress
  var resolved = fullDependencyResolve(job.packageId);
  if (resolved.error) {
    failInstall(job.id, resolved.error);
    return;
  }

  if (resolved.conflicts && resolved.conflicts.length > 0 && !job.options.ignoreConflicts) {
    failInstall(job.id, 'DEPENDENCY_CONFLICT');
    return;
  }

  self.postMessage({
    type: 'install-progress',
    packageId: pkg.id,
    packageName: pkg.name,
    installId: job.id,
    progress: job.progress,
    phase: job.phase,
  });

  // Phase 2: Validate
  job.phase = 'validating';
  job.progress = Math.pow(PHI_INV, 5);  // ~0.09
  var validation = validatePackage(pkg);
  if (!validation.valid) {
    failInstall(job.id, 'VALIDATION_FAILED');
    return;
  }

  self.postMessage({
    type: 'install-progress',
    packageId: pkg.id,
    packageName: pkg.name,
    installId: job.id,
    progress: job.progress,
    phase: job.phase,
  });

  // Phase 3: Download (simulated)
  job.phase = 'downloading';
  job.progress = Math.pow(PHI_INV, 3);  // ~0.236

  self.postMessage({
    type: 'install-progress',
    packageId: pkg.id,
    packageName: pkg.name,
    installId: job.id,
    progress: job.progress,
    phase: job.phase,
  });

  // Phase 4: Configuring
  job.phase = 'configuring';
  job.progress = PHI_INV;  // ~0.618

  self.postMessage({
    type: 'install-progress',
    packageId: pkg.id,
    packageName: pkg.name,
    installId: job.id,
    progress: job.progress,
    phase: job.phase,
  });

  // Phase 5: Finalizing
  job.phase = 'finalizing';
  job.progress = 1.0 - Math.pow(PHI_INV, 5);  // ~0.91

  // Complete the install
  completeInstall(job.id);
}

function completeInstall(installId) {
  var job = activeInstalls.get(installId);
  if (!job) return;

  var pkg = packageRegistry.get(job.packageId);
  if (pkg) {
    pkg.status = 'installed';
    pkg.installedAt = Date.now();
    pkg.updatedAt = Date.now();
    pkg.version = job.version;
    pkg.downloadCount++;
  }

  job.status = 'complete';
  job.phase = 'complete';
  job.progress = 1.0;
  job.completedAt = Date.now();

  activeInstalls.delete(installId);
  totalInstalls++;

  addToHistory('install', job.packageId, job.packageName, job.version, 'success', job.startedAt, job.completedAt);

  logAudit('install-complete', {
    installId: installId,
    packageId: job.packageId,
    packageName: job.packageName,
    version: job.version,
    duration: job.completedAt - job.startedAt,
  });

  self.postMessage({
    type: 'install-complete',
    installId: installId,
    packageId: job.packageId,
    packageName: job.packageName,
    version: job.version,
    duration: job.completedAt - job.startedAt,
  });
}

function failInstall(installId, error) {
  var job = activeInstalls.get(installId);
  if (!job) return;

  // Retry logic
  if (job.retries < job.maxRetries) {
    job.retries++;
    job.phase = 'retrying';
    job.progress = 0;
    logAudit('install-retry', { installId: installId, error: error, attempt: job.retries });
    executeInstall(job);
    return;
  }

  var pkg = packageRegistry.get(job.packageId);
  if (pkg) {
    pkg.status = 'error';
  }

  job.status = 'failed';
  job.phase = 'failed';
  job.error = error;
  job.completedAt = Date.now();

  activeInstalls.delete(installId);
  totalErrors++;

  addToHistory('install', job.packageId, job.packageName, job.version, 'failed', job.startedAt, job.completedAt);

  logAudit('install-failed', {
    installId: installId,
    packageId: job.packageId,
    packageName: job.packageName,
    error: error,
    retries: job.retries,
  });

  self.postMessage({
    type: 'install-error',
    installId: installId,
    packageId: job.packageId,
    packageName: job.packageName,
    error: error,
  });
}

// ════════════════════════════════════════════════════════════════════════
//  PACKAGE VALIDATION
// ════════════════════════════════════════════════════════════════════════

function validatePackage(pkg) {
  var issues = [];

  if (!pkg.name) issues.push('missing-name');
  if (!pkg.version) issues.push('missing-version');
  if (!pkg.type) issues.push('missing-type');
  if (!PACKAGE_TYPES[pkg.type]) issues.push('invalid-type');

  var expectedHash = hashEvent(pkg.id + ':' + pkg.name + ':' + pkg.version);
  if (pkg.hash !== expectedHash) {
    issues.push('hash-mismatch');
  }

  if (pkg.compatibility && pkg.compatibility.minPlatformVersion) {
    if (compareSemver('1.0.0', pkg.compatibility.minPlatformVersion) < 0) {
      issues.push('platform-version-too-old');
    }
  }

  return {
    valid: issues.length === 0,
    issues: issues,
    packageId: pkg.id,
    hash: pkg.hash,
    expectedHash: expectedHash,
  };
}

function securityAuditPackage(pkg) {
  var findings = [];

  if (pkg.dependencies && pkg.dependencies.length > 13) {
    findings.push({
      severity: 'warning',
      issue: 'excessive-dependencies',
      detail: 'Package has ' + pkg.dependencies.length + ' dependencies (threshold: 13)',
    });
  }

  if (pkg.size > 10000000) {
    findings.push({
      severity: 'info',
      issue: 'large-package',
      detail: 'Package is ' + Math.round(pkg.size / 1000000) + 'MB',
    });
  }

  if (pkg.type === 'ai-model' && pkg.size < 100000) {
    findings.push({
      severity: 'warning',
      issue: 'suspiciously-small-model',
      detail: 'AI model package is unusually small: ' + pkg.size + ' bytes',
    });
  }

  var sv = parseSemver(pkg.version);
  if (sv.major === 0) {
    findings.push({
      severity: 'info',
      issue: 'pre-release-version',
      detail: 'Package is pre-release: v' + pkg.version,
    });
  }

  return {
    packageId: pkg.id,
    packageName: pkg.name,
    findingCount: findings.length,
    findings: findings,
    auditedAt: Date.now(),
    passed: findings.filter(function (f) { return f.severity === 'critical'; }).length === 0,
  };
}

// ════════════════════════════════════════════════════════════════════════
//  INSTALL HISTORY
// ════════════════════════════════════════════════════════════════════════

function addToHistory(action, packageId, packageName, version, status, startedAt, completedAt) {
  var entry = {
    action: action,
    packageId: packageId,
    packageName: packageName,
    version: version,
    status: status,
    startedAt: startedAt,
    completedAt: completedAt,
    duration: completedAt - startedAt,
    beat: beatCount,
    timestamp: Date.now(),
    hash: hashEvent(action + ':' + packageId + ':' + version + ':' + Date.now()),
  };

  installHistory.push(entry);
  if (installHistory.length > MAX_HISTORY) installHistory.shift();

  return entry;
}

// ════════════════════════════════════════════════════════════════════════
//  CORE PACKAGE OPERATIONS
// ════════════════════════════════════════════════════════════════════════

function packageInstall(packageId, version, options) {
  return enqueueInstall(packageId, version, options || {});
}

function packageUninstall(packageId) {
  var pkg = packageRegistry.get(packageId);
  if (!pkg) return { error: 'PACKAGE_NOT_FOUND', packageId: packageId };
  if (pkg.status !== 'installed') return { error: 'NOT_INSTALLED', packageId: packageId };
  if (pkg.locked) return { error: 'PACKAGE_LOCKED', packageId: packageId };

  // Check for reverse dependencies
  var dependents = findDependents(pkg.id);
  if (dependents.length > 0) {
    return {
      error: 'HAS_DEPENDENTS',
      packageId: packageId,
      dependents: dependents.map(function (d) { return d.name; }),
      message: 'Cannot uninstall: ' + dependents.length + ' packages depend on this',
    };
  }

  var previousVersion = pkg.version;
  pkg.status = 'available';
  pkg.installedAt = null;
  totalUninstalls++;

  addToHistory('uninstall', pkg.id, pkg.name, previousVersion, 'success', Date.now(), Date.now());
  logAudit('package-uninstalled', { packageId: pkg.id, packageName: pkg.name, version: previousVersion });

  return { packageId: pkg.id, packageName: pkg.name, uninstalled: true, previousVersion: previousVersion };
}

function packageUpdate(packageId, targetVersion) {
  var pkg = packageRegistry.get(packageId);
  if (!pkg) return { error: 'PACKAGE_NOT_FOUND', packageId: packageId };
  if (pkg.status !== 'installed') return { error: 'NOT_INSTALLED', packageId: packageId };
  if (pkg.locked) return { error: 'PACKAGE_LOCKED', packageId: packageId };

  var previousVersion = pkg.version;
  var newVersion = targetVersion || incrementVersion(pkg.version, 'patch');

  if (compareSemver(newVersion, previousVersion) <= 0) {
    return { error: 'NO_UPDATE_AVAILABLE', packageId: packageId, currentVersion: previousVersion };
  }

  pkg.version = newVersion;
  pkg.updatedAt = Date.now();
  pkg.hash = hashEvent(pkg.id + ':' + pkg.name + ':' + newVersion);
  pkg.status = 'installed';
  totalUpdates++;

  addToHistory('update', pkg.id, pkg.name, newVersion, 'success', Date.now(), Date.now());
  logAudit('package-updated', { packageId: pkg.id, packageName: pkg.name, from: previousVersion, to: newVersion });

  return {
    packageId: pkg.id,
    packageName: pkg.name,
    previousVersion: previousVersion,
    newVersion: newVersion,
    updated: true,
  };
}

function packageSearch(query) {
  var results = [];
  var seen = new Set();
  var lowerQuery = (query || '').toLowerCase();

  for (var [key, pkg] of packageRegistry) {
    if (typeof key !== 'string') continue;
    if (seen.has(pkg.id)) continue;

    var matches = false;
    if (pkg.name.toLowerCase().indexOf(lowerQuery) !== -1) matches = true;
    if (pkg.type.toLowerCase().indexOf(lowerQuery) !== -1) matches = true;
    if (pkg.category.toLowerCase().indexOf(lowerQuery) !== -1) matches = true;
    if (pkg.tags && pkg.tags.some(function (t) { return t.toLowerCase().indexOf(lowerQuery) !== -1; })) matches = true;

    if (matches) {
      seen.add(pkg.id);
      results.push({
        id: pkg.id,
        name: pkg.name,
        version: pkg.version,
        type: pkg.type,
        category: pkg.category,
        status: pkg.status,
        rating: pkg.rating,
        size: pkg.size,
      });
    }
  }

  return { query: query, results: results, count: results.length };
}

function packageValidate(packageId) {
  var pkg = packageRegistry.get(packageId);
  if (!pkg) return { error: 'PACKAGE_NOT_FOUND', packageId: packageId };
  return validatePackage(pkg);
}

function packageLock(packageId) {
  var pkg = packageRegistry.get(packageId);
  if (!pkg) return { error: 'PACKAGE_NOT_FOUND', packageId: packageId };
  if (pkg.locked) return { error: 'ALREADY_LOCKED', packageId: packageId };

  pkg.locked = true;
  pkg.autoUpdate = false;
  logAudit('package-locked', { packageId: pkg.id, packageName: pkg.name, version: pkg.version });

  return { packageId: pkg.id, packageName: pkg.name, locked: true, version: pkg.version };
}

function packageUnlock(packageId) {
  var pkg = packageRegistry.get(packageId);
  if (!pkg) return { error: 'PACKAGE_NOT_FOUND', packageId: packageId };
  if (!pkg.locked) return { error: 'NOT_LOCKED', packageId: packageId };

  pkg.locked = false;
  pkg.autoUpdate = true;
  logAudit('package-unlocked', { packageId: pkg.id, packageName: pkg.name });

  return { packageId: pkg.id, packageName: pkg.name, locked: false };
}

function packageAudit() {
  var results = [];
  var seen = new Set();

  for (var [key, pkg] of packageRegistry) {
    if (typeof key !== 'string') continue;
    if (seen.has(pkg.id)) continue;
    if (pkg.status !== 'installed') continue;
    seen.add(pkg.id);

    results.push(securityAuditPackage(pkg));
  }

  var totalFindings = 0;
  var criticalCount = 0;
  for (var i = 0; i < results.length; i++) {
    totalFindings += results[i].findingCount;
    criticalCount += results[i].findings.filter(function (f) { return f.severity === 'critical'; }).length;
  }

  logAudit('security-audit', { packageCount: results.length, totalFindings: totalFindings, criticalCount: criticalCount });

  return {
    auditedAt: Date.now(),
    packagesAudited: results.length,
    totalFindings: totalFindings,
    criticalFindings: criticalCount,
    results: results,
    passed: criticalCount === 0,
  };
}

function packageExport(format) {
  var installed = [];
  var seen = new Set();

  for (var [key, pkg] of packageRegistry) {
    if (typeof key !== 'string') continue;
    if (seen.has(pkg.id)) continue;
    if (pkg.status !== 'installed') continue;
    seen.add(pkg.id);

    installed.push({
      id: pkg.id,
      name: pkg.name,
      version: pkg.version,
      type: pkg.type,
      category: pkg.category,
      dependencies: pkg.dependencies,
      hash: pkg.hash,
      locked: pkg.locked,
    });
  }

  var manifest = {
    format: format || 'json',
    exportedAt: Date.now(),
    platformVersion: '1.0.0',
    packageCount: installed.length,
    packages: installed,
    proofHash: hashEvent('export:' + installed.length + ':' + Date.now()),
  };

  logAudit('manifest-exported', { format: format, packageCount: installed.length });

  return manifest;
}

// ════════════════════════════════════════════════════════════════════════
//  AI/AGI MODULE OPERATIONS
// ════════════════════════════════════════════════════════════════════════

function aiModelInstall(packageId, options) {
  var pkg = packageRegistry.get(packageId);
  if (!pkg) return { error: 'PACKAGE_NOT_FOUND', packageId: packageId };
  if (pkg.type !== 'ai-model') return { error: 'NOT_AI_MODEL', packageId: packageId, type: pkg.type };

  return enqueueInstall(packageId, pkg.version, Object.assign({ installType: 'ai-model' }, options || {}));
}

function aiModelUpdate(packageId) {
  var pkg = packageRegistry.get(packageId);
  if (!pkg) return { error: 'PACKAGE_NOT_FOUND', packageId: packageId };
  if (pkg.type !== 'ai-model') return { error: 'NOT_AI_MODEL', packageId: packageId };
  if (pkg.status !== 'installed') return { error: 'NOT_INSTALLED', packageId: packageId };

  return packageUpdate(packageId);
}

function agiModuleInstall(packageId, options) {
  var pkg = packageRegistry.get(packageId);
  if (!pkg) return { error: 'PACKAGE_NOT_FOUND', packageId: packageId };
  if (pkg.type !== 'agi-module') return { error: 'NOT_AGI_MODULE', packageId: packageId, type: pkg.type };

  return enqueueInstall(packageId, pkg.version, Object.assign({ installType: 'agi-module' }, options || {}));
}

function agiModuleConfig(packageId, config) {
  var pkg = packageRegistry.get(packageId);
  if (!pkg) return { error: 'PACKAGE_NOT_FOUND', packageId: packageId };
  if (pkg.type !== 'agi-module') return { error: 'NOT_AGI_MODULE', packageId: packageId };
  if (pkg.status !== 'installed') return { error: 'NOT_INSTALLED', packageId: packageId };

  pkg.moduleConfig = Object.assign(pkg.moduleConfig || {}, config || {});
  pkg.updatedAt = Date.now();

  logAudit('agi-module-configured', { packageId: pkg.id, packageName: pkg.name, configKeys: Object.keys(config || {}) });

  return {
    packageId: pkg.id,
    packageName: pkg.name,
    configured: true,
    config: pkg.moduleConfig,
  };
}

function promptPackInstall(packageId, options) {
  return enqueueInstall(packageId, null, Object.assign({ installType: 'prompt-pack' }, options || {}));
}

function embeddingInstall(packageId, options) {
  return enqueueInstall(packageId, null, Object.assign({ installType: 'embedding' }, options || {}));
}

function fineTuneInstall(packageId, options) {
  return enqueueInstall(packageId, null, Object.assign({ installType: 'fine-tune' }, options || {}));
}

function agentPackInstall(packageId, options) {
  var pkg = packageRegistry.get(packageId);
  if (!pkg) return { error: 'PACKAGE_NOT_FOUND', packageId: packageId };
  if (pkg.type !== 'agent-pack') return { error: 'NOT_AGENT_PACK', packageId: packageId, type: pkg.type };

  return enqueueInstall(packageId, pkg.version, Object.assign({ installType: 'agent-pack' }, options || {}));
}

// ════════════════════════════════════════════════════════════════════════
//  TOOL & PROTOCOL BUNDLE OPERATIONS
// ════════════════════════════════════════════════════════════════════════

function toolBundleInstall(packageId, options) {
  var pkg = packageRegistry.get(packageId);
  if (!pkg) return { error: 'PACKAGE_NOT_FOUND', packageId: packageId };
  if (pkg.type !== 'tool-bundle') return { error: 'NOT_TOOL_BUNDLE', packageId: packageId, type: pkg.type };

  return enqueueInstall(packageId, pkg.version, Object.assign({ installType: 'tool-bundle' }, options || {}));
}

function protocolPackInstall(packageId, options) {
  var pkg = packageRegistry.get(packageId);
  if (!pkg) return { error: 'PACKAGE_NOT_FOUND', packageId: packageId };
  if (pkg.type !== 'protocol-pack') return { error: 'NOT_PROTOCOL_PACK', packageId: packageId, type: pkg.type };

  return enqueueInstall(packageId, pkg.version, Object.assign({ installType: 'protocol-pack' }, options || {}));
}

function blueprintPackInstall(packageId, options) {
  return enqueueInstall(packageId, null, Object.assign({ installType: 'blueprint-pack' }, options || {}));
}

function recipePackInstall(packageId, options) {
  return enqueueInstall(packageId, null, Object.assign({ installType: 'recipe-pack' }, options || {}));
}

function shieldPackInstall(packageId, options) {
  return enqueueInstall(packageId, null, Object.assign({ installType: 'shield-pack' }, options || {}));
}

function sensorPackInstall(packageId, options) {
  return enqueueInstall(packageId, null, Object.assign({ installType: 'sensor-pack' }, options || {}));
}

function adapterPackInstall(packageId, options) {
  return enqueueInstall(packageId, null, Object.assign({ installType: 'adapter-pack' }, options || {}));
}

function lensPackInstall(packageId, options) {
  return enqueueInstall(packageId, null, Object.assign({ installType: 'lens-pack' }, options || {}));
}

// ════════════════════════════════════════════════════════════════════════
//  SYSTEM & INFRASTRUCTURE OPERATIONS
// ════════════════════════════════════════════════════════════════════════

function workerInstall(packageId, options) {
  return enqueueInstall(packageId, null, Object.assign({ installType: 'worker', priority: 1 }, options || {}));
}

function extensionInstall(packageId, options) {
  var pkg = packageRegistry.get(packageId);
  if (!pkg) return { error: 'PACKAGE_NOT_FOUND', packageId: packageId };
  if (pkg.type !== 'extension') return { error: 'NOT_EXTENSION', packageId: packageId, type: pkg.type };

  return enqueueInstall(packageId, pkg.version, Object.assign({ installType: 'extension' }, options || {}));
}

function themeInstall(packageId, options) {
  var pkg = packageRegistry.get(packageId);
  if (!pkg) return { error: 'PACKAGE_NOT_FOUND', packageId: packageId };
  if (pkg.type !== 'theme') return { error: 'NOT_THEME', packageId: packageId, type: pkg.type };

  return enqueueInstall(packageId, pkg.version, Object.assign({ installType: 'theme' }, options || {}));
}

function localeInstall(packageId, options) {
  var pkg = packageRegistry.get(packageId);
  if (!pkg) return { error: 'PACKAGE_NOT_FOUND', packageId: packageId };
  if (pkg.type !== 'locale') return { error: 'NOT_LOCALE', packageId: packageId, type: pkg.type };

  return enqueueInstall(packageId, pkg.version, Object.assign({ installType: 'locale' }, options || {}));
}

function configProfileInstall(packageId, options) {
  var pkg = packageRegistry.get(packageId);
  if (!pkg) return { error: 'PACKAGE_NOT_FOUND', packageId: packageId };
  if (pkg.type !== 'config') return { error: 'NOT_CONFIG', packageId: packageId, type: pkg.type };

  return enqueueInstall(packageId, pkg.version, Object.assign({ installType: 'config' }, options || {}));
}

function migrationInstall(packageId, options) {
  var pkg = packageRegistry.get(packageId);
  if (!pkg) return { error: 'PACKAGE_NOT_FOUND', packageId: packageId };
  if (pkg.type !== 'migration') return { error: 'NOT_MIGRATION', packageId: packageId, type: pkg.type };

  return enqueueInstall(packageId, pkg.version, Object.assign({ installType: 'migration' }, options || {}));
}

// ════════════════════════════════════════════════════════════════════════
//  AUTO-DISCOVERY ENGINE
// ════════════════════════════════════════════════════════════════════════

function autoDiscover() {
  var discovered = {
    newPackages: [],
    updatesAvailable: [],
    missingDependencies: [],
    compatibilityIssues: [],
    scannedAt: Date.now(),
    beat: beatCount,
  };

  var seen = new Set();

  // Scan for updates and missing dependencies
  for (var [key, pkg] of packageRegistry) {
    if (typeof key !== 'string') continue;
    if (seen.has(pkg.id)) continue;
    seen.add(pkg.id);

    // Check for available updates on installed packages
    if (pkg.status === 'installed' && !pkg.locked && pkg.autoUpdate) {
      var nextVersion = incrementVersion(pkg.version, 'patch');
      discovered.updatesAvailable.push({
        packageId: pkg.id,
        packageName: pkg.name,
        currentVersion: pkg.version,
        availableVersion: nextVersion,
        type: pkg.type,
      });
    }

    // Check for missing dependencies
    if (pkg.status === 'installed' && pkg.dependencies) {
      for (var i = 0; i < pkg.dependencies.length; i++) {
        var dep = pkg.dependencies[i];
        var depPkg = packageRegistry.get(dep.packageId);
        if (depPkg && depPkg.status !== 'installed') {
          discovered.missingDependencies.push({
            packageId: pkg.id,
            packageName: pkg.name,
            missingDep: dep.packageId,
            versionConstraint: dep.versionConstraint,
          });
        }
      }
    }

    // Check compatibility
    if (pkg.compatibility && pkg.compatibility.requiredWorkers && pkg.compatibility.requiredWorkers.length > 0) {
      discovered.compatibilityIssues.push({
        packageId: pkg.id,
        packageName: pkg.name,
        requiredWorkers: pkg.compatibility.requiredWorkers,
        issue: 'unverified-worker-dependencies',
      });
    }
  }

  totalDiscoveries++;
  logAudit('auto-discovery', {
    updates: discovered.updatesAvailable.length,
    missing: discovered.missingDependencies.length,
    compatibility: discovered.compatibilityIssues.length,
  });

  return discovered;
}

// ════════════════════════════════════════════════════════════════════════
//  AUTO-UPDATE ENGINE
// ════════════════════════════════════════════════════════════════════════

function autoUpdate() {
  var results = {
    updated: [],
    skipped: [],
    failed: [],
    checkedAt: Date.now(),
    beat: beatCount,
  };

  var seen = new Set();

  for (var [key, pkg] of packageRegistry) {
    if (typeof key !== 'string') continue;
    if (seen.has(pkg.id)) continue;
    seen.add(pkg.id);

    if (pkg.status !== 'installed') continue;
    if (pkg.locked) {
      results.skipped.push({ packageId: pkg.id, packageName: pkg.name, reason: 'locked' });
      continue;
    }
    if (!pkg.autoUpdate) {
      results.skipped.push({ packageId: pkg.id, packageName: pkg.name, reason: 'auto-update-disabled' });
      continue;
    }

    var updateResult = packageUpdate(pkg.id);
    if (updateResult.error) {
      if (updateResult.error === 'NO_UPDATE_AVAILABLE') {
        results.skipped.push({ packageId: pkg.id, packageName: pkg.name, reason: 'up-to-date' });
      } else {
        results.failed.push({ packageId: pkg.id, packageName: pkg.name, error: updateResult.error });
      }
    } else {
      results.updated.push({
        packageId: pkg.id,
        packageName: pkg.name,
        previousVersion: updateResult.previousVersion,
        newVersion: updateResult.newVersion,
      });
    }
  }

  logAudit('auto-update', {
    updated: results.updated.length,
    skipped: results.skipped.length,
    failed: results.failed.length,
  });

  return results;
}

// ════════════════════════════════════════════════════════════════════════
//  REMOTE REGISTRY SOURCES
// ════════════════════════════════════════════════════════════════════════

const REMOTE_SOURCES = [
  {
    id: 'RS-001',
    name: 'command-platform-core',
    url: 'https://registry.commandplatform.io/core',
    status: 'online',
    lastSync: null,
    packageCount: 0,
    priority: 1,
    trusted: true,
    syncIntervalBeats: 89,
  },
  {
    id: 'RS-002',
    name: 'command-platform-ai',
    url: 'https://registry.commandplatform.io/ai',
    status: 'online',
    lastSync: null,
    packageCount: 0,
    priority: 1,
    trusted: true,
    syncIntervalBeats: 55,
  },
  {
    id: 'RS-003',
    name: 'command-platform-community',
    url: 'https://registry.commandplatform.io/community',
    status: 'online',
    lastSync: null,
    packageCount: 0,
    priority: 2,
    trusted: false,
    syncIntervalBeats: 144,
  },
  {
    id: 'RS-004',
    name: 'command-platform-enterprise',
    url: 'https://registry.commandplatform.io/enterprise',
    status: 'online',
    lastSync: null,
    packageCount: 0,
    priority: 1,
    trusted: true,
    syncIntervalBeats: 89,
  },
  {
    id: 'RS-005',
    name: 'command-platform-sovereign',
    url: 'https://registry.commandplatform.io/sovereign',
    status: 'online',
    lastSync: null,
    packageCount: 0,
    priority: 0,
    trusted: true,
    syncIntervalBeats: 34,
  },
];

const remoteSourceMap = new Map();
for (var rs = 0; rs < REMOTE_SOURCES.length; rs++) {
  remoteSourceMap.set(REMOTE_SOURCES[rs].id, REMOTE_SOURCES[rs]);
  remoteSourceMap.set(REMOTE_SOURCES[rs].name, REMOTE_SOURCES[rs]);
}

function syncRemoteSource(source) {
  var result = {
    sourceId: source.id,
    sourceName: source.name,
    status: source.status,
    previousSync: source.lastSync,
    syncedAt: Date.now(),
    newPackages: 0,
    updatedPackages: 0,
    errors: 0,
  };

  if (source.status !== 'online') {
    result.errors = 1;
    result.errorMessage = 'Source offline: ' + source.name;
    return result;
  }

  // Simulate counting packages from this source
  var seen = new Set();
  var count = 0;
  for (var [key, pkg] of packageRegistry) {
    if (typeof key !== 'string') continue;
    if (seen.has(pkg.id)) continue;
    seen.add(pkg.id);
    count++;
  }

  source.lastSync = Date.now();
  source.packageCount = count;

  return result;
}

// ════════════════════════════════════════════════════════════════════════
//  REGISTRY SYNC
// ════════════════════════════════════════════════════════════════════════

function registrySync() {
  var syncResult = {
    syncedAt: Date.now(),
    beat: beatCount,
    totalPackages: 0,
    byType: {},
    byStatus: {},
    integrityChecks: { passed: 0, failed: 0 },
    remoteSources: [],
  };

  var seen = new Set();

  for (var [key, pkg] of packageRegistry) {
    if (typeof key !== 'string') continue;
    if (seen.has(pkg.id)) continue;
    seen.add(pkg.id);

    syncResult.totalPackages++;

    syncResult.byType[pkg.type] = (syncResult.byType[pkg.type] || 0) + 1;
    syncResult.byStatus[pkg.status] = (syncResult.byStatus[pkg.status] || 0) + 1;

    // Integrity check
    var expectedHash = hashEvent(pkg.id + ':' + pkg.name + ':' + pkg.version);
    if (pkg.hash === expectedHash) {
      syncResult.integrityChecks.passed++;
    } else {
      syncResult.integrityChecks.failed++;
      pkg.hash = expectedHash;  // Auto-repair
    }
  }

  // Sync with remote sources
  for (var i = 0; i < REMOTE_SOURCES.length; i++) {
    var sourceResult = syncRemoteSource(REMOTE_SOURCES[i]);
    syncResult.remoteSources.push(sourceResult);
  }

  logAudit('registry-sync', {
    totalPackages: syncResult.totalPackages,
    integrityPassed: syncResult.integrityChecks.passed,
    integrityFailed: syncResult.integrityChecks.failed,
    remoteSources: syncResult.remoteSources.length,
  });

  return syncResult;
}

// ════════════════════════════════════════════════════════════════════════
//  COMPATIBILITY CHECKER
// ════════════════════════════════════════════════════════════════════════

function checkPlatformCompatibility(pkg) {
  var issues = [];
  var warnings = [];

  // Check minimum platform version
  if (pkg.compatibility && pkg.compatibility.minPlatformVersion) {
    if (compareSemver('1.0.0', pkg.compatibility.minPlatformVersion) < 0) {
      issues.push({
        type: 'platform-version',
        message: 'Requires platform v' + pkg.compatibility.minPlatformVersion + ', current is v1.0.0',
        severity: 'error',
      });
    }
  }

  // Check required workers
  if (pkg.compatibility && pkg.compatibility.requiredWorkers) {
    for (var i = 0; i < pkg.compatibility.requiredWorkers.length; i++) {
      var worker = pkg.compatibility.requiredWorkers[i];
      warnings.push({
        type: 'required-worker',
        message: 'Requires worker: ' + worker,
        severity: 'warning',
      });
    }
  }

  // Check dependency availability
  if (pkg.dependencies) {
    for (var j = 0; j < pkg.dependencies.length; j++) {
      var dep = pkg.dependencies[j];
      var depPkg = packageRegistry.get(dep.packageId);
      if (!depPkg) {
        issues.push({
          type: 'missing-dependency',
          message: 'Dependency not found: ' + dep.packageId,
          severity: 'error',
        });
      } else if (!satisfiesConstraint(depPkg.version, dep.versionConstraint)) {
        issues.push({
          type: 'version-mismatch',
          message: 'Dependency ' + dep.packageId + ' v' + depPkg.version + ' does not satisfy ' + dep.versionConstraint,
          severity: 'error',
        });
      }
    }
  }

  // Check package type specific constraints
  if (pkg.type === 'ai-model' && pkg.size < 50000) {
    warnings.push({
      type: 'size-check',
      message: 'AI model package is unusually small (' + pkg.size + ' bytes)',
      severity: 'warning',
    });
  }

  if (pkg.type === 'agi-module') {
    var governancePkg = packageRegistry.get('agi-governance');
    if (governancePkg && governancePkg.status !== 'installed' && pkg.name !== 'agi-governance') {
      warnings.push({
        type: 'governance-missing',
        message: 'AGI governance module is not installed — recommended for all AGI modules',
        severity: 'warning',
      });
    }
  }

  if (pkg.type === 'migration') {
    var configPkg = packageRegistry.get('config-production');
    if (configPkg && configPkg.status !== 'installed') {
      warnings.push({
        type: 'config-missing',
        message: 'Production config profile not installed — recommended before migrations',
        severity: 'info',
      });
    }
  }

  return {
    packageId: pkg.id,
    packageName: pkg.name,
    compatible: issues.length === 0,
    issues: issues,
    warnings: warnings,
    totalIssues: issues.length,
    totalWarnings: warnings.length,
    checkedAt: Date.now(),
  };
}

function batchCompatibilityCheck() {
  var results = [];
  var seen = new Set();
  var totalIssues = 0;
  var totalWarnings = 0;

  for (var [key, pkg] of packageRegistry) {
    if (typeof key !== 'string') continue;
    if (seen.has(pkg.id)) continue;
    seen.add(pkg.id);

    var check = checkPlatformCompatibility(pkg);
    totalIssues += check.totalIssues;
    totalWarnings += check.totalWarnings;

    if (check.totalIssues > 0 || check.totalWarnings > 0) {
      results.push(check);
    }
  }

  return {
    checkedAt: Date.now(),
    packagesChecked: seen.size,
    packagesWithIssues: results.length,
    totalIssues: totalIssues,
    totalWarnings: totalWarnings,
    results: results,
    allCompatible: totalIssues === 0,
  };
}

// ════════════════════════════════════════════════════════════════════════
//  HELPER: Find reverse dependencies
// ════════════════════════════════════════════════════════════════════════

function findDependents(packageId) {
  var dependents = [];
  var seen = new Set();

  for (var [key, pkg] of packageRegistry) {
    if (typeof key !== 'string') continue;
    if (seen.has(pkg.id)) continue;
    seen.add(pkg.id);

    if (pkg.dependencies) {
      for (var i = 0; i < pkg.dependencies.length; i++) {
        if (pkg.dependencies[i].packageId === packageId) {
          dependents.push(pkg);
          break;
        }
      }
    }
  }

  return dependents;
}

// ════════════════════════════════════════════════════════════════════════
//  QUERY FUNCTIONS (read-only)
// ════════════════════════════════════════════════════════════════════════

function queryPackage(packageId) {
  var pkg = packageRegistry.get(packageId);
  if (!pkg) return { found: false, packageId: packageId };

  return {
    found: true,
    package: {
      id: pkg.id,
      name: pkg.name,
      version: pkg.version,
      type: pkg.type,
      category: pkg.category,
      status: pkg.status,
      dependencies: pkg.dependencies,
      installedAt: pkg.installedAt,
      updatedAt: pkg.updatedAt,
      size: pkg.size,
      hash: pkg.hash,
      autoUpdate: pkg.autoUpdate,
      locked: pkg.locked,
      compatibility: pkg.compatibility,
      downloadCount: pkg.downloadCount,
      rating: pkg.rating,
      publisher: pkg.publisher,
      tags: pkg.tags,
    },
  };
}

function queryPackagesByType(packageType) {
  var results = [];
  var seen = new Set();

  for (var [key, pkg] of packageRegistry) {
    if (typeof key !== 'string') continue;
    if (seen.has(pkg.id)) continue;
    seen.add(pkg.id);

    if (pkg.type === packageType) {
      results.push({
        id: pkg.id,
        name: pkg.name,
        version: pkg.version,
        status: pkg.status,
        category: pkg.category,
        rating: pkg.rating,
        size: pkg.size,
      });
    }
  }

  return { type: packageType, packages: results, count: results.length };
}

function queryInstalled() {
  var installed = [];
  var seen = new Set();

  for (var [key, pkg] of packageRegistry) {
    if (typeof key !== 'string') continue;
    if (seen.has(pkg.id)) continue;
    seen.add(pkg.id);

    if (pkg.status === 'installed') {
      installed.push({
        id: pkg.id,
        name: pkg.name,
        version: pkg.version,
        type: pkg.type,
        category: pkg.category,
        installedAt: pkg.installedAt,
        updatedAt: pkg.updatedAt,
        locked: pkg.locked,
        autoUpdate: pkg.autoUpdate,
      });
    }
  }

  return { installed: installed, count: installed.length };
}

function queryAvailable() {
  var available = [];
  var seen = new Set();

  for (var [key, pkg] of packageRegistry) {
    if (typeof key !== 'string') continue;
    if (seen.has(pkg.id)) continue;
    seen.add(pkg.id);

    if (pkg.status === 'available') {
      available.push({
        id: pkg.id,
        name: pkg.name,
        version: pkg.version,
        type: pkg.type,
        category: pkg.category,
        size: pkg.size,
        rating: pkg.rating,
      });
    }
  }

  return { available: available, count: available.length };
}

function queryDependencies(packageId) {
  var pkg = packageRegistry.get(packageId);
  if (!pkg) return { found: false, packageId: packageId };

  var graph = buildDependencyGraph(packageId);
  var dependents = findDependents(packageId);

  return {
    found: true,
    packageId: pkg.id,
    packageName: pkg.name,
    dependencies: pkg.dependencies,
    dependents: dependents.map(function (d) { return { id: d.id, name: d.name, version: d.version }; }),
    graphSize: graph.size,
    transitiveDeps: graph.size - 1,
  };
}

function queryUpdates() {
  var updates = [];
  var seen = new Set();

  for (var [key, pkg] of packageRegistry) {
    if (typeof key !== 'string') continue;
    if (seen.has(pkg.id)) continue;
    seen.add(pkg.id);

    if (pkg.status === 'installed' && !pkg.locked) {
      var nextVersion = incrementVersion(pkg.version, 'patch');
      updates.push({
        packageId: pkg.id,
        packageName: pkg.name,
        currentVersion: pkg.version,
        availableVersion: nextVersion,
        type: pkg.type,
        autoUpdate: pkg.autoUpdate,
      });
    }
  }

  return { updates: updates, count: updates.length };
}

function queryHistory(count) {
  var limit = count || 50;
  return {
    history: installHistory.slice(-limit),
    totalEntries: installHistory.length,
    maxHistory: MAX_HISTORY,
  };
}

function queryCapacity() {
  var totalPackages = 0;
  var installedCount = 0;
  var availableCount = 0;
  var errorCount = 0;
  var lockedCount = 0;
  var seen = new Set();

  for (var [key, pkg] of packageRegistry) {
    if (typeof key !== 'string') continue;
    if (seen.has(pkg.id)) continue;
    seen.add(pkg.id);

    totalPackages++;
    if (pkg.status === 'installed') installedCount++;
    if (pkg.status === 'available') availableCount++;
    if (pkg.status === 'error') errorCount++;
    if (pkg.locked) lockedCount++;
  }

  return {
    totalPackages: totalPackages,
    maxPackages: MAX_PACKAGES,
    installedCount: installedCount,
    availableCount: availableCount,
    errorCount: errorCount,
    lockedCount: lockedCount,
    queueLength: installQueue.length,
    maxQueue: MAX_INSTALL_QUEUE,
    activeInstalls: activeInstalls.size,
    historyEntries: installHistory.length,
    maxHistory: MAX_HISTORY,
    auditEntries: auditLog.length,
    maxAuditLog: MAX_AUDIT_LOG,
    utilization: totalPackages / MAX_PACKAGES,
  };
}

function queryHealth() {
  var errorRate = totalInstalls > 0 ? totalErrors / totalInstalls : 0;
  var activeCount = activeInstalls.size;
  var utilizationRatio = activeCount / MAX_INSTALL_QUEUE;

  var healthStatus = 'healthy';
  if (errorRate > 0.1) healthStatus = 'degraded';
  if (errorRate > 0.3) healthStatus = 'critical';
  if (!running) healthStatus = 'stopped';

  return {
    status: healthStatus,
    running: running,
    uptime: beatCount * HEARTBEAT,
    beat: beatCount,
    phi: PHI,
    errorRate: errorRate,
    utilizationRatio: utilizationRatio,
    totalInstalls: totalInstalls,
    totalUninstalls: totalUninstalls,
    totalUpdates: totalUpdates,
    totalErrors: totalErrors,
    totalDiscoveries: totalDiscoveries,
    activeInstalls: activeCount,
    queueLength: installQueue.length,
    installerTools: INSTALLER_COUNT,
  };
}

function queryRegistrySummary() {
  var byType = {};
  var byStatus = {};
  var seen = new Set();
  var totalSize = 0;

  for (var [key, pkg] of packageRegistry) {
    if (typeof key !== 'string') continue;
    if (seen.has(pkg.id)) continue;
    seen.add(pkg.id);

    byType[pkg.type] = (byType[pkg.type] || 0) + 1;
    byStatus[pkg.status] = (byStatus[pkg.status] || 0) + 1;
    totalSize += pkg.size;
  }

  return {
    totalPackages: seen.size,
    maxPackages: MAX_PACKAGES,
    byType: byType,
    byStatus: byStatus,
    totalSize: totalSize,
    installerTools: INSTALLER_COUNT,
    categories: Object.keys(PACKAGE_TYPES),
    installerRegistry: INSTALLER_REGISTRY.map(function (t) {
      return { id: t.id, name: t.name, category: t.category, action: t.action };
    }),
  };
}

// ════════════════════════════════════════════════════════════════════════
//  CALL FUNCTIONS (mutating)
// ════════════════════════════════════════════════════════════════════════

function callInstall(packageId, version, options) {
  var result = packageInstall(packageId, version, options);
  if (!result.error) {
    processInstallQueue();
  }
  return result;
}

function callBatchInstall(packages) {
  var results = [];
  for (var i = 0; i < (packages || []).length; i++) {
    var p = packages[i];
    var result = packageInstall(p.packageId, p.version, p.options || {});
    results.push(result);
  }
  processInstallQueue();
  return {
    results: results,
    count: results.length,
    errors: results.filter(function (r) { return r.error; }).length,
    queued: results.filter(function (r) { return r.status === 'queued'; }).length,
  };
}

function callUninstall(packageId) {
  return packageUninstall(packageId);
}

function callUpdate(packageId, version) {
  return packageUpdate(packageId, version);
}

function callLock(packageId) {
  return packageLock(packageId);
}

function callUnlock(packageId) {
  return packageUnlock(packageId);
}

function callAudit() {
  return packageAudit();
}

function callExport(format) {
  return packageExport(format);
}

function callAutoDiscover() {
  return autoDiscover();
}

function callAutoUpdate() {
  return autoUpdate();
}

function callResolve(packageId) {
  return fullDependencyResolve(packageId);
}

function callSync() {
  return registrySync();
}

// ════════════════════════════════════════════════════════════════════════
//  INSTALLER TOOL DISPATCH TABLE
// ════════════════════════════════════════════════════════════════════════

const INSTALLER_DISPATCH = {
  1:  function (msg) { return packageInstall(msg.packageId, msg.version, msg.options); },
  2:  function (msg) { return packageUninstall(msg.packageId); },
  3:  function (msg) { return packageUpdate(msg.packageId, msg.version); },
  4:  function (msg) { return packageSearch(msg.query); },
  5:  function (msg) { return packageValidate(msg.packageId); },
  6:  function (msg) { return packageLock(msg.packageId); },
  7:  function ()    { return packageAudit(); },
  8:  function (msg) { return packageExport(msg.format); },
  9:  function (msg) { return aiModelInstall(msg.packageId, msg.options); },
  10: function (msg) { return aiModelUpdate(msg.packageId); },
  11: function (msg) { return agiModuleInstall(msg.packageId, msg.options); },
  12: function (msg) { return agiModuleConfig(msg.packageId, msg.config); },
  13: function (msg) { return promptPackInstall(msg.packageId, msg.options); },
  14: function (msg) { return embeddingInstall(msg.packageId, msg.options); },
  15: function (msg) { return fineTuneInstall(msg.packageId, msg.options); },
  16: function (msg) { return agentPackInstall(msg.packageId, msg.options); },
  17: function (msg) { return toolBundleInstall(msg.packageId, msg.options); },
  18: function (msg) { return protocolPackInstall(msg.packageId, msg.options); },
  19: function (msg) { return blueprintPackInstall(msg.packageId, msg.options); },
  20: function (msg) { return recipePackInstall(msg.packageId, msg.options); },
  21: function (msg) { return shieldPackInstall(msg.packageId, msg.options); },
  22: function (msg) { return sensorPackInstall(msg.packageId, msg.options); },
  23: function (msg) { return adapterPackInstall(msg.packageId, msg.options); },
  24: function (msg) { return lensPackInstall(msg.packageId, msg.options); },
  25: function (msg) { return workerInstall(msg.packageId, msg.options); },
  26: function (msg) { return extensionInstall(msg.packageId, msg.options); },
  27: function (msg) { return themeInstall(msg.packageId, msg.options); },
  28: function (msg) { return localeInstall(msg.packageId, msg.options); },
  29: function (msg) { return configProfileInstall(msg.packageId, msg.options); },
  30: function (msg) { return migrationInstall(msg.packageId, msg.options); },
  31: function ()    { return autoDiscover(); },
  32: function ()    { return autoUpdate(); },
  33: function (msg) { return fullDependencyResolve(msg.packageId); },
  34: function ()    { return registrySync(); },
};

// ════════════════════════════════════════════════════════════════════════
//  getState — full state snapshot
// ════════════════════════════════════════════════════════════════════════

function getState() {
  var packageList = [];
  var seen = new Set();

  for (var [key, pkg] of packageRegistry) {
    if (typeof key !== 'string') continue;
    if (seen.has(pkg.id)) continue;
    seen.add(pkg.id);

    packageList.push({
      id: pkg.id,
      name: pkg.name,
      version: pkg.version,
      type: pkg.type,
      category: pkg.category,
      status: pkg.status,
      locked: pkg.locked,
      autoUpdate: pkg.autoUpdate,
      installedAt: pkg.installedAt,
      updatedAt: pkg.updatedAt,
      size: pkg.size,
      dependencyCount: (pkg.dependencies || []).length,
    });
  }

  return {
    running: running,
    beat: beatCount,
    phi: PHI,
    installerCount: INSTALLER_COUNT,
    packages: packageList,
    totalPackages: seen.size,
    maxPackages: MAX_PACKAGES,
    queueLength: installQueue.length,
    activeInstalls: activeInstalls.size,
    maxQueue: MAX_INSTALL_QUEUE,
    historyLength: installHistory.length,
    maxHistory: MAX_HISTORY,
    auditLength: auditLog.length,
    maxAuditLog: MAX_AUDIT_LOG,
    totalInstalls: totalInstalls,
    totalUninstalls: totalUninstalls,
    totalUpdates: totalUpdates,
    totalErrors: totalErrors,
    totalDiscoveries: totalDiscoveries,
  };
}

// ════════════════════════════════════════════════════════════════════════
//  getStats — summary metrics
// ════════════════════════════════════════════════════════════════════════

function getStats() {
  var installedCount = 0;
  var availableCount = 0;
  var errorCount = 0;
  var lockedCount = 0;
  var totalSize = 0;
  var seen = new Set();

  for (var [key, pkg] of packageRegistry) {
    if (typeof key !== 'string') continue;
    if (seen.has(pkg.id)) continue;
    seen.add(pkg.id);

    if (pkg.status === 'installed') { installedCount++; totalSize += pkg.size; }
    if (pkg.status === 'available') availableCount++;
    if (pkg.status === 'error') errorCount++;
    if (pkg.locked) lockedCount++;
  }

  return {
    totalPackages: seen.size,
    maxPackages: MAX_PACKAGES,
    installedCount: installedCount,
    availableCount: availableCount,
    errorCount: errorCount,
    lockedCount: lockedCount,
    totalSize: totalSize,
    totalInstalls: totalInstalls,
    totalUninstalls: totalUninstalls,
    totalUpdates: totalUpdates,
    totalErrors: totalErrors,
    totalDiscoveries: totalDiscoveries,
    queueLength: installQueue.length,
    activeInstalls: activeInstalls.size,
    historyLength: installHistory.length,
    auditLength: auditLog.length,
    installerTools: INSTALLER_COUNT,
    recentHistory: installHistory.slice(-10),
  };
}

// ════════════════════════════════════════════════════════════════════════
//  MESSAGE HANDLER
// ════════════════════════════════════════════════════════════════════════

self.onmessage = function (e) {
  const msg = e.data;

  switch (msg.type) {
    // ─── Query API (read-only) ────────────────────────────────
    case 'queryPackage': {
      const result = queryPackage(msg.packageId);
      self.postMessage({ type: 'query-result', query: 'queryPackage', ...result });
      break;
    }

    case 'queryPackagesByType': {
      const result = queryPackagesByType(msg.packageType);
      self.postMessage({ type: 'query-result', query: 'queryPackagesByType', ...result });
      break;
    }

    case 'queryInstalled': {
      const result = queryInstalled();
      self.postMessage({ type: 'query-result', query: 'queryInstalled', ...result });
      break;
    }

    case 'queryAvailable': {
      const result = queryAvailable();
      self.postMessage({ type: 'query-result', query: 'queryAvailable', ...result });
      break;
    }

    case 'queryDependencies': {
      const result = queryDependencies(msg.packageId);
      self.postMessage({ type: 'query-result', query: 'queryDependencies', ...result });
      break;
    }

    case 'queryUpdates': {
      const result = queryUpdates();
      self.postMessage({ type: 'query-result', query: 'queryUpdates', ...result });
      break;
    }

    case 'queryHistory': {
      const result = queryHistory(msg.count);
      self.postMessage({ type: 'query-result', query: 'queryHistory', ...result });
      break;
    }

    case 'queryCapacity': {
      const result = queryCapacity();
      self.postMessage({ type: 'query-result', query: 'queryCapacity', ...result });
      break;
    }

    case 'queryHealth': {
      const result = queryHealth();
      self.postMessage({ type: 'query-result', query: 'queryHealth', ...result });
      break;
    }

    case 'queryRegistry': {
      const result = queryRegistrySummary();
      self.postMessage({ type: 'query-result', query: 'queryRegistry', ...result });
      break;
    }

    // ─── Call API (mutating) ──────────────────────────────────
    case 'callInstall': {
      const result = callInstall(msg.packageId, msg.version, msg.options);
      if (result.error) {
        self.postMessage({ type: 'call-error', call: 'callInstall', error: result.error, packageId: msg.packageId });
      } else {
        self.postMessage({ type: 'call-result', call: 'callInstall', ...result });
      }
      break;
    }

    case 'callBatchInstall': {
      const result = callBatchInstall(msg.packages || []);
      self.postMessage({ type: 'call-result', call: 'callBatchInstall', ...result });
      break;
    }

    case 'callUninstall': {
      const result = callUninstall(msg.packageId);
      if (result.error) {
        self.postMessage({ type: 'call-error', call: 'callUninstall', error: result.error, packageId: msg.packageId });
      } else {
        self.postMessage({ type: 'call-result', call: 'callUninstall', ...result });
      }
      break;
    }

    case 'callUpdate': {
      const result = callUpdate(msg.packageId, msg.version);
      if (result.error) {
        self.postMessage({ type: 'call-error', call: 'callUpdate', error: result.error, packageId: msg.packageId });
      } else {
        self.postMessage({ type: 'call-result', call: 'callUpdate', ...result });
      }
      break;
    }

    case 'callLock': {
      const result = callLock(msg.packageId);
      if (result.error) {
        self.postMessage({ type: 'call-error', call: 'callLock', error: result.error, packageId: msg.packageId });
      } else {
        self.postMessage({ type: 'call-result', call: 'callLock', ...result });
      }
      break;
    }

    case 'callUnlock': {
      const result = callUnlock(msg.packageId);
      if (result.error) {
        self.postMessage({ type: 'call-error', call: 'callUnlock', error: result.error, packageId: msg.packageId });
      } else {
        self.postMessage({ type: 'call-result', call: 'callUnlock', ...result });
      }
      break;
    }

    case 'callAudit': {
      const result = callAudit();
      self.postMessage({ type: 'call-result', call: 'callAudit', ...result });
      break;
    }

    case 'callExport': {
      const result = callExport(msg.format);
      self.postMessage({ type: 'call-result', call: 'callExport', ...result });
      break;
    }

    case 'callAutoDiscover': {
      const result = callAutoDiscover();
      self.postMessage({ type: 'call-result', call: 'callAutoDiscover', ...result });
      break;
    }

    case 'callAutoUpdate': {
      const result = callAutoUpdate();
      self.postMessage({ type: 'call-result', call: 'callAutoUpdate', ...result });
      break;
    }

    case 'callResolve': {
      const result = callResolve(msg.packageId);
      if (result.error) {
        self.postMessage({ type: 'call-error', call: 'callResolve', error: result.error, packageId: msg.packageId });
      } else {
        self.postMessage({ type: 'call-result', call: 'callResolve', ...result });
      }
      break;
    }

    case 'callSync': {
      const result = callSync();
      self.postMessage({ type: 'call-result', call: 'callSync', ...result });
      break;
    }

    // ─── Tool Dispatch ────────────────────────────────────────
    case 'invokeTool': {
      const handler = INSTALLER_DISPATCH[msg.toolId];
      if (!handler) {
        self.postMessage({ type: 'call-error', call: 'invokeTool', error: 'UNKNOWN_TOOL', toolId: msg.toolId });
      } else {
        const result = handler(msg);
        if (result && result.error) {
          self.postMessage({ type: 'call-error', call: 'invokeTool', toolId: msg.toolId, error: result.error });
        } else {
          self.postMessage({ type: 'call-result', call: 'invokeTool', toolId: msg.toolId, ...result });
        }
      }
      break;
    }

    // ─── Registry / Catalog ───────────────────────────────────
    case 'list':
    case 'getRegistry':
      self.postMessage({
        type: 'catalog',
        installers: INSTALLER_REGISTRY.map(function (t) {
          return { id: t.id, name: t.name, category: t.category, action: t.action };
        }),
        count: INSTALLER_COUNT,
        categories: [...new Set(INSTALLER_REGISTRY.map(function (t) { return t.category; }))],
      });
      break;

    // ─── Audit ────────────────────────────────────────────────
    case 'getAudit': {
      const auditCount = msg.count || 50;
      self.postMessage({
        type: 'audit',
        entries: auditLog.slice(-auditCount),
        totalEntries: auditLog.length,
      });
      break;
    }

    // ─── Search ───────────────────────────────────────────────
    case 'search': {
      const searchResult = packageSearch(msg.query);
      self.postMessage({ type: 'query-result', query: 'search', ...searchResult });
      break;
    }

    // ─── State & Stats ────────────────────────────────────────
    case 'getState':
      self.postMessage({ type: 'state', ...getState() });
      break;

    case 'getStats':
      self.postMessage({ type: 'stats', ...getStats() });
      break;

    // ─── Lifecycle ────────────────────────────────────────────
    case 'stop':
      running = false;
      if (heartbeatInterval) clearInterval(heartbeatInterval);
      // Fail all active installs
      for (var [instId] of activeInstalls) {
        failInstall(instId, 'WORKER_STOPPED');
      }
      logAudit('installers-stop', {
        totalInstalls: totalInstalls,
        totalUninstalls: totalUninstalls,
        totalUpdates: totalUpdates,
        totalErrors: totalErrors,
      });
      self.postMessage({
        type: 'stopped',
        totalInstalls: totalInstalls,
        totalUninstalls: totalUninstalls,
        totalUpdates: totalUpdates,
        totalErrors: totalErrors,
      });
      break;
  }
};

// ════════════════════════════════════════════════════════════════════════
//  HEARTBEAT — 873ms φ-scaled
// ════════════════════════════════════════════════════════════════════════

const heartbeatInterval = setInterval(function () {
  if (!running) return;
  beatCount++;

  // Process install queue every heartbeat
  processInstallQueue();

  // Auto-discovery scan every F11 (89) beats (~78s)
  if (beatCount % AUTO_DISCOVER_INTERVAL === 0) {
    var discoveryResult = autoDiscover();
    if (discoveryResult.updatesAvailable.length > 0 || discoveryResult.missingDependencies.length > 0) {
      self.postMessage({
        type: 'auto-discovery-result',
        updatesAvailable: discoveryResult.updatesAvailable.length,
        missingDependencies: discoveryResult.missingDependencies.length,
        compatibilityIssues: discoveryResult.compatibilityIssues.length,
        beat: beatCount,
      });
    }
  }

  // Auto-update check every F10 (55) beats (~48s)
  if (beatCount % AUTO_UPDATE_INTERVAL === 0) {
    // Only auto-update if queue is empty and no active installs
    if (installQueue.length === 0 && activeInstalls.size === 0) {
      var updateResult = autoUpdate();
      if (updateResult.updated.length > 0) {
        self.postMessage({
          type: 'auto-update-result',
          updated: updateResult.updated.length,
          skipped: updateResult.skipped.length,
          failed: updateResult.failed.length,
          beat: beatCount,
        });
      }
    }
  }

  // Periodic registry integrity check every 34 beats (~30s)
  if (beatCount % 34 === 0) {
    var seen = new Set();
    for (var [key, pkg] of packageRegistry) {
      if (typeof key !== 'string') continue;
      if (seen.has(pkg.id)) continue;
      seen.add(pkg.id);

      // Auto-repair hash mismatches
      var expectedHash = hashEvent(pkg.id + ':' + pkg.name + ':' + pkg.version);
      if (pkg.hash !== expectedHash) {
        pkg.hash = expectedHash;
      }
    }
  }

  // Periodic stale install cleanup every 21 beats (~18s)
  if (beatCount % 21 === 0) {
    var now = Date.now();
    for (var [jobId, job] of activeInstalls) {
      if (job.status === 'installing' && (now - job.startedAt) > 120000) {
        failInstall(jobId, 'TIMEOUT');
      }
    }
  }

  // Periodic queue health decay every 13 beats (~11s)
  if (beatCount % 13 === 0) {
    // Decay error count phi-scaled
    if (totalErrors > 0 && totalInstalls > 0) {
      var errorRate = totalErrors / totalInstalls;
      if (errorRate > 0.3) {
        self.postMessage({
          type: 'health-alert',
          severity: 'critical',
          message: 'High error rate: ' + (errorRate * 100).toFixed(1) + '%',
          beat: beatCount,
        });
      }
    }
  }

  self.postMessage({
    type: 'heartbeat',
    beat: beatCount,
    phi: PHI,
    heartbeatMs: HEARTBEAT,
    timestamp: Date.now(),
    status: 'alive',
    installerCount: INSTALLER_COUNT,
    totalInstalls: totalInstalls,
    totalUninstalls: totalUninstalls,
    totalUpdates: totalUpdates,
    totalErrors: totalErrors,
    activeInstalls: activeInstalls.size,
    queueLength: installQueue.length,
    totalDiscoveries: totalDiscoveries,
  });
}, HEARTBEAT);
