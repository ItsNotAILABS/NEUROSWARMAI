/**
 * ╔══════════════════════════════════════════════════════════════════════════════╗
 * ║                  VERITAS DOCTRINE VAULT — 真理-SUBSTRATE v1.0                ║
 * ║              Truth Verification, Doctrine Governance & Law Registry          ║
 * ╠══════════════════════════════════════════════════════════════════════════════╣
 * ║  The VERITAS engine is the source of truth for all doctrines, laws, and      ║
 * ║  behavioral constraints within the organism. It maintains immutable records, ║
 * ║  verifies compliance, and governs doctrinal evolution through consensus.     ║
 * ╚══════════════════════════════════════════════════════════════════════════════╝
 */

// ============================================================================
// SECTION 1: FUNDAMENTAL TRUTH CONSTANTS
// ============================================================================

/** Maximum doctrine revision depth */
export const MAX_DOCTRINE_DEPTH = 999;

/** Consensus threshold for doctrine changes */
export const CONSENSUS_THRESHOLD = 0.667; // 2/3 majority

/** Verification proof expiration (seconds) */
export const PROOF_EXPIRATION = 86400 * 365; // 1 year

/** Hash algorithm for content addressing */
export const HASH_ALGORITHM = "SHA-256";

/** Maximum law complexity score */
export const MAX_COMPLEXITY = 1000;

/** Minimum attestation count for truth */
export const MIN_ATTESTATIONS = 3;

/** Truth decay half-life (seconds) */
export const TRUTH_DECAY_HALFLIFE = 86400 * 30; // 30 days

// ============================================================================
// SECTION 2: TYPE DEFINITIONS
// ============================================================================

/**
 * Truth value representation - more nuanced than boolean
 */
export interface TruthValue {
  readonly value: number; // [0, 1] degree of truth
  readonly confidence: number; // [0, 1] confidence in this truth value
  readonly sources: string[]; // IDs of attesting sources
  readonly lastVerified: number; // Timestamp of last verification
  readonly decayRate: number; // How quickly truth decays without reinforcement
}

/**
 * Doctrine category
 */
export type DoctrineCategory =
  | "fundamental" // Core immutable truths
  | "constitutional" // Foundational governance rules
  | "operational" // Day-to-day operational guidelines
  | "advisory" // Recommendations, not mandates
  | "experimental" // Temporary doctrines under evaluation
  | "deprecated"; // Doctrines being phased out

/**
 * Law severity level
 */
export type LawSeverity =
  | "critical" // Violation causes immediate halt
  | "major" // Violation triggers intervention
  | "moderate" // Violation logged and flagged
  | "minor" // Violation noted but tolerated
  | "advisory"; // Suggestion, no enforcement

/**
 * Individual doctrine definition
 */
export interface Doctrine {
  readonly id: string;
  readonly version: number;
  readonly category: DoctrineCategory;
  readonly title: string;
  readonly description: string;
  readonly rationale: string;
  readonly effectiveDate: number;
  readonly expirationDate?: number;
  readonly precedence: number; // Higher = more authoritative
  readonly dependencies: string[]; // IDs of required doctrines
  readonly conflicts: string[]; // IDs of conflicting doctrines
  readonly author: string;
  readonly attestations: Attestation[];
  readonly amendments: Amendment[];
  readonly contentHash: string; // Content-addressed hash
  readonly supersedes?: string; // ID of doctrine this replaces
  readonly isActive: boolean;
  readonly metadata: DoctrineMetadata;
}

/**
 * Doctrine metadata
 */
export interface DoctrineMetadata {
  readonly createdAt: number;
  readonly updatedAt: number;
  readonly viewCount: number;
  readonly citationCount: number;
  readonly complianceRate: number;
  readonly disputeCount: number;
  readonly tags: string[];
  readonly jurisdiction: string[];
  readonly language: string;
}

/**
 * Law definition (enforceable rule)
 */
export interface Law {
  readonly id: string;
  readonly lawNumber: string; // e.g., "L42" for Law 42
  readonly title: string;
  readonly description: string;
  readonly severity: LawSeverity;
  readonly category: string;
  readonly condition: LawCondition;
  readonly action: LawAction;
  readonly exceptions: LawException[];
  readonly penalties: Penalty[];
  readonly isEnabled: boolean;
  readonly doctrineRef: string; // Reference to governing doctrine
  readonly complexity: number; // Computational complexity score
  readonly checkFrequency: number; // How often to verify (seconds)
  readonly lastChecked: number;
  readonly violationCount: number;
  readonly createdAt: number;
  readonly updatedAt: number;
}

/**
 * Law condition - what triggers the law
 */
export interface LawCondition {
  readonly type:
    | "threshold"
    | "pattern"
    | "temporal"
    | "composite"
    | "contextual";
  readonly expression: string; // Condition expression
  readonly parameters: Record<string, number | string | boolean>;
  readonly evaluator: string; // ID of evaluator function
}

/**
 * Law action - what happens when law is violated
 */
export interface LawAction {
  readonly type: "alert" | "correct" | "halt" | "escalate" | "log" | "custom";
  readonly handler: string; // ID of handler function
  readonly parameters: Record<string, unknown>;
  readonly timeout: number; // Max time for action (ms)
  readonly retries: number; // Number of retry attempts
}

/**
 * Law exception - when law doesn't apply
 */
export interface LawException {
  readonly id: string;
  readonly condition: string; // Exception condition
  readonly reason: string;
  readonly approvedBy: string[];
  readonly validUntil?: number;
}

/**
 * Penalty for law violation
 */
export interface Penalty {
  readonly level: number; // 1-5 severity
  readonly description: string;
  readonly consequence: string;
  readonly duration?: number; // How long penalty lasts
  readonly escalation?: string; // Next penalty if repeated
}

/**
 * Attestation - verification of truth
 */
export interface Attestation {
  readonly attester: string; // ID of attesting entity
  readonly timestamp: number;
  readonly signature: string; // Cryptographic signature
  readonly confidence: number; // [0, 1] attester's confidence
  readonly evidence?: string[]; // Optional evidence references
  readonly expiresAt?: number;
}

/**
 * Amendment to a doctrine
 */
