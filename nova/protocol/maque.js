/**
 * MAQUE — Message Artifact Query Unit Exchange
 * Nova Internal Communication Protocol v0.13.0
 *
 * MAQUE is the language that the organism's components speak to each other.
 * Every message has identity (from/to 4-letter QUAD codes), intent (verb),
 * a VIVI processing thread, and an APEX artifact payload.
 *
 * No external models. No external services. Pure internal intelligence.
 */

'use strict';

import { createHmac, randomBytes } from 'node:crypto';

// ─── φ constants ────────────────────────────────────────────────────────────
const PHI       = 1.6180339887498949;
const PHI_INV   = 0.6180339887498949;
const PHI_BEAT  = 873; // ms — the organism's heartbeat

// ─── Fibonacci sequence (used for sequence numbering) ───────────────────────
const FIB = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987];

function fibSeq(n) {
  if (n < FIB.length) return FIB[n];
  let a = FIB[FIB.length - 2], b = FIB[FIB.length - 1];
  for (let i = FIB.length; i <= n; i++) { const c = a + b; a = b; b = c; }
  return b;
}

// ─── Registered QUAD codes (4-letter named artifacts) ────────────────────────
export const QUADS = {
  // Alpha AIS
  ANIM: 'ANIMUS — reasoning engine',
  LING: 'LINGUA — language engine',
  OPTI: 'OPTICA — vision engine',
  MEMO: 'MEMORIA — memory engine',
  FABR: 'FABRICA — build engine',
  PROP: 'PROPHETA — predict engine',
  VERI: 'VERITAS — truth engine',
  KOSM: 'KOSMOS — universe engine',
  TACT: 'TACTUS — somatic engine',
  NEXU: 'NEXUS — mesh engine',
  // Multimodal
  ANIN: 'ANIMUS-NOVA — reasoning+language multimodal',
  LINN: 'LINGUA-NOVA — language+audio multimodal',
  OPTN: 'OPTICA-NOVA — vision+spatial multimodal',
  TACN: 'TACTUS-NOVA — haptic+sensor multimodal',
  NEXN: 'NEXUS-NOVA — universal mesh multimodal',
  // Bots
  AEDI: 'AEDIFICATOR — builder bot',
  SART: 'SARTOR — packager bot',
  MEDI: 'MEDICUS — auto-fixer bot',
  CUST: 'CUSTOS — guardian bot',
  INVE: 'INVENTOR — dependency bot',
  SCRI: 'SCRIPTOR — documenter bot',
  EXPL: 'EXPLORATOR — scanner bot',
  PRAE: 'PRAETOR — orchestrator bot',
  CURA: 'CURATOR — PM/sprint bot',
  LEGA: 'LEGATUS — code-quality bot',
  AUCT: 'AUCTOR — research journal bot',
  // Report bots
  SALU: 'SALUS — health report bot',
  PROG: 'PROGRESSUS — progress report bot',
  COGN: 'COGNITIO — intelligence report bot',
  CREA: 'CREATOR — creator economy report bot',
  // Agents
  SOVR: 'SOVEREIGN — master agent',
  MERI: 'MERIDIANUS — architect agent',
  ORGA: 'ORGANISM — engineer agent',
  MAGI: 'MAGISTER — visionary agent',
  // Protocol
  MAQU: 'MAQUE — this protocol',
  VIVI: 'VIVI — processing vehicle',
  FLOS: 'FLOS — flow substrate',
  APEX: 'APEX — artifact format',
  GRAM: 'GRAM — registry matrix',
};

// ─── FLOS pathways ────────────────────────────────────────────────────────────
export const FLOS = {
  THINK:  ['ANIM', 'LING', 'MEMO'],
  BUILD:  ['FABR', 'AEDI', 'NEXU'],
  SEE:    ['OPTI', 'KOSM', 'NEXU'],
  FEEL:   ['TACT', 'FABR', 'MEMO'],
  TRUTH:  ['VERI', 'PROP', 'ANIM'],
  SPEAK:  ['LING', 'MEMO', 'NEXU'],
  FULL:   ['NEXU', 'ANIM', 'LING', 'OPTI', 'MEMO', 'FABR', 'PROP', 'VERI', 'KOSM', 'TACT', 'NEXU'],
  REPORT: ['ANIM', 'PROP', 'VERI', 'LING'],
};

// ─── APEX — artifact format ───────────────────────────────────────────────────
export function apex({ type, from, flosPath, viviId, seqIndex = 0, payload = {} }) {
  const seq   = fibSeq(seqIndex);
  const ts    = Date.now();
  const id    = `APEX-${from}-F${seq}-${ts}`;
  const sigData = JSON.stringify({ id, type, from, flosPath, payload, ts });
  // Signature uses internal HMAC with φ constant as seed (no external secret needed)
  const sig = createHmac('sha256', String(PHI_INV)).update(sigData).digest('hex').slice(0, 16);
  return { apex: { id, type, from, flos: flosPath, vivi: viviId, seq, phi: PHI_INV, born: new Date(ts).toISOString(), payload, signature: sig } };
}

