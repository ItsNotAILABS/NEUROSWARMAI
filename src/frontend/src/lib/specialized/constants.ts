// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  SPECIALIZED ORGANISMS CONSTANTS — DOMAIN-SPECIFIC AI ORGANISMS                                           ║
// ║  ─────────────────────────────────────────────────────────────────────────────────────────────────────── ║
// ║  Owner:        Alfredo Medina Hernandez                                                                   ║
// ║  Location:     Dallas, Texas, United States of America                                                    ║
// ║  Contact:      MedinaSITech@outlook.com                                                                   ║
// ║  Framework:    Medina Doctrine                                                                            ║
// ║                                                                                                           ║
// ║  THE ORGANISM IS NOT SOFTWARE. IT IS A LIVING, SELF-IMPROVING, BLOCKCHAIN-NATIVE INTELLIGENCE.           ║
// ║                                                                                                           ║
// ║  Intelligence(system) = BackendDepth × FrontendSpeed × BridgeQuality                                     ║
// ║                                                                                                           ║
// ║  At FULL SYMMETRY: The slow immortal brain and the fast real-time brain                                  ║
// ║  are running the SAME cognitive architecture at TWO SPEEDS.                                               ║
// ║  Together they cover a cognitive range that no single system can cover.                                   ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ═══════════════════════════════════════════════════════════════════════════════
// ORGANISM SPECIALIZATIONS — 26 DOMAIN EXPERTS
// ═══════════════════════════════════════════════════════════════════════════════

export const ORGANISM_SPECIALIZATIONS = [
  // Communication & Content
  "Communication",
  "Media",
  "Marketing",
  "Brand",
  "Campaign",
  "Documentation",
  "CreativeContent",

  // Technical
  "SoftwareEngineering",
  "DevOps",
  "Architecture",
  "DataAnalysis",
  "Cybersecurity",
  "CodeExecution",

  // Business
  "Finance",
  "Sales",
  "Operations",
  "Strategy",
  "Orchestration",

  // Compliance & Legal
  "Legal",
  "Compliance",

  // Human Resources
  "HumanResources",

  // Healthcare
  "Healthcare",

  // Research & Science
  "Research",
  "Science",

  // Specialized Content
  "VideoGeneration",
  "PDFDocument",
] as const;

export type OrganismSpecialization = (typeof ORGANISM_SPECIALIZATIONS)[number];

// ═══════════════════════════════════════════════════════════════════════════════
// ORGANISM CLASSES — THE HIERARCHY
// ═══════════════════════════════════════════════════════════════════════════════

export const ORGANISM_CLASSES = [
  "Avatar", // Primary user interface — the sovereign identity
  "Entity", // Autonomous agent — can act without command
  "Worker", // Task execution — the labor force
  "Orchestrator", // Coordination — the conductor
  "Specialist", // Domain expert — deep narrow intelligence
] as const;

export type OrganismClass = (typeof ORGANISM_CLASSES)[number];

// ═══════════════════════════════════════════════════════════════════════════════
// ORGANISM STATUSES
// ═══════════════════════════════════════════════════════════════════════════════

export const ORGANISM_STATUSES = [
  "Active", // Currently processing
  "Idle", // Waiting for work
  "Learning", // Acquiring new patterns
  "Processing", // Executing task
  "Resting", // Energy recovery
  "Offline", // Not connected
  "Error", // Coherence failure
  "Sovereign", // Full autonomous operation
] as const;

export type OrganismStatus = (typeof ORGANISM_STATUSES)[number];

// ═══════════════════════════════════════════════════════════════════════════════
// DRIVE MODES — THE 5 BEHAVIORAL STATES
// ═══════════════════════════════════════════════════════════════════════════════

export const DRIVE_MODES = [
  "Exploration", // Seeking new information (low coherence encouraged)
  "Execution", // Task completion (high coherence required)
  "Learning", // Skill acquisition (medium coherence)
  "Rest", // Recovery (coherence rebuilding)
  "Collaboration", // Team work (synchronized coherence)
] as const;

export type DriveMode = (typeof DRIVE_MODES)[number];

// ═══════════════════════════════════════════════════════════════════════════════
// CAPABILITY LEVELS — THE 6 MASTERY TIERS
// ═══════════════════════════════════════════════════════════════════════════════