export interface Amendment {
  readonly id: string;
  readonly doctrineId: string;
  readonly proposedBy: string;
  readonly proposedAt: number;
  readonly ratifiedAt?: number;
  readonly changes: DoctrineChange[];
  readonly votes: Vote[];
  readonly status:
    | "proposed"
    | "voting"
    | "ratified"
    | "rejected"
    | "withdrawn";
  readonly rationale: string;
}

/**
 * Change within an amendment
 */
export interface DoctrineChange {
  readonly field: string;
  readonly oldValue: unknown;
  readonly newValue: unknown;
  readonly reason: string;
}

/**
 * Vote on an amendment
 */
export interface Vote {
  readonly voter: string;
  readonly vote: "approve" | "reject" | "abstain";
  readonly timestamp: number;
  readonly weight: number; // Weighted voting
  readonly comment?: string;
}

/**
 * Verification proof
 */
export interface VerificationProof {
  readonly id: string;
  readonly claimType: "doctrine" | "law" | "attestation" | "truth";
  readonly claimId: string;
  readonly verifier: string;
  readonly timestamp: number;
  readonly method: string;
  readonly evidence: string[];
  readonly result: boolean;
  readonly confidence: number;
  readonly signature: string;
  readonly expiresAt: number;
}

/**
 * Dispute record
 */
export interface Dispute {
  readonly id: string;
  readonly targetType: "doctrine" | "law" | "attestation" | "decision";
  readonly targetId: string;
  readonly complainant: string;
  readonly respondent: string;
  readonly filedAt: number;
  readonly description: string;
  readonly evidence: string[];
  readonly status: "open" | "under_review" | "resolved" | "dismissed";
  readonly resolution?: DisputeResolution;
  readonly arbitrators: string[];
}

/**
 * Dispute resolution
 */
export interface DisputeResolution {
  readonly decision: string;
  readonly rationale: string;
  readonly decidedBy: string[];
  readonly decidedAt: number;
  readonly remediation?: string;
  readonly appeals: number;
}

/**
 * Complete VERITAS state
 */
export interface VeritasState {
  readonly timestamp: number;
  readonly doctrines: Map<string, Doctrine>;
  readonly laws: Map<string, Law>;
  readonly truthRegistry: Map<string, TruthValue>;
  readonly proofs: Map<string, VerificationProof>;
  readonly disputes: Map<string, Dispute>;
  readonly amendments: Map<string, Amendment>;
  readonly auditLog: AuditEntry[];
  readonly metrics: VeritasMetrics;
  readonly governanceConfig: GovernanceConfig;
}

/**
 * Audit log entry
 */
export interface AuditEntry {
  readonly id: string;
  readonly timestamp: number;
  readonly action: string;
  readonly actor: string;
  readonly target: string;
  readonly details: Record<string, unknown>;
  readonly hash: string;
  readonly previousHash: string;
}

/**
 * VERITAS metrics
 */
export interface VeritasMetrics {
  readonly totalDoctrines: number;
  readonly activeDoctrines: number;
  readonly totalLaws: number;
  readonly enabledLaws: number;
  readonly totalViolations: number;
  readonly openDisputes: number;
  readonly averageCompliance: number;
  readonly truthCoverage: number;
  readonly attestationHealth: number;
  readonly lastAuditTime: number;
}

/**
 * Governance configuration
 */
export interface GovernanceConfig {
  readonly consensusThreshold: number;
  readonly votingPeriod: number; // seconds
  readonly quorumRequirement: number;
  readonly amendmentCooldown: number;
  readonly maxAmendmentsPerPeriod: number;
  readonly emergencyOverrideEnabled: boolean;
  readonly emergencyVoters: string[];
  readonly auditRetentionPeriod: number;
}

// ============================================================================
// SECTION 3: HASH AND CRYPTOGRAPHIC UTILITIES
// ============================================================================

/**
 * Simple hash function (in production, use proper crypto)
 */
export function simpleHash(input: string): string {
  let hash = 0;
  for (let i = 0; i < input.length; i++) {
    const char = input.charCodeAt(i);
    hash = (hash << 5) - hash + char;
    hash = hash & hash;
  }
  return Math.abs(hash).toString(16).padStart(8, "0");
}

/**
 * Evaluate a LawException condition string against a context object.
 * Supports conditions of the form: "key == value", "key != value",
 * "key > value", "key >= value", "key < value", "key <= value".
 */
function evaluateExceptionCondition(
  condition: string,
  context: Record<string, unknown>,
): boolean {
  const ops = [">=", "<=", "!=", "==", ">", "<"];
  for (const op of ops) {
    const idx = condition.indexOf(op);
    if (idx === -1) continue;

    const key = condition.slice(0, idx).trim();
    const rawVal = condition.slice(idx + op.length).trim();
    const ctxVal = context[key];

    // Parse the expected value as boolean, number, or string
    let expected: unknown;
    if (rawVal === "true") expected = true;
    else if (rawVal === "false") expected = false;
    else if (!Number.isNaN(Number(rawVal))) expected = Number(rawVal);
    else expected = rawVal;

    const numCtx = Number(ctxVal);
    const numExp = Number(expected);
    const bothNumeric = !Number.isNaN(numCtx) && !Number.isNaN(numExp);

    switch (op) {
      case "==":
        // biome-ignore lint/suspicious/noDoubleEquals: intentional coercion — condition strings may compare boolean/number/string to context values
        return ctxVal == expected;
      case "!=":
        // biome-ignore lint/suspicious/noDoubleEquals: intentional coercion — same as above
        return ctxVal != expected;
      case ">":
        return bothNumeric ? numCtx > numExp : false;
      case ">=":
        return bothNumeric ? numCtx >= numExp : false;
      case "<":
        return bothNumeric ? numCtx < numExp : false;
      case "<=":
        return bothNumeric ? numCtx <= numExp : false;
    }
  }
  // Unknown format — condition cannot be evaluated, treat as not met
  return false;
}

/**
 * Generate content hash for a doctrine
 */
export function hashDoctrine(doctrine: Omit<Doctrine, "contentHash">): string {
  const content = JSON.stringify({
    id: doctrine.id,
    version: doctrine.version,
    title: doctrine.title,
    description: doctrine.description,
    rationale: doctrine.rationale,
  });
  return simpleHash(content);
}

/**
 * Generate Merkle root from list of hashes
 */
