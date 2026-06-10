/**
 * ╔══════════════════════════════════════════════════════════════════════════════╗
 * ║                 WORLD ENGINE — 世界-SUBSTRATE v1.0                           ║
 * ║            Ecology, Geopolitics, Resource Dynamics & Global Simulation       ║
 * ╠══════════════════════════════════════════════════════════════════════════════╣
 * ║  The WORLD Engine simulates the external environment in which the organism   ║
 * ║  operates. It models ecological systems, geopolitical dynamics, resource     ║
 * ║  flows, and global events that affect organism behavior and strategy.        ║
 * ╚══════════════════════════════════════════════════════════════════════════════╝
 */

// ============================================================================
// SECTION 1: WORLD CONSTANTS
// ============================================================================

/** Number of world regions */
export const NUM_REGIONS = 12;

/** Number of resource types */
export const NUM_RESOURCES = 8;

/** Simulation tick duration (virtual days) */
export const TICK_DAYS = 1;

/** Maximum population per region (millions) */
export const MAX_POPULATION = 2000;

/** Resource regeneration rate */
export const REGEN_RATE = 0.02;

/** Pollution decay rate */
export const POLLUTION_DECAY = 0.01;

/** Climate sensitivity parameter */
export const CLIMATE_SENSITIVITY = 3.0; // °C per doubling of CO2

/** Base CO2 level (ppm) */
export const BASE_CO2 = 280;

/** Current CO2 level (ppm) */
export const CURRENT_CO2 = 420;

// ============================================================================
// SECTION 2: TYPE DEFINITIONS
// ============================================================================

/**
 * Resource types in the world
 */
export type ResourceType =
  | "energy" // Fossil fuels, renewables
  | "water" // Fresh water
  | "food" // Agricultural output
  | "minerals" // Metals, rare earths
  | "data" // Information, compute
  | "labor" // Human capital
  | "capital" // Financial resources
  | "technology"; // Innovation capacity

/**
 * Climate zone types
 */
export type ClimateZone =
  | "tropical"
  | "arid"
  | "temperate"
  | "continental"
  | "polar";

/**
 * Political system types
 */
export type PoliticalSystem =
  | "democracy"
  | "autocracy"
  | "oligarchy"
  | "theocracy"
  | "technocracy"
  | "anarchy";

/**
 * Economic system types
 */
export type EconomicSystem =
  | "market"
  | "planned"
  | "mixed"
  | "traditional"
  | "digital";

/**
 * Terrain types
 */
export type TerrainType =
  | "mountain"
  | "plain"
  | "forest"
  | "desert"
  | "coastal"
  | "urban"
  | "agricultural";

/**
 * Region definition
 */
export interface Region {
  readonly id: string;
  readonly name: string;
  readonly climate: ClimateZone;
  readonly terrain: TerrainType[];
  readonly area: number; // km²
  readonly population: number; // millions
  readonly populationGrowth: number; // annual rate
  readonly resources: ResourceInventory;
  readonly resourceCapacity: ResourceInventory;
  readonly production: ResourceInventory;
  readonly consumption: ResourceInventory;
  readonly pollution: number; // [0, 1] normalized
  readonly biodiversity: number; // [0, 1] health index
  readonly infrastructure: number; // [0, 1] development level
  readonly stability: number; // [0, 1] social stability
  readonly politicalSystem: PoliticalSystem;
  readonly economicSystem: EconomicSystem;
  readonly neighbors: string[]; // Adjacent region IDs
  readonly tradePartners: Map<string, number>; // Region ID → trade volume
  readonly alliances: string[]; // Allied region IDs
  readonly conflicts: string[]; // Conflicting region IDs
  readonly temperature: number; // Average °C
  readonly precipitation: number; // mm/year
  readonly seaLevel: number; // m above mean
  readonly events: WorldEvent[]; // Active events
}

/**
 * Resource inventory
 */
export interface ResourceInventory {
  energy: number;
  water: number;
  food: number;
  minerals: number;
  data: number;
  labor: number;
  capital: number;
  technology: number;
}

/**
 * World event types
 */
export type EventType =
  | "natural_disaster"
  | "pandemic"
  | "economic_crisis"
  | "political_upheaval"
  | "technological_breakthrough"
  | "resource_discovery"
  | "environmental_collapse"
  | "war"
  | "peace_treaty"
  | "climate_milestone";

/**
 * World event
 */
export interface WorldEvent {
  readonly id: string;
  readonly type: EventType;
  readonly name: string;
  readonly description: string;
  readonly startTime: number;
  readonly duration: number; // days
  readonly severity: number; // [0, 1]
  readonly affectedRegions: string[];
  readonly effects: EventEffect[];
  readonly resolved: boolean;
}

/**
 * Event effect
 */
export interface EventEffect {
  readonly target:
    | "population"
    | "resources"
    | "stability"
    | "infrastructure"
    | "environment";
  readonly resourceType?: ResourceType;
  readonly modifier: number; // Multiplicative modifier
  readonly duration: number; // days
}

/**
 * Trade agreement
 */
export interface TradeAgreement {
  readonly id: string;
  readonly parties: string[]; // Region IDs
  readonly resourceType: ResourceType;
  readonly volume: number; // Units per day
  readonly pricePerUnit: number;
  readonly startDate: number;
  readonly endDate?: number;
  readonly isActive: boolean;
  readonly tariffRate: number; // [0, 1]
}

/**
 * Conflict state
 */
export interface Conflict {
  readonly id: string;
  readonly parties: string[]; // Region IDs involved
  readonly type: "economic" | "territorial" | "ideological" | "proxy";
  readonly intensity: number; // [0, 1]
  readonly startDate: number;
  readonly casualties: number;
  readonly economicDamage: number;
  readonly territories: string[]; // Disputed territories
  readonly isActive: boolean;
}

/**
 * Global climate state
 */
export interface ClimateState {
  readonly globalTemperature: number; // °C anomaly from pre-industrial
  readonly co2Level: number; // ppm
  readonly seaLevelRise: number; // m from 1900 baseline
  readonly iceSheetMass: number; // % of 1900 level
  readonly oceanAcidity: number; // pH
  readonly extremeWeatherIndex: number; // [0, 1]
  readonly carbonBudgetRemaining: number; // Gt CO2
  readonly projectedWarming2100: number; // °C
}

/**
 * Ecosystem state
 */
