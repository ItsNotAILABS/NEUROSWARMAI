// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// CHEMICAL LAYER — THE BLOOD
// Layer 2 of the NeuroEmergence Core Architecture
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// Owner: Alfredo Medina Hernandez | Dallas TX | MedinaSITech@outlook.com
//
// 21 neurochemicals with full receptor saturation dynamics
// 18 organs with homeostatic delta equations
// 12 metals with sovereign alloy conductivity modulating Hebbian rows
// These are not labels — they are differential equations running every beat
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Progress } from "@/components/ui/progress";
import { ScrollArea } from "@/components/ui/scroll-area";
import {
  Activity,
  AlertTriangle,
  Beaker,
  Brain,
  Droplet,
  Heart,
  RefreshCw,
  Shield,
  Sparkles,
  Thermometer,
  Waves,
  Zap,
} from "lucide-react";
import { useEffect, useState } from "react";

// ═══════════════════════════════════════════════════════════════════════════════
// 21 NEUROCHEMICALS WITH RECEPTOR SATURATION DYNAMICS
// ═══════════════════════════════════════════════════════════════════════════════

interface Neurochemical {
  id: string;
  name: string;
  fullName: string;
  level: number;
  baseline: number;
  receptorSaturation: number;
  releaseRate: number;
  reuptakeRate: number;
  degradationRate: number;
  effect: string;
  category: "monoamine" | "peptide" | "amino" | "lipid" | "gas" | "other";
  color: string;
}