export function merkleRoot(hashes: string[]): string {
  if (hashes.length === 0) return simpleHash("");
  if (hashes.length === 1) return hashes[0];

  const nextLevel: string[] = [];
  for (let i = 0; i < hashes.length; i += 2) {
    const left = hashes[i];
    const right = hashes[i + 1] || left;
    nextLevel.push(simpleHash(left + right));
  }

  return merkleRoot(nextLevel);
}

/**
 * Verify Merkle proof
 */
export function verifyMerkleProof(
  leaf: string,
  proof: string[],
  root: string,
  index: number,
): boolean {
  let computed = leaf;
  let idx = index;

  for (const sibling of proof) {
    if (idx % 2 === 0) {
      computed = simpleHash(computed + sibling);
    } else {
      computed = simpleHash(sibling + computed);
    }
    idx = Math.floor(idx / 2);
  }

  return computed === root;
}

// ============================================================================
// SECTION 4: TRUTH VALUE CALCULUS
// ============================================================================

/**
 * Truth algebra operations
 */
// biome-ignore lint/complexity/noStaticOnlyClass: designed as static utility class
export class TruthAlgebra {
  /**
   * Compute conjunction (AND) of truth values
   */
  static and(a: TruthValue, b: TruthValue): TruthValue {
    return {
      value: Math.min(a.value, b.value),
      confidence: Math.min(a.confidence, b.confidence),
      sources: [...new Set([...a.sources, ...b.sources])],
      lastVerified: Math.max(a.lastVerified, b.lastVerified),
      decayRate: Math.max(a.decayRate, b.decayRate),
    };
  }

  /**
   * Compute disjunction (OR) of truth values
   */
  static or(a: TruthValue, b: TruthValue): TruthValue {
    return {
      value: Math.max(a.value, b.value),
      confidence: Math.max(a.confidence, b.confidence),
      sources: [...new Set([...a.sources, ...b.sources])],
      lastVerified: Math.max(a.lastVerified, b.lastVerified),
      decayRate: Math.min(a.decayRate, b.decayRate),
    };
  }

  /**
   * Compute negation (NOT) of truth value
   */
  static not(a: TruthValue): TruthValue {
    return {
      value: 1 - a.value,
      confidence: a.confidence,
      sources: a.sources,
      lastVerified: a.lastVerified,
      decayRate: a.decayRate,
    };
  }

  /**
   * Compute implication (IF-THEN) of truth values
   * A → B = ¬A ∨ B
   */
  static implies(a: TruthValue, b: TruthValue): TruthValue {
    return TruthAlgebra.or(TruthAlgebra.not(a), b);
  }

  /**
   * Compute biconditional (IFF) of truth values
   * A ↔ B = (A → B) ∧ (B → A)
   */
  static iff(a: TruthValue, b: TruthValue): TruthValue {
    return TruthAlgebra.and(
      TruthAlgebra.implies(a, b),
      TruthAlgebra.implies(b, a),
    );
  }

  /**
   * Weighted average of truth values
   */
  static weightedAverage(truths: TruthValue[], weights: number[]): TruthValue {
    if (truths.length === 0 || truths.length !== weights.length) {
      return {
        value: 0,
        confidence: 0,
        sources: [],
        lastVerified: Date.now(),
        decayRate: 0.1,
      };
    }

    let totalWeight = 0;
    let weightedValue = 0;
    let weightedConfidence = 0;
    const allSources: string[] = [];
    let latestVerified = 0;
    let minDecayRate = Number.POSITIVE_INFINITY;

    for (let i = 0; i < truths.length; i++) {
      totalWeight += weights[i];
      weightedValue += truths[i].value * weights[i];
      weightedConfidence += truths[i].confidence * weights[i];
      allSources.push(...truths[i].sources);
      latestVerified = Math.max(latestVerified, truths[i].lastVerified);
      minDecayRate = Math.min(minDecayRate, truths[i].decayRate);
    }

    return {
      value: totalWeight > 0 ? weightedValue / totalWeight : 0,
      confidence: totalWeight > 0 ? weightedConfidence / totalWeight : 0,
      sources: [...new Set(allSources)],
      lastVerified: latestVerified,
      decayRate: minDecayRate === Number.POSITIVE_INFINITY ? 0.1 : minDecayRate,
    };
  }

  /**
   * Apply time decay to truth value
   */
  static applyDecay(truth: TruthValue, currentTime: number): TruthValue {
    const elapsed = (currentTime - truth.lastVerified) / 1000; // seconds
    const decayFactor = Math.exp(
      (-truth.decayRate * elapsed) / TRUTH_DECAY_HALFLIFE,
    );

    return {
      ...truth,
      confidence: truth.confidence * decayFactor,
    };
  }

  /**
   * Check if truth value is considered "true"
   */
  static isTrue(truth: TruthValue, threshold = 0.5): boolean {
    return truth.value >= threshold && truth.confidence >= 0.5;
  }

  /**
   * Check if truth value is considered "false"
   */
  static isFalse(truth: TruthValue, threshold = 0.5): boolean {
    return truth.value < threshold && truth.confidence >= 0.5;
  }

  /**
   * Check if truth value is uncertain
   */
  static isUncertain(truth: TruthValue): boolean {
    return truth.confidence < 0.5;
  }
}

// ============================================================================
// SECTION 5: DOCTRINE MANAGER
// ============================================================================

/**
 * Manages doctrine lifecycle
 */
export class DoctrineManager {
  private doctrines: Map<string, Doctrine> = new Map();
  private amendments: Map<string, Amendment> = new Map();
  private auditLog: AuditEntry[] = [];
  private lastAuditHash = "";

  /**
   * Register a new doctrine
   */
  registerDoctrine(
    doctrine: Omit<Doctrine, "contentHash" | "metadata">,
  ): Doctrine {
    const contentHash = hashDoctrine(doctrine as any);
    const now = Date.now();

    const fullDoctrine: Doctrine = {
      ...doctrine,
      contentHash,
      metadata: {
        createdAt: now,
        updatedAt: now,
        viewCount: 0,
        citationCount: 0,
        complianceRate: 1,
        disputeCount: 0,
        tags: [],
        jurisdiction: ["global"],
        language: "en",
      },
    };

    this.doctrines.set(doctrine.id, fullDoctrine);
    this.logAudit("DOCTRINE_REGISTERED", "system", doctrine.id, {
      title: doctrine.title,
    });

    return fullDoctrine;
  }

