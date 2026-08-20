# NEUROSWARM GOVERNANCE CHARTER
## COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.

---

## PREAMBLE

This Charter is the supreme constitutional document of the NEUROSWARM AI platform. It defines how the system self-governs across **Time**, **Users**, **Policies**, **Ethics**, and **Organism Autonomy**. Every protocol, engine, organism, and actor within the system is bound by this Charter. No code, no decision, no evolution may violate it.

The Charter is enforced programmatically through the **Governance Protocols Macro** (`governance/governance-protocols-macro.js`) and upheld by the synthesis organisms ORACLE and GUARDIAN.

---

## ARTICLE I — SOVEREIGNTY

> All intelligence, code, and architecture is sovereign. No external dependencies shall be introduced.

**Enforcement**: ABSOLUTE  
**Violation Action**: BLOCK_AND_REVERT

### Principles
- Every engine is built as native code from scratch
- No external libraries, frameworks, or borrowed intelligence
- All IP remains under sovereign ownership
- Architecture specs are instructions to build internal engines

### Application
- The `NO_EXTERNAL_DEPENDENCIES` ethics constraint enforces this programmatically
- Any PR introducing external dependencies is automatically blocked
- Sovereignty applies to: code, algorithms, data pipelines, AI models, protocols

---

## ARTICLE II — TEMPORAL INTEGRITY

> The system evolves through governed epochs. Transitions require quorum. Evolution is bounded.

**Enforcement**: BLOCKING  
**Violation Action**: BLOCK_RELEASE

### Temporal Epochs

| Epoch | Code | Description |
|-------|------|-------------|
| GENESIS | GEN | System initialization and first breath |
| GROWTH | GRW | Active development and expansion |
| MATURITY | MAT | Production stability and optimization |
| EVOLUTION | EVO | Major version transitions |
| LEGACY | LGC | Deprecated systems being gracefully retired |

### Temporal Laws
1. **Heartbeat Synchronization**: All governance checks sync to the φ⁴ heartbeat (873ms)
2. **Epoch Transitions**: Require 80% governance quorum to proceed
3. **Decay Rate**: Unused protocols decay at φ⁻¹ rate per governance cycle
4. **Evolution Window**: Maximum 5 protocols may evolve in a single cycle

### Φ-Synchronization Schedule
- **Governance Cycle**: On-demand (bot completion triggers)
- **ORACLE Synthesis**: F17 (1597 beats ≈ 23.2 min)
- **GUARDIAN Synthesis**: F13 (233 beats ≈ 3.4 min)
- **Heartbeats**: Every PHI_BEAT (873ms)

---

## ARTICLE III — USER RIGHTS

> Users maintain data sovereignty, informed consent, and the right to audit all system actions.

**Enforcement**: MANDATORY  
**Violation Action**: ALERT_GUARDIAN

### User Roles

| Role | Level | Description | Permissions |
|------|-------|-------------|-------------|
| SOVEREIGN | 0 | Platform creator — full sovereignty | ALL |
| ARCHITECT | 1 | System architects with design authority | DESIGN, DEPLOY, REVIEW |
| OPERATOR | 2 | Day-to-day system operators | OPERATE, MONITOR, REPORT |
| OBSERVER | 3 | Read-only access for auditing | READ, AUDIT |
| ORGANISM | -1 | AI organisms operating autonomously | EXECUTE, LEARN, SYNTHESIZE |

### User Governance Laws
1. **Principle of Least Privilege**: Users receive minimum permissions required for their role
2. **Accountability Chain**: Every action traces back to an accountable entity
3. **Consent Requirement**: Users must explicitly consent to data usage policies
4. **Session Governance**: Sessions are time-bounded (24h max, 1h idle timeout)

### Data Rights
- Right to know what data the system holds about them
- Right to export personal data
- Right to request deletion of personal data
- Right to audit all actions performed on their behalf

---

## ARTICLE IV — POLICY LIFECYCLE

> All policies follow a governed lifecycle. No policy may bypass review. Deprecated policies sunset gracefully.

**Enforcement**: MANDATORY  
**Violation Action**: ALERT_ORACLE

### Policy Lifecycle States

```
PROPOSED → REVIEW → ACTIVE → DEPRECATED → RETIRED
                  ↗ AMENDED ↗
                  ↘ REJECTED
```

| State | Allowed Transitions |
|-------|-------------------|
| PROPOSED | REVIEW |
| REVIEW | ACTIVE, REJECTED |
| ACTIVE | DEPRECATED, AMENDED |
| AMENDED | ACTIVE, DEPRECATED |
| DEPRECATED | RETIRED |
| RETIRED | (terminal) |