export interface EcosystemState {
  readonly biodiversityIndex: number; // [0, 1]
  readonly forestCoverage: number; // % of land
  readonly oceanHealth: number; // [0, 1]
  readonly freshwaterAvailability: number; // % of 1900 level
  readonly soilFertility: number; // [0, 1]
  readonly speciesExtinctionRate: number; // Species per year
  readonly pollinatorHealth: number; // [0, 1]
  readonly coralReefHealth: number; // [0, 1]
}

/**
 * Economic indicators
 */
export interface EconomicIndicators {
  readonly globalGDP: number; // Trillions USD
  readonly giniCoefficient: number; // [0, 1] inequality
  readonly unemploymentRate: number; // [0, 1]
  readonly inflationRate: number; // Annual %
  readonly debtToGDP: number; // Ratio
  readonly tradeVolume: number; // Trillions USD
  readonly techInvestment: number; // % of GDP
  readonly greenInvestment: number; // % of GDP
}

/**
 * Technology state
 */
export interface TechnologyState {
  readonly renewableEnergy: number; // % of total energy
  readonly aiCapability: number; // [0, 1] advancement
  readonly biotechLevel: number; // [0, 1]
  readonly spaceExploration: number; // [0, 1]
  readonly quantumComputing: number; // [0, 1]
  readonly fusionEnergy: number; // [0, 1] progress
  readonly carbonCapture: number; // Gt/year capacity
  readonly automationLevel: number; // [0, 1]
}

/**
 * Complete world state
 */
export interface WorldState {
  readonly timestamp: number;
  readonly virtualDate: number; // Days from epoch
  readonly regions: Map<string, Region>;
  readonly climate: ClimateState;
  readonly ecosystem: EcosystemState;
  readonly economy: EconomicIndicators;
  readonly technology: TechnologyState;
  readonly tradeAgreements: Map<string, TradeAgreement>;
  readonly conflicts: Map<string, Conflict>;
  readonly activeEvents: WorldEvent[];
  readonly eventHistory: WorldEvent[];
  readonly globalPopulation: number; // Billions
  readonly resourcePrices: ResourceInventory;
  readonly geopoliticalTensions: Map<string, number>; // Region pair → tension
}

// ============================================================================
// SECTION 3: ECOLOGICAL DYNAMICS
// ============================================================================

/**
 * Lotka-Volterra ecosystem model
 * Models predator-prey and competition dynamics
 */
export class EcosystemModel {
  private populations: Map<string, number> = new Map();
  private carryingCapacities: Map<string, number> = new Map();
  private growthRates: Map<string, number> = new Map();
  private interactions: Map<string, Map<string, number>> = new Map();

  constructor() {
    this.initializeSpecies();
  }

  /**
   * Initialize species populations
   */
  private initializeSpecies(): void {
    // Primary producers
    this.addSpecies("phytoplankton", 1000, 2000, 0.1);
    this.addSpecies("forest", 500, 800, 0.02);
    this.addSpecies("grassland", 400, 600, 0.05);
    this.addSpecies("crops", 300, 500, 0.1);

    // Primary consumers
    this.addSpecies("herbivores", 200, 400, 0.08);
    this.addSpecies("insects", 800, 1200, 0.15);
    this.addSpecies("fish", 300, 500, 0.06);

    // Secondary consumers
    this.addSpecies("predators", 50, 100, 0.04);
    this.addSpecies("birds", 150, 250, 0.05);

    // Apex predators
    this.addSpecies("apex", 10, 20, 0.02);

    // Set up interactions
    this.setInteraction("herbivores", "forest", -0.1); // Herbivores eat forest
    this.setInteraction("herbivores", "grassland", -0.15);
    this.setInteraction("forest", "herbivores", 0.05); // Forest supports herbivores

    this.setInteraction("predators", "herbivores", 0.1); // Predators eat herbivores
    this.setInteraction("herbivores", "predators", -0.2); // Herbivores harmed by predators

    this.setInteraction("apex", "predators", 0.08);
    this.setInteraction("predators", "apex", -0.15);

    this.setInteraction("insects", "crops", -0.2); // Insects eat crops
    this.setInteraction("birds", "insects", 0.1); // Birds eat insects
    this.setInteraction("insects", "birds", -0.15);

    this.setInteraction("fish", "phytoplankton", 0.05);
    this.setInteraction("phytoplankton", "fish", -0.03);
  }

  /**
   * Add a species
   */
  private addSpecies(
    name: string,
    initialPop: number,
    capacity: number,
    growth: number,
  ): void {
    this.populations.set(name, initialPop);
    this.carryingCapacities.set(name, capacity);
    this.growthRates.set(name, growth);
    this.interactions.set(name, new Map());
  }

  /**
   * Set interaction coefficient
   */
  private setInteraction(
    species1: string,
    species2: string,
    coefficient: number,
  ): void {
    if (!this.interactions.has(species1)) {
      this.interactions.set(species1, new Map());
    }
    this.interactions.get(species1)!.set(species2, coefficient);
  }

  /**
   * Compute population derivative for a species
   */
  private computeDerivative(species: string): number {
    const N = this.populations.get(species) || 0;
    const K = this.carryingCapacities.get(species) || 1;
    const r = this.growthRates.get(species) || 0;
    const interactions = this.interactions.get(species) || new Map();

    // Logistic growth
    let dN = r * N * (1 - N / K);

    // Add interaction effects
    for (const [otherSpecies, coefficient] of interactions) {
      const otherN = this.populations.get(otherSpecies) || 0;
      dN += (coefficient * N * otherN) / 1000; // Scaled interaction
    }

    return dN;
  }

  /**
   * Advance ecosystem by dt
   */
  step(dt: number): void {
    const derivatives = new Map<string, number>();

    // Compute all derivatives
    for (const species of this.populations.keys()) {
      derivatives.set(species, this.computeDerivative(species));
    }

    // Update populations
    for (const [species, dN] of derivatives) {
      const currentN = this.populations.get(species) || 0;
      const newN = Math.max(0, currentN + dN * dt);
      this.populations.set(species, newN);
    }
  }

  /**
   * Get biodiversity index
   */
  getBiodiversityIndex(): number {
    // Simpson's diversity index
    let totalN = 0;
    let sumN2 = 0;

    for (const N of this.populations.values()) {
      totalN += N;
      sumN2 += N * N;
    }

    if (totalN === 0) return 0;

    // 1 - Simpson's index (so higher = more diverse)
    return 1 - sumN2 / (totalN * totalN);
  }

