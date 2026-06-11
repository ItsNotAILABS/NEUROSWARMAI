/**
 * GOVERNANCE PROTOCOLS MACRO
 * Major system governance across Time, Users, Policies, Ethics
 * 
 * This is the sovereign governance engine that defines HOW the organism
 * self-governs across all dimensions of operation.
 * 
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 * 
 * QUAD: GOVERNANCE
 * PROTOCOL: PROTO-MACRO-GOV
 */

// ─── Constants ───────────────────────────────────────────────────────────────
export const PHI = 1.618033988749895;
export const PHI_INV = 0.618033988749895;
export const HEARTBEAT = 873; // ms - φ⁴ heartbeat
export const GOVERNANCE_VERSION = '1.0.0';

// ─── Temporal Governance ─────────────────────────────────────────────────────
// How the system operates across TIME — epochs, cycles, decay, evolution

export const TEMPORAL_EPOCHS = {
  GENESIS: { code: 'GEN', duration: 'initial', description: 'System initialization and first breath' },
  GROWTH: { code: 'GRW', duration: 'ongoing', description: 'Active development and expansion' },
  MATURITY: { code: 'MAT', duration: 'stable', description: 'Production stability and optimization' },
  EVOLUTION: { code: 'EVO', duration: 'triggered', description: 'Major version transitions' },
  LEGACY: { code: 'LGC', duration: 'sunset', description: 'Deprecated systems being gracefully retired' },
};

export const TEMPORAL_POLICIES = {
  HEARTBEAT_SYNC: {
    interval: HEARTBEAT,
    description: 'All governance checks synchronized to φ⁴ heartbeat',
    enforcement: 'MANDATORY',
  },
  EPOCH_TRANSITION: {
    requiresQuorum: 0.8,
    description: 'Epoch transitions require 80% governance quorum',
    enforcement: 'BLOCKING',
  },
  DECAY_RATE: {
    phi_decay: PHI_INV,
    description: 'Unused protocols decay at φ⁻¹ rate per governance cycle',
    enforcement: 'AUTOMATIC',
  },
  EVOLUTION_WINDOW: {
    maxProtocolsPerCycle: 5,
    description: 'Maximum protocols that can evolve in a single cycle',
    enforcement: 'BLOCKING',
  },
};

/**
 * Compute temporal health of the system
 * @param {Object} state - Current system temporal state
 * @returns {Object} Temporal health report
 */
export function computeTemporalHealth(state) {
  if (!state) return { health: 0, epoch: 'UNKNOWN', violations: [] };

  const violations = [];
  let healthScore = 1.0;

  // Check heartbeat synchronization
  if (state.lastHeartbeat) {
    const drift = Math.abs(Date.now() - state.lastHeartbeat - HEARTBEAT);
    if (drift > HEARTBEAT * PHI) {
      violations.push({ type: 'HEARTBEAT_DRIFT', drift, severity: 'HIGH' });
      healthScore *= PHI_INV;
    }
  }

  // Check epoch validity
  if (state.epoch && !TEMPORAL_EPOCHS[state.epoch]) {
    violations.push({ type: 'INVALID_EPOCH', epoch: state.epoch, severity: 'CRITICAL' });
    healthScore *= 0.5;
  }

  // Check protocol evolution rate
  if (state.protocolsEvolvedThisCycle > TEMPORAL_POLICIES.EVOLUTION_WINDOW.maxProtocolsPerCycle) {
    violations.push({
      type: 'EVOLUTION_OVERFLOW',
      count: state.protocolsEvolvedThisCycle,
      max: TEMPORAL_POLICIES.EVOLUTION_WINDOW.maxProtocolsPerCycle,
      severity: 'HIGH',
    });
    healthScore *= PHI_INV;
  }

  return {
    health: Math.max(0, Math.min(1, healthScore)),
    epoch: state.epoch || 'GENESIS',
    violations,
    timestamp: Date.now(),
  };
}

// ─── User Governance ─────────────────────────────────────────────────────────
// How the system manages USERS — roles, permissions, accountability

export const USER_ROLES = {
  SOVEREIGN: { level: 0, description: 'Platform creator — full sovereignty', permissions: ['ALL'] },
  ARCHITECT: { level: 1, description: 'System architects with design authority', permissions: ['DESIGN', 'DEPLOY', 'REVIEW'] },
  OPERATOR: { level: 2, description: 'Day-to-day system operators', permissions: ['OPERATE', 'MONITOR', 'REPORT'] },
  OBSERVER: { level: 3, description: 'Read-only access for auditing', permissions: ['READ', 'AUDIT'] },
  ORGANISM: { level: -1, description: 'AI organisms operating autonomously', permissions: ['EXECUTE', 'LEARN', 'SYNTHESIZE'] },
};

