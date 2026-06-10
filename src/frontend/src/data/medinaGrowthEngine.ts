// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  MEDINA GROWTH ENGINE — EXPONENTIAL LEARNING & KNOWLEDGE ACCUMULATION                                     ║
// ║  ─────────────────────────────────────────────────────────────────────────────────────────────────────── ║
// ║  Owner:        Alfredo Medina Hernandez                                                                   ║
// ║  Location:     Dallas, Texas, United States of America                                                    ║
// ║  Contact:      MedinaSITech@outlook.com                                                                   ║
// ║  Framework:    Medina Doctrine                                                                            ║
// ║                                                                                                           ║
// ║  THIS IS THE GROWTH ENGINE — WHERE KNOWLEDGE COMPOUNDS EXPONENTIALLY.                                    ║
// ║  Today knows more than yesterday. Tomorrow knows more than today. The gap compounds.                      ║
// ║  Not linear - exponential. Not stable - growing. Every day the organism gets smarter.                    ║
// ║                                                                                                           ║
// ║  ARCHITECTURE:                                                                                            ║
// ║  ═══════════════════════════════════════════════════════════════════════════════════════════════════════ ║
// ║  Layer 1: Knowledge Acquisition - How new information enters the system                                  ║
// ║  Layer 2: Knowledge Processing - How information becomes knowledge                                       ║
// ║  Layer 3: Knowledge Integration - How knowledge connects to existing knowledge                           ║
// ║  Layer 4: Knowledge Application - How knowledge becomes wisdom and action                                ║
// ║  Layer 5: Knowledge Compounding - How today's knowledge amplifies tomorrow's learning                    ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

import {
  type CompoundState,
  E,
  MEDINA_ALPHA,
  MEDINA_BETA,
  MEDINA_DELTA,
  MEDINA_ETA,
  MEDINA_GAMMA,
  MEDINA_ZETA,
  PHI,
  PHI_INVERSE,
  S_ZERO,
  clamp,
  compoundValue,
  correlation,
  ema,
  initCompoundState,
  lerp,
  mean,
  projectCompoundValue,
  sigmoid,
  smoothstep,
  softplus,
  stdDev,
  updateCompoundState,
  variance,
} from "./medinaCompoundEngine";

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// SECTION 1: GROWTH CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

// Base Learning Rates
export const BASE_LEARNING_RATE = MEDINA_ALPHA; // 0.042
export const ACCELERATED_LEARNING_RATE = MEDINA_ALPHA * PHI; // 0.068
export const DEEP_LEARNING_RATE = MEDINA_ALPHA * PHI_INVERSE; // 0.026

// Knowledge Decay Rates
export const KNOWLEDGE_HALF_LIFE_DAYS = 90; // Without reinforcement
export const SKILL_HALF_LIFE_DAYS = 180; // Skills decay slower
export const WISDOM_HALF_LIFE_DAYS = 365; // Wisdom decays slowest

// Compound Growth Constants
export const DAILY_COMPOUND_RATE = 0.003; // 0.3% daily = 189% annually
export const WEEKLY_COMPOUND_RATE = 0.021; // ~2.1% weekly
export const MONTHLY_COMPOUND_RATE = 0.09; // ~9% monthly
export const ANNUAL_COMPOUND_RATE = 1.89; // 189% annual

// Streak Multipliers
export const STREAK_BASE_MULTIPLIER = 1.0;
export const STREAK_GROWTH_PER_DAY = 0.02; // 2% per streak day
export const MAX_STREAK_MULTIPLIER = 3.0; // Cap at 3x
export const STREAK_RESET_PENALTY = 0.5; // Lose 50% of streak value

// Learning Curve Parameters
export const LEARNING_CURVE_STEEPNESS = 0.1; // S-curve steepness
export const LEARNING_PLATEAU_START = 0.7; // Where diminishing returns begin
export const MASTERY_THRESHOLD = 0.95; // When skill is "mastered"

// Experience Points
export const XP_PER_TASK_COMPLETE = 10;
export const XP_PER_SKILL_USE = 5;
export const XP_PER_CHALLENGE_OVERCOME = 50;
export const XP_PER_KNOWLEDGE_SHARE = 20;
export const XP_PER_INNOVATION = 100;

// Level Thresholds (exponential)
export const LEVEL_XP_BASE = 100;
export const LEVEL_XP_MULTIPLIER = PHI; // Each level needs PHI times more XP

// Knowledge Categories
export const KNOWLEDGE_CATEGORIES = [
  "technical",
  "domain",
  "procedural",
  "conceptual",
  "metacognitive",
  "social",
  "creative",
  "strategic",
] as const;

export type KnowledgeCategory = (typeof KNOWLEDGE_CATEGORIES)[number];

// Skill Categories
export const SKILL_CATEGORIES = [
  "cognitive",
  "technical",
  "interpersonal",
  "leadership",
  "creative",
  "analytical",
  "communication",
  "execution",
] as const;

export type SkillCategory = (typeof SKILL_CATEGORIES)[number];

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// SECTION 2: TYPE DEFINITIONS — KNOWLEDGE & GROWTH STRUCTURES
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

/**
 * A piece of knowledge in the system
 */
