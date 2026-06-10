// ─────────────────────────────────────────────────────────────────────────────
// MOTOKO COPY-PASTE SNIPPET — Meridianus Security Adapter
// ─────────────────────────────────────────────────────────────────────────────
//
// Paste this into ANY Motoko canister to add φ-bot protection in 4 steps:
//
//   Step 1. Import Runtime at the top of your file.
//   Step 2. Define the security actor (replace CANISTER_ID_HERE).
//   Step 3. Call `await sec.checkCaller()` inside your protected function.
//   Step 4. Deploy. Done.
//
// That's it. Your canister is now protected by:
//   • Rate limit: 89 calls/60 seconds (Fibonacci F11)
//   • φ-deviation bot scoring (score > 0.618 = suspicious)
//   • Auto-blacklist after 21 bot flags (Fibonacci F8, 10-min ban)
//
// Get the canister ID after deploy:
//   $ dfx deploy security_adapter
//   $ dfx canister id security_adapter
//
// ─────────────────────────────────────────────────────────────────────────────

import Runtime "mo:core/Runtime";

// ─── STEP 1: Define the security actor (put this at the top of your actor) ───

let sec : actor {
  checkCaller : () -> async {
    allowed    : Bool;
    score      : Float;
    reason     : Text;
    callerRate : Nat;
    layer      : Text;
  };
  rateCheck : () -> async {
    allowed    : Bool;
    count      : Nat;
    maxAllowed : Nat;
  };
  reportBot : (Principal, Text) -> async { accepted : Bool };
  isBlocked : (Principal) -> async Bool;  // query
} = actor("CANISTER_ID_HERE");           // <── replace with your canister ID

// ─── STEP 2: Wrap any function you want to protect ───────────────────────────

// FULL PROTECTION: rate + phi-scoring + blacklist
// Use this for sensitive operations (writes, payments, governance votes, etc.)
public shared(msg) func myProtectedFunction(data : Text) : async Text {
  let verdict = await sec.checkCaller();
  if (not verdict.allowed) {
    Runtime.trap("security: " # verdict.reason # " score=" # Float.toText(verdict.score))
  };
  // Your logic here — only clean traffic reaches this point
  "processed: " # data
};

// LIGHTWEIGHT: rate-only check (no phi-scoring)
// Use this for read operations or high-frequency calls where you just want rate limiting.
public shared(_msg) func myFastFunction(query : Text) : async Text {
  let rate = await sec.rateCheck();
  if (not rate.allowed) {
    Runtime.trap("rate_limited: " # Nat.toText(rate.count) # "/" # Nat.toText(rate.maxAllowed))
  };
  "result: " # query
};

// ─── STEP 3: Report bots you detect in your own system ───────────────────────

// Call this when you detect suspicious behavior in your own canister logic.
// Contributes to the shared cross-canister blacklist.
public shared(_msg) func flagSuspiciousCaller(suspect : Principal) : async () {
  let _ = await sec.reportBot(suspect, "custom_detection");
};

// ─── STEP 4: Optional — pre-flight check before calling another canister ──────

// Before you make an expensive inter-canister call, check if the target is blocked.
// Saves you cycles if they're already on the blacklist.
public func isSafe(target : Principal) : async Bool {
  let blocked = await sec.isBlocked(target);
  not blocked
};

// ─────────────────────────────────────────────────────────────────────────────
// MINIMAL VERSION — just 4 lines if you only need the basic check:
// ─────────────────────────────────────────────────────────────────────────────
//
//   let sec = actor("CANISTER_ID") : actor { checkCaller : () -> async { allowed : Bool; score : Float; reason : Text; callerRate : Nat; layer : Text } };
//   public shared(_msg) func doThing() : async Text {
//     let v = await sec.checkCaller();
//     if (not v.allowed) Runtime.trap(v.reason);
//     "ok"
//   };
//
// ─────────────────────────────────────────────────────────────────────────────
