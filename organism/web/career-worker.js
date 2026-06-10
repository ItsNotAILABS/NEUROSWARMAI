/**
 * Career Worker — CP-001–013: Career Protocol Execution Engine
 *
 * Manages and autonomously advances the 13 Career Protocols that guide
 * sovereign professional development. Each protocol has a defined phase
 * sequence, milestone set, and PHI-weighted progression model.
 *
 * Career Protocols:
 *   CP-001  Resonance Mapping      — Identify and map personal resonance fields
 *   CP-002  Value Alignment        — Align professional values with market opportunities
 *   CP-003  Skill Synthesis        — Synthesise and compound skill stacks
 *   CP-004  Network Activation     — Activate and grow sovereign network nodes
 *   CP-005  Brand Architecture     — Architect a defensible personal brand
 *   CP-006  Revenue Engineering    — Engineer multiple converging revenue streams
 *   CP-007  Influence Amplification — Amplify reach and thought leadership
 *   CP-008  Knowledge Crystallisation — Crystallise expertise into reusable IP
 *   CP-009  Legacy Construction    — Construct long-horizon legacy assets
 *   CP-010  Ecosystem Building     — Build a self-reinforcing professional ecosystem
 *   CP-011  Innovation Pipeline    — Maintain a pipeline of novel innovations
 *   CP-012  Leadership Emergence   — Emerge as a recognised sovereign leader
 *   CP-013  Sovereign Ascension    — Complete ascension to full sovereignty
 *
 * Proactive beats:
 *   Every 144 beats — auto-advance all active career journeys by one phase step
 *   Every 89 beats  — generate actionable insights for each active journey
 *
 * Message types (in):
 *   query:protocols  — list all 13 career protocols
 *   query:journeys   — list all active journeys
 *   query:milestones — milestones for a given journeyId
 *   call:start       — start a new career journey on a protocol
 *   call:advance     — manually advance a journey one step
 *   call:assess      — run a PHI-scored assessment on a journey
 *   call:complete    — mark a journey phase as complete
 */

const PHI = 1.618033988749895;
const PHI_INV = 1 / PHI;
const PHI_BEAT = 873; // ms

// Fibonacci constants
const F7  = 13;
const F8  = 21;
const F9  = 34;
const F10 = 55;
const F11 = 89;
const F12 = 144;
const F13 = 233;
const F14 = 377;
const F15 = 610;
const F16 = 987;
const F17 = 1597;
const F18 = 2584;

const ADVANCE_INTERVAL = F12; // 144 beats
const INSIGHT_INTERVAL = F11; // 89 beats

let beatCount = 0;
let journeyCounter = 0;
let insightCounter = 0;

/* ════════════════════════════════════════════════════════════════
   Tool Registry — 13 Career Protocols as tools
   ════════════════════════════════════════════════════════════════ */