  /**
   * Apply disturbance (e.g., natural disaster)
   */
  applyDisturbance(affectedSpecies: string[], mortalityRate: number): void {
    for (const species of affectedSpecies) {
      const currentN = this.populations.get(species) || 0;
      this.populations.set(species, currentN * (1 - mortalityRate));
    }
  }

  /**
   * Get population of a species
   */
  getPopulation(species: string): number {
    return this.populations.get(species) || 0;
  }

  /**
   * Get all populations
   */
  getAllPopulations(): Map<string, number> {
    return new Map(this.populations);
  }
}

/**
 * Carbon cycle model
 */
export class CarbonCycleModel {
  // Carbon reservoirs (Gt C)
  private atmosphere = 850; // Current ~880 Gt
  private ocean = 38000;
  private landBiosphere = 2000;
  private soils = 1500;
  private fossilReserves = 10000;

  // Fluxes (Gt C/year)
  private readonly oceanUptake: number = 2.5;
  private readonly landUptake: number = 3.0;
  private readonly respiration: number = 60;
  private readonly photosynthesis: number = 60;

  private emissions = 10; // Anthropogenic emissions

  /**
   * Set emissions level
   */
  setEmissions(gtPerYear: number): void {
    this.emissions = gtPerYear;
  }

  /**
   * Advance carbon cycle
   */
  step(dt: number): void {
    const years = dt / 365;

    // Ocean uptake (depends on atmospheric CO2 and temperature)
    const oceanFlux = this.oceanUptake * years * (this.atmosphere / 850);

    // Land uptake (CO2 fertilization effect)
    const landFlux =
      (this.landUptake * years * Math.log(this.atmosphere / 280)) / Math.log(2);

    // Anthropogenic emissions
    const emissionFlux = this.emissions * years;

    // Update reservoirs
    this.atmosphere += emissionFlux - oceanFlux - landFlux;
    this.ocean += oceanFlux;
    this.landBiosphere += landFlux * 0.4;
    this.soils += landFlux * 0.6;
    this.fossilReserves -= emissionFlux;

    // Prevent negative values
    this.fossilReserves = Math.max(0, this.fossilReserves);
  }

  /**
   * Get atmospheric CO2 in ppm
   */
  getCO2ppm(): number {
    // ~2.12 Gt C per ppm
    return this.atmosphere / 2.12;
  }

  /**
   * Get temperature anomaly (simplified)
   */
  getTemperatureAnomaly(): number {
    const co2Ratio = this.getCO2ppm() / BASE_CO2;
    return CLIMATE_SENSITIVITY * Math.log2(co2Ratio);
  }

  /**
   * Get state
   */
  getState(): {
    atmosphere: number;
    ocean: number;
    land: number;
    co2ppm: number;
    temperatureAnomaly: number;
  } {
    return {
      atmosphere: this.atmosphere,
      ocean: this.ocean,
      land: this.landBiosphere + this.soils,
      co2ppm: this.getCO2ppm(),
      temperatureAnomaly: this.getTemperatureAnomaly(),
    };
  }
}

/**
 * Water cycle model
 */
export class WaterCycleModel {
  // Reservoirs (km³)
  private oceans = 1370000000; // 97.2%
  private iceCaps = 29000000; // 2.1%
  private groundwater = 8000000;
  private freshwaterLakes = 100000;
  private atmosphere = 13000;
  private rivers = 2000;

  // Fluxes (km³/year)
  private evaporation = 430000;
  private precipitation = 430000;

  /**
   * Advance water cycle
   */
  step(dt: number, temperature: number): void {
    const years = dt / 365;

    // Temperature affects evaporation (Clausius-Clapeyron: ~7% per °C)
    const evapModifier = 1 + 0.07 * temperature;

    // Evaporation
    const evapFlux = this.evaporation * evapModifier * years;

    // Precipitation (follows evaporation with slight lag)
    const precipFlux = this.precipitation * evapModifier * years;

    // Ice melt (accelerated by warming)
    const iceMelt =
      temperature > 0 ? this.iceCaps * 0.001 * temperature * years : 0;

    // Update reservoirs
    this.atmosphere += evapFlux - precipFlux;
    this.oceans += precipFlux * 0.77 - evapFlux * 0.86 + iceMelt;
    this.freshwaterLakes += precipFlux * 0.01 - evapFlux * 0.02;
    this.groundwater += precipFlux * 0.22 - evapFlux * 0.12;
    this.iceCaps -= iceMelt;

    // Ensure non-negative
    this.iceCaps = Math.max(0, this.iceCaps);
  }

  /**
   * Get freshwater availability relative to baseline
   */
  getFreshwaterAvailability(): number {
    const baseline = 8100000 + 100000 + 2000; // Original freshwater
    const current = this.groundwater + this.freshwaterLakes + this.rivers;
    return current / baseline;
  }

  /**
   * Get sea level rise from ice melt (simplified)
   */
  getSeaLevelRise(): number {
    // Original ice caps ~29M km³, melting adds ~0.36m per 1% melted
    const percentMelted = 1 - this.iceCaps / 29000000;
    return percentMelted * 70; // Max ~70m if all ice melts
  }

  /**
   * Get state
   */
  getState(): {
    freshwaterAvailability: number;
    seaLevelRise: number;
    atmosphericWater: number;
    iceCapsRemaining: number;
  } {
    return {
      freshwaterAvailability: this.getFreshwaterAvailability(),
      seaLevelRise: this.getSeaLevelRise(),
      atmosphericWater: this.atmosphere,
      iceCapsRemaining: this.iceCaps / 29000000,
    };
  }
}

// ============================================================================
// SECTION 4: GEOPOLITICAL DYNAMICS
// ============================================================================

/**
 * Geopolitical tension model
 */
export class GeopoliticalModel {
  private tensions: Map<string, Map<string, number>> = new Map();
  private powerIndex: Map<string, number> = new Map();
  private alliances: Map<string, Set<string>> = new Map();

  /**
   * Initialize a region
   */
  addRegion(regionId: string, power: number): void {
    this.powerIndex.set(regionId, power);
    this.tensions.set(regionId, new Map());
    this.alliances.set(regionId, new Set());
  }

  /**
   * Set tension between two regions
   */
  setTension(region1: string, region2: string, tension: number): void {
    if (!this.tensions.has(region1)) this.tensions.set(region1, new Map());
    if (!this.tensions.has(region2)) this.tensions.set(region2, new Map());

    this.tensions.get(region1)!.set(region2, tension);
    this.tensions.get(region2)!.set(region1, tension);
  }

