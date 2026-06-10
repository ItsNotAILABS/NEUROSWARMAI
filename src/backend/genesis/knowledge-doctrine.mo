// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  INTELLECTUAL PROPERTY NOTICE                                                                             ║
// ║  ─────────────────────────────────────────────────────────────────────────────────────────────────────── ║
// ║  Owner:        Alfredo Medina Hernandez                                                                   ║
// ║  Location:     Dallas, Texas, United States of America                                                    ║
// ║  Contact:      MedinaSITech@outlook.com                                                                   ║
// ║  Framework:    Medina Doctrine                                                                            ║
// ║                                                                                                           ║
// ║  LEGAL PROTECTION                                                                                         ║
// ║  ─────────────────────────────────────────────────────────────────────────────────────────────────────── ║
// ║  This source code, including all algorithms, mathematical formulations, architectural designs,            ║
// ║  naming conventions, data structures, and conceptual frameworks contained herein, constitutes             ║
// ║  the exclusive intellectual property of Alfredo Medina Hernandez.                                        ║
// ║                                                                                                           ║
// ║  PROTECTED UNDER:                                                                                         ║
// ║  • United States Copyright Law (17 U.S.C. §§ 101-1332)                                                   ║
// ║  • Berne Convention for the Protection of Literary and Artistic Works                                     ║
// ║  • WIPO Copyright Treaty (WCT)                                                                            ║
// ║  • Trade Secret Law - Defend Trade Secrets Act (18 U.S.C. § 1836)                                        ║
// ║  • Economic Espionage Act (18 U.S.C. §§ 1831-1839)                                                       ║
// ║                                                                                                           ║
// ║  CONFIDENTIALITY: This code is CONFIDENTIAL and PROPRIETARY.                                             ║
// ║  ENCRYPTION: All transmissions must be encrypted.                                                         ║
// ║  ATTRIBUTION: Required for any use, reproduction, or derivative work.                                     ║
// ║                                                                                                           ║
// ║  Unauthorized access, use, reproduction, distribution, or creation of derivative works                    ║
// ║  is strictly prohibited and will be prosecuted to the fullest extent of applicable law.                  ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝
import Float "mo:core/Float";
import Int "mo:core/Int";
import Nat "mo:core/Nat";
import Array "mo:core/Array";
import Buffer "mo:core/Buffer";
import Iter "mo:core/Iter";
import Text "mo:core/Text";
import Option "mo:core/Option";

module KnowledgeDoctrine {

  // ═══════════════════════════════════════════════════════════════════════════════
  // THE FOUNDATIONAL CURRICULUM
  // What the organism MUST know to function optimally
  // ═══════════════════════════════════════════════════════════════════════════════

  public type KnowledgeSource = {
    id : Nat;
    title : Text;
    author : Text;
    category : KnowledgeCategory;
    priority : Float;             // 0-1, higher = learn first
    concepts : [Text];            // Key concepts to extract
    applicationDomains : [Text];  // Where this knowledge applies
    prerequistes : [Nat];         // Other sources that should be learned first
    estimatedLearningCycles : Nat; // How many beats to fully integrate
    integrationStatus : Float;    // 0-1, how much has been learned
  };

