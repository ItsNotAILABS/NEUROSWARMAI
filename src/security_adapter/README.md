# MERIDIANUS Security Adapter
### The φ-Doctrine Intelligence Contract

---

Imagine you've built something on the Internet Computer and someone is testing it. Within seconds, a bot hits it 400 times. Your canister cycles drain. Real users can't get through. You added nothing wrong — you just didn't have a gate.

**This canister is that gate.**

Deploy it once. Point any other canister at it. Every call that comes in gets evaluated in milliseconds against a living intelligence — and the answer comes back: `allowed: true` or `allowed: false`. Your canister only runs the function body when the answer is `true`. When the answer is `false`, the rejection happens *before* your code even starts, consuming zero of your cycles.

That's it. That's the product.

---

## What Happens to a Call

Picture a request hitting your dApp. Here is exactly what the system does — in order, in under a millisecond, every single time.

**First:** The call arrives at the Cloudflare edge — the VIGILIA and UMBRA workers from the Meridianus fleet. They run the intelligence *at the network level*, before the request ever reaches ICP. If the caller's behavior pattern triggers the doctrine, the edge returns `allowed: false` instantly. Nothing downstream is touched.

**Second:** If the caller made it through the edge and they're in a browser dApp, the in-page Organism Web Worker runs the same intelligence locally. Another zero-network check. Bad actors blocked before a single canister call is made.

**Third:** The call reaches ICP. The `inspect_message()` system function fires *before* the target function body executes. The caller is evaluated against the doctrine. If they fail — zero cycles consumed. The canister traps before doing any work.

Three concentric shields. Each one stops bots at a different level. Most bots never make it to the canister. The ones that do are stopped with zero cost to you.

---

## The Intelligence Contract

This isn't an API you learn. It's a contract you sign.

You call `checkCaller()`. The intelligence returns a verdict. You act on it.

```
Verdict {
  allowed  : Bool   ← proceed or stop
  score    : Float  ← coherence with the doctrine (0.0 = clean, 1.0 = rejected)
  reason   : Text   ← what triggered the decision
}
```

The score reflects how coherent the caller's behavior is with natural human patterns. The intelligence tracks, learns, and adapts. You don't configure it. You don't tune it. You don't need to understand it. You just ask, and it answers.

**Primary contract:**
- `checkCaller()` — Am I allowed through?

**Auxiliary contracts:**
- `reportBot(suspect, evidence)` — I saw something suspicious. Flag this identity.
- `isBlocked(who)` — Is this identity currently blocked?
- `getStatus()` — What's the system's current state?

**Administrative contracts (owner only):**
- `setGate(open)` — Emergency stop. Close everything.
- `unblock(who)` — Manually override a block.
- `resetCaller(who)` — Clear someone's history.

That's the entire surface. The intelligence beneath it runs on a mathematical doctrine derived from nature — the same ratios found in spiral galaxies, market cycles, and the growth patterns of living organisms. It distinguishes human from machine by measuring coherence with these patterns. A human naturally stays coherent. A bot cannot.

---

## Deploy It

```bash
# Install dfx if you don't have it
sh -ci "$(curl -fsSL https://internetcomputer.org/install.sh)"

# Deploy
dfx start --background
dfx deploy security_adapter

# Get your contract address
dfx canister id security_adapter
```

That ID is now a live intelligence contract on the Internet Computer.

---

## Connect Your Canister

**Motoko — four lines:**

```motoko
let gate = actor("YOUR_CONTRACT_ID") : actor { checkCaller : () -> async { allowed : Bool } };

public shared func protectedFunction() : async Text {
  let v = await gate.checkCaller();
  if (not v.allowed) { Runtime.trap("denied") };
  "result"
};
```

**Rust, TypeScript, CLI** — the Candid interface at `security_adapter.did` works with any ICP-compatible language. The pattern is always the same: call `checkCaller()`, check `allowed`, proceed or reject.

---

## The Organism Connection

The Meridianus platform runs 35 Organism Web Workers in the browser and 69 AIS Cloudflare Worker intelligences at the edge. The security adapter is the on-chain anchor for all of them.

**L1 Edge** — VIGILIA and UMBRA run the doctrine at the network perimeter.
**L2 Browser** — TOOL-221 runs it locally in every user's session.
**L3 Chain** — This canister holds the ground truth.

All three layers speak the same doctrine. They are one intelligence expressed at three levels of the stack.

---

*Meridianus Security Adapter — Medina φ-Doctrine v1.0*
*Copyright © 2024-2026 Alfredo Medina Hernandez. All Rights Reserved.*
*SPDX-License-Identifier: CPEL-1.0*
