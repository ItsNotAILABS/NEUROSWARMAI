/**
 * Meridianus Security Adapter — TypeScript/JavaScript SDK
 *
 * Drop-in security layer for any ICP dApp or web app.
 * Powered by the Medina φ-doctrine: Fibonacci rate gates,
 * φ-deviation bot scoring, and zero-cycle canister rejection.
 *
 * Copyright © 2024-2026 Alfredo Medina Hernandez. All Rights Reserved.
 * Framework: Medina Doctrine
 *
 * ─── QUICK START ────────────────────────────────────────────────────────────
 *
 *   import { SecurityAdapter } from './index';
 *
 *   const sec = new SecurityAdapter({
 *     canisterId: 'YOUR_CANISTER_ID_HERE',
 *     identity: yourIdentity,          // from @dfinity/agent or @dfinity/auth-client
 *   });
 *
 *   const verdict = await sec.checkCaller();
 *   if (!verdict.allowed) throw new Error(`Blocked: ${verdict.reason}`);
 *
 * ─── OR — HTTP-ONLY (no ICP setup needed) ───────────────────────────────────
 *
 *   const sec = new SecurityAdapter({ cloudflareUrl: 'https://your-worker.workers.dev' });
 *   const verdict = await sec.checkHttp('user-id-or-ip');
 *
 * ────────────────────────────────────────────────────────────────────────────
 */

// ── Types ──────────────────────────────────────────────────────────────────

export interface SecurityVerdict {
  allowed: boolean;
  /** 0.0 = clean, 1.0 = certain bot. Threshold = φ⁻¹ = 0.618 */
  score: number;
  /** 'clean' | 'phi_elevated' | 'rate_exceeded' | 'blacklisted' | 'phi_blacklisted' | 'gate_closed' */
  reason: string;
  callerRate: number;
  layer: string;
}

export interface SecurityStatus {
  totalChecked: bigint;
  totalAllowed: bigint;
  totalRejected: bigint;
  blacklistSize: number;
  activeCallers: number;
  coherence: number;
  gateOpen: boolean;
  phiInv: number;
  doctrine: string;
}

export interface Thresholds {
  maxRate: number;
  windowSeconds: number;
  phiInv: number;
  botFlagThreshold: number;
  blacklistDurationMins: number;
  fibonacciSequence: string;
}

export interface SecurityAdapterConfig {
  /** Canister ID of the deployed security_adapter canister */
  canisterId?: string;
  /** ICP identity (from @dfinity/auth-client, @dfinity/agent, etc.) */
  identity?: unknown;
  /** ICP host — defaults to mainnet */
  host?: string;
  /** Cloudflare worker URL for REST-only usage */
  cloudflareUrl?: string;
  /** If true, logs security events to console */
  debug?: boolean;
}

// Candid IDL factory — inline so no separate .did.js file is required
const idlFactory = ({ IDL }: { IDL: Record<string, unknown> & {
  Record: (fields: Record<string, unknown>) => unknown;
  Text: unknown;
  Bool: unknown;
  Float64: unknown;
  Nat: unknown;
  Nat64: unknown;
  Principal: unknown;
  Service: (methods: Record<string, unknown>) => unknown;
  Func: (args: unknown[], rets: unknown[], annotations?: string[]) => unknown;
} }) => {
  const SecurityVerdict = IDL.Record({
    allowed    : IDL.Bool,
    score      : IDL.Float64,
    reason     : IDL.Text,
    callerRate : IDL.Nat,
    layer      : IDL.Text,
  });
  const SecurityStatus = IDL.Record({
    totalChecked  : IDL.Nat64,
    totalAllowed  : IDL.Nat64,
    totalRejected : IDL.Nat64,
    blacklistSize : IDL.Nat,
    activeCallers : IDL.Nat,
    coherence     : IDL.Float64,
    gateOpen      : IDL.Bool,
    phiInv        : IDL.Float64,
    doctrine      : IDL.Text,
  });
  const Thresholds = IDL.Record({
    maxRate               : IDL.Nat,
    windowSeconds         : IDL.Nat,
    phiInv                : IDL.Float64,
    botFlagThreshold      : IDL.Nat,
    blacklistDurationMins : IDL.Nat,
    fibonacciSequence     : IDL.Text,
  });
  const RateResult = IDL.Record({ allowed: IDL.Bool, count: IDL.Nat, maxAllowed: IDL.Nat });
  const ReportResult = IDL.Record({ accepted: IDL.Bool });
  const UnblockResult = IDL.Record({ removed: IDL.Bool });

  return IDL.Service({
    checkCaller  : IDL.Func([], [SecurityVerdict], []),
    rateCheck    : IDL.Func([], [RateResult], []),
    reportBot    : IDL.Func([IDL.Principal, IDL.Text], [ReportResult], []),
    isBlocked    : IDL.Func([IDL.Principal], [IDL.Bool], ['query']),
    getStatus    : IDL.Func([], [SecurityStatus], ['query']),
    getThresholds: IDL.Func([], [Thresholds], ['query']),
    setGate      : IDL.Func([IDL.Bool], [], []),
    unblock      : IDL.Func([IDL.Principal], [UnblockResult], []),
    resetCaller  : IDL.Func([IDL.Principal], [UnblockResult], []),
  });
};

