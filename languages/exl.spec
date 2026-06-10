---
name: Experiment Language
id: exl
layer: WorkCraft
version: 1.0.0
status: stable
phi_sync: true
phi_beat: 873ms

domain:
  description: >
    EXL defines hypotheses, probes, experiments, and kill-switches for structured learning and iteration.
  scope: [hypotheses, probes, experiments, learnings]

core_concepts:
  - EXPERIMENT
  - HYPOTHESIS
  - PROBE
  - MEASURE
  - LEARN
  - KILL_SWITCH
  - ITERATE
  - CONCLUDE

syntax:
  form: experiment-protocol
  primary_block: EXPERIMENT
  encoding: yaml
  schema:
    hypothesis: string
    experiments:
    - id: string
      description: string
      metrics: [string]
      status: string
    outcomes:
    - experiment_id: string
      result: string
      notes: string


semantics:
  - Feeds RIL, CDL, and UEL for learning and evolution.

storage:
  extension: .exl
  location: experiments/*.exl

integration:
  constrained_by: [WFL, ECL]
  feeds_into: [CIL, MML]
  consumed_by: [organisms]

terminal_binding: Every terminal can run experiments within its OCL charter limits
atlas_binding: Coordinates multi-terminal experiments
---
╔══════════════════════════════════════════════════════════════════╗
║  EXL — EXPERIMENT LANGUAGE                                       ║
║  Stack: IV — Work, Craft, Creation                               ║
║  Version: 1.0.0 · φ-Aligned                                     ║
╚══════════════════════════════════════════════════════════════════╝

═══ PURPOSE ═══

EXL defines hypotheses, probes, experiments, kill-switches, and
learnings. It is the scientific method of the Cognitive Cosmos.

═══ SYNTAX ═══

  EXPERIMENT <name> {
    HYPOTHESIS: <proposition>
    PROBE {
      ACTION: <test_action>
      MEASURE: <metric>
      DURATION: <time_expr>
    }
    KILL_SWITCH {
      CONDITION: <abort_trigger>
      ACTION: ROLLBACK | HALT | QUARANTINE
    }
    RESULT {
      OUTCOME: CONFIRMED | DENIED | INCONCLUSIVE
      DATA: <measurements>
      LEARNING: <insight>
    }
  }

═══ SEMANTICS ═══

- Every HYPOTHESIS is a falsifiable proposition.
- PROBEs are bounded, measurable test actions.
- KILL_SWITCHes provide safety boundaries.
- RESULTs produce learnings regardless of outcome.
- Experiments feed into CXL creation and WFL workflow optimization.

═══ EXAMPLES ═══

  EXPERIMENT PHI_HEARTBEAT_OPTIMIZATION {
    HYPOTHESIS: "Reducing heartbeat from 873ms to 539ms improves throughput by φ."
    PROBE {
      ACTION: SET_BEAT(539)
      MEASURE: QUERIES_PER_SECOND
      DURATION: F13 * 60s
    }
    KILL_SWITCH {
      CONDITION: ERROR_RATE > 0.1
      ACTION: ROLLBACK
    }
    RESULT {
      OUTCOME: DENIED
      DATA: { throughput: +23%, errors: +89% }
      LEARNING: "873ms is the optimal φ-beat. Faster breaks coherence."
    }
  }

═══ INTEGRATION POINTS ═══

- Feeds CXL creation iteration.
- Monitored by MML metrics.
- Logged in TIL timeline.
- Narrated by CIL.
- Bounded by CPL-L safety laws.
- Scheduled by SCL.

═══ TERMINAL BINDINGS ═══

Every terminal:
  - Can run experiments within its OCL charter limits.
  - Enforces kill-switches autonomously.
  - Reports results to Atlas.

═══ ATLAS BINDINGS ═══

Atlas:
  - Coordinates multi-terminal experiments.
  - Prevents conflicting experiments.
  - Aggregates learnings into civilization knowledge.