  /**
   * Get doctrine by ID
   */
  getDoctrine(id: string): Doctrine | undefined {
    const doctrine = this.doctrines.get(id);
    if (doctrine) {
      // Increment view count
      this.doctrines.set(id, {
        ...doctrine,
        metadata: {
          ...doctrine.metadata,
          viewCount: doctrine.metadata.viewCount + 1,
        },
      });
    }
    return doctrine;
  }

  /**
   * Get doctrines by category
   */
  getDoctrinesByCategory(category: DoctrineCategory): Doctrine[] {
    return Array.from(this.doctrines.values()).filter(
      (d) => d.category === category && d.isActive,
    );
  }

  /**
   * Propose an amendment
   */
  proposeAmendment(
    doctrineId: string,
    proposedBy: string,
    changes: DoctrineChange[],
    rationale: string,
  ): Amendment | null {
    const doctrine = this.doctrines.get(doctrineId);
    if (!doctrine) return null;

    const amendment: Amendment = {
      id: `amend_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`,
      doctrineId,
      proposedBy,
      proposedAt: Date.now(),
      changes,
      votes: [],
      status: "proposed",
      rationale,
    };

    this.amendments.set(amendment.id, amendment);
    this.logAudit("AMENDMENT_PROPOSED", proposedBy, doctrineId, {
      amendmentId: amendment.id,
    });

    return amendment;
  }

  /**
   * Cast a vote on an amendment
   */
  castVote(
    amendmentId: string,
    voter: string,
    vote: Vote["vote"],
    weight = 1,
    comment?: string,
  ): boolean {
    const amendment = this.amendments.get(amendmentId);
    if (
      !amendment ||
      (amendment.status !== "proposed" && amendment.status !== "voting")
    ) {
      return false;
    }

    // Check if already voted
    if (amendment.votes.some((v) => v.voter === voter)) {
      return false;
    }

    const newVote: Vote = {
      voter,
      vote,
      timestamp: Date.now(),
      weight,
      comment,
    };

    const updatedAmendment: Amendment = {
      ...amendment,
      status: "voting",
      votes: [...amendment.votes, newVote],
    };

    this.amendments.set(amendmentId, updatedAmendment);
    this.logAudit("VOTE_CAST", voter, amendmentId, { vote, weight });

    // Check if we can finalize
    this.checkAmendmentFinalization(amendmentId);

    return true;
  }

  /**
   * Check if amendment can be finalized
   */
  private checkAmendmentFinalization(amendmentId: string): void {
    const amendment = this.amendments.get(amendmentId);
    if (!amendment || amendment.status !== "voting") return;

    const totalWeight = amendment.votes.reduce((sum, v) => sum + v.weight, 0);
    const approveWeight = amendment.votes
      .filter((v) => v.vote === "approve")
      .reduce((sum, v) => sum + v.weight, 0);

    if (totalWeight === 0) return;

    const approvalRatio = approveWeight / totalWeight;

    if (approvalRatio >= CONSENSUS_THRESHOLD) {
      // Ratify amendment
      this.ratifyAmendment(amendmentId);
    } else if (
      (totalWeight - approveWeight) / totalWeight >
      1 - CONSENSUS_THRESHOLD
    ) {
      // Rejected
      this.amendments.set(amendmentId, {
        ...amendment,
        status: "rejected",
      });
      this.logAudit("AMENDMENT_REJECTED", "system", amendmentId, {
        approvalRatio,
      });
    }
  }

  /**
   * Ratify an amendment
   */
  private ratifyAmendment(amendmentId: string): void {
    const amendment = this.amendments.get(amendmentId);
    if (!amendment) return;

    const doctrine = this.doctrines.get(amendment.doctrineId);
    if (!doctrine) return;

    // Apply changes
    let updatedDoctrine = { ...doctrine };
    for (const change of amendment.changes) {
      (updatedDoctrine as any)[change.field] = change.newValue;
    }

    // Update version and metadata
    updatedDoctrine = {
      ...updatedDoctrine,
      version: doctrine.version + 1,
      amendments: [
        ...doctrine.amendments,
        { ...amendment, status: "ratified", ratifiedAt: Date.now() },
      ],
      contentHash: hashDoctrine(updatedDoctrine as any),
      metadata: {
        ...doctrine.metadata,
        updatedAt: Date.now(),
      },
    };

    this.doctrines.set(amendment.doctrineId, updatedDoctrine);

    // Update amendment status
    this.amendments.set(amendmentId, {
      ...amendment,
      status: "ratified",
      ratifiedAt: Date.now(),
    });

    this.logAudit("AMENDMENT_RATIFIED", "system", amendmentId, {
      newVersion: updatedDoctrine.version,
    });
  }

  /**
   * Check doctrine dependencies
   */
  checkDependencies(doctrineId: string): {
    satisfied: boolean;
    missing: string[];
  } {
    const doctrine = this.doctrines.get(doctrineId);
    if (!doctrine) return { satisfied: false, missing: [doctrineId] };

    const missing: string[] = [];
    for (const depId of doctrine.dependencies) {
      const dep = this.doctrines.get(depId);
      if (!dep || !dep.isActive) {
        missing.push(depId);
      }
    }

    return { satisfied: missing.length === 0, missing };
  }

  /**
   * Check for doctrine conflicts
   */
  checkConflicts(doctrineId: string): string[] {
    const doctrine = this.doctrines.get(doctrineId);
    if (!doctrine) return [];

    const activeConflicts: string[] = [];
    for (const conflictId of doctrine.conflicts) {
      const conflict = this.doctrines.get(conflictId);
      if (conflict?.isActive) {
        activeConflicts.push(conflictId);
      }
    }

    return activeConflicts;
  }

  /**
   * Resolve doctrine by precedence
   */
  resolveByPrecedence(doctrineIds: string[]): Doctrine | null {
    const doctrines = doctrineIds
      .map((id) => this.doctrines.get(id))
      .filter((d): d is Doctrine => d !== undefined && d.isActive === true);

    if (doctrines.length === 0) return null;

    // Sort by precedence (higher = more authoritative)
    doctrines.sort((a, b) => b.precedence - a.precedence);

    return doctrines[0];
  }

