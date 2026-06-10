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
// ║  CONFIDENTIALITY: This code is CONFIDENTIAL and PROPRIETARY.                                             ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// EXTERNAL WORKFLOW MODELS — BACKEND VERSION (MALE)
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// WORKFLOW MODEL CLASSIFICATION:
//
// INTERNAL MODELS — Run inside the organism (separate module)
// - Cognitive workflows (thinking, learning, memory)
// - Metabolic workflows (energy, chemistry)
// - Homeostatic workflows (balance, stability)
// - Reproductive workflows (spawning, lineage)
//
// EXTERNAL MODELS — Interface with outside world (THIS MODULE)
// - Sensory workflows (perception, input)
// - Motor workflows (action, output)
// - Social workflows (communication, trust)
// - Economic workflows (tokens, trade)
//
// BACKEND vs FRONTEND EXTERNAL MODELS:
// Backend (Male): Canonical state, event processing, persistence
// Frontend (Female): Real-time rendering, user input, immediate feedback
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:core/Float";
import Int "mo:core/Int";
import Nat "mo:core/Nat";
import Array "mo:core/Array";
import Buffer "mo:core/Buffer";
import Iter "mo:core/Iter";
import Time "mo:core/Time";
import Option "mo:core/Option";
import Text "mo:core/Text";
import Principal "mo:core/Principal";

module ExternalWorkflowModels {