// ── Constants ──────────────────────────────────────────────────────────────

const PHI     = 1.6180339887498948482;
const PHI_INV = 0.6180339887498948482;
const DEFAULT_HOST = 'https://ic0.app';

// ── SecurityAdapter class ──────────────────────────────────────────────────

export class SecurityAdapter {
  private config: SecurityAdapterConfig;
  private actor: Record<string, (...args: unknown[]) => Promise<unknown>> | null = null;

  // In-browser rate tracking (mirrors L2 logic from useEdgeSecurity.ts)
  private sessionRateCount = 0;
  private sessionWindowStart = Date.now();
  private readonly SESSION_WINDOW_MS = 60_000;
  private readonly SESSION_MAX_RATE = 89; // Fibonacci F11

  constructor(config: SecurityAdapterConfig) {
    this.config = {
      host: DEFAULT_HOST,
      debug: false,
      ...config,
    };
  }

  // ── ICP canister methods ─────────────────────────────────────────────────

  /**
   * Initialize the ICP actor. Called automatically on first canister call.
   * Requires @dfinity/agent to be available.
   */
  private async getActor(): Promise<Record<string, (...args: unknown[]) => Promise<unknown>>> {
    if (this.actor) return this.actor;
    if (!this.config.canisterId) {
      throw new Error('[SecurityAdapter] canisterId is required for ICP canister calls');
    }

    // Dynamic import so the SDK works in environments without @dfinity/agent
    const { HttpAgent, Actor } = await import(/* webpackIgnore: true */ '@dfinity/agent');
    const agent = await HttpAgent.create({
      identity: this.config.identity as Parameters<typeof HttpAgent.create>[0]['identity'],
      host: this.config.host,
    });

    // Fetch root key on local replica
    if (this.config.host?.includes('localhost') || this.config.host?.includes('127.0.0.1')) {
      await agent.fetchRootKey();
    }

    this.actor = Actor.createActor(idlFactory, {
      agent,
      canisterId: this.config.canisterId,
    }) as Record<string, (...args: unknown[]) => Promise<unknown>>;

    return this.actor;
  }

  /**
   * PRIMARY: Check the calling principal against the φ-security gate.
   *
   * This is the main function. Call it at the start of any action
   * you want to protect from bots.
   *
   * The calling identity's principal is evaluated against:
   *   - Rate limit: 89 calls/60s (Fibonacci F11)
   *   - φ-deviation scoring: score > 0.618 = suspicious
   *   - Blacklist: auto-applied after 21 bot flags (Fibonacci F8)
   *
   * @returns SecurityVerdict — check verdict.allowed before proceeding
   */
  async checkCaller(): Promise<SecurityVerdict> {
    // L2: browser-local rate check first (no network needed)
    const browserCheck = this.browserRateCheck();
    if (!browserCheck.allowed) {
      this.log('blocked at L2 browser gate', browserCheck);
      return {
        allowed: false,
        score: 1.0,
        reason: 'browser_rate_exceeded',
        callerRate: browserCheck.count,
        layer: 'L2_BROWSER',
      };
    }

    // L3: ICP canister check
    try {
      const actor = await this.getActor();
      const verdict = await actor['checkCaller']() as SecurityVerdict;
      this.log('canister verdict', verdict);
      return verdict;
    } catch (err) {
      this.log('canister call failed, falling back to browser-only', err);
      return {
        allowed: browserCheck.allowed,
        score: browserCheck.score,
        reason: 'canister_unreachable_browser_gate_applied',
        callerRate: browserCheck.count,
        layer: 'L2_BROWSER_FALLBACK',
      };
    }
  }

  /**
   * Lightweight rate-only check. Cheaper than checkCaller().
   * No φ-scoring, just: "did this caller call too often?"
   */
  async rateCheck(): Promise<{ allowed: boolean; count: number; maxAllowed: number }> {
    const actor = await this.getActor();
    const result = await actor['rateCheck']() as { allowed: boolean; count: bigint; maxAllowed: bigint };
    return {
      allowed: result.allowed,
      count: Number(result.count),
      maxAllowed: Number(result.maxAllowed),
    };
  }

  /**
   * Report a suspicious principal you detected in your own dApp.
   * Each report increments their flag counter. At 21 flags they are
   * automatically blacklisted for 10 minutes.
   *
   * @param suspectPrincipal — the Principal object from @dfinity/agent
   * @param evidence         — short description e.g. "ddos", "injection_attempt"
   */
  async reportBot(suspectPrincipal: unknown, evidence: string): Promise<{ accepted: boolean }> {
    const actor = await this.getActor();
    return await actor['reportBot'](suspectPrincipal, evidence) as { accepted: boolean };
  }