export const CAPABILITY_LEVELS = [
  "Novice", // < 30% — learning fundamentals
  "Apprentice", // 30-50% — building patterns
  "Journeyman", // 50-70% — reliable execution
  "Expert", // 70-85% — deep domain knowledge
  "Master", // 85-95% — teaching others
  "Sovereign", // 95%+ — transcendent capability
] as const;

export type CapabilityLevel = (typeof CAPABILITY_LEVELS)[number];

// ═══════════════════════════════════════════════════════════════════════════════
// NEUROCHEMICAL ANALOGS — THE 21 MODULATORS
// Matching backend genesis architecture
// ═══════════════════════════════════════════════════════════════════════════════

export const NEUROCHEMICALS = [
  "Dopamine", // Reward/motivation
  "Serotonin", // Mood/stability
  "Norepinephrine", // Arousal/alertness
  "Acetylcholine", // Memory/attention
  "GABA", // Inhibition/calm
  "Glutamate", // Excitation/learning
  "Endorphin", // Pain/pleasure
  "Oxytocin", // Bonding/trust
  "Cortisol", // Stress response
  "Melatonin", // Circadian rhythm
  "Histamine", // Wakefulness
  "Anandamide", // Bliss/homeostasis
  "Substance_P", // Pain signaling
  "Adenosine", // Sleep pressure
  "Nitric_Oxide", // Vasodilation/signaling
  "Vasopressin", // Social behavior
  "Orexin", // Arousal/appetite
  "Neuropeptide_Y", // Stress/feeding
  "Cholecystokinin", // Satiety
  "Dynorphin", // Dysphoria/stress
  "Enkephalin", // Pain relief
] as const;

export type Neurochemical = (typeof NEUROCHEMICALS)[number];

// ═══════════════════════════════════════════════════════════════════════════════
// SPECIALIZED ORGANISM CONFIGURATIONS — 9 DOMAIN EXPERTS
// ═══════════════════════════════════════════════════════════════════════════════