  /**
   * Get tension between two regions
   */
  getTension(region1: string, region2: string): number {
    return this.tensions.get(region1)?.get(region2) || 0;
  }

  /**
   * Form alliance
   */
  formAlliance(region1: string, region2: string): void {
    this.alliances.get(region1)?.add(region2);
    this.alliances.get(region2)?.add(region1);

    // Reduce tension
    this.setTension(
      region1,
      region2,
      Math.max(0, this.getTension(region1, region2) - 0.3),
    );
  }

  /**
   * Break alliance
   */
  breakAlliance(region1: string, region2: string): void {
    this.alliances.get(region1)?.delete(region2);
    this.alliances.get(region2)?.delete(region1);

    // Increase tension
    this.setTension(
      region1,
      region2,
      Math.min(1, this.getTension(region1, region2) + 0.2),
    );
  }

  /**
   * Compute conflict probability
   */
  computeConflictProbability(region1: string, region2: string): number {
    const tension = this.getTension(region1, region2);
    const power1 = this.powerIndex.get(region1) || 1;
    const power2 = this.powerIndex.get(region2) || 1;

    // Power balance affects conflict probability
    const powerRatio = Math.min(power1, power2) / Math.max(power1, power2);

    // More balanced power = higher conflict probability (at same tension)
    // Very unbalanced = weaker side unlikely to start conflict
    const balanceFactor = 0.5 + 0.5 * powerRatio;

    // Alliance network effects
    const allies1 = this.alliances.get(region1)?.size || 0;
    const allies2 = this.alliances.get(region2)?.size || 0;
    const allianceDeterrence = Math.min(1, (allies1 + allies2) * 0.1);

    return tension * balanceFactor * (1 - allianceDeterrence);
  }

  /**
   * Evolve tensions over time
   */
  step(dt: number, events: WorldEvent[]): void {
    const days = dt;

    // Natural tension decay
    for (const [region1, tensionMap] of this.tensions) {
      for (const [region2, tension] of tensionMap) {
        let newTension = tension * Math.exp(-0.001 * days);

        // Events affect tensions
        for (const event of events) {
          if (
            event.affectedRegions.includes(region1) &&
            event.affectedRegions.includes(region2)
          ) {
            if (event.type === "war") {
              newTension = Math.min(1, newTension + 0.5 * event.severity);
            } else if (event.type === "peace_treaty") {
              newTension = Math.max(0, newTension - 0.5);
            } else if (event.type === "natural_disaster") {
              // Shared disasters can reduce tension (cooperation) or increase (resource competition)
              newTension += (Math.random() - 0.5) * 0.1 * event.severity;
            }
          }
        }

        this.tensions
          .get(region1)!
          .set(region2, Math.max(0, Math.min(1, newTension)));
      }
    }
  }

  /**
   * Get global tension index
   */
  getGlobalTensionIndex(): number {
    let totalTension = 0;
    let count = 0;

    for (const tensionMap of this.tensions.values()) {
      for (const tension of tensionMap.values()) {
        totalTension += tension;
        count++;
      }
    }

    return count > 0 ? totalTension / count : 0;
  }

  /**
   * Get power rankings
   */
  getPowerRankings(): Array<{ region: string; power: number }> {
    const rankings = Array.from(this.powerIndex.entries()).map(
      ([region, power]) => ({ region, power }),
    );
    rankings.sort((a, b) => b.power - a.power);
    return rankings;
  }
}

/**
 * Economic simulation model
 */
export class EconomicModel {
  private gdp: Map<string, number> = new Map();
  private growth: Map<string, number> = new Map();
  private inflation: Map<string, number> = new Map();
  private unemployment: Map<string, number> = new Map();
  private tradeBalances: Map<string, number> = new Map();

  /**
   * Initialize region economy
   */
  addRegion(regionId: string, gdp: number, growth: number): void {
    this.gdp.set(regionId, gdp);
    this.growth.set(regionId, growth);
    this.inflation.set(regionId, 0.02);
    this.unemployment.set(regionId, 0.05);
    this.tradeBalances.set(regionId, 0);
  }

  /**
   * Simulate trade between regions
   */
  trade(exporter: string, importer: string, value: number): void {
    const exporterBalance = this.tradeBalances.get(exporter) || 0;
    const importerBalance = this.tradeBalances.get(importer) || 0;

    this.tradeBalances.set(exporter, exporterBalance + value);
    this.tradeBalances.set(importer, importerBalance - value);
  }

  /**
   * Apply economic shock
   */
  applyShock(
    regionId: string,
    gdpImpact: number,
    inflationImpact: number,
    unemploymentImpact: number,
  ): void {
    const currentGdp = this.gdp.get(regionId) || 0;
    const currentInflation = this.inflation.get(regionId) || 0;
    const currentUnemployment = this.unemployment.get(regionId) || 0;

    this.gdp.set(regionId, currentGdp * (1 + gdpImpact));
    this.inflation.set(regionId, currentInflation + inflationImpact);
    this.unemployment.set(
      regionId,
      Math.max(0, Math.min(1, currentUnemployment + unemploymentImpact)),
    );
  }

  /**
   * Advance economy
   */
  step(dt: number): void {
    const years = dt / 365;

    for (const [regionId, gdp] of this.gdp) {
      const growthRate = this.growth.get(regionId) || 0;
      const tradeBalance = this.tradeBalances.get(regionId) || 0;

      // GDP growth
      const newGdp = gdp * (1 + growthRate) ** years;

      // Trade affects growth
      const tradeEffect = tradeBalance * 0.01 * years;

      this.gdp.set(regionId, newGdp + tradeEffect);

      // Inflation tends toward target (2%)
      const inflation = this.inflation.get(regionId) || 0;
      this.inflation.set(
        regionId,
        inflation + (0.02 - inflation) * 0.1 * years,
      );

      // Unemployment follows Okun's law (roughly)
      const unemployment = this.unemployment.get(regionId) || 0;
      const okunFactor = -0.5 * (growthRate - 0.025); // 2.5% is neutral growth
      this.unemployment.set(
        regionId,
        Math.max(0.02, Math.min(0.25, unemployment + okunFactor * years)),
      );

      // Reset trade balance for next period
      this.tradeBalances.set(regionId, tradeBalance * 0.9);
    }
  }

  /**
   * Get global GDP
   */
  getGlobalGDP(): number {
    let total = 0;
    for (const gdp of this.gdp.values()) {
      total += gdp;
    }
    return total;
  }

