// doctrineEngine.ts — Doctrine Chain & Behavioral Programming Engine
// Living-world simulation platform

// ─── Types ────────────────────────────────────────────────────────────────────

export type DoctrineCategory =
  | "territorial"
  | "diplomatic"
  | "economic"
  | "military"
  | "spiritual"
  | "quantum"
  | "void";

export type ConflictResolutionMode =
  | "precedence"
  | "merge"
  | "veto"
  | "vote"
  | "arbitration"
  | "cascade";

export interface DoctrineRule {
  id: string;
  name: string;
  category: DoctrineCategory;
  description: string;
  conditions: DoctrineCondition[];
  actions: DoctrineAction[];
  priority: number;
  enabled: boolean;
  chainId: string;
  createdTick: number;
  expiryTick: number | null;
  authorFactionId: string;
  tags: string[];
  immutable: boolean;
}

export interface DoctrineCondition {
  field: string;
  operator:
    | "eq"
    | "neq"
    | "gt"
    | "lt"
    | "gte"
    | "lte"
    | "in"
    | "not_in"
    | "contains";
  value: unknown;
  negated: boolean;
}

export interface DoctrineAction {
  type:
    | "set"
    | "increment"
    | "decrement"
    | "append"
    | "remove"
    | "trigger"
    | "forbid"
    | "allow";
  target: string;
  value: unknown;
  magnitude: number | null;
}

export interface DoctrineChain {
  id: string;
  name: string;
  category: DoctrineCategory;
  rules: string[];
  parentChainId: string | null;
  childChainIds: string[];
  depth: number;
  factionId: string;
  active: boolean;
  createdTick: number;
  lockedAt: number | null;
  version: number;
  hash: string;
}

export interface DoctrineConflict {
  id: string;
  detectedTick: number;
  ruleAId: string;
  ruleBId: string;
  chainId: string;
  conflictType:
    | "contradiction"
    | "overlap"
    | "priority_tie"
    | "scope_collision"
    | "void_breach";
  severity: "low" | "medium" | "high" | "critical";
  resolved: boolean;
  resolutionId: string | null;
}

export interface DoctrineResolution {
  id: string;
  conflictId: string;
  mode: ConflictResolutionMode;
  appliedTick: number;
  winningRuleId: string | null;
  notes: string;
  automatedDecision: boolean;
}

export interface BehaviorPolicy {
  id: string;
  name: string;
  targetEntityType: string;
  targetEntityId: string | null;
  chainId: string;
  evaluationOrder: string[];
  fallbackAction: DoctrineAction | null;
  active: boolean;
  lastEvaluatedTick: number | null;
  evaluationCount: number;
}

export interface PolicyTree {
  rootPolicyId: string;
  nodes: Record<string, PolicyTreeNode>;
}

export interface PolicyTreeNode {
  policyId: string;
  children: string[];
  conditionToEnter: DoctrineCondition | null;
  weight: number;
}

export interface DoctrineVersion {
  versionNumber: number;
  chainId: string;
  snapshotJson: string;
  takenAtTick: number;
  takenByFactionId: string;
  changeLog: string;
  parentVersionNumber: number | null;
}

export interface DoctrineAudit {
  id: string;
  tick: number;
  chainId: string;
  ruleId: string | null;
  actorFactionId: string;
  action:
    | "add_rule"
    | "remove_rule"
    | "modify_rule"
    | "resolve_conflict"
    | "propagate"
    | "merge"
    | "fork"
    | "bind_law";
  before: string | null;
  after: string | null;
  notes: string;
}

export interface PropagationEvent {
  id: string;
  tick: number;
  sourceChainId: string;
  targetChainId: string;
  ruleIds: string[];
  propagationType: "broadcast" | "inheritance" | "override" | "suggestion";
  accepted: boolean;
  rejectionReason: string | null;
}

export interface LawBinding {
  id: string;
  doctrineRuleId: string;
  lawCode: string;
  lawText: string;
  bindingStrength: number;
  enforcingFactionId: string;
  boundAtTick: number;
  expiryTick: number | null;
  active: boolean;
  overridable: boolean;
}

