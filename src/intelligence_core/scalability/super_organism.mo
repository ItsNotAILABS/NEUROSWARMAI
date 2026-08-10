// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  NOVA INTELLIGENCE CORE — SCALABILITY PILLAR                                                              ║
// ║  Super-Organism Coordination, Hierarchical Routing, Massive-Scale Sync                                    ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

import Float "mo:core/Float";
import Array "mo:core/Array";
import Nat "mo:core/Nat";
import Iter "mo:core/Iter";
import NovaComputing "../computing/core";

module NovaScalability {

  // ═══════════════════════════════════════════════════════════════════════════════
  // HIERARCHICAL CLUSTER ARCHITECTURE
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Cluster health: aggregate node health with weighted contribution
  /// Health = Σ(weight_i × health_i) / Σ weight_i
  public func clusterHealth(nodeHealths : [Float], nodeWeights : [Float]) : Float {
    if (nodeHealths.size() == 0) return 0.0;

    var weightedSum : Float = 0.0;
    var totalWeight : Float = 0.0;

    let n = Nat.min(nodeHealths.size(), nodeWeights.size());
    for (i in Iter.range(0, n - 1)) {
      weightedSum += nodeWeights[i] * nodeHealths[i];
      totalWeight += nodeWeights[i];
    };

    if (totalWeight < NovaComputing.EPSILON) return 0.0;
    weightedSum / totalWeight
  };

  /// Load balancing: distribute work proportional to capacity
  /// Returns allocation fraction per node
  public func loadBalance(capacities : [Float]) : [Float] {
    if (capacities.size() == 0) return [];

    var totalCapacity : Float = 0.0;
    for (c in capacities.vals()) { totalCapacity += Float.max(0.0, c) };

    if (totalCapacity < NovaComputing.EPSILON) {
      // Equal distribution if all capacities are zero
      let equal = 1.0 / Float.fromInt(capacities.size());
      return Array.tabulate<Float>(capacities.size(), func(_) { equal });
    };

    Array.tabulate<Float>(capacities.size(), func(i) {
      Float.max(0.0, capacities[i]) / totalCapacity
    })
  };

  /// Fibonacci-scaled tier assignment
  /// Nodes assigned to tiers based on Fibonacci grouping (8, 13, 21, 34, 55, 89...)
  public func fibonacciTierSize(tier : Nat) : Nat {
    NovaComputing.fibonacci(tier + 5) // Starting at F₆=8
  };