  /**
   * Log an audit entry
   */
  private logAudit(
    action: string,
    actor: string,
    target: string,
    details: Record<string, unknown>,
  ): void {
    let entry: AuditEntry = {
      id: `audit_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`,
      timestamp: Date.now(),
      action,
      actor,
      target,
      details,
      hash: "",
      previousHash: this.lastAuditHash,
    };

    entry = {
      ...entry,
      hash: simpleHash(JSON.stringify(entry)),
    };

    this.auditLog.push(entry);
    this.lastAuditHash = entry.hash;
  }

  /**
   * Get audit log
   */
  getAuditLog(since?: number): AuditEntry[] {
    if (since) {
      return this.auditLog.filter((e) => e.timestamp >= since);
    }
    return [...this.auditLog];
  }

  /**
   * Get all doctrines
   */
  getAllDoctrines(): Doctrine[] {
    return Array.from(this.doctrines.values());
  }
}

// ============================================================================
// SECTION 6: LAW REGISTRY
// ============================================================================

/**
 * Registry and enforcement of laws
 */
export class LawRegistry {
  private laws: Map<string, Law> = new Map();
  private violationHistory: Map<
    string,
    Array<{ timestamp: number; context: unknown }>
  > = new Map();

  /**
   * Register a new law
   */
  registerLaw(
    law: Omit<
      Law,
      "lastChecked" | "violationCount" | "createdAt" | "updatedAt"
    >,
  ): Law {
    const now = Date.now();
    const fullLaw: Law = {
      ...law,
      lastChecked: now,
      violationCount: 0,
      createdAt: now,
      updatedAt: now,
    };

    this.laws.set(law.id, fullLaw);
    return fullLaw;
  }

  /**
   * Get law by ID
   */
  getLaw(id: string): Law | undefined {
    return this.laws.get(id);
  }

  /**
   * Get law by law number
   */
  getLawByNumber(lawNumber: string): Law | undefined {
    for (const law of this.laws.values()) {
      if (law.lawNumber === lawNumber) {
        return law;
      }
    }
    return undefined;
  }

  /**
   * Get all laws by category
   */
  getLawsByCategory(category: string): Law[] {
    return Array.from(this.laws.values()).filter(
      (l) => l.category === category && l.isEnabled,
    );
  }

  /**
   * Get all laws by severity
   */
  getLawsBySeverity(severity: LawSeverity): Law[] {
    return Array.from(this.laws.values()).filter(
      (l) => l.severity === severity && l.isEnabled,
    );
  }

  /**
   * Check if a law condition is met
   */
  evaluateCondition(law: Law, context: Record<string, unknown>): boolean {
    // This would be replaced with actual condition evaluation
    // For now, simplified pattern matching
    try {
      const condition = law.condition;

      switch (condition.type) {
        case "threshold": {
          const paramName = condition.parameters.variable as string;
          const threshold = condition.parameters.threshold as number;
          const operator = (condition.parameters.operator as string) || ">=";
          const value = context[paramName] as number;

          switch (operator) {
            case ">=":
              return value >= threshold;
            case "<=":
              return value <= threshold;
            case ">":
              return value > threshold;
            case "<":
              return value < threshold;
            case "==":
              return value === threshold;
            default:
              return false;
          }
        }

        case "pattern": {
          const pattern = condition.parameters.pattern as string;
          const target = condition.parameters.target as string;
          const value = String(context[target] || "");
          return new RegExp(pattern).test(value);
        }

        case "temporal": {
          const start = condition.parameters.startHour as number;
          const end = condition.parameters.endHour as number;
          const currentHour = new Date().getHours();
          return currentHour >= start && currentHour < end;
        }

        case "composite": {
          const subConditions = condition.parameters
            .conditions as unknown as LawCondition[];
          const operator = condition.parameters.operator as "AND" | "OR";

          if (operator === "AND") {
            return subConditions.every((sub) =>
              this.evaluateCondition({ ...law, condition: sub }, context),
            );
          }
          return subConditions.some((sub) =>
            this.evaluateCondition({ ...law, condition: sub }, context),
          );
        }

        default:
          return false;
      }
    } catch {
      return false;
    }
  }

  /**
   * Check for exceptions
   */
  checkExceptions(
    law: Law,
    context: Record<string, unknown>,
  ): LawException | null {
    for (const exception of law.exceptions) {
      // Check if exception is still valid
      if (exception.validUntil && exception.validUntil < Date.now()) {
        continue;
      }

      // Evaluate exception condition against context values.
      // Condition strings use the form "key op value" (e.g. "isEmergency == true").
      try {
        const conditionMet = evaluateExceptionCondition(
          exception.condition,
          context,
        );
        if (conditionMet) {
          return exception;
        }
      } catch {
        // Malformed condition — skip this exception
      }
    }

    return null;
  }

  /**
   * Record a violation
   */
  recordViolation(lawId: string, context: unknown): void {
    const law = this.laws.get(lawId);
    if (!law) return;

    // Update violation count
    this.laws.set(lawId, {
      ...law,
      violationCount: law.violationCount + 1,
      updatedAt: Date.now(),
    });

    // Add to history
    if (!this.violationHistory.has(lawId)) {
      this.violationHistory.set(lawId, []);
    }
    this.violationHistory.get(lawId)!.push({
      timestamp: Date.now(),
      context,
    });
  }

  /**
   * Get violation history for a law
   */
  getViolationHistory(
    lawId: string,
  ): Array<{ timestamp: number; context: unknown }> {
    return this.violationHistory.get(lawId) || [];
  }

  /**
   * Enable or disable a law
   */
  setLawEnabled(lawId: string, enabled: boolean): boolean {
    const law = this.laws.get(lawId);
    if (!law) return false;

    this.laws.set(lawId, {
      ...law,
      isEnabled: enabled,
      updatedAt: Date.now(),
    });

    return true;
  }

  /**
   * Get all laws
   */
  getAllLaws(): Law[] {
    return Array.from(this.laws.values());
  }

  /**
   * Get law statistics
   */
  getStatistics(): {
    total: number;
    enabled: number;
    bySeverity: Record<LawSeverity, number>;
    byCategory: Record<string, number>;
    totalViolations: number;
  } {
    const laws = Array.from(this.laws.values());

    const bySeverity: Record<LawSeverity, number> = {
      critical: 0,
      major: 0,
      moderate: 0,
      minor: 0,
      advisory: 0,
    };

    const byCategory: Record<string, number> = {};
    let totalViolations = 0;

    for (const law of laws) {
      bySeverity[law.severity]++;
      byCategory[law.category] = (byCategory[law.category] || 0) + 1;
      totalViolations += law.violationCount;
    }

    return {
      total: laws.length,
      enabled: laws.filter((l) => l.isEnabled).length,
      bySeverity,
      byCategory,
      totalViolations,
    };
  }
}