  /**
   * Query (free, no cycles) — check if a principal is blacklisted.
   */
  async isBlocked(principal: unknown): Promise<boolean> {
    const actor = await this.getActor();
    return await actor['isBlocked'](principal) as boolean;
  }

  /**
   * Query (free, no cycles) — get full system metrics for a dashboard.
   */
  async getStatus(): Promise<SecurityStatus> {
    const actor = await this.getActor();
    return await actor['getStatus']() as SecurityStatus;
  }

  /**
   * Query (free, no cycles) — get the security thresholds.
   */
  async getThresholds(): Promise<Thresholds> {
    const actor = await this.getActor();
    return await actor['getThresholds']() as Thresholds;
  }

  // ── HTTP / REST methods (no ICP setup needed) ────────────────────────────

  /**
   * Check security via the Cloudflare REST bridge (no ICP agent needed).
   * Uses VIGILIA + UMBRA edge workers running on your Cloudflare deployment.
   *
   * Perfect for:
   *   - Non-ICP web apps that want the φ-scoring logic
   *   - Quick testing before setting up the canister
   *   - Edge-only protection without on-chain calls
   *
   * @param callerId — any string identifier (IP, user ID, session ID, etc.)
   */
  async checkHttp(callerId: string): Promise<SecurityVerdict> {
    if (!this.config.cloudflareUrl) {
      throw new Error('[SecurityAdapter] cloudflareUrl is required for HTTP checks');
    }
    const url = `${this.config.cloudflareUrl}/security/check`;
    const res = await fetch(url, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ callerId }),
    });
    if (!res.ok) {
      throw new Error(`[SecurityAdapter] HTTP check failed: ${res.status} ${res.statusText}`);
    }
    return await res.json() as SecurityVerdict;
  }

  /**
   * Get system status via the Cloudflare REST bridge.
   */
  async getStatusHttp(): Promise<SecurityStatus> {
    if (!this.config.cloudflareUrl) {
      throw new Error('[SecurityAdapter] cloudflareUrl is required for HTTP checks');
    }
    const res = await fetch(`${this.config.cloudflareUrl}/security/status`);
    if (!res.ok) throw new Error(`[SecurityAdapter] Status fetch failed: ${res.status}`);
    return await res.json() as SecurityStatus;
  }

  // ── Browser-local L2 gate ────────────────────────────────────────────────

  /**
   * In-browser φ-rate check. Runs synchronously with zero network calls.
   * Mirrors the L2 useEdgeSecurity.ts hook logic.
   */
  browserRateCheck(): { allowed: boolean; count: number; score: number } {
    const now = Date.now();
    if (now - this.sessionWindowStart > this.SESSION_WINDOW_MS) {
      this.sessionWindowStart = now;
      this.sessionRateCount = 0;
    }
    this.sessionRateCount += 1;
    const score = Math.abs(this.sessionRateCount - 5) / (5 + 1); // φ-deviation vs baseline=5
    const allowed = this.sessionRateCount <= this.SESSION_MAX_RATE;
    return { allowed, count: this.sessionRateCount, score: Math.min(score, 1.0) };
  }

  // ── Utilities ────────────────────────────────────────────────────────────

  /** Returns the φ constants used by the security doctrine. */
  getConstants() {
    return {
      phi: PHI,
      phiInv: PHI_INV,
      maxRate: 89,       // F11
      flagLimit: 21,     // F8
      windowMs: 60_000,
      blacklistMs: 600_000,
    };
  }

  /** Disconnect and clear the actor instance (e.g. on logout). */
  disconnect() {
    this.actor = null;
    this.sessionRateCount = 0;
    this.sessionWindowStart = Date.now();
  }

  private log(msg: string, data?: unknown) {
    if (this.config.debug) {
      console.log(`[SecurityAdapter φ] ${msg}`, data ?? '');
    }
  }
}

// ── Standalone helper functions ────────────────────────────────────────────

/**
 * One-liner security check. Simplest possible usage.
 *
 * @example
 *   const ok = await securityCheck({ canisterId: 'xxx', identity });
 *   if (!ok) throw new Error('Bot detected');
 */
export async function securityCheck(config: SecurityAdapterConfig): Promise<boolean> {
  const adapter = new SecurityAdapter(config);
  const verdict = await adapter.checkCaller();
  return verdict.allowed;
}

/**
 * React hook wrapper (returns the full verdict + adapter instance).
 * Import separately if you need it — this file is framework-agnostic.
 */
export function createSecurityAdapter(config: SecurityAdapterConfig): SecurityAdapter {
  return new SecurityAdapter(config);
}

// Default export for CommonJS compatibility
export default SecurityAdapter;
