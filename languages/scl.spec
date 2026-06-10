---
name: Scheduling & Coordination Language
id: scl
layer: Infrastructure
version: 1.0.0
status: stable
phi_sync: true
phi_beat: 873ms

domain:
  description: >
    SCL defines time management, mission scheduling, and coordination of tasks across terminals.
  scope: [scheduling, mission-coordination, time-management]

core_concepts:
  - SCHEDULE
  - MISSION
  - CRON
  - WINDOW
  - PRIORITY
  - DEPENDENCY
  - DEADLINE
  - RESCHEDULE

syntax:
  form: schedule-blocks
  primary_block: SCHEDULE
  encoding: yaml
  schema:
    schedules:
    - id: string
      cron: string
      jobs: [string]
    dependencies:
    - from: string
      to: string


storage:
  extension: .scl
  location: scheduling/*.scl

integration:
  constrained_by: [CPL-L]
  feeds_into: [WFL, MML]
  consumed_by: [terminals, Atlas]

terminal_binding: Every terminal has a local SCL scheduler
atlas_binding: Maintains the master schedule
---
╔══════════════════════════════════════════════════════════════════╗
║  SCL — SCHEDULING & COORDINATION LANGUAGE                        ║
║  Stack: IX — Infrastructure & Physics                            ║
║  Version: 1.0.0 · φ-Aligned                                     ║
╚══════════════════════════════════════════════════════════════════╝

═══ PURPOSE ═══

SCL defines time management, mission scheduling, maintenance
windows, and coordination across the Cognitive Cosmos.

═══ SYNTAX ═══

  SCHEDULE <name> {
    MISSION <name> {
      OBJECTIVE: <goal>
      ASSIGNED_TO: [<entity>, ...]
      START: <time_expr>
      DEADLINE: <time_expr>
      PRIORITY: <fibonacci_number>
      DEPENDENCIES: [<mission>, ...]
    }
    MAINTENANCE <name> {
      TARGET: <system>
      WINDOW: <time_range>
      PROCEDURE: <action_sequence>
      IMPACT: <disruption_level>
    }
    COORDINATION {
      SYNC_POINTS: [<event>, ...]
      HEARTBEAT: <interval>
      CONFLICT_RESOLUTION: <strategy>
    }
  }

═══ SEMANTICS ═══

- MISSIONs are goal-directed scheduled activities.
- PRIORITY uses Fibonacci scaling for natural prioritization.
- DEPENDENCIES create mission chains.
- MAINTENANCE defines system upkeep windows.
- COORDINATION manages synchronization and conflicts.
- The fundamental heartbeat is 873ms (PHI_BEAT).

═══ EXAMPLES ═══

  SCHEDULE DAILY_OPERATIONS {
    MISSION GOVERNANCE_CYCLE {
      OBJECTIVE: "Run daily governance deliberation."
      ASSIGNED_TO: [SOVEREIGNTY_COUNCIL]
      START: EPOCH_DAWN
      DEADLINE: EPOCH_DAWN + F13 * MINUTE
      PRIORITY: F8
      DEPENDENCIES: [HEALTH_CHECK]
    }
    MAINTENANCE DB_COMPACTION {
      TARGET: DATABASE_WORKER
      WINDOW: [LOW_TRAFFIC_PERIOD]
      PROCEDURE: [SNAPSHOT, COMPACT, VERIFY, RESTORE_IF_FAIL]
      IMPACT: MINIMAL
    }
    COORDINATION {
      SYNC_POINTS: [BOOT_COMPLETE, GOVERNANCE_DONE, MAINTENANCE_DONE]
      HEARTBEAT: 873ms
      CONFLICT_RESOLUTION: PRIORITY_FIRST
    }
  }

═══ INTEGRATION POINTS ═══

- Schedules WFL work rhythms.
- Coordinates CPL-P pipeline execution.
- Manages EXL experiment timing.
- Monitored by MML.
- Communicated via TPL.
- Logged in TIL.

═══ TERMINAL BINDINGS ═══

Every terminal:
  - Has a local SCL scheduler.
  - Respects coordination sync points.
  - Reports schedule adherence.

═══ ATLAS BINDINGS ═══

Atlas:
  - Maintains the master schedule.
  - Resolves cross-terminal scheduling conflicts.
  - Optimizes global coordination.