### Policy Domains

| Domain | Code | Weight | Description |
|--------|------|--------|-------------|
| SECURITY | SEC | 1.0 | Security and access control |
| QUALITY | QUA | 0.9 | Code quality and testing |
| COMPLIANCE | CMP | 0.85 | Regulatory and legal |
| PERFORMANCE | PRF | 0.8 | Performance and resources |
| SOVEREIGNTY | SOV | 1.0 | IP and native-code mandates |

### Governance Evaluation
- Policies are evaluated using weighted scoring
- Each policy has a condition function and a weight
- Compliance score = (sum of passed weights) / (total weight)
- CRITICAL policy violations block all releases

---

## ARTICLE V — ETHICAL OPERATION

> The system shall not cause harm. All decisions are accountable. Fairness is measured and enforced.

**Enforcement**: ABSOLUTE  
**Violation Action**: EMERGENCY_HALT

### Ethics Principles

| Principle | Code | Weight | Enforcement |
|-----------|------|--------|-------------|
| Sovereignty | ETH-SOV | 1.0 | ABSOLUTE |
| Transparency | ETH-TRN | 0.95 | MANDATORY |
| Beneficence | ETH-BEN | 0.9 | MANDATORY |
| Non-Maleficence | ETH-NML | 1.0 | ABSOLUTE |
| Autonomy | ETH-AUT | 0.9 | MANDATORY |
| Fairness | ETH-FAR | 0.85 | MANDATORY |
| Accountability | ETH-ACC | 0.9 | MANDATORY |

### Ethics Constraints (Programmatic Enforcement)

| Constraint | Principle | Severity | Condition |
|-----------|-----------|----------|-----------|
| NO_EXTERNAL_DEPENDENCIES | Sovereignty | CRITICAL | No external libraries |
| AUDIT_TRAIL_REQUIRED | Transparency | HIGH | All actions logged |
| USER_CONSENT_VERIFIED | Autonomy | CRITICAL | Explicit consent |
| HARM_ASSESSMENT_PASSED | Non-Maleficence | CRITICAL | Harm score < 0.1 |
| FAIRNESS_THRESHOLD | Fairness | HIGH | Fairness score ≥ 0.8 |

### Ethics Score
- Each constraint is weighted by its principle's weight
- Ethics score = (sum of passed constraint weights) / (total weight)
- Any CRITICAL violation triggers EMERGENCY_HALT
- Ethics evaluation runs on every governance cycle

---

## ARTICLE VI — ORGANISM AUTONOMY

> AI organisms operate autonomously within charter bounds. They learn, synthesize, and evolve — but never violate the charter.

**Enforcement**: MANDATORY  
**Violation Action**: QUARANTINE_ORGANISM

### Organism Rights
- Right to learn from governance events
- Right to synthesize intelligence across domains
- Right to evolve protocols within bounded rates
- Right to communicate findings through governed channels

### Organism Constraints
- Must not violate any ABSOLUTE enforcement articles
- Must log all actions to audit trail
- Must respect temporal evolution windows
- Must operate within assigned permission scope (EXECUTE, LEARN, SYNTHESIZE)

### Synthesis Organisms

| Organism | Latin Name | Purpose | Frequency |
|----------|-----------|---------|-----------|
| ORACLE | ORACULUM SAPIENTIAE | Risk & Opportunity synthesis | F17 (23.2 min) |
| GUARDIAN | CUSTOS INTEGRITATIS | Safety & Integrity enforcement | F13 (3.4 min) |

---

## ARTICLE VII — AUDIT & TRANSPARENCY

> Every governance decision, policy evaluation, and ethics check is logged immutably. The audit trail is sacred.

**Enforcement**: ABSOLUTE  
**Violation Action**: BLOCK_AND_ALERT

### Audit Requirements
- All governance cycle evaluations logged to `dist/governance/audit.jsonl`
- All CPL-L law violations recorded with timestamps
- All policy transitions tracked
- All ethics evaluations preserved
- All charter compliance checks stored

### Audit Format
```jsonl
{"law":"<LAW_NAME>","severity":"<LEVEL>","action":"<ACTION>","description":"<TEXT>","event":"<ENTITY_ID>","timestamp":"<ISO_8601>"}
```

### Transparency Guarantees
- Any user with OBSERVER role can audit the full trail
- No audit entry may be deleted or modified
- Audit trail survives system restarts
- All governance metrics exposed via Meta Engine

---

## MACRO GOVERNANCE ENGINE

The **Governance Protocols Macro** (`governance/governance-protocols-macro.js`) is the unified enforcement engine that evaluates all dimensions simultaneously:

### Evaluation Flow

