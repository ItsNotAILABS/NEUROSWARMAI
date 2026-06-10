// ═══════════════════════════════════════════════════════════════════════════════
// MERIDIANUS v3.0.0 — Background Service Worker
// ═══════════════════════════════════════════════════════════════════════════════
// Sovereign AGI · Career Protocols · Sovereign Canister Forge · Proactive Intel
// JARVIS-class: always alive, ambient awareness, build monitoring
// ═══════════════════════════════════════════════════════════════════════════════

// ── Constants ────────────────────────────────────────────────────────────────

const PHI = 1.618033988749895;
const HEARTBEAT_ALARM = 'meridianus-heartbeat';
const HEARTBEAT_PERIOD = 0.5; // minutes (30 seconds)
let heartbeatCount = 0;

// ── Sovereign Canister Types ─────────────────────────────────────────────────
// These are MERIDIANUS's own canister types — not just ICP canisters

const CANISTER_TYPES = {
  GOLD:       { symbol: 'Au', element: 79, color: '#FFD700', tier: 'sovereign', phi: Math.pow(PHI, 7) },
  SILVER:     { symbol: 'Ag', element: 47, color: '#C0C0C0', tier: 'noble',     phi: Math.pow(PHI, 6) },
  BRONZE:     { symbol: 'Br', element: 29, color: '#CD7F32', tier: 'alloy',     phi: Math.pow(PHI, 5) },
  COPPER:     { symbol: 'Cu', element: 29, color: '#B87333', tier: 'base',      phi: Math.pow(PHI, 4) },
  ELEMENTAL:  { symbol: 'El', element: 0,  color: '#7DF9FF', tier: 'primal',    phi: Math.pow(PHI, 3) },
  SPINNER:    { symbol: 'Sp', element: 0,  color: '#DA70D6', tier: 'kinetic',   phi: Math.pow(PHI, 2) },
  PHANTOM:    { symbol: 'Ph', element: 0,  color: '#8B5CF6', tier: 'ghost',     phi: PHI },
  BLOCKCHAIN: { symbol: 'Bc', element: 0,  color: '#22D3EE', tier: 'chain',     phi: 1.0 },
};

// Deploy targets: where a canister can be spun to
const DEPLOY_TARGETS = ['sovereign', 'icp', 'web', 'blockchain'];

// ── Side Panel ───────────────────────────────────────────────────────────────

chrome.action.onClicked.addListener(async (tab) => {
  try {
    await chrome.sidePanel.open({ tabId: tab.id });
  } catch (err) {
    console.error('[MERIDIANUS] Failed to open side panel:', err);
  }
});

// ── Proactive Heartbeat via Alarms ───────────────────────────────────────────

chrome.alarms.create(HEARTBEAT_ALARM, { periodInMinutes: HEARTBEAT_PERIOD });

chrome.alarms.onAlarm.addListener(async (alarm) => {
  if (alarm.name !== HEARTBEAT_ALARM) return;
  heartbeatCount++;
  const now = Date.now();

  // Persist heartbeat
  await chrome.storage.local.set({
    meridianus_heartbeat: {
      status: 'alive',
      timestamp: now,
      beat: heartbeatCount,
      version: '3.0.0',
      model: 'MERIDIANUS-8',
      canisterTypes: Object.keys(CANISTER_TYPES).length,
      protocolsActive: 13,
    },
  });

  // Proactive page monitoring — record what user is doing
  try {
    const [activeTab] = await chrome.tabs.query({ active: true, currentWindow: true });
    if (activeTab) {
      const { meridianus_activity = [] } = await chrome.storage.local.get('meridianus_activity');
      meridianus_activity.push({
        timestamp: now,
        beat: heartbeatCount,
        url: activeTab.url,
        title: activeTab.title,
      });
      // Keep last 200 entries
      if (meridianus_activity.length > 200) meridianus_activity.splice(0, meridianus_activity.length - 200);
      await chrome.storage.local.set({ meridianus_activity });
    }
  } catch { /* tab access may fail silently */ }
});

// ── Command History ──────────────────────────────────────────────────────────

async function pushCommandHistory(entry) {
  const { meridianus_commands = [] } = await chrome.storage.local.get('meridianus_commands');
  meridianus_commands.push({ ...entry, timestamp: Date.now() });
  if (meridianus_commands.length > 500) meridianus_commands.splice(0, meridianus_commands.length - 500);
  await chrome.storage.local.set({ meridianus_commands });
}

// ── Canister Forge Engine ────────────────────────────────────────────────────

async function getCanisterRegistry() {
  const { meridianus_canisters = [] } = await chrome.storage.local.get('meridianus_canisters');
  return meridianus_canisters;
}