export interface KnowledgeNode {
  id: string;
  title: string;
  description: string;
  category: KnowledgeCategory;
  content: string;
  tags: string[];
  strength: number; // 0-1, how well known
  accessibility: number; // 0-1, how easily retrieved
  connections: KnowledgeConnection[];
  sources: KnowledgeSource[];
  applications: KnowledgeApplication[];
  acquisitionDate: number;
  lastAccessDate: number;
  accessCount: number;
  reinforcementCount: number;
  decayRate: number;
  compound: CompoundState;
}

export interface KnowledgeConnection {
  targetId: string;
  type: "prerequisite" | "related" | "extends" | "contradicts" | "supports";
  strength: number;
  bidirectional: boolean;
  created: number;
}

export interface KnowledgeSource {
  type:
    | "experience"
    | "teaching"
    | "reading"
    | "observation"
    | "experiment"
    | "collaboration";
  sourceId: string;
  date: number;
  quality: number;
  trustworthiness: number;
}

export interface KnowledgeApplication {
  context: string;
  date: number;
  success: boolean;
  outcome: string;
  insights: string[];
}

/**
 * A skill in the system
 */
export interface SkillNode {
  id: string;
  name: string;
  description: string;
  category: SkillCategory;
  level: number; // 0-100
  experience: number; // Total hours
  proficiency: number; // 0-1, current ability
  potential: number; // 0-1, max possible level
  learningRate: number; // How fast skill improves
  decayRate: number; // How fast skill decays
  prerequisites: string[];
  dependents: string[];
  subskills: SubSkill[];
  practiceHistory: PracticeSession[];
  assessments: SkillAssessment[];
  compound: CompoundState;
}

export interface SubSkill {
  id: string;
  name: string;
  level: number;
  weight: number; // Contribution to parent skill
}

export interface PracticeSession {
  date: number;
  duration: number; // Minutes
  quality: number; // 0-1
  focus: number; // 0-1
  outcome: "improved" | "maintained" | "declined";
  insights: string[];
}

export interface SkillAssessment {
  id: string;
  date: number;
  assessor: string;
  score: number;
  feedback: string;
  areas: { name: string; score: number }[];
}

/**
 * A learning goal
 */
export interface LearningGoal {
  id: string;
  title: string;
  description: string;
  type: "knowledge" | "skill" | "certification" | "project";
  targetId: string; // ID of knowledge/skill to achieve
  targetLevel: number; // Target proficiency
  currentLevel: number; // Current proficiency
  deadline: number;
  priority: number;
  status: "not_started" | "in_progress" | "completed" | "abandoned";
  milestones: LearningMilestone[];
  resources: LearningResource[];
  timeInvested: number; // Hours
  estimatedTimeRemaining: number;
  compound: CompoundState;
}

export interface LearningMilestone {
  id: string;
  title: string;
  targetLevel: number;
  achieved: boolean;
  achievedDate: number | null;
  reward: number; // XP reward
}

export interface LearningResource {
  id: string;
  type: "course" | "book" | "video" | "mentor" | "practice" | "project";
  title: string;
  url?: string;
  estimatedTime: number;
  completionRate: number;
  effectiveness: number;
}

/**
 * Experience and leveling
 */
export interface ExperienceState {
  totalXP: number;
  level: number;
  currentLevelXP: number;
  nextLevelXP: number;
  xpToNextLevel: number;
  levelProgress: number; // 0-1
  xpHistory: XPEvent[];
  achievements: Achievement[];
  milestones: ExperienceMilestone[];
  multipliers: XPMultiplier[];
  compound: CompoundState;
}

export interface XPEvent {
  id: string;
  amount: number;
  source: string;
  category: string;
  timestamp: number;
  multiplier: number;
}

export interface Achievement {
  id: string;
  title: string;
  description: string;
  icon: string;
  rarity: "common" | "uncommon" | "rare" | "epic" | "legendary";
  xpReward: number;
  unlockedAt: number | null;
  progress: number;
  target: number;
}

export interface ExperienceMilestone {
  level: number;
  title: string;
  reward: string;
  achieved: boolean;
}

export interface XPMultiplier {
  id: string;
  name: string;
  value: number;
  source: string;
  expiresAt: number | null;
}

/**
 * Learning streak tracking
 */
export interface StreakState {
  currentStreak: number; // Days
  longestStreak: number;
  totalDays: number;
  lastActivityDate: number;
  currentMultiplier: number;
  streakHistory: StreakPeriod[];
  freezesAvailable: number;
  freezesUsed: number;
  compound: CompoundState;
}

export interface StreakPeriod {
  startDate: number;
  endDate: number;
  length: number;
  reason: "active" | "broken" | "frozen";
}

/**
 * Knowledge graph state
 */
export interface KnowledgeGraphState {
  nodes: Map<string, KnowledgeNode>;
  skills: Map<string, SkillNode>;
  edges: KnowledgeEdge[];
  clusters: KnowledgeCluster[];
  totalKnowledge: number;
  totalSkills: number;
  graphDensity: number;
  averageConnections: number;
  strongestConnections: string[];
  weakestAreas: string[];
  compound: CompoundState;
}

export interface KnowledgeEdge {
  sourceId: string;
  targetId: string;
  type: "knowledge-knowledge" | "knowledge-skill" | "skill-skill";
  strength: number;
  created: number;
  lastActivated: number;
}