export interface DoctrineState {
  id: string;
  name: string;
  chains: Record<string, DoctrineChain>;
  rules: Record<string, DoctrineRule>;
  conflicts: Record<string, DoctrineConflict>;
  resolutions: Record<string, DoctrineResolution>;
  policies: Record<string, BehaviorPolicy>;
  versions: Record<string, DoctrineVersion[]>;
  audits: DoctrineAudit[];
  propagationEvents: PropagationEvent[];
  lawBindings: Record<string, LawBinding>;
  tick: number;
}

// ─── Constants ────────────────────────────────────────────────────────────────

export const DOCTRINE_PRECEDENCE_ORDER: DoctrineCategory[] = [
  "void",
  "quantum",
  "spiritual",
  "military",
  "territorial",
  "diplomatic",
  "economic",
];

export const CONFLICT_RESOLUTION_MODES: Record<string, ConflictResolutionMode> =
  {
    default: "precedence",
    tied_priority: "vote",
    cross_faction: "arbitration",
    same_chain: "cascade",
    immutable_rule: "veto",
  };

export const MAX_CHAIN_DEPTH = 8;

export const LAW_BINDING_STRENGTH: Record<string, number> = {
  advisory: 0.2,
  soft: 0.5,
  enforced: 0.8,
  absolute: 1.0,
};

// ─── Utility ──────────────────────────────────────────────────────────────────

function generateId(prefix: string): string {
  return `${prefix}_${Math.random().toString(36).slice(2, 11)}_${Date.now()}`;
}

function simpleHash(input: string): string {
  let hash = 0;
  for (let i = 0; i < input.length; i++) {
    const char = input.charCodeAt(i);
    hash = (hash << 5) - hash + char;
    hash |= 0;
  }
  return Math.abs(hash).toString(16).padStart(8, "0");
}

function deepCloneRule(rule: DoctrineRule): DoctrineRule {
  return JSON.parse(JSON.stringify(rule)) as DoctrineRule;
}

function evaluateCondition(
  condition: DoctrineCondition,
  context: Record<string, unknown>,
): boolean {
  const fieldValue = context[condition.field];
  let result: boolean;

  switch (condition.operator) {
    case "eq":
      result = fieldValue === condition.value;
      break;
    case "neq":
      result = fieldValue !== condition.value;
      break;
    case "gt":
      result = (fieldValue as number) > (condition.value as number);
      break;
    case "lt":
      result = (fieldValue as number) < (condition.value as number);
      break;
    case "gte":
      result = (fieldValue as number) >= (condition.value as number);
      break;
    case "lte":
      result = (fieldValue as number) <= (condition.value as number);
      break;
    case "in":
      result =
        Array.isArray(condition.value) &&
        (condition.value as unknown[]).includes(fieldValue);
      break;
    case "not_in":
      result =
        Array.isArray(condition.value) &&
        !(condition.value as unknown[]).includes(fieldValue);
      break;
    case "contains":
      result =
        typeof fieldValue === "string" &&
        typeof condition.value === "string" &&
        fieldValue.includes(condition.value);
      break;
    default:
      result = false;
  }

  return condition.negated ? !result : result;
}

function allConditionsMet(
  conditions: DoctrineCondition[],
  context: Record<string, unknown>,
): boolean {
  return conditions.every((c) => evaluateCondition(c, context));
}

function createAuditEntry(
  state: DoctrineState,
  chainId: string,
  ruleId: string | null,
  actorFactionId: string,
  action: DoctrineAudit["action"],
  before: string | null,
  after: string | null,
  notes = "",
): DoctrineAudit {
  const entry: DoctrineAudit = {
    id: generateId("audit"),
    tick: state.tick,
    chainId,
    ruleId,
    actorFactionId,
    action,
    before,
    after,
    notes,
  };
  state.audits.push(entry);
  return entry;
}

// ─── Rule Management ──────────────────────────────────────────────────────────

