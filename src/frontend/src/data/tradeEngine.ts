// tradeEngine.ts — Trade Network & Resource Flow Engine
// Living-world simulation platform

// ─── Types ────────────────────────────────────────────────────────────────────

export type CommodityType =
  | "raw_material"
  | "processed_good"
  | "organism_part"
  | "anomaly_extract"
  | "doctrine_scroll"
  | "signal_crystal"
  | "void_matter"
  | "forma_ingot";

export interface Commodity {
  id: string;
  name: string;
  type: CommodityType;
  baseValue: number;
  weight: number;
  volume: number;
  perishable: boolean;
  perishRateTicks: number | null;
  contraband: boolean;
  tariffCategory: string;
  tags: string[];
}

export interface TradeNode {
  id: string;
  name: string;
  regionId: string;
  position: { x: number; y: number };
  inventory: Record<string, number>;
  demand: Record<string, number>;
  supply: Record<string, number>;
  portFacility: PortFacility | null;
  embargoed: boolean;
  embargoedBy: string[];
  taxRate: number;
  factionId: string;
  throughputCapacity: number;
  currentThroughput: number;
}

export interface TradeEdge {
  id: string;
  fromNodeId: string;
  toNodeId: string;
  distance: number;
  terrainModifier: number;
  blocked: boolean;
  blockedReason: string | null;
  tariffScheduleId: string | null;
  bandits: number;
  lastTraversedTick: number | null;
  caravansInTransit: string[];
}

export interface TradeNetwork {
  id: string;
  name: string;
  nodes: Record<string, TradeNode>;
  edges: Record<string, TradeEdge>;
  caravans: Record<string, CaravanUnit>;
  agreements: Record<string, TradeAgreement>;
  tariffSchedules: Record<string, TariffSchedule>;
  contrabandAlerts: ContrabandAlert[];
  tick: number;
}

export interface CaravanUnit {
  id: string;
  name: string;
  ownerFactionId: string;
  cargo: Record<string, number>;
  capacity: number;
  currentLoad: number;
  speed: number;
  currentEdgeId: string | null;
  originNodeId: string;
  destinationNodeId: string;
  routeEdgeIds: string[];
  routeProgress: number;
  status: "idle" | "in_transit" | "blocked" | "arrived" | "seized";
  departedTick: number;
  estimatedArrivalTick: number | null;
  guards: number;
  smuggling: boolean;
}

export interface PortFacility {
  id: string;
  nodeId: string;
  level: number;
  maxThroughput: number;
  storageBonusMultiplier: number;
  inspectionCapability: number;
  customsStrictness: number;
  operatingFactionId: string;
  fees: Record<string, number>;
}

export interface TariffSchedule {
  id: string;
  name: string;
  appliedByFactionId: string;
  rates: Record<string, number>;
  exemptFactions: string[];
  exemptCommodityTypes: CommodityType[];
  validFromTick: number;
  validUntilTick: number | null;
}

export interface TradeAgreement {
  id: string;
  name: string;
  factionAId: string;
  factionBId: string;
  type: "free_trade" | "preferential" | "embargo" | "monopoly";
  commodityScope: CommodityType[] | "all";
  tariffReduction: number;
  signedTick: number;
  expiryTick: number | null;
  active: boolean;
  terms: string;
}

export interface ContrabandAlert {
  id: string;
  tick: number;
  nodeId: string;
  caravanId: string | null;
  commodityId: string;
  quantity: number;
  severity: "low" | "medium" | "high" | "critical";
  resolved: boolean;
  resolvedTick: number | null;
  factionNotified: string[];
}

export interface TradeIntelReport {
  id: string;
  generatedTick: number;
  networkId: string;
  topTradeRoutes: Array<{
    fromNodeId: string;
    toNodeId: string;
    volumePerTick: number;
  }>;
  mostTradedCommodities: Array<{ commodityId: string; totalVolume: number }>;
  networkDensity: number;
  activeCaravans: number;
  blockedEdges: number;
  contrabandIncidents: number;
  totalTariffRevenue: Record<string, number>;
  nodeRankings: Array<{ nodeId: string; score: number }>;
  embargoesSummary: Array<{ nodeId: string; embargoedBy: string[] }>;
}