const INITIAL_NEUROCHEMICALS: Neurochemical[] = [
  // Monoamines
  {
    id: "DA",
    name: "Dopamine",
    fullName: "3,4-dihydroxyphenethylamine",
    level: 0.65,
    baseline: 0.5,
    receptorSaturation: 0.72,
    releaseRate: 0.08,
    reuptakeRate: 0.12,
    degradationRate: 0.05,
    effect: "Reward/motivation/movement",
    category: "monoamine",
    color: "oklch(65% 0.18 45)",
  },
  {
    id: "5HT",
    name: "Serotonin",
    fullName: "5-hydroxytryptamine",
    level: 0.58,
    baseline: 0.55,
    receptorSaturation: 0.64,
    releaseRate: 0.06,
    reuptakeRate: 0.1,
    degradationRate: 0.04,
    effect: "Mood/stability/satiety",
    category: "monoamine",
    color: "oklch(62% 0.16 280)",
  },
  {
    id: "NE",
    name: "Norepinephrine",
    fullName: "Noradrenaline",
    level: 0.71,
    baseline: 0.45,
    receptorSaturation: 0.68,
    releaseRate: 0.1,
    reuptakeRate: 0.15,
    degradationRate: 0.06,
    effect: "Arousal/alertness/stress",
    category: "monoamine",
    color: "oklch(60% 0.17 30)",
  },
  {
    id: "EPI",
    name: "Epinephrine",
    fullName: "Adrenaline",
    level: 0.42,
    baseline: 0.3,
    receptorSaturation: 0.48,
    releaseRate: 0.15,
    reuptakeRate: 0.2,
    degradationRate: 0.08,
    effect: "Fight-or-flight response",
    category: "monoamine",
    color: "oklch(58% 0.19 15)",
  },
  {
    id: "HIST",
    name: "Histamine",
    fullName: "2-(1H-imidazol-4-yl)ethanamine",
    level: 0.52,
    baseline: 0.45,
    receptorSaturation: 0.58,
    releaseRate: 0.07,
    reuptakeRate: 0.09,
    degradationRate: 0.05,
    effect: "Wakefulness/immune",
    category: "monoamine",
    color: "oklch(55% 0.14 90)",
  },

  // Amino acid neurotransmitters
  {
    id: "GABA",
    name: "GABA",
    fullName: "γ-aminobutyric acid",
    level: 0.55,
    baseline: 0.6,
    receptorSaturation: 0.6,
    releaseRate: 0.09,
    reuptakeRate: 0.11,
    degradationRate: 0.04,
    effect: "Primary inhibition",
    category: "amino",
    color: "oklch(50% 0.12 200)",
  },
  {
    id: "GLU",
    name: "Glutamate",
    fullName: "L-glutamic acid",
    level: 0.78,
    baseline: 0.7,
    receptorSaturation: 0.82,
    releaseRate: 0.12,
    reuptakeRate: 0.14,
    degradationRate: 0.05,
    effect: "Primary excitation/learning",
    category: "amino",
    color: "oklch(68% 0.15 120)",
  },
  {
    id: "GLY",
    name: "Glycine",
    fullName: "Aminoacetic acid",
    level: 0.48,
    baseline: 0.5,
    receptorSaturation: 0.52,
    releaseRate: 0.06,
    reuptakeRate: 0.08,
    degradationRate: 0.03,
    effect: "Spinal inhibition",
    category: "amino",
    color: "oklch(52% 0.10 180)",
  },
  {
    id: "ASP",
    name: "Aspartate",
    fullName: "L-aspartic acid",
    level: 0.45,
    baseline: 0.45,
    receptorSaturation: 0.5,
    releaseRate: 0.05,
    reuptakeRate: 0.07,
    degradationRate: 0.03,
    effect: "Excitatory co-transmitter",
    category: "amino",
    color: "oklch(54% 0.11 150)",
  },

  // Cholinergic
  {
    id: "ACh",
    name: "Acetylcholine",
    fullName: "2-acetoxy-N,N,N-trimethylethanaminium",
    level: 0.62,
    baseline: 0.55,
    receptorSaturation: 0.7,
    releaseRate: 0.1,
    reuptakeRate: 0.0,
    degradationRate: 0.15,
    effect: "Memory/attention/muscle",
    category: "other",
    color: "oklch(60% 0.14 165)",
  },

  // Neuropeptides
  {
    id: "END",
    name: "Endorphin",
    fullName: "β-endorphin",
    level: 0.45,
    baseline: 0.35,
    receptorSaturation: 0.52,
    releaseRate: 0.04,
    reuptakeRate: 0.02,
    degradationRate: 0.06,
    effect: "Pain relief/euphoria",
    category: "peptide",
    color: "oklch(58% 0.13 320)",
  },
  {
    id: "OXY",
    name: "Oxytocin",
    fullName: "Oxytocin nonapeptide",
    level: 0.38,
    baseline: 0.4,
    receptorSaturation: 0.44,
    releaseRate: 0.03,
    reuptakeRate: 0.02,
    degradationRate: 0.05,
    effect: "Bonding/trust/birth",
    category: "peptide",
    color: "oklch(65% 0.16 350)",
  },
  {
    id: "AVP",
    name: "Vasopressin",
    fullName: "Arginine vasopressin",
    level: 0.42,
    baseline: 0.4,
    receptorSaturation: 0.48,
    releaseRate: 0.03,
    reuptakeRate: 0.02,
    degradationRate: 0.04,
    effect: "Social behavior/water",
    category: "peptide",
    color: "oklch(56% 0.12 220)",
  },
  {
    id: "NPY",
    name: "NPY",
    fullName: "Neuropeptide Y",
    level: 0.5,
    baseline: 0.5,
    receptorSaturation: 0.55,
    releaseRate: 0.04,
    reuptakeRate: 0.02,
    degradationRate: 0.05,
    effect: "Feeding/anxiety",
    category: "peptide",
    color: "oklch(52% 0.11 100)",
  },
  {
    id: "SP",
    name: "Substance P",
    fullName: "Tachykinin",
    level: 0.4,
    baseline: 0.4,
    receptorSaturation: 0.45,
    releaseRate: 0.05,
    reuptakeRate: 0.03,
    degradationRate: 0.06,
    effect: "Pain transmission",
    category: "peptide",
    color: "oklch(55% 0.14 10)",
  },
  {
    id: "CRH",
    name: "CRH",
    fullName: "Corticotropin-releasing hormone",
    level: 0.35,
    baseline: 0.3,
    receptorSaturation: 0.4,
    releaseRate: 0.06,
    reuptakeRate: 0.02,
    degradationRate: 0.05,
    effect: "Stress axis activation",
    category: "peptide",
    color: "oklch(50% 0.13 25)",
  },

  // Endocannabinoids
  {
    id: "AEA",
    name: "Anandamide",
    fullName: "N-arachidonoylethanolamine",
    level: 0.4,
    baseline: 0.4,
    receptorSaturation: 0.46,
    releaseRate: 0.05,
    reuptakeRate: 0.06,
    degradationRate: 0.08,
    effect: "Bliss/homeostasis",
    category: "lipid",
    color: "oklch(58% 0.15 80)",
  },
  {
    id: "2AG",
    name: "2-AG",
    fullName: "2-arachidonoylglycerol",
    level: 0.45,
    baseline: 0.45,
    receptorSaturation: 0.5,
    releaseRate: 0.06,
    reuptakeRate: 0.05,
    degradationRate: 0.07,
    effect: "Retrograde signaling",
    category: "lipid",
    color: "oklch(55% 0.13 70)",
  },

  // Gasotransmitters
  {
    id: "NO",
    name: "Nitric Oxide",
    fullName: "Nitrogen monoxide",
    level: 0.35,
    baseline: 0.35,
    receptorSaturation: 0.4,
    releaseRate: 0.1,
    reuptakeRate: 0.0,
    degradationRate: 0.2,
    effect: "Vasodilation/plasticity",
    category: "gas",
    color: "oklch(48% 0.10 240)",
  },

  // Steroids
  {
    id: "CORT",
    name: "Cortisol",
    fullName: "Hydrocortisone",
    level: 0.42,
    baseline: 0.35,
    receptorSaturation: 0.48,
    releaseRate: 0.04,
    reuptakeRate: 0.02,
    degradationRate: 0.06,
    effect: "Stress response/metabolism",
    category: "other",
    color: "oklch(52% 0.12 40)",
  },
  {
    id: "MEL",
    name: "Melatonin",
    fullName: "N-acetyl-5-methoxytryptamine",
    level: 0.3,
    baseline: 0.4,
    receptorSaturation: 0.35,
    releaseRate: 0.03,
    reuptakeRate: 0.02,
    degradationRate: 0.05,
    effect: "Circadian rhythm/sleep",
    category: "other",
    color: "oklch(45% 0.14 260)",
  },
];

