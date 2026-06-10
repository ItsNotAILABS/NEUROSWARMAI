// ═══════════════════════════════════════════════════════════════════════════════
// HISTORY ENGINE — World History, Narrative Arcs, Legends & Chronicles
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com
// ═══════════════════════════════════════════════════════════════════════════════

// ─── Event Category Types ────────────────────────────────────────────────────

export type EventCategory =
  | "territorial"
  | "diplomatic"
  | "economic"
  | "anomaly"
  | "organism"
  | "cataclysm";

export type EventSeverity =
  | "minor"
  | "moderate"
  | "major"
  | "catastrophic"
  | "epoch";

export type EraPhase =
  | "dawn"
  | "rise"
  | "peak"
  | "decline"
  | "collapse"
  | "rebirth";

export type NarrativeTone =
  | "heroic"
  | "tragic"
  | "mysterious"
  | "triumphant"
  | "ominous"
  | "neutral";

export type ProphecyStatus =
  | "unfulfilled"
  | "partially_fulfilled"
  | "fulfilled"
  | "broken"
  | "inverted";

// ─── Core Event Types ────────────────────────────────────────────────────────

export interface HistoricalEvent {
  id: string;
  tick: number;
  category: EventCategory;
  severity: EventSeverity;
  title: string;
  description: string;
  involvedFactions: number[];
  involvedOrganisms: string[];
  location?: { x: number; y: number };
  deltaValues: Record<string, number>;
  tags: string[];
  cascadeIds: string[]; // ids of events triggered by this one
  isLandmark: boolean;
  narrativeWeight: number;
}

export interface WorldEra {
  index: number;
  name: string;
  phase: EraPhase;
  startTick: number;
  endTick: number | null;
  dominantFaction: number | null;
  definingEvent: string | null; // event id
  tone: NarrativeTone;
  stabilityScore: number; // 0-1
  prosperityScore: number; // 0-1
  conflictCount: number;
  diplomaticCount: number;
  cataclysmCount: number;
  summary: string;
}

export interface BattleScar {
  id: string;
  eventId: string;
  location: { x: number; y: number };
  radius: number;
  intensity: number; // 0-1: how severe the permanent mark on terrain/culture
  type: "razed" | "cursed" | "hallowed" | "contested" | "forgotten";
  healsAtTick: number | null;
  factionCauser: number | null;
  lore: string;
}

export interface NarrativeArc {
  id: string;
  title: string;
  tone: NarrativeTone;
  openingEventId: string;
  closingEventId: string | null;
  involvedFactions: number[];
  chapters: NarrativeChapter[];
  isResolved: boolean;
  tensionLevel: number; // 0-1
  prominence: number; // 0-1: how central to world history
}

export interface NarrativeChapter {
  index: number;
  title: string;
  eventIds: string[];
  summary: string;
  tensionDelta: number;
}

export interface Legend {
  id: string;
  subjectType: "faction" | "organism" | "place" | "artifact";
  subjectId: string;
  name: string;
  epithet: string;
  deeds: string[];
  firstMentionTick: number;
  lastMentionTick: number;
  renown: number; // cumulative score
  isMythologized: boolean; // true if subject no longer active
  loreText: string;
}

export interface ProphecyEntry {
  id: string;
  text: string;
  issuedAtTick: number;
  status: ProphecyStatus;
  triggerConditions: ProphecyCondition[];
  fulfillmentTick: number | null;
  fulfilledEventId: string | null;
  weight: number; // how much world history bent toward this
}

export interface ProphecyCondition {
  type:
    | "era_advance"
    | "faction_eliminated"
    | "cataclysm"
    | "economic_collapse"
    | "anomaly_surge";
  threshold: number;
  met: boolean;
}

export interface ChronicleEntry {
  tick: number;
  eraIndex: number;
  headline: string;
  body: string;
  relatedEventIds: string[];
  tone: NarrativeTone;
  isEraMarker: boolean;
}

