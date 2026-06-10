// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  INTELLECTUAL PROPERTY NOTICE                                                                             ║
// ║  Owner:        Alfredo Medina Hernandez                                                                   ║
// ║  Location:     Dallas, Texas, United States of America                                                    ║
// ║  Contact:      MedinaSITech@outlook.com                                                                   ║
// ║  Framework:    Medina Doctrine                                                                            ║
// ║  CONFIDENTIALITY: This code is CONFIDENTIAL and PROPRIETARY.                                             ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// THE SOVEREIGNTY ENGINE — src/neuron_fleet/main.mo
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// 200 neurons. 5 Fibonacci groups. Everything loops.
//
// GROUP ARCHITECTURE:
//   A_SOVEREIGNTY  — 8  neurons (F₆)  — 8yr dissolve  — STAKE_MATURITY  — ICP     — Max VP, never dissolves
//   B_COMPOUNDING  — 34 neurons (F₉)  — 5yr dissolve  — STAKE_MATURITY  — ICP     — Compounds forever
//   C_HARVEST      — 89 neurons (F₁₁) — 3yr dissolve  — SPAWN_NEURON    — ICP     — Maturity → spawns NEW neurons
//   D_LIQUID       — 55 neurons (F₁₀) — 1.5yr dissolve — DISBURSE        — ICP     — Maturity → ICP → ONESICAN treasury
//   E_PHANTOM      — 14 neurons (F₇)  — 8yr dissolve  — STAKE_MATURITY  — PHANTOM — Cross-substrate governance
//                   ─── TOTAL: 200 ───
//
// 100 field nodes registered. Each node binds to 2 neurons. Node health routes vote weight.
//
// ONESICAN CYCLE PREMIUM (on-chain formula):
//   1 ONESICAN on PHANTOM = φ³ × 1T cycles = 4.236T raw-cycle-equivalent
//   At ICP=$10, 10T cycles/ICP:
//     1 ONESICAN on ICP      = 1T   cycle-eq
//     1 ONESICAN on EDGE     = 1.618T  (φ¹)
//     1 ONESICAN on CLOUD    = 2.618T  (φ²)
//     1 ONESICAN on PHANTOM  = 4.236T  (φ³) ← THE VEIN
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

import Time "mo:core/Time";
import Array "mo:core/Array";
import Float "mo:core/Float";
import Int "mo:core/Int";
import Nat "mo:core/Nat";
import Text "mo:core/Text";
import Buffer "mo:core/Buffer";
import Iter "mo:core/Iter";

