// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  MERIDIANUS SECURITY ADAPTER — PUBLIC ICP CANISTER                                                        ║
// ║  Copyright © 2024-2026 Alfredo Medina Hernandez. All Rights Reserved.                                    ║
// ║  Framework: Medina Doctrine                                                                               ║
// ║                                                                                                           ║
// ║  PURPOSE: Open adapter canister that any ICP developer can call into.                                     ║
// ║  Exposes the Medina φ-security doctrine as a clean public API:                                            ║
// ║    • φ-deviation bot scoring (Fibonacci rate windows)                                                     ║
// ║    • Automatic blacklisting after F8=21 bot flags                                                         ║
// ║    • inspect_message pre-flight gate (zero cycles on rejection)                                           ║
// ║    • Cross-canister call support (any ICP canister can call us)                                           ║
// ║                                                                                                           ║
// ║  HOW TO USE:                                                                                              ║
// ║    In your Motoko canister:                                                                               ║
// ║      let sec = actor("ADAPTER_CANISTER_ID") : actor {                                                     ║
// ║        checkCaller : () -> async SecurityVerdict                                                          ║
// ║      };                                                                                                   ║
// ║      let verdict = await sec.checkCaller();                                                               ║
// ║      if (not verdict.allowed) Runtime.trap("bot: " # verdict.reason);                                    ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

import Text      "mo:core/Text";
import Time      "mo:core/Time";
import Nat       "mo:core/Nat";
import Nat64     "mo:core/Nat64";
import Float     "mo:core/Float";
import Int       "mo:core/Int";
import Array     "mo:core/Array";
import Principal "mo:core/Principal";
import Runtime   "mo:core/Runtime";
import Bool      "mo:core/Bool";