export function addRule(
  state: DoctrineState,
  chainId: string,
  partial: Omit<DoctrineRule, "id" | "chainId" | "createdTick">,
): DoctrineRule {
  const chain = state.chains[chainId];
  if (!chain) throw new Error(`addRule: chain ${chainId} not found`);
  if (chain.depth >= MAX_CHAIN_DEPTH) {
    throw new Error(
      `addRule: chain ${chainId} has reached MAX_CHAIN_DEPTH (${MAX_CHAIN_DEPTH})`,
    );
  }

  const rule: DoctrineRule = {
    ...partial,
    id: generateId("rule"),
    chainId,
    createdTick: state.tick,
  };
  state.rules[rule.id] = rule;

  if (!chain.rules.includes(rule.id)) {
    chain.rules.push(rule.id);
  }
  chain.rules.sort(
    (a, b) => (state.rules[b]?.priority ?? 0) - (state.rules[a]?.priority ?? 0),
  );
  chain.hash = computeDoctrineHash(state, chainId);
  chain.version += 1;

  createAuditEntry(
    state,
    chainId,
    rule.id,
    rule.authorFactionId,
    "add_rule",
    null,
    JSON.stringify(rule),
  );
  return rule;
}

export function removeRule(
  state: DoctrineState,
  ruleId: string,
  actorFactionId: string,
): boolean {
  const rule = state.rules[ruleId];
  if (!rule) return false;
  if (rule.immutable)
    throw new Error(`removeRule: rule ${ruleId} is immutable`);

  const chain = state.chains[rule.chainId];
  const before = JSON.stringify(rule);
  delete state.rules[ruleId];

  if (chain) {
    chain.rules = chain.rules.filter((id) => id !== ruleId);
    chain.hash = computeDoctrineHash(state, chain.id);
    chain.version += 1;
  }

  createAuditEntry(
    state,
    rule.chainId,
    ruleId,
    actorFactionId,
    "remove_rule",
    before,
    null,
  );
  return true;
}

// ─── Conflict Detection & Resolution ─────────────────────────────────────────

export function resolveConflicts(
  state: DoctrineState,
  chainId: string,
): DoctrineResolution[] {
  const chain = state.chains[chainId];
  if (!chain) return [];

  const resolutions: DoctrineResolution[] = [];
  const chainRules = chain.rules
    .map((id) => state.rules[id])
    .filter(Boolean) as DoctrineRule[];

  for (let i = 0; i < chainRules.length; i++) {
    for (let j = i + 1; j < chainRules.length; j++) {
      const ruleA = chainRules[i];
      const ruleB = chainRules[j];
      const conflict = detectRuleConflict(state, ruleA, ruleB, chainId);
      if (!conflict) continue;
      if (state.conflicts[conflict.id]) continue;
      state.conflicts[conflict.id] = conflict;

      const resolution = autoResolveConflict(state, conflict, ruleA, ruleB);
      state.resolutions[resolution.id] = resolution;
      conflict.resolved = true;
      conflict.resolutionId = resolution.id;
      resolutions.push(resolution);

      createAuditEntry(
        state,
        chainId,
        null,
        ruleA.authorFactionId,
        "resolve_conflict",
        JSON.stringify(conflict),
        JSON.stringify(resolution),
        `Auto-resolved: ${resolution.mode}`,
      );
    }
  }
  return resolutions;
}

function detectRuleConflict(
  state: DoctrineState,
  ruleA: DoctrineRule,
  ruleB: DoctrineRule,
  chainId: string,
): DoctrineConflict | null {
  if (ruleA.category !== ruleB.category) return null;

  const conflictsInActions = ruleA.actions.some((actionA) =>
    ruleB.actions.some(
      (actionB) =>
        actionA.target === actionB.target &&
        ((actionA.type === "forbid" && actionB.type === "allow") ||
          (actionA.type === "allow" && actionB.type === "forbid") ||
          (actionA.type === "set" &&
            actionB.type === "set" &&
            actionA.value !== actionB.value)),
    ),
  );

  if (!conflictsInActions && ruleA.priority !== ruleB.priority) return null;

  const conflictType: DoctrineConflict["conflictType"] =
    ruleA.category === "void"
      ? "void_breach"
      : ruleA.priority === ruleB.priority
        ? "priority_tie"
        : conflictsInActions
          ? "contradiction"
          : "overlap";

  const severity: DoctrineConflict["severity"] =
    ruleA.category === "void" || ruleA.category === "quantum"
      ? "critical"
      : ruleA.category === "military"
        ? "high"
        : conflictType === "contradiction"
          ? "medium"
          : "low";

  return {
    id: generateId("conflict"),
    detectedTick: state.tick,
    ruleAId: ruleA.id,
    ruleBId: ruleB.id,
    chainId,
    conflictType,
    severity,
    resolved: false,
    resolutionId: null,
  };
}