const TOOL_REGISTRY = [
  {
    id: 'CP-001', name: 'Resonance Mapping',
    phases: ['discovery','mapping','calibration','integration'],
    description: 'Identify and map personal resonance fields',
    phiMultiplier: PHI,
  },
  {
    id: 'CP-002', name: 'Value Alignment',
    phases: ['inventory','prioritisation','alignment','anchoring'],
    description: 'Align professional values with market opportunities',
    phiMultiplier: PHI * PHI_INV,
  },
  {
    id: 'CP-003', name: 'Skill Synthesis',
    phases: ['audit','stacking','synthesis','compounding'],
    description: 'Synthesise and compound skill stacks',
    phiMultiplier: PHI,
  },
  {
    id: 'CP-004', name: 'Network Activation',
    phases: ['mapping','seeding','activation','amplification'],
    description: 'Activate and grow sovereign network nodes',
    phiMultiplier: PHI * PHI,
  },
  {
    id: 'CP-005', name: 'Brand Architecture',
    phases: ['positioning','narrative','expression','defence'],
    description: 'Architect a defensible personal brand',
    phiMultiplier: PHI_INV * PHI,
  },
  {
    id: 'CP-006', name: 'Revenue Engineering',
    phases: ['audit','design','launch','optimisation'],
    description: 'Engineer multiple converging revenue streams',
    phiMultiplier: PHI * PHI * PHI_INV,
  },
  {
    id: 'CP-007', name: 'Influence Amplification',
    phases: ['baseline','content','distribution','flywheel'],
    description: 'Amplify reach and thought leadership',
    phiMultiplier: PHI,
  },
  {
    id: 'CP-008', name: 'Knowledge Crystallisation',
    phases: ['capture','structuring','crystallisation','publication'],
    description: 'Crystallise expertise into reusable IP',
    phiMultiplier: PHI_INV,
  },
  {
    id: 'CP-009', name: 'Legacy Construction',
    phases: ['vision','foundation','construction','endowment'],
    description: 'Construct long-horizon legacy assets',
    phiMultiplier: PHI * PHI,
  },
  {
    id: 'CP-010', name: 'Ecosystem Building',
    phases: ['nucleation','growth','governance','self-sustaining'],
    description: 'Build a self-reinforcing professional ecosystem',
    phiMultiplier: PHI * PHI_INV * PHI,
  },
  {
    id: 'CP-011', name: 'Innovation Pipeline',
    phases: ['ideation','filtering','prototyping','pipeline'],
    description: 'Maintain a pipeline of novel innovations',
    phiMultiplier: PHI_INV * PHI_INV,
  },
  {
    id: 'CP-012', name: 'Leadership Emergence',
    phases: ['foundation','visibility','recognition','sovereignty'],
    description: 'Emerge as a recognised sovereign leader',
    phiMultiplier: PHI * PHI * PHI_INV,
  },
  {
    id: 'CP-013', name: 'Sovereign Ascension',
    phases: ['preparation','ascent','consolidation','sovereignty'],
    description: 'Complete ascension to full sovereignty',
    phiMultiplier: PHI * PHI * PHI,
  },
];

const protocolMap = new Map(TOOL_REGISTRY.map(p => [p.id, p]));

/* ════════════════════════════════════════════════════════════════
   State
   ════════════════════════════════════════════════════════════════ */

const activeJourneys = new Map();
const completedJourneys = [];
const insightLog = [];
const MAX_INSIGHTS = F15; // 610
const achievementLog = [];
const MAX_ACHIEVEMENTS = F13; // 233

/* ════════════════════════════════════════════════════════════════
   Journey engine
   ════════════════════════════════════════════════════════════════ */

function createJourney(protocolId, userId, context = {}) {
  const protocol = protocolMap.get(protocolId);
  if (!protocol) return null;
  const id = `JRN-${Date.now()}-${++journeyCounter}`;
  return {
    id,
    protocolId,
    protocolName: protocol.name,
    userId,
    phases: [...protocol.phases],
    currentPhaseIndex: 0,
    completedPhases: [],
    status: 'active',
    score: 0,
    phiScore: 0,
    milestones: buildMilestones(protocol),
    context,
    startedAt: Date.now(),
    lastAdvancedAt: null,
    completedAt: null,
  };
}

function buildMilestones(protocol) {
  return protocol.phases.map((phase, i) => ({
    id: `${protocol.id}-M${i + 1}`,
    phase,
    label: `Complete ${phase} phase of ${protocol.name}`,
    achieved: false,
    achievedAt: null,
    phiValue: Math.pow(PHI, i + 1),
  }));
}

