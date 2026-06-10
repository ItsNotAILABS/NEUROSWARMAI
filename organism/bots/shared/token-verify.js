/**
 * token-verify.js — Organism Token Gate
 * (Latin: "Custodia Tessarae")
 *
 * Verifies MERIDIANUS organism sub-token balances against the ICP canister
 * and maps them to bot access tiers.
 *
 * Sub-token tier map (organism_token sub-tokens):
 *   CHR (CHROMIA)  — Tier 1: Basic Slack + Telegram ambient bots
 *   SCB (SCAFFOLD) — Tier 2: + Airport bots (AERIS, TERMINI)
 *   ARC (ARCANUM)  — Tier 3: + Full ambient fleet
 *   NXS (NEXUS)    — Tier 4: + Baggage/Lounge (premium)
 *   SWM (SWARM)    — Tier 5: + Multi-user team Slack fleet
 *   PHT (PHANTOM)  — Tier 6: + All bots + private instances
 *   ORS (ORISON)   — Tier 7: + Custom bot creation
 *   GOL (GOLDEN)   — Tier 8: Sovereign — all bots, all domains
 *
 * Usage (inside a Cloudflare Worker):
 *   import { verifyToken } from './shared/token-verify.js';
 *   const { ok, tier, symbol } = await verifyToken(tokenId, env);
 *
 * Environment variables required (set in wrangler.toml secrets):
 *   ICP_CANISTER_URL — e.g. "https://command-platform.caffeine.ai"
 *   ICP_TOKEN_CANISTER_ID — organism_token canister ID
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

const PHI     = 1.618033988749895;
const PHI_INV = 1 / PHI;

// Sub-token symbols ordered by tier (ascending privilege)
const TOKEN_TIERS = [
  { symbol: 'CHR', name: 'CHROMIA',  tier: 1, label: 'Basic' },
  { symbol: 'SCB', name: 'SCAFFOLD', tier: 2, label: 'Airport Alpha' },
  { symbol: 'ARC', name: 'ARCANUM',  tier: 3, label: 'Full Ambient' },
  { symbol: 'NXS', name: 'NEXUS',    tier: 4, label: 'Premium' },
  { symbol: 'SWM', name: 'SWARM',    tier: 5, label: 'Team' },
  { symbol: 'PHT', name: 'PHANTOM',  tier: 6, label: 'Phantom' },
  { symbol: 'ORS', name: 'ORISON',   tier: 7, label: 'Creator' },
  { symbol: 'GOL', name: 'GOLDEN',   tier: 8, label: 'Sovereign' },
];

// Bot feature flags by minimum tier
const BOT_TIERS = {
  'slack-status':    1,
  'slack-deploy':    1,
  'slack-ask':       1,
  'slack-forecast':  1,
  'slack-run':       1,
  'ambient-vigil':   1,
  'ambient-pulse':   1,
  'airport-aeris':   2,
  'airport-termini': 2,
  'ambient-praeco':  3,
  'ambient-mercator':3,
  'airport-lugendi': 4,
  'airport-lounge':  4,
  'slack-team':      5,
  'phantom-all':     6,
  'custom-bot':      7,
  'sovereign-all':   8,
};

/**
 * Verify a token ID against the ICP canister and return the access tier.
 * Falls back to a mock response when ICP_CANISTER_URL is not configured
 * (development / alpha mode).
 *
 * @param {string} tokenId  — raw token string provided by the user
 * @param {object} env      — Cloudflare Worker env bindings
 * @returns {{ ok: boolean, tier: number, symbol: string, name: string, label: string, phi: number }}
 */
export async function verifyToken(tokenId, env) {
  // Alpha mode: if no canister URL is configured, allow CHR tier for any token
  if (!env || !env.ICP_CANISTER_URL) {
    const alphaEntry = TOKEN_TIERS[0];
    return { ok: true, tier: alphaEntry.tier, symbol: alphaEntry.symbol, name: alphaEntry.name, label: alphaEntry.label, mode: 'alpha', phi: PHI };
  }

  try {
    const url = `${env.ICP_CANISTER_URL}/api/token/verify`;
    const res = await fetch(url, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json', 'X-Organism-Token': tokenId },
      body: JSON.stringify({ tokenId }),
    });

    if (!res.ok) {
      return { ok: false, tier: 0, symbol: 'NONE', name: 'none', label: 'No Access', phi: PHI };
    }

    const data = await res.json();
    const entry = TOKEN_TIERS.find(t => t.symbol === (data.symbol || '').toUpperCase());
    if (!entry) {
      return { ok: false, tier: 0, symbol: 'UNKNOWN', name: 'unknown', label: 'Invalid Token', phi: PHI };
    }

    return { ok: true, tier: entry.tier, symbol: entry.symbol, name: entry.name, label: entry.label, phi: PHI };
  } catch {
    return { ok: false, tier: 0, symbol: 'ERROR', name: 'error', label: 'Verification Error', phi: PHI };
  }
}

/**
 * Check if a given tier can access a specific bot feature.
 *
 * @param {number} tier     — caller's tier (1–8)
 * @param {string} feature  — key from BOT_TIERS
 * @returns {boolean}
 */
export function canAccess(tier, feature) {
  const minTier = BOT_TIERS[feature] ?? 8;
  return tier >= minTier;
}

/**
 * Build a φ-weighted access summary for a tier.
 * Useful for /status and /forecast responses.
 *
 * @param {number} tier
 * @returns {{ tier: number, features: string[], phi_weight: number }}
 */
export function tierSummary(tier) {
  const features = Object.entries(BOT_TIERS)
    .filter(([, minTier]) => tier >= minTier)
    .map(([feature]) => feature);
  return {
    tier,
    features,
    phi_weight: +(Math.pow(PHI_INV, 8 - tier)).toFixed(6),
    TOKEN_TIERS,
  };
}

export { TOKEN_TIERS, BOT_TIERS, PHI, PHI_INV };