// ─── Constants ────────────────────────────────────────────────────────────────

export const CARAVAN_SPEED = 1.0;

export const PORT_THROUGHPUT: Record<number, number> = {
  1: 100,
  2: 250,
  3: 500,
  4: 1000,
  5: 2500,
};

export const TARIFF_RATES: Record<CommodityType, number> = {
  raw_material: 0.05,
  processed_good: 0.1,
  organism_part: 0.15,
  anomaly_extract: 0.25,
  doctrine_scroll: 0.3,
  signal_crystal: 0.2,
  void_matter: 0.4,
  forma_ingot: 0.12,
};

export const CONTRABAND_CATEGORIES: CommodityType[] = [
  "void_matter",
  "anomaly_extract",
  "doctrine_scroll",
];

export const SMUGGLING_DETECTION_RATE = 0.35;

// ─── Utility Helpers ──────────────────────────────────────────────────────────

function generateId(prefix: string): string {
  return `${prefix}_${Math.random().toString(36).slice(2, 11)}_${Date.now()}`;
}

function clamp(value: number, min: number, max: number): number {
  return Math.max(min, Math.min(max, value));
}

function edgeKey(fromId: string, toId: string): string {
  return `${fromId}::${toId}`;
}

// ─── Node & Edge Management ───────────────────────────────────────────────────

export function addTradeNode(
  network: TradeNetwork,
  partial: Omit<
    TradeNode,
    "id" | "currentThroughput" | "embargoed" | "embargoedBy"
  >,
): TradeNode {
  const node: TradeNode = {
    ...partial,
    id: generateId("node"),
    embargoed: false,
    embargoedBy: [],
    currentThroughput: 0,
  };
  network.nodes[node.id] = node;
  return node;
}

export function addTradeEdge(
  network: TradeNetwork,
  fromNodeId: string,
  toNodeId: string,
  distance: number,
  terrainModifier = 1.0,
  tariffScheduleId: string | null = null,
): TradeEdge {
  if (!network.nodes[fromNodeId] || !network.nodes[toNodeId]) {
    throw new Error(
      `addTradeEdge: node not found (${fromNodeId} → ${toNodeId})`,
    );
  }
  const edge: TradeEdge = {
    id: generateId("edge"),
    fromNodeId,
    toNodeId,
    distance,
    terrainModifier,
    blocked: false,
    blockedReason: null,
    tariffScheduleId,
    bandits: 0,
    lastTraversedTick: null,
    caravansInTransit: [],
  };
  network.edges[edge.id] = edge;
  return edge;
}

// ─── Routing ──────────────────────────────────────────────────────────────────

export function computeShortestTradeRoute(
  network: TradeNetwork,
  originNodeId: string,
  destinationNodeId: string,
): string[] {
  const nodeIds = Object.keys(network.nodes);
  const dist: Record<string, number> = {};
  const prev: Record<string, string | null> = {};
  const unvisited = new Set<string>(nodeIds);

  for (const id of nodeIds) {
    dist[id] = Number.POSITIVE_INFINITY;
    prev[id] = null;
  }
  dist[originNodeId] = 0;

  while (unvisited.size > 0) {
    let u: string | null = null;
    let minDist = Number.POSITIVE_INFINITY;
    for (const id of unvisited) {
      if (dist[id] < minDist) {
        minDist = dist[id];
        u = id;
      }
    }
    if (u === null || u === destinationNodeId) break;
    unvisited.delete(u);

    for (const edge of Object.values(network.edges)) {
      if (edge.blocked) continue;
      let neighbor: string | null = null;
      if (edge.fromNodeId === u) neighbor = edge.toNodeId;
      else if (edge.toNodeId === u) neighbor = edge.fromNodeId;
      if (!neighbor || !unvisited.has(neighbor)) continue;

      const cost = edge.distance * edge.terrainModifier + edge.bandits * 2;
      const alt = dist[u] + cost;
      if (alt < dist[neighbor]) {
        dist[neighbor] = alt;
        prev[neighbor] = u;
      }
    }
  }

  const path: string[] = [];
  let current: string | null = destinationNodeId;
  while (current !== null) {
    path.unshift(current);
    current = prev[current] ?? null;
  }
  if (path[0] !== originNodeId) return [];
  return path;
}