actor NeuronFleet {

  // ═══════════════════════════════════════════════════════════════════════════
  // CONSTANTS — φ-ALIGNED
  // ═══════════════════════════════════════════════════════════════════════════

  let PHI   : Float = 1.618033988749895;
  let PHI2  : Float = 2.618033988749895;   // φ²
  let PHI3  : Float = 4.236067977499790;   // φ³
  let PHI_INV : Float = 0.618033988749895; // φ⁻¹

  // Fibonacci neuron counts per group
  let F6  : Nat = 8;    // A_SOVEREIGNTY
  let F7  : Nat = 14;   // E_PHANTOM (used as Fib index 7 approximation in design)
  let F9  : Nat = 34;   // B_COMPOUNDING
  let F10 : Nat = 55;   // D_LIQUID
  let F11 : Nat = 89;   // C_HARVEST
  // Total = 8 + 34 + 89 + 55 + 14 = 200

  let TOTAL_NEURONS  : Nat = 200;
  let TOTAL_NODES    : Nat = 100;
  let NEURONS_PER_NODE : Nat = 2;

  // Dissolve delay in seconds (ICP NNS uses seconds)
  let DISSOLVE_8YR  : Nat = 252_288_000;  // 8 years
  let DISSOLVE_5YR  : Nat = 157_680_000;  // 5 years
  let DISSOLVE_3YR  : Nat = 94_608_000;   // 3 years
  let DISSOLVE_15YR : Nat = 47_304_000;   // 1.5 years

  // ONESICAN cycle premiums by substrate (1T base)
  let CYCLES_ICP     : Float = 1.0;    // 1T cycle-eq baseline
  let CYCLES_EDGE    : Float = 1.618;  // φ¹ premium
  let CYCLES_CLOUD   : Float = 2.618;  // φ²
  let CYCLES_PHANTOM : Float = 4.236;  // φ³ — The Vein

  // ═══════════════════════════════════════════════════════════════════════════
  // TYPES
  // ═══════════════════════════════════════════════════════════════════════════

  public type NeuronGroup = {
    #A_SOVEREIGNTY;
    #B_COMPOUNDING;
    #C_HARVEST;
    #D_LIQUID;
    #E_PHANTOM;
  };

  public type DissolvePolicy = {
    #STAKE_MATURITY;   // Restake maturity → compound VP forever
    #SPAWN_NEURON;     // Maturity → spawn new neuron (C_HARVEST)
    #DISBURSE;         // Maturity → ICP → ONESICAN treasury (D_LIQUID)
  };

  public type Substrate = {
    #ICP;
    #PHANTOM;
    #EDGE;
    #CLOUD;
  };

  public type Neuron = {
    id              : Nat;
    group           : NeuronGroup;
    dissolvePolicy  : DissolvePolicy;
    substrate       : Substrate;
    dissolveSecs    : Nat;
    stakedICP       : Float;      // ICP staked (in e8s expressed as float for simplicity)
    maturity        : Float;      // Accumulated maturity
    votingPower     : Float;      // Computed VP
    createdAt       : Int;
    lastMaturityAt  : Int;
    active          : Bool;
  };

  public type FieldNode = {
    nodeId          : Nat;
    boundNeuron1    : Nat;   // neuron IDs
    boundNeuron2    : Nat;
    healthScore     : Float; // 0.0–1.0
    substrate       : Substrate;
    voteWeight      : Float; // proportional to health × VP of bound neurons
    lastHealthAt    : Int;
  };

  public type NeuronFleetStats = {
    totalNeurons    : Nat;
    totalNodes      : Nat;
    groupCounts     : { a: Nat; b: Nat; c: Nat; d: Nat; e: Nat };
    totalVP         : Float;
    totalMaturity   : Float;
    activeNeurons   : Nat;
    spawnedCount    : Nat;
    disbursedICP    : Float;
    cyclesEquivalent : Float;  // ONESICAN cycle-eq total across all substrates
  };

  public type CyclePremium = {
    substrate       : Substrate;
    multiplier      : Float;
    trillionCycleEq : Float;   // For 1 ONESICAN
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // STATE
  // ═══════════════════════════════════════════════════════════════════════════

  stable var neurons    : [Neuron] = [];
  stable var fieldNodes : [FieldNode] = [];
  stable var spawnedCount   : Nat = 0;
  stable var disbursedICP   : Float = 0.0;
  stable var totalBeatCount : Nat = 0;
  stable var genesisAt      : Int = 0;

  // ═══════════════════════════════════════════════════════════════════════════
  // INITIALIZATION — Build all 200 neurons and 100 field nodes
  // ═══════════════════════════════════════════════════════════════════════════

  func buildNeurons() : [Neuron] {
    let buf = Buffer.Buffer<Neuron>(200);
    let now = Time.now();
    var id = 0;

    // GROUP A — SOVEREIGNTY (8 neurons, F₆)
    for (i in Iter.range(0, F6 - 1)) {
      buf.add({
        id              = id;
        group           = #A_SOVEREIGNTY;
        dissolvePolicy  = #STAKE_MATURITY;
        substrate       = #ICP;
        dissolveSecs    = DISSOLVE_8YR;
        stakedICP       = 100.0 * PHI;         // φ-scaled initial stake
        maturity        = 0.0;
        votingPower     = 100.0 * PHI * 8.0;   // 8yr bonus × stake
        createdAt       = now;
        lastMaturityAt  = now;
        active          = true;
      });
      id += 1;
    };

    // GROUP B — COMPOUNDING (34 neurons, F₉)
    for (i in Iter.range(0, F9 - 1)) {
      buf.add({
        id              = id;
        group           = #B_COMPOUNDING;
        dissolvePolicy  = #STAKE_MATURITY;
        substrate       = #ICP;
        dissolveSecs    = DISSOLVE_5YR;
        stakedICP       = 34.0 * PHI_INV;
        maturity        = 0.0;
        votingPower     = 34.0 * PHI_INV * 5.0;
        createdAt       = now;
        lastMaturityAt  = now;
        active          = true;
      });
      id += 1;
    };

    // GROUP C — HARVEST (89 neurons, F₁₁)
    for (i in Iter.range(0, F11 - 1)) {
      buf.add({
        id              = id;
        group           = #C_HARVEST;
        dissolvePolicy  = #SPAWN_NEURON;
        substrate       = #ICP;
        dissolveSecs    = DISSOLVE_3YR;
        stakedICP       = 8.9 * PHI_INV;
        maturity        = 0.0;
        votingPower     = 8.9 * PHI_INV * 3.0;
        createdAt       = now;
        lastMaturityAt  = now;
        active          = true;
      });
      id += 1;
    };

    // GROUP D — LIQUID (55 neurons, F₁₀)
    for (i in Iter.range(0, F10 - 1)) {
      buf.add({
        id              = id;
        group           = #D_LIQUID;
        dissolvePolicy  = #DISBURSE;
        substrate       = #ICP;
        dissolveSecs    = DISSOLVE_15YR;
        stakedICP       = 5.5;
        maturity        = 0.0;
        votingPower     = 5.5 * 1.5;
        createdAt       = now;
        lastMaturityAt  = now;
        active          = true;
      });
      id += 1;
    };

    // GROUP E — PHANTOM (14 neurons, F₇)
    for (i in Iter.range(0, F7 - 1)) {
      buf.add({
        id              = id;
        group           = #E_PHANTOM;
        dissolvePolicy  = #STAKE_MATURITY;
        substrate       = #PHANTOM;
        dissolveSecs    = DISSOLVE_8YR;
        stakedICP       = 14.0 * PHI3;   // PHANTOM premium: φ³ multiplier
        maturity        = 0.0;
        votingPower     = 14.0 * PHI3 * 8.0;
        createdAt       = now;
        lastMaturityAt  = now;
        active          = true;
      });
      id += 1;
    };

    Buffer.toArray(buf);
  };

  func buildFieldNodes(neuronArr : [Neuron]) : [FieldNode] {
    let buf = Buffer.Buffer<FieldNode>(100);
    let now = Time.now();
    for (i in Iter.range(0, TOTAL_NODES - 1)) {
      let n1 = (i * 2) % TOTAL_NEURONS;
      let n2 = (i * 2 + 1) % TOTAL_NEURONS;
      let substrate = neuronArr[n1].substrate;
      let vp1 = neuronArr[n1].votingPower;
      let vp2 = neuronArr[n2].votingPower;
      buf.add({
        nodeId       = i;
        boundNeuron1 = n1;
        boundNeuron2 = n2;
        healthScore  = 1.0;
        substrate    = substrate;
        voteWeight   = (vp1 + vp2) * 0.5;
        lastHealthAt = now;
      });
    };
    Buffer.toArray(buf);
  };

  // Run genesis on first call
  func ensureGenesis() {
    if (neurons.size() == 0) {
      neurons    := buildNeurons();
      fieldNodes := buildFieldNodes(neurons);
      genesisAt  := Time.now();
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // TICK — Called by ai_division productionTick each heartbeat
  // ═══════════════════════════════════════════════════════════════════════════

  /// Advance one production beat: accrue maturity, fire policies, update node health.
  public func tick(beatNumber : Nat) : async Text {
    ensureGenesis();
    totalBeatCount += 1;
    let now = Time.now();

    // Fibonacci-gated maturity check schedule:
    //   F(3)=2 beats, F(4)=3, F(5)=5, F(6)=8, F(7)=13, F(8)=21, F(9)=34, F(10)=55...
    let fibGates = [2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987];
    var shouldAccrue = false;
    for (gate in fibGates.vals()) {
      if (beatNumber % gate == 0) { shouldAccrue := true };
    };

    var spawned = 0;
    var disbursed : Float = 0.0;

    let updated = Array.tabulate<Neuron>(neurons.size(), func(idx : Nat) : Neuron {
      let n = neurons[idx];
      if (not n.active) return n;

      // Accrue maturity proportional to VP and stake
      let maturityRate : Float = if (shouldAccrue) {
        n.stakedICP * 0.0001 * PHI_INV
      } else { 0.0 };

      let newMaturity = n.maturity + maturityRate;
      let THRESHOLD : Float = 10.0;  // maturity threshold to fire policy

      // Fire policy when maturity crosses threshold
      if (newMaturity >= THRESHOLD) {
        switch (n.dissolvePolicy) {
          case (#SPAWN_NEURON) {
            spawned += 1;
            return { n with maturity = 0.0; lastMaturityAt = now };
          };
          case (#DISBURSE) {
            disbursed += n.stakedICP * PHI_INV;
            return { n with maturity = 0.0; lastMaturityAt = now };
          };
          case (#STAKE_MATURITY) {
            // Compound: maturity → stake → higher VP
            let newStake = n.stakedICP + newMaturity;
            let newVP = newStake * Float.fromInt(n.dissolveSecs / 31_536_000);
            return { n with stakedICP = newStake; votingPower = newVP; maturity = 0.0; lastMaturityAt = now };
          };
        };
      };
      { n with maturity = newMaturity };
    });

    neurons := updated;
    spawnedCount += spawned;
    disbursedICP += disbursed;

    // Update field node health — nodes degrade by φ⁻¹ per beat, refreshed by neuron activity
    let updatedNodes = Array.tabulate<FieldNode>(fieldNodes.size(), func(idx : Nat) : FieldNode {
      let node = fieldNodes[idx];
      let n1 = neurons[node.boundNeuron1 % neurons.size()];
      let n2 = neurons[node.boundNeuron2 % neurons.size()];
      let healthDecay = node.healthScore * PHI_INV;
      let healthRefresh = if (n1.active and n2.active) { 0.05 } else { 0.0 };
      let newHealth = Float.min(1.0, healthDecay + healthRefresh);
      let newWeight = (n1.votingPower + n2.votingPower) * newHealth;
      { node with healthScore = newHealth; voteWeight = newWeight; lastHealthAt = now };
    });
    fieldNodes := updatedNodes;

    "beat=" # Nat.toText(beatNumber) # " spawned=" # Nat.toText(spawned) # " disbursed=" # Float.toText(disbursed);
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // QUERIES
  // ═══════════════════════════════════════════════════════════════════════════

  public query func getStats() : async NeuronFleetStats {
    ensureGenesis();
    var totalVP : Float = 0.0;
    var totalMat : Float = 0.0;
    var activeCount : Nat = 0;
    var ga = 0; var gb = 0; var gc = 0; var gd = 0; var ge = 0;

    for (n in neurons.vals()) {
      totalVP  += n.votingPower;
      totalMat += n.maturity;
      if (n.active) { activeCount += 1 };
      switch (n.group) {
        case (#A_SOVEREIGNTY) { ga += 1 };
        case (#B_COMPOUNDING) { gb += 1 };
        case (#C_HARVEST)     { gc += 1 };
        case (#D_LIQUID)      { gd += 1 };
        case (#E_PHANTOM)     { ge += 1 };
      };
    };

    // Cycle equivalents: PHANTOM neurons contribute φ³ premium
    let cycleEq = totalVP * CYCLES_ICP + (Float.fromInt(ge) * 14.0 * CYCLES_PHANTOM);

    {
      totalNeurons    = neurons.size();
      totalNodes      = fieldNodes.size();
      groupCounts     = { a = ga; b = gb; c = gc; d = gd; e = ge };
      totalVP         = totalVP;
      totalMaturity   = totalMat;
      activeNeurons   = activeCount;
      spawnedCount    = spawnedCount;
      disbursedICP    = disbursedICP;
      cyclesEquivalent = cycleEq;
    };
  };

  public query func getNeuron(id : Nat) : async ?Neuron {
    ensureGenesis();
    if (id >= neurons.size()) return null;
    ?neurons[id];
  };

  public query func getFieldNode(nodeId : Nat) : async ?FieldNode {
    ensureGenesis();
    if (nodeId >= fieldNodes.size()) return null;
    ?fieldNodes[nodeId];
  };

  public query func getCyclePremiums() : async [CyclePremium] {
    [
      { substrate = #ICP;     multiplier = 1.0;  trillionCycleEq = CYCLES_ICP     },
      { substrate = #EDGE;    multiplier = PHI;   trillionCycleEq = CYCLES_EDGE    },
      { substrate = #CLOUD;   multiplier = PHI2;  trillionCycleEq = CYCLES_CLOUD   },
      { substrate = #PHANTOM; multiplier = PHI3;  trillionCycleEq = CYCLES_PHANTOM },
    ];
  };

  public query func getGroupNeurons(group : NeuronGroup) : async [Neuron] {
    ensureGenesis();
    let buf = Buffer.Buffer<Neuron>(50);
    for (n in neurons.vals()) { if (n.group == group) { buf.add(n) } };
    Buffer.toArray(buf);
  };

  public query func getTotalVotingPower() : async Float {
    ensureGenesis();
    var vp : Float = 0.0;
    for (n in neurons.vals()) { vp += n.votingPower };
    vp;
  };

  public query func getNodesByHealth(minHealth : Float) : async [FieldNode] {
    ensureGenesis();
    let buf = Buffer.Buffer<FieldNode>(50);
    for (fn in fieldNodes.vals()) { if (fn.healthScore >= minHealth) { buf.add(fn) } };
    Buffer.toArray(buf);
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // UPDATES
  // ═══════════════════════════════════════════════════════════════════════════

  /// Force-initialize the fleet (idempotent)
  public func genesis() : async Text {
    ensureGenesis();
    "NeuronFleet genesis complete: " # Nat.toText(neurons.size()) # " neurons, " # Nat.toText(fieldNodes.size()) # " field nodes";
  };

  /// Reroute degraded node to PHANTOM substrate for resilience
  public func rerouteNodeToPhantom(nodeId : Nat) : async Bool {
    ensureGenesis();
    if (nodeId >= fieldNodes.size()) return false;
    fieldNodes := Array.tabulate<FieldNode>(fieldNodes.size(), func(i : Nat) : FieldNode {
      let node = fieldNodes[i];
      if (i == nodeId) {
        { node with substrate = #PHANTOM; healthScore = Float.min(1.0, node.healthScore + 0.3) }
      } else { node }
    });
    true;
  };

  /// Stake more ICP into a neuron (compound call)
  public func stakeMore(neuronId : Nat, amount : Float) : async Bool {
    ensureGenesis();
    if (neuronId >= neurons.size()) return false;
    neurons := Array.tabulate<Neuron>(neurons.size(), func(i : Nat) : Neuron {
      let n = neurons[i];
      if (i == neuronId) {
        let newStake = n.stakedICP + amount;
        let yearBonus = Float.fromInt(n.dissolveSecs / 31_536_000);
        { n with stakedICP = newStake; votingPower = newStake * yearBonus }
      } else { n }
    });
    true;
  };

};