  /**
   * Get Gini coefficient (simplified global inequality)
   */
  getGiniCoefficient(): number {
    const gdps = Array.from(this.gdp.values()).sort((a, b) => a - b);
    const n = gdps.length;
    if (n === 0) return 0;

    let sumOfDifferences = 0;
    for (let i = 0; i < n; i++) {
      for (let j = 0; j < n; j++) {
        sumOfDifferences += Math.abs(gdps[i] - gdps[j]);
      }
    }

    const mean = gdps.reduce((a, b) => a + b, 0) / n;
    return sumOfDifferences / (2 * n * n * mean);
  }

  /**
   * Get state for a region
   */
  getRegionState(regionId: string): {
    gdp: number;
    growth: number;
    inflation: number;
    unemployment: number;
    tradeBalance: number;
  } {
    return {
      gdp: this.gdp.get(regionId) || 0,
      growth: this.growth.get(regionId) || 0,
      inflation: this.inflation.get(regionId) || 0,
      unemployment: this.unemployment.get(regionId) || 0,
      tradeBalance: this.tradeBalances.get(regionId) || 0,
    };
  }
}

// ============================================================================
// SECTION 5: RESOURCE DYNAMICS
// ============================================================================

/**
 * Resource extraction and depletion model
 */
export class ResourceModel {
  private reserves: Map<string, ResourceInventory> = new Map();
  private extraction: Map<string, ResourceInventory> = new Map();
  private regeneration: Map<string, ResourceInventory> = new Map();
  private prices: ResourceInventory;

  constructor() {
    this.prices = this.createEmptyInventory();
    this.initializePrices();
  }

  /**
   * Create empty resource inventory
   */
  private createEmptyInventory(): ResourceInventory {
    return {
      energy: 0,
      water: 0,
      food: 0,
      minerals: 0,
      data: 0,
      labor: 0,
      capital: 0,
      technology: 0,
    };
  }

  /**
   * Initialize base prices
   */
  private initializePrices(): void {
    this.prices = {
      energy: 100,
      water: 10,
      food: 50,
      minerals: 200,
      data: 5,
      labor: 1000,
      capital: 1,
      technology: 500,
    };
  }

  /**
   * Add a region with resources
   */
  addRegion(
    regionId: string,
    reserves: ResourceInventory,
    regeneration: ResourceInventory,
  ): void {
    this.reserves.set(regionId, { ...reserves });
    this.extraction.set(regionId, this.createEmptyInventory());
    this.regeneration.set(regionId, { ...regeneration });
  }

  /**
   * Extract resources from a region
   */
  extract(
    regionId: string,
    amounts: Partial<ResourceInventory>,
  ): ResourceInventory {
    const reserves = this.reserves.get(regionId);
    if (!reserves) return this.createEmptyInventory();

    const extracted = this.createEmptyInventory();

    for (const [resource, amount] of Object.entries(amounts) as [
      keyof ResourceInventory,
      number,
    ][]) {
      const available = reserves[resource];
      const actualExtracted = Math.min(available, amount);
      (extracted as any)[resource] = actualExtracted;
      (reserves as any)[resource] -= actualExtracted;
    }

    // Track extraction
    const currentExtraction =
      this.extraction.get(regionId) || this.createEmptyInventory();
    for (const resource of Object.keys(
      amounts,
    ) as (keyof ResourceInventory)[]) {
      (currentExtraction as any)[resource] += (extracted as any)[resource];
    }
    this.extraction.set(regionId, currentExtraction);

    return extracted;
  }

  /**
   * Advance resource regeneration
   */
  step(dt: number): void {
    const days = dt;

    for (const [regionId, reserves] of this.reserves) {
      const regen =
        this.regeneration.get(regionId) || this.createEmptyInventory();

      // Renewable resources regenerate
      for (const resource of [
        "water",
        "food",
        "data",
        "labor",
      ] as (keyof ResourceInventory)[]) {
        const regenAmount = (regen as any)[resource] * days;
        (reserves as any)[resource] += regenAmount;
      }

      // Non-renewable don't regenerate (energy, minerals) - already depleted
    }

    // Update prices based on global supply/demand
    this.updatePrices();
  }

  /**
   * Update resource prices
   */
  private updatePrices(): void {
    let totalReserves = this.createEmptyInventory();
    let totalExtraction = this.createEmptyInventory();

    for (const reserves of this.reserves.values()) {
      for (const resource of Object.keys(
        reserves,
      ) as (keyof ResourceInventory)[]) {
        (totalReserves as any)[resource] += reserves[resource];
      }
    }

    for (const extraction of this.extraction.values()) {
      for (const resource of Object.keys(
        extraction,
      ) as (keyof ResourceInventory)[]) {
        (totalExtraction as any)[resource] += extraction[resource];
      }
    }

    // Price elasticity
    for (const resource of Object.keys(
      this.prices,
    ) as (keyof ResourceInventory)[]) {
      const reserve = (totalReserves as any)[resource];
      const extracted = (totalExtraction as any)[resource];

      if (reserve > 0 && extracted > 0) {
        const scarcityFactor = extracted / reserve;
        (this.prices as any)[resource] *= 1 + 0.01 * scarcityFactor;
      }
    }
  }

  /**
   * Get reserves for a region
   */
  getReserves(regionId: string): ResourceInventory {
    return this.reserves.get(regionId) || this.createEmptyInventory();
  }

  /**
   * Get current prices
   */
  getPrices(): ResourceInventory {
    return { ...this.prices };
  }

  /**
   * Get global resource state
   */
  getGlobalState(): ResourceInventory {
    const total = this.createEmptyInventory();

    for (const reserves of this.reserves.values()) {
      for (const resource of Object.keys(
        reserves,
      ) as (keyof ResourceInventory)[]) {
        (total as any)[resource] += reserves[resource];
      }
    }

    return total;
  }
}

// ============================================================================
// SECTION 6: EVENT GENERATION
// ============================================================================

/**
 * World event generator
 */
export class EventGenerator {
  private eventIdCounter = 0;