function getEdgeBetween(
  network: TradeNetwork,
  fromId: string,
  toId: string,
): TradeEdge | null {
  for (const edge of Object.values(network.edges)) {
    if (
      (edge.fromNodeId === fromId && edge.toNodeId === toId) ||
      (edge.fromNodeId === toId && edge.toNodeId === fromId)
    ) {
      return edge;
    }
  }
  return null;
}

export function routeCaravan(
  network: TradeNetwork,
  caravanId: string,
  destinationNodeId: string,
): boolean {
  const caravan = network.caravans[caravanId];
  if (!caravan) return false;
  if (!network.nodes[destinationNodeId]) return false;

  const nodeRoute = computeShortestTradeRoute(
    network,
    caravan.originNodeId,
    destinationNodeId,
  );
  if (nodeRoute.length < 2) return false;

  const edgeIds: string[] = [];
  for (let i = 0; i < nodeRoute.length - 1; i++) {
    const edge = getEdgeBetween(network, nodeRoute[i], nodeRoute[i + 1]);
    if (!edge) return false;
    edgeIds.push(edge.id);
  }

  caravan.destinationNodeId = destinationNodeId;
  caravan.routeEdgeIds = edgeIds;
  caravan.routeProgress = 0;
  caravan.currentEdgeId = edgeIds[0];
  caravan.status = "in_transit";

  const totalDist = edgeIds.reduce((sum, eid) => {
    const e = network.edges[eid];
    return sum + (e ? e.distance * e.terrainModifier : 0);
  }, 0);
  caravan.estimatedArrivalTick =
    network.tick + Math.ceil(totalDist / caravan.speed);
  return true;
}

// ─── Trade Processing ─────────────────────────────────────────────────────────

export function processTrade(
  network: TradeNetwork,
  fromNodeId: string,
  toNodeId: string,
  commodityId: string,
  quantity: number,
): { success: boolean; revenue: number; tariffPaid: number; reason?: string } {
  const from = network.nodes[fromNodeId];
  const to = network.nodes[toNodeId];
  if (!from || !to)
    return {
      success: false,
      revenue: 0,
      tariffPaid: 0,
      reason: "node not found",
    };

  if (from.embargoed && from.embargoedBy.includes(to.factionId))
    return {
      success: false,
      revenue: 0,
      tariffPaid: 0,
      reason: "embargo active",
    };

  const available = from.inventory[commodityId] ?? 0;
  if (available < quantity)
    return {
      success: false,
      revenue: 0,
      tariffPaid: 0,
      reason: "insufficient stock",
    };

  const throughputLeft = from.throughputCapacity - from.currentThroughput;
  if (throughputLeft < quantity)
    return {
      success: false,
      revenue: 0,
      tariffPaid: 0,
      reason: "throughput exceeded",
    };

  from.inventory[commodityId] = available - quantity;
  to.inventory[commodityId] = (to.inventory[commodityId] ?? 0) + quantity;
  from.currentThroughput += quantity;

  const tariffResult = applyTariffs(
    network,
    fromNodeId,
    toNodeId,
    commodityId,
    quantity,
  );
  return {
    success: true,
    revenue: tariffResult.netRevenue,
    tariffPaid: tariffResult.tariffAmount,
  };
}

