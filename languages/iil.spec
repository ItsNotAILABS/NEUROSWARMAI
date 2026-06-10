---
name: Integration Interface Language
id: iil
layer: Enterprise
version: 1.0.0
status: stable
phi_sync: true
phi_beat: 873ms

domain:
  description: >
    IIL defines APIs, ETL pipelines, event buses, SSO, and all integration interfaces between systems.
  scope: [APIs, ETL, SSO, system-integration]

core_concepts:
  - INTERFACE
  - ENDPOINT
  - TRANSFORM
  - ROUTE
  - AUTHENTICATE
  - AUTHORIZE
  - THROTTLE
  - MONITOR

syntax:
  form: interface-blocks
  primary_block: INTERFACE
  encoding: yaml
  schema:
    endpoints:
    - id: string
      url: string
      method: string
    mappings:
    - from: string
      to: string
    policies: [string]


storage:
  extension: .iil
  location: enterprise/integration/*.iil

integration:
  constrained_by: [ECL, DDL]
  feeds_into: [TPL, MML]
  consumed_by: [systems]

terminal_binding: Every terminal exposes IIL interfaces for its capabilities
atlas_binding: Maintains the interface registry
---
╔══════════════════════════════════════════════════════════════════╗
║  IIL — INTEGRATION INTERFACE LANGUAGE                            ║
║  Stack: VIII — Enterprise & Organizational                       ║
║  Version: 1.0.0 · φ-Aligned                                     ║
╚══════════════════════════════════════════════════════════════════╝

═══ PURPOSE ═══

IIL defines APIs, ETL pipelines, event buses, SSO, and all
integration interfaces between systems within and across
civilizations.

═══ SYNTAX ═══

  INTERFACE <name> {
    TYPE: API | ETL | EVENT_BUS | SSO | WEBHOOK | STREAM
    ENDPOINT {
      PATH: <route>
      METHOD: <http_method> | <custom_protocol>
      AUTH: <auth_scheme>
      RATE_LIMIT: <fibonacci_number> / <period>
    }
    SCHEMA {
      INPUT: <data_shape>
      OUTPUT: <data_shape>
      ERRORS: [<error_type>, ...]
    }
    TRANSFORM {
      MAP: <field_mapping>
      FILTER: <predicate>
      ENRICH: <enrichment_source>
    }
    EVENT <name> {
      TRIGGER: <condition>
      PAYLOAD: <data_shape>
      SUBSCRIBERS: [<entity>, ...]
    }
  }

═══ SEMANTICS ═══

- INTERFACEs are typed integration points.
- ENDPOINTs define how to connect.
- RATE_LIMIT uses Fibonacci scaling.
- SCHEMAs define data contracts.
- TRANSFORMs handle data mapping and enrichment.
- EVENTs enable asynchronous integration.

═══ EXAMPLES ═══

  INTERFACE COGNITIVE_API {
    TYPE: API
    ENDPOINT {
      PATH: /api/v1/cognition
      METHOD: POST
      AUTH: ED25519_SIGNED
      RATE_LIMIT: F11 / MINUTE
    }
    SCHEMA {
      INPUT: { query: String, context: Map, model: ModelTier }
      OUTPUT: { response: String, confidence: Float, trace: CIL_Trace }
      ERRORS: [RATE_LIMITED, UNAUTHORIZED, OVERLOADED]
    }
  }

  INTERFACE TELEMETRY_STREAM {
    TYPE: STREAM
    EVENT HEALTH_TICK {
      TRIGGER: EVERY(873ms)
      PAYLOAD: { terminal: ID, metrics: HealthMap }
      SUBSCRIBERS: [ATLAS, MML_AGGREGATOR]
    }
  }

═══ INTEGRATION POINTS ═══

- Connects all language systems.
- Validated by ECL compliance.
- Used by BCL business contracts.
- Monitored by MML.
- Defined in DDL data shapes.
- Secured by CPL-L.

═══ TERMINAL BINDINGS ═══

Every terminal:
  - Exposes IIL interfaces for its capabilities.
  - Validates all input/output against schemas.
  - Enforces rate limits.

═══ ATLAS BINDINGS ═══

Atlas:
  - Maintains the interface registry.
  - Routes cross-terminal integrations.
  - Monitors interface health.
