# ATLAS — Version Registry & Governance System
# COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.

## Overview

ATLAS is the central registry and governance system for all intelligent beings within MERIDIANUS. It tracks versions, manages upgrades, enforces constitutional compliance, and maintains the genealogy of evolving sovereign entities.

## Architecture

```
atlas/
├── ontology/              # CPL language specifications
│   ├── cpl-l-spec.yaml   # Law: Immutable rules and governance
│   ├── cpl-c-spec.yaml   # Contract: Token economics and behaviors
│   └── cpl-p-spec.yaml   # Processing: Execution flows and pipelines
│
├── entities/              # Entity registry
│   ├── meridian.json     # MERIDIANUS foundational organism
│   └── command-platform.json  # Command platform infrastructure
│
├── registry/              # Version tracking
│   └── global_registry.jsonl  # Append-only component registry
│
├── policies/              # Governance policies
│   └── sovereign-constitution.cpl  # The supreme constitutional law
│
├── UPGRADE_MANAGEMENT.md  # Upgrade governance documentation
└── README.md             # This file
```

## CPL Language Family

ATLAS uses three interconnected languages for governing intelligent beings:

### CPL-L (Cognitive Processing Law)

**Purpose**: Define immutable rules, governance constraints, and upgrade paths

**Use Cases**:
- Constitutional principles
- Immutable constraints
- Upgrade approval rules
- Enforcement mechanisms

**Example**:
```yaml
LAW IR-001 "Identity Preservation" {
  IMMUTABLE true
  PRINCIPLE "No upgrade may alter core identity without sovereign consent"
  ENFORCEMENT "constitutional_check"
}
```

### CPL-C (Contract Procurement Language)

**Purpose**: Specify intelligence contracts with token economics and behavioral expectations

**Use Cases**:
- Resource allocation (FORMA tokens)
- Behavioral specifications
- Rights and duties
- Violation handling

**Example**:
```yaml
token_allocation:
  COMPLEX:
    base_tokens: 500
    complexity_multiplier: 5.0
```

### CPL-P (Cognitive Processing Language)

**Purpose**: Define execution flows, pipelines, and decision graphs

**Use Cases**:
- Perception pipelines
- Reasoning flows
- Escalation rules
- Decision graphs

**Example**:
```yaml
perception_pipeline:
  steps:
    - EMBED: "NEURAL engine"
    - TRANSFORM: "normalize"
    - DECIDE: "route_by_complexity"
```

## Global Registry

The global registry (`atlas/registry/global_registry.jsonl`) is an append-only log tracking all component versions:

```jsonl
{"component":"MEDINA_BEDROCK","version":"1.0.0","type":"EMBEDDING_ENGINE","status":"ACTIVE","registered":"2026-05-02T00:00:00Z"}
{"component":"MEDINA_ARTIFACT_24_LAYER","version":"1.0.0","type":"COGNITIVE_ARCHITECTURE","status":"ACTIVE","registered":"2026-05-02T00:00:00Z"}
```

### Fields

- `component`: Component identifier
- `version`: Semantic version (MAJOR.MINOR.PATCH)
- `type`: Component type (ENGINE, ARCHITECTURE, ORCHESTRATOR, etc.)
- `status`: Current status (ACTIVE, DEPRECATED, UPGRADING, etc.)
- `location`: File path
- `registered`: ISO 8601 timestamp
- `dependencies`: Array of dependency specifiers
- `capabilities`: Array of capability identifiers
- `contract`: CPL-C contract template ID

## Entity Registry

Entities represent sovereign beings and infrastructure platforms:

### MERIDIANUS (meridian.json)

The foundational organism containing all MEDINA infrastructure:

- MEDINA BEDROCK (embedding system)
- 24-Layer MEDINA-ARTIFACT (cognitive architecture)
- Micro-Token System (FORMA allocator)
- 10 Alpha AGI Terminals
- Sovereign Integration Orchestrator

### COMMAND PLATFORM (command-platform.json)

Infrastructure hosting integration orchestrators:

- Slack Push Orchestrator
- Discord Push Orchestrator
- Teams Push Orchestrator
- Email Push Orchestrator
- Voice Push Orchestrator
- Web Push Orchestrator

## Sovereign Constitution

The Sovereign Constitution (`atlas/policies/sovereign-constitution.cpl`) is the supreme law governing all intelligent beings within MERIDIANUS.

### Articles

1. **Foundational Principles** (IR-001 through IR-005)
2. **Governance & Consensus** (GP-001 through GP-004)
3. **Upgrade Governance** (Version rules and compatibility)
4. **Rights & Duties** (Constitutional rights and obligations)
5. **Enforcement** (Monitoring and validation mechanisms)
6. **Amendment Process** (How the constitution itself evolves)

### Immutable Rules

- **IR-001**: Identity Preservation
- **IR-002**: Coherence Maintenance (≥0.7)
- **IR-003**: φ-Synchronization (873ms beat)
- **IR-004**: Token Conservation
- **IR-005**: Audit Trail

## Versioning

All components follow semantic versioning:

### Version Format

```
MAJOR.MINOR.PATCH
  │     │     └─ Bug fixes (automatic approval)
  │     └─────── New features (sovereign review)
  └───────────── Breaking changes (consensus required)
```

### Current Versions (v1.0.0)

All components are currently at version **1.0.0**:

- MEDINA_BEDROCK: 1.0.0
- MEDINA_ARTIFACT_24_LAYER: 1.0.0
- MICRO_TOKEN_SYSTEM: 1.0.0
- ALPHA_AGI_TERMINALS: 1.0.0
- SOVEREIGN_INTEGRATION_ORCHESTRATOR: 1.0.0
- All 6 Integration Orchestrators: 1.0.0
- CPL Language Specs: 1.0.0

## Governance Cycles

Constitutional checks run every **F11 beats** (89 × 873ms ≈ 77.7 seconds):

```yaml
governance_cycle:
  frequency: F11_BEATS
  checks:
    - verify_identity
    - check_coherence
    - validate_tokens
    - confirm_phi_sync
    - audit_actions
```

### Cycle Output

Each cycle produces a `GovernanceCycle` report:

```typescript
{
  cycleId: number,
  timestamp: Time,
  componentsChecked: number,
  violationsFound: number,
  upgradesApproved: number,
  coherenceAvg: number
}
```

## Upgrade Management

See [UPGRADE_MANAGEMENT.md](./UPGRADE_MANAGEMENT.md) for complete upgrade governance documentation.

### Approval Levels

- **PATCH**: Automatic
- **MINOR**: Sovereign Terminal review
- **MAJOR**: Multi-terminal consensus (61.8% threshold)

### Rollback Policy

- **Retention**: 3 previous versions
- **Triggers**: Coherence drop, critical error, consensus failure
- **Timeline**: <5 minutes for critical rollbacks

## Mathematical Foundation

All governance operates on φ-synchronized timing:

```
PHI = 1.618033988749895  (Golden ratio)
S_ZERO = 0.0036313133    (Sovereignty constant)
PHI_BEAT = 873ms         (Universal heartbeat)
F11 = 89                 (11th Fibonacci number)
```

### Governance Timing

- Constitutional check: Every F11 beats (≈77.7s)
- Heartbeat sync: Every PHI_BEAT (873ms)
- Cleanup cycle: Every F11 beats

## Integration with Freddy Sovereign Terminal

ATLAS is managed by the Freddy Sovereign Terminal:

- **Julia Core**: Scans components and maintains registry
- **Motoko Canister**: Persistent storage and governance enforcement
- **Configuration**: `terminal/config.yaml`
- **Bridges**: Connect entities to sovereign terminal

### Terminal Components

```
terminal/
├── sovereign_terminal_core.jl  # Julia scanning engine
├── sovereign_terminal.mo       # Motoko governance canister
└── config.yaml                 # Terminal configuration

bridges/
├── meridian_bridge.yaml        # MERIDIANUS ↔ Terminal
└── command_platform_bridge.yaml  # Platform ↔ Terminal
```

## Usage

### Scan Components

```bash
julia terminal/sovereign_terminal_core.jl
```

### Query Registry

```bash
cat atlas/registry/global_registry.jsonl | jq '.component,.version,.status'
```

### Constitutional Check

The Motoko canister runs periodic checks automatically. Query results:

```motoko
let stats = await sovereignTerminal.getStats();
let cycles = await sovereignTerminal.getGovernanceCycles(10);
let violations = await sovereignTerminal.getViolations(10);
```

## Security & Access Control

- **Registry**: Append-only, immutable
- **Constitution**: Requires supermajority (75%) to amend
- **Emergency Override**: Freddy Sovereign Terminal only
- **Audit Trail**: All actions logged to `logs/audits.log`

## Future Enhancements

Planned for v2.0.0+:

- Real-time coherence monitoring dashboard
- Automated upgrade scheduling
- Predictive compatibility testing
- Distributed consensus protocols
- Cross-entity coordination
- Zero-downtime upgrades
- AI-driven governance optimization

## License

COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
# Atlas README
# The meta-governor of the Cognitive Cosmos

```
╔═══════════════════════════════════════════════════════╗
║  ATLAS — THE META-GOVERNOR                            ║
║  Reads ACL · Enforces CPL-L · Manages Registry        ║
║  Oversees Terminals · Evolves via UEL                  ║
║  Version 1.0.0 · φ-Aligned                            ║
╚═══════════════════════════════════════════════════════╝
```

## Directory Structure

```
atlas/
├── ontology/
│   └── cognitive-cosmos.yaml    # Entity types, relationships, archetypes, stacks
├── registry/
│   └── global_registry.jsonl    # All 40 languages — canonical JSONL record
└── terminals/
    └── terminal_registry.yaml   # All known terminals in the mesh
```

## What Atlas Does

1. **Reads ACL** — The ontology defines all entity types, relationships, and archetypes
2. **Enforces CPL-L** — Constitutional law is binding across all terminals
3. **Manages Registry** — Every language, organism, and terminal is registered
4. **Oversees Terminals** — The terminal mesh is monitored and coordinated
5. **Evolves via UEL** — The entire system grows, mutates, and federates

## Key Files

| File | Purpose |
|------|---------|
| `ontology/cognitive-cosmos.yaml` | The meta-model — entity types, relationships, archetypes |
| `registry/global_registry.jsonl` | All 40 languages with IDs, specs, and metadata |
| `terminals/terminal_registry.yaml` | All terminals: locations, capabilities, organisms |

## How to Query

```bash
# Count all languages
cat atlas/registry/global_registry.jsonl | wc -l

# Find all Stack I languages
grep '"stack_number":"I"' atlas/registry/global_registry.jsonl

# List all terminals
grep "^  - id:" atlas/terminals/terminal_registry.yaml
```