export function applyTariffs(
  network: TradeNetwork,
  fromNodeId: string,
  toNodeId: string,
  commodityId: string,
  quantity: number,
): { tariffAmount: number; netRevenue: number; scheduleUsed: string | null } {
  const from = network.nodes[fromNodeId];
  const to = network.nodes[toNodeId];
  const edge = getEdgeBetween(network, fromNodeId, toNodeId);

  let tariffRate = from.taxRate;
  let scheduleUsed: string | null = null;

  if (edge?.tariffScheduleId) {
    const schedule = network.tariffSchedules[edge.tariffScheduleId];
    if (
      schedule &&
      network.tick <= (schedule.validUntilTick ?? Number.POSITIVE_INFINITY)
    ) {
      if (!schedule.exemptFactions.includes(to.factionId)) {
        const rate =
          schedule.rates[commodityId] ?? schedule.rates.default ?? tariffRate;
        tariffRate = rate;
        scheduleUsed = schedule.id;
      } else {
        tariffRate = 0;
        scheduleUsed = schedule.id;
      }
    }
  }

  for (const agreement of Object.values(network.agreements)) {
    if (!agreement.active) continue;
    const involves =
      (agreement.factionAId === from.factionId &&
        agreement.factionBId === to.factionId) ||
      (agreement.factionBId === from.factionId &&
        agreement.factionAId === to.factionId);
    if (!involves) continue;
    if (agreement.type === "free_trade") {
      tariffRate = 0;
    } else if (agreement.type === "preferential") {
      tariffRate *= 1 - agreement.tariffReduction;
    }
  }

  const tariffAmount = tariffRate * quantity;
  const netRevenue = quantity - tariffAmount;
  return { tariffAmount, netRevenue, scheduleUsed };
}

export function detectContraband(
  network: TradeNetwork,
  caravanId: string,
): ContrabandAlert[] {
  const caravan = network.caravans[caravanId];
  if (!caravan) return [];

  const alerts: ContrabandAlert[] = [];
  const currentNodeId = caravan.originNodeId;
  const node = network.nodes[currentNodeId];
  const inspectionPower = node?.portFacility?.inspectionCapability ?? 0.5;

  for (const [commodityId, quantity] of Object.entries(caravan.cargo)) {
    if (quantity <= 0) continue;
    if (!CONTRABAND_CATEGORIES.some((ct) => commodityId.startsWith(ct)))
      continue;

    const detectionChance =
      SMUGGLING_DETECTION_RATE *
      inspectionPower *
      (caravan.smuggling ? 1.5 : 0.8);
    if (Math.random() < detectionChance) {
      const severity =
        quantity > 100
          ? "critical"
          : quantity > 50
            ? "high"
            : quantity > 10
              ? "medium"
              : "low";
      const alert: ContrabandAlert = {
        id: generateId("alert"),
        tick: network.tick,
        nodeId: currentNodeId,
        caravanId,
        commodityId,
        quantity,
        severity,
        resolved: false,
        resolvedTick: null,
        factionNotified: node ? [node.factionId] : [],
      };
      alerts.push(alert);
      network.contrabandAlerts.push(alert);
    }
  }
  return alerts;
}

// ─── Network Analytics ────────────────────────────────────────────────────────

export function computeNetworkDensity(network: TradeNetwork): number {
  const n = Object.keys(network.nodes).length;
  if (n < 2) return 0;
  const maxEdges = n * (n - 1);
  const actualEdges = Object.keys(network.edges).length;
  return actualEdges / maxEdges;
}

export function rankTradeNodes(
  network: TradeNetwork,
): Array<{ nodeId: string; score: number }> {
  const scores: Record<string, number> = {};
  for (const nodeId of Object.keys(network.nodes)) {
    scores[nodeId] = 0;
  }

  for (const edge of Object.values(network.edges)) {
    if (!edge.blocked) {
      scores[edge.fromNodeId] = (scores[edge.fromNodeId] ?? 0) + 1;
      scores[edge.toNodeId] = (scores[edge.toNodeId] ?? 0) + 1;
    }
  }

  for (const caravan of Object.values(network.caravans)) {
    if (caravan.status === "in_transit") {
      scores[caravan.originNodeId] = (scores[caravan.originNodeId] ?? 0) + 0.5;
      scores[caravan.destinationNodeId] =
        (scores[caravan.destinationNodeId] ?? 0) + 0.5;
    }
  }

  for (const node of Object.values(network.nodes)) {
    const totalInventory = Object.values(node.inventory).reduce(
      (a, b) => a + b,
      0,
    );
    scores[node.id] = (scores[node.id] ?? 0) + totalInventory * 0.001;
    if (node.portFacility) {
      scores[node.id] += node.portFacility.level * 2;
    }
  }

  return Object.entries(scores)
    .map(([nodeId, score]) => ({ nodeId, score }))
    .sort((a, b) => b.score - a.score);
}