function autoResolveConflict(
  state: DoctrineState,
  conflict: DoctrineConflict,
  ruleA: DoctrineRule,
  ruleB: DoctrineRule,
): DoctrineResolution {
  let mode: ConflictResolutionMode = CONFLICT_RESOLUTION_MODES.default;
  let winningRuleId: string | null = null;

  if (ruleA.immutable) {
    mode = "veto";
    winningRuleId = ruleA.id;
  } else if (ruleB.immutable) {
    mode = "veto";
    winningRuleId = ruleB.id;
  } else if (conflict.conflictType === "priority_tie") {
    mode = "vote";
    const catA = DOCTRINE_PRECEDENCE_ORDER.indexOf(ruleA.category);
    const catB = DOCTRINE_PRECEDENCE_ORDER.indexOf(ruleB.category);
    winningRuleId = catA <= catB ? ruleA.id : ruleB.id;
  } else {
    mode = "precedence";
    winningRuleId = ruleA.priority >= ruleB.priority ? ruleA.id : ruleB.id;
  }

  if (winningRuleId) {
    const loser = winningRuleId === ruleA.id ? ruleB : ruleA;
    if (!loser.immutable) loser.enabled = false;
  }

  return {
    id: generateId("resolution"),
    conflictId: conflict.id,
    mode,
    appliedTick: state.tick,
    winningRuleId,
    notes: `Auto-resolved via ${mode}. Winner: ${winningRuleId ?? "none"}.`,
    automatedDecision: true,
  };
}

// ─── Doctrine Propagation ─────────────────────────────────────────────────────

export function propagateDoctrine(
  state: DoctrineState,
  sourceChainId: string,
  targetChainId: string,
  ruleIds: string[],
  propagationType: PropagationEvent["propagationType"] = "broadcast",
): PropagationEvent {
  const sourceChain = state.chains[sourceChainId];
  const targetChain = state.chains[targetChainId];

  const event: PropagationEvent = {
    id: generateId("prop"),
    tick: state.tick,
    sourceChainId,
    targetChainId,
    ruleIds,
    propagationType,
    accepted: false,
    rejectionReason: null,
  };

  if (!sourceChain || !targetChain) {
    event.rejectionReason = "source or target chain not found";
    state.propagationEvents.push(event);
    return event;
  }

  if (targetChain.lockedAt !== null) {
    event.rejectionReason = `target chain locked at tick ${targetChain.lockedAt}`;
    state.propagationEvents.push(event);
    return event;
  }

  for (const ruleId of ruleIds) {
    const sourceRule = state.rules[ruleId];
    if (!sourceRule) continue;

    if (propagationType === "override" || !targetChain.rules.includes(ruleId)) {
      const cloned = deepCloneRule(sourceRule);
      cloned.id = generateId("rule");
      cloned.chainId = targetChainId;
      cloned.createdTick = state.tick;
      cloned.immutable = propagationType === "override";
      state.rules[cloned.id] = cloned;
      targetChain.rules.push(cloned.id);
    }
  }

  targetChain.hash = computeDoctrineHash(state, targetChainId);
  targetChain.version += 1;
  event.accepted = true;

  state.propagationEvents.push(event);
  createAuditEntry(
    state,
    targetChainId,
    null,
    sourceChain.factionId,
    "propagate",
    null,
    JSON.stringify(ruleIds),
    `Propagation type: ${propagationType}`,
  );
  return event;
}

// ─── Policy Evaluation ────────────────────────────────────────────────────────

export function evaluatePolicy(
  state: DoctrineState,
  policyId: string,
  context: Record<string, unknown>,
): DoctrineAction[] {
  const policy = state.policies[policyId];
  if (!policy || !policy.active) return [];

  const appliedActions: DoctrineAction[] = [];
  const chain = state.chains[policy.chainId];
  if (!chain) return [];

  const orderedRuleIds =
    policy.evaluationOrder.length > 0 ? policy.evaluationOrder : chain.rules;

  for (const ruleId of orderedRuleIds) {
    const rule = state.rules[ruleId];
    if (!rule || !rule.enabled) continue;
    if (rule.expiryTick !== null && state.tick > rule.expiryTick) continue;

    if (allConditionsMet(rule.conditions, context)) {
      appliedActions.push(...rule.actions);
    }
  }

  if (appliedActions.length === 0 && policy.fallbackAction) {
    appliedActions.push(policy.fallbackAction);
  }

  policy.lastEvaluatedTick = state.tick;
  policy.evaluationCount += 1;
  return appliedActions;
}