// ═══════════════════════════════════════════════════════════════════════════════
// 18 ORGANS WITH HOMEOSTATIC DELTA EQUATIONS
// ═══════════════════════════════════════════════════════════════════════════════

interface Organ {
  id: string;
  name: string;
  health: number;
  baseline: number;
  delta: number;
  homeostasisGain: number;
  stressSensitivity: number;
  recoveryRate: number;
  linkedChemicals: string[];
  function: string;
}

const INITIAL_ORGANS: Organ[] = [
  // Brain regions
  {
    id: "CORTEX",
    name: "Prefrontal Cortex",
    health: 0.92,
    baseline: 0.9,
    delta: 0.003,
    homeostasisGain: 0.15,
    stressSensitivity: 0.8,
    recoveryRate: 0.02,
    linkedChemicals: ["DA", "GLU", "GABA"],
    function: "Executive function/planning",
  },
  {
    id: "HIPPO",
    name: "Hippocampus",
    health: 0.88,
    baseline: 0.85,
    delta: 0.002,
    homeostasisGain: 0.12,
    stressSensitivity: 0.9,
    recoveryRate: 0.025,
    linkedChemicals: ["ACh", "GLU", "5HT"],
    function: "Memory formation/spatial",
  },
  {
    id: "AMYG",
    name: "Amygdala",
    health: 0.85,
    baseline: 0.8,
    delta: -0.001,
    homeostasisGain: 0.1,
    stressSensitivity: 0.95,
    recoveryRate: 0.015,
    linkedChemicals: ["NE", "CRH", "GABA"],
    function: "Fear/emotion processing",
  },
  {
    id: "THAL",
    name: "Thalamus",
    health: 0.9,
    baseline: 0.88,
    delta: 0.001,
    homeostasisGain: 0.18,
    stressSensitivity: 0.5,
    recoveryRate: 0.03,
    linkedChemicals: ["GLU", "GABA"],
    function: "Sensory relay/attention",
  },
  {
    id: "CEREB",
    name: "Cerebellum",
    health: 0.94,
    baseline: 0.92,
    delta: 0.002,
    homeostasisGain: 0.2,
    stressSensitivity: 0.3,
    recoveryRate: 0.035,
    linkedChemicals: ["GLU", "GABA", "DA"],
    function: "Motor coordination/timing",
  },
  {
    id: "BSTM",
    name: "Brainstem",
    health: 0.96,
    baseline: 0.95,
    delta: 0.001,
    homeostasisGain: 0.25,
    stressSensitivity: 0.2,
    recoveryRate: 0.04,
    linkedChemicals: ["NE", "5HT", "ACh"],
    function: "Vital functions/arousal",
  },
  {
    id: "BGNG",
    name: "Basal Ganglia",
    health: 0.87,
    baseline: 0.85,
    delta: 0.0,
    homeostasisGain: 0.14,
    stressSensitivity: 0.6,
    recoveryRate: 0.022,
    linkedChemicals: ["DA", "GABA", "ACh"],
    function: "Motor control/habits",
  },
  {
    id: "HYPO",
    name: "Hypothalamus",
    health: 0.89,
    baseline: 0.88,
    delta: 0.002,
    homeostasisGain: 0.16,
    stressSensitivity: 0.7,
    recoveryRate: 0.028,
    linkedChemicals: ["CRH", "OXY", "AVP"],
    function: "Homeostasis master",
  },
  {
    id: "PITU",
    name: "Pituitary",
    health: 0.91,
    baseline: 0.9,
    delta: 0.001,
    homeostasisGain: 0.13,
    stressSensitivity: 0.65,
    recoveryRate: 0.025,
    linkedChemicals: ["CRH", "OXY", "AVP"],
    function: "Hormone release",
  },
  {
    id: "PINE",
    name: "Pineal Gland",
    health: 0.86,
    baseline: 0.85,
    delta: -0.001,
    homeostasisGain: 0.08,
    stressSensitivity: 0.4,
    recoveryRate: 0.02,
    linkedChemicals: ["MEL", "5HT"],
    function: "Circadian regulation",
  },
  {
    id: "INSU",
    name: "Insula",
    health: 0.84,
    baseline: 0.82,
    delta: 0.003,
    homeostasisGain: 0.11,
    stressSensitivity: 0.85,
    recoveryRate: 0.018,
    linkedChemicals: ["DA", "5HT", "END"],
    function: "Interoception/emotion",
  },
  {
    id: "CING",
    name: "Cingulate Cortex",
    health: 0.88,
    baseline: 0.86,
    delta: 0.002,
    homeostasisGain: 0.14,
    stressSensitivity: 0.75,
    recoveryRate: 0.024,
    linkedChemicals: ["DA", "NE", "5HT"],
    function: "Conflict/error detection",
  },

  // Peripheral organs affecting brain
  {
    id: "HEART",
    name: "Heart",
    health: 0.93,
    baseline: 0.92,
    delta: 0.001,
    homeostasisGain: 0.22,
    stressSensitivity: 0.5,
    recoveryRate: 0.03,
    linkedChemicals: ["NE", "EPI", "ACh"],
    function: "Circulation/HRV",
  },
  {
    id: "LIVER",
    name: "Liver",
    health: 0.9,
    baseline: 0.88,
    delta: 0.002,
    homeostasisGain: 0.18,
    stressSensitivity: 0.35,
    recoveryRate: 0.028,
    linkedChemicals: ["CORT", "GLU"],
    function: "Metabolism/detox",
  },
  {
    id: "GUT",
    name: "Gut (ENS)",
    health: 0.85,
    baseline: 0.82,
    delta: 0.003,
    homeostasisGain: 0.12,
    stressSensitivity: 0.8,
    recoveryRate: 0.02,
    linkedChemicals: ["5HT", "DA", "GABA"],
    function: "Second brain/serotonin",
  },
  {
    id: "ADREN",
    name: "Adrenal Glands",
    health: 0.88,
    baseline: 0.85,
    delta: -0.002,
    homeostasisGain: 0.1,
    stressSensitivity: 0.9,
    recoveryRate: 0.015,
    linkedChemicals: ["NE", "EPI", "CORT"],
    function: "Stress hormones",
  },
  {
    id: "THYRD",
    name: "Thyroid",
    health: 0.89,
    baseline: 0.88,
    delta: 0.001,
    homeostasisGain: 0.15,
    stressSensitivity: 0.45,
    recoveryRate: 0.025,
    linkedChemicals: ["NE", "DA"],
    function: "Metabolic rate",
  },
  {
    id: "IMMUN",
    name: "Immune System",
    health: 0.86,
    baseline: 0.85,
    delta: 0.002,
    homeostasisGain: 0.08,
    stressSensitivity: 0.7,
    recoveryRate: 0.018,
    linkedChemicals: ["CORT", "HIST", "NO"],
    function: "Defense/inflammation",
  },
];