export function applyEmbargo(
  network: TradeNetwork,
  targetNodeId: string,
  byFactionId: string,
): void {
  const node = network.nodes[targetNodeId];
  if (!node) throw new Error(`applyEmbargo: node ${targetNodeId} not found`);
  if (!node.embargoedBy.includes(byFactionId)) {
    node.embargoedBy.push(byFactionId);
  }
  node.embargoed = node.embargoedBy.length > 0;
}

export function liftEmbargo(
  network: TradeNetwork,
  targetNodeId: string,
  byFactionId: string,
): void {
  const node = network.nodes[targetNodeId];
  if (!node) return;
  node.embargoedBy = node.embargoedBy.filter((id) => id !== byFactionId);
  node.embargoed = node.embargoedBy.length > 0;
}

export function generateTradeReport(network: TradeNetwork): TradeIntelReport {
  const routeVolumes: Record<string, number> = {};
  const commodityVolumes: Record<string, number> = {};
  const tariffRevenue: Record<string, number> = {};

  for (const caravan of Object.values(network.caravans)) {
    if (caravan.status !== "arrived") continue;
    const key = edgeKey(caravan.originNodeId, caravan.destinationNodeId);
    for (const [commodityId, qty] of Object.entries(caravan.cargo)) {
      routeVolumes[key] = (routeVolumes[key] ?? 0) + qty;
      commodityVolumes[commodityId] =
        (commodityVolumes[commodityId] ?? 0) + qty;
    }
  }

  for (const node of Object.values(network.nodes)) {
    tariffRevenue[node.factionId] =
      (tariffRevenue[node.factionId] ?? 0) +
      node.currentThroughput * node.taxRate;
  }

  const topRoutes = Object.entries(routeVolumes)
    .sort(([, a], [, b]) => b - a)
    .slice(0, 10)
    .map(([key, vol]) => {
      const [fromNodeId, toNodeId] = key.split("::");
      return { fromNodeId, toNodeId, volumePerTick: vol };
    });

  const topCommodities = Object.entries(commodityVolumes)
    .sort(([, a], [, b]) => b - a)
    .slice(0, 10)
    .map(([commodityId, totalVolume]) => ({ commodityId, totalVolume }));

  const blockedEdges = Object.values(network.edges).filter(
    (e) => e.blocked,
  ).length;
  const activeCaravans = Object.values(network.caravans).filter(
    (c) => c.status === "in_transit",
  ).length;
  const contrabandIncidents = network.contrabandAlerts.filter(
    (a) => !a.resolved,
  ).length;
  const nodeRankings = rankTradeNodes(network);
  const embargoesSummary = Object.values(network.nodes)
    .filter((n) => n.embargoed)
    .map((n) => ({ nodeId: n.id, embargoedBy: [...n.embargoedBy] }));

  return {
    id: generateId("report"),
    generatedTick: network.tick,
    networkId: network.id,
    topTradeRoutes: topRoutes,
    mostTradedCommodities: topCommodities,
    networkDensity: computeNetworkDensity(network),
    activeCaravans,
    blockedEdges,
    contrabandIncidents,
    totalTariffRevenue: tariffRevenue,
    nodeRankings,
    embargoesSummary,
  };
}

// ─── TradeNetworkEngine Class ─────────────────────────────────────────────────

export class TradeNetworkEngine {
  private network: TradeNetwork;

  constructor(name: string) {
    this.network = {
      id: generateId("network"),
      name,
      nodes: {},
      edges: {},
      caravans: {},
      agreements: {},
      tariffSchedules: {},
      contrabandAlerts: [],
      tick: 0,
    };
  }

  getNetwork(): TradeNetwork {
    return this.network;
  }

  addNode(
    partial: Omit<
      TradeNode,
      "id" | "currentThroughput" | "embargoed" | "embargoedBy"
    >,
  ): TradeNode {
    return addTradeNode(this.network, partial);
  }

  addRoute(
    fromNodeId: string,
    toNodeId: string,
    distance: number,
    terrainModifier = 1.0,
    tariffScheduleId: string | null = null,
  ): TradeEdge {
    return addTradeEdge(
      this.network,
      fromNodeId,
      toNodeId,
      distance,
      terrainModifier,
      tariffScheduleId,
    );
  }

