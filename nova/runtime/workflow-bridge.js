// nova/runtime/workflow-bridge.js
// Nova Workflow Bridge — GitHub Actions 27-workflow interface
// Triggers, monitors, and chains all 27 GitHub Actions workflows
// Serves as the real-time bridge between the Nova runtime and GitHub
// Brand: Nova by FreddyCreates

const PHI      = 1.618033988749895;
const PHI_BEAT = 873; // ms — φ-spaced workflow triggers

// ─── ALL 27 WORKFLOWS ─────────────────────────────────────────────────────
export const WORKFLOWS = {
  // ── 11 ORGANISM BILL BOTS ─────────────────────────────────────────────
  'organism-bot-aedificator':  { id:'BOT-001', slot:'F1',  fib:1,    desc:'Builder — daily+push', event:'schedule|push',       triggers:'daily+push'    },
  'organism-bot-sartor':       { id:'BOT-002', slot:'F2',  fib:1,    desc:'Packager — main+tags', event:'push|release',         triggers:'main branch'   },
  'organism-bot-medicus':      { id:'BOT-003', slot:'F3',  fib:2,    desc:'Auto-fixer — 6h',      event:'schedule',             triggers:'every 6h'      },
  'organism-bot-custos':       { id:'BOT-004', slot:'F4',  fib:3,    desc:'Guardian — 12h+PR',    event:'schedule|pull_request',triggers:'every 12h'    },
  'organism-bot-inventor':     { id:'BOT-005', slot:'F5',  fib:5,    desc:'Deps — weekly',        event:'schedule',             triggers:'Sunday'        },
  'organism-bot-scriptor':     { id:'BOT-006', slot:'F6',  fib:8,    desc:'Documenter — Saturday',event:'schedule',             triggers:'Saturday'      },
  'organism-bot-explorator':   { id:'BOT-007', slot:'F7',  fib:13,   desc:'Scanner — 8h',         event:'schedule',             triggers:'every 8h'      },
  'organism-bot-praetor':      { id:'BOT-008', slot:'F8',  fib:21,   desc:'Orchestrator — 05:00', event:'schedule|workflow_call',triggers:'calls all 7'  },
  'organism-bot-curator':      { id:'BOT-009', slot:'F9',  fib:34,   desc:'PM — Sprint milestones',event:'schedule',            triggers:'weekly'        },
  'organism-bot-legatus':      { id:'BOT-010', slot:'F10', fib:55,   desc:'Code quality',         event:'schedule|pull_request',triggers:'PR+schedule'  },
  'organism-bot-auctor':       { id:'BOT-011', slot:'F11', fib:89,   desc:'Research journal',     event:'schedule',             triggers:'weekly'        },
  // ── 14 SYSTEM BOTS ────────────────────────────────────────────────────
  'organism-build-bot':        { id:'BUILD',     slot:'F12', fib:144,  desc:'Extension packaging',  event:'push',                 triggers:'push'          },
  'organism-neural-bot':       { id:'NEURAL',    slot:'F13', fib:233,  desc:'AI architecture',      event:'push|schedule',        triggers:'push+schedule' },
  'organism-sdk-bot':          { id:'SDK',       slot:'F14', fib:377,  desc:'SDK tarballs',         event:'release',              triggers:'release'       },
  'organism-protocol-bot':     { id:'PROTOCOL',  slot:'F15', fib:610,  desc:'Protocol integrity',   event:'push',                 triggers:'push'          },
  'organism-test-bot':         { id:'TEST',      slot:'F16', fib:987,  desc:'Node 18/20/22 matrix', event:'push|pull_request',    triggers:'PR+push'       },
  'organism-docs-bot':         { id:'DOCS',      slot:'F17', fib:1597, desc:'Auto-documentation',   event:'push',                 triggers:'push'          },
  'organism-release-bot':      { id:'RELEASE',   slot:'F18', fib:2584, desc:'Production releases',  event:'push',                 triggers:'v* tags'       },
  'organism-deploy-bot':       { id:'DEPLOY',    slot:'F19', fib:4181, desc:'ICP/CF validation',    event:'push|workflow_dispatch',triggers:'push+dispatch'},
  'organism-sentinel-bot':     { id:'SENTINEL',  slot:'F20', fib:6765, desc:'Security audit',       event:'schedule|push',        triggers:'weekly+push'   },
  'organism-crawler-bot':      { id:'CRAWLER',   slot:'F21', fib:10946,desc:'Web crawler',          event:'schedule',             triggers:'daily'         },
  'organism-economy-bot':      { id:'ECONOMY',   slot:'F22', fib:17711,desc:'Economy cycle',        event:'schedule',             triggers:'daily'         },
  'organism-governance-cycle': { id:'GOVERNANCE',slot:'F23', fib:28657,desc:'Governance cycle',     event:'schedule',             triggers:'weekly'        },
  'organism-learning-bot':     { id:'LEARNING',  slot:'F24', fib:46368,desc:'Learning cycle',       event:'schedule',             triggers:'daily'         },
  'organism-alpha-bot':        { id:'ALPHA',     slot:'F25', fib:75025,desc:'Alpha protocols',      event:'workflow_dispatch',    triggers:'manual'        },
  // ── 2 CI/CD ───────────────────────────────────────────────────────────
  'build-release':             { id:'CI',        slot:'F26', fib:121393,desc:'Build + release',     event:'push|pull_request',    triggers:'PR+push'       },
  'deploy-canister':           { id:'DEPLOY_CD', slot:'F27', fib:196418,desc:'Deploy ICP canister', event:'push|workflow_dispatch',triggers:'v* tags'     },
};