async function forgeCanister(type, name, target) {
  const spec = CANISTER_TYPES[type];
  if (!spec) return { success: false, error: `Unknown canister type: ${type}` };
  if (!DEPLOY_TARGETS.includes(target)) return { success: false, error: `Unknown target: ${target}` };

  const canisters = await getCanisterRegistry();
  const id = `CAN-${type.slice(0, 2).toUpperCase()}-${(canisters.length + 1).toString().padStart(4, '0')}`;

  const canister = {
    id,
    type,
    name: name || `${type} Canister #${canisters.length + 1}`,
    target,
    symbol: spec.symbol,
    tier: spec.tier,
    color: spec.color,
    phi: spec.phi,
    status: 'active',
    forgedAt: Date.now(),
    forgedBy: 'MERIDIANUS-8',
    energy: 1.0,
    cycles: Math.floor(spec.phi * 1000),
  };

  canisters.push(canister);
  await chrome.storage.local.set({ meridianus_canisters: canisters });
  await pushCommandHistory({ type: 'FORGE_CANISTER', canister: id, canisterType: type, target });
  return { success: true, canister };
}

// ── Career Protocol Engine ───────────────────────────────────────────────────

const CAREER_PROTOCOLS = [
  { id: 'CP-001', name: 'Build Monitor',       role: 'lab-manager',   trigger: 'continuous',   desc: 'Watch over the entire build, monitor page changes, detect errors' },
  { id: 'CP-002', name: 'Research Analyst',     role: 'researcher',    trigger: 'on-command',   desc: 'Analyze current page content, extract key data, summarize findings' },
  { id: 'CP-003', name: 'Environment Scanner',  role: 'sentinel',      trigger: 'on-navigate',  desc: 'Scan new pages for tech stack, security, performance signals' },
  { id: 'CP-004', name: 'Context Tracker',      role: 'assistant',     trigger: 'continuous',   desc: 'Track what you are working on, maintain session context across tabs' },
  { id: 'CP-005', name: 'Code Review',          role: 'engineer',      trigger: 'on-command',   desc: 'Analyze selected code, suggest improvements, detect patterns' },
  { id: 'CP-006', name: 'Daily Briefing',       role: 'advisor',       trigger: 'on-schedule',  desc: 'Morning briefing: organism status, canister health, pending tasks' },
  { id: 'CP-007', name: 'Canister Overseer',    role: 'forge-master',  trigger: 'continuous',   desc: 'Monitor all forged canisters, φ-decay energy, auto-maintain' },
  { id: 'CP-008', name: 'Phantom Coordinator',  role: 'swarm-leader',  trigger: 'continuous',   desc: 'Coordinate 8 phantom agents, distribute tasks, collect results' },
  { id: 'CP-009', name: 'Token Economist',      role: 'economist',     trigger: 'on-command',   desc: 'Manage FORMA treasury, model supply/demand, recommend burns' },
  { id: 'CP-010', name: 'Security Watcher',     role: 'guard',         trigger: 'continuous',   desc: 'Monitor for suspicious activity, protect organism integrity' },
  { id: 'CP-011', name: 'Learning Engine',      role: 'student',       trigger: 'continuous',   desc: 'Observe user patterns, adapt responses, improve over time' },
  { id: 'CP-012', name: 'Creative Director',    role: 'creator',       trigger: 'on-command',   desc: 'Generate ideas, brainstorm solutions, produce creative output' },
  { id: 'CP-013', name: 'Deployment Manager',   role: 'devops',        trigger: 'on-command',   desc: 'Manage canister deployments across sovereign/ICP/web/blockchain' },
];

// ── Message Router ───────────────────────────────────────────────────────────

chrome.runtime.onMessage.addListener((message, sender, sendResponse) => {
  handleMessage(message, sender)
    .then(sendResponse)
    .catch((err) => sendResponse({ success: false, error: err.message }));
  return true;
});