export interface KnowledgeCluster {
  id: string;
  name: string;
  nodeIds: string[];
  coherence: number;
  size: number;
  category: KnowledgeCategory;
}

/**
 * Full growth state
 */
export interface GrowthState {
  entityId: string;
  experience: ExperienceState;
  streak: StreakState;
  knowledgeGraph: KnowledgeGraphState;
  learningGoals: Map<string, LearningGoal>;
  dailyProgress: DailyProgress;
  weeklyProgress: WeeklyProgress;
  monthlyProgress: MonthlyProgress;
  growthMetrics: GrowthMetrics;
  compound: CompoundState;
}

export interface DailyProgress {
  date: number;
  xpEarned: number;
  knowledgeGained: number;
  skillsImproved: string[];
  tasksCompleted: number;
  timeInvested: number;
  streak: number;
  compound: CompoundState;
}

export interface WeeklyProgress {
  weekStart: number;
  xpEarned: number;
  knowledgeGained: number;
  skillsImproved: string[];
  goalsProgress: { goalId: string; progress: number }[];
  averageDailyXP: number;
  trend: number;
  compound: CompoundState;
}

export interface MonthlyProgress {
  monthStart: number;
  xpEarned: number;
  levelGained: number;
  knowledgeGained: number;
  skillsMastered: string[];
  goalsCompleted: string[];
  growthRate: number;
  compound: CompoundState;
}

export interface GrowthMetrics {
  overallGrowthRate: number;
  knowledgeGrowthRate: number;
  skillGrowthRate: number;
  learningEfficiency: number;
  retentionRate: number;
  applicationRate: number;
  innovationRate: number;
  teachingRate: number;
  collaborationRate: number;
  consistencyScore: number;
}

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// SECTION 3: LEARNING CURVE MATHEMATICS
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

/**
 * EQUATION: S-Curve Learning
 * L(t) = L_max / (1 + e^(-k(t - t_mid)))
 *
 * Classic S-curve for skill acquisition
 */
export function calculateSCurveLearning(
  time: number,
  maxLevel = 1,
  steepness: number = LEARNING_CURVE_STEEPNESS,
  midpoint = 50,
): number {
  return maxLevel / (1 + Math.exp(-steepness * (time - midpoint)));
}

/**
 * EQUATION: Power Law of Practice
 * P(n) = a × n^(-b) + c
 *
 * Time to complete task decreases with practice
 */
export function calculatePowerLawPractice(
  practiceCount: number,
  initialTime = 100,
  learningRate = 0.4,
  minimumTime = 10,
): number {
  return initialTime * (practiceCount + 1) ** -learningRate + minimumTime;
}

/**
 * EQUATION: Diminishing Returns
 * R(x) = max × (1 - e^(-k×x))
 *
 * Returns diminish as you approach mastery
 */
export function calculateDiminishingReturns(
  effort: number,
  maxReturn = 1,
  rate = 0.05,
): number {
  return maxReturn * (1 - Math.exp(-rate * effort));
}

/**
 * EQUATION: Forgetting Curve (Ebbinghaus)
 * R(t) = e^(-t/S)
 *
 * Memory retention over time
 */
export function calculateForgettingCurve(
  timeSinceReview: number,
  stability: number = KNOWLEDGE_HALF_LIFE_DAYS,
): number {
  return Math.exp(-timeSinceReview / stability);
}

/**
 * EQUATION: Spaced Repetition Interval
 * I(n) = I(0) × EF^n
 *
 * Optimal interval for next review
 */
export function calculateSpacedRepetitionInterval(
  repetitionNumber: number,
  baseInterval = 1,
  easinessFactor = 2.5,
): number {
  return baseInterval * easinessFactor ** repetitionNumber;
}

/**
 * EQUATION: Learning Rate Adaptation
 * η(t) = η₀ × (1 - progress) × difficulty_factor × fatigue_factor
 *
 * Adaptive learning rate based on context
 */
export function calculateAdaptiveLearningRate(
  baseRate: number,
  progress: number,
  difficulty: number,
  fatigue: number,
): number {
  const progressFactor = 1 - progress * 0.5; // Slower as you progress
  const difficultyFactor = 1 + difficulty * 0.5; // Faster for easier material
  const fatigueFactor = 1 - fatigue * 0.3; // Slower when tired

  return clamp(
    baseRate * progressFactor * difficultyFactor * fatigueFactor,
    0.001,
    0.5,
  );
}

/**
 * EQUATION: Skill Decay
 * S(t) = S₀ × e^(-λt) + S_floor
 *
 * Skill decays without practice
 */
export function calculateSkillDecay(
  initialSkill: number,
  daysSincePractice: number,
  decayRate = 0.01,
  floorLevel = 0.2,
): number {
  const decayed = initialSkill * Math.exp(-decayRate * daysSincePractice);
  return Math.max(decayed, floorLevel * initialSkill);
}

/**
 * EQUATION: Compound Learning
 * K(t+1) = K(t) × (1 + r × (1 + streak_bonus)) + new_knowledge
 *
 * Knowledge compounds daily
 */
export function calculateCompoundLearning(
  currentKnowledge: number,
  newKnowledge: number,
  compoundRate: number = DAILY_COMPOUND_RATE,
  streakBonus = 0,
): number {
  const compoundFactor = 1 + compoundRate * (1 + streakBonus);
  return currentKnowledge * compoundFactor + newKnowledge;
}

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// SECTION 4: EXPERIENCE & LEVELING MATHEMATICS
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

