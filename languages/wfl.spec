---
name: Work Flow Language
id: wfl
layer: WorkCraft
version: 1.0.0
status: stable
phi_sync: true
phi_beat: 873ms

domain:
  description: >
    WFL encodes personal and organizational work rhythms — how tasks, sprints, and rest cycles are structured.
  scope: [work-rhythms, task-management, sprint-cycles, rest-patterns]

core_concepts:
  - WORKFLOW
  - RHYTHM
  - TASK
  - SPRINT
  - REST
  - FOCUS
  - BLOCK
  - REVIEW

syntax:
  form: rhythm-blocks
  primary_block: WORKFLOW
  encoding: yaml
  schema:
    sessions:
    - id: string
      mode: string
      duration_minutes: integer
      context_window: string
      interrupt_policy: string


semantics:
  - Guides how terminals schedule missions and tasks for agents.

storage:
  extension: .wfl
  location: work/*.wfl

integration:
  constrained_by: [SCL]
  feeds_into: [CXL, EXL]
  consumed_by: [organisms, terminals]

terminal_binding: Every terminal runs on a WFL work rhythm
atlas_binding: Optimizes workflow distribution
---
╔══════════════════════════════════════════════════════════════════╗
║  WFL — WORK FLOW LANGUAGE                                        ║
║  Stack: IV — Work, Craft, Creation                               ║
║  Version: 1.0.0 · φ-Aligned                                     ║
╚══════════════════════════════════════════════════════════════════╝

═══ PURPOSE ═══

WFL encodes personal and organizational work rhythms — how tasks
flow, how attention is managed, and how productivity cycles align
with natural φ-rhythms.

═══ SYNTAX ═══

  WORKFLOW <name> {
    RHYTHM {
      BEAT: <duration>
      CYCLE: [<phase>, ...]
      REST: <recovery_period>
    }
    TASK <name> {
      PRIORITY: <fibonacci_number>
      EFFORT: <fibonacci_number>
      DEPENDENCIES: [<task>, ...]
      DEADLINE: <time_expr>
    }
    FOCUS {
      MODE: DEEP | BROAD | SCAN | REST
      DURATION: <fibonacci_beats>
      SWITCH_COST: <fibonacci_number>
    }
  }

═══ SEMANTICS ═══

- RHYTHM defines the fundamental work heartbeat.
- BEAT aligns with the organism's PHI_BEAT (873ms default).
- TASKs have Fibonacci-scaled priority and effort.
- FOCUS modes define attention allocation patterns.
- SWITCH_COST penalizes context switching.

═══ EXAMPLES ═══

  WORKFLOW MERIDIANUS_DAILY {
    RHYTHM {
      BEAT: 873ms
      CYCLE: [BOOT, PROCESS, CREATE, REFLECT, REST]
      REST: F8 * BEAT
    }
    TASK PROCESS_QUERIES {
      PRIORITY: F8
      EFFORT: F5
      DEPENDENCIES: [BOOT]
      DEADLINE: END_OF_CYCLE
    }
    FOCUS {
      MODE: DEEP
      DURATION: F13 * BEAT
      SWITCH_COST: F3
    }
  }

═══ INTEGRATION POINTS ═══

- Scheduled by SCL coordination.
- Narrated by CIL inner monologue.
- Drives CXL creation workflows.
- Fed by EXL experiment results.
- Tracked by MML metrics.
- Logged in TIL timeline.

═══ TERMINAL BINDINGS ═══

Every terminal:
  - Runs on a WFL work rhythm.
  - Manages task queues per WFL priorities.
  - Reports productivity metrics.

═══ ATLAS BINDINGS ═══

Atlas:
  - Optimizes workflow distribution.
  - Detects burnout patterns (overwork without REST).
  - Balances load across terminals.