function advanceJourney(journey) {
  if (journey.status !== 'active') return false;
  if (journey.currentPhaseIndex >= journey.phases.length) {
    journey.status = 'completed';
    journey.completedAt = Date.now();
    return false;
  }

  const completedPhase = journey.phases[journey.currentPhaseIndex];
  journey.completedPhases.push(completedPhase);

  // Mark milestone
  const milestone = journey.milestones[journey.currentPhaseIndex];
  if (milestone && !milestone.achieved) {
    milestone.achieved = true;
    milestone.achievedAt = Date.now();
    achievementLog.push({ journeyId: journey.id, milestoneId: milestone.id, label: milestone.label, ts: Date.now() });
    if (achievementLog.length > MAX_ACHIEVEMENTS) achievementLog.shift();
  }

  journey.currentPhaseIndex++;
  journey.lastAdvancedAt = Date.now();

  const protocol = protocolMap.get(journey.protocolId);
  const progress = journey.currentPhaseIndex / journey.phases.length;
  journey.score = Math.round(progress * 100);
  journey.phiScore = progress * (protocol ? protocol.phiMultiplier : 1) * PHI;

  if (journey.currentPhaseIndex >= journey.phases.length) {
    journey.status = 'completed';
    journey.completedAt = Date.now();
    completedJourneys.push({ ...journey });
    activeJourneys.delete(journey.id);
  }

  return true;
}

function assessJourney(journey) {
  const protocol = protocolMap.get(journey.protocolId);
  const progress = journey.currentPhaseIndex / journey.phases.length;
  const velocity = journey.lastAdvancedAt
    ? (journey.currentPhaseIndex / ((Date.now() - journey.startedAt) / (PHI_BEAT * ADVANCE_INTERVAL)))
    : 0;
  return {
    journeyId: journey.id,
    protocolId: journey.protocolId,
    progress: progress.toFixed(4),
    score: journey.score,
    phiScore: journey.phiScore.toFixed(4),
    velocity: velocity.toFixed(4),
    phiAlignment: (progress * (protocol ? protocol.phiMultiplier : 1)).toFixed(4),
    currentPhase: journey.phases[journey.currentPhaseIndex] || 'complete',
    completedPhases: journey.completedPhases,
    remaining: journey.phases.length - journey.currentPhaseIndex,
    ts: Date.now(),
  };
}

/* ════════════════════════════════════════════════════════════════
   Proactive insight generation
   ════════════════════════════════════════════════════════════════ */

function generateInsights() {
  const insights = [];
  for (const journey of activeJourneys.values()) {
    const assessment = assessJourney(journey);
    const protocol = protocolMap.get(journey.protocolId);
    const insight = {
      id: `INS-${++insightCounter}`,
      journeyId: journey.id,
      protocolId: journey.protocolId,
      protocolName: protocol ? protocol.name : journey.protocolId,
      currentPhase: assessment.currentPhase,
      recommendation: deriveRecommendation(assessment),
      phiScore: assessment.phiScore,
      ts: Date.now(),
    };
    insights.push(insight);
    insightLog.push(insight);
    if (insightLog.length > MAX_INSIGHTS) insightLog.shift();
  }

  if (insights.length > 0) {
    self.postMessage({
      type: 'career:insights',
      insights,
      beat: beatCount,
      ts: Date.now(),
    });
  }
}

function deriveRecommendation(assessment) {
  const progress = parseFloat(assessment.progress);
  if (progress < 0.25) return `Deepen focus on ${assessment.currentPhase} — early phase requires full resonance`;
  if (progress < 0.5)  return `Sustain momentum through ${assessment.currentPhase} — PHI compounding building`;
  if (progress < 0.75) return `Accelerate ${assessment.currentPhase} — golden ratio inflection approaching`;
  return `Final stretch — consolidate ${assessment.currentPhase} gains and prepare for next protocol`;
}

/* ════════════════════════════════════════════════════════════════
   Proactive auto-advance all active journeys
   ════════════════════════════════════════════════════════════════ */

function autoAdvanceJourneys() {
  let advanced = 0;
  for (const journey of [...activeJourneys.values()]) {
    if (advanceJourney(journey)) advanced++;
  }
  self.postMessage({
    type: 'career:auto-advanced',
    advanced,
    active: activeJourneys.size,
    completed: completedJourneys.length,
    beat: beatCount,
    ts: Date.now(),
  });
}

/* ════════════════════════════════════════════════════════════════
   Heartbeat
   ════════════════════════════════════════════════════════════════ */