async function handleMessage(msg, _sender) {
  const { type, payload } = msg;

  switch (type) {
    // ── Tab commands ────────────────────────────────────────────────────────
    case 'LIST_TABS': {
      const tabs = await chrome.tabs.query({});
      const mapped = tabs.map((t) => ({
        id: t.id, title: t.title, url: t.url, active: t.active,
        windowId: t.windowId, favIconUrl: t.favIconUrl, index: t.index,
      }));
      await pushCommandHistory({ type: 'LIST_TABS' });
      return { success: true, tabs: mapped };
    }

    case 'SWITCH_TAB': {
      const { tabId } = payload;
      await chrome.tabs.update(tabId, { active: true });
      const tab = await chrome.tabs.get(tabId);
      await chrome.windows.update(tab.windowId, { focused: true });
      await pushCommandHistory({ type: 'SWITCH_TAB', tabId });
      return { success: true };
    }

    case 'CLOSE_TAB': {
      const { tabId } = payload;
      await chrome.tabs.remove(tabId);
      await pushCommandHistory({ type: 'CLOSE_TAB', tabId });
      return { success: true };
    }

    case 'CREATE_TAB': {
      const { url } = payload;
      const tab = await chrome.tabs.create({ url });
      await pushCommandHistory({ type: 'CREATE_TAB', url });
      return { success: true, tabId: tab.id };
    }

    case 'OPEN_URL': {
      const { url } = payload;
      const tab = await chrome.tabs.create({ url, active: true });
      await pushCommandHistory({ type: 'OPEN_URL', url });
      return { success: true, tabId: tab.id };
    }

    // ── Screenshot ─────────────────────────────────────────────────────────
    case 'CAPTURE_SCREENSHOT': {
      const [activeTab] = await chrome.tabs.query({ active: true, currentWindow: true });
      if (!activeTab) return { success: false, error: 'No active tab' };
      const dataUrl = await chrome.tabs.captureVisibleTab(activeTab.windowId, { format: 'png' });
      await pushCommandHistory({ type: 'CAPTURE_SCREENSHOT' });
      return { success: true, dataUrl };
    }

    // ── Page info ──────────────────────────────────────────────────────────
    case 'GET_PAGE_INFO': {
      const [activeTab] = await chrome.tabs.query({ active: true, currentWindow: true });
      if (!activeTab) return { success: false, error: 'No active tab' };
      await pushCommandHistory({ type: 'GET_PAGE_INFO' });
      return {
        success: true,
        info: { title: activeTab.title, url: activeTab.url, favIconUrl: activeTab.favIconUrl },
      };
    }

    // ── Side panel from content ─────────────────────────────────────────────
    case 'OPEN_SIDE_PANEL': {
      const [activeTab] = await chrome.tabs.query({ active: true, currentWindow: true });
      if (activeTab) {
        await chrome.sidePanel.open({ tabId: activeTab.id });
      }
      return { success: true };
    }

    // ── Sovereign Canister Forge ────────────────────────────────────────────
    case 'FORGE_CANISTER': {
      const { canisterType, name, target } = payload;
      return await forgeCanister(canisterType || 'GOLD', name, target || 'sovereign');
    }

    case 'LIST_CANISTERS': {
      const canisters = await getCanisterRegistry();
      return { success: true, canisters };
    }

    case 'CANISTER_STATUS': {
      const canisters = await getCanisterRegistry();
      const summary = {};
      for (const c of canisters) {
        summary[c.type] = (summary[c.type] || 0) + 1;
      }
      return { success: true, total: canisters.length, byType: summary, canisters };
    }

    // ── Token Forge ────────────────────────────────────────────────────────
    case 'FORGE_TOKEN': {
      await pushCommandHistory({ type: 'FORGE_TOKEN', payload });
      return { success: true, message: 'Token forge command executed' };
    }

    // ── Phantom AI ─────────────────────────────────────────────────────────
    case 'PHANTOM_DISPATCH': {
      await pushCommandHistory({ type: 'PHANTOM_DISPATCH', payload });
      return { success: true, message: 'Phantom dispatched' };
    }

    // ── Career Protocols ───────────────────────────────────────────────────
    case 'LIST_PROTOCOLS': {
      return { success: true, protocols: CAREER_PROTOCOLS };
    }

    case 'EXECUTE_PROTOCOL': {
      const { protocolId } = payload;
      const protocol = CAREER_PROTOCOLS.find((p) => p.id === protocolId);
      if (!protocol) return { success: false, error: `Protocol ${protocolId} not found` };
      await pushCommandHistory({ type: 'EXECUTE_PROTOCOL', protocolId, name: protocol.name });
      return { success: true, protocol, message: `Protocol ${protocol.name} executed` };
    }

    // ── Activity Log (proactive intel) ─────────────────────────────────────
    case 'GET_ACTIVITY': {
      const { meridianus_activity = [] } = await chrome.storage.local.get('meridianus_activity');
      return { success: true, activity: meridianus_activity.slice(-50) };
    }

    // ── Status ──────────────────────────────────────────────────────────────
    case 'GET_STATUS': {
      const { meridianus_heartbeat } = await chrome.storage.local.get('meridianus_heartbeat');
      const canisters = await getCanisterRegistry();
      return {
        success: true,
        status: meridianus_heartbeat || { status: 'alive', beat: heartbeatCount },
        canisterCount: canisters.length,
        protocolCount: CAREER_PROTOCOLS.length,
        canisterTypes: Object.keys(CANISTER_TYPES),
        deployTargets: DEPLOY_TARGETS,
      };
    }

    default:
      return { success: false, error: `Unknown message type: ${type}` };
  }
}