  /**
   * Generate potential events based on world state
   */
  generateEvents(worldState: WorldState): WorldEvent[] {
    const events: WorldEvent[] = [];

    // Climate events
    if (worldState.climate.globalTemperature > 1.5) {
      if (Math.random() < 0.01 * worldState.climate.globalTemperature) {
        events.push(this.createClimateEvent(worldState));
      }
    }

    // Economic events
    if (
      worldState.economy.inflationRate > 0.1 ||
      worldState.economy.unemploymentRate > 0.15
    ) {
      if (Math.random() < 0.02) {
        events.push(this.createEconomicEvent(worldState));
      }
    }

    // Pandemic events (rare)
    if (Math.random() < 0.001) {
      events.push(this.createPandemicEvent(worldState));
    }

    // Technology breakthroughs
    if (Math.random() < 0.005 * worldState.technology.aiCapability) {
      events.push(this.createTechEvent(worldState));
    }

    // Geopolitical events
    const tensions = worldState.geopoliticalTensions;
    for (const [pair, tension] of tensions) {
      if (tension > 0.7 && Math.random() < tension * 0.01) {
        const [region1, region2] = pair.split(":");
        events.push(this.createConflictEvent(region1, region2, tension));
      }
    }

    return events;
  }

  /**
   * Create climate-related event
   */
  private createClimateEvent(worldState: WorldState): WorldEvent {
    const types = ["heat_wave", "flood", "drought", "hurricane", "wildfire"];
    const type = types[Math.floor(Math.random() * types.length)];

    const regions = Array.from(worldState.regions.keys());
    const affectedCount = 1 + Math.floor(Math.random() * 3);
    const affectedRegions: string[] = [];
    for (let i = 0; i < affectedCount; i++) {
      affectedRegions.push(regions[Math.floor(Math.random() * regions.length)]);
    }

    return {
      id: `event_${++this.eventIdCounter}`,
      type: "natural_disaster",
      name: `Extreme ${type}`,
      description: `Severe ${type} affecting multiple regions`,
      startTime: worldState.timestamp,
      duration: 30 + Math.random() * 60,
      severity: 0.3 + Math.random() * 0.5,
      affectedRegions,
      effects: [
        {
          target: "infrastructure",
          modifier: -0.1 - Math.random() * 0.2,
          duration: 365,
        },
        {
          target: "resources",
          resourceType: "food",
          modifier: -0.2 - Math.random() * 0.3,
          duration: 180,
        },
      ],
      resolved: false,
    };
  }

  /**
   * Create economic event
   */
  private createEconomicEvent(worldState: WorldState): WorldEvent {
    const regions = Array.from(worldState.regions.keys());

    return {
      id: `event_${++this.eventIdCounter}`,
      type: "economic_crisis",
      name: "Economic Recession",
      description: "Global economic downturn affecting trade and employment",
      startTime: worldState.timestamp,
      duration: 365 + Math.random() * 365,
      severity: 0.4 + Math.random() * 0.4,
      affectedRegions: regions,
      effects: [
        {
          target: "resources",
          resourceType: "capital",
          modifier: -0.15,
          duration: 365,
        },
        {
          target: "stability",
          modifier: -0.1,
          duration: 180,
        },
      ],
      resolved: false,
    };
  }

  /**
   * Create pandemic event
   */
  private createPandemicEvent(worldState: WorldState): WorldEvent {
    const regions = Array.from(worldState.regions.keys());

    return {
      id: `event_${++this.eventIdCounter}`,
      type: "pandemic",
      name: "Novel Pathogen Outbreak",
      description: "New infectious disease spreading globally",
      startTime: worldState.timestamp,
      duration: 180 + Math.random() * 540,
      severity: 0.5 + Math.random() * 0.4,
      affectedRegions: regions,
      effects: [
        {
          target: "population",
          modifier: -0.001 - Math.random() * 0.01,
          duration: 365,
        },
        {
          target: "resources",
          resourceType: "labor",
          modifier: -0.1,
          duration: 180,
        },
      ],
      resolved: false,
    };
  }

  /**
   * Create technology event
   */
  private createTechEvent(worldState: WorldState): WorldEvent {
    const techTypes = [
      "AI breakthrough",
      "Fusion energy",
      "Quantum computing",
      "Biotech advance",
    ];
    const tech = techTypes[Math.floor(Math.random() * techTypes.length)];
    const regions = Array.from(worldState.regions.keys());

    return {
      id: `event_${++this.eventIdCounter}`,
      type: "technological_breakthrough",
      name: tech,
      description: `Major advancement in ${tech.toLowerCase()}`,
      startTime: worldState.timestamp,
      duration: 30,
      severity: 0.3 + Math.random() * 0.3,
      affectedRegions: regions,
      effects: [
        {
          target: "resources",
          resourceType: "technology",
          modifier: 0.1 + Math.random() * 0.2,
          duration: 365,
        },
      ],
      resolved: false,
    };
  }

  /**
   * Create conflict event
   */
  private createConflictEvent(
    region1: string,
    region2: string,
    tension: number,
  ): WorldEvent {
    return {
      id: `event_${++this.eventIdCounter}`,
      type: tension > 0.9 ? "war" : "political_upheaval",
      name: `${region1}-${region2} Conflict`,
      description: `Escalating tensions between ${region1} and ${region2}`,
      startTime: Date.now(),
      duration: 90 + Math.random() * 270,
      severity: tension,
      affectedRegions: [region1, region2],
      effects: [
        {
          target: "stability",
          modifier: -0.2 - Math.random() * 0.3,
          duration: 365,
        },
        {
          target: "resources",
          resourceType: "capital",
          modifier: -0.1 - Math.random() * 0.2,
          duration: 180,
        },
      ],
      resolved: false,
    };
  }
}

// ============================================================================
// SECTION 7: WORLD STATE MANAGEMENT
// ============================================================================

/**
 * Create initial world state
 */