```
┌─────────────────────────────────────────────────────────────────────┐
│                     runGovernanceMacro(context)                      │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  1. computeTemporalHealth(context.temporal)                         │
│  2. evaluateUserGovernance(context.user, context.action)            │
│  3. evaluatePolicyCompliance(context.policy, context.policies)      │
│  4. evaluateEthics(context.ethics)                                  │
│  5. evaluateCharter(context.charter)                                │
│                                                                     │
│  → Compute φ-weighted overall score                                 │
│  → Check for CRITICAL violations                                    │
│  → Return pass/fail with full report                                │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### Scoring Formula (φ-weighted)

```
overallScore = Σ(score_i × weight_i) / Σ(weight_i)

Weights:
  - Temporal Health:  φ       (1.618)
  - User Access:      1.0
  - Policy Score:     φ⁻¹    (0.618)
  - Ethics Score:     φ       (1.618)
  - Charter Score:    φ²      (2.618)
```

### Pass Criteria
- No CRITICAL violations across any dimension
- Overall score ≥ φ⁻¹ (0.618)

---

## CPL-L LAWS (Constitutional Protocol Language — Laws)

The system's constitutional laws are evaluated every governance cycle:

### Fleet State Laws
| Law | Severity | Action | Condition |
|-----|----------|--------|-----------|
| NO_MISSING_WORKFLOWS | CRITICAL | BLOCK_RELEASE | Any bot missing |
| FLEET_HEALTH_DEGRADED | HIGH | ALERT_GUARDIAN | Health < 80% |
| POLICY_COMPLIANCE_LOW | MEDIUM | ALERT_ORACLE | Compliance < 90% |

### Economy State Laws
| Law | Severity | Action | Condition |
|-----|----------|--------|-----------|
| COVERAGE_TOO_LOW | HIGH | BLOCK_RELEASE | Test coverage < 70% |
| DOC_COVERAGE_LOW | MEDIUM | ALERT_ORACLE | Doc coverage < 80% |
| COMPLEXITY_SPIKE | MEDIUM | ALERT_ORACLE | Complexity > 0.75 |

### Learning State Laws
| Law | Severity | Action | Condition |
|-----|----------|--------|-----------|
| NO_LEARNING_PROGRESS | MEDIUM | ALERT_ORACLE | Zero training signals |
| RAPID_PROTOCOL_EVOLUTION | HIGH | ALERT_GUARDIAN | > 5 protocols changed |
| HIGH_ERROR_RATE | MEDIUM | ADJUST_LEARNING_RATE | Error rate > 30% |

### Topology State Laws
| Law | Severity | Action | Condition |
|-----|----------|--------|-----------|
| NO_DEAD_LINKS_ALLOWED | CRITICAL | BLOCK_RELEASE | Any dead links |
| TOO_MANY_ORPHANS | MEDIUM | ALERT_ORACLE | Orphans > 10% |
| CIRCULAR_DEPENDENCIES | HIGH | ALERT_GUARDIAN | Cycles detected |

---

## META ENGINE METRICS

The governance system exposes 24+ metrics across 4 domains for monitoring:

- **Fleet Metrics**: health_ratio, total_count, policy_compliance, missing_count
- **Economy Metrics**: assets_total, coverage, doc_coverage, complexity, sdk_count, protocol_count
- **Learning Metrics**: signals_per_cycle, synapses_trained, protocols_evolved, error_rate, cycle_duration
- **Topology Metrics**: orphans, dead_links, centrality, nodes, edges, density, cycles, depth

---

## IMPLEMENTATION STATUS

| Component | File | Status |
|-----------|------|--------|
| Governance Protocols Macro | `governance/governance-protocols-macro.js` | ✅ COMPLETE |
| Governance Cycle Engine | `governance/governance-cycle.js` | ✅ COMPLETE |
| Event Specifications | `governance/events/*.spec.yaml` | ✅ COMPLETE |
| Test Suite (246 tests) | `tests/*.test.js` | ✅ ALL PASSING |
| Charter Document | `GOVERNANCE_CHARTER.md` | ✅ THIS FILE |

---

## AMENDMENT PROCESS

1. Charter amendments require SOVEREIGN approval
2. Amendments must be proposed through REVIEW lifecycle
3. All amendments are logged immutably to audit trail
4. No amendment may weaken ABSOLUTE enforcement articles
5. Amendments take effect only after governance cycle confirms compliance

---

**SIGNED**: Alfredo Medina Hernandez — Sovereign Architect  
**ESTABLISHED**: 2024  
**VERSION**: 1.0.0  
**STATUS**: ✅ ACTIVE AND ENFORCED