export function applyDoctrine(
  state: DoctrineState,
  chainId: string,
  context: Record<string, unknown>,
): Record<string, unknown> {
  const chain = state.chains[chainId];
  if (!chain || !chain.active) return context;

  const output: Record<string, unknown> = { ...context };

  const sortedRules = chain.rules
    .map((id) => state.rules[id])
    .filter((r): r is DoctrineRule => !!r && r.enabled)
    .filter((r) => r.expiryTick === null || state.tick <= r.expiryTick)
    .sort((a, b) => b.priority - a.priority);

  for (const rule of sortedRules) {
    if (!allConditionsMet(rule.conditions, output)) continue;

    for (const action of rule.actions) {
      switch (action.type) {
        case "set":
          output[action.target] = action.value;
          break;
        case "increment":
          output[action.target] =
            ((output[action.target] as number) ?? 0) + (action.magnitude ?? 1);
          break;
        case "decrement":
          output[action.target] =
            ((output[action.target] as number) ?? 0) - (action.magnitude ?? 1);
          break;
        case "append":
          if (Array.isArray(output[action.target])) {
            (output[action.target] as unknown[]).push(action.value);
          } else {
            output[action.target] = [action.value];
          }
          break;
        case "remove":
          if (Array.isArray(output[action.target])) {
            output[action.target] = (output[action.target] as unknown[]).filter(
              (v) => v !== action.value,
            );
          }
          break;
        case "forbid":
          output[`__forbid_${action.target}`] = true;
          break;
        case "allow":
          output[`__forbid_${action.target}`] = false;
          break;
        case "trigger":
          output[`__trigger_${action.target}`] = action.value ?? state.tick;
          break;
      }
    }
  }

  return output;
}

// ─── Hashing & Diffing ────────────────────────────────────────────────────────

export function computeDoctrineHash(
  state: DoctrineState,
  chainId: string,
): string {
  const chain = state.chains[chainId];
  if (!chain) return "0000000000000000";

  const rulesSerialized = chain.rules
    .map((id) => state.rules[id])
    .filter(Boolean)
    .map((r) => `${r!.id}:${r!.priority}:${r!.enabled}:${r!.category}`)
    .join("|");

  return simpleHash(`${chainId}:${chain.version}:${rulesSerialized}`);
}

export function diffDoctrines(
  state: DoctrineState,
  chainAId: string,
  chainBId: string,
): {
  onlyInA: string[];
  onlyInB: string[];
  inBoth: string[];
  priorityDiffs: Array<{
    ruleId: string;
    priorityA: number;
    priorityB: number;
  }>;
} {
  const chainA = state.chains[chainAId];
  const chainB = state.chains[chainBId];

  const setA = new Set(chainA?.rules ?? []);
  const setB = new Set(chainB?.rules ?? []);

  const onlyInA = [...setA].filter((id) => !setB.has(id));
  const onlyInB = [...setB].filter((id) => !setA.has(id));
  const inBoth = [...setA].filter((id) => setB.has(id));

  const priorityDiffs = inBoth
    .map((id) => {
      const rA = state.rules[id];
      const rB = state.rules[id];
      if (!rA || !rB) return null;
      if (rA.priority === rB.priority) return null;
      return { ruleId: id, priorityA: rA.priority, priorityB: rB.priority };
    })
    .filter((d): d is NonNullable<typeof d> => d !== null);

  return { onlyInA, onlyInB, inBoth, priorityDiffs };
}