  /// Total nodes across N tiers
  public func totalNodesForTiers(numTiers : Nat) : Nat {
    var total : Nat = 0;
    for (t in Iter.range(0, numTiers - 1)) {
      total += fibonacciTierSize(t);
    };
    total
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // WAVE ROUTING — SIGNAL PROPAGATION AT SCALE
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Wave propagation delay: φ-scaled per tier
  /// Delay(tier) = base_delay × φ^tier
  public func tierDelay(basedelayMs : Float, tier : Nat) : Float {
    basedelayMs * Float.pow(NovaComputing.PHI, Float.fromInt(tier))
  };

  /// Signal attenuation across tiers: amplitude × φ⁻ⁿ
  public func signalAttenuation(amplitude : Float, tiersTraversed : Nat) : Float {
    amplitude * Float.pow(NovaComputing.PHI_INV_1, Float.fromInt(tiersTraversed))
  };

  /// Routing priority: urgency × (1/tier_distance) × signal_strength
  public func routingPriority(urgency : Float, tierDistance : Nat, signalStrength : Float) : Float {
    if (tierDistance == 0) return urgency * signalStrength;
    urgency * signalStrength / Float.fromInt(tierDistance)
  };

  /// Broadcast radius: how many tiers a signal can reach
  /// Based on signal strength and attenuation threshold
  public func broadcastRadius(signalStrength : Float, attenuationThreshold : Float) : Nat {
    if (signalStrength <= attenuationThreshold) return 0;

    // Solve: strength × φ⁻ⁿ = threshold → n = log(strength/threshold) / log(φ)
    var n : Nat = 0;
    var current = signalStrength;
    while (current > attenuationThreshold and n < 20) {
      current *= NovaComputing.PHI_INV_1;
      n += 1;
    };
    n
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // QUORUM & CONSENSUS AT SCALE
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Supermajority threshold: φ⁻¹ ≈ 61.8%
  public let SUPERMAJORITY_THRESHOLD : Float = 0.618033988749895;

  /// Check quorum: minimum participation required
  public func hasQuorum(participating : Nat, total : Nat) : Bool {
    if (total == 0) return false;
    let ratio = Float.fromInt(participating) / Float.fromInt(total);
    ratio >= SUPERMAJORITY_THRESHOLD
  };

  /// Weighted consensus: do weighted votes exceed threshold?
  public func weightedConsensus(votes : [Float], weights : [Float], threshold : Float) : Bool {
    if (votes.size() == 0) return false;

    var weightedYes : Float = 0.0;
    var totalWeight : Float = 0.0;

    let n = Nat.min(votes.size(), weights.size());
    for (i in Iter.range(0, n - 1)) {
      totalWeight += weights[i];
      if (votes[i] > 0.5) {
        weightedYes += weights[i];
      };
    };

    if (totalWeight < NovaComputing.EPSILON) return false;
    (weightedYes / totalWeight) >= threshold
  };

  /// Byzantine fault tolerance: system tolerates f faults with 3f+1 nodes
  public func byzantineFaultCapacity(totalNodes : Nat) : Nat {
    if (totalNodes < 4) return 0;
    (totalNodes - 1) / 3
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SCALE-FREE NETWORK TOPOLOGY
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Preferential attachment probability: P(connect to i) ∝ degree_i^α
  public func preferentialAttachment(degrees : [Nat], alpha : Float) : [Float] {
    if (degrees.size() == 0) return [];

    let powered = Array.tabulate<Float>(degrees.size(), func(i) {
      Float.pow(Float.fromInt(degrees[i] + 1), alpha) // +1 to avoid zero
    });

    var sum : Float = 0.0;
    for (p in powered.vals()) { sum += p };

    if (sum < NovaComputing.EPSILON) {
      let equal = 1.0 / Float.fromInt(degrees.size());
      return Array.tabulate<Float>(degrees.size(), func(_) { equal });
    };

    Array.tabulate<Float>(powered.size(), func(i) { powered[i] / sum })
  };

  /// Hub detection: is this node a hub? (degree > φ × mean_degree)
  public func isHub(nodeDegree : Nat, meanDegree : Float) : Bool {
    Float.fromInt(nodeDegree) > NovaComputing.PHI * meanDegree
  };

  /// Network diameter estimate for scale-free: O(log(log(N)))
  public func estimatedDiameter(totalNodes : Nat) : Float {
    if (totalNodes < 2) return 0.0;
    Float.log(Float.log(Float.fromInt(totalNodes)) + 1.0) + 1.0
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // ORGANISM HEARTBEAT COORDINATION
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Heartbeat phase for tier: offset by φ-ratio
  /// Ensures tiers pulse in golden-ratio-phased waves
  public func heartbeatPhase(tier : Nat, globalPhase : Float) : Float {
    NovaComputing.wrapAngle(globalPhase + Float.fromInt(tier) * NovaComputing.GOLDEN_ANGLE_RAD)
  };

  /// Heartbeat sync check: is a node within acceptable phase drift?
  public func isHeartbeatSynced(nodePhase : Float, expectedPhase : Float, tolerance : Float) : Bool {
    let diff = Float.abs(NovaComputing.angleDiff(nodePhase, expectedPhase));
    diff <= tolerance
  };

  /// Dead node detection: no heartbeat for N cycles
  public func isNodeDead(missedHeartbeats : Nat, maxMissed : Nat) : Bool {
    missedHeartbeats >= maxMissed
  };

}