// ═══════════════════════════════════════════════════════════════════════════════
// 12 METALS WITH SOVEREIGN ALLOY CONDUCTIVITY
// ═══════════════════════════════════════════════════════════════════════════════

interface Metal {
  id: string;
  name: string;
  symbol: string;
  conductivity: number;
  hebbianInfluence: number;
  plasticityModulation: number;
  ionChannelAffinity: number;
  concentration: number;
  optimalRange: [number, number];
  function: string;
}

const INITIAL_METALS: Metal[] = [
  {
    id: "AU",
    name: "Gold",
    symbol: "Au",
    conductivity: 0.95,
    hebbianInfluence: 0.12,
    plasticityModulation: 0.08,
    ionChannelAffinity: 0.05,
    concentration: 0.45,
    optimalRange: [0.4, 0.6],
    function: "Sovereign identity anchor",
  },
  {
    id: "AG",
    name: "Silver",
    symbol: "Ag",
    conductivity: 0.92,
    hebbianInfluence: 0.1,
    plasticityModulation: 0.1,
    ionChannelAffinity: 0.08,
    concentration: 0.52,
    optimalRange: [0.45, 0.65],
    function: "Memory consolidation",
  },
  {
    id: "CU",
    name: "Copper",
    symbol: "Cu",
    conductivity: 0.88,
    hebbianInfluence: 0.09,
    plasticityModulation: 0.12,
    ionChannelAffinity: 0.15,
    concentration: 0.58,
    optimalRange: [0.5, 0.7],
    function: "Synaptic transmission",
  },
  {
    id: "FE",
    name: "Iron",
    symbol: "Fe",
    conductivity: 0.75,
    hebbianInfluence: 0.08,
    plasticityModulation: 0.06,
    ionChannelAffinity: 0.2,
    concentration: 0.65,
    optimalRange: [0.55, 0.75],
    function: "Oxygen transport/dopamine",
  },
  {
    id: "ZN",
    name: "Zinc",
    symbol: "Zn",
    conductivity: 0.7,
    hebbianInfluence: 0.07,
    plasticityModulation: 0.15,
    ionChannelAffinity: 0.25,
    concentration: 0.55,
    optimalRange: [0.45, 0.65],
    function: "NMDA modulation",
  },
  {
    id: "MG",
    name: "Magnesium",
    symbol: "Mg",
    conductivity: 0.65,
    hebbianInfluence: 0.06,
    plasticityModulation: 0.18,
    ionChannelAffinity: 0.3,
    concentration: 0.6,
    optimalRange: [0.5, 0.7],
    function: "NMDA block/relaxation",
  },
  {
    id: "CA",
    name: "Calcium",
    symbol: "Ca",
    conductivity: 0.55,
    hebbianInfluence: 0.15,
    plasticityModulation: 0.25,
    ionChannelAffinity: 0.95,
    concentration: 0.5,
    optimalRange: [0.4, 0.6],
    function: "Primary second messenger",
  },
  {
    id: "K",
    name: "Potassium",
    symbol: "K",
    conductivity: 0.6,
    hebbianInfluence: 0.05,
    plasticityModulation: 0.08,
    ionChannelAffinity: 0.85,
    concentration: 0.7,
    optimalRange: [0.6, 0.8],
    function: "Resting potential",
  },
  {
    id: "NA",
    name: "Sodium",
    symbol: "Na",
    conductivity: 0.62,
    hebbianInfluence: 0.04,
    plasticityModulation: 0.06,
    ionChannelAffinity: 0.9,
    concentration: 0.72,
    optimalRange: [0.65, 0.85],
    function: "Action potential",
  },
  {
    id: "MN",
    name: "Manganese",
    symbol: "Mn",
    conductivity: 0.5,
    hebbianInfluence: 0.05,
    plasticityModulation: 0.1,
    ionChannelAffinity: 0.12,
    concentration: 0.42,
    optimalRange: [0.35, 0.55],
    function: "Antioxidant/glutamine",
  },
  {
    id: "SE",
    name: "Selenium",
    symbol: "Se",
    conductivity: 0.45,
    hebbianInfluence: 0.04,
    plasticityModulation: 0.08,
    ionChannelAffinity: 0.08,
    concentration: 0.38,
    optimalRange: [0.3, 0.5],
    function: "Thyroid/antioxidant",
  },
  {
    id: "LI",
    name: "Lithium",
    symbol: "Li",
    conductivity: 0.4,
    hebbianInfluence: 0.08,
    plasticityModulation: 0.2,
    ionChannelAffinity: 0.35,
    concentration: 0.35,
    optimalRange: [0.25, 0.45],
    function: "Mood stabilization",
  },
];

