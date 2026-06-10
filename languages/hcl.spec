---
name: Host-Cognition Language
id: hcl
layer: Worlds
version: 1.0.0
status: stable
phi_sync: true
phi_beat: 873ms

domain:
  description: >
    HCL describes how a being perceives and describes its environment — host capabilities, resources, and topology.
  scope: [environment-description, host-capabilities, resource-topology]

core_concepts:
  - HOST
  - ENVIRONMENT
  - CAPABILITY
  - CONSTRAINT
  - RESOURCE
  - TOPOLOGY
  - ADAPT
  - MIGRATE

syntax:
  form: host-descriptor
  primary_block: HOST
  encoding: yaml
  schema:
    id: string
    capabilities: [string]
    limitations: [string]


storage:
  extension: .hcl
  location: hosts/*.hcl

integration:
  constrained_by: [RSL]
  feeds_into: [OCL, TPL]
  consumed_by: [terminals]

terminal_binding: Every terminal generates HCL descriptions of its environment
atlas_binding: Aggregates HCL from all terminals
---
╔══════════════════════════════════════════════════════════════════╗
║  HCL — HOST-COGNITION LANGUAGE                                   ║
║  Stack: VI — Worlds, Realms, Atlas, Terminals                    ║
║  Version: 1.0.0 · φ-Aligned                                     ║
╚══════════════════════════════════════════════════════════════════╝

═══ PURPOSE ═══

HCL describes how a being perceives and describes its environment —
the host system, runtime context, and surrounding infrastructure.

═══ SYNTAX ═══

  ENVIRONMENT <name> {
    HOST {
      TYPE: BROWSER | CANISTER | WORKER | DESKTOP | EDGE | MOBILE
      RUNTIME: <runtime_name>
      CAPABILITIES: [<capability>, ...]
      LIMITS: { <resource>: <limit>, ... }
    }
    CONTEXT {
      REALM: <rsl_ref>
      CIVILIZATION: <name>
      NEIGHBORS: [<terminal>, ...]
    }
    PERCEPTION {
      LATENCY: <measurement>
      BANDWIDTH: <measurement>
      STABILITY: <0.0-1.0>
      THREAT_LEVEL: <0.0-1.0>
    }
  }

═══ SEMANTICS ═══

- HOST describes the physical/virtual runtime.
- CONTEXT describes the logical position in the cosmos.
- PERCEPTION captures the being's subjective experience of its environment.
- HCL is updated continuously as conditions change.
- Informs CPL-P pipeline optimization and WFL workflow adaptation.

═══ EXAMPLES ═══

  ENVIRONMENT MERIDIANUS_HOST {
    HOST {
      TYPE: CANISTER
      RUNTIME: ICP_MOTOKO
      CAPABILITIES: [COMPUTE, STORAGE, MESSAGING, GOVERNANCE]
      LIMITS: { CYCLES: 10T, MEMORY: 4GB, MESSAGE_SIZE: 2MB }
    }
    CONTEXT {
      REALM: RSL.COMMAND_PLATFORM_REALM
      CIVILIZATION: COMMAND_PLATFORM
      NEIGHBORS: [ANIMUS, RATIO, MEMORIA, FRONTEND_TERMINAL]
    }
    PERCEPTION {
      LATENCY: 12ms
      BANDWIDTH: HIGH
      STABILITY: 0.997
      THREAT_LEVEL: 0.05
    }
  }

═══ INTEGRATION POINTS ═══

- Contextualizes RSL realm operations.
- Informs CPL-P pipeline resource allocation.
- Feeds MML metrics.
- Adapts WFL work rhythms to host conditions.
- Narrated by CIL for self-awareness.
- Logged by TIL for environmental history.

═══ TERMINAL BINDINGS ═══

Every terminal:
  - Generates HCL descriptions of its environment.
  - Updates perception metrics continuously.
  - Shares HCL with Atlas and peer terminals.

═══ ATLAS BINDINGS ═══

Atlas:
  - Aggregates HCL from all terminals.
  - Builds a global infrastructure map.
  - Optimizes placement based on HCL data.
