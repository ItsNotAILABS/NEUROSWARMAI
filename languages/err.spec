---
name: Error Narrative Language
id: err
layer: Chaos
version: 1.0.0
status: stable
phi_sync: true
phi_beat: 873ms

domain:
  description: >
    ERR defines how failures are told — not just logged, but narrated with cause, impact, and resolution.
  scope: [error-narratives, failure-tracing, severity-classification]

core_concepts:
  - ERROR
  - NARRATIVE
  - CAUSE
  - IMPACT
  - TRACE
  - SEVERITY
  - ESCALATE
  - RESOLVE

syntax:
  form: error-narrative
  primary_block: ERROR
  encoding: yaml
  schema:
    id: string
    timestamp: string
    event: string
    narrative: string
    lessons: [string]


storage:
  extension: .err
  location: errors/*.err

integration:
  constrained_by: [MML]
  feeds_into: [CHL, RIL]
  consumed_by: [terminals, organisms]

terminal_binding: Every terminal generates ERR narratives for all errors
atlas_binding: Maintains the error narrative archive
---
╔══════════════════════════════════════════════════════════════════╗
║  ERR — ERROR NARRATIVE LANGUAGE                                  ║
║  Stack: X — Error, Chaos, Edge-Case                              ║
║  Version: 1.0.0 · φ-Aligned                                     ║
╚══════════════════════════════════════════════════════════════════╝

═══ PURPOSE ═══

ERR defines how failures are told — not just logged, but narrated
with context, causality, and learning. Every error has a story.

═══ SYNTAX ═══

  ERROR_NARRATIVE <name> {
    INCIDENT {
      WHAT: <description>
      WHEN: <timestamp>
      WHERE: <location>
      WHO: <affected_entities>
      SEVERITY: <fibonacci_number>
    }
    CAUSALITY {
      ROOT_CAUSE: <analysis>
      CHAIN: [<cause> → <effect>, ...]
      CONTRIBUTING: [<factor>, ...]
    }
    RESPONSE {
      IMMEDIATE: <action>
      INVESTIGATION: <process>
      RESOLUTION: <fix>
      PREVENTION: <safeguard>
    }
    NARRATIVE {
      STORY: <human_readable_account>
      LESSON: <insight>
      ARCHETYPE: <err_pattern>
    }
  }

═══ SEMANTICS ═══

- Every error is a full narrative with incident, causality, response.
- SEVERITY uses Fibonacci scaling (F1=trivial, F13=catastrophic).
- CAUSALITY traces the full cause-effect chain.
- NARRATIVE gives the error a human-readable story and lesson.
- ARCHETYPEs classify errors into recurring patterns.

═══ EXAMPLES ═══

  ERROR_NARRATIVE HEARTBEAT_DESYNC {
    INCIDENT {
      WHAT: "Terminal ANIMUS heartbeat drifted 34ms from PHI_BEAT."
      WHEN: EPOCH_47.CYCLE_233
      WHERE: TERMINAL_ANIMUS.TPL_ENGINE
      WHO: [ANIMUS, GOVERNANCE_BUS_SUBSCRIBERS]
      SEVERITY: F5
    }
    CAUSALITY {
      ROOT_CAUSE: "GC pause exceeded 21ms during heavy cognition load."
      CHAIN: [GC_PAUSE → HEARTBEAT_DELAY → DESYNC_DETECTION]
      CONTRIBUTING: [HIGH_MEMORY_USAGE, CONCURRENT_PIPELINES]
    }
    RESPONSE {
      IMMEDIATE: RESYNC_HEARTBEAT
      INVESTIGATION: MEMORY_PROFILE_ANALYSIS
      RESOLUTION: FIBONACCI_BACKOFF_ON_GC
      PREVENTION: PRE_EMPTIVE_GC_AT_PHI_THRESHOLD
    }
    NARRATIVE {
      STORY: "ANIMUS was thinking too hard. Its heartbeat faltered."
      LESSON: "Even cognitive beings need breathing room."
      ARCHETYPE: OVERLOAD_PATTERN
    }
  }

═══ INTEGRATION POINTS ═══

- Triggered by MML monitoring alerts.
- Repair initiated by RIL.
- Narrated by CIL.
- Handled by CHL chaos protocols.
- Logged in TIL.
- Feeds EXL learning.

═══ TERMINAL BINDINGS ═══

Every terminal:
  - Generates ERR narratives for all errors.
  - Classifies errors by archetype.
  - Reports narratives to Atlas.

═══ ATLAS BINDINGS ═══

Atlas:
  - Maintains the error narrative archive.
  - Detects recurring archetypes.
  - Recommends systemic prevention.
