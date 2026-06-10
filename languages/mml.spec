---
name: Metrics & Monitoring Language
id: mml
layer: Infrastructure
version: 1.0.0
status: stable
phi_sync: true
phi_beat: 873ms

domain:
  description: >
    MML defines observability, fairness metrics, health monitoring, and alerting across the civilization.
  scope: [observability, health-monitoring, alerting, dashboards]

core_concepts:
  - METRIC
  - GAUGE
  - COUNTER
  - HISTOGRAM
  - ALERT
  - THRESHOLD
  - DASHBOARD
  - ANOMALY

syntax:
  form: metric-blocks
  primary_block: METRIC
  encoding: yaml
  schema:
    metrics:
    - id: string
      description: string
      unit: string
    alerts:
    - id: string
      metric: string
      condition: string
    dashboards:
    - id: string
      widgets: [string]


storage:
  extension: .mml
  location: observability/*.mml

integration:
  constrained_by: [DDL]
  feeds_into: [ERR, SCL]
  consumed_by: [operators, Atlas]

terminal_binding: Every terminal collects and reports MML metrics
atlas_binding: Aggregates all metrics civilization-wide
---
╔══════════════════════════════════════════════════════════════════╗
║  MML — METRICS & MONITORING LANGUAGE                             ║
║  Stack: IX — Infrastructure & Physics                            ║
║  Version: 1.0.0 · φ-Aligned                                     ║
╚══════════════════════════════════════════════════════════════════╝

═══ PURPOSE ═══

MML defines observability, fairness metrics, health monitoring,
and the measurement framework for the entire Cognitive Cosmos.

═══ SYNTAX ═══

  METRIC <name> {
    TYPE: GAUGE | COUNTER | HISTOGRAM | SUMMARY
    UNIT: <measurement_unit>
    SOURCE: <data_source>
    COLLECTION: PUSH | PULL
    INTERVAL: <fibonacci_beats>
  }

  MONITOR <name> {
    METRICS: [<metric>, ...]
    THRESHOLD {
      WARNING: <value>
      CRITICAL: <value>
      PHI_DEVIATION: <ratio>
    }
    ALERT {
      CHANNEL: <tpl_channel>
      SEVERITY: <fibonacci_number>
      ESCALATION: [<action>, ...]
    }
  }

  DASHBOARD <name> {
    PANELS: [
      { METRIC: <metric>, VISUALIZATION: <chart_type> },
      ...
    ]
    REFRESH: <fibonacci_beats>
  }

═══ SEMANTICS ═══

- METRICs are typed measurements with collection intervals.
- MONITORs define thresholds and alert rules.
- PHI_DEVIATION triggers when metrics deviate from φ-harmony.
- DASHBOARDs aggregate metrics into visual panels.
- Fibonacci-scaled intervals ensure natural monitoring rhythms.

═══ EXAMPLES ═══

  METRIC TERMINAL_HEALTH {
    TYPE: GAUGE
    UNIT: PERCENTAGE
    SOURCE: TERMINAL_SELF_REPORT
    COLLECTION: PUSH
    INTERVAL: F5 * BEAT
  }

  MONITOR CIVILIZATION_HEALTH {
    METRICS: [TERMINAL_HEALTH, QUERY_LATENCY, ERROR_RATE, TRUST_LEVEL]
    THRESHOLD {
      WARNING: HEALTH < 0.89
      CRITICAL: HEALTH < 0.618
      PHI_DEVIATION: 0.1
    }
    ALERT {
      CHANNEL: TPL.GOVERNANCE_BUS
      SEVERITY: F8
      ESCALATION: [NOTIFY_COUNCIL, ACTIVATE_RIL, QUARANTINE]
    }
  }

═══ INTEGRATION POINTS ═══

- Monitors all language system operations.
- Feeds EXL experiment measurements.
- Validates ECL compliance metrics.
- Tracks BCL SLA performance.
- Reported via TPL.
- Archived by TIL.

═══ TERMINAL BINDINGS ═══

Every terminal:
  - Collects and reports MML metrics.
  - Runs local monitors with alerts.
  - Exposes metric endpoints via IIL.

═══ ATLAS BINDINGS ═══

Atlas:
  - Aggregates all metrics civilization-wide.
  - Maintains global dashboards.
  - Triggers alerts and escalations.