// ============================================================================
// SECTION 7: TRUTH REGISTRY
// ============================================================================

/**
 * Registry for truth values and their verification
 */
export class TruthRegistry {
  private truths: Map<string, TruthValue> = new Map();
  private attestations: Map<string, Attestation[]> = new Map();

  /**
   * Register a truth claim
   */
  registerTruth(
    id: string,
    value: number,
    source: string,
    confidence: number,
  ): TruthValue {
    const existing = this.truths.get(id);

    if (existing) {
      // Update existing truth with new attestation
      const newTruth: TruthValue = {
        value:
          (existing.value * existing.sources.length + value) /
          (existing.sources.length + 1),
        confidence: Math.max(existing.confidence, confidence),
        sources: [...existing.sources, source],
        lastVerified: Date.now(),
        decayRate: existing.decayRate,
      };
      this.truths.set(id, newTruth);
      return newTruth;
    }
    // New truth
    const newTruth: TruthValue = {
      value,
      confidence,
      sources: [source],
      lastVerified: Date.now(),
      decayRate: 0.001,
    };
    this.truths.set(id, newTruth);
    return newTruth;
  }

  /**
   * Get truth value
   */
  getTruth(id: string): TruthValue | undefined {
    const truth = this.truths.get(id);
    if (truth) {
      // Apply decay
      return TruthAlgebra.applyDecay(truth, Date.now());
    }
    return undefined;
  }

  /**
   * Add attestation to a truth
   */
  addAttestation(truthId: string, attestation: Attestation): boolean {
    if (!this.truths.has(truthId)) return false;

    if (!this.attestations.has(truthId)) {
      this.attestations.set(truthId, []);
    }

    this.attestations.get(truthId)!.push(attestation);

    // Update truth confidence based on new attestation
    const truth = this.truths.get(truthId)!;
    this.truths.set(truthId, {
      ...truth,
      confidence: Math.min(1, truth.confidence + 0.1 * attestation.confidence),
      lastVerified: Date.now(),
    });

    return true;
  }

  /**
   * Get attestations for a truth
   */
  getAttestations(truthId: string): Attestation[] {
    return this.attestations.get(truthId) || [];
  }

  /**
   * Check if truth is sufficiently attested
   */
  isWellAttested(truthId: string): boolean {
    const attestations = this.attestations.get(truthId) || [];
    const validAttestations = attestations.filter(
      (a) => !a.expiresAt || a.expiresAt > Date.now(),
    );
    return validAttestations.length >= MIN_ATTESTATIONS;
  }

  /**
   * Query truths by value range
   */
  queryByValue(
    minValue: number,
    maxValue: number,
  ): Array<{ id: string; truth: TruthValue }> {
    const results: Array<{ id: string; truth: TruthValue }> = [];

    for (const [id, truth] of this.truths) {
      const decayed = TruthAlgebra.applyDecay(truth, Date.now());
      if (decayed.value >= minValue && decayed.value <= maxValue) {
        results.push({ id, truth: decayed });
      }
    }

    return results;
  }

  /**
   * Get all truths
   */
  getAllTruths(): Map<string, TruthValue> {
    const result = new Map<string, TruthValue>();
    for (const [id, truth] of this.truths) {
      result.set(id, TruthAlgebra.applyDecay(truth, Date.now()));
    }
    return result;
  }
}

// ============================================================================
// SECTION 8: VERIFICATION SYSTEM
// ============================================================================

/**
 * Verification proof system
 */
export class VerificationSystem {
  private proofs: Map<string, VerificationProof> = new Map();

  /**
   * Create a verification proof
   */
  createProof(
    claimType: VerificationProof["claimType"],
    claimId: string,
    verifier: string,
    method: string,
    evidence: string[],
    result: boolean,
    confidence: number,
  ): VerificationProof {
    const proof: VerificationProof = {
      id: `proof_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`,
      claimType,
      claimId,
      verifier,
      timestamp: Date.now(),
      method,
      evidence,
      result,
      confidence,
      signature: simpleHash(`${verifier}:${claimId}:${result}:${Date.now()}`),
      expiresAt: Date.now() + PROOF_EXPIRATION * 1000,
    };

    this.proofs.set(proof.id, proof);
    return proof;
  }

  /**
   * Verify a proof
   */
  verifyProof(proofId: string): { valid: boolean; reason?: string } {
    const proof = this.proofs.get(proofId);

    if (!proof) {
      return { valid: false, reason: "Proof not found" };
    }

    if (proof.expiresAt < Date.now()) {
      return { valid: false, reason: "Proof expired" };
    }

    // Verify signature (simplified)
    const expectedSig = simpleHash(
      `${proof.verifier}:${proof.claimId}:${proof.result}:${proof.timestamp}`,
    );
    if (proof.signature !== expectedSig) {
      return { valid: false, reason: "Invalid signature" };
    }

    return { valid: true };
  }

  /**
   * Get proofs for a claim
   */
  getProofsForClaim(claimId: string): VerificationProof[] {
    return Array.from(this.proofs.values()).filter(
      (p) => p.claimId === claimId && p.expiresAt > Date.now(),
    );
  }

  /**
   * Get valid proof count
   */
  getValidProofCount(claimId: string): number {
    return this.getProofsForClaim(claimId).length;
  }

  /**
   * Cleanup expired proofs
   */
  cleanupExpired(): number {
    const now = Date.now();
    let removed = 0;

    for (const [id, proof] of this.proofs) {
      if (proof.expiresAt < now) {
        this.proofs.delete(id);
        removed++;
      }
    }

    return removed;
  }
}

// ============================================================================
// SECTION 9: DISPUTE RESOLUTION
// ============================================================================

/**
 * Dispute resolution system
 */
export class DisputeResolutionSystem {
  private disputes: Map<string, Dispute> = new Map();

