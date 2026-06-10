# ALPHA ORCHESTRATORS — SIGNAL BUS INTEGRATION

## Overview

The 4 ALPHA orchestrators are now fully integrated with the central Signal Propagation Bus, enabling instant cross-domain intelligence sharing across all Five Alphas substrates.

## Architecture

```
┌─────────────────────────────────────────────────────────────────────────┐
│                        SIGNAL PROPAGATION BUS                            │
│                    (18 Domain, 18×18 Coupling Matrix)                   │
└────────────┬──────────────┬──────────────┬──────────────┬──────────────┘
             │              │              │              │
     ┌───────▼──────┐ ┌────▼─────┐ ┌─────▼──────┐ ┌─────▼──────┐
     │ ALPHA I      │ │ ALPHA II │ │ ALPHA III  │ │ ALPHA IV   │
     │ CHIMERA      │ │ PHANTOM  │ │ ORBITAL    │ │ IRONVEIL   │
     │ Physical     │ │ Virtual  │ │ Space      │ │ Infra      │
     └──────────────┘ └──────────┘ └────────────┘ └────────────┘
     89 Field Nodes   89 Comp Nodes  55 Orb Nodes  55 Infra Nodes
     144 Agents       233 Agents     89 Monitors   89 Sentinels
```

## ALPHA Orchestrators

### ALPHA I — CHIMERA (Physical Swarm)
- **Field Nodes**: 89 (F11) distributed in golden spiral
- **Agents**: 144 (F12) physical swarm agents
- **Domain**: Physical space (3D coordinates)
- **Signals Emitted**:
  - `SwarmCoherence` — Kuramoto phase-locking strength
  - `CollisionAvoidance` — Proximity warning level
  - `TargetAcquired` — Target lock confirmation
  - `FormationComplete` — Formation geometry achieved

### ALPHA II — PHANTOM (Virtual Swarm)
- **Field Nodes**: 89 (F11) computational regions
- **Agents**: 233 (F13) virtual agents
- **Domain**: ICP canister space (Memory, Compute, Network, Storage, etc.)
- **Signals Emitted**:
  - `SwarmCoherence` — Virtual swarm synchronization
  - `LoadBalanced` — Load distribution status
  - `AnomalyDetected` — KL divergence anomaly
  - `ResourceStarvation` — Low cycle warning
  - `TaskCompleted` — Task completion notification

### ALPHA III — ORBITAL (Space Domain)
- **Field Nodes**: 55 (F10) orbital shells (LEO, MEO, GEO, HEO, LUNAR)
- **Monitors**: 89 (F11) satellite/debris trackers
- **Domain**: Space domain awareness
- **Signals Emitted**:
  - `SwarmCoherence` — Monitor synchronization
  - `GPSIntegrityAlert` — GPS constellation degradation
  - `ASATDetected` — Anti-satellite threat detected
  - `DebrisWarning` — Space debris collision risk
  - `TrackLost` — Object tracking lost
  - `AnomalousOrbit` — Unexpected orbital change
  - `ConstellationDegraded` — Constellation health decline
  - `ManeuverDetected` — Satellite maneuver detected

### ALPHA IV — IRONVEIL (Infrastructure)
- **Field Nodes**: 55 (F10) infrastructure sectors
- **Sentinels**: 89 (F11) infrastructure monitors
- **Domain**: Critical infrastructure (Power, Water, Comms, Transport, Financial, Healthcare, Gov, Food)
- **Signals Emitted**:
  - `SwarmCoherence` — Infrastructure synchronization
  - `CascadeRiskElevated` — Cascade failure risk rising
  - `SectorFailure` — Critical sector failure
  - `HealthDegraded` — Sector health declining
  - `DependencyBroken` — Dependency link broken
  - `LoadCritical` — Sector overload warning

## Signal Flow

### 1. ALPHA Tick
Each orchestrator runs its update cycle:
- Kuramoto phase synchronization
- ACO pheromone update
- Signal emission

```motoko
AlphaChimera.tickChimera(alphaChimeraState, dt);
AlphaPhantom.tickPhantom(alphaPhantomState, dt);
AlphaOrbital.tickOrbital(alphaOrbitalState, dt);
AlphaIronveil.tickIronveil(alphaIronveilState, dt);
```

### 2. Signal Emission
Each orchestrator emits domain-specific signals:

```motoko
let chimeraSignals = AlphaChimera.emitSignals(alphaChimeraState);
let phantomSignals = AlphaPhantom.emitSignals(alphaPhantomState);
let orbitalSignals = AlphaOrbital.emitSignals(alphaOrbitalState);
let ironveilSignals = AlphaIronveil.emitSignals(alphaIronveilState);
```

### 3. Signal Conversion
ALPHA-specific signals are converted to SignalBus format:

```motoko
private func convertOrbitalSignal(signal : AlphaOrbital.OrbitalSignal) : SignalBus.SignalValue {
  switch (signal.signalType) {
    case (#ASATDetected) {
      SignalBus.createSignal(
        #AttackDetected,
        signal.value,
        #GuardianDefense,
        0.98,  // Critical urgency
        0.95   // High confidence
      )
    };
    // ... other conversions
  }
};
```

### 4. Bus Emission
Converted signals are emitted to the central bus:

```motoko
for (orbitalSignal in orbitalSignals.vals()) {
  let busSignal = convertOrbitalSignal(orbitalSignal);
  signalBusState := SignalBus.emitSignal(signalBusState, busSignal);
};
```

### 5. Signal Propagation
The bus propagates signals using the 18×18 coupling matrix:

```
Signal_out(domain_i) = Σ_j [Coupling(i,j) × Signal_in(j) × urgency(j)]
```

Example coupling values:
- GuardianDefense → Fear: 0.95 (high coupling)
- Economic → GuardianDefense: 0.45 (medium)
- Quantum → Economic: 0.15 (low)

### 6. Cross-Domain Effects
Signals affect other domains based on coupling strength:

**Example**: ORBITAL detects ASAT threat
1. ORBITAL emits `ASATDetected` signal (urgency: 0.98)
2. Converts to `AttackDetected` for `#GuardianDefense` domain
3. Propagates to:
   - Fear substrate (coupling: 0.85) → elevates fear level
   - Economic (coupling: 0.45) → suppresses FORMA minting
   - BehavioralAI (coupling: 0.65) → triggers defensive drive
   - Anticipatory (coupling: 0.70) → pre-positions defenses

## API Endpoints

### Get Individual ALPHA Status

```motoko
// ALPHA I - Physical Swarm
getAlphaChimeraStatus() : {
  globalCoherence : Float;
  activeAgents : Nat;
  totalPheromone : Float;
  signalCount : Nat;
  beats : Nat64;
}

// ALPHA II - Virtual Swarm
getAlphaPhantomStatus() : {
  globalCoherence : Float;
  totalLoad : Float;
  activeAgents : Nat;
  signalCount : Nat;
  beats : Nat64;
}

// ALPHA III - Space Domain
getAlphaOrbitalStatus() : {
  globalCoherence : Float;
  avgIntegrity : Float;
  maxThreat : Float;
  activeMonitors : Nat;
  signalCount : Nat;
  beats : Nat64;
}

// ALPHA IV - Infrastructure
getAlphaIronveilStatus() : {
  globalCoherence : Float;
  avgHealth : Float;
  maxCascadeRisk : Float;
  criticalNodes : Nat;
  signalCount : Nat;
  beats : Nat64;
}
```

### Get Combined ALPHA Summary

```motoko
getAllAlphasSummary() : {
  chimeraCoherence : Float;
  phantomCoherence : Float;
  orbitalCoherence : Float;
  ironveilCoherence : Float;
  totalActiveAgents : Nat;
  totalSignals : Nat;
}
```

### Get Signal Bus Status

```motoko
getSignalBusStatus() : {
  globalCoherence : Float;
  totalActivity : Float;
  dominantDomain : Text;
  urgentAlerts : Nat;
  signalCount : Nat;
  beat : Nat64;
}
```

### Tick All ALPHAs

```motoko
tickAllAlphas(dt : Float) : async ()
```

Call this from the main heartbeat to update all 4 orchestrators and propagate their signals.

## Integration with Main Heartbeat

The ALPHAs should be ticked during each main heartbeat cycle:

```motoko
public shared func heartbeat() : async () {
  // ... existing heartbeat logic

  // Tick all ALPHA orchestrators
  await tickAllAlphas(0.1);  // dt = 0.1 seconds

  // Signal bus has now received all ALPHA signals
  // and propagated them across all 18 domains

  // ... continue with other engines
}
```

## Signal Bus Domain Mapping

ALPHA signals map to these SignalBus domains:

| ALPHA Signal Type | Bus Domain | Urgency | Notes |
|-------------------|------------|---------|-------|
| SwarmCoherence | Architecture | 0.7 | Kuramoto sync level |
| ASATDetected | GuardianDefense | 0.98 | Critical threat |
| GPSIntegrityAlert | GuardianDefense | 0.6-0.95 | Degraded integrity |
| CascadeRisk | GuardianDefense | 0.7-0.95 | Infrastructure cascade |
| AnomalyDetected | GuardianDefense | 0.9 | Virtual anomaly |
| LoadBalanced | Architecture | 0.6 | Load distribution |
| TaskCompleted | Workflow | 0.4 | Task notification |

## Fibonacci Agent Counts

All ALPHA orchestrators use Fibonacci sequences for agent/node counts:

- **CHIMERA**: 89 nodes (F11), 144 agents (F12)
- **PHANTOM**: 89 nodes (F11), 233 agents (F13)
- **ORBITAL**: 55 nodes (F10), 89 agents (F11)
- **IRONVEIL**: 55 nodes (F10), 89 agents (F11)

**Total**: 288 field nodes, 555 agents/monitors/sentinels

## Mathematical Foundation

### Kuramoto Synchronization
Each ALPHA uses Kuramoto phase-locking:

```
dθ_i/dt = ω_i + (K/N) Σ_j sin(θ_j - θ_i)
```

Where:
- θ_i = phase of node i
- ω_i = natural frequency
- K = coupling strength
- N = total nodes

Order parameter R measures coherence:
```
R = |1/N Σ_j e^(iθ_j)|
```

### ACO Stigmergy
Pheromone-based priority:

```
τ_ij(t+1) = (1-ρ)τ_ij(t) + Δτ_ij
```

Where:
- τ = pheromone level
- ρ = evaporation rate
- Δτ = new pheromone deposit

### Signal Propagation
Cross-domain signal strength:

```
S_out(i) = Σ_j [C(i,j) × S_in(j) × urgency(j) × confidence(j)]
```

Where:
- C(i,j) = coupling matrix (18×18)
- S_in(j) = input signal from domain j
- urgency ∈ [0,1]
- confidence ∈ [0,1]

## Usage Examples

### Example 1: Monitor Space Domain Threats

```motoko
// Get orbital status
let orbital = await getAlphaOrbitalStatus();

if (orbital.maxThreat > 0.3) {
  // Check signal bus for cross-domain effects
  let bus = await getSignalBusStatus();

  // ORBITAL threat should elevate GuardianDefense and Fear domains
  // Check if defensive measures are automatically engaged
};
```

### Example 2: Monitor Infrastructure Cascades

```motoko
// Get infrastructure status
let ironveil = await getAlphaIronveilStatus();

if (ironveil.maxCascadeRisk > 0.7) {
  // Critical cascade risk
  // Signal bus will automatically propagate to:
  // - GuardianDefense (for defense activation)
  // - Economic (for resource allocation)
  // - Fear (for threat awareness)
  // - Anticipatory (for pre-positioning)
};
```

### Example 3: Track Virtual Swarm Load

```motoko
// Get phantom status
let phantom = await getAlphaPhantomStatus();

if (phantom.totalLoad > 0.8) {
  // Virtual swarm overloaded
  // Signal bus propagates ResourceStarvation to:
  // - ICPCycleEconomics (for cycle allocation)
  // - Architecture (for load balancing)
};
```

## Future Enhancements

1. **Bidirectional Coupling**: Allow SignalBus signals to modulate ALPHA behavior
2. **Adaptive Coupling**: Adjust coupling matrix based on organism state
3. **Signal Filtering**: Implement confidence thresholds per domain
4. **Historical Analysis**: Track signal patterns over time
5. **Predictive Alerts**: Use signal trends to predict future states

## File Locations

- **ALPHA I (CHIMERA)**: `/src/backend/genesis/alpha-chimera-orchestrator.mo`
- **ALPHA II (PHANTOM)**: `/src/backend/genesis/alpha-phantom-orchestrator.mo`
- **ALPHA III (ORBITAL)**: `/src/backend/genesis/alpha-orbital-orchestrator.mo`
- **ALPHA IV (IRONVEIL)**: `/src/backend/genesis/alpha-ironveil-orchestrator.mo`
- **Signal Bus**: `/src/backend/genesis/signal-propagation-bus.mo`
- **Main Integration**: `/src/backend/main.mo` (lines 14866-15257)

---

**© 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.**