export interface WorldTimeline {
  eras: WorldEra[];
  events: HistoricalEvent[];
  chronicles: ChronicleEntry[];
  legends: Legend[];
  prophecies: ProphecyEntry[];
  scars: BattleScar[];
  arcs: NarrativeArc[];
  currentEraIndex: number;
  totalTicks: number;
  worldAge: number; // in-world years derived from ticks
}

// ─── Constants ───────────────────────────────────────────────────────────────

export const ERA_NAMES: string[] = [
  "The First Silence",
  "Age of Kindling",
  "The Fractured Dawn",
  "Era of Iron Pacts",
  "The Bleeding Fields",
  "Age of Hollow Crowns",
  "The Great Divergence",
  "Era of Whispering Machines",
  "The Second Silence",
  "Age of Unmade Things",
  "The Rebirth Tide",
  "Era of Final Forms",
];

export const LEGEND_THRESHOLDS = {
  local: 100,
  regional: 400,
  worldly: 1200,
  mythic: 4000,
  immortal: 12000,
} as const;

export const NARRATIVE_WEIGHTS: Record<EventCategory, number> = {
  territorial: 1.2,
  diplomatic: 0.9,
  economic: 0.7,
  anomaly: 1.8,
  organism: 1.0,
  cataclysm: 3.0,
};

export const SEVERITY_SCORE: Record<EventSeverity, number> = {
  minor: 1,
  moderate: 3,
  major: 8,
  catastrophic: 20,
  epoch: 60,
};

export const TONE_COLORS: Record<NarrativeTone, string> = {
  heroic: "#f0b429",
  tragic: "#a0522d",
  mysterious: "#6a0dad",
  triumphant: "#228b22",
  ominous: "#8b0000",
  neutral: "#708090",
};

const ERA_PHASE_ORDER: EraPhase[] = [
  "dawn",
  "rise",
  "peak",
  "decline",
  "collapse",
  "rebirth",
];

const CATACLYSM_TITLES = [
  "The Sundering",
  "Night of Ash",
  "The Hollow Storm",
  "Tide of Entropy",
  "The Great Unraveling",
  "Hour of Silence",
  "The Fracture Point",
  "Cascade of Ruin",
];

const DIPLOMATIC_TITLES = [
  "The Accord of Dust",
  "Pact of Iron Hands",
  "The Silent Treaty",
  "Bond of Fractured Crowns",
  "The Hollow Covenant",
  "Agreement at Ashen Field",
];

const TERRITORIAL_TITLES = [
  "Fall of the Northern Hold",
  "Conquest of the Pale Reach",
  "Siege of Ember Gate",
  "Annexation of the Deep Fen",
  "March on the Shattered Coast",
  "Reclamation of the Forgotten Spire",
];

// ─── Utility Functions ────────────────────────────────────────────────────────

let _eventCounter = 0;
let _legendCounter = 0;
let _chronicleCounter = 0;

function uid(prefix: string): string {
  return `${prefix}_${Date.now().toString(36)}_${(++_eventCounter).toString(36)}`;
}

export function computeWorldAge(ticks: number, ticksPerYear = 12): number {
  return Math.floor(ticks / ticksPerYear);
}

export function formatEventTimestamp(tick: number, ticksPerYear = 12): string {
  const year = Math.floor(tick / ticksPerYear);
  const season = tick % ticksPerYear;
  const seasonName =
    season < 3
      ? "Spring"
      : season < 6
        ? "Summer"
        : season < 9
          ? "Autumn"
          : "Winter";
  return `Year ${year}, ${seasonName} (Tick ${tick})`;
}

export function getEraColor(phase: EraPhase): string {
  const colors: Record<EraPhase, string> = {
    dawn: "#ffe066",
    rise: "#82e0aa",
    peak: "#5dade2",
    decline: "#e59866",
    collapse: "#cd6155",
    rebirth: "#a569bd",
  };
  return colors[phase];
}

export function getTopLegends(legends: Legend[], limit = 5): Legend[] {
  return [...legends].sort((a, b) => b.renown - a.renown).slice(0, limit);
}