export const USER_POLICIES = {
  PRINCIPLE_OF_LEAST_PRIVILEGE: {
    description: 'Users receive minimum permissions required for their role',
    enforcement: 'MANDATORY',
  },
  ACCOUNTABILITY_CHAIN: {
    description: 'Every action traces back to an accountable entity',
    enforcement: 'MANDATORY',
  },
  CONSENT_REQUIREMENT: {
    description: 'Users must explicitly consent to data usage policies',
    enforcement: 'BLOCKING',
  },
  SESSION_GOVERNANCE: {
    maxSessionDuration: 86400000, // 24 hours
    idleTimeout: 3600000, // 1 hour
    description: 'Sessions are time-bounded and expire on inactivity',
    enforcement: 'AUTOMATIC',
  },
};

/**
 * Evaluate user governance compliance
 * @param {Object} user - User context
 * @param {string} action - Attempted action
 * @returns {Object} Authorization decision
 */
export function evaluateUserGovernance(user, action) {
  if (!user || !action) return { allowed: false, reason: 'MISSING_CONTEXT' };

  const role = USER_ROLES[user.role];
  if (!role) return { allowed: false, reason: 'INVALID_ROLE' };

  // Sovereign bypasses all checks
  if (user.role === 'SOVEREIGN') {
    return { allowed: true, reason: 'SOVEREIGN_AUTHORITY', role: 'SOVEREIGN' };
  }

  // Check permission mapping
  const actionToPermission = {
    deploy: 'DEPLOY',
    design: 'DESIGN',
    review: 'REVIEW',
    operate: 'OPERATE',
    monitor: 'MONITOR',
    report: 'REPORT',
    read: 'READ',
    audit: 'AUDIT',
    execute: 'EXECUTE',
    learn: 'LEARN',
    synthesize: 'SYNTHESIZE',
  };

  const requiredPermission = actionToPermission[action.toLowerCase()];
  if (!requiredPermission) return { allowed: false, reason: 'UNKNOWN_ACTION' };

  const hasPermission = role.permissions.includes('ALL') || role.permissions.includes(requiredPermission);

  return {
    allowed: hasPermission,
    reason: hasPermission ? 'PERMISSION_GRANTED' : 'INSUFFICIENT_PERMISSIONS',
    role: user.role,
    requiredPermission,
  };
}

// ─── Policy Governance ───────────────────────────────────────────────────────
// How POLICIES are defined, enforced, and evolved

export const POLICY_DOMAINS = {
  SECURITY: { code: 'SEC', weight: 1.0, description: 'Security and access control policies' },
  QUALITY: { code: 'QUA', weight: 0.9, description: 'Code quality and testing standards' },
  COMPLIANCE: { code: 'CMP', weight: 0.85, description: 'Regulatory and legal compliance' },
  PERFORMANCE: { code: 'PRF', weight: 0.8, description: 'Performance and resource policies' },
  SOVEREIGNTY: { code: 'SOV', weight: 1.0, description: 'IP protection and native-code mandates' },
};

export const POLICY_LIFECYCLE = {
  PROPOSED: { transitions: ['REVIEW'] },
  REVIEW: { transitions: ['ACTIVE', 'REJECTED'] },
  ACTIVE: { transitions: ['DEPRECATED', 'AMENDED'] },
  AMENDED: { transitions: ['ACTIVE', 'DEPRECATED'] },
  DEPRECATED: { transitions: ['RETIRED'] },
  RETIRED: { transitions: [] },
};

/**
 * Evaluate policy compliance for an action
 * @param {Object} context - Action context
 * @param {Array} policies - Active policies to evaluate
 * @returns {Object} Compliance result
 */