/**
 * EQUATION: XP Required for Level
 * XP(L) = base × multiplier^(L-1)
 *
 * Exponential XP requirements
 */
export function calculateXPForLevel(
  level: number,
  base: number = LEVEL_XP_BASE,
  multiplier: number = LEVEL_XP_MULTIPLIER,
): number {
  return Math.floor(base * multiplier ** (level - 1));
}

/**
 * EQUATION: Total XP to Reach Level
 * Total(L) = Σ(XP(i)) for i=1 to L
 *
 * Sum of all XP needed
 */
export function calculateTotalXPForLevel(
  level: number,
  base: number = LEVEL_XP_BASE,
  multiplier: number = LEVEL_XP_MULTIPLIER,
): number {
  let total = 0;
  for (let i = 1; i <= level; i++) {
    total += calculateXPForLevel(i, base, multiplier);
  }
  return Math.floor(total);
}

/**
 * EQUATION: Level from Total XP
 * Inverse of total XP function
 */
export function calculateLevelFromXP(
  totalXP: number,
  base: number = LEVEL_XP_BASE,
  multiplier: number = LEVEL_XP_MULTIPLIER,
): { level: number; currentLevelXP: number; xpToNextLevel: number } {
  let level = 1;
  let xpUsed = 0;

  while (true) {
    const xpForThisLevel = calculateXPForLevel(level, base, multiplier);
    if (xpUsed + xpForThisLevel > totalXP) {
      break;
    }
    xpUsed += xpForThisLevel;
    level++;
  }

  const currentLevelXP = totalXP - xpUsed;
  const xpToNextLevel =
    calculateXPForLevel(level, base, multiplier) - currentLevelXP;

  return { level, currentLevelXP, xpToNextLevel };
}

/**
 * EQUATION: XP Multiplier from Streak
 * M(s) = 1 + min(growth × s, max - 1)
 *
 * Streak increases XP gain
 */
export function calculateStreakMultiplier(
  streakDays: number,
  growthPerDay: number = STREAK_GROWTH_PER_DAY,
  maxMultiplier: number = MAX_STREAK_MULTIPLIER,
): number {
  return 1 + Math.min(growthPerDay * streakDays, maxMultiplier - 1);
}

/**
 * EQUATION: XP with Multipliers
 * XP_final = XP_base × Π(multipliers)
 *
 * Apply all multipliers
 */
export function calculateFinalXP(
  baseXP: number,
  multipliers: number[],
): number {
  const totalMultiplier = multipliers.reduce((prod, m) => prod * m, 1);
  return Math.floor(baseXP * totalMultiplier);
}

/**
 * EQUATION: Level Progress
 * P = current_xp / xp_required
 *
 * Progress to next level
 */
export function calculateLevelProgress(
  currentLevelXP: number,
  xpForLevel: number,
): number {
  return clamp(currentLevelXP / xpForLevel, 0, 1);
}

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// SECTION 5: KNOWLEDGE GRAPH MATHEMATICS
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

/**
 * EQUATION: Knowledge Connection Strength
 * S = co_access × similarity × recency × application
 *
 * How strongly two pieces of knowledge connect
 */
export function calculateConnectionStrength(
  coAccessCount: number,
  similarityScore: number,
  daysSinceCoAccess: number,
  applicationsTogether: number,
  maxCoAccess = 100,
): number {
  const coAccessFactor = Math.min(coAccessCount / maxCoAccess, 1);
  const recencyFactor = Math.exp(-daysSinceCoAccess / 30);
  const applicationFactor = Math.min(1, 0.5 + applicationsTogether * 0.1);

  return clamp(
    coAccessFactor * similarityScore * recencyFactor * applicationFactor,
    0,
    1,
  );
}

/**
 * EQUATION: Knowledge Accessibility
 * A = base × recency × connections × reinforcement
 *
 * How easily knowledge can be retrieved
 */
export function calculateAccessibility(
  baseAccessibility: number,
  daysSinceAccess: number,
  connectionCount: number,
  reinforcementCount: number,
): number {
  const recencyFactor = Math.exp(-daysSinceAccess / 14);
  const connectionFactor = Math.min(1, 0.5 + connectionCount * 0.05);
  const reinforcementFactor = Math.min(1, 0.5 + reinforcementCount * 0.1);

  return clamp(
    baseAccessibility * recencyFactor * connectionFactor * reinforcementFactor,
    0,
    1,
  );
}

/**
 * EQUATION: Knowledge Graph Density
 * D = 2E / (N × (N-1))
 *
 * How interconnected the graph is
 */
export function calculateGraphDensity(
  nodeCount: number,
  edgeCount: number,
): number {
  if (nodeCount < 2) return 0;
  const maxEdges = (nodeCount * (nodeCount - 1)) / 2;
  return edgeCount / maxEdges;
}

/**
 * EQUATION: Cluster Coherence
 * C = Σ(edge_strength) / cluster_size
 *
 * How coherent a knowledge cluster is
 */
export function calculateClusterCoherence(
  internalEdgeStrengths: number[],
  clusterSize: number,
): number {
  if (clusterSize < 2) return 1;
  const totalStrength = internalEdgeStrengths.reduce((sum, s) => sum + s, 0);
  return totalStrength / ((clusterSize * (clusterSize - 1)) / 2);
}