export function mergeDoctrines(
  state: DoctrineState,
  sourceChainId: string,
  targetChainId: string,
  actorFactionId: string,
  overwriteConflicts = false,
): { merged: number; skipped: number; conflicts: string[] } {
  const source = state.chains[sourceChainId];
  const target = state.chains[targetChainId];

  if (!source || !target) throw new Error("mergeDoctrines: chain not found");
  if (target.lockedAt !== null)
    throw new Error("mergeDoctrines: target chain is locked");

  let merged = 0;
  let skipped = 0;
  const conflicts: string[] = [];

  for (const ruleId of source.rules) {
    const sourceRule = state.rules[ruleId];
    if (!sourceRule) continue;

    const existingInTarget = target.rules
      .map((id) => state.rules[id])
      .find(
        (r) =>
          r?.name === sourceRule.name && r.category === sourceRule.category,
      );

    if (existingInTarget) {
      if (overwriteConflicts && !existingInTarget.immutable) {
        const cloned = deepCloneRule(sourceRule);
        cloned.id = existingInTarget.id;
        cloned.chainId = targetChainId;
        state.rules[existingInTarget.id] = cloned;
        merged++;
      } else {
        conflicts.push(ruleId);
        skipped++;
      }
      continue;
    }

    const cloned = deepCloneRule(sourceRule);
    cloned.id = generateId("rule");
    cloned.chainId = targetChainId;
    cloned.createdTick = state.tick;
    state.rules[cloned.id] = cloned;
    target.rules.push(cloned.id);
    merged++;
  }

  target.hash = computeDoctrineHash(state, targetChainId);
  target.version += 1;

  createAuditEntry(
    state,
    targetChainId,
    null,
    actorFactionId,
    "merge",
    null,
    JSON.stringify({ merged, skipped }),
    `Merged from chain ${sourceChainId}`,
  );

  return { merged, skipped, conflicts };
}

// ─── Audit & Versioning ───────────────────────────────────────────────────────

export function auditDoctrine(
  state: DoctrineState,
  chainId: string,
): DoctrineAudit[] {
  return state.audits.filter((a) => a.chainId === chainId);
}

function snapshotChain(
  state: DoctrineState,
  chainId: string,
  actorFactionId: string,
  changeLog: string,
): DoctrineVersion {
  const chain = state.chains[chainId];
  if (!chain) throw new Error(`snapshotChain: chain ${chainId} not found`);

  const existingVersions = state.versions[chainId] ?? [];
  const parentVersionNumber =
    existingVersions.length > 0
      ? existingVersions[existingVersions.length - 1].versionNumber
      : null;

  const version: DoctrineVersion = {
    versionNumber: existingVersions.length + 1,
    chainId,
    snapshotJson: JSON.stringify(
      chain.rules.map((id) => state.rules[id]).filter(Boolean),
    ),
    takenAtTick: state.tick,
    takenByFactionId: actorFactionId,
    changeLog,
    parentVersionNumber,
  };

  if (!state.versions[chainId]) state.versions[chainId] = [];
  state.versions[chainId].push(version);
  return version;
}

// ─── Law Binding ──────────────────────────────────────────────────────────────

export function bindToLaw(
  state: DoctrineState,
  ruleId: string,
  lawCode: string,
  lawText: string,
  bindingStrengthKey: string,
  enforcingFactionId: string,
  expiryTick: number | null = null,
  overridable = true,
): LawBinding {
  const rule = state.rules[ruleId];
  if (!rule) throw new Error(`bindToLaw: rule ${ruleId} not found`);

  const strength =
    LAW_BINDING_STRENGTH[bindingStrengthKey] ?? LAW_BINDING_STRENGTH.soft;

  if (strength >= LAW_BINDING_STRENGTH.absolute) {
    rule.immutable = true;
  }

  const binding: LawBinding = {
    id: generateId("lawbind"),
    doctrineRuleId: ruleId,
    lawCode,
    lawText,
    bindingStrength: strength,
    enforcingFactionId,
    boundAtTick: state.tick,
    expiryTick,
    active: true,
    overridable,
  };
  state.lawBindings[binding.id] = binding;

  createAuditEntry(
    state,
    rule.chainId,
    ruleId,
    enforcingFactionId,
    "bind_law",
    null,
    JSON.stringify(binding),
    `Bound to law: ${lawCode}`,
  );

  return binding;
}

// ─── DoctrineEngine Class ─────────────────────────────────────────────────────

export class DoctrineEngine {
  private state: DoctrineState;

  constructor(name: string) {
    this.state = {
      id: generateId("doctrine"),
      name,
      chains: {},
      rules: {},
      conflicts: {},
      resolutions: {},
      policies: {},
      versions: {},
      audits: [],
      propagationEvents: [],
      lawBindings: {},
      tick: 0,
    };
  }