function pickRandom<T>(arr: T[]): T {
  return arr[Math.floor(Math.random() * arr.length)];
}

function clamp(v: number, lo: number, hi: number): number {
  return Math.max(lo, Math.min(hi, v));
}

// ─── Event Recording ──────────────────────────────────────────────────────────

export function recordEvent(
  timeline: WorldTimeline,
  params: Omit<HistoricalEvent, "id" | "narrativeWeight" | "cascadeIds">,
): HistoricalEvent {
  const narrativeWeight =
    NARRATIVE_WEIGHTS[params.category] * SEVERITY_SCORE[params.severity];

  const event: HistoricalEvent = {
    ...params,
    id: uid("evt"),
    narrativeWeight,
    cascadeIds: [],
  };

  timeline.events.push(event);
  timeline.totalTicks = Math.max(timeline.totalTicks, params.tick);
  timeline.worldAge = computeWorldAge(timeline.totalTicks);

  // update current era stats
  const era = timeline.eras[timeline.currentEraIndex];
  if (era) {
    if (params.category === "cataclysm") era.cataclysmCount++;
    if (params.category === "diplomatic") era.diplomaticCount++;
    if (params.category === "territorial") era.conflictCount++;
    era.stabilityScore = clamp(
      era.stabilityScore - narrativeWeight * 0.003,
      0,
      1,
    );
    era.prosperityScore = clamp(
      era.prosperityScore + (params.category === "economic" ? 0.005 : -0.001),
      0,
      1,
    );
  }

  // auto-generate a battle scar for catastrophic/epoch territorial or cataclysm events
  if (
    (params.severity === "catastrophic" || params.severity === "epoch") &&
    (params.category === "territorial" || params.category === "cataclysm") &&
    params.location
  ) {
    const scar = generateBattleScar(event);
    timeline.scars.push(scar);
  }

  // update legend renown for involved organisms / factions
  updateLegendRenown(timeline, event);

  return event;
}

function generateBattleScar(event: HistoricalEvent): BattleScar {
  const typeOptions: BattleScar["type"][] = [
    "razed",
    "cursed",
    "hallowed",
    "contested",
    "forgotten",
  ];
  const loreLines = [
    `The land remembers ${event.title}. Even now the soil refuses new growth.`,
    `Pilgrims avoid this scar, claiming they hear the echoes of ${event.title}.`,
    `Cartographers mark this place with a skull — remnant of ${event.title}.`,
    `Legends say a fragment of the event's power remains sealed beneath the earth here.`,
    `The wound left by ${event.title} seeps entropy into the surrounding region.`,
  ];

  return {
    id: uid("scar"),
    eventId: event.id,
    location: event.location ?? { x: 0, y: 0 },
    radius: SEVERITY_SCORE[event.severity] * 2 + Math.random() * 4,
    intensity: Math.random() * 0.4 + 0.5,
    type: pickRandom(typeOptions),
    healsAtTick:
      event.severity === "epoch"
        ? null
        : event.tick + Math.floor(Math.random() * 300 + 100),
    factionCauser: event.involvedFactions[0] ?? null,
    lore: pickRandom(loreLines),
  };
}

function updateLegendRenown(
  timeline: WorldTimeline,
  event: HistoricalEvent,
): void {
  const gain = event.narrativeWeight * SEVERITY_SCORE[event.severity] * 0.5;

  for (const orgId of event.involvedOrganisms) {
    let legend = timeline.legends.find(
      (l) => l.subjectId === orgId && l.subjectType === "organism",
    );
    if (!legend) {
      legend = createLegend(
        "organism",
        orgId,
        `Unknown Entity #${_legendCounter++}`,
        event.tick,
      );
      timeline.legends.push(legend);
    }
    legend.renown += gain;
    legend.lastMentionTick = event.tick;
    legend.deeds.push(`${event.title} (Tick ${event.tick})`);
    if (legend.renown >= LEGEND_THRESHOLDS.mythic) legend.isMythologized = true;
  }

  for (const fId of event.involvedFactions) {
    const fIdStr = String(fId);
    let legend = timeline.legends.find(
      (l) => l.subjectId === fIdStr && l.subjectType === "faction",
    );
    if (!legend) {
      legend = createLegend("faction", fIdStr, `Faction #${fId}`, event.tick);
      timeline.legends.push(legend);
    }
    legend.renown += gain * 0.7;
    legend.lastMentionTick = event.tick;
    legend.deeds.push(`${event.title} (Tick ${event.tick})`);
  }
}