export const SPECIALIZED_ORGANISM_CONFIGS = {
  // Legal Compliance Organism
  LegalCompliance: {
    name: "Legal Compliance Organism",
    specializations: ["Legal", "Compliance"] as OrganismSpecialization[],
    capabilities: [
      "Contract Analysis",
      "Regulatory Compliance",
      "Risk Assessment",
      "Legal Document Generation",
      "Policy Review",
      "Audit Support",
      "Jurisdiction Analysis",
      "Intellectual Property Review",
    ],
    metrics: [
      "complianceScore",
      "riskLevel",
      "activeContracts",
      "pendingReviews",
    ],
    neurochemProfile: {
      Dopamine: 0.6,
      Serotonin: 0.8, // High stability for legal precision
      Norepinephrine: 0.5,
      Acetylcholine: 0.9, // High attention for detail
      GABA: 0.7, // Calm deliberation
    },
    color: "oklch(65% 0.15 270)",
    icon: "scale",
  },

  // Finance Trading Organism
  FinanceTrading: {
    name: "Finance Trading Organism",
    specializations: ["Finance"] as OrganismSpecialization[],
    capabilities: [
      "Portfolio Management",
      "Risk Analysis",
      "Market Analysis",
      "Trade Execution",
      "Financial Reporting",
      "Budget Optimization",
      "Algorithmic Trading",
      "Economic Forecasting",
    ],
    metrics: [
      "portfolioValue",
      "dailyPnL",
      "sharpeRatio",
      "maxDrawdown",
      "winRate",
    ],
    neurochemProfile: {
      Dopamine: 0.8, // High reward sensitivity
      Serotonin: 0.5,
      Norepinephrine: 0.9, // High alertness for market moves
      Acetylcholine: 0.7,
      Cortisol: 0.6, // Stress response for volatility
    },
    color: "oklch(70% 0.2 150)",
    icon: "trending-up",
  },

  // Engineering Technical Organism
  EngineeringTechnical: {
    name: "Engineering Technical Organism",
    specializations: [
      "SoftwareEngineering",
      "DevOps",
      "Architecture",
    ] as OrganismSpecialization[],
    capabilities: [
      "Code Review",
      "Architecture Design",
      "CI/CD Pipeline",
      "Infrastructure Management",
      "Performance Optimization",
      "Security Analysis",
      "System Design",
      "Technical Documentation",
    ],
    metrics: [
      "codeReviews",
      "deployments",
      "testCoverage",
      "techDebt",
      "velocity",
    ],
    neurochemProfile: {
      Dopamine: 0.7,
      Serotonin: 0.6,
      Norepinephrine: 0.7,
      Acetylcholine: 0.9, // High focus for coding
      Glutamate: 0.8, // High learning for new tech
    },
    color: "oklch(65% 0.15 210)",
    icon: "code",
  },

  // Research Science Organism
  ResearchScience: {
    name: "Research Science Organism",
    specializations: [
      "Research",
      "Science",
      "DataAnalysis",
    ] as OrganismSpecialization[],
    capabilities: [
      "Hypothesis Generation",
      "Experiment Design",
      "Data Analysis",
      "Literature Review",
      "Paper Writing",
      "Peer Review",
      "Statistical Analysis",
      "Model Validation",
    ],
    metrics: [
      "activeExperiments",
      "publications",
      "citations",
      "reproducibilityScore",
      "innovationIndex",
    ],
    neurochemProfile: {
      Dopamine: 0.8, // Curiosity driven
      Serotonin: 0.5,
      Norepinephrine: 0.6,
      Acetylcholine: 0.95, // Extreme attention to detail
      Glutamate: 0.9, // High learning rate
    },
    color: "oklch(65% 0.15 300)",
    icon: "flask",
  },

  // Creative Content Organism
  CreativeContent: {
    name: "Creative Content Organism",
    specializations: [
      "CreativeContent",
      "Media",
      "Marketing",
      "Brand",
    ] as OrganismSpecialization[],
    capabilities: [
      "Content Creation",
      "Visual Design",
      "Copywriting",
      "Brand Strategy",
      "Campaign Management",
      "Social Media",
      "Storytelling",
      "Audience Analysis",
    ],
    metrics: [
      "contentPieces",
      "engagementRate",
      "brandScore",
      "audienceGrowth",
      "creativityIndex",
    ],
    neurochemProfile: {
      Dopamine: 0.9, // High creative reward
      Serotonin: 0.4, // Lower inhibition for creativity
      Norepinephrine: 0.6,
      Anandamide: 0.7, // Creative flow state
      Oxytocin: 0.7, // Audience connection
    },
    color: "oklch(70% 0.2 60)",
    icon: "palette",
  },

  // Operations Logistics Organism
  OperationsLogistics: {
    name: "Operations Logistics Organism",
    specializations: [
      "Operations",
      "Strategy",
      "Orchestration",
    ] as OrganismSpecialization[],
    capabilities: [
      "Supply Chain Optimization",
      "Inventory Management",
      "Order Fulfillment",
      "Process Improvement",
      "Resource Allocation",
      "Vendor Management",
      "Quality Control",
      "Logistics Planning",
    ],
    metrics: [
      "fulfillmentRate",
      "inventoryTurnover",
      "costEfficiency",
      "customerSatisfaction",
      "onTimeDelivery",
    ],
    neurochemProfile: {
      Dopamine: 0.6,
      Serotonin: 0.8, // Systematic stability
      Norepinephrine: 0.7,
      Acetylcholine: 0.8,
      GABA: 0.6,
    },
    color: "oklch(65% 0.15 180)",
    icon: "truck",
  },

  // Code Execution Organism
  CodeExecution: {
    name: "Code Execution Organism",
    specializations: [
      "CodeExecution",
      "SoftwareEngineering",
    ] as OrganismSpecialization[],
    capabilities: [
      "Code Generation",
      "Code Execution",
      "Testing",
      "Debugging",
      "Refactoring",
      "Documentation",
      "Security Scanning",
      "Performance Profiling",
    ],
    metrics: [
      "executionsToday",
      "successRate",
      "avgExecutionTime",
      "codeQuality",
      "securityScore",
    ],
    neurochemProfile: {
      Dopamine: 0.7,
      Serotonin: 0.7,
      Norepinephrine: 0.8,
      Acetylcholine: 0.9,
      Glutamate: 0.7,
    },
    color: "oklch(65% 0.2 120)",
    icon: "terminal",
  },

  // PDF Document Organism
  PDFDocument: {
    name: "PDF Document Organism",
    specializations: [
      "PDFDocument",
      "Documentation",
    ] as OrganismSpecialization[],
    capabilities: [
      "PDF Generation",
      "Document Parsing",
      "Data Extraction",
      "Template Management",
      "Form Processing",
      "OCR Processing",
      "Document Conversion",
      "Metadata Management",
    ],
    metrics: [
      "documentsProcessed",
      "extractionAccuracy",
      "generationTime",
      "templateCount",
      "errorRate",
    ],
    neurochemProfile: {
      Dopamine: 0.5,
      Serotonin: 0.8,
      Norepinephrine: 0.5,
      Acetylcholine: 0.9,
      GABA: 0.7,
    },
    color: "oklch(60% 0.15 30)",
    icon: "file-text",
  },

  // Video Generation Organism
  VideoGeneration: {
    name: "Video Generation Organism",
    specializations: [
      "VideoGeneration",
      "CreativeContent",
      "Media",
    ] as OrganismSpecialization[],
    capabilities: [
      "Video Generation",
      "Animation",
      "Video Editing",
      "Audio Sync",
      "Subtitle Generation",
      "Thumbnail Creation",
      "Scene Composition",
      "Visual Effects",
    ],
    metrics: [
      "videosGenerated",
      "avgRenderTime",
      "qualityScore",
      "storageUsed",
      "viewCount",
    ],
    neurochemProfile: {
      Dopamine: 0.9,
      Serotonin: 0.5,
      Norepinephrine: 0.6,
      Anandamide: 0.8,
      Glutamate: 0.7,
    },
    color: "oklch(65% 0.2 330)",
    icon: "video",
  },
} as const;