  removeRoute(edgeId: string): boolean {
    if (!this.network.edges[edgeId]) return false;
    const edge = this.network.edges[edgeId];
    for (const caravanId of edge.caravansInTransit) {
      const caravan = this.network.caravans[caravanId];
      if (caravan) caravan.status = "blocked";
    }
    delete this.network.edges[edgeId];
    return true;
  }

  spawnCaravan(
    ownerFactionId: string,
    originNodeId: string,
    cargo: Record<string, number>,
    guards = 0,
  ): CaravanUnit {
    const totalLoad = Object.values(cargo).reduce((a, b) => a + b, 0);
    const caravan: CaravanUnit = {
      id: generateId("caravan"),
      name: `Caravan-${Math.floor(Math.random() * 9999)}`,
      ownerFactionId,
      cargo,
      capacity: Math.max(totalLoad * 1.2, 100),
      currentLoad: totalLoad,
      speed: CARAVAN_SPEED,
      currentEdgeId: null,
      originNodeId,
      destinationNodeId: originNodeId,
      routeEdgeIds: [],
      routeProgress: 0,
      status: "idle",
      departedTick: this.network.tick,
      estimatedArrivalTick: null,
      guards,
      smuggling: false,
    };
    this.network.caravans[caravan.id] = caravan;
    return caravan;
  }

  dispatchCaravan(caravanId: string, destinationNodeId: string): boolean {
    return routeCaravan(this.network, caravanId, destinationNodeId);
  }

  addTariffSchedule(schedule: Omit<TariffSchedule, "id">): TariffSchedule {
    const full: TariffSchedule = { ...schedule, id: generateId("tariff") };
    this.network.tariffSchedules[full.id] = full;
    return full;
  }

  addAgreement(agreement: Omit<TradeAgreement, "id">): TradeAgreement {
    const full: TradeAgreement = { ...agreement, id: generateId("agreement") };
    this.network.agreements[full.id] = full;
    return full;
  }

  imposEmbargo(targetNodeId: string, byFactionId: string): void {
    applyEmbargo(this.network, targetNodeId, byFactionId);
  }

  liftEmbargo(targetNodeId: string, byFactionId: string): void {
    liftEmbargo(this.network, targetNodeId, byFactionId);
  }

  private tickCaravans(): void {
    for (const caravan of Object.values(this.network.caravans)) {
      if (caravan.status !== "in_transit") continue;
      if (caravan.routeEdgeIds.length === 0) {
        caravan.status = "arrived";
        continue;
      }

      const currentEdgeId = caravan.routeEdgeIds[0];
      const edge = this.network.edges[currentEdgeId];
      if (!edge) {
        caravan.status = "blocked";
        continue;
      }
      if (edge.blocked) {
        caravan.status = "blocked";
        continue;
      }

      const travelPerTick =
        caravan.speed / (edge.distance * edge.terrainModifier);
      caravan.routeProgress += travelPerTick;

      if (caravan.routeProgress >= 1.0) {
        caravan.routeProgress = 0;
        edge.caravansInTransit = edge.caravansInTransit.filter(
          (id) => id !== caravan.id,
        );
        edge.lastTraversedTick = this.network.tick;
        caravan.routeEdgeIds.shift();
        caravan.currentEdgeId = caravan.routeEdgeIds[0] ?? null;

        if (caravan.routeEdgeIds.length === 0) {
          caravan.status = "arrived";
          const destNode = this.network.nodes[caravan.destinationNodeId];
          if (destNode) {
            for (const [commodityId, qty] of Object.entries(caravan.cargo)) {
              destNode.inventory[commodityId] =
                (destNode.inventory[commodityId] ?? 0) + qty;
            }
          }
          detectContraband(this.network, caravan.id);
        } else {
          const nextEdge = this.network.edges[caravan.routeEdgeIds[0]];
          if (nextEdge && !nextEdge.caravansInTransit.includes(caravan.id)) {
            nextEdge.caravansInTransit.push(caravan.id);
          }
        }
      }

      if (edge.bandits > 0) {
        const robberyChance = clamp(
          edge.bandits * 0.02 - caravan.guards * 0.01,
          0,
          0.5,
        );
        if (Math.random() < robberyChance) {
          for (const key of Object.keys(caravan.cargo)) {
            caravan.cargo[key] = Math.floor(caravan.cargo[key] * 0.7);
          }
        }
      }
    }
  }