function createLegend(
  type: Legend["subjectType"],
  subjectId: string,
  name: string,
  tick: number,
): Legend {
  const epithets = [
    "the Undying",
    "of Ash and Iron",
    "the Forgotten",
    "the Relentless",
    "Bringer of Tides",
    "the Silent",
    "who Broke the Sky",
    "the Wanderer",
  ];
  return {
    id: uid("leg"),
    subjectType: type,
    subjectId,
    name,
    epithet: pickRandom(epithets),
    deeds: [],
    firstMentionTick: tick,
    lastMentionTick: tick,
    renown: 0,
    isMythologized: false,
    loreText: "",
  };
}

// ─── Era Management ───────────────────────────────────────────────────────────

export function advanceEra(
  timeline: WorldTimeline,
  atTick: number,
  forceName?: string,
): WorldEra {
  // close current era
  const current = timeline.eras[timeline.currentEraIndex];
  if (current) {
    current.endTick = atTick;
    current.summary = summarizeEra(current, timeline.events);
  }

  const nextIndex = timeline.currentEraIndex + 1;
  const phaseCycle = ERA_PHASE_ORDER[nextIndex % ERA_PHASE_ORDER.length];
  const nameIndex = nextIndex % ERA_NAMES.length;

  const newEra: WorldEra = {
    index: nextIndex,
    name: forceName ?? ERA_NAMES[nameIndex],
    phase: phaseCycle,
    startTick: atTick,
    endTick: null,
    dominantFaction: null,
    definingEvent: null,
    tone: deriveEraTone(phaseCycle),
    stabilityScore: 0.7,
    prosperityScore: 0.5,
    conflictCount: 0,
    diplomaticCount: 0,
    cataclysmCount: 0,
    summary: "",
  };

  timeline.eras.push(newEra);
  timeline.currentEraIndex = nextIndex;

  // add a chronicle era-marker entry
  const entry = buildChronicleEntry(
    atTick,
    nextIndex,
    `The ${newEra.name} Begins`,
    `A new era dawns across the world. The age known as "${newEra.name}" commences, shaped by forces ${phaseCycle === "dawn" ? "still nascent and undefined" : "born from the ruins of what came before"}.`,
    [],
    newEra.tone,
    true,
  );
  timeline.chronicles.push(entry);

  return newEra;
}

function deriveEraTone(phase: EraPhase): NarrativeTone {
  const map: Record<EraPhase, NarrativeTone> = {
    dawn: "mysterious",
    rise: "heroic",
    peak: "triumphant",
    decline: "tragic",
    collapse: "ominous",
    rebirth: "heroic",
  };
  return map[phase];
}