/**
 * EQUATION: Knowledge Spread Activation
 * A(t+1) = A(t) × decay + Σ(neighbor_activation × edge_strength)
 *
 * How activation spreads through knowledge graph
 */
export function spreadActivation(
  currentActivation: number,
  neighborActivations: number[],
  edgeStrengths: number[],
  decay = 0.8,
  spreadRate = 0.3,
): number {
  let incoming = 0;
  for (let i = 0; i < neighborActivations.length; i++) {
    incoming +=
      (neighborActivations[i] ?? 0) * (edgeStrengths[i] ?? 0) * spreadRate;
  }
  return clamp(currentActivation * decay + incoming, 0, 1);
}

/**
 * EQUATION: Knowledge Depth
 * D = log(1 + hours) × quality × connections
 *
 * How deep understanding is
 */
export function calculateKnowledgeDepth(
  hoursStudied: number,
  qualityFactor: number,
  connectionCount: number,
): number {
  const timeFactor = Math.log(1 + hoursStudied) / Math.log(1000); // Normalize to ~1 at 1000 hours
  const connectionFactor = Math.min(1, 0.5 + connectionCount * 0.05);
  return clamp(timeFactor * qualityFactor * connectionFactor, 0, 1);
}

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// SECTION 6: COMPOUND GROWTH EQUATIONS — FORMULAS FEEDING INTO FORMULAS
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

/**
 * COMPOUND EQUATION: Total Knowledge Value
 * V = Σ(knowledge_strength × accessibility × application_count × recency)
 *
 * Total value of all knowledge
 */
export function calculateTotalKnowledgeValue(
  knowledgeNodes: KnowledgeNode[],
): number {
  const now = Date.now();

  return knowledgeNodes.reduce((total, node) => {
    const recency = Math.exp(
      -(now - node.lastAccessDate) / (30 * 24 * 60 * 60 * 1000),
    ); // 30-day decay
    const applicationFactor = Math.min(1, 0.5 + node.applications.length * 0.1);
    const value =
      node.strength * node.accessibility * applicationFactor * recency;
    return total + value;
  }, 0);
}

/**
 * COMPOUND EQUATION: Learning Velocity
 * V = (knowledge_gained / time) × efficiency × streak × consistency
 *
 * Rate of learning
 */
export function calculateLearningVelocity(
  knowledgeGained: number,
  timeInvested: number,
  efficiency: number,
  streakMultiplier: number,
  consistencyScore: number,
): number {
  if (timeInvested === 0) return 0;
  const baseVelocity = knowledgeGained / timeInvested;
  return baseVelocity * efficiency * streakMultiplier * consistencyScore;
}

/**
 * COMPOUND EQUATION: Growth Momentum
 * M = velocity × trend × resources × motivation
 *
 * Current growth momentum
 */
export function calculateGrowthMomentum(
  learningVelocity: number,
  trendDirection: number,
  resourceAvailability: number,
  motivationLevel: number,
): number {
  const trendFactor = 1 + trendDirection * 0.3; // -0.3 to +0.3 adjustment
  return (
    learningVelocity * trendFactor * resourceAvailability * motivationLevel
  );
}

/**
 * COMPOUND EQUATION: Skill Synergy
 * S = Π(1 + skill_level × weight) for related skills
 *
 * How skills amplify each other
 */
export function calculateSkillSynergy(
  skillLevels: { level: number; weight: number }[],
): number {
  if (skillLevels.length === 0) return 1;

  return skillLevels.reduce((product, skill) => {
    return product * (1 + skill.level * skill.weight * 0.01);
  }, 1);
}

/**
 * COMPOUND EQUATION: Knowledge Transfer Efficiency
 * E = similarity × prerequisite_strength × cognitive_load_capacity
 *
 * How efficiently knowledge transfers to new domain
 */
export function calculateKnowledgeTransfer(
  similarityScore: number,
  prerequisiteStrength: number,
  cognitiveLoadCapacity: number,
): number {
  return clamp(
    similarityScore * prerequisiteStrength * cognitiveLoadCapacity,
    0,
    1,
  );
}

/**
 * COMPOUND EQUATION: Mastery Progress
 * P = time_invested × quality × consistency × feedback_integration × deliberate_practice
 *
 * Progress toward mastery
 */
export function calculateMasteryProgress(
  timeInvestedHours: number,
  qualityScore: number,
  consistencyScore: number,
  feedbackIntegration: number,
  deliberatePracticeFactor: number,
  targetHours = 10000, // 10,000 hour rule
): number {
  const timeFactor = timeInvestedHours / targetHours;
  const qualityMultiplier = 0.5 + qualityScore * 0.5;
  const consistencyMultiplier = 0.5 + consistencyScore * 0.5;

  return clamp(
    timeFactor *
      qualityMultiplier *
      consistencyMultiplier *
      feedbackIntegration *
      deliberatePracticeFactor,
    0,
    1,
  );
}

/**
 * COMPOUND EQUATION: Learning ROI
 * ROI = (value_gained - cost) / cost
 *
 * Return on learning investment
 */