  // ═══════════════════════════════════════════════════════════════════════════════
  // WORKFLOW CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public let TOTAL_EXTERNAL_WORKFLOWS : Nat = 48;
  public let WORKFLOWS_PER_CATEGORY : Nat = 12;
  public let CATEGORY_COUNT : Nat = 4;
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // WORKFLOW CATEGORIES
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type WorkflowCategory = {
    #Sensory;    // Perception, input
    #Motor;      // Action, output
    #Social;     // Communication, trust
    #Economic;   // Tokens, trade
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // WORKFLOW TRIGGER TYPES
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type WorkflowTrigger = {
    #EveryBeat;
    #EveryNBeats : Nat;
    #OnThreshold : (Text, Float);
    #OnEvent : Text;
    #OnPlayerInput : Text;
    #OnExternalSignal : Text;
    #OnTrade;
    #OnCombat;
    #OnSacrifice;
    #Conditional : Text;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // WORKFLOW PRIORITY
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type WorkflowPriority = {
    #Critical;
    #High;
    #Normal;
    #Low;
    #Background;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // WORKFLOW DEFINITION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type WorkflowDefinition = {
    id : Nat;
    name : Text;
    category : WorkflowCategory;
    description : Text;
    trigger : WorkflowTrigger;
    priority : WorkflowPriority;
    inputVariables : [Text];
    outputVariables : [Text];
    equation : Text;
    dependencies : [Nat];
    isEnabled : Bool;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // THE 48 EXTERNAL WORKFLOWS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func getWorkflow(id : Nat) : ?WorkflowDefinition {
    switch (id) {
      // ═══════════════════════════════════════════════════════════════════════════
      // SENSORY WORKFLOWS (49-60)
      // ═══════════════════════════════════════════════════════════════════════════
      
      case (49) { ?{
        id = 49;
        name = "Visual Perception";
        category = #Sensory;
        description = "Process visual input from world state";
        trigger = #EveryBeat;
        priority = #High;
        inputVariables = ["worldState", "entityPosition", "viewRange"];
        outputVariables = ["visualField", "detectedEntities", "detectedResources"];
        equation = "visible = filter(world, position, range, occlusion)";
        dependencies = [];
        isEnabled = true;
      }};
      
      case (50) { ?{
        id = 50;
        name = "Threat Detection";
        category = #Sensory;
        description = "Identify threats in perceptual field";
        trigger = #EveryBeat;
        priority = #Critical;
        inputVariables = ["visualField", "threatPatterns", "faction"];
        outputVariables = ["threatLevel", "threatDirection", "threatType"];
        equation = "threat = Σ(pattern_match × distance_factor × faction_hostility)";
        dependencies = [49];
        isEnabled = true;
      }};
      
      case (51) { ?{
        id = 51;
        name = "Resource Detection";
        category = #Sensory;
        description = "Identify resources in perceptual field";
        trigger = #EveryBeat;
        priority = #High;
        inputVariables = ["visualField", "resourceNeeds"];
        outputVariables = ["resourceLocations", "resourceValues"];
        equation = "value = resource_amount × need_urgency / distance";
        dependencies = [49];
        isEnabled = true;
      }};
      
      case (52) { ?{
        id = 52;
        name = "Ally Detection";
        category = #Sensory;
        description = "Identify allies and squadmates";
        trigger = #EveryBeat;
        priority = #High;
        inputVariables = ["visualField", "faction", "squadId"];
        outputVariables = ["allyPositions", "allyHealth", "allySignals"];
        equation = "allies = filter(entities, same_faction OR same_squad)";
        dependencies = [49];
        isEnabled = true;
      }};
      
      case (53) { ?{
        id = 53;
        name = "Environmental Sensing";
        category = #Sensory;
        description = "Sense environmental conditions";
        trigger = #EveryBeat;
        priority = #Normal;
        inputVariables = ["biome", "position", "circadianPhase"];
        outputVariables = ["temperature", "lighting", "terrain"];
        equation = "conditions = biome_base × circadian_mod × position_mod";
        dependencies = [];
        isEnabled = true;
      }};
      
      case (54) { ?{
        id = 54;
        name = "Danger Zone Memory Recall";
        category = #Sensory;
        description = "Recall remembered danger zones";
        trigger = #EveryBeat;
        priority = #High;
        inputVariables = ["position", "dangerZoneMemory"];
        outputVariables = ["nearbyDangerZones", "dangerAvoidance"];
        equation = "danger_influence = Σ(danger_level / distance²)";
        dependencies = [];
        isEnabled = true;
      }};
      
      case (55) { ?{
        id = 55;
        name = "Pheromone Detection";
        category = #Sensory;
        description = "Detect pheromone trails from other entities";
        trigger = #EveryBeat;
        priority = #Normal;
        inputVariables = ["position", "pheromoneField"];
        outputVariables = ["pheromoneGradient", "trailDirection"];
        equation = "gradient = ∇(pheromone_field)";
        dependencies = [];
        isEnabled = true;
      }};
      
      case (56) { ?{
        id = 56;
        name = "Sound Localization";
        category = #Sensory;
        description = "Localize sound sources";
        trigger = #OnEvent("sound_emitted");
        priority = #High;
        inputVariables = ["soundSources", "position"];
        outputVariables = ["soundDirections", "soundDistances", "soundTypes"];
        equation = "direction = atan2(source_y - pos_y, source_x - pos_x)";
        dependencies = [];
        isEnabled = true;
      }};
      
      case (57) { ?{
        id = 57;
        name = "Salience Map Construction";
        category = #Sensory;
        description = "Build combined salience map from all senses";
        trigger = #EveryBeat;
        priority = #High;
        inputVariables = ["threatLevel", "resourceValues", "allySignals", "pheromoneGradient"];
        outputVariables = ["salienceMap"];
        equation = "salience = w_threat × threat + w_resource × resource + w_ally × ally + w_pheromone × pheromone";
        dependencies = [50, 51, 52, 55];
        isEnabled = true;
      }};
      
      case (58) { ?{
        id = 58;
        name = "Novelty Assessment";
        category = #Sensory;
        description = "Assess novelty of perceived patterns";
        trigger = #EveryBeat;
        priority = #Normal;
        inputVariables = ["currentPercept", "perceptHistory"];
        outputVariables = ["noveltyScore", "shouldInvestigate"];
        equation = "novelty = 1 - max_similarity(current, history)";
        dependencies = [49];
        isEnabled = true;
      }};
      
      case (59) { ?{
        id = 59;
        name = "Territory Boundary Detection";
        category = #Sensory;
        description = "Detect territory boundaries";
        trigger = #EveryBeat;
        priority = #Normal;
        inputVariables = ["position", "territoryMap", "faction"];
        outputVariables = ["inOwnTerritory", "nearBoundary", "boundaryDirection"];
        equation = "in_territory = territory_map[pos] == faction";
        dependencies = [];
        isEnabled = true;
      }};
      
      case (60) { ?{
        id = 60;
        name = "Communication Signal Reception";
        category = #Sensory;
        description = "Receive signals from other entities";
        trigger = #EveryBeat;
        priority = #High;
        inputVariables = ["signalBuffer", "position"];
        outputVariables = ["receivedSignals", "signalSources"];
        equation = "signals = filter(buffer, distance < reception_range)";
        dependencies = [];
        isEnabled = true;
      }};
      
      // ═══════════════════════════════════════════════════════════════════════════
      // MOTOR WORKFLOWS (61-72)
      // ═══════════════════════════════════════════════════════════════════════════
      
      case (61) { ?{
        id = 61;
        name = "Movement Execution";
        category = #Motor;
        description = "Execute movement action";
        trigger = #EveryBeat;
        priority = #Critical;
        inputVariables = ["targetPosition", "currentPosition", "speed", "terrain"];
        outputVariables = ["newPosition", "energyCost"];
        equation = "new_pos = current + velocity × dt; cost = base_cost × terrain_factor";
        dependencies = [];
        isEnabled = true;
      }};
      
      case (62) { ?{
        id = 62;
        name = "Attack Execution";
        category = #Motor;
        description = "Execute attack action";
        trigger = #OnCombat;
        priority = #Critical;
        inputVariables = ["targetEntity", "attackPower", "accuracy"];
        outputVariables = ["damageDealt", "hitSuccess", "attackCooldown"];
        equation = "damage = hit_success × attack_power × (1 + random × 0.2)";
        dependencies = [];
        isEnabled = true;
      }};
      
      case (63) { ?{
        id = 63;
        name = "Defense Posture";
        category = #Motor;
        description = "Adopt defensive stance";
        trigger = #Conditional("under_threat");
        priority = #High;
        inputVariables = ["threatDirection", "currentStance"];
        outputVariables = ["defenseBonus", "mobilityPenalty"];
        equation = "defense_bonus = base_defense × (1 + facing_threat × 0.5)";
        dependencies = [];
        isEnabled = true;
      }};
      
      case (64) { ?{
        id = 64;
        name = "Resource Gathering";
        category = #Motor;
        description = "Gather resources from environment";
        trigger = #Conditional("at_resource");
        priority = #High;
        inputVariables = ["resourceNode", "gatheringSkill"];
        outputVariables = ["resourcesGathered", "gatherTime"];
        equation = "gathered = resource_available × skill × time";
        dependencies = [];
        isEnabled = true;
      }};
      
      case (65) { ?{
        id = 65;
        name = "Pheromone Emission";
        category = #Motor;
        description = "Emit pheromone trail";
        trigger = #EveryBeat;
        priority = #Low;
        inputVariables = ["emissionType", "intensity", "position"];
        outputVariables = ["pheromoneDeposit"];
        equation = "deposit = type × intensity × (1 - evaporation_rate × dt)";
        dependencies = [];
        isEnabled = true;
      }};
      
      case (66) { ?{
        id = 66;
        name = "Signal Emission";
        category = #Motor;
        description = "Emit communication signal";
        trigger = #Conditional("signal_intent");
        priority = #High;
        inputVariables = ["signalType", "content", "range"];
        outputVariables = ["signalBroadcast"];
        equation = "broadcast = {type, content, source_pos, range, timestamp}";
        dependencies = [];
        isEnabled = true;
      }};
      
      case (67) { ?{
        id = 67;
        name = "Formation Maintenance";
        category = #Motor;
        description = "Maintain squad formation position";
        trigger = #EveryBeat;
        priority = #Normal;
        inputVariables = ["squadLeaderPos", "formationType", "formationIndex"];
        outputVariables = ["targetFormationPos", "formationCorrection"];
        equation = "target = leader_pos + formation_offset[type][index]";
        dependencies = [];
        isEnabled = true;
      }};
      
      case (68) { ?{
        id = 68;
        name = "Flee Behavior";
        category = #Motor;
        description = "Execute flee from threat";
        trigger = #Conditional("flee_decision");
        priority = #Critical;
        inputVariables = ["threatPosition", "currentPosition", "escapeRoutes"];
        outputVariables = ["fleeDirection", "fleeSpeed"];
        equation = "flee_dir = normalize(pos - threat) × (1 + escape_route_bonus)";
        dependencies = [];
        isEnabled = true;
      }};
      
      case (69) { ?{
        id = 69;
        name = "Chase Behavior";
        category = #Motor;
        description = "Execute chase of target";
        trigger = #Conditional("chase_decision");
        priority = #High;
        inputVariables = ["targetPosition", "targetVelocity", "pursuerSpeed"];
        outputVariables = ["interceptPosition", "chaseVelocity"];
        equation = "intercept = target + target_vel × estimated_time_to_intercept";
        dependencies = [];
        isEnabled = true;
      }};
      
      case (70) { ?{
        id = 70;
        name = "Rest Behavior";
        category = #Motor;
        description = "Enter rest state";
        trigger = #Conditional("rest_decision");
        priority = #Normal;
        inputVariables = ["currentEnergy", "fatigue", "safetyLevel"];
        outputVariables = ["restRate", "alertnessLevel"];
        equation = "rest_rate = base_rest × safety × (1 - alertness)";
        dependencies = [];
        isEnabled = true;
      }};
      
      case (71) { ?{
        id = 71;
        name = "Patrol Behavior";
        category = #Motor;
        description = "Execute patrol route";
        trigger = #Conditional("patrol_mode");
        priority = #Normal;
        inputVariables = ["patrolRoute", "currentWaypoint"];
        outputVariables = ["nextWaypoint", "patrolProgress"];
        equation = "next = route[(current_index + 1) % route_length]";
        dependencies = [];
        isEnabled = true;
      }};
      
      case (72) { ?{
        id = 72;
        name = "Sacrifice Behavior";
        category = #Motor;
        description = "Execute sacrifice for group benefit";
        trigger = #OnSacrifice;
        priority = #Critical;
        inputVariables = ["sacrificeTarget", "groupBenefit"];
        outputVariables = ["sacrificeEffect", "griefPropagation"];
        equation = "effect = entity_value × sacrifice_multiplier; grief = propagate(nearby_allies)";
        dependencies = [];
        isEnabled = true;
      }};
      
      // ═══════════════════════════════════════════════════════════════════════════
      // SOCIAL WORKFLOWS (73-84)
      // ═══════════════════════════════════════════════════════════════════════════
      
      case (73) { ?{
        id = 73;
        name = "Trust Update";
        category = #Social;
        description = "Update trust levels based on interactions";
        trigger = #OnEvent("interaction_completed");
        priority = #High;
        inputVariables = ["interactionType", "outcome", "currentTrust"];
        outputVariables = ["newTrust"];
        equation = "trust = trust + α × (outcome - expected_outcome)";
        dependencies = [];
        isEnabled = true;
      }};
      
      case (74) { ?{
        id = 74;
        name = "Alliance Formation";
        category = #Social;
        description = "Form alliance with trusted entities";
        trigger = #Conditional("trust_threshold_met");
        priority = #Normal;
        inputVariables = ["trustLevel", "sharedGoals", "complementarySkills"];
        outputVariables = ["allianceStrength", "allianceBenefits"];
        equation = "strength = trust × goal_alignment × skill_complement";
        dependencies = [73];
        isEnabled = true;
      }};
      
      case (75) { ?{
        id = 75;
        name = "Squad Coordination";
        category = #Social;
        description = "Coordinate actions within squad";
        trigger = #EveryBeat;
        priority = #High;
        inputVariables = ["squadMembers", "sharedPerception", "squadGoal"];
        outputVariables = ["coordinatedAction", "roleAssignments"];
        equation = "action = consensus(member_preferences) weighted by role";
        dependencies = [];
        isEnabled = true;
      }};
      
      case (76) { ?{
        id = 76;
        name = "Leadership Evaluation";
        category = #Social;
        description = "Evaluate and update leadership";
        trigger = #EveryNBeats(100);
        priority = #Normal;
        inputVariables = ["leaderPerformance", "followerSatisfaction"];
        outputVariables = ["leadershipScore", "shouldChangeLeader"];
        equation = "score = performance × satisfaction × tenure_bonus";
        dependencies = [];
        isEnabled = true;
      }};
      
      case (77) { ?{
        id = 77;
        name = "Grief Processing";
        category = #Social;
        description = "Process grief from ally loss";
        trigger = #OnEvent("ally_died");
        priority = #Critical;
        inputVariables = ["deceasedId", "relationshipStrength", "griefIntensity"];
        outputVariables = ["griefDuration", "performancePenalty"];
        equation = "penalty = relationship × intensity × (1 - grief_resistance)";
        dependencies = [];
        isEnabled = true;
      }};
      
      case (78) { ?{
        id = 78;
        name = "Social Learning";
        category = #Social;
        description = "Learn from observing others";
        trigger = #EveryBeat;
        priority = #Normal;
        inputVariables = ["observedBehavior", "observedOutcome"];
        outputVariables = ["learnedAssociation"];
        equation = "association[behavior] += α × (outcome - expected)";
        dependencies = [];
        isEnabled = true;
      }};
      
      case (79) { ?{
        id = 79;
        name = "Faction Loyalty Update";
        category = #Social;
        description = "Update faction loyalty based on experience";
        trigger = #EveryNBeats(50);
        priority = #Normal;
        inputVariables = ["factionExperiences", "currentLoyalty"];
        outputVariables = ["newLoyalty"];
        equation = "loyalty += Σ(experience_valence × experience_salience)";
        dependencies = [];
        isEnabled = true;
      }};
      
      case (80) { ?{
        id = 80;
        name = "Reputation Calculation";
        category = #Social;
        description = "Calculate reputation score";
        trigger = #EveryNBeats(100);
        priority = #Low;
        inputVariables = ["pastActions", "witnesses", "decayRate"];
        outputVariables = ["reputationScore"];
        equation = "rep = Σ(action_value × witness_count × decay^time_since)";
        dependencies = [];
        isEnabled = true;
      }};
      
      case (81) { ?{
        id = 81;
        name = "Communication Intent Formation";
        category = #Social;
        description = "Form intent to communicate";
        trigger = #Conditional("information_to_share");
        priority = #Normal;
        inputVariables = ["informationType", "recipients", "urgency"];
        outputVariables = ["communicationIntent"];
        equation = "intent = {type, content, targets, priority}";
        dependencies = [];
        isEnabled = true;
      }};
      
      case (82) { ?{
        id = 82;
        name = "Help Request Processing";
        category = #Social;
        description = "Process request for help";
        trigger = #OnEvent("help_requested");
        priority = #High;
        inputVariables = ["requester", "requestType", "urgency", "ownCapacity"];
        outputVariables = ["willHelp", "helpResponse"];
        equation = "help_prob = relationship × capacity × (1 - own_need) × urgency";
        dependencies = [73];
        isEnabled = true;
      }};
      
      case (83) { ?{
        id = 83;
        name = "Territory Negotiation";
        category = #Social;
        description = "Negotiate territory boundaries";
        trigger = #OnEvent("territory_dispute");
        priority = #High;
        inputVariables = ["disputedTerritory", "ownStrength", "opponentStrength"];
        outputVariables = ["negotiationOutcome", "newBoundary"];
        equation = "share = strength / (own_strength + opponent_strength)";
        dependencies = [];
        isEnabled = true;
      }};
      
      case (84) { ?{
        id = 84;
        name = "Conflict Resolution";
        category = #Social;
        description = "Resolve intra-group conflicts";
        trigger = #OnEvent("conflict_detected");
        priority = #High;
        inputVariables = ["conflictParties", "conflictIssue", "mediatorPresent"];
        outputVariables = ["resolution", "relationshipChanges"];
        equation = "resolution_prob = mediator_skill × party_willingness";
        dependencies = [];
        isEnabled = true;
      }};
      
      // ═══════════════════════════════════════════════════════════════════════════
      // ECONOMIC WORKFLOWS (85-96)
      // ═══════════════════════════════════════════════════════════════════════════
      
      case (85) { ?{
        id = 85;
        name = "FORMA Earning";
        category = #Economic;
        description = "Earn FORMA from activities";
        trigger = #EveryBeat;
        priority = #High;
        inputVariables = ["activity", "coherence", "jubileeMultiplier"];
        outputVariables = ["formaEarned"];
        equation = "forma = activity_reward × coherence × jubilee_mult";
        dependencies = [];
        isEnabled = true;
      }};
      
      case (86) { ?{
        id = 86;
        name = "FORMA Spending";
        category = #Economic;
        description = "Spend FORMA on upgrades/items";
        trigger = #OnPlayerInput("spend");
        priority = #High;
        inputVariables = ["purchaseType", "cost", "balance"];
        outputVariables = ["purchaseSuccess", "newBalance"];
        equation = "success = balance >= cost; new_balance = balance - cost";
        dependencies = [];
        isEnabled = true;
      }};
      
      case (87) { ?{
        id = 87;
        name = "Trade Initiation";
        category = #Economic;
        description = "Initiate trade with another entity";
        trigger = #OnTrade;
        priority = #Normal;
        inputVariables = ["offerItems", "requestItems", "tradingPartner"];
        outputVariables = ["tradeProposal"];
        equation = "proposal = {offer, request, partner, timestamp}";
        dependencies = [];
        isEnabled = true;
      }};
      
      case (88) { ?{
        id = 88;
        name = "Trade Evaluation";
        category = #Economic;
        description = "Evaluate incoming trade proposal";
        trigger = #OnEvent("trade_proposal_received");
        priority = #Normal;
        inputVariables = ["proposal", "ownValuations", "partnerTrust"];
        outputVariables = ["acceptTrade", "counterOffer"];
        equation = "accept = (received_value - given_value) × trust > threshold";
        dependencies = [73];
        isEnabled = true;
      }};
      
      case (89) { ?{
        id = 89;
        name = "Trade Execution";
        category = #Economic;
        description = "Execute accepted trade";
        trigger = #OnEvent("trade_accepted");
        priority = #High;
        inputVariables = ["trade", "buyerInventory", "sellerInventory"];
        outputVariables = ["newBuyerInventory", "newSellerInventory"];
        equation = "transfer items between inventories atomically";
        dependencies = [88];
        isEnabled = true;
      }};
      
      case (90) { ?{
        id = 90;
        name = "Resource Valuation";
        category = #Economic;
        description = "Update resource valuations";
        trigger = #EveryNBeats(10);
        priority = #Low;
        inputVariables = ["resourceInventory", "resourceNeeds", "marketPrices"];
        outputVariables = ["resourceValues"];
        equation = "value = base_value × scarcity_factor × need_urgency";
        dependencies = [];
        isEnabled = true;
      }};
      
      case (91) { ?{
        id = 91;
        name = "Architect Fee Collection";
        category = #Economic;
        description = "Collect 10% architect reserve";
        trigger = #OnEvent("forma_minted");
        priority = #Critical;
        inputVariables = ["mintedAmount"];
        outputVariables = ["architectShare", "playerShare"];
        equation = "architect = minted × 0.10; player = minted × 0.90";
        dependencies = [];
        isEnabled = true;
      }};
      
      case (92) { ?{
        id = 92;
        name = "OMNIS Bonus Distribution";
        category = #Economic;
        description = "Apply 2.75× bonus on OMNIS";
        trigger = #OnEvent("omnis_emerged");
        priority = #Critical;
        inputVariables = ["baseReward", "omnisMultiplier"];
        outputVariables = ["boostedReward"];
        equation = "reward = base × 2.75";
        dependencies = [];
        isEnabled = true;
      }};
      
      case (93) { ?{
        id = 93;
        name = "Jubilee Distribution";
        category = #Economic;
        description = "Distribute jubilee rewards";
        trigger = #OnEvent("jubilee_triggered");
        priority = #Critical;
        inputVariables = ["jubileeType", "participantContributions", "totalPool"];
        outputVariables = ["individualRewards"];
        equation = "reward[i] = pool × (contribution[i] / total_contribution) × jubilee_mult";
        dependencies = [];
        isEnabled = true;
      }};
      
      case (94) { ?{
        id = 94;
        name = "Debt Recording";
        category = #Economic;
        description = "Record economic debts";
        trigger = #OnEvent("debt_incurred");
        priority = #High;
        inputVariables = ["debtType", "amount", "creditor"];
        outputVariables = ["debtRecord"];
        equation = "debt = {type, amount, creditor, timestamp, forgiveness_eligible}";
        dependencies = [];
        isEnabled = true;
      }};
      
      case (95) { ?{
        id = 95;
        name = "Debt Forgiveness";
        category = #Economic;
        description = "Process debt forgiveness during jubilee";
        trigger = #OnEvent("jubilee_triggered");
        priority = #High;
        inputVariables = ["debts", "forgivenessPct"];
        outputVariables = ["forgivenAmount", "remainingDebts"];
        equation = "forgiven = Σ(eligible_debt × forgiveness_pct)";
        dependencies = [93];
        isEnabled = true;
      }};
      
      case (96) { ?{
        id = 96;
        name = "Economic Census";
        category = #Economic;
        description = "Aggregate economic statistics";
        trigger = #EveryNBeats(100);
        priority = #Low;
        inputVariables = ["allBalances", "allTrades", "allDebts"];
        outputVariables = ["totalSupply", "velocity", "giniCoefficient"];
        equation = "gini = Σ|x_i - x_j| / (2 × n × mean)";
        dependencies = [];
        isEnabled = true;
      }};
      
      case (_) { null };
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // WORKFLOW STATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type WorkflowExecutionState = {
    var lastExecutionBeat : [var Nat];
    var executionCounts : [var Nat];
    var totalExecutions : Nat;
    var failedExecutions : Nat;
    var averageExecutionTime : Float;
  };
  
  public func initWorkflowState() : WorkflowExecutionState {
    {
      var lastExecutionBeat = Array.init<Nat>(TOTAL_EXTERNAL_WORKFLOWS + 49, 0);
      var executionCounts = Array.init<Nat>(TOTAL_EXTERNAL_WORKFLOWS + 49, 0);
      var totalExecutions = 0;
      var failedExecutions = 0;
      var averageExecutionTime = 0.0;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // QUERY FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func getAllWorkflows() : [WorkflowDefinition] {
    let workflows = Buffer.Buffer<WorkflowDefinition>(TOTAL_EXTERNAL_WORKFLOWS);
    for (id in Iter.range(49, 96)) {
      switch (getWorkflow(id)) {
        case (?wf) { workflows.add(wf) };
        case (null) {};
      };
    };
    Buffer.toArray(workflows)
  };
  
  public func getWorkflowsByCategory(category : WorkflowCategory) : [WorkflowDefinition] {
    let workflows = Buffer.Buffer<WorkflowDefinition>(WORKFLOWS_PER_CATEGORY);
    for (id in Iter.range(49, 96)) {
      switch (getWorkflow(id)) {
        case (?wf) {
          if (wf.category == category) {
            workflows.add(wf);
          };
        };
        case (null) {};
      };
    };
    Buffer.toArray(workflows)
  };

}