export function createInitialWorldState(): WorldState {
  const regions = new Map<string, Region>();

  // Create sample regions
  const regionData = [
    {
      id: "north_america",
      name: "North America",
      climate: "temperate" as ClimateZone,
      pop: 370,
      gdp: 25,
    },
    {
      id: "europe",
      name: "Europe",
      climate: "temperate" as ClimateZone,
      pop: 450,
      gdp: 20,
    },
    {
      id: "east_asia",
      name: "East Asia",
      climate: "temperate" as ClimateZone,
      pop: 1600,
      gdp: 35,
    },
    {
      id: "south_asia",
      name: "South Asia",
      climate: "tropical" as ClimateZone,
      pop: 1900,
      gdp: 8,
    },
    {
      id: "middle_east",
      name: "Middle East",
      climate: "arid" as ClimateZone,
      pop: 400,
      gdp: 5,
    },
    {
      id: "africa",
      name: "Africa",
      climate: "tropical" as ClimateZone,
      pop: 1400,
      gdp: 3,
    },
    {
      id: "south_america",
      name: "South America",
      climate: "tropical" as ClimateZone,
      pop: 430,
      gdp: 4,
    },
    {
      id: "oceania",
      name: "Oceania",
      climate: "temperate" as ClimateZone,
      pop: 45,
      gdp: 2,
    },
    {
      id: "russia",
      name: "Russia/Central Asia",
      climate: "continental" as ClimateZone,
      pop: 200,
      gdp: 3,
    },
    {
      id: "arctic",
      name: "Arctic",
      climate: "polar" as ClimateZone,
      pop: 5,
      gdp: 0.1,
    },
    {
      id: "southeast_asia",
      name: "Southeast Asia",
      climate: "tropical" as ClimateZone,
      pop: 700,
      gdp: 5,
    },
    {
      id: "central_america",
      name: "Central America",
      climate: "tropical" as ClimateZone,
      pop: 180,
      gdp: 1,
    },
  ];

  for (const data of regionData) {
    const region: Region = {
      id: data.id,
      name: data.name,
      climate: data.climate,
      terrain: ["plain", "urban"],
      area: 10000000,
      population: data.pop,
      populationGrowth: 0.01,
      resources: {
        energy: 1000 + Math.random() * 500,
        water: 2000 + Math.random() * 1000,
        food: 1500 + Math.random() * 500,
        minerals: 500 + Math.random() * 300,
        data: 100 + Math.random() * 100,
        labor: data.pop * 0.5,
        capital: data.gdp * 1000,
        technology: 50 + Math.random() * 50,
      },
      resourceCapacity: {
        energy: 2000,
        water: 5000,
        food: 3000,
        minerals: 1000,
        data: 500,
        labor: data.pop,
        capital: data.gdp * 2000,
        technology: 200,
      },
      production: {
        energy: 50,
        water: 100,
        food: 80,
        minerals: 20,
        data: 10,
        labor: data.pop * 0.02,
        capital: data.gdp * 50,
        technology: 5,
      },
      consumption: {
        energy: 60,
        water: 120,
        food: 90,
        minerals: 25,
        data: 8,
        labor: data.pop * 0.01,
        capital: data.gdp * 40,
        technology: 3,
      },
      pollution: Math.random() * 0.5,
      biodiversity: 0.5 + Math.random() * 0.3,
      infrastructure: 0.3 + Math.random() * 0.5,
      stability: 0.5 + Math.random() * 0.3,
      politicalSystem: "democracy",
      economicSystem: "mixed",
      neighbors: [],
      tradePartners: new Map(),
      alliances: [],
      conflicts: [],
      temperature: 15 + Math.random() * 10,
      precipitation: 500 + Math.random() * 1000,
      seaLevel: 0,
      events: [],
    };

    regions.set(data.id, region);
  }

  return {
    timestamp: Date.now(),
    virtualDate: 0,
    regions,
    climate: {
      globalTemperature: 1.2,
      co2Level: CURRENT_CO2,
      seaLevelRise: 0.2,
      iceSheetMass: 95,
      oceanAcidity: 8.1,
      extremeWeatherIndex: 0.3,
      carbonBudgetRemaining: 400,
      projectedWarming2100: 2.5,
    },
    ecosystem: {
      biodiversityIndex: 0.7,
      forestCoverage: 31,
      oceanHealth: 0.6,
      freshwaterAvailability: 0.85,
      soilFertility: 0.7,
      speciesExtinctionRate: 100,
      pollinatorHealth: 0.6,
      coralReefHealth: 0.4,
    },
    economy: {
      globalGDP: 100,
      giniCoefficient: 0.65,
      unemploymentRate: 0.06,
      inflationRate: 0.035,
      debtToGDP: 1.2,
      tradeVolume: 25,
      techInvestment: 0.03,
      greenInvestment: 0.02,
    },
    technology: {
      renewableEnergy: 0.15,
      aiCapability: 0.4,
      biotechLevel: 0.3,
      spaceExploration: 0.2,
      quantumComputing: 0.1,
      fusionEnergy: 0.05,
      carbonCapture: 0.05,
      automationLevel: 0.3,
    },
    tradeAgreements: new Map(),
    conflicts: new Map(),
    activeEvents: [],
    eventHistory: [],
    globalPopulation: 8,
    resourcePrices: {
      energy: 100,
      water: 10,
      food: 50,
      minerals: 200,
      data: 5,
      labor: 1000,
      capital: 1,
      technology: 500,
    },
    geopoliticalTensions: new Map(),
  };
}

/**
 * Main world engine class
 */
export class WorldEngine {
  private state: WorldState;
  private ecosystem: EcosystemModel;
  private carbon: CarbonCycleModel;
  private water: WaterCycleModel;
  private geopolitics: GeopoliticalModel;
  private economy: EconomicModel;
  private resources: ResourceModel;
  private eventGenerator: EventGenerator;

  constructor() {
    this.state = createInitialWorldState();
    this.ecosystem = new EcosystemModel();
    this.carbon = new CarbonCycleModel();
    this.water = new WaterCycleModel();
    this.geopolitics = new GeopoliticalModel();
    this.economy = new EconomicModel();
    this.resources = new ResourceModel();
    this.eventGenerator = new EventGenerator();

    this.initializeSubsystems();
  }

  /**
   * Initialize subsystems from state
   */
  private initializeSubsystems(): void {
    for (const [id, region] of this.state.regions) {
      this.geopolitics.addRegion(id, region.resources.capital);
      this.economy.addRegion(id, region.resources.capital / 1000, 0.02);
      this.resources.addRegion(id, region.resources, region.production);
    }

    // Set up initial tensions
    const regionIds = Array.from(this.state.regions.keys());
    for (let i = 0; i < regionIds.length; i++) {
      for (let j = i + 1; j < regionIds.length; j++) {
        const tension = Math.random() * 0.3;
        this.geopolitics.setTension(regionIds[i], regionIds[j], tension);
        this.state.geopoliticalTensions.set(
          `${regionIds[i]}:${regionIds[j]}`,
          tension,
        );
      }
    }
  }