export function calculateLearningROI(
  knowledgeValueGained: number,
  skillValueGained: number,
  timeInvestedHours: number,
  monetaryCost: number,
  hourlyRate = 50,
): number {
  const totalValue = knowledgeValueGained + skillValueGained;
  const totalCost = timeInvestedHours * hourlyRate + monetaryCost;

  if (totalCost === 0) return 0;
  return (totalValue - totalCost) / totalCost;
}

/**
 * COMPOUND EQUATION: Optimal Learning Path
 * Score = impact × feasibility × prerequisite_match × time_efficiency
 *
 * Score for prioritizing what to learn next
 */
export function calculateLearningPathScore(
  impactOnGoals: number,
  feasibility: number,
  prerequisiteMatch: number,
  timeEfficiency: number,
  urgency = 0.5,
): number {
  const baseScore =
    impactOnGoals * feasibility * prerequisiteMatch * timeEfficiency;
  const urgencyBoost = 1 + urgency * 0.3;
  return baseScore * urgencyBoost;
}

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// SECTION 7: META GROWTH EQUATIONS — EMERGENT GROWTH BEHAVIORS
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

/**
 * META EQUATION: Growth Potential
 * P = ceiling × (1 - current_level) × (aptitude × effort × resources × time)
 *
 * How much growth is still possible
 */
export function calculateGrowthPotential(
  currentLevel: number,
  ceilingLevel,
  aptitude: number,
  effort: number,
  resources: number,
  timeAvailable: number,
): number {
  const headroom = ceilingLevel - currentLevel;
  const growthCapacity = aptitude * effort * resources * timeAvailable;
  return clamp(headroom * growthCapacity, 0, 1);
}

/**
 * META EQUATION: Expertise Index
 * EI = depth × breadth × application × recognition × teaching
 *
 * Overall expertise level
 */
export function calculateExpertiseIndex(
  knowledgeDepth: number,
  knowledgeBreadth: number,
  applicationSuccess: number,
  peerRecognition: number,
  teachingAbility: number,
): number {
  return clamp(
    knowledgeDepth * 0.25 +
      knowledgeBreadth * 0.15 +
      applicationSuccess * 0.3 +
      peerRecognition * 0.15 +
      teachingAbility * 0.15,
    0,
    1,
  );
}

/**
 * META EQUATION: Knowledge Compounding Factor
 * CF = base × (1 + network_effect) × (1 + application_rate) × (1 + teaching_rate)
 *
 * How fast knowledge compounds
 */
export function calculateCompoundingFactor(
  baseRate: number,
  networkEffect: number,
  applicationRate: number,
  teachingRate: number,
): number {
  return (
    baseRate * (1 + networkEffect) * (1 + applicationRate) * (1 + teachingRate)
  );
}

/**
 * META EQUATION: Intellectual Capital
 * IC = knowledge_value + skill_value + experience_value + network_value
 *
 * Total intellectual capital
 */
export function calculateIntellectualCapital(
  knowledgeValue: number,
  skillValue: number,
  experienceValue: number,
  networkValue: number,
  weights: number[] = [0.3, 0.3, 0.25, 0.15],
): number {
  const [w1, w2, w3, w4] = weights;
  return (
    w1! * knowledgeValue +
    w2! * skillValue +
    w3! * experienceValue +
    w4! * networkValue
  );
}

/**
 * META EQUATION: Learning Efficiency Score
 * LES = retention × transfer × application × speed × depth
 *
 * How efficiently learning occurs
 */
export function calculateLearningEfficiencyScore(
  retentionRate: number,
  transferRate: number,
  applicationRate: number,
  learningSpeed: number,
  learningDepth: number,
): number {
  return clamp(
    retentionRate *
      transferRate *
      applicationRate *
      learningSpeed *
      learningDepth,
    0,
    1,
  );
}

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// SECTION 8: STATE MANAGEMENT — TRACKING GROWTH OVER TIME
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

/**
 * Initialize a knowledge node
 */
export function initKnowledgeNode(
  id: string,
  title: string,
  description: string,
  category: KnowledgeCategory,
  content = "",
): KnowledgeNode {
  const now = Date.now();
  return {
    id,
    title,
    description,
    category,
    content,
    tags: [],
    strength: 0.1,
    accessibility: 0.5,
    connections: [],
    sources: [],
    applications: [],
    acquisitionDate: now,
    lastAccessDate: now,
    accessCount: 1,
    reinforcementCount: 0,
    decayRate: 0.01,
    compound: initCompoundState(0.1),
  };
}

/**
 * Initialize a skill node
 */
export function initSkillNode(
  id: string,
  name: string,
  description: string,
  category: SkillCategory,
): SkillNode {
  return {
    id,
    name,
    description,
    category,
    level: 0,
    experience: 0,
    proficiency: 0,
    potential: 1,
    learningRate: BASE_LEARNING_RATE,
    decayRate: 0.005,
    prerequisites: [],
    dependents: [],
    subskills: [],
    practiceHistory: [],
    assessments: [],
    compound: initCompoundState(0),
  };
}

/**
 * Initialize experience state
 */
export function initExperienceState(): ExperienceState {
  return {
    totalXP: 0,
    level: 1,
    currentLevelXP: 0,
    nextLevelXP: LEVEL_XP_BASE,
    xpToNextLevel: LEVEL_XP_BASE,
    levelProgress: 0,
    xpHistory: [],
    achievements: [],
    milestones: [],
    multipliers: [
      { id: "base", name: "Base", value: 1, source: "system", expiresAt: null },
    ],
    compound: initCompoundState(0),
  };
}