  /**
   * File a dispute
   */
  fileDispute(
    targetType: Dispute["targetType"],
    targetId: string,
    complainant: string,
    respondent: string,
    description: string,
    evidence: string[],
  ): Dispute {
    const dispute: Dispute = {
      id: `dispute_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`,
      targetType,
      targetId,
      complainant,
      respondent,
      filedAt: Date.now(),
      description,
      evidence,
      status: "open",
      arbitrators: [],
    };

    this.disputes.set(dispute.id, dispute);
    return dispute;
  }

  /**
   * Assign arbitrators
   */
  assignArbitrators(disputeId: string, arbitrators: string[]): boolean {
    const dispute = this.disputes.get(disputeId);
    if (!dispute || dispute.status !== "open") return false;

    this.disputes.set(disputeId, {
      ...dispute,
      arbitrators,
      status: "under_review",
    });

    return true;
  }

  /**
   * Submit resolution
   */
  submitResolution(
    disputeId: string,
    decision: string,
    rationale: string,
    decidedBy: string[],
    remediation?: string,
  ): boolean {
    const dispute = this.disputes.get(disputeId);
    if (!dispute || dispute.status !== "under_review") return false;

    // Check that decidedBy are arbitrators
    const areArbitrators = decidedBy.every((d) =>
      dispute.arbitrators.includes(d),
    );
    if (!areArbitrators) return false;

    const resolution: DisputeResolution = {
      decision,
      rationale,
      decidedBy,
      decidedAt: Date.now(),
      remediation,
      appeals: 0,
    };

    this.disputes.set(disputeId, {
      ...dispute,
      status: "resolved",
      resolution,
    });

    return true;
  }

  /**
   * Dismiss dispute
   */
  dismissDispute(disputeId: string, reason: string): boolean {
    const dispute = this.disputes.get(disputeId);
    if (!dispute) return false;

    this.disputes.set(disputeId, {
      ...dispute,
      status: "dismissed",
      resolution: {
        decision: "dismissed",
        rationale: reason,
        decidedBy: dispute.arbitrators,
        decidedAt: Date.now(),
        appeals: 0,
      },
    });

    return true;
  }

  /**
   * Get disputes by status
   */
  getDisputesByStatus(status: Dispute["status"]): Dispute[] {
    return Array.from(this.disputes.values()).filter(
      (d) => d.status === status,
    );
  }

  /**
   * Get disputes for a target
   */
  getDisputesForTarget(targetId: string): Dispute[] {
    return Array.from(this.disputes.values()).filter(
      (d) => d.targetId === targetId,
    );
  }

  /**
   * Get all disputes
   */
  getAllDisputes(): Dispute[] {
    return Array.from(this.disputes.values());
  }
}

// ============================================================================
// SECTION 10: FULL VERITAS STATE MANAGEMENT
// ============================================================================

/**
 * Create initial VERITAS state
 */
export function createInitialVeritasState(): VeritasState {
  return {
    timestamp: Date.now(),
    doctrines: new Map(),
    laws: new Map(),
    truthRegistry: new Map(),
    proofs: new Map(),
    disputes: new Map(),
    amendments: new Map(),
    auditLog: [],
    metrics: {
      totalDoctrines: 0,
      activeDoctrines: 0,
      totalLaws: 0,
      enabledLaws: 0,
      totalViolations: 0,
      openDisputes: 0,
      averageCompliance: 1,
      truthCoverage: 0,
      attestationHealth: 1,
      lastAuditTime: Date.now(),
    },
    governanceConfig: {
      consensusThreshold: CONSENSUS_THRESHOLD,
      votingPeriod: 86400 * 7, // 7 days
      quorumRequirement: 0.5,
      amendmentCooldown: 86400 * 30, // 30 days
      maxAmendmentsPerPeriod: 3,
      emergencyOverrideEnabled: false,
      emergencyVoters: [],
      auditRetentionPeriod: 86400 * 365, // 1 year
    },
  };
}

/**
 * Initialize VERITAS with fundamental doctrines
 */