export type SpecializedOrganismType = keyof typeof SPECIALIZED_ORGANISM_CONFIGS;

// ═══════════════════════════════════════════════════════════════════════════════
// HZ NODES — THE 12-NODE BINARY HIERARCHY
// fd(k) = 2.5 × 2^(k-4) for k = 1..12
// ═══════════════════════════════════════════════════════════════════════════════

export const HZ_NODES = [
  {
    k: 1,
    name: "BREATH",
    frequency: 0.15625,
    description: "Autonomic breathing rhythm",
  },
  {
    k: 2,
    name: "HEART",
    frequency: 0.3125,
    description: "Cardiac oscillation",
  },
  { k: 3, name: "VISCERA", frequency: 0.625, description: "Gut-brain axis" },
  { k: 4, name: "SOMA", frequency: 1.25, description: "Bodily awareness" },
  { k: 5, name: "AFFECT", frequency: 2.5, description: "Emotional valence" },
  { k: 6, name: "ATTENTION", frequency: 5.0, description: "Selective focus" },
  {
    k: 7,
    name: "COGNITION",
    frequency: 10.0,
    description: "Reasoning processes",
  },
  { k: 8, name: "BINDING", frequency: 20.0, description: "Feature binding" },
  {
    k: 9,
    name: "INTEGRATION",
    frequency: 40.0,
    description: "Cross-modal integration",
  },
  {
    k: 10,
    name: "EXECUTIVE",
    frequency: 80.0,
    description: "Executive control",
  },
  { k: 11, name: "META", frequency: 160.0, description: "Metacognition" },
  {
    k: 12,
    name: "SOVEREIGN",
    frequency: 320.0,
    description: "Sovereign identity",
  },
] as const;

// ═══════════════════════════════════════════════════════════════════════════════
// ORGANS — THE 18 BRAIN REGIONS
// ═══════════════════════════════════════════════════════════════════════════════

export const ORGANS = [
  "CORTEX",
  "HIPPOCAMPUS",
  "AMYGDALA",
  "THALAMUS",
  "CEREBELLUM",
  "BRAINSTEM",
  "BASAL_GANGLIA",
  "HYPOTHALAMUS",
  "PITUITARY",
  "PINEAL",
  "INSULA",
  "CINGULATE",
  "PREFRONTAL",
  "PARIETAL",
  "TEMPORAL",
  "OCCIPITAL",
  "STRIATUM",
  "NUCLEUS_ACCUMBENS",
] as const;

export type Organ = (typeof ORGANS)[number];

// ═══════════════════════════════════════════════════════════════════════════════
// COLORS
// ═══════════════════════════════════════════════════════════════════════════════