// ─── TRIGGER WORKFLOW ─────────────────────────────────────────────────────
export async function triggerWorkflow(name, opts = {}) {
  const wf = WORKFLOWS[name];
  if (!wf) {
    return {
      success: false,
      error:   `Workflow '${name}' not found`,
      known:   Object.keys(WORKFLOWS).length,
    };
  }

  const {
    ref    = 'main',
    inputs = {},
    token  = process.env.GITHUB_TOKEN,
    owner  = process.env.GITHUB_OWNER || 'FreddyCreates',
    repo   = process.env.GITHUB_REPO  || 'command-platform',
  } = opts;

  if (!token) {
    return {
      success: false,
      dry_run: true,
      workflow: name,
      meta: wf,
      would_call: `POST /repos/${owner}/${repo}/actions/workflows/${name}.yml/dispatches`,
      body: JSON.stringify({ ref, inputs }),
      note: 'Set GITHUB_TOKEN env var to trigger real workflows',
    };
  }

  const url = `https://api.github.com/repos/${owner}/${repo}/actions/workflows/${name}.yml/dispatches`;
  try {
    const res = await fetch(url, {
      method:  'POST',
      headers: {
        'Authorization': `Bearer ${token}`,
        'Accept':        'application/vnd.github+json',
        'Content-Type':  'application/json',
      },
      body: JSON.stringify({ ref, inputs }),
    });
    return { success: res.status === 204, status: res.status, workflow: name, ref, phi: PHI };
  } catch(e) {
    return { success: false, error: e.message, workflow: name };
  }
}

// ─── PHI-CHAIN: Trigger workflows at φ-beat intervals ────────────────────
export async function phiChain(workflows, opts = {}) {
  const results = [];
  for (let i = 0; i < workflows.length; i++) {
    const wf     = workflows[i];
    const delay  = Math.round(PHI_BEAT * Math.pow(PHI, i)); // φ^i × 873ms
    await sleep(delay);
    const result = await triggerWorkflow(wf, opts);
    results.push({ workflow: wf, delay_ms: delay, phi_power: i, result });
  }
  return { chain: workflows, phi: PHI, results };
}

// ─── WORKFLOW STATUS ──────────────────────────────────────────────────────
export async function workflowStatus(name, opts = {}) {
  const { token = process.env.GITHUB_TOKEN, owner = 'FreddyCreates', repo = 'command-platform' } = opts;
  if (!token) return { error: 'No GITHUB_TOKEN', workflow: name };
  const url = `https://api.github.com/repos/${owner}/${repo}/actions/workflows/${name}.yml/runs?per_page=5`;
  try {
    const res  = await fetch(url, {
      headers: { 'Authorization': `Bearer ${token}`, 'Accept': 'application/vnd.github+json' },
    });
    const data = await res.json();
    return {
      workflow: name,
      runs: (data.workflow_runs || []).map(r => ({
        id: r.id, status: r.status, conclusion: r.conclusion,
        created_at: r.created_at, html_url: r.html_url,
      })),
      phi: PHI,
    };
  } catch(e) {
    return { error: e.message, workflow: name };
  }
}

// ─── BOT FLEET ORCHESTRATION ──────────────────────────────────────────────
// Trigger all 11 organism bots in Fibonacci order (PRAETOR first, then others)
export async function orchestrateAllBots(opts = {}) {
  const bots = [
    'organism-bot-praetor',    // BOT-008 — orchestrator calls all 7 sub-bots
    'organism-bot-curator',    // BOT-009 — PM
    'organism-bot-legatus',    // BOT-010 — Code quality
    'organism-bot-auctor',     // BOT-011 — Research
  ];
  return phiChain(bots, opts);
}

// ─── REGISTRY ─────────────────────────────────────────────────────────────
export function listWorkflows() {
  return Object.entries(WORKFLOWS).map(([name, meta]) => ({
    name, file: `${name}.yml`, ...meta,
  }));
}

export function getWorkflow(name) {
  const wf = WORKFLOWS[name];
  if (!wf) return null;
  return { name, file: `${name}.yml`, ...wf };
}

// ─── SCHEDULE MAP ─────────────────────────────────────────────────────────
// Fibonacci-indexed workflow schedule — F(n) = schedule priority weight
export function scheduleMap() {
  return Object.entries(WORKFLOWS).map(([name, wf]) => ({
    workflow: name,
    fibonacci_slot: wf.slot,
    fibonacci_value: wf.fib,
    phi_weight: (1 / wf.fib).toFixed(8), // smaller fib → higher phi weight → higher priority
    trigger: wf.triggers,
  })).sort((a, b) => a.fibonacci_value - b.fibonacci_value);
}

function sleep(ms) { return new Promise(r => setTimeout(r, ms)); }

// ─── CLI ──────────────────────────────────────────────────────────────────
if (process.argv[1].endsWith('workflow-bridge.js')) {
  const [,, cmd, name] = process.argv;
  switch(cmd) {
    case 'list':
      console.log(JSON.stringify(listWorkflows().map(w => ({
        name: w.name, id: w.id, slot: w.slot, fib: w.fib, desc: w.desc
      })), null, 2));
      break;
    case 'get':
      console.log(JSON.stringify(getWorkflow(name), null, 2));
      break;
    case 'schedule':
      console.log(JSON.stringify(scheduleMap().slice(0, 11), null, 2));
      break;
    case 'trigger':
      triggerWorkflow(name||'organism-bot-praetor').then(r => console.log(JSON.stringify(r, null, 2)));
      break;
    default:
      console.log(`Nova Workflow Bridge — ${Object.keys(WORKFLOWS).length} workflows
Commands: list | get <name> | schedule | trigger <name>
Fibonacci-indexed: F1=organism-bot-aedificator ... F27=deploy-canister
φ = ${PHI}`);
  }
}