export function summarizeEra(
  era: WorldEra,
  allEvents: HistoricalEvent[],
): string {
  const eraEvents = allEvents.filter(
    (e) =>
      e.tick >= era.startTick && (era.endTick == null || e.tick < era.endTick),
  );
  const total = eraEvents.length;
  const catCount = eraEvents.filter((e) => e.category === "cataclysm").length;
  const dipCount = eraEvents.filter((e) => e.category === "diplomatic").length;
  const topEvent = eraEvents.sort(
    (a, b) => b.narrativeWeight - a.narrativeWeight,
  )[0];
  const duration =
    era.endTick != null ? era.endTick - era.startTick : "ongoing";
  const stabilityDesc =
    era.stabilityScore > 0.7
      ? "stable"
      : era.stabilityScore > 0.4
        ? "turbulent"
        : "chaotic";

  return `The ${era.name} spanned ${duration} ticks and recorded ${total} events. The era was largely ${stabilityDesc}, with ${catCount} cataclysm(s) and ${dipCount} diplomatic engagement(s). ${
    topEvent
      ? `Its defining moment was "${topEvent.title}", which reshaped the world's course.`
      : "No single event defined the era — it faded as quietly as it began."
  }`;
}

// ─── Legend Generation ────────────────────────────────────────────────────────

export function generateLegend(
  legend: Legend,
  allEvents: HistoricalEvent[],
): string {
  const renownTier =
    legend.renown >= LEGEND_THRESHOLDS.immortal
      ? "immortal"
      : legend.renown >= LEGEND_THRESHOLDS.mythic
        ? "mythic"
        : legend.renown >= LEGEND_THRESHOLDS.worldly
          ? "worldly"
          : legend.renown >= LEGEND_THRESHOLDS.regional
            ? "regional"
            : "local";

  const relatedEvents = allEvents
    .filter(
      (e) =>
        e.involvedOrganisms.includes(legend.subjectId) ||
        e.involvedFactions.map(String).includes(legend.subjectId),
    )
    .sort((a, b) => b.narrativeWeight - a.narrativeWeight)
    .slice(0, 3);

  const deedSentences = relatedEvents.map(
    (e) =>
      `During ${e.title}, ${legend.name} ${pickRandom([
        "carved their name into the world's memory",
        "stood at the fulcrum of fate",
        "changed the course of events irreversibly",
        "left a mark that historians still debate",
      ])}.`,
  );

  const opening =
    renownTier === "immortal" || renownTier === "mythic"
      ? `Songs speak of ${legend.name} ${legend.epithet} as if they were woven from the fabric of the world itself.`
      : renownTier === "worldly"
        ? `Across every inhabited region, the name ${legend.name} ${legend.epithet} stirs recognition.`
        : `In local circles, ${legend.name} ${legend.epithet} is remembered with reverence.`;

  const closing = legend.isMythologized
    ? "They are no longer seen among the living, yet their influence persists like a tide that never fully retreats."
    : "Their story is not yet complete — each new tick adds another line to their unfinished chronicle.";

  legend.loreText = [opening, ...deedSentences, closing].join(" ");
  return legend.loreText;
}

// ─── Chronicle Building ───────────────────────────────────────────────────────

export function buildChronicle(
  timeline: WorldTimeline,
  tick: number,
): ChronicleEntry[] {
  const windowStart = Math.max(0, tick - 50);
  const recentEvents = timeline.events.filter(
    (e) => e.tick >= windowStart && e.tick <= tick,
  );
  const entries: ChronicleEntry[] = [];

  // group events by rough clusters (every 10 ticks)
  const buckets = new Map<number, HistoricalEvent[]>();
  for (const e of recentEvents) {
    const bucket = Math.floor(e.tick / 10) * 10;
    if (!buckets.has(bucket)) buckets.set(bucket, []);
    buckets.get(bucket)!.push(e);
  }

  for (const [bucketTick, events] of buckets) {
    const sorted = events.sort((a, b) => b.narrativeWeight - a.narrativeWeight);
    const lead = sorted[0];
    if (!lead) continue;
    const era = timeline.eras.find(
      (er) =>
        er.startTick <= bucketTick &&
        (er.endTick == null || er.endTick > bucketTick),
    );

    const tone = determineTone(events);
    const body = buildChronicleBody(sorted, era?.name ?? "Unknown Era");

    const entry = buildChronicleEntry(
      bucketTick,
      era?.index ?? 0,
      lead.title,
      body,
      sorted.map((e) => e.id),
      tone,
      false,
    );
    entries.push(entry);
  }

  timeline.chronicles.push(...entries);
  return entries;
}

function buildChronicleEntry(
  tick: number,
  eraIndex: number,
  headline: string,
  body: string,
  relatedEventIds: string[],
  tone: NarrativeTone,
  isEraMarker: boolean,
): ChronicleEntry {
  return {
    tick,
    eraIndex,
    headline,
    body,
    relatedEventIds,
    tone,
    isEraMarker,
  };
}

function buildChronicleBody(
  events: HistoricalEvent[],
  eraName: string,
): string {
  const catEvents = events.filter((e) => e.category === "cataclysm");
  const dipEvents = events.filter((e) => e.category === "diplomatic");
  const terEvents = events.filter((e) => e.category === "territorial");

  const lines: string[] = [];

  if (catEvents.length > 0) {
    lines.push(
      `The ${eraName} shook as ${catEvents.length} cataclysmic force(s) swept through the known world. ` +
        `Chief among them: "${catEvents[0].title}" — ${catEvents[0].description}`,
    );
  }
  if (terEvents.length > 0) {
    lines.push(
      `Borders shifted when ${terEvents.map((e) => `"${e.title}"`).join(" and ")} rewrote the territorial map with blood and fire.`,
    );
  }
  if (dipEvents.length > 0) {
    lines.push(
      `Amid the strife, diplomats convened: ${dipEvents.map((e) => `"${e.title}"`).join(", ")} marked attempts to thread peace through a needle of suspicion.`,
    );
  }
  if (lines.length === 0 && events.length > 0) {
    lines.push(
      `Quiet forces moved beneath the surface of the ${eraName}. ` +
        `${events[0].description}`,
    );
  }

  return lines.join(" ");
}

function determineTone(events: HistoricalEvent[]): NarrativeTone {
  const hasCataclysm = events.some((e) => e.category === "cataclysm");
  const hasDip = events.some((e) => e.category === "diplomatic");
  const hasAnomaly = events.some((e) => e.category === "anomaly");
  if (hasCataclysm) return "ominous";
  if (hasAnomaly) return "mysterious";
  if (hasDip) return "neutral";
  const dominantSev = events.reduce(
    (a, b) => (b.narrativeWeight > a.narrativeWeight ? b : a),
    events[0],
  );
  if (dominantSev?.severity === "epoch") return "tragic";
  return "heroic";
}

// ─── Narrative Prediction ─────────────────────────────────────────────────────

export function predictNarrative(
  timeline: WorldTimeline,
  _horizonTicks: number,
): NarrativeArc {
  const recent = [...timeline.events]
    .sort((a, b) => b.tick - a.tick)
    .slice(0, 20);

  const catCount = recent.filter((e) => e.category === "cataclysm").length;
  const dipCount = recent.filter((e) => e.category === "diplomatic").length;
  const anomCount = recent.filter((e) => e.category === "anomaly").length;
  const openingEvent = recent[0];

  let tone: NarrativeTone = "neutral";
  let title = "The Unwritten Arc";

  if (catCount >= 3) {
    tone = "tragic";
    title = pickRandom([
      "The Coming Ruin",
      "Tide of Ash",
      "The Last Chapter",
      "When All Falls Silent",
    ]);
  } else if (anomCount >= 3) {
    tone = "mysterious";
    title = pickRandom([
      "The Veil Thins",
      "Voices from the Unseen",
      "The Fracture Between Worlds",
    ]);
  } else if (dipCount >= 4) {
    tone = "heroic";
    title = pickRandom([
      "The Grand Accord",
      "Alliance at the Edge",
      "Before the Storm Breaks",
    ]);
  } else {
    tone = "triumphant";
    title = pickRandom([
      "Rise of the New Order",
      "The Ascending Age",
      "Era of Forged Bonds",
    ]);
  }

  const tension = clamp(
    catCount * 0.15 + anomCount * 0.1 - dipCount * 0.05 + Math.random() * 0.2,
    0,
    1,
  );

  const arc: NarrativeArc = {
    id: uid("arc"),
    title,
    tone,
    openingEventId: openingEvent?.id ?? "",
    closingEventId: null,
    involvedFactions: [
      ...new Set(recent.flatMap((e) => e.involvedFactions)),
    ].slice(0, 4),
    chapters: [
      {
        index: 0,
        title: "The Catalyst",
        eventIds: recent.slice(0, 5).map((e) => e.id),
        summary: `Forces converged as the world entered a period of ${tone} tension.`,
        tensionDelta: tension * 0.4,
      },
      {
        index: 1,
        title: "The Escalation",
        eventIds: recent.slice(5, 12).map((e) => e.id),
        summary: `Patterns deepened, alliances shifted, and the trajectory toward "${title}" became undeniable.`,
        tensionDelta: tension * 0.6,
      },
    ],
    isResolved: false,
    tensionLevel: tension,
    prominence: clamp((catCount + anomCount) / 10, 0.1, 1),
  };

  timeline.arcs.push(arc);
  return arc;
}

// ─── Prophecy Engine ──────────────────────────────────────────────────────────

export function generateProphecy(
  timeline: WorldTimeline,
  tick: number,
): ProphecyEntry {
  const texts = [
    "When the third cataclysm speaks, the eldest faction shall fall silent.",
    "A wanderer without a name shall bend the tide of the coming collapse.",
    "The silence between wars holds the seed of the world's final age.",
    "What was shattered at the peak shall be reforged in the rebirth.",
    "When the anomalies outnumber the living, the veil between eras dissolves.",
    "The faction that outlasts the Hollow Storm shall inherit an empty throne.",
    "Before the last chronicle closes, one legend will walk among the myths.",
  ];

  const conditionTypes: ProphecyCondition["type"][] = [
    "era_advance",
    "faction_eliminated",
    "cataclysm",
    "economic_collapse",
    "anomaly_surge",
  ];

  const numConditions = Math.floor(Math.random() * 2) + 1;
  const conditions: ProphecyCondition[] = Array.from(
    { length: numConditions },
    () => ({
      type: pickRandom(conditionTypes),
      threshold: Math.floor(Math.random() * 5) + 1,
      met: false,
    }),
  );

  const prophecy: ProphecyEntry = {
    id: uid("proph"),
    text: pickRandom(texts),
    issuedAtTick: tick,
    status: "unfulfilled",
    triggerConditions: conditions,
    fulfillmentTick: null,
    fulfilledEventId: null,
    weight: Math.random() * 0.6 + 0.2,
  };

  timeline.prophecies.push(prophecy);
  return prophecy;
}

export function evaluateProphecies(
  timeline: WorldTimeline,
  tick: number,
): void {
  const catTotal = timeline.events.filter(
    (e) => e.category === "cataclysm",
  ).length;
  const eraCount = timeline.eras.length;
  const anomTotal = timeline.events.filter(
    (e) => e.category === "anomaly",
  ).length;

  for (const p of timeline.prophecies) {
    if (p.status === "fulfilled" || p.status === "broken") continue;

    let allMet = true;
    for (const cond of p.triggerConditions) {
      if (cond.met) continue;
      if (cond.type === "cataclysm" && catTotal >= cond.threshold)
        cond.met = true;
      if (cond.type === "era_advance" && eraCount >= cond.threshold)
        cond.met = true;
      if (cond.type === "anomaly_surge" && anomTotal >= cond.threshold)
        cond.met = true;
      if (!cond.met) allMet = false;
    }

    if (allMet) {
      p.status = "fulfilled";
      p.fulfillmentTick = tick;
    } else if (p.issuedAtTick + 500 < tick) {
      p.status = "broken";
    }
  }
}

// ─── WorldHistorian Class ─────────────────────────────────────────────────────

export class WorldHistorian {
  private timeline: WorldTimeline;
  private ticksPerEra: number;
  private eventBuffer: Omit<
    HistoricalEvent,
    "id" | "narrativeWeight" | "cascadeIds"
  >[];

  constructor(ticksPerEra = 120) {
    this.ticksPerEra = ticksPerEra;
    this.eventBuffer = [];

    const firstEra: WorldEra = {
      index: 0,
      name: ERA_NAMES[0],
      phase: "dawn",
      startTick: 0,
      endTick: null,
      dominantFaction: null,
      definingEvent: null,
      tone: "mysterious",
      stabilityScore: 0.85,
      prosperityScore: 0.5,
      conflictCount: 0,
      diplomaticCount: 0,
      cataclysmCount: 0,
      summary: "",
    };

    this.timeline = {
      eras: [firstEra],
      events: [],
      chronicles: [],
      legends: [],
      prophecies: [],
      scars: [],
      arcs: [],
      currentEraIndex: 0,
      totalTicks: 0,
      worldAge: 0,
    };

    generateProphecy(this.timeline, 0);
  }

  queueEvent(
    params: Omit<HistoricalEvent, "id" | "narrativeWeight" | "cascadeIds">,
  ): void {
    this.eventBuffer.push(params);
  }

  tick(currentTick: number): void {
    // flush buffered events
    for (const e of this.eventBuffer) {
      recordEvent(this.timeline, e);
    }
    this.eventBuffer = [];

    // auto-generate flavour events occasionally
    if (currentTick % 7 === 0) this.autoGenerateEvent(currentTick);

    // evaluate prophecies
    evaluateProphecies(this.timeline, currentTick);

    // advance era if due
    const era = this.timeline.eras[this.timeline.currentEraIndex];
    const elapsed = currentTick - era.startTick;
    if (elapsed >= this.ticksPerEra) {
      advanceEra(this.timeline, currentTick);
      generateProphecy(this.timeline, currentTick);
    }

    // periodic chronicle build
    if (currentTick % 20 === 0) {
      buildChronicle(this.timeline, currentTick);
    }

    // periodic narrative arc prediction
    if (currentTick % 50 === 0 && this.timeline.events.length >= 10) {
      predictNarrative(this.timeline, 60);
    }

    this.timeline.totalTicks = currentTick;
    this.timeline.worldAge = computeWorldAge(currentTick);
  }

  private autoGenerateEvent(tick: number): void {
    const categories: EventCategory[] = [
      "territorial",
      "diplomatic",
      "economic",
      "anomaly",
      "organism",
    ];
    const severities: EventSeverity[] = [
      "minor",
      "minor",
      "moderate",
      "moderate",
      "major",
    ];
    const cat = pickRandom(categories);
    const sev = pickRandom(severities);

    const titleMap: Record<EventCategory, string[]> = {
      territorial: TERRITORIAL_TITLES,
      diplomatic: DIPLOMATIC_TITLES,
      economic: [
        "Market Surge in the Western Reaches",
        "FORMA Vein Discovered",
        "Trade Route Severed",
      ],
      anomaly: [
        "Anomalous Resonance Detected",
        "The Hollow Pulse",
        "Reality Fold Observed",
      ],
      organism: [
        "Elder Organism Stirs",
        "Pack Migration Reported",
        "Apex Predator Sighted",
      ],
      cataclysm: CATACLYSM_TITLES,
    };

    const titles = titleMap[cat];
    const title = pickRandom(titles);

    recordEvent(this.timeline, {
      tick,
      category: cat,
      severity: sev,
      title,
      description: `An event of ${sev} significance unfolded: ${title.toLowerCase()}.`,
      involvedFactions: [],
      involvedOrganisms: [],
      deltaValues: {},
      tags: [cat, sev],
      isLandmark: sev === "epoch" || sev === "catastrophic",
    });
  }

  query<K extends keyof WorldTimeline>(key: K): WorldTimeline[K] {
    return this.timeline[key];
  }

  getTimeline(): WorldTimeline {
    return this.timeline;
  }

  getCurrentEra(): WorldEra {
    return this.timeline.eras[this.timeline.currentEraIndex];
  }

  getLegendsSorted(): Legend[] {
    return getTopLegends(this.timeline.legends, this.timeline.legends.length);
  }

  regenerateLegendLore(): void {
    for (const leg of this.timeline.legends) {
      generateLegend(leg, this.timeline.events);
    }
  }

  serialize(): string {
    return JSON.stringify(this.timeline, null, 2);
  }

  deserialize(json: string): void {
    this.timeline = JSON.parse(json) as WorldTimeline;
  }
}

export default WorldHistorian;