actor {

  // ═══════════════════════════════════════════════════════════════════════════
  // MEDINA φ-DOCTRINE CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════

  let PHI     : Float = 1.6180339887498948482;  // Golden ratio
  let PHI_INV : Float = 0.6180339887498948482;  // φ⁻¹ — coherence threshold

  // Fibonacci gate constants
  let MAX_RATE          : Nat = 89;                     // F11 — max calls per 60s window
  let BOT_FLAG_LIMIT    : Nat = 21;                     // F8  — flags before blacklist
  let MAX_RATE_TABLE    : Nat = 144;                    // F12 — max tracked callers
  let MAX_BLACKLIST     : Nat = 89;                     // F11 — max blacklisted entries

  // Time constants (nanoseconds)
  let WINDOW_NS         : Int = 60_000_000_000;         // 60 seconds
  let BLACKLIST_NS      : Int = 600_000_000_000;        // 10 minutes

  // ═══════════════════════════════════════════════════════════════════════════
  // PUBLIC TYPES — copied into your canister or used via Candid
  // ═══════════════════════════════════════════════════════════════════════════

  /// The result of calling checkCaller().
  /// allowed=false means the caller is a bot or rate-limited.
  /// score: 0.0 = clean, 1.0 = certain bot. Threshold = φ⁻¹ = 0.618.
  public type SecurityVerdict = {
    allowed    : Bool;
    score      : Float;
    reason     : Text;
    callerRate : Nat;
    layer      : Text;
  };

  /// Full system metrics — returned by getStatus() (free query, no cycles).
  public type SecurityStatus = {
    totalChecked   : Nat64;
    totalAllowed   : Nat64;
    totalRejected  : Nat64;
    blacklistSize  : Nat;
    activeCallers  : Nat;
    coherence      : Float;
    gateOpen       : Bool;
    phiInv         : Float;
    doctrine       : Text;
  };

  /// Threshold configuration — returned by getThresholds() (free query).
  public type Thresholds = {
    maxRate                : Nat;
    windowSeconds          : Nat;
    phiInv                 : Float;
    botFlagThreshold       : Nat;
    blacklistDurationMins  : Nat;
    fibonacciSequence      : Text;
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // INTERNAL STABLE TYPES
  // ═══════════════════════════════════════════════════════════════════════════

  type RateEntry = {
    who        : Text;  // Principal.toText()
    count      : Nat;   // calls in current window
    windowStart: Int;   // nanosecond timestamp of window start
    flags      : Nat;   // accumulated bot-flag count
  };

  type BlackEntry = {
    who    : Text;
    reason : Text;
    until  : Int;   // nanosecond timestamp
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // STABLE STATE — persists across canister upgrades
  // ═══════════════════════════════════════════════════════════════════════════

  stable var totalChecked  : Nat64 = 0;
  stable var totalAllowed  : Nat64 = 0;
  stable var totalRejected : Nat64 = 0;
  stable var gateOpen      : Bool  = true;
  stable var emaBaseline   : Float = 5.0;   // EMA of observed call rates

  // Rate tracking table — immutable array updated via thaw/freeze
  stable var rateTable : [RateEntry] = [];

  // Blacklist table
  stable var blacklist : [BlackEntry] = [];

  // ═══════════════════════════════════════════════════════════════════════════
  // INTERNAL HELPERS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Linear scan for a rate entry by principal text. Returns the index or null.
  func findRate(who : Text) : ?Nat {
    let n = rateTable.size();
    var i = 0;
    var found : ?Nat = null;
    while (i < n and found == null) {
      if (rateTable[i].who == who) { found := ?i };
      i += 1;
    };
    found
  };

  /// Linear scan for a blacklist entry by principal text. Returns the index or null.
  func findBlack(who : Text) : ?Nat {
    let n = blacklist.size();
    var i = 0;
    var found : ?Nat = null;
    while (i < n and found == null) {
      if (blacklist[i].who == who) { found := ?i };
      i += 1;
    };
    found
  };

  /// Returns true if the principal is currently blacklisted (not expired).
  func isBlocked_(who : Text, now : Int) : Bool {
    switch (findBlack(who)) {
      case null  { false };
      case (?i)  { blacklist[i].until > now };
    }
  };

  /// Add or refresh a blacklist entry.
  func blacklistAdd(who : Text, reason : Text, now : Int) {
    let entry : BlackEntry = { who; reason; until = now + BLACKLIST_NS };
    switch (findBlack(who)) {
      case (?i) {
        let buf = Array.thaw<BlackEntry>(blacklist);
        buf[i] := entry;
        blacklist := Array.freeze(buf);
      };
      case null {
        if (blacklist.size() < MAX_BLACKLIST) {
          blacklist := Array.append(blacklist, [entry]);
        } else {
          // Evict the oldest entry (slot 0) and append the new one at the end
          let n = blacklist.size();
          let buf = Array.thaw<BlackEntry>(blacklist);
          var j = 0;
          while (j < n - 1) { buf[j] := buf[j + 1]; j += 1 };
          buf[n - 1] := entry;
          blacklist := Array.freeze(buf);
        }
      };
    }
  };

  /// Update or insert a rate entry. Evicts oldest slot when table is full.
  func rateUpsert(entry : RateEntry) {
    switch (findRate(entry.who)) {
      case (?i) {
        let buf = Array.thaw<RateEntry>(rateTable);
        buf[i] := entry;
        rateTable := Array.freeze(buf);
      };
      case null {
        if (rateTable.size() < MAX_RATE_TABLE) {
          rateTable := Array.append(rateTable, [entry]);
        } else {
          let n = rateTable.size();
          let buf = Array.thaw<RateEntry>(rateTable);
          var j = 0;
          while (j < n - 1) { buf[j] := buf[j + 1]; j += 1 };
          buf[n - 1] := entry;
          rateTable := Array.freeze(buf);
        }
      };
    }
  };

  /// Compute φ-deviation score for a caller's rate vs the EMA baseline.
  /// score > PHI_INV (0.618) = suspicious.
  func phiScore(callRate : Nat) : Float {
    let r   = Float.fromInt(callRate);
    let dev = Float.abs(r - emaBaseline) / (emaBaseline + 1.0);
    if (dev > 1.0) { 1.0 } else { dev }
  };

  /// Update the EMA baseline with the latest observed rate.
  func emaUpdate(callRate : Nat) {
    // alpha = 2 / (φ × 13 + 1) — Fibonacci-13 smoothing
    let alpha = 2.0 / (PHI * 13.0 + 1.0);
    emaBaseline := alpha * Float.fromInt(callRate) + (1.0 - alpha) * emaBaseline;
  };

  /// Core evaluation: rate-limit + φ-deviation + blacklist check.
  /// Returns (allowed, score, reason, currentRate).
  func evaluate(caller : Principal, now : Int) : (Bool, Float, Text, Nat) {
    let who = Principal.toText(caller);

    // Gate closed
    if (not gateOpen) { return (false, 1.0, "gate_closed", 0) };

    // Blacklist check
    if (isBlocked_(who, now)) { return (false, 1.0, "blacklisted", MAX_RATE + 1) };

    // Get current rate window for caller
    let (prevCount, winStart) : (Nat, Int) = switch (findRate(who)) {
      case null  { (0, now) };
      case (?i)  {
        let e = rateTable[i];
        if (now - e.windowStart > WINDOW_NS) { (0, now) }
        else { (e.count, e.windowStart) }
      };
    };

    let newCount = prevCount + 1;

    // Hard rate limit
    if (newCount > MAX_RATE) {
      // Get existing flags before updating
      let flags = switch (findRate(who)) {
        case null  { 0 };
        case (?i)  { rateTable[i].flags };
      };
      rateUpsert({ who; count = newCount; windowStart = winStart; flags });
      return (false, 1.0, "rate_exceeded", newCount)
    };

    // φ-deviation scoring
    let score  = phiScore(newCount);
    emaUpdate(newCount);

    // Existing flag count
    let prevFlags = switch (findRate(who)) {
      case null  { 0 };
      case (?i)  { rateTable[i].flags };
    };

    let newFlags = if (score > PHI_INV) { prevFlags + 1 } else { prevFlags };

    // Store updated entry
    rateUpsert({ who; count = newCount; windowStart = winStart; flags = newFlags });

    // Auto-blacklist after BOT_FLAG_LIMIT flags
    if (newFlags >= BOT_FLAG_LIMIT) {
      blacklistAdd(who, "phi_flags_" # Nat.toText(newFlags), now);
      return (false, score, "phi_blacklisted", newCount)
    };

    if (score > PHI_INV) {
      return (true, score, "phi_elevated", newCount)
    };

    (true, score, "clean", newCount)
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SYSTEM: inspect_message
  // Runs BEFORE every update call — zero cycles consumed on rejection.
  // ═══════════════════════════════════════════════════════════════════════════

  system func inspect_message() {
    if (not gateOpen) { Runtime.trap("gate_closed") }
    // Passes through to the actual function where per-caller checks run
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // PUBLIC API — callable from any ICP canister or front-end
  // ═══════════════════════════════════════════════════════════════════════════

  /// ─── PRIMARY: checkCaller() ──────────────────────────────────────────────
  /// Check whether the calling canister/principal passes the security gate.
  ///
  /// Returns SecurityVerdict:
  ///   • allowed = true  → caller is clean, proceed
  ///   • allowed = false → caller is a bot, rate-limited, or blacklisted
  ///   • score           → 0.0 clean, 1.0 certain bot, threshold = 0.618 (φ⁻¹)
  ///   • reason          → "clean" | "phi_elevated" | "rate_exceeded" | "blacklisted" | ...
  ///
  /// Usage in your Motoko canister:
  ///   let verdict = await sec.checkCaller();
  ///   if (not verdict.allowed) Runtime.trap("bot: " # verdict.reason);
  public shared(msg) func checkCaller() : async SecurityVerdict {
    let now = Time.now();
    totalChecked += 1;
    let (ok, score, reason, rate) = evaluate(msg.caller, now);
    if (ok) { totalAllowed += 1 } else { totalRejected += 1 };
    {
      allowed    = ok;
      score;
      reason;
      callerRate = rate;
      layer      = "L3_MERIDIANUS_ADAPTER";
    }
  };

  /// ─── LIGHTWEIGHT: rateCheck() ────────────────────────────────────────────
  /// Cheaper than checkCaller() — only checks the rate counter, no φ-scoring.
  /// Use when you just want to know "did this caller call too many times?"
  ///
  /// Returns: { allowed, count, maxAllowed }
  public shared(msg) func rateCheck() : async { allowed : Bool; count : Nat; maxAllowed : Nat } {
    let now = Time.now();
    let who = Principal.toText(msg.caller);
    let (count, _) : (Nat, Int) = switch (findRate(who)) {
      case null  { (0, now) };
      case (?i)  {
        let e = rateTable[i];
        if (now - e.windowStart > WINDOW_NS) { (0, now) } else { (e.count, e.windowStart) }
      };
    };
    let newCount = count + 1;
    let ok = newCount <= MAX_RATE and gateOpen and not isBlocked_(who, now);
    { allowed = ok; count = newCount; maxAllowed = MAX_RATE }
  };

  /// ─── REPORT: reportBot() ─────────────────────────────────────────────────
  /// Report a suspicious principal you detected in YOUR own system.
  /// Each report increments that principal's flag count.
  /// After 21 flags (F8) from any combination of sources, they are blacklisted.
  ///
  /// Usage: await sec.reportBot(suspectPrincipal, "ddos_pattern");
  public shared(_msg) func reportBot(suspect : Principal, evidence : Text) : async { accepted : Bool } {
    let now  = Time.now();
    let who  = Principal.toText(suspect);
    let prevFlags = switch (findRate(who)) {
      case null  { 0 };
      case (?i)  { rateTable[i].flags };
    };
    let newFlags = prevFlags + 1;
    let (prevCount, winStart) : (Nat, Int) = switch (findRate(who)) {
      case null  { (0, now) };
      case (?i)  {
        let e = rateTable[i];
        if (now - e.windowStart > WINDOW_NS) { (0, now) } else { (e.count, e.windowStart) }
      };
    };
    rateUpsert({ who; count = prevCount; windowStart = winStart; flags = newFlags });
    if (newFlags >= BOT_FLAG_LIMIT) {
      blacklistAdd(who, "cross_canister_report_" # evidence, now);
    };
    { accepted = true }
  };

  /// ─── QUERY: isBlocked() ──────────────────────────────────────────────────
  /// Free query (no cycles). Check if a principal is currently blacklisted.
  /// Useful before making inter-canister calls so you don't waste cycles.
  ///
  /// Usage: let blocked = await sec.isBlocked(somePrincipal);
  public query func isBlocked(who : Principal) : async Bool {
    isBlocked_(Principal.toText(who), Time.now())
  };

  /// ─── QUERY: getStatus() ──────────────────────────────────────────────────
  /// Free query (no cycles). Returns full system metrics.
  /// Call this to display a live security dashboard in your dApp.
  public query func getStatus() : async SecurityStatus {
    let now = Time.now();
    var activeBlacklist = 0;
    var j = 0;
    while (j < blacklist.size()) {
      if (blacklist[j].until > now) { activeBlacklist += 1 };
      j += 1;
    };
    let checked  = Float.fromInt(Nat64.toNat(totalChecked));
    let allowed_ = Float.fromInt(Nat64.toNat(totalAllowed));
    let coherence = if (checked > 0.0) { allowed_ / checked } else { 1.0 };
    {
      totalChecked;
      totalAllowed;
      totalRejected;
      blacklistSize = activeBlacklist;
      activeCallers = rateTable.size();
      coherence;
      gateOpen;
      phiInv    = PHI_INV;
      doctrine  = "Medina phi-doctrine v1.0 | F11=89 calls/60s | threshold=phi-inv=0.618 | F8=21 flags to blacklist | 10min ban";
    }
  };

  /// ─── QUERY: getThresholds() ──────────────────────────────────────────────
  /// Free query. Returns the security thresholds so callers understand the gate.
  public query func getThresholds() : async Thresholds {
    {
      maxRate               = MAX_RATE;
      windowSeconds         = 60;
      phiInv                = PHI_INV;
      botFlagThreshold      = BOT_FLAG_LIMIT;
      blacklistDurationMins = 10;
      fibonacciSequence     = "F8=21 flags, F11=89 rate/min, F12=144 tracked callers";
    }
  };

  /// ─── ADMIN: setGate() ────────────────────────────────────────────────────
  /// Open or close the security gate. Closing it rejects ALL update calls
  /// via inspect_message (zero cycles on rejection).
  /// In production: add an owner check (see README.md).
  public shared(_msg) func setGate(open : Bool) : async () {
    gateOpen := open;
  };

  /// ─── ADMIN: unblock() ────────────────────────────────────────────────────
  /// Remove a principal from the blacklist.
  /// In production: add an owner check (see README.md).
  public shared(_msg) func unblock(who : Principal) : async { removed : Bool } {
    let txt = Principal.toText(who);
    switch (findBlack(txt)) {
      case null { { removed = false } };
      case (?i) {
        let n = blacklist.size();
        let buf = Array.thaw<BlackEntry>(blacklist);
        // Shift entries left to remove slot i
        var k = i;
        while (k < n - 1) { buf[k] := buf[k + 1]; k += 1 };
        blacklist := Array.freeze(Array.subArray(blacklist, 0, n - 1));
        { removed = true }
      };
    }
  };

  /// ─── ADMIN: resetCaller() ────────────────────────────────────────────────
  /// Clear the rate entry for a principal (flags + count reset).
  /// Use to manually rehabilitate a caller.
  public shared(_msg) func resetCaller(who : Principal) : async { removed : Bool } {
    let txt = Principal.toText(who);
    switch (findRate(txt)) {
      case null { { removed = false } };
      case (?i) {
        let n = rateTable.size();
        let buf = Array.thaw<RateEntry>(rateTable);
        var k = i;
        while (k < n - 1) { buf[k] := buf[k + 1]; k += 1 };
        rateTable := Array.freeze(Array.subArray(rateTable, 0, n - 1));
        { removed = true }
      };
    }
  };
}