  private tickAgreements(): void {
    for (const agreement of Object.values(this.network.agreements)) {
      if (!agreement.active) continue;
      if (
        agreement.expiryTick !== null &&
        this.network.tick >= agreement.expiryTick
      ) {
        agreement.active = false;
      }
    }
  }

  private tickThroughputReset(): void {
    for (const node of Object.values(this.network.nodes)) {
      node.currentThroughput = 0;
    }
  }

  tick(): void {
    this.tickThroughputReset();
    this.tickAgreements();
    this.tickCaravans();
    this.network.tick += 1;
  }

  report(): TradeIntelReport {
    return generateTradeReport(this.network);
  }

  serialize(): string {
    return JSON.stringify(this.network, null, 2);
  }

  static deserialize(json: string): TradeNetworkEngine {
    const data = JSON.parse(json) as TradeNetwork;
    const engine = new TradeNetworkEngine(data.name);
    engine.network = data;
    return engine;
  }

  getNodeById(nodeId: string): TradeNode | null {
    return this.network.nodes[nodeId] ?? null;
  }

  getEdgeById(edgeId: string): TradeEdge | null {
    return this.network.edges[edgeId] ?? null;
  }

  getCaravanById(caravanId: string): CaravanUnit | null {
    return this.network.caravans[caravanId] ?? null;
  }

  listActiveCaravans(): CaravanUnit[] {
    return Object.values(this.network.caravans).filter(
      (c) => c.status === "in_transit",
    );
  }

  listNodes(): TradeNode[] {
    return Object.values(this.network.nodes);
  }

  listEdges(): TradeEdge[] {
    return Object.values(this.network.edges);
  }

  blockEdge(edgeId: string, reason: string): void {
    const edge = this.network.edges[edgeId];
    if (!edge) throw new Error(`blockEdge: edge ${edgeId} not found`);
    edge.blocked = true;
    edge.blockedReason = reason;
    for (const caravanId of edge.caravansInTransit) {
      const c = this.network.caravans[caravanId];
      if (c) c.status = "blocked";
    }
  }

  unblockEdge(edgeId: string): void {
    const edge = this.network.edges[edgeId];
    if (!edge) return;
    edge.blocked = false;
    edge.blockedReason = null;
  }

  updateBandits(edgeId: string, count: number): void {
    const edge = this.network.edges[edgeId];
    if (!edge) return;
    edge.bandits = clamp(count, 0, 100);
  }

  resolveAlert(alertId: string): boolean {
    const alert = this.network.contrabandAlerts.find((a) => a.id === alertId);
    if (!alert || alert.resolved) return false;
    alert.resolved = true;
    alert.resolvedTick = this.network.tick;
    const caravan = alert.caravanId
      ? this.network.caravans[alert.caravanId]
      : null;
    if (caravan) {
      caravan.cargo[alert.commodityId] = 0;
      caravan.status = "seized";
    }
    return true;
  }

  setPortFacility(
    nodeId: string,
    facility: Omit<PortFacility, "id" | "nodeId">,
  ): PortFacility {
    const node = this.network.nodes[nodeId];
    if (!node) throw new Error(`setPortFacility: node ${nodeId} not found`);
    const port: PortFacility = {
      ...facility,
      id: generateId("port"),
      nodeId,
    };
    node.portFacility = port;
    node.throughputCapacity =
      PORT_THROUGHPUT[port.level] ?? node.throughputCapacity;
    return port;
  }

  computeDensity(): number {
    return computeNetworkDensity(this.network);
  }

  shortestRoute(fromId: string, toId: string): string[] {
    return computeShortestTradeRoute(this.network, fromId, toId);
  }

  currentTick(): number {
    return this.network.tick;
  }
}