  getState(): DoctrineState {
    return this.state;
  }

  createChain(
    name: string,
    category: DoctrineCategory,
    factionId: string,
    parentChainId: string | null = null,
  ): DoctrineChain {
    const parentDepth = parentChainId
      ? (this.state.chains[parentChainId]?.depth ?? 0)
      : 0;
    if (parentDepth + 1 > MAX_CHAIN_DEPTH) {
      throw new Error(
        `createChain: parent chain depth would exceed MAX_CHAIN_DEPTH (${MAX_CHAIN_DEPTH})`,
      );
    }

    const chain: DoctrineChain = {
      id: generateId("chain"),
      name,
      category,
      rules: [],
      parentChainId,
      childChainIds: [],
      depth: parentDepth + 1,
      factionId,
      active: true,
      createdTick: this.state.tick,
      lockedAt: null,
      version: 0,
      hash: "",
    };
    chain.hash = simpleHash(`${chain.id}:${name}:${factionId}`);
    this.state.chains[chain.id] = chain;

    if (parentChainId && this.state.chains[parentChainId]) {
      this.state.chains[parentChainId].childChainIds.push(chain.id);
    }
    return chain;
  }

  addRule(
    chainId: string,
    partial: Omit<DoctrineRule, "id" | "chainId" | "createdTick">,
  ): DoctrineRule {
    return addRule(this.state, chainId, partial);
  }

  removeRule(ruleId: string, actorFactionId: string): boolean {
    return removeRule(this.state, ruleId, actorFactionId);
  }

  evaluate(
    chainId: string,
    context: Record<string, unknown>,
  ): Record<string, unknown> {
    return applyDoctrine(this.state, chainId, context);
  }

  evaluatePolicy(
    policyId: string,
    context: Record<string, unknown>,
  ): DoctrineAction[] {
    return evaluatePolicy(this.state, policyId, context);
  }

  propagate(
    sourceChainId: string,
    targetChainId: string,
    ruleIds: string[],
    type: PropagationEvent["propagationType"] = "broadcast",
  ): PropagationEvent {
    return propagateDoctrine(
      this.state,
      sourceChainId,
      targetChainId,
      ruleIds,
      type,
    );
  }

  resolveConflicts(chainId: string): DoctrineResolution[] {
    return resolveConflicts(this.state, chainId);
  }

  merge(
    sourceChainId: string,
    targetChainId: string,
    actorFactionId: string,
    overwrite = false,
  ): ReturnType<typeof mergeDoctrines> {
    return mergeDoctrines(
      this.state,
      sourceChainId,
      targetChainId,
      actorFactionId,
      overwrite,
    );
  }

  fork(
    sourceChainId: string,
    newName: string,
    factionId: string,
  ): DoctrineChain {
    const source = this.state.chains[sourceChainId];
    if (!source)
      throw new Error(`fork: source chain ${sourceChainId} not found`);

    const forked = this.createChain(
      newName,
      source.category,
      factionId,
      source.parentChainId,
    );

    for (const ruleId of source.rules) {
      const rule = this.state.rules[ruleId];
      if (!rule) continue;
      const cloned = deepCloneRule(rule);
      cloned.id = generateId("rule");
      cloned.chainId = forked.id;
      cloned.createdTick = this.state.tick;
      cloned.immutable = false;
      this.state.rules[cloned.id] = cloned;
      forked.rules.push(cloned.id);
    }

    forked.hash = computeDoctrineHash(this.state, forked.id);

    createAuditEntry(
      this.state,
      forked.id,
      null,
      factionId,
      "fork",
      null,
      JSON.stringify({ forkedFromChainId: sourceChainId }),
      `Forked from ${source.name}`,
    );

    return forked;
  }

  lockChain(chainId: string): void {
    const chain = this.state.chains[chainId];
    if (chain) chain.lockedAt = this.state.tick;
  }

  unlockChain(chainId: string): void {
    const chain = this.state.chains[chainId];
    if (chain) chain.lockedAt = null;
  }

  snapshot(
    chainId: string,
    actorFactionId: string,
    changeLog: string,
  ): DoctrineVersion {
    return snapshotChain(this.state, chainId, actorFactionId, changeLog);
  }