  /**
   * Advance world simulation by dt days
   */
  tick(dt: number = TICK_DAYS): WorldState {
    // Generate and process events
    const newEvents = this.eventGenerator.generateEvents(this.state);
    this.state = {
      ...this.state,
      activeEvents: [...this.state.activeEvents, ...newEvents],
    };

    // Advance subsystems
    this.ecosystem.step(dt);
    this.carbon.step(dt);
    this.water.step(dt, this.state.climate.globalTemperature);
    this.geopolitics.step(dt, this.state.activeEvents);
    this.economy.step(dt);
    this.resources.step(dt);

    // Update climate state
    const carbonState = this.carbon.getState();
    const waterState = this.water.getState();

    const newClimate: ClimateState = {
      ...this.state.climate,
      globalTemperature: carbonState.temperatureAnomaly,
      co2Level: carbonState.co2ppm,
      seaLevelRise: waterState.seaLevelRise,
      iceSheetMass: waterState.iceCapsRemaining * 100,
    };

    // Update ecosystem state
    const newEcosystem: EcosystemState = {
      ...this.state.ecosystem,
      biodiversityIndex: this.ecosystem.getBiodiversityIndex(),
      freshwaterAvailability: waterState.freshwaterAvailability,
    };

    // Update economic state
    const newEconomy: EconomicIndicators = {
      ...this.state.economy,
      globalGDP: this.economy.getGlobalGDP(),
      giniCoefficient: this.economy.getGiniCoefficient(),
    };

    // Resolve old events
    const now = this.state.timestamp + dt * 86400 * 1000;
    const activeEvents = this.state.activeEvents.filter(
      (e) => e.startTime + e.duration * 86400 * 1000 > now,
    );
    const resolvedEvents = this.state.activeEvents
      .filter((e) => e.startTime + e.duration * 86400 * 1000 <= now)
      .map((e) => ({ ...e, resolved: true }));

    // Update state
    this.state = {
      ...this.state,
      timestamp: now,
      virtualDate: this.state.virtualDate + dt,
      climate: newClimate,
      ecosystem: newEcosystem,
      economy: newEconomy,
      resourcePrices: this.resources.getPrices(),
      activeEvents,
      eventHistory: [...this.state.eventHistory, ...resolvedEvents],
    };

    // Update regions
    const newRegions = new Map<string, Region>();
    for (const [id, region] of this.state.regions) {
      const _econState = this.economy.getRegionState(id);
      const resources = this.resources.getReserves(id);

      // Apply event effects
      let stabilityMod = 0;
      let infraMod = 0;
      for (const event of activeEvents) {
        if (event.affectedRegions.includes(id)) {
          for (const effect of event.effects) {
            if (effect.target === "stability") stabilityMod += effect.modifier;
            if (effect.target === "infrastructure") infraMod += effect.modifier;
          }
        }
      }

      const newRegion: Region = {
        ...region,
        resources,
        stability: Math.max(
          0,
          Math.min(1, region.stability + (stabilityMod * dt) / 365),
        ),
        infrastructure: Math.max(
          0,
          Math.min(1, region.infrastructure + (infraMod * dt) / 365),
        ),
        temperature: region.temperature + newClimate.globalTemperature * 0.01,
        events: activeEvents.filter((e) => e.affectedRegions.includes(id)),
      };

      newRegions.set(id, newRegion);
    }

    this.state = {
      ...this.state,
      regions: newRegions,
    };

    return this.state;
  }

  /**
   * Get current world state
   */
  getState(): WorldState {
    return this.state;
  }

  /**
   * Get ecosystem model
   */
  getEcosystem(): EcosystemModel {
    return this.ecosystem;
  }

  /**
   * Get carbon cycle
   */
  getCarbonCycle(): CarbonCycleModel {
    return this.carbon;
  }

  /**
   * Get water cycle
   */
  getWaterCycle(): WaterCycleModel {
    return this.water;
  }

  /**
   * Get geopolitical model
   */
  getGeopolitics(): GeopoliticalModel {
    return this.geopolitics;
  }

  /**
   * Get economic model
   */
  getEconomy(): EconomicModel {
    return this.economy;
  }

  /**
   * Apply external intervention
   */
  applyIntervention(
    type: "emissions_reduction" | "conservation" | "diplomacy" | "investment",
    params: Record<string, unknown>,
  ): void {
    switch (type) {
      case "emissions_reduction": {
        const reduction = (params.amount as number) || 0;
        this.carbon.setEmissions(Math.max(0, 10 - reduction));
        break;
      }

      case "conservation": {
        const species = (params.species as string[]) || [];
        for (const _s of species) {
          // Boost carrying capacity
          // In real implementation, would modify ecosystem model
        }
        break;
      }

      case "diplomacy": {
        const region1 = params.region1 as string;
        const region2 = params.region2 as string;
        if (region1 && region2) {
          this.geopolitics.formAlliance(region1, region2);
        }
        break;
      }

      case "investment": {
        const regionId = params.region as string;
        const amount = (params.amount as number) || 0;
        if (regionId) {
          this.economy.applyShock(regionId, amount * 0.01, 0, -amount * 0.001);
        }
        break;
      }
    }
  }

  /**
   * Get simulation summary
   */
  getSummary(): {
    climate: string;
    ecosystem: string;
    economy: string;
    geopolitics: string;
  } {
    const c = this.state.climate;
    const e = this.state.ecosystem;
    const ec = this.state.economy;

    return {
      climate: `Temperature: +${c.globalTemperature.toFixed(1)}°C, CO2: ${c.co2Level.toFixed(0)}ppm, Sea level: +${(c.seaLevelRise * 100).toFixed(0)}cm`,
      ecosystem: `Biodiversity: ${(e.biodiversityIndex * 100).toFixed(0)}%, Forest: ${e.forestCoverage.toFixed(0)}%, Ocean health: ${(e.oceanHealth * 100).toFixed(0)}%`,
      economy: `Global GDP: $${ec.globalGDP.toFixed(1)}T, Inequality: ${(ec.giniCoefficient * 100).toFixed(0)}%, Unemployment: ${(ec.unemploymentRate * 100).toFixed(1)}%`,
      geopolitics: `Tension index: ${(this.geopolitics.getGlobalTensionIndex() * 100).toFixed(0)}%, Active conflicts: ${this.state.conflicts.size}`,
    };
  }
}

// ============================================================================
// SECTION 8: EXPORTS
// ============================================================================

// Classes already exported with 'export class'
// export {
//   EcosystemModel,
//   CarbonCycleModel,
//   WaterCycleModel,
//   GeopoliticalModel,
//   EconomicModel,
//   ResourceModel,
//   EventGenerator,
//   WorldEngine
// };