export function evaluatePolicyCompliance(context, policies) {
  if (!context || !policies || !Array.isArray(policies)) {
    return { compliant: false, score: 0, violations: [{ policy: 'SYSTEM', reason: 'INVALID_INPUT' }] };
  }

  const violations = [];
  let totalWeight = 0;
  let passedWeight = 0;

  for (const policy of policies) {
    const weight = policy.weight || 1.0;
    totalWeight += weight;

    if (policy.condition && typeof policy.condition === 'function') {
      try {
        const passed = policy.condition(context);
        if (passed) {
          passedWeight += weight;
        } else {
          violations.push({
            policy: policy.name || 'UNNAMED',
            domain: policy.domain || 'UNKNOWN',
            severity: policy.severity || 'MEDIUM',
            reason: policy.description || 'Policy condition not met',
          });
        }
      } catch (err) {
        violations.push({
          policy: policy.name || 'UNNAMED',
          domain: policy.domain || 'UNKNOWN',
          severity: 'HIGH',
          reason: `Policy evaluation error: ${err.message}`,
        });
      }
    } else {
      passedWeight += weight; // No condition = auto-pass
    }
  }

  const score = totalWeight > 0 ? passedWeight / totalWeight : 0;

  return {
    compliant: violations.length === 0,
    score,
    violations,
    policiesEvaluated: policies.length,
    timestamp: Date.now(),
  };
}

/**
 * Validate policy lifecycle transition
 * @param {string} currentState - Current policy state
 * @param {string} targetState - Desired target state
 * @returns {Object} Transition validity
 */
export function validatePolicyTransition(currentState, targetState) {
  if (!currentState || !targetState) return { valid: false, reason: 'MISSING_STATE' };

  const lifecycle = POLICY_LIFECYCLE[currentState];
  if (!lifecycle) return { valid: false, reason: 'INVALID_CURRENT_STATE' };

  const valid = lifecycle.transitions.includes(targetState);
  return {
    valid,
    reason: valid ? 'TRANSITION_ALLOWED' : 'INVALID_TRANSITION',
    currentState,
    targetState,
    allowedTransitions: lifecycle.transitions,
  };
}

// ─── Ethics Governance ───────────────────────────────────────────────────────
// How the system maintains ETHICAL operation — principles, constraints, reviews

export const ETHICS_PRINCIPLES = {
  SOVEREIGNTY: {
    code: 'ETH-SOV',
    description: 'All code and intelligence remains sovereign — no external dependencies',
    weight: 1.0,
    enforcement: 'ABSOLUTE',
  },
  TRANSPARENCY: {
    code: 'ETH-TRN',
    description: 'All governance decisions are auditable and traceable',
    weight: 0.95,
    enforcement: 'MANDATORY',
  },
  BENEFICENCE: {
    code: 'ETH-BEN',
    description: 'System actions must produce net positive outcomes',
    weight: 0.9,
    enforcement: 'MANDATORY',
  },
  NON_MALEFICENCE: {
    code: 'ETH-NML',
    description: 'System must not cause harm to users or external entities',
    weight: 1.0,
    enforcement: 'ABSOLUTE',
  },
  AUTONOMY: {
    code: 'ETH-AUT',
    description: 'Respect user autonomy and informed consent',
    weight: 0.9,
    enforcement: 'MANDATORY',
  },
  FAIRNESS: {
    code: 'ETH-FAR',
    description: 'Equal treatment regardless of user characteristics',
    weight: 0.85,
    enforcement: 'MANDATORY',
  },
  ACCOUNTABILITY: {
    code: 'ETH-ACC',
    description: 'Every decision has a responsible entity that can be held to account',
    weight: 0.9,
    enforcement: 'MANDATORY',
  },
};

export const ETHICS_CONSTRAINTS = {
  NO_EXTERNAL_DEPENDENCIES: {
    principle: 'SOVEREIGNTY',
    condition: (ctx) => !ctx.externalDependencies || ctx.externalDependencies.length === 0,
    severity: 'CRITICAL',
    description: 'Never borrow from external libraries — all native code',
  },
  AUDIT_TRAIL_REQUIRED: {
    principle: 'TRANSPARENCY',
    condition: (ctx) => ctx.auditTrail !== false,
    severity: 'HIGH',
    description: 'All actions must be logged to audit trail',
  },
  USER_CONSENT_VERIFIED: {
    principle: 'AUTONOMY',
    condition: (ctx) => ctx.userConsent === true,
    severity: 'CRITICAL',
    description: 'User must have given explicit consent',
  },
  HARM_ASSESSMENT_PASSED: {
    principle: 'NON_MALEFICENCE',
    condition: (ctx) => ctx.harmScore === undefined || ctx.harmScore < 0.1,
    severity: 'CRITICAL',
    description: 'Action must pass harm assessment (< 0.1 harm score)',
  },
  FAIRNESS_THRESHOLD: {
    principle: 'FAIRNESS',
    condition: (ctx) => ctx.fairnessScore === undefined || ctx.fairnessScore >= 0.8,
    severity: 'HIGH',
    description: 'Actions must meet fairness threshold (>= 0.8)',
  },
};