  bindToLaw(
    ruleId: string,
    lawCode: string,
    lawText: string,
    strengthKey: string,
    factionId: string,
    expiryTick: number | null = null,
  ): LawBinding {
    return bindToLaw(
      this.state,
      ruleId,
      lawCode,
      lawText,
      strengthKey,
      factionId,
      expiryTick,
    );
  }

  hash(chainId: string): string {
    return computeDoctrineHash(this.state, chainId);
  }

  diff(chainAId: string, chainBId: string): ReturnType<typeof diffDoctrines> {
    return diffDoctrines(this.state, chainAId, chainBId);
  }

  audit(chainId: string): DoctrineAudit[] {
    return auditDoctrine(this.state, chainId);
  }

  createPolicy(
    name: string,
    chainId: string,
    targetEntityType: string,
    targetEntityId: string | null = null,
    fallbackAction: DoctrineAction | null = null,
  ): BehaviorPolicy {
    const chain = this.state.chains[chainId];
    if (!chain) throw new Error(`createPolicy: chain ${chainId} not found`);

    const policy: BehaviorPolicy = {
      id: generateId("policy"),
      name,
      targetEntityType,
      targetEntityId,
      chainId,
      evaluationOrder: [...chain.rules],
      fallbackAction,
      active: true,
      lastEvaluatedTick: null,
      evaluationCount: 0,
    };
    this.state.policies[policy.id] = policy;
    return policy;
  }

  createPolicyTree(rootPolicyId: string): PolicyTree {
    const rootPolicy = this.state.policies[rootPolicyId];
    if (!rootPolicy)
      throw new Error(
        `createPolicyTree: root policy ${rootPolicyId} not found`,
      );

    const nodes: Record<string, PolicyTreeNode> = {};
    const buildTree = (policyId: string, visited: Set<string>): void => {
      if (visited.has(policyId)) return;
      visited.add(policyId);
      nodes[policyId] = {
        policyId,
        children: [],
        conditionToEnter: null,
        weight: 1.0,
      };
    };

    buildTree(rootPolicyId, new Set());
    return { rootPolicyId, nodes };
  }

  private tickExpireRules(): void {
    for (const rule of Object.values(this.state.rules)) {
      if (rule.expiryTick !== null && this.state.tick >= rule.expiryTick) {
        rule.enabled = false;
      }
    }
  }

  private tickExpireLawBindings(): void {
    for (const binding of Object.values(this.state.lawBindings)) {
      if (!binding.active) continue;
      if (
        binding.expiryTick !== null &&
        this.state.tick >= binding.expiryTick
      ) {
        binding.active = false;
        const rule = this.state.rules[binding.doctrineRuleId];
        if (rule && binding.bindingStrength >= LAW_BINDING_STRENGTH.absolute) {
          rule.immutable = false;
        }
      }
    }
  }

  private tickExpireAgreements(): void {
    for (const chain of Object.values(this.state.chains)) {
      if (!chain.active) continue;
    }
  }

  tick(): void {
    this.tickExpireRules();
    this.tickExpireLawBindings();
    this.tickExpireAgreements();
    this.state.tick += 1;
  }

  serialize(): string {
    return JSON.stringify(this.state, null, 2);
  }

  static deserialize(json: string): DoctrineEngine {
    const data = JSON.parse(json) as DoctrineState;
    const engine = new DoctrineEngine(data.name);
    engine.state = data;
    return engine;
  }

  getChain(chainId: string): DoctrineChain | null {
    return this.state.chains[chainId] ?? null;
  }

  getRule(ruleId: string): DoctrineRule | null {
    return this.state.rules[ruleId] ?? null;
  }

  listChains(): DoctrineChain[] {
    return Object.values(this.state.chains);
  }

  listRules(chainId?: string): DoctrineRule[] {
    const all = Object.values(this.state.rules);
    return chainId ? all.filter((r) => r.chainId === chainId) : all;
  }

  listConflicts(resolved = false): DoctrineConflict[] {
    return Object.values(this.state.conflicts).filter(
      (c) => c.resolved === resolved,
    );
  }

  listPropagationEvents(): PropagationEvent[] {
    return [...this.state.propagationEvents];
  }

  getVersionHistory(chainId: string): DoctrineVersion[] {
    return this.state.versions[chainId] ?? [];
  }

  currentTick(): number {
    return this.state.tick;
  }
}