/**
 * Initialize streak state
 */
export function initStreakState(): StreakState {
  return {
    currentStreak: 0,
    longestStreak: 0,
    totalDays: 0,
    lastActivityDate: 0,
    currentMultiplier: 1,
    streakHistory: [],
    freezesAvailable: 3,
    freezesUsed: 0,
    compound: initCompoundState(0),
  };
}

/**
 * Initialize knowledge graph state
 */
export function initKnowledgeGraphState(): KnowledgeGraphState {
  return {
    nodes: new Map(),
    skills: new Map(),
    edges: [],
    clusters: [],
    totalKnowledge: 0,
    totalSkills: 0,
    graphDensity: 0,
    averageConnections: 0,
    strongestConnections: [],
    weakestAreas: [],
    compound: initCompoundState(0),
  };
}

/**
 * Initialize full growth state
 */
export function initGrowthState(entityId: string): GrowthState {
  const now = Date.now();
  return {
    entityId,
    experience: initExperienceState(),
    streak: initStreakState(),
    knowledgeGraph: initKnowledgeGraphState(),
    learningGoals: new Map(),
    dailyProgress: {
      date: now,
      xpEarned: 0,
      knowledgeGained: 0,
      skillsImproved: [],
      tasksCompleted: 0,
      timeInvested: 0,
      streak: 0,
      compound: initCompoundState(0),
    },
    weeklyProgress: {
      weekStart: now,
      xpEarned: 0,
      knowledgeGained: 0,
      skillsImproved: [],
      goalsProgress: [],
      averageDailyXP: 0,
      trend: 0,
      compound: initCompoundState(0),
    },
    monthlyProgress: {
      monthStart: now,
      xpEarned: 0,
      levelGained: 0,
      knowledgeGained: 0,
      skillsMastered: [],
      goalsCompleted: [],
      growthRate: 0,
      compound: initCompoundState(0),
    },
    growthMetrics: {
      overallGrowthRate: 0,
      knowledgeGrowthRate: 0,
      skillGrowthRate: 0,
      learningEfficiency: 0.5,
      retentionRate: 0.7,
      applicationRate: 0.3,
      innovationRate: 0.1,
      teachingRate: 0.1,
      collaborationRate: 0.3,
      consistencyScore: 0.5,
    },
    compound: initCompoundState(0),
  };
}

/**
 * Add XP to growth state
 */
export function addXP(
  state: GrowthState,
  baseXP: number,
  source: string,
  category: string,
): GrowthState {
  const now = Date.now();

  // Calculate multipliers
  const allMultipliers = state.experience.multipliers
    .filter((m) => m.expiresAt === null || m.expiresAt > now)
    .map((m) => m.value);
  allMultipliers.push(state.streak.currentMultiplier);

  const finalXP = calculateFinalXP(baseXP, allMultipliers);
  const newTotalXP = state.experience.totalXP + finalXP;

  // Calculate new level
  const { level, currentLevelXP, xpToNextLevel } =
    calculateLevelFromXP(newTotalXP);
  const nextLevelXP = calculateXPForLevel(level);
  const levelProgress = calculateLevelProgress(currentLevelXP, nextLevelXP);

  // Create XP event
  const xpEvent: XPEvent = {
    id: `xp-${now}`,
    amount: finalXP,
    source,
    category,
    timestamp: now,
    multiplier: allMultipliers.reduce((a, b) => a * b, 1),
  };

  return {
    ...state,
    experience: {
      ...state.experience,
      totalXP: newTotalXP,
      level,
      currentLevelXP,
      nextLevelXP,
      xpToNextLevel,
      levelProgress,
      xpHistory: [...state.experience.xpHistory.slice(-99), xpEvent],
      compound: updateCompoundState(state.experience.compound, newTotalXP, now),
    },
    dailyProgress: {
      ...state.dailyProgress,
      xpEarned: state.dailyProgress.xpEarned + finalXP,
      compound: updateCompoundState(
        state.dailyProgress.compound,
        state.dailyProgress.xpEarned + finalXP,
        now,
      ),
    },
    compound: updateCompoundState(state.compound, newTotalXP / 10000, now),
  };
}

/**
 * Update streak
 */
export function updateStreak(
  state: GrowthState,
  hadActivity: boolean,
): GrowthState {
  const now = Date.now();
  const dayInMs = 24 * 60 * 60 * 1000;
  const daysSinceLastActivity = (now - state.streak.lastActivityDate) / dayInMs;

  let newStreak = state.streak.currentStreak;
  let newHistory = [...state.streak.streakHistory];

  if (hadActivity) {
    if (daysSinceLastActivity < 2) {
      // Continue streak
      newStreak = state.streak.currentStreak + 1;
    } else if (daysSinceLastActivity < 3 && state.streak.freezesAvailable > 0) {
      // Use freeze
      newStreak = state.streak.currentStreak + 1;
    } else {
      // Start new streak
      if (state.streak.currentStreak > 0) {
        newHistory.push({
          startDate:
            state.streak.lastActivityDate -
            state.streak.currentStreak * dayInMs,
          endDate: state.streak.lastActivityDate,
          length: state.streak.currentStreak,
          reason: "broken",
        });
      }
      newStreak = 1;
    }
  }

  const newMultiplier = calculateStreakMultiplier(newStreak);
  const newLongest = Math.max(state.streak.longestStreak, newStreak);

  return {
    ...state,
    streak: {
      ...state.streak,
      currentStreak: newStreak,
      longestStreak: newLongest,
      totalDays: state.streak.totalDays + (hadActivity ? 1 : 0),
      lastActivityDate: hadActivity ? now : state.streak.lastActivityDate,
      currentMultiplier: newMultiplier,
      streakHistory: newHistory,
      compound: updateCompoundState(state.streak.compound, newStreak, now),
    },
  };
}