/**
 * Evaluate ethics compliance for an action
 * @param {Object} context - Action context with ethics-relevant fields
 * @returns {Object} Ethics evaluation result
 */
export function evaluateEthics(context) {
  if (!context) return { ethical: false, score: 0, violations: [{ constraint: 'SYSTEM', reason: 'NO_CONTEXT' }] };

  const violations = [];
  let totalWeight = 0;
  let passedWeight = 0;

  for (const [name, constraint] of Object.entries(ETHICS_CONSTRAINTS)) {
    const principle = ETHICS_PRINCIPLES[constraint.principle];
    const weight = principle ? principle.weight : 1.0;
    totalWeight += weight;

    try {
      const passed = constraint.condition(context);
      if (passed) {
        passedWeight += weight;
      } else {
        violations.push({
          constraint: name,
          principle: constraint.principle,
          severity: constraint.severity,
          description: constraint.description,
        });
      }
    } catch (err) {
      violations.push({
        constraint: name,
        principle: constraint.principle,
        severity: 'CRITICAL',
        description: `Ethics evaluation error: ${err.message}`,
      });
    }
  }

  const score = totalWeight > 0 ? passedWeight / totalWeight : 0;

  return {
    ethical: violations.length === 0,
    score,
    violations,
    constraintsEvaluated: Object.keys(ETHICS_CONSTRAINTS).length,
    timestamp: Date.now(),
  };
}

// ─── Charter Governance ──────────────────────────────────────────────────────
// The CHARTER — the constitution that binds all governance together

export const CHARTER = {
  name: 'NEUROSWARM GOVERNANCE CHARTER',
  version: GOVERNANCE_VERSION,
  sovereign: 'Alfredo Medina Hernandez',
  established: '2024-01-01',

  articles: {
    ARTICLE_I: {
      title: 'Sovereignty',
      text: 'All intelligence, code, and architecture is sovereign. No external dependencies shall be introduced.',
      enforcement: 'ABSOLUTE',
      violationAction: 'BLOCK_AND_REVERT',
    },
    ARTICLE_II: {
      title: 'Temporal Integrity',
      text: 'The system evolves through governed epochs. Transitions require quorum. Evolution is bounded.',
      enforcement: 'BLOCKING',
      violationAction: 'BLOCK_RELEASE',
    },
    ARTICLE_III: {
      title: 'User Rights',
      text: 'Users maintain data sovereignty, informed consent, and the right to audit all system actions.',
      enforcement: 'MANDATORY',
      violationAction: 'ALERT_GUARDIAN',
    },
    ARTICLE_IV: {
      title: 'Policy Lifecycle',
      text: 'All policies follow a governed lifecycle. No policy may bypass review. Deprecated policies sunset gracefully.',
      enforcement: 'MANDATORY',
      violationAction: 'ALERT_ORACLE',
    },
    ARTICLE_V: {
      title: 'Ethical Operation',
      text: 'The system shall not cause harm. All decisions are accountable. Fairness is measured and enforced.',
      enforcement: 'ABSOLUTE',
      violationAction: 'EMERGENCY_HALT',
    },
    ARTICLE_VI: {
      title: 'Organism Autonomy',
      text: 'AI organisms operate autonomously within charter bounds. They learn, synthesize, and evolve — but never violate the charter.',
      enforcement: 'MANDATORY',
      violationAction: 'QUARANTINE_ORGANISM',
    },
    ARTICLE_VII: {
      title: 'Audit & Transparency',
      text: 'Every governance decision, policy evaluation, and ethics check is logged immutably. The audit trail is sacred.',
      enforcement: 'ABSOLUTE',
      violationAction: 'BLOCK_AND_ALERT',
    },
  },

  amendments: [],
};

/**
 * Evaluate full charter compliance
 * @param {Object} context - System context for charter evaluation
 * @returns {Object} Charter compliance report
 */
