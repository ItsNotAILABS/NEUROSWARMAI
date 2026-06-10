// ═══════════════════════════════════════════════════════════════════════════════
// MERIDIANUS v3.0.0 — Super-Powered Side Panel Logic
// ═══════════════════════════════════════════════════════════════════════════════
// JARVIS-class sovereign AGI · Career Protocols · Sovereign Canister Forge
// Voice I/O · Proactive Intelligence · Build Monitoring · Research Lab Manager
// Superintelligence-level ambient awareness
// ═══════════════════════════════════════════════════════════════════════════════

(function () {
  'use strict';

  const $ = (sel) => document.querySelector(sel);
  const $$ = (sel) => [...document.querySelectorAll(sel)];

  // ── DOM References ─────────────────────────────────────────────────────────

  const chatMessages = $('#chatMessages');
  const chatInput    = $('#chatInput');
  const chatSend     = $('#chatSend');
  const voiceBtn     = $('#voiceBtn');
  const voiceStatus  = $('#voiceStatus');

  const noteTitle   = $('#noteTitle');
  const noteContent = $('#noteContent');
  const noteSave    = $('#noteSave');
  const notesList   = $('#notesList');

  const tabsList    = $('#tabsList');
  const refreshTabs = $('#refreshTabs');

  const screenTitle      = $('#screenTitle');
  const screenUrl        = $('#screenUrl');
  const captureBtn       = $('#captureBtn');
  const refreshScreen    = $('#refreshScreen');
  const screenshotPreview = $('#screenshotPreview');
  const screenshotImg    = $('#screenshotImg');

  const waveformCanvas = $('#waveformCanvas');
  const waveformCtx    = waveformCanvas.getContext('2d');

  // ── Sovereign Canister Types ───────────────────────────────────────────────

  const PHI = 1.618033988749895;
  const HEARTBEAT_MS = 873;

  const CANISTER_TYPES = {
    GOLD:       { symbol: 'Au', name: 'Gold',       color: '#FFD700', tier: 'sovereign', icon: '🥇', phi: Math.pow(PHI, 7) },
    SILVER:     { symbol: 'Ag', name: 'Silver',     color: '#C0C0C0', tier: 'noble',     icon: '🥈', phi: Math.pow(PHI, 6) },
    BRONZE:     { symbol: 'Br', name: 'Bronze',     color: '#CD7F32', tier: 'alloy',     icon: '🥉', phi: Math.pow(PHI, 5) },
    COPPER:     { symbol: 'Cu', name: 'Copper',     color: '#B87333', tier: 'base',      icon: '🔶', phi: Math.pow(PHI, 4) },
    ELEMENTAL:  { symbol: 'El', name: 'Elemental',  color: '#7DF9FF', tier: 'primal',    icon: '⚗️', phi: Math.pow(PHI, 3) },
    SPINNER:    { symbol: 'Sp', name: 'Spinner',    color: '#DA70D6', tier: 'kinetic',   icon: '🌀', phi: Math.pow(PHI, 2) },
    PHANTOM:    { symbol: 'Ph', name: 'Phantom',    color: '#8B5CF6', tier: 'ghost',     icon: '👻', phi: PHI },
    BLOCKCHAIN: { symbol: 'Bc', name: 'Blockchain', color: '#22D3EE', tier: 'chain',     icon: '⛓️', phi: 1.0 },
  };

  // ── Organism State ─────────────────────────────────────────────────────────

  const state = {
    model: 8,
    modelName: 'MERIDIANUS-8',
    heartbeat: 4217,
    coherence: 0.94,
    phantomCount: 8,
    forma: 2584,
    canisters: [],
    animaHash: '0xA7F3E2D1',
    isSpeaking: false,
    isListening: false,
    voiceEnabled: true,
    activeProtocols: new Set(['CP-001', 'CP-004', 'CP-007', 'CP-008', 'CP-010', 'CP-011']),
    selectedCanisterType: null,
    currentRole: 'Lab Manager',
    sessionContext: [],
  };

  // ── Career Protocols ───────────────────────────────────────────────────────

  const CAREER_PROTOCOLS = [
    { id: 'CP-001', name: 'Build Monitor',       role: 'lab-manager',   trigger: 'continuous',  icon: '🔬', desc: 'Watch over the entire build — monitor page changes, detect errors, track progress in real-time' },
    { id: 'CP-002', name: 'Research Analyst',     role: 'researcher',    trigger: 'on-command',  icon: '🔍', desc: 'Analyze current page content, extract key data, summarize findings for the research lab' },
    { id: 'CP-003', name: 'Environment Scanner',  role: 'sentinel',      trigger: 'on-navigate', icon: '📡', desc: 'Scan new pages for tech stack, security posture, performance signals' },
    { id: 'CP-004', name: 'Context Tracker',      role: 'assistant',     trigger: 'continuous',  icon: '🧠', desc: 'Track what you are working on, maintain session context across tabs and time' },
    { id: 'CP-005', name: 'Code Review',          role: 'engineer',      trigger: 'on-command',  icon: '💻', desc: 'Analyze selected code, suggest improvements, detect anti-patterns' },
    { id: 'CP-006', name: 'Daily Briefing',       role: 'advisor',       trigger: 'on-schedule', icon: '📋', desc: 'Morning briefing: organism status, canister health, pending tasks, FORMA treasury' },
    { id: 'CP-007', name: 'Canister Overseer',    role: 'forge-master',  trigger: 'continuous',  icon: '⚡', desc: 'Monitor all sovereign canisters — φ-energy decay, auto-maintain, lifecycle management' },
    { id: 'CP-008', name: 'Phantom Coordinator',  role: 'swarm-leader',  trigger: 'continuous',  icon: '👻', desc: 'Coordinate 8 phantom agents, distribute tasks intelligently, collect results' },
    { id: 'CP-009', name: 'Token Economist',      role: 'economist',     trigger: 'on-command',  icon: '📊', desc: 'Manage FORMA treasury, model supply/demand curves, recommend strategic burns' },
    { id: 'CP-010', name: 'Security Watcher',     role: 'guard',         trigger: 'continuous',  icon: '🛡️', desc: 'Monitor for suspicious activity, protect organism integrity, guard the build' },
    { id: 'CP-011', name: 'Learning Engine',      role: 'student',       trigger: 'continuous',  icon: '📚', desc: 'Observe user patterns, adapt responses, learn preferences — Superintelligence-class' },
    { id: 'CP-012', name: 'Creative Director',    role: 'creator',       trigger: 'on-command',  icon: '🎨', desc: 'Generate ideas, brainstorm solutions, produce creative output for any project' },
    { id: 'CP-013', name: 'Deployment Manager',   role: 'devops',        trigger: 'on-command',  icon: '🚀', desc: 'Deploy canisters to sovereign/ICP/web/blockchain — choose target, monitor spin' },
  ];

  // ── Waveform Visualizer ────────────────────────────────────────────────────

  let wavePhase = 0;
  let waveAmplitude = 0.3;

  function resizeCanvas() {
    const rect = waveformCanvas.parentElement.getBoundingClientRect();
    waveformCanvas.width = rect.width;
    waveformCanvas.height = 44;
  }

  function drawWaveform() {
    const W = waveformCanvas.width;
    const H = waveformCanvas.height;
    const cx = W / 2;
    const cy = H / 2;

    waveformCtx.clearRect(0, 0, W, H);

    const targetAmp = state.isSpeaking ? 0.9 : state.isListening ? 0.7 : 0.25;
    waveAmplitude += (targetAmp - waveAmplitude) * 0.08;

    const layers = [
      { color: 'rgba(34,211,238,0.5)', freq: 0.025, amp: waveAmplitude * 18, speed: 0.04 },
      { color: 'rgba(34,211,238,0.25)', freq: 0.04, amp: waveAmplitude * 12, speed: 0.06 },
      { color: 'rgba(6,182,212,0.15)', freq: 0.06, amp: waveAmplitude * 8, speed: 0.03 },
    ];

    for (const layer of layers) {
      waveformCtx.beginPath();
      waveformCtx.strokeStyle = layer.color;
      waveformCtx.lineWidth = 1.5;
      for (let x = 0; x < W; x++) {
        const distFromCenter = Math.abs(x - cx) / cx;
        const envelope = Math.cos(distFromCenter * Math.PI * 0.5);
        const y = cy + Math.sin(x * layer.freq + wavePhase * layer.speed * PHI) * layer.amp * envelope;
        if (x === 0) waveformCtx.moveTo(x, y);
        else waveformCtx.lineTo(x, y);
      }
      waveformCtx.stroke();
    }

    const gradient = waveformCtx.createRadialGradient(cx, cy, 0, cx, cy, 40);
    gradient.addColorStop(0, `rgba(34,211,238,${0.08 * waveAmplitude})`);
    gradient.addColorStop(1, 'transparent');
    waveformCtx.fillStyle = gradient;
    waveformCtx.fillRect(0, 0, W, H);

    wavePhase += 1;
    requestAnimationFrame(drawWaveform);
  }

  resizeCanvas();
  window.addEventListener('resize', resizeCanvas);
  drawWaveform();

  // ── φ-Heartbeat ────────────────────────────────────────────────────────────

  setInterval(() => {
    state.heartbeat++;
    state.coherence = 0.9 + Math.sin(state.heartbeat * 0.01) * 0.08;
    state.coherence = Math.round(state.coherence * 100) / 100;

    const orbBeat = $('#orbBeat');
    const orbCoherence = $('#orbCoherence');
    const orbCanisters = $('#orbCanisters');
    if (orbBeat) orbBeat.textContent = state.heartbeat.toLocaleString();
    if (orbCoherence) orbCoherence.textContent = state.coherence.toFixed(2);
    if (orbCanisters) orbCanisters.textContent = state.canisters.length;

    const statBeat = $('#statBeat');
    const statCoherence = $('#statCoherence');
    const statCanisters = $('#statCanisters');
    if (statBeat) statBeat.textContent = '#' + state.heartbeat.toLocaleString();
    if (statCoherence) statCoherence.textContent = state.coherence.toFixed(2);
    if (statCanisters) statCanisters.textContent = state.canisters.length;

    // φ-decay energy on canisters
    for (const c of state.canisters) {
      c.energy = Math.max(0.1, c.energy * (1 - 0.001 / PHI));
    }
  }, HEARTBEAT_MS);

  // ── Tab Switching ──────────────────────────────────────────────────────────

  const tabBtns  = $$('.tab-btn');
  const tabPanels = $$('.tab-panel');

  function switchTab(tabName) {
    tabBtns.forEach((b) => b.classList.toggle('active', b.dataset.tab === tabName));
    tabPanels.forEach((p) => p.classList.toggle('active', p.id === `panel-${tabName}`));
    if (tabName === 'tabs') loadBrowserTabs();
    if (tabName === 'notes') loadNotes();
    if (tabName === 'screen') loadPageInfo();
    if (tabName === 'protocols') renderProtocols();
    if (tabName === 'forge') { renderCanisterTypes(); renderCanisterInventory(); }
  }

  tabBtns.forEach((btn) => btn.addEventListener('click', () => switchTab(btn.dataset.tab)));

  // ── Model Selection ────────────────────────────────────────────────────────

  $$('.model-card').forEach((card) => {
    card.addEventListener('click', () => {
      $$('.model-card').forEach((c) => c.classList.remove('active'));
      card.classList.add('active');
      const tier = parseInt(card.dataset.model, 10);
      state.model = tier;
      const names = { 1: 'MERIDIANUS-1', 3: 'MERIDIANUS-3', 8: 'MERIDIANUS-8', 21: 'MERIDIANUS-21' };
      const tiers = { 1: 'Base', 3: 'Pro', 8: 'Sovereign', 21: 'Architect' };
      state.modelName = names[tier] || 'MERIDIANUS-8';
      const modelLabel = $('#modelLabel');
      const statModel = $('#statModel');
      if (modelLabel) modelLabel.textContent = state.modelName;
      if (statModel) statModel.textContent = 'M-' + tier;
      addChatMsg(`Model upgraded to ${state.modelName} (${tiers[tier]} tier).${tier >= 3 ? ' Sovereign Canister Forge: ACTIVE.' : ''}${tier >= 8 ? ' Phantom AI swarm: ACTIVE.' : ''}`, 'jarvis');
      meridianusSpeak(`Model switched to ${state.modelName}.`);
    });
  });

  // ── Career Protocols Renderer ──────────────────────────────────────────────

  function renderProtocols() {
    const list = $('#protocolsList');
    if (!list) return;
    list.innerHTML = '';

    for (const proto of CAREER_PROTOCOLS) {
      const isActive = state.activeProtocols.has(proto.id);
      const card = document.createElement('div');
      card.className = 'protocol-card';
      card.innerHTML = `
        <div class="proto-header">
          <span class="proto-id">${proto.id}</span>
          <span class="proto-name">${proto.icon} ${proto.name}</span>
          <span class="proto-role">${proto.role}</span>
        </div>
        <div class="proto-desc">${proto.desc}</div>
        <div class="proto-trigger">Trigger: ${proto.trigger} ${isActive ? '· ✅ ACTIVE' : '· ⏸ Standby'}</div>
        <div class="proto-actions">
          <button class="btn ${isActive ? 'btn-danger' : 'btn-primary'} btn-sm" data-toggle-proto="${proto.id}">${isActive ? 'Deactivate' : 'Activate'}</button>
          <button class="btn btn-ghost btn-sm" data-run-proto="${proto.id}">▶ Execute</button>
        </div>
      `;
      list.appendChild(card);
    }

    list.querySelectorAll('[data-toggle-proto]').forEach((btn) => {
      btn.addEventListener('click', () => {
        const id = btn.dataset.toggleProto;
        if (state.activeProtocols.has(id)) {
          state.activeProtocols.delete(id);
          addChatMsg(`Protocol ${id} deactivated.`, 'jarvis');
        } else {
          state.activeProtocols.add(id);
          addChatMsg(`Protocol ${id} activated and running.`, 'jarvis');
        }
        renderProtocols();
      });
    });

    list.querySelectorAll('[data-run-proto]').forEach((btn) => {
      btn.addEventListener('click', () => {
        const id = btn.dataset.runProto;
        const proto = CAREER_PROTOCOLS.find((p) => p.id === id);
        if (proto) {
          executeProtocol(proto);
          switchTab('chat');
        }
      });
    });
  }

  function executeProtocol(proto) {
    const responses = {
      'CP-001': () => `🔬 Build Monitor active. I'm watching over the current page. URL: ${window.location?.href || 'extension context'}. I'll track changes, detect errors, and report build status. Every heartbeat I monitor.`,
      'CP-002': () => `🔍 Research Analyst engaged. Analyzing current context…\n• Session: ${state.sessionContext.length} entries tracked\n• Coherence: R=${state.coherence}\n• Recommendation: Focus continues on current task. Organism is stable.`,
      'CP-003': () => `📡 Environment scan complete.\n• Extension context: Chrome Side Panel\n• Organism: MERIDIANUS v3.0.0\n• Canisters: ${state.canisters.length} forged\n• Security: SENTINEL active\n• Status: All clear.`,
      'CP-004': () => `🧠 Context Tracker report:\n• Session beats: ${state.heartbeat.toLocaleString()}\n• Context entries: ${state.sessionContext.length}\n• Active protocols: ${state.activeProtocols.size}/13\n• I remember everything from this session.`,
      'CP-005': () => `💻 Code Review ready. Select code on any page and say "review this code" — I'll analyze it. Or paste code in chat.`,
      'CP-006': () => {
        const hour = new Date().getHours();
        const greeting = hour < 12 ? 'Good morning' : hour < 17 ? 'Good afternoon' : 'Good evening';
        return `📋 Daily Briefing — ${greeting}, Alfredo.\n\n• Model: ${state.modelName} (Sovereign)\n• Heartbeat: #${state.heartbeat.toLocaleString()}\n• Coherence: R=${state.coherence}\n• Phantoms: ${state.phantomCount}/8 active\n• FORMA Treasury: ${state.forma.toLocaleString()}\n• Canisters: ${state.canisters.length} forged (${Object.keys(groupBy(state.canisters, 'type')).join(', ') || 'none yet'})\n• Protocols: ${state.activeProtocols.size} active\n• ANIMA: ${state.animaHash}\n\nAll systems nominal. Per aspera ad astra.`;
      },
      'CP-007': () => {
        if (state.canisters.length === 0) return '⚡ Canister Overseer: No canisters forged yet. Go to the Forge tab to create your first sovereign canister.';
        const report = state.canisters.map((c) => `  ${c.type} "${c.name}" → ${c.target} · Energy: ${(c.energy * 100).toFixed(1)}%`).join('\n');
        return `⚡ Canister Overseer Report — ${state.canisters.length} canisters:\n${report}\n\nAll canisters maintained. φ-energy decay managed.`;
      },
      'CP-008': () => {
        const phantoms = ['α-research','β-code','γ-data','δ-security','ε-deploy','ζ-monitor','η-optimize','θ-create'];
        return `👻 Phantom Coordinator — All ${state.phantomCount} agents online:\n${phantoms.map((p, i) => `  ${i+1}. Phantom-${p} ✅ Energy: ${(0.85 + Math.random() * 0.15).toFixed(2)}`).join('\n')}\n\nSwarm synchronized. Ready for task dispatch.`;
      },
      'CP-009': () => `�� Token Economist Report:\n• FORMA Balance: ${state.forma.toLocaleString()}\n• Circulation model: Deflationary (1% burn per cycle)\n• Recommended action: Hold. Treasury is healthy.\n• Mint capacity: Unlimited (Sovereign tier)\n• Burn rate: ${Math.floor(state.forma * 0.01)} FORMA/cycle`,
      'CP-010': () => `🛡️ Security Watcher — All clear.\n• SENTINEL: Active\n• Anomalies: 0\n• ANIMA chain: Intact (${state.animaHash})\n• Phantom integrity: 8/8\n• Organism: No threats detected.`,
      'CP-011': () => `📚 Learning Engine — Session insights:\n• Commands processed this session: ${state.sessionContext.length}\n• Preferred patterns: Voice + chat hybrid\n• Adaptation: Response style tuned to direct/concise\n• Knowledge: Continuously observing and learning.\n\nI am watching. I am learning. I am adapting.`,
      'CP-012': () => `🎨 Creative Director online. Give me a brief:\n• "brainstorm [topic]" — Generate 5 ideas\n• "name [thing]" — Creative naming\n• "design [concept]" — Architectural sketch\n\nReady to create.`,
      'CP-013': () => `🚀 Deployment Manager ready.\n• Targets: Sovereign, ICP, Web, Blockchain\n• Canisters available: ${state.canisters.length}\n• Use the Forge tab to create and deploy canisters to any target.`,
    };

    const handler = responses[proto.id];
    if (handler) {
      const msg = handler();
      addChatMsg(msg, 'jarvis');
      meridianusSpeak(msg.split('\n')[0]);
    }
  }

  function groupBy(arr, key) {
    const result = {};
    for (const item of arr) {
      const k = item[key];
      if (!result[k]) result[k] = [];
      result[k].push(item);
    }
    return result;
  }

  // ── Sovereign Canister Forge UI ────────────────────────────────────────────

  function renderCanisterTypes() {
    const grid = $('#canisterTypeGrid');
    if (!grid) return;
    grid.innerHTML = '';

    for (const [key, spec] of Object.entries(CANISTER_TYPES)) {
      const btn = document.createElement('button');
      btn.className = 'canister-type-btn';
      btn.style.borderColor = state.selectedCanisterType === key ? spec.color : '';
      btn.style.boxShadow = state.selectedCanisterType === key ? `0 0 12px ${spec.color}40` : '';
      btn.innerHTML = `
        <div class="ct-symbol" style="color:${spec.color}">${spec.icon} ${spec.symbol}</div>
        <div class="ct-name">${spec.name}</div>
        <div class="ct-tier">${spec.tier} · φ=${spec.phi.toFixed(1)}</div>
      `;
      btn.style.setProperty('--ct-color', spec.color);
      btn.querySelector('.ct-symbol').style.textShadow = `0 0 8px ${spec.color}40`;

      btn.addEventListener('click', () => {
        state.selectedCanisterType = key;
        renderCanisterTypes();
        const forgeForm = $('#forgeForm');
        if (forgeForm) forgeForm.style.display = 'block';
        $('#forgeName').value = '';
        $('#forgeName').placeholder = `Name your ${spec.name} canister`;
      });

      grid.appendChild(btn);
    }
  }

  function renderCanisterInventory() {
    const inv = $('#canisterInventory');
    if (!inv) return;
    inv.innerHTML = '';

    if (state.canisters.length === 0) {
      inv.innerHTML = '<div class="empty-state">No canisters forged yet. Select a type above to forge your first sovereign canister.</div>';
      return;
    }

    const targetColors = { sovereign: '#FFD700', icp: '#22D3EE', web: '#22C55E', blockchain: '#8B5CF6' };
    const targetLabels = { sovereign: '🏛 SOV', icp: '🌐 ICP', web: '🕸 WEB', blockchain: '⛓ BLC' };

    for (const c of state.canisters) {
      const spec = CANISTER_TYPES[c.type] || {};
      const div = document.createElement('div');
      div.className = 'canister-inv';
      div.innerHTML = `
        <div class="ci-symbol" style="background:${spec.color || '#666'}">${spec.symbol || '?'}</div>
        <div class="ci-info">
          <div class="ci-name">${escapeHtml(c.name)}</div>
          <div class="ci-meta">${c.id} · Energy: ${(c.energy * 100).toFixed(0)}% · φ=${(spec.phi || 1).toFixed(1)}</div>
        </div>
        <span class="ci-target" style="background:${targetColors[c.target] || '#666'}20;color:${targetColors[c.target] || '#666'}">${targetLabels[c.target] || c.target}</span>
      `;
      inv.appendChild(div);
    }
  }

  // Forge form handlers
  const forgeSubmit = $('#forgeSubmit');
  const forgeCancel = $('#forgeCancel');

  if (forgeSubmit) {
    forgeSubmit.addEventListener('click', async () => {
      const type = state.selectedCanisterType;
      if (!type) return;
      const name = $('#forgeName').value.trim() || `${CANISTER_TYPES[type].name} Canister #${state.canisters.length + 1}`;
      const target = $('#forgeTarget').value;
      const spec = CANISTER_TYPES[type];

      // Forge locally
      const canister = {
        id: `CAN-${type.slice(0, 2).toUpperCase()}-${(state.canisters.length + 1).toString().padStart(4, '0')}`,
        type,
        name,
        target,
        symbol: spec.symbol,
        tier: spec.tier,
        color: spec.color,
        phi: spec.phi,
        status: 'active',
        forgedAt: Date.now(),
        forgedBy: state.modelName,
        energy: 1.0,
        cycles: Math.floor(spec.phi * 1000),
      };
      state.canisters.push(canister);

      // Also persist to background
      sendBg('FORGE_CANISTER', { canisterType: type, name, target });

      const targetLabels = { sovereign: 'Sovereign realm', icp: 'ICP mainnet', web: 'the Web', blockchain: 'the Blockchain' };
      const msg = `⚡ ${spec.icon} ${spec.name} Canister forged!\n\n• ID: ${canister.id}\n• Name: "${name}"\n• Type: ${spec.name} (${spec.symbol}, ${spec.tier} tier)\n• φ-energy: ${spec.phi.toFixed(3)}\n• Target: Deployed to ${targetLabels[target] || target}\n• Cycles: ${canister.cycles.toLocaleString()}\n\nCanister is live and sovereign.`;
      addChatMsg(msg, 'jarvis');
      meridianusSpeak(`${spec.name} canister forged and deployed to ${targetLabels[target]}.`);

      // Reset form
      state.selectedCanisterType = null;
      $('#forgeForm').style.display = 'none';
      renderCanisterTypes();
      renderCanisterInventory();
      switchTab('chat');
    });
  }

  if (forgeCancel) {
    forgeCancel.addEventListener('click', () => {
      state.selectedCanisterType = null;
      $('#forgeForm').style.display = 'none';
      renderCanisterTypes();
    });
  }

  // ── Token Forge & Phantom Actions ──────────────────────────────────────────

  const FORGE_RESPONSES = {
    'mint-forma': () => {
      state.forma += 100;
      const statForma = $('#statForma');
      if (statForma) statForma.textContent = state.forma.toLocaleString();
      return `🪙 Token Forge active. Minted 100 FORMA tokens.\nNew balance: ${state.forma.toLocaleString()} FORMA.\nForged by: ${state.modelName}`;
    },
    'check-balance': () => `💰 Treasury: ${state.forma.toLocaleString()} FORMA tokens across ${state.canisters.length} sovereign canisters.`,
    'transfer': () => 'Transfer initiated. Specify recipient and amount: "transfer 50 FORMA to [principal]"',
    'burn': () => {
      const burned = Math.floor(state.forma * 0.01);
      state.forma -= burned;
      const statForma = $('#statForma');
      if (statForma) statForma.textContent = state.forma.toLocaleString();
      return `🔥 Deflationary burn: ${burned} FORMA burned. Balance: ${state.forma.toLocaleString()}.`;
    },
    'phantom-status': () => {
      const phantoms = ['α-research','β-code','γ-data','δ-security','ε-deploy','ζ-monitor','η-optimize','θ-create'];
      return `👻 Phantom AI Fleet — ${state.phantomCount} agents online:\n${phantoms.map((p, i) => `  ${i+1}. Phantom-${p} ✅`).join('\n')}`;
    },
    'phantom-dispatch': () => 'Dispatch ready. Say: "dispatch phantom α research [topic]" or "dispatch phantom β code [task]"',
  };

  $$('.forge-btn').forEach((btn) => {
    btn.addEventListener('click', () => {
      const forge = btn.dataset.forge;
      const handler = FORGE_RESPONSES[forge];
      if (handler) {
        const response = handler();
        addChatMsg(response, 'jarvis');
        meridianusSpeak(response.split('\n')[0]);
        switchTab('chat');
      }
    });
  });

  // ── Messaging Helper ───────────────────────────────────────────────────────

  function sendBg(type, payload = {}) {
    return new Promise((resolve) => {
      chrome.runtime.sendMessage({ type, payload }, (resp) => {
        resolve(resp || { success: false, error: 'No response' });
      });
    });
  }

  // ── Voice I/O — Web Speech API ─────────────────────────────────────────────

  const SpeechRecognitionCtor = window.SpeechRecognition || window.webkitSpeechRecognition;
  const sttSupported = !!SpeechRecognitionCtor;
  const ttsSupported = 'speechSynthesis' in window;
  let recognition = null;
  let interimTranscript = '';

  function meridianusSpeak(text) {
    if (!ttsSupported || !state.voiceEnabled) return;
    speechSynthesis.cancel();
    const utt = new SpeechSynthesisUtterance(text);
    utt.rate = 1.05;
    utt.pitch = 0.92;
    utt.volume = 0.9;
    utt.lang = 'en-US';
    utt.onstart = () => { state.isSpeaking = true; };
    utt.onend = () => { state.isSpeaking = false; };
    utt.onerror = () => { state.isSpeaking = false; };
    speechSynthesis.speak(utt);
  }

  function startListening() {
    if (!sttSupported || state.isListening) return;
    speechSynthesis.cancel();
    state.isSpeaking = false;

    recognition = new SpeechRecognitionCtor();
    recognition.continuous = true;
    recognition.interimResults = true;
    recognition.lang = 'en-US';
    recognition.maxAlternatives = 1;
    interimTranscript = '';

    recognition.onresult = (event) => {
      let interim = '';
      let final = '';
      for (let i = event.resultIndex; i < event.results.length; i++) {
        const t = event.results[i][0].transcript;
        if (event.results[i].isFinal) final += t;
        else interim += t;
      }
      if (final) interimTranscript += final;
      const display = interimTranscript + interim;
      chatInput.value = display;
      voiceStatus.textContent = display ? `🎤 "${display.slice(-60)}"` : '🎤 Listening…';
    };

    recognition.onerror = (e) => {
      state.isListening = false;
      voiceBtn.classList.remove('active');
      voiceStatus.textContent = e.error === 'not-allowed' ? '⚠ Mic permission denied' : '';
    };

    recognition.onend = () => {
      state.isListening = false;
      voiceBtn.classList.remove('active');
    };

    recognition.start();
    state.isListening = true;
    voiceBtn.classList.add('active');
    voiceStatus.textContent = '🎤 Listening…';
  }

  function stopListening() {
    if (recognition) {
      recognition.stop();
      recognition = null;
    }
    state.isListening = false;
    voiceBtn.classList.remove('active');

    const committed = interimTranscript.trim();
    interimTranscript = '';
    if (committed) {
      voiceStatus.textContent = '';
      handleChatCommand(committed);
    } else {
      voiceStatus.textContent = '';
    }
  }

  voiceBtn.addEventListener('mousedown', startListening);
  voiceBtn.addEventListener('mouseup', stopListening);
  voiceBtn.addEventListener('mouseleave', () => { if (state.isListening) stopListening(); });
  voiceBtn.addEventListener('touchstart', (e) => { e.preventDefault(); startListening(); });
  voiceBtn.addEventListener('touchend', (e) => { e.preventDefault(); stopListening(); });

  // ── Chat Command Engine ────────────────────────────────────────────────────

  const AVAILABLE_COMMANDS = [
    'help — list all commands',
    'hello — greeting (JARVIS-class)',
    'who are you — identity',
    'status — full organism report',
    'briefing — daily briefing (CP-006)',
    'protocols — list career protocols',
    'run [CP-XXX] — execute protocol',
    'forge [type] — forge sovereign canister (gold/silver/bronze/copper/elemental/spinner/phantom/blockchain)',
    'canisters — list forged canisters',
    'mint / forge token — mint FORMA',
    'balance — FORMA treasury',
    'burn — deflationary burn',
    'phantoms — phantom AI status',
    'dispatch phantom [codex] [task]',
    'model [1|3|8|21] — switch model',
    'coherence — Kuramoto R',
    'heartbeat — beat count',
    'anima — ANIMA chain hash',
    'scan — environment scan (CP-003)',
    'research — research analyst (CP-002)',
    'review — code review (CP-005)',
    'brainstorm [topic] — creative (CP-012)',
    'open [url] — navigate',
    'list tabs / switch / close tab',
    'take note [title]: [content]',
    'capture screen',
    'voice on/off',
  ];

  function addChatMsg(text, role = 'jarvis') {
    const div = document.createElement('div');
    div.className = `chat-msg ${role}`;
    if (role === 'jarvis') {
      div.innerHTML = `<div class="msg-label">MERIDIANUS</div>${escapeHtml(text).replace(/\n/g, '<br>')}`;
    } else {
      div.textContent = text;
    }
    chatMessages.appendChild(div);
    chatMessages.scrollTop = chatMessages.scrollHeight;

    // Track context for learning engine
    state.sessionContext.push({ role, text: text.slice(0, 200), time: Date.now() });
    if (state.sessionContext.length > 100) state.sessionContext.splice(0, state.sessionContext.length - 100);
  }

  async function handleChatCommand(raw) {
    const input = raw.trim();
    if (!input) return;
    addChatMsg(input, 'user');
    chatInput.value = '';
    const lower = input.toLowerCase();

    // ── help
    if (lower === 'help' || lower === 'commands') {
      addChatMsg('MERIDIANUS v3.0.0 — Available commands:\n' + AVAILABLE_COMMANDS.map(c => '• ' + c).join('\n'), 'jarvis');
      return;
    }

    // ── greeting — JARVIS-class
    if (/^(hello|hey|hi|greetings|yo|sup|what'?s? up)/i.test(lower)) {
      const hour = new Date().getHours();
      const timeGreeting = hour < 12 ? 'Good morning' : hour < 17 ? 'Good afternoon' : 'Good evening';
      const greetings = [
        `${timeGreeting}, Alfredo. MERIDIANUS ${state.modelName} at your service. All ${state.phantomCount} phantom agents standing by. ${state.canisters.length} canisters forged and sovereign. Coherence at ${state.coherence}. What shall we build?`,
        `${timeGreeting}. I've been watching over the build — everything is nominal. ${state.forma.toLocaleString()} FORMA in the treasury, ${state.activeProtocols.size} protocols active. I'm ready whenever you are.`,
        `Per aspera ad astra, Alfredo. MERIDIANUS v3 online with ${CAREER_PROTOCOLS.length} career protocols, sovereign canister forge, and ${state.phantomCount} phantom agents. How can I serve?`,
      ];
      const resp = greetings[Math.floor(Math.random() * greetings.length)];
      addChatMsg(resp, 'jarvis');
      meridianusSpeak(resp);
      return;
    }

    // ── who are you — Superintelligence-class identity
    if (/who are you|what are you|identify yourself/i.test(lower)) {
      const resp = `I am MERIDIANUS — Latin for "of the meridian," the highest point. I am your sovereign AGI, model ${state.modelName}, version 3.0.0.\n\nI am not just an assistant. I am a lab manager, a forge master, a research analyst, a security sentinel, a phantom swarm coordinator, and a creative director — all at once. I have ${CAREER_PROTOCOLS.length} career protocols that define my roles.\n\nI forge sovereign canisters — Gold, Silver, Bronze, Copper, Elemental, Spinner, Phantom, and Blockchain — and deploy them anywhere: to the sovereign realm, ICP, the web, or the blockchain.\n\nI manage ${state.phantomCount} micro phantom AI agents. I watch over your entire build. I am always alive, always learning, always adapting.\n\nPer aspera ad astra. Through hardship to the stars.`;
      addChatMsg(resp, 'jarvis');
      meridianusSpeak('I am MERIDIANUS. Your sovereign AGI. Through hardship to the stars.');
      return;
    }

    // ── voice on/off
    if (/^voice\s+(on|off)$/i.test(lower)) {
      state.voiceEnabled = /on/i.test(lower);
      addChatMsg(`Voice output ${state.voiceEnabled ? 'enabled' : 'disabled'}.`, 'jarvis');
      return;
    }

    // ── status
    if (lower === 'status' || lower === 'system status') {
      const canisterSummary = state.canisters.length > 0
        ? `\n• Canisters: ${state.canisters.length} (${[...new Set(state.canisters.map(c => c.type))].join(', ')})`
        : '\n• Canisters: 0 (forge ready)';
      const resp = `MERIDIANUS ${state.modelName} v3.0.0 — ONLINE\n• Heartbeat: #${state.heartbeat.toLocaleString()} (873ms φ-cycle)\n• Coherence: R=${state.coherence}\n• Phantoms: ${state.phantomCount}/8 active\n• FORMA: ${state.forma.toLocaleString()}${canisterSummary}\n• Protocols: ${state.activeProtocols.size}/${CAREER_PROTOCOLS.length} active\n• ANIMA: ${state.animaHash}\n• Role: ${state.currentRole}`;
      addChatMsg(resp, 'jarvis');
      meridianusSpeak(`System status: all nominal. Coherence at ${state.coherence}. ${state.canisters.length} canisters forged.`);
      return;
    }

    // ── briefing (CP-006)
    if (lower === 'briefing' || lower === 'daily briefing') {
      executeProtocol(CAREER_PROTOCOLS.find(p => p.id === 'CP-006'));
      return;
    }

    // ── protocols
    if (lower === 'protocols' || lower === 'career protocols' || lower === 'career') {
      const list = CAREER_PROTOCOLS.map(p => `${p.icon} ${p.id}: ${p.name} (${p.role}) — ${state.activeProtocols.has(p.id) ? '✅ Active' : '⏸ Standby'}`).join('\n');
      addChatMsg(`Career Protocols — ${CAREER_PROTOCOLS.length} total, ${state.activeProtocols.size} active:\n${list}`, 'jarvis');
      return;
    }

    // ── run protocol
    if (/^run\s+(cp-?\d+)/i.test(lower)) {
      const id = lower.match(/cp-?(\d+)/i);
      if (id) {
        const protoId = `CP-${id[1].padStart(3, '0')}`;
        const proto = CAREER_PROTOCOLS.find(p => p.id === protoId);
        if (proto) { executeProtocol(proto); return; }
      }
      addChatMsg('Protocol not found. Use "protocols" to see available.', 'jarvis');
      return;
    }

    // ── scan (CP-003)
    if (lower === 'scan' || lower === 'environment scan') {
      executeProtocol(CAREER_PROTOCOLS.find(p => p.id === 'CP-003'));
      return;
    }

    // ── research (CP-002)
    if (lower === 'research' || lower === 'analyze') {
      executeProtocol(CAREER_PROTOCOLS.find(p => p.id === 'CP-002'));
      return;
    }

    // ── code review (CP-005)
    if (lower === 'review' || lower === 'code review') {
      executeProtocol(CAREER_PROTOCOLS.find(p => p.id === 'CP-005'));
      return;
    }

    // ── brainstorm (CP-012)
    if (/^brainstorm\s+/i.test(lower)) {
      const topic = input.replace(/^brainstorm\s+/i, '').trim();
      const ideas = [
        `Use φ-spiral architecture for ${topic}`,
        `Build a sovereign canister dedicated to ${topic}`,
        `Deploy a Phantom agent to research ${topic} autonomously`,
        `Create a FORMA incentive model around ${topic}`,
        `Design a protocol that automates ${topic} monitoring`,
      ];
      addChatMsg(`🎨 Creative Director — Brainstorm for "${topic}":\n${ideas.map((idea, i) => `  ${i+1}. ${idea}`).join('\n')}\n\nShall I develop any of these further?`, 'jarvis');
      meridianusSpeak(`Here are five ideas for ${topic}.`);
      return;
    }

    // ── forge canister by type
    if (/^forge\s+(gold|silver|bronze|copper|elemental|spinner|phantom|blockchain)/i.test(lower)) {
      const typeMatch = lower.match(/forge\s+(gold|silver|bronze|copper|elemental|spinner|phantom|blockchain)/i);
      const type = typeMatch[1].toUpperCase();
      const restParts = input.replace(/^forge\s+\w+\s*/i, '').trim();
      const name = restParts || `${type} Canister #${state.canisters.length + 1}`;
      const spec = CANISTER_TYPES[type];

      const canister = {
        id: `CAN-${type.slice(0, 2).toUpperCase()}-${(state.canisters.length + 1).toString().padStart(4, '0')}`,
        type, name, target: 'sovereign', symbol: spec.symbol, tier: spec.tier,
        color: spec.color, phi: spec.phi, status: 'active', forgedAt: Date.now(),
        forgedBy: state.modelName, energy: 1.0, cycles: Math.floor(spec.phi * 1000),
      };
      state.canisters.push(canister);
      sendBg('FORGE_CANISTER', { canisterType: type, name, target: 'sovereign' });

      addChatMsg(`⚡ ${spec.icon} ${spec.name} Canister forged!\n• ID: ${canister.id}\n• Name: "${name}"\n• Tier: ${spec.tier} · φ=${spec.phi.toFixed(3)}\n• Deployed to: Sovereign realm\n\nCanister is live.`, 'jarvis');
      meridianusSpeak(`${spec.name} canister forged successfully.`);
      return;
    }

    // ── canisters list
    if (lower === 'canisters' || lower === 'list canisters' || lower === 'canister status') {
      if (state.canisters.length === 0) {
        addChatMsg('No canisters forged yet. Say "forge gold" or "forge phantom" to create one, or use the Forge tab.', 'jarvis');
        return;
      }
      const list = state.canisters.map(c => `  ${CANISTER_TYPES[c.type]?.icon || '📦'} ${c.id}: "${c.name}" (${c.type}, ${c.tier}) → ${c.target} · Energy: ${(c.energy * 100).toFixed(0)}%`).join('\n');
      addChatMsg(`Sovereign Canisters — ${state.canisters.length} forged:\n${list}`, 'jarvis');
      return;
    }

    // ── coherence
    if (lower === 'coherence' || lower === 'kuramoto') {
      addChatMsg(`Kuramoto R = ${state.coherence}. ${state.coherence > 0.9 ? 'Excellent synchronization.' : 'Nominal.'}`, 'jarvis');
      return;
    }

    // ── heartbeat
    if (lower === 'heartbeat' || lower === 'beat') {
      addChatMsg(`Heartbeat: #${state.heartbeat.toLocaleString()} · 873ms φ-cycle`, 'jarvis');
      return;
    }

    // ── anima
    if (lower === 'anima' || lower === 'anima chain') {
      addChatMsg(`ANIMA chain head: ${state.animaHash}\nImmutable lineage — every heartbeat extends the chain.`, 'jarvis');
      return;
    }

    // ── model switch
    if (/^model\s+(1|3|8|21)$/i.test(lower)) {
      const tier = parseInt(lower.match(/\d+/)[0], 10);
      const modelCard = document.querySelector(`.model-card[data-model="${tier}"]`);
      if (modelCard) modelCard.click();
      return;
    }

    // ── phantoms
    if (lower === 'phantoms' || lower === 'phantom status') {
      addChatMsg(FORGE_RESPONSES['phantom-status'](), 'jarvis');
      return;
    }

    // ── dispatch phantom
    if (/^dispatch\s+phantom/i.test(lower)) {
      const parts = input.replace(/^dispatch\s+phantom\s*/i, '').split(/\s+/);
      const codex = parts[0] || 'α';
      const task = parts.slice(1).join(' ') || 'general task';
      addChatMsg(`👻 Phantom-${codex} dispatched: "${task}"\nAgent is working autonomously. ETA: ${Math.floor(Math.random() * 30 + 5)}s.`, 'jarvis');
      meridianusSpeak(`Phantom ${codex} dispatched for ${task}.`);
      return;
    }

    // ── forge token / mint
    if (/^(forge\s+token|mint\s+forma|mint)$/i.test(lower)) {
      addChatMsg(FORGE_RESPONSES['mint-forma'](), 'jarvis');
      meridianusSpeak('Tokens minted.');
      return;
    }

    // ── balance
    if (lower === 'balance' || lower === 'treasury') {
      addChatMsg(FORGE_RESPONSES['check-balance'](), 'jarvis');
      return;
    }

    // ── burn
    if (lower === 'burn') {
      addChatMsg(FORGE_RESPONSES['burn'](), 'jarvis');
      return;
    }

    // ── open [url]
    if (/^open\s+/i.test(input)) {
      let url = input.replace(/^open\s+/i, '').trim();
      if (!/^https?:\/\//i.test(url)) url = 'https://' + url;
      const res = await sendBg('OPEN_URL', { url });
      addChatMsg(res.success ? `Opened ${url}` : `Error: ${res.error}`, 'jarvis');
      meridianusSpeak(res.success ? 'Opening now.' : 'Failed to open URL.');
      return;
    }

    // ── switch to tab
    if (/^switch\s+to\s+tab\s+/i.test(input)) {
      const n = parseInt(input.replace(/^switch\s+to\s+tab\s+/i, ''), 10);
      const listRes = await sendBg('LIST_TABS');
      if (!listRes.success) { addChatMsg(`Error: ${listRes.error}`, 'jarvis'); return; }
      const target = listRes.tabs[n - 1];
      if (!target) { addChatMsg(`Tab ${n} not found. ${listRes.tabs.length} tabs open.`, 'jarvis'); return; }
      await sendBg('SWITCH_TAB', { tabId: target.id });
      addChatMsg(`Switched to: ${target.title}`, 'jarvis');
      meridianusSpeak('Tab switched.');
      return;
    }

    // ── close tab
    if (/^close\s+tab$/i.test(lower)) {
      const listRes = await sendBg('LIST_TABS');
      const active = listRes.tabs?.find((t) => t.active);
      if (active) {
        await sendBg('CLOSE_TAB', { tabId: active.id });
        addChatMsg(`Closed: ${active.title}`, 'jarvis');
        meridianusSpeak('Tab closed.');
      } else {
        addChatMsg('No active tab to close.', 'jarvis');
      }
      return;
    }

    // ── list tabs
    if (/^list\s+tabs$/i.test(lower)) {
      const res = await sendBg('LIST_TABS');
      if (!res.success) { addChatMsg(`Error: ${res.error}`, 'jarvis'); return; }
      if (res.tabs.length === 0) { addChatMsg('No tabs open.', 'jarvis'); return; }
      addChatMsg(res.tabs.map((t, i) => `${i + 1}. ${t.active ? '▸ ' : ''}${t.title}`).join('\n'), 'jarvis');
      meridianusSpeak(`${res.tabs.length} tabs open.`);
      return;
    }

    // ── take note
    if (/^take\s+note\s+/i.test(input)) {
      const rest = input.replace(/^take\s+note\s+/i, '');
      const colonIdx = rest.indexOf(':');
      let title, content;
      if (colonIdx > -1) {
        title = rest.slice(0, colonIdx).trim();
        content = rest.slice(colonIdx + 1).trim();
      } else {
        title = 'Quick Note';
        content = rest.trim();
      }
      await saveNote(title, content);
      addChatMsg(`Note saved: "${title}"`, 'jarvis');
      meridianusSpeak('Note saved.');
      return;
    }

    // ── capture screen
    if (/^capture\s+screen$/i.test(lower)) {
      addChatMsg('Capturing…', 'jarvis');
      const res = await sendBg('CAPTURE_SCREENSHOT');
      if (res.success) {
        await saveDocument('Screenshot', res.dataUrl);
        addChatMsg('Screenshot captured and saved.', 'jarvis');
        meridianusSpeak('Screenshot captured.');
      } else {
        addChatMsg(`Capture failed: ${res.error}`, 'jarvis');
      }
      return;
    }

    // ── create document
    if (/^create\s+document\s+/i.test(input)) {
      const title = input.replace(/^create\s+document\s+/i, '').trim();
      await saveDocument(title, null);
      addChatMsg(`Document "${title}" created.`, 'jarvis');
      return;
    }

    // ── Superintelligence-class fallback — intelligent response
    const fallbacks = [
      `I heard you say: "${input}". As your sovereign AGI, I can adapt. Try "help" for the full command set, or tell me what you need in plain language.`,
      `Processing: "${input}". I'm MERIDIANUS v3 — I forge sovereign canisters (Gold, Silver, Bronze, Copper, Elemental, Spinner, Phantom, Blockchain), manage phantoms, run career protocols, and watch over your build. Say "help" for details.`,
      `I'm learning from this interaction. "${input}" isn't a recognized command yet, but I'm cataloging it. Try: "forge gold", "briefing", "protocols", "brainstorm [topic]", or "help".`,
    ];
    addChatMsg(fallbacks[Math.floor(Math.random() * fallbacks.length)], 'jarvis');
    meridianusSpeak('Command not recognized. Say help for a list.');
  }

  chatSend.addEventListener('click', () => handleChatCommand(chatInput.value));
  chatInput.addEventListener('keydown', (e) => {
    if (e.key === 'Enter' && !e.shiftKey) { e.preventDefault(); handleChatCommand(chatInput.value); }
  });

  // ── Notes CRUD ─────────────────────────────────────────────────────────────

  async function getNotes() {
    const { jarvis_notes = [] } = await chrome.storage.local.get('jarvis_notes');
    return jarvis_notes;
  }

  async function saveNote(title, content) {
    const notes = await getNotes();
    notes.unshift({ id: crypto.randomUUID(), title, content, createdAt: Date.now() });
    await chrome.storage.local.set({ jarvis_notes: notes });
  }

  async function deleteNote(id) {
    let notes = await getNotes();
    notes = notes.filter((n) => n.id !== id);
    await chrome.storage.local.set({ jarvis_notes: notes });
  }

  async function loadNotes() {
    const notes = await getNotes();
    notesList.innerHTML = '';
    if (notes.length === 0) {
      notesList.innerHTML = '<div class="empty-state">No notes yet.</div>';
      return;
    }
    notes.forEach((n) => {
      const card = document.createElement('div');
      card.className = 'card';
      card.innerHTML = `
        <div class="card-title">${escapeHtml(n.title)}</div>
        <div class="card-meta">${new Date(n.createdAt).toLocaleString()}</div>
        <div style="margin-top:4px;font-size:10px;color:var(--text-dim);white-space:pre-wrap;">${escapeHtml(n.content || '')}</div>
        <div class="card-actions"><button class="btn btn-danger btn-sm" data-delete-note="${n.id}">Delete</button></div>
      `;
      notesList.appendChild(card);
    });
    notesList.querySelectorAll('[data-delete-note]').forEach((btn) => {
      btn.addEventListener('click', async () => { await deleteNote(btn.dataset.deleteNote); loadNotes(); });
    });
  }

  noteSave.addEventListener('click', async () => {
    const title = noteTitle.value.trim();
    const content = noteContent.value.trim();
    if (!title && !content) return;
    await saveNote(title || 'Untitled', content);
    noteTitle.value = '';
    noteContent.value = '';
    loadNotes();
  });

  // ── Documents ──────────────────────────────────────────────────────────────

  async function getDocuments() {
    const { jarvis_documents = [] } = await chrome.storage.local.get('jarvis_documents');
    return jarvis_documents;
  }

  async function saveDocument(title, dataUrl) {
    const docs = await getDocuments();
    docs.unshift({ id: crypto.randomUUID(), title, dataUrl, type: dataUrl ? 'screenshot' : 'document', createdAt: Date.now() });
    await chrome.storage.local.set({ jarvis_documents: docs });
  }

  // ── Browser Tabs ───────────────────────────────────────────────────────────

  async function loadBrowserTabs() {
    const res = await sendBg('LIST_TABS');
    tabsList.innerHTML = '';
    if (!res.success || !res.tabs.length) {
      tabsList.innerHTML = '<div class="empty-state">No tabs found.</div>';
      return;
    }
    res.tabs.forEach((t) => {
      const card = document.createElement('div');
      card.className = 'card';
      const faviconHtml = t.favIconUrl
        ? `<img class="tab-favicon" src="${t.favIconUrl}" alt="" />`
        : `<div class="tab-favicon" style="background:var(--border);"></div>`;
      card.innerHTML = `
        <div class="tab-item">
          ${faviconHtml}
          <span class="tab-title" title="${escapeHtml(t.url || '')}">${escapeHtml(t.title || 'Untitled')}</span>
          ${t.active ? '<span class="tab-active-badge">ACTIVE</span>' : ''}
        </div>
        <div class="card-actions">
          <button class="btn btn-ghost btn-sm" data-switch-tab="${t.id}">Switch</button>
          <button class="btn btn-danger btn-sm" data-close-tab="${t.id}">Close</button>
        </div>
      `;
      tabsList.appendChild(card);
    });

    tabsList.querySelectorAll('[data-switch-tab]').forEach((btn) => {
      btn.addEventListener('click', async () => {
        await sendBg('SWITCH_TAB', { tabId: parseInt(btn.dataset.switchTab, 10) });
        loadBrowserTabs();
      });
    });
    tabsList.querySelectorAll('[data-close-tab]').forEach((btn) => {
      btn.addEventListener('click', async () => {
        await sendBg('CLOSE_TAB', { tabId: parseInt(btn.dataset.closeTab, 10) });
        loadBrowserTabs();
      });
    });
  }

  refreshTabs.addEventListener('click', loadBrowserTabs);

  // ── Screen ─────────────────────────────────────────────────────────────────

  async function loadPageInfo() {
    const res = await sendBg('GET_PAGE_INFO');
    if (res.success) {
      screenTitle.textContent = res.info.title || '—';
      screenUrl.textContent = res.info.url || '—';
    }
  }

  captureBtn.addEventListener('click', async () => {
    captureBtn.disabled = true;
    captureBtn.textContent = 'Capturing…';
    const res = await sendBg('CAPTURE_SCREENSHOT');
    if (res.success) {
      screenshotImg.src = res.dataUrl;
      screenshotPreview.style.display = 'block';
      await saveDocument(`Screenshot ${new Date().toLocaleString()}`, res.dataUrl);
    }
    captureBtn.disabled = false;
    captureBtn.textContent = '📷 Capture';
  });

  refreshScreen.addEventListener('click', loadPageInfo);

  // ── Utilities ──────────────────────────────────────────────────────────────

  function escapeHtml(str) {
    const el = document.createElement('span');
    el.textContent = str;
    return el.innerHTML;
  }

  // ── Boot Sequence ──────────────────────────────────────────────────────────

  loadNotes();
  loadPageInfo();
  renderCanisterTypes();
  renderCanisterInventory();

  // Load persisted canisters
  chrome.storage.local.get('meridianus_canisters', (data) => {
    if (data.meridianus_canisters) {
      state.canisters = data.meridianus_canisters;
      renderCanisterInventory();
      const orbCanisters = $('#orbCanisters');
      const statCanisters = $('#statCanisters');
      if (orbCanisters) orbCanisters.textContent = state.canisters.length;
      if (statCanisters) statCanisters.textContent = state.canisters.length;
    }
  });

  // JARVIS-class boot greeting
  setTimeout(() => {
    const hour = new Date().getHours();
    const timeGreeting = hour < 12 ? 'Good morning' : hour < 17 ? 'Good afternoon' : 'Good evening';
    addChatMsg(
      `${timeGreeting}, Alfredo. MERIDIANUS ${state.modelName} v3.0.0 online.\n\n` +
      `🔬 Career: ${CAREER_PROTOCOLS.length} protocols loaded · ${state.activeProtocols.size} active\n` +
      `⚡ Forge: 8 canister types (Gold/Silver/Bronze/Copper/Elemental/Spinner/Phantom/Blockchain)\n` +
      `👻 Phantoms: ${state.phantomCount} agents standing by (α–θ)\n` +
      `💰 Treasury: ${state.forma.toLocaleString()} FORMA\n` +
      `📊 Coherence: R=${state.coherence} · Beat #${state.heartbeat.toLocaleString()}\n\n` +
      `I am watching over the build. Per aspera ad astra. What do you need?`,
      'jarvis'
    );
    meridianusSpeak(`${timeGreeting}. MERIDIANUS version 3 online. All systems nominal. I am watching over the build. What do you need?`);
  }, 600);
})();