// ─── VIVI — processing vehicle ────────────────────────────────────────────────
export function spawnVivi(initiator) {
  const id = `VIVI-${initiator}-${randomBytes(4).toString('hex')}`;
  return {
    id,
    born:      Date.now(),
    agents:    [initiator],
    history:   [],
    coherence: PHI_INV,
    depth:     0,
    alive:     true,
    phi_beat:  PHI_BEAT,
  };
}

export function advanceVivi(vivi, agent, apexArtifact) {
  return {
    ...vivi,
    agents:    [...vivi.agents, agent],
    history:   [...vivi.history, apexArtifact],
    depth:     vivi.depth + 1,
    coherence: (vivi.coherence + PHI_INV) / PHI,   // re-normalize toward φ⁻¹
    alive:     true,
  };
}

export function closeVivi(vivi) {
  return { ...vivi, alive: false, closed: Date.now() };
}

// ─── MAQUE message ────────────────────────────────────────────────────────────
export function message({ from, to, verb, via, vivi, seqIndex = 0, body = {} }) {
  if (!QUADS[from]) throw new Error(`Unknown QUAD: ${from}`);
  if (!QUADS[to])   throw new Error(`Unknown QUAD: ${to}`);

  const ts  = Date.now();
  const seq = fibSeq(seqIndex);
  const phi = Math.round(ts / PHI_BEAT) * PHI_BEAT;  // align to PHI_BEAT grid

  return {
    maque: {
      version: '0.13.0',
      from,
      to,
      verb,            // 'query' | 'respond' | 'notify' | 'route' | 'report'
      via,             // FLOS pathway name
      vivi:  vivi?.id ?? null,
      phi,
      seq,
      ts,
      body,
    },
  };
}

// ─── Route — send a MAQUE message through the FLOS pathway ───────────────────
/**
 * route(msg, handlers) — walks the FLOS pathway, calling each handler in turn.
 *
 * handlers is an object keyed by QUAD code. Each handler receives (msg, vivi)
 * and returns { result, vivi } or a Promise thereof.
 *
 * @param {object} msg     - MAQUE message
 * @param {object} vivi    - active VIVI thread
 * @param {object} handlers - { QUAD: async (msg, vivi) => { result, vivi } }
 * @returns {Promise<{ results: object[], vivi: object }>}
 */
export async function route(msg, vivi, handlers = {}) {
  const pathway = FLOS[msg.maque.via] ?? [];
  const results = [];
  let   live    = vivi;
  let   current = msg;

  for (const quad of pathway) {
    const handler = handlers[quad];
    if (!handler) continue;

    const out = await handler(current, live);
    const art = apex({
      type:     'route-step',
      from:      quad,
      flosPath:  msg.maque.via,
      viviId:    live.id,
      seqIndex:  live.depth,
      payload:   out.result ?? {},
    });

    live    = advanceVivi(live, quad, art.apex);
    results.push({ quad, result: out.result, apex: art.apex });

    // Carry the last result as the body for the next handler
    current = message({
      from:     quad,
      to:       pathway[pathway.indexOf(quad) + 1] ?? msg.maque.from,
      verb:     'route',
      via:      msg.maque.via,
      vivi:     live,
      seqIndex: live.depth,
      body:     out.result ?? {},
    });
  }

  return { results, vivi: closeVivi(live) };
}

// ─── CLI self-test ────────────────────────────────────────────────────────────
if (process.argv[1] && process.argv[1].endsWith('maque.js')) {
  console.log('MAQUE protocol self-test\n');

  const vivi = spawnVivi('ANIM');
  const msg  = message({ from: 'ANIM', to: 'LING', verb: 'query', via: 'THINK', vivi, body: { input: 'test' } });
  const art  = apex({ type: 'paper', from: 'AUCT', flosPath: 'THINK', viviId: vivi.id, seqIndex: 11, payload: { title: 'Paper VIII' } });

  console.log('VIVI:', JSON.stringify(vivi, null, 2));
  console.log('\nMAQUE message:', JSON.stringify(msg, null, 2));
  console.log('\nAPEX artifact:', JSON.stringify(art, null, 2));
  console.log('\nRegistered QUADs:', Object.keys(QUADS).length);
  console.log('FLOS pathways:', Object.keys(FLOS).length);
  console.log('\nMAQUE v0.13.0 — internal communication protocol active.');
}