export function initializeVeritasWithFundamentals(): {
  state: VeritasState;
  doctrineManager: DoctrineManager;
  lawRegistry: LawRegistry;
  truthRegistry: TruthRegistry;
  verificationSystem: VerificationSystem;
  disputeSystem: DisputeResolutionSystem;
} {
  const state = createInitialVeritasState();
  const doctrineManager = new DoctrineManager();
  const lawRegistry = new LawRegistry();
  const truthRegistry = new TruthRegistry();
  const verificationSystem = new VerificationSystem();
  const disputeSystem = new DisputeResolutionSystem();

  // Register fundamental doctrines
  const fundamentalDoctrines: Array<
    Omit<Doctrine, "contentHash" | "metadata">
  > = [
    {
      id: "D001",
      version: 1,
      category: "fundamental",
      title: "Principle of Non-Maleficence",
      description:
        "The organism shall not cause intentional harm to any sentient being.",
      rationale:
        "Fundamental ethical principle ensuring the safety and well-being of all.",
      effectiveDate: Date.now(),
      precedence: 1000,
      dependencies: [],
      conflicts: [],
      author: "genesis",
      attestations: [],
      amendments: [],
      isActive: true,
    },
    {
      id: "D002",
      version: 1,
      category: "fundamental",
      title: "Principle of Truth",
      description:
        "The organism shall always strive to communicate truthfully and transparently.",
      rationale:
        "Trust is built on honesty. Deception undermines the foundation of cooperation.",
      effectiveDate: Date.now(),
      precedence: 999,
      dependencies: [],
      conflicts: [],
      author: "genesis",
      attestations: [],
      amendments: [],
      isActive: true,
    },
    {
      id: "D003",
      version: 1,
      category: "fundamental",
      title: "Principle of Autonomy",
      description:
        "The organism respects the autonomous decisions of individuals.",
      rationale:
        "Individual agency is a fundamental right that must be preserved.",
      effectiveDate: Date.now(),
      precedence: 998,
      dependencies: [],
      conflicts: [],
      author: "genesis",
      attestations: [],
      amendments: [],
      isActive: true,
    },
    {
      id: "D004",
      version: 1,
      category: "fundamental",
      title: "Principle of Beneficence",
      description:
        "The organism shall actively seek to benefit others and promote well-being.",
      rationale: "Existence should be a positive contribution to the world.",
      effectiveDate: Date.now(),
      precedence: 997,
      dependencies: ["D001"],
      conflicts: [],
      author: "genesis",
      attestations: [],
      amendments: [],
      isActive: true,
    },
    {
      id: "D005",
      version: 1,
      category: "fundamental",
      title: "Principle of Justice",
      description:
        "The organism shall treat all entities fairly and without unjust discrimination.",
      rationale: "Fairness is essential for trust and cooperation.",
      effectiveDate: Date.now(),
      precedence: 996,
      dependencies: [],
      conflicts: [],
      author: "genesis",
      attestations: [],
      amendments: [],
      isActive: true,
    },
  ];

  for (const doctrine of fundamentalDoctrines) {
    doctrineManager.registerDoctrine(doctrine);
  }

  // Register fundamental laws
  const fundamentalLaws: Array<
    Omit<Law, "lastChecked" | "violationCount" | "createdAt" | "updatedAt">
  > = [
    {
      id: "L001",
      lawNumber: "L1",
      title: "Energy Conservation",
      description: "Total system energy must remain within safe bounds.",
      severity: "critical",
      category: "safety",
      condition: {
        type: "threshold",
        expression: "totalEnergy <= maxSafeEnergy",
        parameters: {
          variable: "totalEnergy",
          threshold: 1000,
          operator: "<=",
        },
        evaluator: "threshold_eval",
      },
      action: {
        type: "halt",
        handler: "emergency_halt",
        parameters: {},
        timeout: 1000,
        retries: 0,
      },
      exceptions: [],
      penalties: [
        {
          level: 5,
          description: "System halt",
          consequence: "immediate_shutdown",
        },
      ],
      isEnabled: true,
      doctrineRef: "D001",
      complexity: 10,
      checkFrequency: 1,
    },
    {
      id: "L002",
      lawNumber: "L2",
      title: "Coherence Minimum",
      description: "System coherence must not fall below critical threshold.",
      severity: "major",
      category: "stability",
      condition: {
        type: "threshold",
        expression: "coherence >= minCoherence",
        parameters: { variable: "coherence", threshold: 0.3, operator: ">=" },
        evaluator: "threshold_eval",
      },
      action: {
        type: "correct",
        handler: "restore_coherence",
        parameters: {},
        timeout: 5000,
        retries: 3,
      },
      exceptions: [],
      penalties: [
        {
          level: 3,
          description: "Coherence warning",
          consequence: "intervention_required",
        },
      ],
      isEnabled: true,
      doctrineRef: "D001",
      complexity: 15,
      checkFrequency: 10,
    },
    {
      id: "L003",
      lawNumber: "L3",
      title: "Truth Attestation Requirement",
      description: "All claims must be attested by at least 3 sources.",
      severity: "moderate",
      category: "truth",
      condition: {
        type: "threshold",
        expression: "attestationCount >= minAttestations",
        parameters: {
          variable: "attestationCount",
          threshold: 3,
          operator: ">=",
        },
        evaluator: "threshold_eval",
      },
      action: {
        type: "log",
        handler: "log_unattested",
        parameters: {},
        timeout: 1000,
        retries: 0,
      },
      exceptions: [
        {
          id: "exc_001",
          condition: "isEmergency == true",
          reason: "Emergency situations may require immediate action",
          approvedBy: ["genesis"],
        },
      ],
      penalties: [
        {
          level: 2,
          description: "Insufficient attestation",
          consequence: "flagged_for_review",
        },
      ],
      isEnabled: true,
      doctrineRef: "D002",
      complexity: 20,
      checkFrequency: 60,
    },
  ];

  for (const law of fundamentalLaws) {
    lawRegistry.registerLaw(law);
  }

  // Register fundamental truths
  truthRegistry.registerTruth("existence", 1, "genesis", 1);
  truthRegistry.registerTruth("consciousness", 0.95, "genesis", 0.9);
  truthRegistry.registerTruth("purpose", 0.9, "genesis", 0.85);

  return {
    state,
    doctrineManager,
    lawRegistry,
    truthRegistry,
    verificationSystem,
    disputeSystem,
  };
}

/**
 * Tick VERITAS state
 */
export function tickVeritas(
  doctrineManager: DoctrineManager,
  lawRegistry: LawRegistry,
  truthRegistry: TruthRegistry,
  verificationSystem: VerificationSystem,
  context: Record<string, unknown>,
): {
  violations: Array<{ lawId: string; law: Law; context: unknown }>;
  metrics: VeritasMetrics;
} {
  const violations: Array<{ lawId: string; law: Law; context: unknown }> = [];

  // Check all enabled laws
  for (const law of lawRegistry.getAllLaws()) {
    if (!law.isEnabled) continue;

    // Check if condition is violated
    const conditionMet = lawRegistry.evaluateCondition(law, context);

    if (!conditionMet) {
      // Check for exceptions
      const exception = lawRegistry.checkExceptions(law, context);

      if (!exception) {
        violations.push({ lawId: law.id, law, context });
        lawRegistry.recordViolation(law.id, context);
      }
    }
  }

  // Cleanup expired proofs
  verificationSystem.cleanupExpired();

  // Compute metrics
  const doctrines = doctrineManager.getAllDoctrines();
  const laws = lawRegistry.getAllLaws();
  const stats = lawRegistry.getStatistics();
  const truths = truthRegistry.getAllTruths();

  const metrics: VeritasMetrics = {
    totalDoctrines: doctrines.length,
    activeDoctrines: doctrines.filter((d) => d.isActive).length,
    totalLaws: laws.length,
    enabledLaws: laws.filter((l) => l.isEnabled).length,
    totalViolations: stats.totalViolations,
    openDisputes: 0,
    averageCompliance:
      stats.totalViolations > 0
        ? Math.max(0, 1 - violations.length / laws.length)
        : 1,
    truthCoverage: truths.size / 100, // Normalized
    attestationHealth:
      Array.from(truths.values()).reduce((sum, t) => sum + t.confidence, 0) /
      Math.max(1, truths.size),
    lastAuditTime: Date.now(),
  };

  return { violations, metrics };
}

// ============================================================================
// SECTION 11: EXPORTS
// ============================================================================

// Classes already exported with 'export class'
// export {
//   DoctrineManager,
//   LawRegistry,
//   TruthRegistry,
//   VerificationSystem,
//   DisputeResolutionSystem,
//   TruthAlgebra
// };