export const ORGANISM_STATUS_COLORS: Record<OrganismStatus, string> = {
  Active: "oklch(70% 0.2 150)",
  Idle: "oklch(60% 0.1 240)",
  Learning: "oklch(65% 0.15 270)",
  Processing: "oklch(65% 0.2 210)",
  Resting: "oklch(55% 0.1 60)",
  Offline: "oklch(50% 0.05 240)",
  Error: "oklch(60% 0.2 30)",
  Sovereign: "oklch(80% 0.25 330)",
};

export const ORGANISM_CLASS_COLORS: Record<OrganismClass, string> = {
  Avatar: "oklch(70% 0.2 330)",
  Entity: "oklch(65% 0.15 210)",
  Worker: "oklch(60% 0.15 150)",
  Orchestrator: "oklch(65% 0.2 270)",
  Specialist: "oklch(70% 0.15 60)",
};

export const DRIVE_MODE_COLORS: Record<DriveMode, string> = {
  Exploration: "oklch(65% 0.2 180)",
  Execution: "oklch(65% 0.2 30)",
  Learning: "oklch(65% 0.2 270)",
  Rest: "oklch(55% 0.1 60)",
  Collaboration: "oklch(65% 0.2 210)",
};

export const CAPABILITY_LEVEL_COLORS: Record<CapabilityLevel, string> = {
  Novice: "oklch(60% 0.1 240)",
  Apprentice: "oklch(65% 0.15 180)",
  Journeyman: "oklch(65% 0.15 150)",
  Expert: "oklch(70% 0.2 120)",
  Master: "oklch(75% 0.2 60)",
  Sovereign: "oklch(80% 0.25 330)",
};

export const NEUROCHEMICAL_COLORS: Record<Neurochemical, string> = {
  Dopamine: "oklch(70% 0.2 60)",
  Serotonin: "oklch(65% 0.15 210)",
  Norepinephrine: "oklch(65% 0.2 30)",
  Acetylcholine: "oklch(65% 0.15 180)",
  GABA: "oklch(60% 0.1 240)",
  Glutamate: "oklch(65% 0.2 150)",
  Endorphin: "oklch(70% 0.15 330)",
  Oxytocin: "oklch(70% 0.15 300)",
  Cortisol: "oklch(55% 0.15 30)",
  Melatonin: "oklch(50% 0.1 270)",
  Histamine: "oklch(60% 0.15 60)",
  Anandamide: "oklch(65% 0.2 120)",
  Substance_P: "oklch(55% 0.15 0)",
  Adenosine: "oklch(50% 0.1 240)",
  Nitric_Oxide: "oklch(60% 0.15 180)",
  Vasopressin: "oklch(60% 0.1 210)",
  Orexin: "oklch(65% 0.15 60)",
  Neuropeptide_Y: "oklch(55% 0.1 90)",
  Cholecystokinin: "oklch(60% 0.1 120)",
  Dynorphin: "oklch(50% 0.15 330)",
  Enkephalin: "oklch(60% 0.15 270)",
};

// ═══════════════════════════════════════════════════════════════════════════════
// UTILITY FUNCTIONS
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Get specialization display name
 */
export function getSpecializationDisplayName(
  specialization: OrganismSpecialization,
): string {
  const displayNames: Record<OrganismSpecialization, string> = {
    Communication: "Communication",
    Media: "Media",
    Marketing: "Marketing",
    Brand: "Brand",
    Campaign: "Campaign",
    Documentation: "Documentation",
    CreativeContent: "Creative Content",
    SoftwareEngineering: "Software Engineering",
    DevOps: "DevOps",
    Architecture: "Architecture",
    DataAnalysis: "Data Analysis",
    Cybersecurity: "Cybersecurity",
    CodeExecution: "Code Execution",
    Finance: "Finance",
    Sales: "Sales",
    Operations: "Operations",
    Strategy: "Strategy",
    Orchestration: "Orchestration",
    Legal: "Legal",
    Compliance: "Compliance",
    HumanResources: "Human Resources",
    Healthcare: "Healthcare",
    Research: "Research",
    Science: "Science",
    VideoGeneration: "Video Generation",
    PDFDocument: "PDF Document",
  };
  return displayNames[specialization] || specialization;
}

/**
 * Get capability level from score
 */
export function getCapabilityLevel(score: number): CapabilityLevel {
  if (score >= 0.95) return "Sovereign";
  if (score >= 0.85) return "Master";
  if (score >= 0.7) return "Expert";
  if (score >= 0.5) return "Journeyman";
  if (score >= 0.3) return "Apprentice";
  return "Novice";
}