export function evaluateCharter(context) {
  if (!context) return { compliant: false, score: 0, violations: [] };

  const violations = [];

  // Article I — Sovereignty
  if (context.externalDependencies && context.externalDependencies.length > 0) {
    violations.push({
      article: 'ARTICLE_I',
      title: 'Sovereignty',
      severity: 'CRITICAL',
      action: CHARTER.articles.ARTICLE_I.violationAction,
    });
  }

  // Article II — Temporal Integrity
  if (context.epochTransition && context.quorum < TEMPORAL_POLICIES.EPOCH_TRANSITION.requiresQuorum) {
    violations.push({
      article: 'ARTICLE_II',
      title: 'Temporal Integrity',
      severity: 'HIGH',
      action: CHARTER.articles.ARTICLE_II.violationAction,
    });
  }

  // Article III — User Rights
  if (context.userAction && !context.userConsent) {
    violations.push({
      article: 'ARTICLE_III',
      title: 'User Rights',
      severity: 'HIGH',
      action: CHARTER.articles.ARTICLE_III.violationAction,
    });
  }

  // Article V — Ethical Operation
  if (context.harmScore !== undefined && context.harmScore >= 0.1) {
    violations.push({
      article: 'ARTICLE_V',
      title: 'Ethical Operation',
      severity: 'CRITICAL',
      action: CHARTER.articles.ARTICLE_V.violationAction,
    });
  }

  // Article VII — Audit & Transparency
  if (context.auditTrail === false) {
    violations.push({
      article: 'ARTICLE_VII',
      title: 'Audit & Transparency',
      severity: 'CRITICAL',
      action: CHARTER.articles.ARTICLE_VII.violationAction,
    });
  }

  const articleCount = Object.keys(CHARTER.articles).length;
  const score = (articleCount - violations.length) / articleCount;

  return {
    compliant: violations.length === 0,
    score,
    violations,
    articlesEvaluated: articleCount,
    charterVersion: CHARTER.version,
    timestamp: Date.now(),
  };
}

// ─── Macro Governance Engine ─────────────────────────────────────────────────
// Unified governance evaluation across all dimensions

/**
 * Run the full governance macro evaluation
 * @param {Object} context - Complete system context
 * @returns {Object} Comprehensive governance report
 */
export function runGovernanceMacro(context) {
  if (!context) {
    return {
      pass: false,
      overallScore: 0,
      temporal: { health: 0 },
      user: { allowed: false },
      policy: { compliant: false },
      ethics: { ethical: false },
      charter: { compliant: false },
      timestamp: Date.now(),
    };
  }

  const temporal = computeTemporalHealth(context.temporal || {});
  const user = context.user ? evaluateUserGovernance(context.user, context.action || 'read') : { allowed: true, reason: 'NO_USER_CONTEXT' };
  const policy = evaluatePolicyCompliance(context.policy || {}, context.policies || []);
  const ethics = evaluateEthics(context.ethics || {});
  const charter = evaluateCharter(context.charter || {});

  // Compute overall governance score (φ-weighted)
  const scores = [
    { value: temporal.health, weight: PHI },
    { value: user.allowed ? 1.0 : 0.0, weight: 1.0 },
    { value: policy.score, weight: PHI_INV },
    { value: ethics.score, weight: PHI },
    { value: charter.score, weight: PHI * PHI },
  ];

  const totalWeight = scores.reduce((sum, s) => sum + s.weight, 0);
  const weightedScore = scores.reduce((sum, s) => sum + s.value * s.weight, 0) / totalWeight;

  // System passes only if no CRITICAL violations exist
  const hasCritical = [
    ...temporal.violations.filter(v => v.severity === 'CRITICAL'),
    ...ethics.violations.filter(v => v.severity === 'CRITICAL'),
    ...charter.violations.filter(v => v.severity === 'CRITICAL'),
    ...(policy.violations || []).filter(v => v.severity === 'CRITICAL'),
  ].length > 0;

  return {
    pass: !hasCritical && weightedScore >= PHI_INV,
    overallScore: weightedScore,
    temporal,
    user,
    policy,
    ethics,
    charter,
    hasCritical,
    timestamp: Date.now(),
  };
}

// ─── Default Export ──────────────────────────────────────────────────────────
export default {
  GOVERNANCE_VERSION,
  PHI,
  PHI_INV,
  HEARTBEAT,
  TEMPORAL_EPOCHS,
  TEMPORAL_POLICIES,
  USER_ROLES,
  USER_POLICIES,
  POLICY_DOMAINS,
  POLICY_LIFECYCLE,
  ETHICS_PRINCIPLES,
  ETHICS_CONSTRAINTS,
  CHARTER,
  computeTemporalHealth,
  evaluateUserGovernance,
  evaluatePolicyCompliance,
  validatePolicyTransition,
  evaluateEthics,
  evaluateCharter,
  runGovernanceMacro,
};