/**
 * Execute growth tick - daily compound
 */
export function executeGrowthTick(state: GrowthState): GrowthState {
  const now = Date.now();

  // Compound all knowledge
  const updatedNodes = new Map<string, KnowledgeNode>();
  for (const [id, node] of state.knowledgeGraph.nodes) {
    const decayedStrength = calculateSkillDecay(
      node.strength,
      1,
      node.decayRate,
    );
    const compoundedStrength = calculateCompoundLearning(
      decayedStrength,
      0,
      DAILY_COMPOUND_RATE,
      state.streak.currentMultiplier - 1,
    );

    updatedNodes.set(id, {
      ...node,
      strength: clamp(compoundedStrength, 0, 1),
      compound: updateCompoundState(node.compound, compoundedStrength, now),
    });
  }

  // Compound all skills
  const updatedSkills = new Map<string, SkillNode>();
  for (const [id, skill] of state.knowledgeGraph.skills) {
    const decayedProficiency = calculateSkillDecay(
      skill.proficiency,
      1,
      skill.decayRate,
    );

    updatedSkills.set(id, {
      ...skill,
      proficiency: decayedProficiency,
      compound: updateCompoundState(skill.compound, skill.proficiency, now),
    });
  }

  // Calculate graph metrics
  const totalKnowledge = calculateTotalKnowledgeValue(
    Array.from(updatedNodes.values()),
  );
  const graphDensity = calculateGraphDensity(
    updatedNodes.size + updatedSkills.size,
    state.knowledgeGraph.edges.length,
  );

  // Calculate growth metrics
  const learningVelocity = calculateLearningVelocity(
    state.dailyProgress.knowledgeGained,
    state.dailyProgress.timeInvested || 1,
    state.growthMetrics.learningEfficiency,
    state.streak.currentMultiplier,
    state.growthMetrics.consistencyScore,
  );

  return {
    ...state,
    knowledgeGraph: {
      ...state.knowledgeGraph,
      nodes: updatedNodes,
      skills: updatedSkills,
      totalKnowledge,
      graphDensity,
      totalSkills: updatedSkills.size,
      compound: updateCompoundState(
        state.knowledgeGraph.compound,
        totalKnowledge,
        now,
      ),
    },
    growthMetrics: {
      ...state.growthMetrics,
      overallGrowthRate: learningVelocity,
    },
    compound: updateCompoundState(state.compound, totalKnowledge, now),
  };
}

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// SECTION 9: EXPORTS
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

// All exports are inline above. Summary:
//
// CONSTANTS:
// - Learning rates (BASE, ACCELERATED, DEEP)
// - Knowledge decay half-lives
// - Compound growth rates (DAILY, WEEKLY, MONTHLY, ANNUAL)
// - Streak multipliers
// - Learning curve parameters
// - XP constants
// - Level thresholds
// - Knowledge and skill categories
//
// TYPES:
// - KnowledgeNode, SkillNode, LearningGoal
// - ExperienceState, StreakState, KnowledgeGraphState
// - GrowthState, DailyProgress, WeeklyProgress, MonthlyProgress
// - GrowthMetrics and all sub-types
//
// LEARNING CURVE EQUATIONS:
// - calculateSCurveLearning, calculatePowerLawPractice
// - calculateDiminishingReturns, calculateForgettingCurve
// - calculateSpacedRepetitionInterval, calculateAdaptiveLearningRate
// - calculateSkillDecay, calculateCompoundLearning
//
// EXPERIENCE EQUATIONS:
// - calculateXPForLevel, calculateTotalXPForLevel, calculateLevelFromXP
// - calculateStreakMultiplier, calculateFinalXP, calculateLevelProgress
//
// KNOWLEDGE GRAPH EQUATIONS:
// - calculateConnectionStrength, calculateAccessibility
// - calculateGraphDensity, calculateClusterCoherence
// - spreadActivation, calculateKnowledgeDepth
//
// COMPOUND EQUATIONS:
// - calculateTotalKnowledgeValue, calculateLearningVelocity
// - calculateGrowthMomentum, calculateSkillSynergy
// - calculateKnowledgeTransfer, calculateMasteryProgress
// - calculateLearningROI, calculateLearningPathScore
//
// META EQUATIONS:
// - calculateGrowthPotential, calculateExpertiseIndex
// - calculateCompoundingFactor, calculateIntellectualCapital
// - calculateLearningEfficiencyScore
//
// STATE MANAGEMENT:
// - initKnowledgeNode, initSkillNode, initExperienceState
// - initStreakState, initKnowledgeGraphState, initGrowthState
// - addXP, updateStreak, executeGrowthTick