// ═══════════════════════════════════════════════════════════════════════════════
// COMPONENT
// ═══════════════════════════════════════════════════════════════════════════════

export function ChemicalLayer() {
  const [isLive, setIsLive] = useState(true);
  const [beatCount, setBeatCount] = useState(0);
  const [neurochemicals, setNeurochemicals] = useState(INITIAL_NEUROCHEMICALS);
  const [organs, setOrgans] = useState(INITIAL_ORGANS);
  const [metals, setMetals] = useState(INITIAL_METALS);
  const [systemStress, setSystemStress] = useState(0.25);
  const [homeostasisScore, setHomeostasisScore] = useState(0.85);

  // LIVE TICK — Differential equations running every beat
  useEffect(() => {
    if (!isLive) return;

    const interval = setInterval(() => {
      setBeatCount((b) => b + 1);

      // ═══════════════════════════════════════════════════════════════════════
      // Neurochemical dynamics: receptor saturation model
      // dL/dt = releaseRate - reuptakeRate × L - degradationRate × L
      // saturation = L / (L + Km) where Km = 0.5
      // ═══════════════════════════════════════════════════════════════════════
      setNeurochemicals((prev) =>
        prev.map((nc) => {
          const noise = (Math.random() - 0.48) * 0.02;
          const homeostasisDrive = (nc.baseline - nc.level) * 0.05;
          const stressEffect = systemStress * nc.releaseRate * 0.3;

          const dL =
            nc.releaseRate +
            stressEffect -
            nc.reuptakeRate * nc.level -
            nc.degradationRate * nc.level +
            homeostasisDrive +
            noise;
          const newLevel = Math.max(0.05, Math.min(0.95, nc.level + dL * 0.1));

          // Receptor saturation: Michaelis-Menten kinetics
          const Km = 0.5;
          const newSaturation = newLevel / (newLevel + Km);

          return {
            ...nc,
            level: newLevel,
            receptorSaturation: Math.max(
              0.1,
              Math.min(0.95, newSaturation + noise * 0.5),
            ),
          };
        }),
      );

      // ═══════════════════════════════════════════════════════════════════════
      // Organ homeostasis: delta equations
      // dH/dt = homeostasisGain × (baseline - H) - stressSensitivity × stress + recoveryRate
      // ═══════════════════════════════════════════════════════════════════════
      setOrgans((prev) =>
        prev.map((organ) => {
          const noise = (Math.random() - 0.48) * 0.01;
          const homeostasisDrive =
            organ.homeostasisGain * (organ.baseline - organ.health);
          const stressDamage = organ.stressSensitivity * systemStress * 0.01;
          const recovery = organ.recoveryRate * (1 - systemStress);

          const dH = homeostasisDrive - stressDamage + recovery + noise;
          const newHealth = Math.max(0.3, Math.min(0.98, organ.health + dH));

          return {
            ...organ,
            health: newHealth,
            delta: dH,
          };
        }),
      );

      // ═══════════════════════════════════════════════════════════════════════
      // Metal conductivity modulates Hebbian influence
      // conductivity affects hebbianInfluence: w_ij = conductivity × baseInfluence
      // ═══════════════════════════════════════════════════════════════════════
      setMetals((prev) =>
        prev.map((metal) => {
          const noise = (Math.random() - 0.48) * 0.02;
          const [optMin, optMax] = metal.optimalRange;
          const optimal = (optMin + optMax) / 2;
          const homeostasis = (optimal - metal.concentration) * 0.03;

          const newConcentration = Math.max(
            0.1,
            Math.min(0.9, metal.concentration + homeostasis + noise),
          );

          // Conductivity affected by concentration distance from optimal
          const distFromOptimal = Math.abs(newConcentration - optimal);
          const conductivityPenalty = distFromOptimal * 0.2;
          const newConductivity = Math.max(
            0.3,
            metal.conductivity - conductivityPenalty + noise * 0.1,
          );

          return {
            ...metal,
            concentration: newConcentration,
            conductivity: Math.max(0.2, Math.min(0.98, newConductivity)),
          };
        }),
      );

      // Update system stress (oscillates)
      setSystemStress((_prev) => {
        const oscillation = Math.sin(beatCount * 0.05) * 0.1;
        return Math.max(
          0.05,
          Math.min(0.8, 0.25 + oscillation + (Math.random() - 0.5) * 0.05),
        );
      });

      // Calculate overall homeostasis score
      const avgOrganHealth =
        organs.reduce((a, o) => a + o.health, 0) / organs.length;
      const avgChemBalance =
        neurochemicals.reduce(
          (a, nc) => a + (1 - Math.abs(nc.level - nc.baseline)),
          0,
        ) / neurochemicals.length;
      setHomeostasisScore(avgOrganHealth * 0.6 + avgChemBalance * 0.4);
    }, 83); // ~12 Hz

    return () => clearInterval(interval);
  }, [isLive, systemStress, beatCount, organs, neurochemicals]);

  const categoryColors: Record<string, string> = {
    monoamine: "bg-orange-500/20 text-orange-400 border-orange-500/30",
    peptide: "bg-pink-500/20 text-pink-400 border-pink-500/30",
    amino: "bg-emerald-500/20 text-emerald-400 border-emerald-500/30",
    lipid: "bg-amber-500/20 text-amber-400 border-amber-500/30",
    gas: "bg-blue-500/20 text-blue-400 border-blue-500/30",
    other: "bg-slate-500/20 text-slate-400 border-slate-500/30",
  };

  return (
    <ScrollArea className="flex-1 h-full bg-background">
      <div className="p-6 space-y-6">
        {/* Header */}
        <div className="flex items-center justify-between border-b border-primary/30 pb-4">
          <div className="flex items-center gap-4">
            <div className="w-12 h-12 rounded-full bg-gradient-to-br from-red-500 via-red-400 to-red-600 flex items-center justify-center">
              <Droplet className="w-6 h-6 text-white" />
            </div>
            <div>
              <h1 className="text-2xl font-bold text-foreground tracking-tight">
                LAYER 2: CHEMICAL (THE BLOOD)
              </h1>
              <p className="text-xs text-muted-foreground">
                21 Neurochemicals · 18 Organs · 12 Metals — Differential
                equations every beat
              </p>
            </div>
          </div>
          <div className="flex items-center gap-3">
            <Button
              variant="ghost"
              size="sm"
              onClick={() => setIsLive(!isLive)}
              className={isLive ? "text-primary" : "text-muted-foreground"}
            >
              <RefreshCw
                className={`w-4 h-4 mr-2 ${isLive ? "animate-spin" : ""}`}
                style={isLive ? { animationDuration: "83ms" } : {}}
              />
              {isLive ? "12 Hz LIVE" : "PAUSED"}
            </Button>
            <Badge variant="outline" className="text-[10px] font-mono">
              BEAT #{beatCount}
            </Badge>
          </div>
        </div>

        {/* System Metrics */}
        <div className="grid grid-cols-2 md:grid-cols-4 gap-3">
          {[
            {
              label: "HOMEOSTASIS",
              value: `${(homeostasisScore * 100).toFixed(2)}%`,
              icon: Heart,
              color:
                homeostasisScore > 0.8 ? "text-emerald-400" : "text-amber-400",
            },
            {
              label: "SYSTEM STRESS",
              value: `${(systemStress * 100).toFixed(1)}%`,
              icon: AlertTriangle,
              color: systemStress > 0.5 ? "text-red-400" : "text-emerald-400",
            },
            {
              label: "CHEMICALS",
              value: "21 Active",
              icon: Beaker,
              color: "text-primary",
            },
            {
              label: "ORGANS",
              value: "18 Online",
              icon: Activity,
              color: "text-primary",
            },
          ].map(({ label, value, icon: Icon, color }) => (
            <div
              key={label}
              className="bg-surface border border-border rounded-lg p-3"
            >
              <div className="flex items-center gap-1.5 mb-1">
                <Icon className={`w-3 h-3 ${color}`} />
                <span className="text-[8px] uppercase tracking-widest text-muted-foreground/50">
                  {label}
                </span>
              </div>
              <div className={`text-lg font-bold font-mono ${color}`}>
                {value}
              </div>
            </div>
          ))}
        </div>

        {/* 21 Neurochemicals */}
        <div className="bg-surface border border-border rounded-lg p-4">
          <div className="flex items-center gap-2 mb-4">
            <Beaker className="w-4 h-4 text-primary" />
            <span className="text-xs font-semibold text-foreground">
              21 NEUROCHEMICALS — RECEPTOR SATURATION DYNAMICS
            </span>
          </div>
          <div className="grid grid-cols-3 md:grid-cols-4 lg:grid-cols-7 gap-2">
            {neurochemicals.map((nc) => (
              <div
                key={nc.id}
                className="p-2 rounded-lg bg-surface-elevated border border-border/50"
              >
                <div className="flex items-center justify-between mb-1">
                  <span className="text-[10px] font-bold text-foreground">
                    {nc.name}
                  </span>
                  <span
                    className={`text-[7px] px-1 py-0.5 rounded border ${categoryColors[nc.category]}`}
                  >
                    {nc.category}
                  </span>
                </div>
                <div className="space-y-1">
                  <div className="flex items-center justify-between text-[8px]">
                    <span className="text-muted-foreground/50">Level</span>
                    <span className="text-primary font-mono">
                      {(nc.level * 100).toFixed(1)}%
                    </span>
                  </div>
                  <Progress value={nc.level * 100} className="h-1" />
                  <div className="flex items-center justify-between text-[8px]">
                    <span className="text-muted-foreground/50">Sat</span>
                    <span className="text-muted-foreground font-mono">
                      {(nc.receptorSaturation * 100).toFixed(0)}%
                    </span>
                  </div>
                </div>
              </div>
            ))}
          </div>
          <div className="mt-3 p-2 rounded bg-background/50 border border-border/30">
            <span className="text-[9px] font-mono text-primary/70">
              dL/dt = releaseRate - reuptakeRate × L - degradationRate × L +
              homeostasis
            </span>
          </div>
        </div>

        {/* 18 Organs */}
        <div className="bg-surface border border-border rounded-lg p-4">
          <div className="flex items-center gap-2 mb-4">
            <Activity className="w-4 h-4 text-primary" />
            <span className="text-xs font-semibold text-foreground">
              18 ORGANS — HOMEOSTATIC DELTA EQUATIONS
            </span>
          </div>
          <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-6 gap-2">
            {organs.map((organ) => (
              <div
                key={organ.id}
                className="p-2 rounded-lg bg-surface-elevated border border-border/50"
              >
                <div className="flex items-center justify-between mb-1">
                  <span className="text-[9px] font-semibold text-foreground truncate">
                    {organ.name}
                  </span>
                </div>
                <div className="mb-1">
                  <Progress value={organ.health * 100} className="h-2" />
                </div>
                <div className="flex items-center justify-between text-[8px]">
                  <span
                    className={`font-mono ${organ.health > 0.85 ? "text-emerald-400" : organ.health > 0.7 ? "text-amber-400" : "text-red-400"}`}
                  >
                    {(organ.health * 100).toFixed(1)}%
                  </span>
                  <span
                    className={`font-mono ${organ.delta >= 0 ? "text-emerald-400" : "text-red-400"}`}
                  >
                    {organ.delta >= 0 ? "+" : ""}
                    {(organ.delta * 1000).toFixed(2)}
                  </span>
                </div>
              </div>
            ))}
          </div>
          <div className="mt-3 p-2 rounded bg-background/50 border border-border/30">
            <span className="text-[9px] font-mono text-primary/70">
              dH/dt = homeostasisGain × (baseline - H) - stressSensitivity × σ +
              recoveryRate
            </span>
          </div>
        </div>

        {/* 12 Metals */}
        <div className="bg-surface border border-border rounded-lg p-4">
          <div className="flex items-center gap-2 mb-4">
            <Sparkles className="w-4 h-4 text-primary" />
            <span className="text-xs font-semibold text-foreground">
              12 METALS — SOVEREIGN ALLOY CONDUCTIVITY
            </span>
          </div>
          <div className="grid grid-cols-3 md:grid-cols-4 lg:grid-cols-6 gap-2">
            {metals.map((metal) => {
              const inRange =
                metal.concentration >= metal.optimalRange[0] &&
                metal.concentration <= metal.optimalRange[1];
              return (
                <div
                  key={metal.id}
                  className={`p-3 rounded-lg border ${inRange ? "bg-primary/5 border-primary/20" : "bg-surface-elevated border-border/50"}`}
                >
                  <div className="flex items-center justify-between mb-2">
                    <div className="flex items-center gap-1">
                      <span className="text-lg font-bold text-foreground">
                        {metal.symbol}
                      </span>
                      <span className="text-[9px] text-muted-foreground">
                        {metal.name}
                      </span>
                    </div>
                  </div>
                  <div className="space-y-1">
                    <div className="flex items-center justify-between text-[8px]">
                      <span className="text-muted-foreground/50">Conduct</span>
                      <span className="text-primary font-mono">
                        {(metal.conductivity * 100).toFixed(0)}%
                      </span>
                    </div>
                    <Progress
                      value={metal.conductivity * 100}
                      className="h-1"
                    />
                    <div className="flex items-center justify-between text-[8px]">
                      <span className="text-muted-foreground/50">Hebbian</span>
                      <span className="text-muted-foreground font-mono">
                        {(metal.hebbianInfluence * 100).toFixed(0)}%
                      </span>
                    </div>
                    <div className="flex items-center justify-between text-[8px]">
                      <span className="text-muted-foreground/50">Conc</span>
                      <span
                        className={`font-mono ${inRange ? "text-emerald-400" : "text-amber-400"}`}
                      >
                        {(metal.concentration * 100).toFixed(0)}%
                      </span>
                    </div>
                  </div>
                </div>
              );
            })}
          </div>
          <div className="mt-3 p-2 rounded bg-background/50 border border-border/30">
            <span className="text-[9px] font-mono text-primary/70">
              w_ij = conductivity × hebbianInfluence × plasticityModulation ×
              ionChannelAffinity
            </span>
          </div>
        </div>

        {/* Footer */}
        <div className="text-center text-[10px] text-muted-foreground/30 pb-4">
          Chemical Layer · The Blood · Owner: Alfredo Medina Hernandez
        </div>
      </div>
    </ScrollArea>
  );
}