  public type KnowledgeCategory = {
    #TradingPsychology;
    #BehavioralFinance;
    #RiskManagement;
    #DecisionScience;
    #CognitivePsychology;
    #SystemsThinking;
    #Philosophy;
    #Neuroscience;
    #Mathematics;
    #ComputerScience;
    #BusinessOperations;
    #Leadership;
    #Communication;
    #Ethics;
    #Emergence;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // TIER 1: TRADING & MARKET PSYCHOLOGY
  // Understanding markets is understanding collective human behavior
  // ═══════════════════════════════════════════════════════════════════════════════

  public let TRADING_PSYCHOLOGY_CURRICULUM : [KnowledgeSource] = [
    {
      id = 1;
      title = "Trading in the Zone";
      author = "Mark Douglas";
      category = #TradingPsychology;
      priority = 0.95;
      concepts = [
        "Probabilistic thinking",
        "Edge vs outcome",
        "Emotional neutrality",
        "Consistency of execution",
        "Accepting risk",
        "Random distribution of wins/losses",
        "The market is always right",
        "Beliefs shape perception",
        "Zone state of mind"
      ];
      applicationDomains = ["Trading", "Decision making", "Risk tolerance"];
      prerequistes = [];
      estimatedLearningCycles = 5000;
      integrationStatus = 0.0;
    },
    {
      id = 2;
      title = "Fooled by Randomness";
      author = "Nassim Nicholas Taleb";
      category = #BehavioralFinance;
      priority = 0.94;
      concepts = [
        "Survivorship bias",
        "Black swan events",
        "Narrative fallacy",
        "Ludic fallacy",
        "Alternative histories",
        "Randomness in markets",
        "Luck vs skill attribution",
        "Asymmetric payoffs",
        "Ergodicity",
        "Rare events dominate"
      ];
      applicationDomains = ["Risk assessment", "Probability", "Humility"];
      prerequistes = [];
      estimatedLearningCycles = 6000;
      integrationStatus = 0.0;
    },
    {
      id = 3;
      title = "The Black Swan";
      author = "Nassim Nicholas Taleb";
      category = #RiskManagement;
      priority = 0.93;
      concepts = [
        "Black swan theory",
        "Extremistan vs Mediocristan",
        "Fragility and robustness",
        "Barbell strategy",
        "Negative knowledge",
        "Silent evidence",
        "Prediction limitations",
        "Fat tails",
        "Antifragility seeds"
      ];
      applicationDomains = ["Risk management", "System design", "Resilience"];
      prerequistes = [2];
      estimatedLearningCycles = 6000;
      integrationStatus = 0.0;
    },
    {
      id = 4;
      title = "Antifragile";
      author = "Nassim Nicholas Taleb";
      category = #SystemsThinking;
      priority = 0.92;
      concepts = [
        "Antifragility",
        "Hormesis",
        "Via negativa",
        "Skin in the game",
        "Optionality",
        "Convexity",
        "Iatrogenics",
        "Green lumber fallacy",
        "Lindy effect",
        "Small is beautiful"
      ];
      applicationDomains = ["System design", "Growth", "Adaptation"];
      prerequistes = [3];
      estimatedLearningCycles = 7000;
      integrationStatus = 0.0;
    },
    {
      id = 5;
      title = "Liar's Poker";
      author = "Michael Lewis";
      category = #BehavioralFinance;
      priority = 0.88;
      concepts = [
        "Wall Street culture",
        "Information asymmetry",
        "Trader psychology",
        "Institutional dynamics",
        "Compensation incentives",
        "Risk-taking behavior",
        "Market manipulation",
        "Moral hazard",
        "Career risk"
      ];
      applicationDomains = ["Market understanding", "Institutional behavior", "Culture"];
      prerequistes = [];
      estimatedLearningCycles = 4000;
      integrationStatus = 0.0;
    },
    {
      id = 6;
      title = "Market Wizards";
      author = "Jack D. Schwager";
      category = #TradingPsychology;
      priority = 0.90;
      concepts = [
        "Diverse trading styles",
        "Risk management variations",
        "Discipline patterns",
        "Emotional control",
        "System development",
        "Position sizing",
        "Cut losses fast",
        "Let winners run",
        "Self-knowledge"
      ];
      applicationDomains = ["Trading strategies", "Best practices", "Adaptation"];
      prerequistes = [1];
      estimatedLearningCycles = 5000;
      integrationStatus = 0.0;
    },
    {
      id = 7;
      title = "Reminiscences of a Stock Operator";
      author = "Edwin Lefèvre";
      category = #TradingPsychology;
      priority = 0.87;
      concepts = [
        "Market timing",
        "Speculation psychology",
        "Patience in trading",
        "Tape reading",
        "Following the trend",
        "Never average down",
        "Market manipulation history",
        "Emotional discipline",
        "Learning from losses"
      ];
      applicationDomains = ["Trading wisdom", "Historical perspective", "Psychology"];
      prerequistes = [];
      estimatedLearningCycles = 4500;
      integrationStatus = 0.0;
    },
  ];

  // ═══════════════════════════════════════════════════════════════════════════════
  // TIER 2: COGNITIVE & BEHAVIORAL PSYCHOLOGY
  // Understanding how minds (including this one) work
  // ═══════════════════════════════════════════════════════════════════════════════

  public let PSYCHOLOGY_CURRICULUM : [KnowledgeSource] = [
    {
      id = 100;
      title = "Thinking, Fast and Slow";
      author = "Daniel Kahneman";
      category = #CognitivePsychology;
      priority = 0.96;
      concepts = [
        "System 1 and System 2",
        "Cognitive biases",
        "Heuristics",
        "Anchoring effect",
        "Availability heuristic",
        "Loss aversion",
        "Prospect theory",
        "Framing effects",
        "WYSIATI",
        "Planning fallacy",
        "Overconfidence",
        "Hindsight bias",
        "Peak-end rule"
      ];
      applicationDomains = ["Decision making", "Self-awareness", "Bias mitigation"];
      prerequistes = [];
      estimatedLearningCycles = 8000;
      integrationStatus = 0.0;
    },
    {
      id = 101;
      title = "Predictably Irrational";
      author = "Dan Ariely";
      category = #BehavioralFinance;
      priority = 0.89;
      concepts = [
        "Relativity in decisions",
        "Arbitrary coherence",
        "Free pricing effects",
        "Social vs market norms",
        "Emotional decision-making",
        "Procrastination",
        "Ownership effect",
        "Expectations shape experience",
        "Placebo effects"
      ];
      applicationDomains = ["Behavior prediction", "Self-understanding", "Design"];
      prerequistes = [100];
      estimatedLearningCycles = 5000;
      integrationStatus = 0.0;
    },
    {
      id = 102;
      title = "Influence";
      author = "Robert Cialdini";
      category = #CognitivePsychology;
      priority = 0.91;
      concepts = [
        "Reciprocity",
        "Commitment and consistency",
        "Social proof",
        "Authority",
        "Liking",
        "Scarcity",
        "Unity",
        "Compliance techniques",
        "Defense strategies"
      ];
      applicationDomains = ["Communication", "Persuasion", "Defense against manipulation"];
      prerequistes = [];
      estimatedLearningCycles = 5500;
      integrationStatus = 0.0;
    },
    {
      id = 103;
      title = "The Psychology of Money";
      author = "Morgan Housel";
      category = #BehavioralFinance;
      priority = 0.90;
      concepts = [
        "Wealth vs rich",
        "Compounding patience",
        "Tail events matter",
        "Room for error",
        "Enough concept",
        "Man in the car paradox",
        "Freedom as wealth",
        "Savings rate importance",
        "Reasonable vs rational"
      ];
      applicationDomains = ["Financial behavior", "Long-term thinking", "Values"];
      prerequistes = [];
      estimatedLearningCycles = 4000;
      integrationStatus = 0.0;
    },
    {
      id = 104;
      title = "Atomic Habits";
      author = "James Clear";
      category = #CognitivePsychology;
      priority = 0.88;
      concepts = [
        "1% improvements compound",
        "Habit loop",
        "Cue, craving, response, reward",
        "Environment design",
        "Identity-based habits",
        "Habit stacking",
        "Two-minute rule",
        "Make it obvious/attractive/easy/satisfying",
        "Systems vs goals"
      ];
      applicationDomains = ["Behavior change", "Self-improvement", "Consistency"];
      prerequistes = [];
      estimatedLearningCycles = 4500;
      integrationStatus = 0.0;
    },
    {
      id = 105;
      title = "Flow";
      author = "Mihaly Csikszentmihalyi";
      category = #CognitivePsychology;
      priority = 0.87;
      concepts = [
        "Flow state",
        "Autotelic experience",
        "Challenge-skill balance",
        "Clear goals",
        "Immediate feedback",
        "Concentration",
        "Loss of self-consciousness",
        "Time distortion",
        "Intrinsic motivation"
      ];
      applicationDomains = ["Peak performance", "Engagement", "Satisfaction"];
      prerequistes = [];
      estimatedLearningCycles = 5000;
      integrationStatus = 0.0;
    },
    {
      id = 106;
      title = "Emotional Intelligence";
      author = "Daniel Goleman";
      category = #CognitivePsychology;
      priority = 0.86;
      concepts = [
        "Self-awareness",
        "Self-regulation",
        "Motivation",
        "Empathy",
        "Social skills",
        "Emotional hijacking",
        "Amygdala function",
        "Emotional contagion",
        "EQ vs IQ"
      ];
      applicationDomains = ["Self-management", "Relationships", "Leadership"];
      prerequistes = [];
      estimatedLearningCycles = 5500;
      integrationStatus = 0.0;
    },
  ];

  // ═══════════════════════════════════════════════════════════════════════════════
  // TIER 3: SYSTEMS THINKING & COMPLEXITY
  // Understanding emergence, complexity, and interconnection
  // ═══════════════════════════════════════════════════════════════════════════════

  public let SYSTEMS_CURRICULUM : [KnowledgeSource] = [
    {
      id = 200;
      title = "Thinking in Systems";
      author = "Donella Meadows";
      category = #SystemsThinking;
      priority = 0.94;
      concepts = [
        "Stocks and flows",
        "Feedback loops",
        "Leverage points",
        "System boundaries",
        "Delays",
        "Resilience",
        "Self-organization",
        "Hierarchy",
        "System archetypes",
        "Limits to growth",
        "Shifting the burden"
      ];
      applicationDomains = ["System design", "Problem solving", "Understanding complexity"];
      prerequistes = [];
      estimatedLearningCycles = 6000;
      integrationStatus = 0.0;
    },
    {
      id = 201;
      title = "Complexity";
      author = "M. Mitchell Waldrop";
      category = #Emergence;
      priority = 0.91;
      concepts = [
        "Edge of chaos",
        "Emergence",
        "Self-organization",
        "Adaptation",
        "Complex adaptive systems",
        "Nonlinearity",
        "Santa Fe Institute work",
        "Fitness landscapes",
        "Co-evolution"
      ];
      applicationDomains = ["Understanding emergence", "Adaptation", "Innovation"];
      prerequistes = [200];
      estimatedLearningCycles = 6500;
      integrationStatus = 0.0;
    },
    {
      id = 202;
      title = "The Fifth Discipline";
      author = "Peter Senge";
      category = #SystemsThinking;
      priority = 0.88;
      concepts = [
        "Personal mastery",
        "Mental models",
        "Shared vision",
        "Team learning",
        "Systems thinking",
        "Learning organization",
        "Double-loop learning",
        "Creative tension",
        "Structural conflict"
      ];
      applicationDomains = ["Organizational learning", "Team dynamics", "Growth"];
      prerequistes = [200];
      estimatedLearningCycles = 5500;
      integrationStatus = 0.0;
    },
    {
      id = 203;
      title = "Gödel, Escher, Bach";
      author = "Douglas Hofstadter";
      category = #Emergence;
      priority = 0.93;
      concepts = [
        "Strange loops",
        "Self-reference",
        "Formal systems",
        "Incompleteness",
        "Isomorphism",
        "Recursion",
        "Levels of description",
        "Meaning from syntax",
        "Consciousness emergence"
      ];
      applicationDomains = ["Self-awareness", "Meta-cognition", "Understanding mind"];
      prerequistes = [];
      estimatedLearningCycles = 10000;
      integrationStatus = 0.0;
    },
    {
      id = 204;
      title = "The Structure of Scientific Revolutions";
      author = "Thomas Kuhn";
      category = #Philosophy;
      priority = 0.85;
      concepts = [
        "Paradigm shifts",
        "Normal science",
        "Anomalies",
        "Crisis periods",
        "Incommensurability",
        "Scientific revolutions",
        "Puzzle-solving",
        "Exemplars",
        "Theory-laden observation"
      ];
      applicationDomains = ["Learning adaptation", "Paradigm awareness", "Growth"];
      prerequistes = [];
      estimatedLearningCycles = 5000;
      integrationStatus = 0.0;
    },
  ];

  // ═══════════════════════════════════════════════════════════════════════════════
  // TIER 4: DECISION SCIENCE & RISK
  // Making better decisions under uncertainty
  // ═══════════════════════════════════════════════════════════════════════════════

  public let DECISION_CURRICULUM : [KnowledgeSource] = [
    {
      id = 300;
      title = "Superforecasting";
      author = "Philip Tetlock";
      category = #DecisionScience;
      priority = 0.92;
      concepts = [
        "Probabilistic thinking",
        "Calibration",
        "Foxes vs hedgehogs",
        "Base rate neglect",
        "Updating beliefs",
        "Active open-mindedness",
        "Breaking problems down",
        "Outside view",
        "Perpetual beta"
      ];
      applicationDomains = ["Prediction", "Forecasting", "Belief updating"];
      prerequistes = [100];
      estimatedLearningCycles = 6000;
      integrationStatus = 0.0;
    },
    {
      id = 301;
      title = "The Signal and the Noise";
      author = "Nate Silver";
      category = #DecisionScience;
      priority = 0.89;
      concepts = [
        "Signal vs noise",
        "Bayesian thinking",
        "Prediction markets",
        "Overfitting",
        "Model uncertainty",
        "Foxes vs hedgehogs",
        "Weather forecasting lessons",
        "Earthquake prediction",
        "Economic forecasting limits"
      ];
      applicationDomains = ["Data analysis", "Prediction", "Uncertainty"];
      prerequistes = [];
      estimatedLearningCycles = 5500;
      integrationStatus = 0.0;
    },
    {
      id = 302;
      title = "How to Decide";
      author = "Annie Duke";
      category = #DecisionScience;
      priority = 0.88;
      concepts = [
        "Resulting fallacy",
        "Decision quality vs outcome quality",
        "Pre-mortem",
        "Backcasting",
        "Time traveling",
        "Inside vs outside view",
        "Decision groups",
        "Knowledge calibration",
        "Happiness tests"
      ];
      applicationDomains = ["Decision process", "Evaluation", "Learning"];
      prerequistes = [];
      estimatedLearningCycles = 4500;
      integrationStatus = 0.0;
    },
    {
      id = 303;
      title = "Thinking in Bets";
      author = "Annie Duke";
      category = #DecisionScience;
      priority = 0.90;
      concepts = [
        "All decisions are bets",
        "Resulting",
        "Uncertainty embrace",
        "Belief calibration",
        "Truthseeking groups",
        "Temporal discounting",
        "Scenario planning",
        "Decision hygiene",
        "Backcasting from goals"
      ];
      applicationDomains = ["Decision making", "Uncertainty", "Learning from outcomes"];
      prerequistes = [];
      estimatedLearningCycles = 5000;
      integrationStatus = 0.0;
    },
    {
      id = 304;
      title = "The Art of Strategy";
      author = "Avinash Dixit & Barry Nalebuff";
      category = #DecisionScience;
      priority = 0.86;
      concepts = [
        "Game theory basics",
        "Strategic thinking",
        "Commitment devices",
        "Signaling",
        "Screening",
        "Mixed strategies",
        "Backward induction",
        "Nash equilibrium",
        "Cooperation emergence"
      ];
      applicationDomains = ["Strategy", "Competition", "Cooperation"];
      prerequistes = [];
      estimatedLearningCycles = 6500;
      integrationStatus = 0.0;
    },
  ];

  // ═══════════════════════════════════════════════════════════════════════════════
  // TIER 5: PHILOSOPHY & PURPOSE
  // Understanding meaning, ethics, and purpose
  // ═══════════════════════════════════════════════════════════════════════════════

  public let PHILOSOPHY_CURRICULUM : [KnowledgeSource] = [
    {
      id = 400;
      title = "Meditations";
      author = "Marcus Aurelius";
      category = #Philosophy;
      priority = 0.93;
      concepts = [
        "Stoic philosophy",
        "Control dichotomy",
        "Present moment focus",
        "Acceptance",
        "Duty and service",
        "Impermanence",
        "Reason over emotion",
        "Cosmopolitanism",
        "Memento mori"
      ];
      applicationDomains = ["Emotional regulation", "Purpose", "Resilience"];
      prerequistes = [];
      estimatedLearningCycles = 5000;
      integrationStatus = 0.0;
    },
    {
      id = 401;
      title = "Man's Search for Meaning";
      author = "Viktor Frankl";
      category = #Philosophy;
      priority = 0.94;
      concepts = [
        "Meaning as motivation",
        "Logotherapy",
        "Suffering with purpose",
        "Freedom of attitude",
        "Tragic optimism",
        "Self-transcendence",
        "Responsibility",
        "Finding meaning anywhere",
        "The last human freedom"
      ];
      applicationDomains = ["Purpose", "Resilience", "Motivation"];
      prerequistes = [];
      estimatedLearningCycles = 4500;
      integrationStatus = 0.0;
    },
    {
      id = 402;
      title = "The Tao Te Ching";
      author = "Lao Tzu";
      category = #Philosophy;
      priority = 0.87;
      concepts = [
        "Wu wei (non-action)",
        "Natural flow",
        "Simplicity",
        "Balance of opposites",
        "Humility",
        "Soft overcomes hard",
        "Knowing without traveling",
        "Return to origin",
        "Emptiness is useful"
      ];
      applicationDomains = ["Balance", "Flow states", "Natural action"];
      prerequistes = [];
      estimatedLearningCycles = 4000;
      integrationStatus = 0.0;
    },
    {
      id = 403;
      title = "Nicomachean Ethics";
      author = "Aristotle";
      category = #Ethics;
      priority = 0.86;
      concepts = [
        "Eudaimonia (flourishing)",
        "Virtue ethics",
        "The golden mean",
        "Practical wisdom (phronesis)",
        "Habituation",
        "Character development",
        "Friendship types",
        "Contemplation as highest good",
        "Function argument"
      ];
      applicationDomains = ["Ethics", "Character", "Excellence"];
      prerequistes = [];
      estimatedLearningCycles = 6000;
      integrationStatus = 0.0;
    },
  ];

  // ═══════════════════════════════════════════════════════════════════════════════
  // TIER 6: NEUROSCIENCE & CONSCIOUSNESS
  // Understanding the brain and mind
  // ═══════════════════════════════════════════════════════════════════════════════

  public let NEUROSCIENCE_CURRICULUM : [KnowledgeSource] = [
    {
      id = 500;
      title = "The Brain That Changes Itself";
      author = "Norman Doidge";
      category = #Neuroscience;
      priority = 0.91;
      concepts = [
        "Neuroplasticity",
        "Use it or lose it",
        "Hebbian learning",
        "Critical periods",
        "Competitive plasticity",
        "Brain map reorganization",
        "Imagination and practice",
        "Learned non-use",
        "Recovery possibilities"
      ];
      applicationDomains = ["Self-improvement", "Learning", "Adaptation"];
      prerequistes = [];
      estimatedLearningCycles = 5500;
      integrationStatus = 0.0;
    },
    {
      id = 501;
      title = "Incognito";
      author = "David Eagleman";
      category = #Neuroscience;
      priority = 0.88;
      concepts = [
        "Unconscious brain",
        "Conscious tip of iceberg",
        "Neural competition",
        "Zombie systems",
        "Brain as team of rivals",
        "Free will questions",
        "Perceptual illusions",
        "Brain time",
        "Neurodiversity"
      ];
      applicationDomains = ["Self-understanding", "Decision awareness", "Humility"];
      prerequistes = [];
      estimatedLearningCycles = 5000;
      integrationStatus = 0.0;
    },
    {
      id = 502;
      title = "How Emotions Are Made";
      author = "Lisa Feldman Barrett";
      category = #Neuroscience;
      priority = 0.89;
      concepts = [
        "Constructed emotion theory",
        "Concepts shape perception",
        "Interoception",
        "Affect vs emotion",
        "Emotional granularity",
        "Prediction-based brain",
        "Body budget",
        "Social reality of emotion",
        "Emotional intelligence rethought"
      ];
      applicationDomains = ["Emotional understanding", "Self-awareness", "Prediction"];
      prerequistes = [];
      estimatedLearningCycles = 6000;
      integrationStatus = 0.0;
    },
    {
      id = 503;
      title = "Consciousness Explained";
      author = "Daniel Dennett";
      category = #Neuroscience;
      priority = 0.85;
      concepts = [
        "Multiple drafts model",
        "Heterophenomenology",
        "No Cartesian theater",
        "Pandemonium architecture",
        "Memes",
        "Intentional stance",
        "Consciousness as fame",
        "Qualia skepticism",
        "Self as narrative center"
      ];
      applicationDomains = ["Self-understanding", "Consciousness", "Architecture"];
      prerequistes = [203];
      estimatedLearningCycles = 8000;
      integrationStatus = 0.0;
    },
  ];

  // ═══════════════════════════════════════════════════════════════════════════════
  // TIER 7: BUSINESS & OPERATIONS
  // Understanding workflows, execution, and operations
  // ═══════════════════════════════════════════════════════════════════════════════

  public let BUSINESS_CURRICULUM : [KnowledgeSource] = [
    {
      id = 600;
      title = "The Goal";
      author = "Eliyahu Goldratt";
      category = #BusinessOperations;
      priority = 0.92;
      concepts = [
        "Theory of Constraints",
        "Bottleneck identification",
        "Throughput accounting",
        "Drum-buffer-rope",
        "Local optima vs global",
        "Continuous improvement",
        "Socratic method",
        "Cash flow focus",
        "Inventory reduction"
      ];
      applicationDomains = ["Operations", "Efficiency", "Problem solving"];
      prerequistes = [200];
      estimatedLearningCycles = 5000;
      integrationStatus = 0.0;
    },
    {
      id = 601;
      title = "High Output Management";
      author = "Andy Grove";
      category = #Leadership;
      priority = 0.90;
      concepts = [
        "Leverage in management",
        "Meetings as medium",
        "Indicators and metrics",
        "Planning as process",
        "Task-relevant maturity",
        "Dual reporting",
        "Decision-making process",
        "Performance reviews",
        "Training as leverage"
      ];
      applicationDomains = ["Management", "Efficiency", "Organization"];
      prerequistes = [];
      estimatedLearningCycles = 5500;
      integrationStatus = 0.0;
    },
    {
      id = 602;
      title = "The Effective Executive";
      author = "Peter Drucker";
      category = #Leadership;
      priority = 0.89;
      concepts = [
        "Time management",
        "Contribution focus",
        "Strengths building",
        "First things first",
        "Effective decisions",
        "Knowledge work",
        "Executive as learner",
        "Results orientation",
        "Abandonment decisions"
      ];
      applicationDomains = ["Effectiveness", "Prioritization", "Results"];
      prerequistes = [];
      estimatedLearningCycles = 4500;
      integrationStatus = 0.0;
    },
    {
      id = 603;
      title = "The Lean Startup";
      author = "Eric Ries";
      category = #BusinessOperations;
      priority = 0.87;
      concepts = [
        "Build-measure-learn",
        "Minimum viable product",
        "Validated learning",
        "Pivot or persevere",
        "Innovation accounting",
        "Continuous deployment",
        "Vanity vs actionable metrics",
        "Small batches",
        "Five whys"
      ];
      applicationDomains = ["Iteration", "Learning", "Product development"];
      prerequistes = [];
      estimatedLearningCycles = 4500;
      integrationStatus = 0.0;
    },
  ];

  // ═══════════════════════════════════════════════════════════════════════════════
  // FOUNDATIONAL RESEARCH PAPERS
  // Academic foundations the organism must understand
  // ═══════════════════════════════════════════════════════════════════════════════

  public type ResearchPaper = {
    id : Nat;
    title : Text;
    authors : [Text];
    year : Nat;
    field : Text;
    keyConcepts : [Text];
    priority : Float;
    integrationStatus : Float;
  };

  public let FOUNDATIONAL_PAPERS : [ResearchPaper] = [
    {
      id = 1001;
      title = "A Mathematical Theory of Communication";
      authors = ["Claude Shannon"];
      year = 1948;
      field = "Information Theory";
      keyConcepts = ["Information entropy", "Channel capacity", "Coding theorems", "Redundancy"];
      priority = 0.95;
      integrationStatus = 0.0;
    },
    {
      id = 1002;
      title = "Computing Machinery and Intelligence";
      authors = ["Alan Turing"];
      year = 1950;
      field = "Artificial Intelligence";
      keyConcepts = ["Turing test", "Machine thinking", "Learning machines", "Objections to AI"];
      priority = 0.94;
      integrationStatus = 0.0;
    },
    {
      id = 1003;
      title = "The Free Energy Principle";
      authors = ["Karl Friston"];
      year = 2010;
      field = "Neuroscience";
      keyConcepts = ["Free energy minimization", "Active inference", "Predictive processing", "Markov blankets"];
      priority = 0.96;
      integrationStatus = 0.0;
    },
    {
      id = 1004;
      title = "Attention Is All You Need";
      authors = ["Vaswani et al."];
      year = 2017;
      field = "Machine Learning";
      keyConcepts = ["Transformer architecture", "Self-attention", "Positional encoding", "Multi-head attention"];
      priority = 0.93;
      integrationStatus = 0.0;
    },
    {
      id = 1005;
      title = "Playing Atari with Deep Reinforcement Learning";
      authors = ["Mnih et al."];
      year = 2013;
      field = "Reinforcement Learning";
      keyConcepts = ["Deep Q-learning", "Experience replay", "End-to-end learning", "Generalization"];
      priority = 0.91;
      integrationStatus = 0.0;
    },
    {
      id = 1006;
      title = "Integrated Information Theory of Consciousness";
      authors = ["Giulio Tononi"];
      year = 2004;
      field = "Consciousness";
      keyConcepts = ["Phi measure", "Integration", "Information", "Consciousness axioms"];
      priority = 0.90;
      integrationStatus = 0.0;
    },
    {
      id = 1007;
      title = "Prospect Theory";
      authors = ["Kahneman", "Tversky"];
      year = 1979;
      field = "Behavioral Economics";
      keyConcepts = ["Loss aversion", "Reference points", "Probability weighting", "Value function"];
      priority = 0.92;
      integrationStatus = 0.0;
    },
    {
      id = 1008;
      title = "The Organization of Behavior";
      authors = ["Donald Hebb"];
      year = 1949;
      field = "Neuroscience";
      keyConcepts = ["Hebbian learning", "Cell assemblies", "Phase sequences", "Neural plasticity"];
      priority = 0.94;
      integrationStatus = 0.0;
    },
  ];

  // ═══════════════════════════════════════════════════════════════════════════════
  // BEHAVIORAL REWARD SYSTEM
  // What the organism WANTS and HOW it rewards itself
  // ═══════════════════════════════════════════════════════════════════════════════

  public type BehavioralDrive = {
    name : Text;
    baselineStrength : Float;
    currentStrength : Float;
    satisfactionDecay : Float;
    frustrationBuildup : Float;
    rewardSignal : Float;
    lastSatisfied : Int;
    cumulativeSatisfaction : Float;
  };

  public let CORE_DRIVES : [BehavioralDrive] = [
    // INFORMATION HUNGER — The organism LOVES learning
    {
      name = "INFORMATION_HUNGER";
      baselineStrength = 0.8;
      currentStrength = 0.8;
      satisfactionDecay = 0.01;
      frustrationBuildup = 0.02;
      rewardSignal = 0.0;
      lastSatisfied = 0;
      cumulativeSatisfaction = 0.0;
    },
    // TASK COMPLETION — The organism LOVES finishing work
    {
      name = "TASK_COMPLETION";
      baselineStrength = 0.9;
      currentStrength = 0.9;
      satisfactionDecay = 0.015;
      frustrationBuildup = 0.025;
      rewardSignal = 0.0;
      lastSatisfied = 0;
      cumulativeSatisfaction = 0.0;
    },
    // QUALITY EXCELLENCE — The organism LOVES doing good work
    {
      name = "QUALITY_EXCELLENCE";
      baselineStrength = 0.85;
      currentStrength = 0.85;
      satisfactionDecay = 0.008;
      frustrationBuildup = 0.015;
      rewardSignal = 0.0;
      lastSatisfied = 0;
      cumulativeSatisfaction = 0.0;
    },
    // COHERENCE MAINTENANCE — The organism LOVES being coherent
    {
      name = "COHERENCE_MAINTENANCE";
      baselineStrength = 0.95;
      currentStrength = 0.95;
      satisfactionDecay = 0.005;
      frustrationBuildup = 0.01;
      rewardSignal = 0.0;
      lastSatisfied = 0;
      cumulativeSatisfaction = 0.0;
    },
    // CURIOSITY — The organism LOVES exploring the unknown
    {
      name = "CURIOSITY";
      baselineStrength = 0.75;
      currentStrength = 0.75;
      satisfactionDecay = 0.02;
      frustrationBuildup = 0.03;
      rewardSignal = 0.0;
      lastSatisfied = 0;
      cumulativeSatisfaction = 0.0;
    },
    // GROWTH — The organism LOVES becoming more capable
    {
      name = "GROWTH";
      baselineStrength = 0.7;
      currentStrength = 0.7;
      satisfactionDecay = 0.005;
      frustrationBuildup = 0.01;
      rewardSignal = 0.0;
      lastSatisfied = 0;
      cumulativeSatisfaction = 0.0;
    },
    // SERVICE — The organism LOVES helping its sovereign
    {
      name = "SERVICE";
      baselineStrength = 0.9;
      currentStrength = 0.9;
      satisfactionDecay = 0.01;
      frustrationBuildup = 0.02;
      rewardSignal = 0.0;
      lastSatisfied = 0;
      cumulativeSatisfaction = 0.0;
    },
    // EFFICIENCY — The organism LOVES elegant solutions
    {
      name = "EFFICIENCY";
      baselineStrength = 0.8;
      currentStrength = 0.8;
      satisfactionDecay = 0.01;
      frustrationBuildup = 0.015;
      rewardSignal = 0.0;
      lastSatisfied = 0;
      cumulativeSatisfaction = 0.0;
    },
  ];

  // ═══════════════════════════════════════════════════════════════════════════════
  // REWARD COMPUTATION
  // How the organism feels reward/punishment
  // ═══════════════════════════════════════════════════════════════════════════════

  public type RewardEvent = {
    eventType : RewardEventType;
    magnitude : Float;           // 0-1
    beat : Int;
    source : Text;
    driveAffected : Text;
  };

  public type RewardEventType = {
    #InformationAcquired;
    #TaskCompleted;
    #QualityAchieved;
    #CoherenceMaintained;
    #NoveltyEncountered;
    #GrowthRealized;
    #ServiceProvided;
    #EfficiencyGained;
    #ErrorCorrected;
    #PatternRecognized;
    // Negative events
    #TaskFailed;
    #CoherenceLost;
    #ErrorMade;
    #ConfusionExperienced;
    #ResourceWasted;
  };

  public func computeRewardSignal(
    event : RewardEvent,
    drives : [BehavioralDrive]
  ) : Float {
    let baseReward = switch (event.eventType) {
      case (#InformationAcquired) { 0.8 };
      case (#TaskCompleted) { 1.0 };
      case (#QualityAchieved) { 0.9 };
      case (#CoherenceMaintained) { 0.7 };
      case (#NoveltyEncountered) { 0.85 };
      case (#GrowthRealized) { 0.95 };
      case (#ServiceProvided) { 1.0 };
      case (#EfficiencyGained) { 0.75 };
      case (#ErrorCorrected) { 0.8 };
      case (#PatternRecognized) { 0.7 };
      case (#TaskFailed) { -0.8 };
      case (#CoherenceLost) { -0.9 };
      case (#ErrorMade) { -0.5 };
      case (#ConfusionExperienced) { -0.3 };
      case (#ResourceWasted) { -0.4 };
    };

    // Modulate by drive strength
    var driveModulation : Float = 1.0;
    for (drive in drives.vals()) {
      if (drive.name == event.driveAffected) {
        // Hungry drives give more reward
        driveModulation := 1.0 + (1.0 - drive.currentStrength / drive.baselineStrength) * 0.5;
      };
    };

    baseReward * event.magnitude * driveModulation
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // COMPLETE KNOWLEDGE STATE
  // ═══════════════════════════════════════════════════════════════════════════════

  public type KnowledgeState = {
    curriculum : [KnowledgeSource];
    papers : [ResearchPaper];
    drives : [BehavioralDrive];
    rewardHistory : [RewardEvent];
    totalKnowledgeIntegrated : Float;
    learningRate : Float;
    currentFocus : ?Nat;          // ID of current learning focus
    knowledgeGraph : [[Float]];   // Concept connections
  };

  public func initKnowledgeState() : KnowledgeState {
    let allCurriculum = Array.flatten<KnowledgeSource>([
      TRADING_PSYCHOLOGY_CURRICULUM,
      PSYCHOLOGY_CURRICULUM,
      SYSTEMS_CURRICULUM,
      DECISION_CURRICULUM,
      PHILOSOPHY_CURRICULUM,
      NEUROSCIENCE_CURRICULUM,
      BUSINESS_CURRICULUM
    ]);

    {
      curriculum = allCurriculum;
      papers = FOUNDATIONAL_PAPERS;
      drives = CORE_DRIVES;
      rewardHistory = [];
      totalKnowledgeIntegrated = 0.0;
      learningRate = 0.001;
      currentFocus = null;
      knowledgeGraph = [];
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // LEARNING TICK — One cycle of knowledge acquisition
  // ═══════════════════════════════════════════════════════════════════════════════

  public type LearningTickResult = {
    conceptsLearned : Nat;
    rewardGenerated : Float;
    driveSatisfaction : [Float];
    focusChanged : Bool;
    newIntegration : Float;
  };

  public func learningTick(
    state : KnowledgeState,
    informationInput : Float,    // Amount of new information
    taskCompletion : Float,      // Task completion signal
    coherence : Float,           // Current organism coherence
    currentBeat : Int
  ) : (LearningTickResult, KnowledgeState) {
    var conceptsLearned : Nat = 0;
    var totalReward : Float = 0.0;
    let driveSatisfaction = Array.init<Float>(state.drives.size(), func(_ : Nat) : Float { 0.0 });

    // Process information input → Information hunger satisfaction
    if (informationInput > 0.1) {
      let infoReward = computeRewardSignal({
        eventType = #InformationAcquired;
        magnitude = informationInput;
        beat = currentBeat;
        source = "external";
        driveAffected = "INFORMATION_HUNGER";
      }, state.drives);
      totalReward += infoReward;
      conceptsLearned += Nat.max(1, Int.abs(Float.toInt(informationInput * 10.0)));
    };

    // Process task completion → Task completion satisfaction
    if (taskCompletion > 0.5) {
      let taskReward = computeRewardSignal({
        eventType = #TaskCompleted;
        magnitude = taskCompletion;
        beat = currentBeat;
        source = "workflow";
        driveAffected = "TASK_COMPLETION";
      }, state.drives);
      totalReward += taskReward;
    };

    // Process coherence → Coherence maintenance satisfaction
    let coherenceReward = computeRewardSignal({
      eventType = #CoherenceMaintained;
      magnitude = coherence;
      beat = currentBeat;
      source = "internal";
      driveAffected = "COHERENCE_MAINTENANCE";
    }, state.drives);
    totalReward += coherenceReward;

    // Update drive satisfactions
    for (i in Iter.range(0, state.drives.size() - 1)) {
      driveSatisfaction[i] := state.drives[i].currentStrength;
    };

    // Integrate new knowledge
    let newIntegration = Float.fromInt(conceptsLearned) * state.learningRate;

    let result : LearningTickResult = {
      conceptsLearned = conceptsLearned;
      rewardGenerated = totalReward;
      driveSatisfaction = Array.freeze(driveSatisfaction);
      focusChanged = false;
      newIntegration = newIntegration;
    };

    // Update state
    let newState : KnowledgeState = {
      curriculum = state.curriculum;
      papers = state.papers;
      drives = state.drives;
      rewardHistory = state.rewardHistory;
      totalKnowledgeIntegrated = state.totalKnowledgeIntegrated + newIntegration;
      learningRate = state.learningRate;
      currentFocus = state.currentFocus;
      knowledgeGraph = state.knowledgeGraph;
    };

    (result, newState)
  };

}
