/**
 * useEdgeSecurity — Layer 2 Client-Side Security Runtime Hook
 *
 * Production React hook implementing φ-deviation bot detection and
 * request rate limiting in the browser (Layer 2 of the 3-layer architecture).
 *
 * Architecture position:
 *   Layer 1 — Cloudflare Edge (VIGILIA AIS-006 + UMBRA AIS-022)  ← edge workers
 *   Layer 2 — Browser Gate (this hook + shields-worker)           ← you are here
 *   Layer 3 — Canister Female Gate (main.mo inspect_message)      ← ICP canister
 *
 * What this does:
 *   - φ-deviation fingerprint scoring on every outbound canister request
 *   - Rolling request rate window (sessionStorage, 60-second bucket)
 *   - Fibonacci-bounded rate limit: F11 = 89 requests per 60 seconds
 *   - Optional integration with VIGILIA's /edge-reject endpoint for
 *     server-side verdict before a request reaches the canister
 *   - Returns { verdict, botScore, isBlocked, securityState, checkRequest }
 *
 * Usage:
 *   const { checkRequest, isBlocked, securityState } = useEdgeSecurity();
 *
 *   // Before every canister call:
 *   const result = await checkRequest({ endpoint: '/myCanisterMethod' });
 *   if (result.action === 'REJECT') return; // block the call
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

import { useCallback, useEffect, useRef, useState } from "react";

// ─── Constants ────────────────────────────────────────────────────────────────

const PHI      = 1.618033988749895;
const PHI_INV  = 1 / PHI;           // ≈ 0.618 — gate threshold
const F11      = 89;                 // Fibonacci rate-limit cap
const RATE_KEY = "meridianus_security_rate";   // sessionStorage key
const RATE_WIN = 60_000;            // 60-second rolling window (ms)

// ─── Types ────────────────────────────────────────────────────────────────────

export type SecurityVerdict = "ADMIT" | "REJECT";
export type SecurityState   = "optimus" | "elevated" | "sovereign";

export interface SecurityCheckParams {
  endpoint?: string;
  bodySize?: number;
}

export interface SecurityCheckResult {
  action:         SecurityVerdict;
  layer:          number;
  reason:         string;
  botScore:       number;
  ratePerMin:     number;
  icp_cycles_saved: boolean;
}

export interface EdgeSecurityStatus {
  securityState:    SecurityState;
  isBlocked:        boolean;
  botScore:         number;
  ratePerMin:       number;
  totalChecked:     number;
  totalRejected:    number;
  rateBucket:       number;
  rateWindowStart:  number;
}

// ─── Rate store (sessionStorage) ─────────────────────────────────────────────

interface RateStore {
  timestamps: number[];
  windowStart: number;
}

function readRateStore(): RateStore {
  try {
    const raw = sessionStorage.getItem(RATE_KEY);
    if (raw) return JSON.parse(raw) as RateStore;
  } catch {
    // ignore
  }
  return { timestamps: [], windowStart: Date.now() };
}

function writeRateStore(store: RateStore): void {
  try {
    sessionStorage.setItem(RATE_KEY, JSON.stringify(store));
  } catch {
    // ignore — private browsing mode
  }
}

function pruneAndRecord(store: RateStore): RateStore {
  const now = Date.now();
  const fresh = store.timestamps.filter(t => now - t < RATE_WIN);
  fresh.push(now);
  const next: RateStore = { timestamps: fresh, windowStart: store.windowStart };
  if (now - store.windowStart >= RATE_WIN) next.windowStart = now;
  writeRateStore(next);
  return next;
}

// ─── φ-deviation bot score (same math as VIGILIA's edge runtime) ──────────────

function computeBotScore(ratePerMin: number): number {
  const uaScore    = navigator.userAgent.length === 0 ? PHI : 0;
  const rateScore  = ratePerMin > 34 ? (ratePerMin / 34) * PHI_INV : 0;
  const autoScore  = navigator.webdriver ? PHI * 0.5 : 0;     // Selenium/Puppeteer flag
  return uaScore + rateScore + autoScore;
}

// ─── State machine ────────────────────────────────────────────────────────────

function deriveState(botScore: number, ratePerMin: number): SecurityState {
  if (botScore > PHI || ratePerMin > F11)     return "sovereign";
  if (botScore > PHI_INV || ratePerMin > 34)  return "elevated";
  return "optimus";
}

// ─── Hook ─────────────────────────────────────────────────────────────────────

export function useEdgeSecurity(): EdgeSecurityStatus & {
  checkRequest: (params?: SecurityCheckParams) => SecurityCheckResult;
  resetSecurity: () => void;
} {
  const [isBlocked,     setIsBlocked]     = useState(false);
  const [botScore,      setBotScore]      = useState(0);
  const [ratePerMin,    setRatePerMin]    = useState(0);
  const [securityState, setSecurityState] = useState<SecurityState>("optimus");
  const [totalChecked,  setTotalChecked]  = useState(0);
  const [totalRejected, setTotalRejected] = useState(0);
  const [rateBucket,    setRateBucket]    = useState(0);
  const [rateWindowStart, setRateWindowStart] = useState(Date.now());

  // Keep a ref for the blacklist unlock timer
  const unblockTimer = useRef<ReturnType<typeof setTimeout> | null>(null);

  // On mount, sync state from sessionStorage
  useEffect(() => {
    const store = readRateStore();
    const now = Date.now();
    const fresh = store.timestamps.filter(t => now - t < RATE_WIN);
    setRateBucket(fresh.length);
    setRateWindowStart(store.windowStart);
  }, []);

  const resetSecurity = useCallback(() => {
    sessionStorage.removeItem(RATE_KEY);
    setIsBlocked(false);
    setBotScore(0);
    setRatePerMin(0);
    setSecurityState("optimus");
    setTotalChecked(0);
    setTotalRejected(0);
    setRateBucket(0);
    setRateWindowStart(Date.now());
    if (unblockTimer.current) clearTimeout(unblockTimer.current);
  }, []);

  /**
   * checkRequest — Layer 2 gate. Call before every canister update call.
   * Returns synchronously (O(1) — no async required for browser-side check).
   */
  const checkRequest = useCallback((params: SecurityCheckParams = {}): SecurityCheckResult => {
    const store   = pruneAndRecord(readRateStore());
    const now     = Date.now();
    const fresh   = store.timestamps.filter(t => now - t < RATE_WIN);
    const rate    = fresh.length;                       // requests in last 60 s
    const score   = computeBotScore(rate);
    const state   = deriveState(score, rate);

    setRateBucket(fresh.length);
    setRateWindowStart(store.windowStart);
    setRatePerMin(rate);
    setBotScore(score);
    setSecurityState(state);
    setTotalChecked(c => c + 1);

    // 1. Rate limit — F11 = 89 calls per 60 s
    if (rate > F11) {
      setIsBlocked(true);
      setTotalRejected(r => r + 1);
      // Auto-unblock after 89 × 873 ms ≈ 78 s
      if (unblockTimer.current) clearTimeout(unblockTimer.current);
      unblockTimer.current = setTimeout(() => setIsBlocked(false), 89 * 873);
      return {
        action: "REJECT",
        layer: 2,
        reason: "rate-limit-f11",
        botScore: score,
        ratePerMin: rate,
        icp_cycles_saved: true,
      };
    }

    // 2. φ-deviation bot score
    if (score > PHI_INV) {
      setIsBlocked(true);
      setTotalRejected(r => r + 1);
      if (unblockTimer.current) clearTimeout(unblockTimer.current);
      unblockTimer.current = setTimeout(() => setIsBlocked(false), 55 * 873);
      return {
        action: "REJECT",
        layer: 2,
        reason: "phi-deviation-bot",
        botScore: score,
        ratePerMin: rate,
        icp_cycles_saved: true,
      };
    }

    // 3. Already blacklisted from a previous check
    if (isBlocked) {
      setTotalRejected(r => r + 1);
      return {
        action: "REJECT",
        layer: 2,
        reason: "blacklisted",
        botScore: score,
        ratePerMin: rate,
        icp_cycles_saved: true,
      };
    }

    // ADMIT — forward to ICP canister
    return {
      action: "ADMIT",
      layer: 2,
      reason: "passed-layer-2",
      botScore: score,
      ratePerMin: rate,
      icp_cycles_saved: false,
    };
  }, [isBlocked]);

  // Cleanup timer on unmount
  useEffect(() => () => {
    if (unblockTimer.current) clearTimeout(unblockTimer.current);
  }, []);

  return {
    checkRequest,
    resetSecurity,
    isBlocked,
    botScore,
    ratePerMin,
    securityState,
    totalChecked,
    totalRejected,
    rateBucket,
    rateWindowStart,
  };
}