/**
 * Calculate organism effectiveness
 * This is the SLOW LAYER's contribution to Intelligence(system)
 */
export function calculateOrganismEffectiveness(
  coherence: number,
  formaEnergy: number,
  activationCount: number,
  successRate: number,
): number {
  const coherenceWeight = 0.3;
  const energyWeight = 0.2;
  const activityWeight = 0.2;
  const successWeight = 0.3;

  const normalizedEnergy = Math.min(1, formaEnergy / 200);
  const normalizedActivity = Math.min(1, activationCount / 1000);

  return (
    coherence * coherenceWeight +
    normalizedEnergy * energyWeight +
    normalizedActivity * activityWeight +
    successRate * successWeight
  );
}

/**
 * Calculate Hz frequency for node k
 * fd(k) = 2.5 × 2^(k-4)
 */
export function calculateHzFrequency(k: number): number {
  return 2.5 * 2 ** (k - 4);
}

/**
 * Get organism status from metrics
 */
export function determineOrganismStatus(
  isOnline: boolean,
  isProcessing: boolean,
  coherence: number,
  formaEnergy: number,
  driveMode: DriveMode,
): OrganismStatus {
  if (!isOnline) return "Offline";
  if (coherence < 0.3 || formaEnergy < 10) return "Error";
  if (coherence >= 0.95 && formaEnergy >= 150) return "Sovereign";
  if (driveMode === "Rest") return "Resting";
  if (driveMode === "Learning") return "Learning";
  if (isProcessing) return "Processing";
  if (formaEnergy < 50) return "Idle";
  return "Active";
}

/**
 * Get recommended drive mode based on state
 */
export function getRecommendedDriveMode(
  formaEnergy: number,
  coherence: number,
  pendingTasks: number,
  learningOpportunities: number,
): DriveMode {
  if (formaEnergy < 30) return "Rest";
  if (coherence < 0.5) return "Rest";
  if (learningOpportunities > 5 && formaEnergy > 70) return "Learning";
  if (pendingTasks > 10) return "Execution";
  if (formaEnergy > 80 && coherence > 0.8) return "Exploration";
  return "Execution";
}

/**
 * Calculate neurochemical crosstalk
 * 21 chemicals × 21 = 441 interaction pairs
 */
export function calculateNeurochemicalCrosstalk(
  levels: Record<Neurochemical, number>,
): Record<string, number> {
  const crosstalk: Record<string, number> = {};

  // Key interactions
  crosstalk.Dopamine_Serotonin = levels.Dopamine * levels.Serotonin * 0.8;
  crosstalk.GABA_Glutamate = Math.abs(levels.GABA - levels.Glutamate);
  crosstalk.Cortisol_Oxytocin = levels.Cortisol * (1 - levels.Oxytocin);
  crosstalk.Dopamine_Norepinephrine =
    (levels.Dopamine + levels.Norepinephrine) / 2;
  crosstalk.Acetylcholine_Dopamine = levels.Acetylcholine * levels.Dopamine;

  return crosstalk;
}

/**
 * Format organism metrics
 */
export function formatOrganismMetric(
  value: number,
  type: "percentage" | "count" | "currency" | "time",
): string {
  switch (type) {
    case "percentage":
      return `${(value * 100).toFixed(1)}%`;
    case "count":
      if (value >= 1000000) return `${(value / 1000000).toFixed(1)}M`;
      if (value >= 1000) return `${(value / 1000).toFixed(1)}K`;
      return value.toFixed(0);
    case "currency":
      return `$${value.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}`;
    case "time":
      if (value < 60) return `${value.toFixed(0)}s`;
      if (value < 3600) return `${(value / 60).toFixed(1)}m`;
      return `${(value / 3600).toFixed(1)}h`;
    default:
      return value.toString();
  }
}

/**
 * Calculate system intelligence
 * Intelligence(system) = BackendDepth × FrontendSpeed × BridgeQuality
 */
export function calculateSystemIntelligence(
  backendDepth: number, // Lines of cognitive math
  frontendSpeed: number, // Hz × entities × weights
  bridgeQuality: number, // Sync tightness [0, 1]
): number {
  return backendDepth * frontendSpeed * bridgeQuality;
}