setInterval(() => {
  beatCount++;

  if (beatCount % INSIGHT_INTERVAL  === 0) generateInsights();
  if (beatCount % ADVANCE_INTERVAL  === 0) autoAdvanceJourneys();

  self.postMessage({
    type: 'heartbeat',
    beat: beatCount,
    activeJourneys: activeJourneys.size,
    completedJourneys: completedJourneys.length,
    insights: insightLog.length,
    achievements: achievementLog.length,
    ts: Date.now(),
  });
}, PHI_BEAT);

/* ════════════════════════════════════════════════════════════════
   Message handler
   ════════════════════════════════════════════════════════════════ */

self.onmessage = function(e) {
  const { type, ...payload } = e.data || {};

  switch (type) {

    case 'query:protocols':
      self.postMessage({
        type: 'result:protocols',
        protocols: TOOL_REGISTRY.map(p => ({
          id: p.id, name: p.name, description: p.description,
          phases: p.phases, phiMultiplier: p.phiMultiplier,
        })),
        total: TOOL_REGISTRY.length,
        ts: Date.now(),
      });
      break;

    case 'query:journeys':
      self.postMessage({
        type: 'result:journeys',
        journeys: [...activeJourneys.values()].map(j => ({
          id: j.id, protocolId: j.protocolId, protocolName: j.protocolName,
          userId: j.userId, status: j.status, score: j.score,
          phiScore: j.phiScore, currentPhase: j.phases[j.currentPhaseIndex] || 'complete',
        })),
        active: activeJourneys.size,
        completed: completedJourneys.length,
        ts: Date.now(),
      });
      break;

    case 'query:milestones': {
      const { journeyId } = payload;
      const journey = activeJourneys.get(journeyId) || completedJourneys.find(j => j.id === journeyId);
      if (!journey) { self.postMessage({ type: 'error', error: 'unknown_journey', journeyId, ts: Date.now() }); break; }
      self.postMessage({ type: 'result:milestones', journeyId, milestones: journey.milestones, ts: Date.now() });
      break;
    }

    case 'call:start': {
      const { protocolId, userId, context } = payload;
      if (!protocolMap.has(protocolId)) {
        self.postMessage({ type: 'error', error: 'unknown_protocol', protocolId, ts: Date.now() });
        break;
      }
      const journey = createJourney(protocolId, userId, context);
      activeJourneys.set(journey.id, journey);
      self.postMessage({ type: 'result:start', journeyId: journey.id, protocolId, ts: Date.now() });
      break;
    }

    case 'call:advance': {
      const { journeyId } = payload;
      const journey = activeJourneys.get(journeyId);
      if (!journey) { self.postMessage({ type: 'error', error: 'unknown_journey', journeyId, ts: Date.now() }); break; }
      const advanced = advanceJourney(journey);
      self.postMessage({ type: 'result:advance', journeyId, advanced, score: journey.score, phiScore: journey.phiScore, ts: Date.now() });
      break;
    }

    case 'call:assess': {
      const { journeyId } = payload;
      const journey = activeJourneys.get(journeyId) || completedJourneys.find(j => j.id === journeyId);
      if (!journey) { self.postMessage({ type: 'error', error: 'unknown_journey', journeyId, ts: Date.now() }); break; }
      self.postMessage({ type: 'result:assess', ...assessJourney(journey) });
      break;
    }

    case 'call:complete': {
      const { journeyId } = payload;
      const journey = activeJourneys.get(journeyId);
      if (!journey) { self.postMessage({ type: 'error', error: 'unknown_journey', journeyId, ts: Date.now() }); break; }
      journey.status = 'completed';
      journey.completedAt = Date.now();
      completedJourneys.push({ ...journey });
      activeJourneys.delete(journeyId);
      self.postMessage({ type: 'result:complete', journeyId, score: journey.score, phiScore: journey.phiScore, ts: Date.now() });
      break;
    }

    default:
      self.postMessage({ type: 'error', error: 'unknown_type', received: type, ts: Date.now() });
  }
};
