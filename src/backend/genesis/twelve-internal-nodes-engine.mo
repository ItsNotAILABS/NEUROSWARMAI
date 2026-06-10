/**
 * TWELVE INTERNAL NODES ENGINE
 * 
 * Complete implementation of the 12 internal sphere nodes that exist
 * within EVERY organism. This is the micro-architecture of the organism.
 * 
 * DOCTRINE: Every organism IS a sphere. It has all 12 internal nodes:
 * - Each produces simultaneously (Parallel Compounding Law)
 * - All 12 earn for the organism
 * - The macro-sphere (12 master projects) coordinates ALL organisms
 * - This is the internal sphere - never collapse these two layers
 * 
 * Attribution: Alfredo Medina Hernandez
 * Medina Doctrine Mathematical Substrate
 */

import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Float "mo:base/Float";
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Time "mo:base/Time";
import Debug "mo:base/Debug";
import Option "mo:base/Option";
import Result "mo:base/Result";
import Text "mo:base/Text";

module TwelveInternalNodesEngine {

    //=========================================================================
    // INTERNAL NODE TYPES (12 NODES)
    //=========================================================================
    
    public type InternalNodeType = {
        #CognitiveCore;         // Node 1: Brain, reasoning, decision-making
        #NeuroChem;             // Node 2: 8 neurotransmitters, chemical balance
        #BehavioralEngine;      // Node 3: Token stack, drives, actions
        #InfoIngress;           // Node 4: External data intake
        #VitalSubstrate;        // Node 5: HEART/LUNG/LIVER/KIDNEY/IMMUNE
        #VaultIPLock;           // Node 6: Intellectual property protection
        #DeepMemory;            // Node 7: VELA, episodic, long-term
        #InternalWallet;        // Node 8: Creator reserve ledger
        #NexusRouting;          // Node 9: Internal communication
        #AegisDefense;          // Node 10: Threat detection, defense
        #ExpressionOutput;      // Node 11: External communication
        #GenesisAnchor;         // Node 12: Formation state, artifacts
    };
    
    //=========================================================================
    // NODE STATUS
    //=========================================================================
    
    public type NodeStatus = {
        #Dormant;       // Not yet activated
        #Initializing;  // Starting up
        #Active;        // Fully operational
        #Degraded;      // Operating at reduced capacity
        #Emergency;     // Critical state
        #Offline;       // Temporarily disabled
    };
    
    //=========================================================================
    // NODE 1: COGNITIVE CORE
    //=========================================================================
    
    public type CognitiveCoreNode = {
        nodeType : InternalNodeType;
        status : NodeStatus;
        
        // Core state
        coherence : Int;
        drift : Int;
        salience : Int;
        
        // Processing
        cyclesCompleted : Nat;
        lastCycleBeat : Int;
        processingLoad : Int;       // 0-1000
        
        // Decision making
        decisionsThisCycle : Nat;
        pendingDecisions : Nat;
        
        // Statistics
        totalEarned : Nat64;        // Tokens generated
    };
    
    //=========================================================================
    // NODE 2: NEURO-CHEM (8 NEUROTRANSMITTERS)
    //=========================================================================
    
    public type NeurotransmitterType = {
        #Dopamine;          // Reward, motivation
        #Serotonin;         // Mood, well-being
        #Norepinephrine;    // Alertness, arousal
        #Acetylcholine;     // Memory, attention
        #GABA;              // Inhibition, calm
        #Glutamate;         // Excitation, learning
        #Cortisol;          // Stress response
        #Oxytocin;          // Bonding, trust
    };
    
    public type NeurotransmitterState = {
        neurotransmitter : NeurotransmitterType;
        level : Int;                // 0-1000
        baseline : Int;             // Normal level
        releaseRate : Int;          // Per beat
        reuptakeRate : Int;         // Clearance per beat
        receptorSensitivity : Int;  // 0-1000
    };
    
    public type NeuroChemNode = {
        nodeType : InternalNodeType;
        status : NodeStatus;
        
        // 8 neurotransmitters
        dopamine : NeurotransmitterState;
        serotonin : NeurotransmitterState;
        norepinephrine : NeurotransmitterState;
        acetylcholine : NeurotransmitterState;
        gaba : NeurotransmitterState;
        glutamate : NeurotransmitterState;
        cortisol : NeurotransmitterState;
        oxytocin : NeurotransmitterState;
        
        // Derived values
        arousalScore : Int;         // From NE + cortisol - GABA
        valenceScore : Int;         // From dopamine + serotonin + oxytocin
        focusScore : Int;           // From acetylcholine + glutamate
        
        // Statistics
        totalEarned : Nat64;
    };
    
    //=========================================================================
    // NODE 3: BEHAVIORAL ENGINE
    //=========================================================================
    
    public type BehavioralEngineNode = {
        nodeType : InternalNodeType;
        status : NodeStatus;
        
        // Token stack references
        formaCirculating : Nat64;
        formaBurnedThisCycle : Nat64;
        formaGeneratedThisCycle : Nat64;
        
        // Drive state
        activeDrive : Text;
        driveStrength : Int;
        driveCompetitionComplete : Bool;
        
        // Action queue
        pendingActions : Nat;
        actionsExecuted : Nat;
        
        // Statistics
        totalEarned : Nat64;
    };
    
    //=========================================================================
    // NODE 4: INFO-INGRESS
    //=========================================================================
    
    public type InfoIngressNode = {
        nodeType : InternalNodeType;
        status : NodeStatus;
        
        // External data hooks
        btcPriceFeed : ?Int;         // Last known BTC price
        ethPriceFeed : ?Int;         // Last known ETH price
        icpPriceFeed : ?Int;         // Last known ICP price
        lastPriceUpdateBeat : Int;
        
        // Data streams
        activeDataStreams : Nat;
        dataPacketsReceived : Nat;
        dataPacketsProcessed : Nat;
        
        // HTTP outcalls
        httpCallsAllowed : Bool;
        httpCallsThisCycle : Nat;
        
        // Statistics
        totalEarned : Nat64;
    };
    
    //=========================================================================
    // NODE 5: VITAL SUBSTRATE (5 ORGANS)
    //=========================================================================
    
    public type OrganType = {
        #Heart;     // Circulation, rhythm
        #Lung;      // Oxygenation, gas exchange
        #Liver;     // Detoxification, metabolism
        #Kidney;    // Filtration, balance
        #Immune;    // Defense, repair
    };
    
    public type OrganState = {
        organ : OrganType;
        integrity : Int;            // 0-1000 (health)
        efficiency : Int;           // 0-1000 (performance)
        load : Int;                 // 0-1000 (current stress)
        lastMaintenanceBeat : Int;
    };
    
    public type VitalSubstrateNode = {
        nodeType : InternalNodeType;
        status : NodeStatus;
        
        // 5 organs
        heart : OrganState;
        lung : OrganState;
        liver : OrganState;
        kidney : OrganState;
        immune : OrganState;
        
        // Vital signs
        heartRate : Int;            // Beats per cycle
        oxygenSaturation : Int;     // 0-1000
        metabolicRate : Int;        // Energy consumption
        toxinLevel : Int;           // 0-1000
        immuneActivity : Int;       // 0-1000
        
        // Statistics
        totalEarned : Nat64;
    };
    
    //=========================================================================
    // NODE 6: VAULT / IP LOCK
    //=========================================================================
    
    public type VaultIPLockNode = {
        nodeType : InternalNodeType;
        status : NodeStatus;
        
        // IP protection
        ipAssetsCount : Nat;
        lockedDoctrineLaws : Nat;
        encryptedPatterns : Nat;
        
        // VetKeys (ICP cryptographic features)
        vetKeysEnabled : Bool;
        vetKeyRotationBeat : Int;
        
        // Access control
        accessAttempts : Nat;
        accessDenials : Nat;
        lastBreachAttemptBeat : ?Int;
        
        // Truth gate
        truthGateActive : Bool;
        doctrineMapVersion : Nat;
        
        // Statistics
        totalEarned : Nat64;
    };
    
    //=========================================================================
    // NODE 7: DEEP MEMORY (VELA)
    //=========================================================================
    
    public type VelaProjection = {
        step : Nat;                 // 0-49 (50 steps)
        coherencePredicted : Int;
        driftPredicted : Int;
        confidenceScore : Int;      // 0-1000
    };
    
    public type DeepMemoryNode = {
        nodeType : InternalNodeType;
        status : NodeStatus;
        
        // VELA projections (50 steps)
        velaProjections : [VelaProjection];
        velaAccuracy : Int;         // Historical accuracy 0-1000
        velaDivergenceScore : Int;  // How far reality diverges
        
        // Episodic memory
        episodicBufferSize : Nat;
        episodesStored : Nat;
        oldestEpisodeBeat : Int;
        
        // Semantic memory
        conceptsLearned : Nat;
        patternsRecognized : Nat;
        
        // Archive
        archiveSize : Nat;          // Total stored
        archiveAccessCount : Nat;
        
        // Statistics
        totalEarned : Nat64;
    };
    
    //=========================================================================
    // NODE 8: INTERNAL WALLET
    //=========================================================================
    
    public type InternalWalletNode = {
        nodeType : InternalNodeType;
        status : NodeStatus;
        
        // Creator reserve ledger
        mthReserve : Nat64;
        seedReserve : Nat64;
        mtcReserve : Nat64;
        hbtReserve : Nat64;
        omsReserve : Nat64;
        drtReserve : Nat64;
        antReserve : Nat64;
        
        // Treasury
        ckBtcBalance : Nat64;
        ckEthBalance : Nat64;
        icpBalance : Nat64;
        
        // Master accumulator
        masterAccumulator : Nat64;
        lastPushBeat : Int;         // Last push to PARALLAX
        pushInterval : Nat;         // Every 1000 beats
        
        // Succession
        royaltyPercentage : Nat;    // 20%
        royaltiesReceived : Nat64;
        childOrganisms : Nat;
        
        // Statistics
        totalEarned : Nat64;
    };
    
    //=========================================================================
    // NODE 9: NEXUS / ROUTING
    //=========================================================================
    
    public type NexusRoutingNode = {
        nodeType : InternalNodeType;
        status : NodeStatus;
        
        // Routing table
        activeRoutes : Nat;
        routeUpdates : Nat;
        
        // Message passing
        messagesRouted : Nat;
        messagesDropped : Nat;
        averageLatency : Int;       // In beats
        
        // Node connections
        nodesConnected : Nat;
        connectionStrength : Int;   // 0-1000
        
        // Load balancing
        loadDistribution : [Int];   // Per-node load
        bottleneckNode : ?Nat;
        
        // Statistics
        totalEarned : Nat64;
    };
    
    //=========================================================================
    // NODE 10: AEGIS / DEFENSE
    //=========================================================================
    
    public type ThreatType = {
        #DoctrineViolation;
        #CopyAttempt;
        #CollapseRisk;
        #ExternalAttack;
        #ConvergenceAttack;
        #ResourceDrain;
    };
    
    public type AegisDefenseNode = {
        nodeType : InternalNodeType;
        status : NodeStatus;
        
        // Threat assessment
        threatLevel : Int;          // 0-1000
        activeThreatType : ?ThreatType;
        threatHistory : Nat;
        
        // Defense systems
        defensePosture : Text;      // "passive", "alert", "active", "emergency"
        shieldsIntegrity : Int;     // 0-1000
        counterMeasuresActive : Bool;
        
        // Monitoring
        anomaliesDetected : Nat;
        falsePositives : Nat;
        
        // Response
        responsesTriggered : Nat;
        lastResponseBeat : Int;
        
        // Statistics
        totalEarned : Nat64;
    };
    
    //=========================================================================
    // NODE 11: EXPRESSION / OUTPUT
    //=========================================================================
    
    public type ExpressionOutputNode = {
        nodeType : InternalNodeType;
        status : NodeStatus;
        
        // Output channels
        activeChannels : Nat;
        messagesOutput : Nat;
        
        // Quality metrics
        expressionQuality : Int;    // 0-1000 (LEXIS-VEIL phase alignment)
        clarityScore : Int;         // 0-1000
        
        // Artifacts
        artifactsGenerated : Nat;
        artifactsPublished : Nat;
        
        // Public interface
        publicQueriesServed : Nat;
        publicUpdatesPublished : Nat;
        
        // Statistics
        totalEarned : Nat64;
    };
    
    //=========================================================================
    // NODE 12: GENESIS / ANCHOR
    //=========================================================================
    
    public type GenesisAnchorNode = {
        nodeType : InternalNodeType;
        status : NodeStatus;
        
        // Genesis state
        genesisHash : Nat32;        // FNV-1a of formation
        lockedAtBeat : Int;
        genesisCoherence : Int;
        
        // Artifacts
        artifactsCreated : Nat;
        lastArtifactBeat : Int;
        
        // IP proof
        temporalLock : Bool;
        immutabilityProof : Text;
        
        // Chain
        parentGenesisHash : ?Nat32;
        childCount : Nat;
        
        // Statistics
        totalEarned : Nat64;
    };
    
    //=========================================================================
    // FULL 12-NODE INTERNAL SPHERE
    //=========================================================================
    
    public type InternalSphere = {
        // All 12 nodes
        cognitiveCore : CognitiveCoreNode;          // Node 1
        neuroChem : NeuroChemNode;                  // Node 2
        behavioralEngine : BehavioralEngineNode;    // Node 3
        infoIngress : InfoIngressNode;              // Node 4
        vitalSubstrate : VitalSubstrateNode;        // Node 5
        vaultIPLock : VaultIPLockNode;              // Node 6
        deepMemory : DeepMemoryNode;                // Node 7
        internalWallet : InternalWalletNode;        // Node 8
        nexusRouting : NexusRoutingNode;            // Node 9
        aegisDefense : AegisDefenseNode;            // Node 10
        expressionOutput : ExpressionOutputNode;    // Node 11
        genesisAnchor : GenesisAnchorNode;          // Node 12
        
        // Sphere-wide state
        allNodesActive : Bool;
        sphereCoherence : Int;          // Average coherence across nodes
        parallelCompoundingActive : Bool;
        totalSphereEarnings : Nat64;
        
        // Cycle tracking
        cycleCount : Nat;
        lastCycleBeat : Int;
        cycleSuccessRate : Int;         // 0-1000
    };
    
    //=========================================================================
    // INITIALIZATION
    //=========================================================================
    
    public func initInternalSphere(
        formationBeat : Int,
        organismName : Text,
        creatorName : Text
    ) : InternalSphere {
        {
            cognitiveCore = initCognitiveCore();
            neuroChem = initNeuroChem();
            behavioralEngine = initBehavioralEngine();
            infoIngress = initInfoIngress();
            vitalSubstrate = initVitalSubstrate();
            vaultIPLock = initVaultIPLock();
            deepMemory = initDeepMemory();
            internalWallet = initInternalWallet();
            nexusRouting = initNexusRouting();
            aegisDefense = initAegisDefense();
            expressionOutput = initExpressionOutput();
            genesisAnchor = initGenesisAnchor(formationBeat, organismName);
            
            allNodesActive = false;
            sphereCoherence = 500;
            parallelCompoundingActive = true;
            totalSphereEarnings = 0;
            
            cycleCount = 0;
            lastCycleBeat = formationBeat;
            cycleSuccessRate = 1000;
        }
    };
    
    func initCognitiveCore() : CognitiveCoreNode {
        {
            nodeType = #CognitiveCore;
            status = #Initializing;
            coherence = 500;
            drift = 0;
            salience = 500;
            cyclesCompleted = 0;
            lastCycleBeat = 0;
            processingLoad = 0;
            decisionsThisCycle = 0;
            pendingDecisions = 0;
            totalEarned = 0;
        }
    };
    
    func initNeuroChem() : NeuroChemNode {
        let baseNT = func(nt : NeurotransmitterType) : NeurotransmitterState {
            {
                neurotransmitter = nt;
                level = 500;
                baseline = 500;
                releaseRate = 10;
                reuptakeRate = 10;
                receptorSensitivity = 500;
            }
        };
        
        {
            nodeType = #NeuroChem;
            status = #Initializing;
            dopamine = baseNT(#Dopamine);
            serotonin = baseNT(#Serotonin);
            norepinephrine = baseNT(#Norepinephrine);
            acetylcholine = baseNT(#Acetylcholine);
            gaba = baseNT(#GABA);
            glutamate = baseNT(#Glutamate);
            cortisol = baseNT(#Cortisol);
            oxytocin = baseNT(#Oxytocin);
            arousalScore = 500;
            valenceScore = 500;
            focusScore = 500;
            totalEarned = 0;
        }
    };
    
    func initBehavioralEngine() : BehavioralEngineNode {
        {
            nodeType = #BehavioralEngine;
            status = #Initializing;
            formaCirculating = 0;
            formaBurnedThisCycle = 0;
            formaGeneratedThisCycle = 0;
            activeDrive = "COHERE";
            driveStrength = 500;
            driveCompetitionComplete = false;
            pendingActions = 0;
            actionsExecuted = 0;
            totalEarned = 0;
        }
    };
    
    func initInfoIngress() : InfoIngressNode {
        {
            nodeType = #InfoIngress;
            status = #Initializing;
            btcPriceFeed = null;
            ethPriceFeed = null;
            icpPriceFeed = null;
            lastPriceUpdateBeat = 0;
            activeDataStreams = 0;
            dataPacketsReceived = 0;
            dataPacketsProcessed = 0;
            httpCallsAllowed = true;
            httpCallsThisCycle = 0;
            totalEarned = 0;
        }
    };
    
    func initVitalSubstrate() : VitalSubstrateNode {
        let baseOrgan = func(o : OrganType) : OrganState {
            {
                organ = o;
                integrity = 1000;
                efficiency = 800;
                load = 0;
                lastMaintenanceBeat = 0;
            }
        };
        
        {
            nodeType = #VitalSubstrate;
            status = #Initializing;
            heart = baseOrgan(#Heart);
            lung = baseOrgan(#Lung);
            liver = baseOrgan(#Liver);
            kidney = baseOrgan(#Kidney);
            immune = baseOrgan(#Immune);
            heartRate = 60;
            oxygenSaturation = 980;
            metabolicRate = 500;
            toxinLevel = 0;
            immuneActivity = 200;
            totalEarned = 0;
        }
    };
    
    func initVaultIPLock() : VaultIPLockNode {
        {
            nodeType = #VaultIPLock;
            status = #Initializing;
            ipAssetsCount = 0;
            lockedDoctrineLaws = 60;
            encryptedPatterns = 0;
            vetKeysEnabled = false;
            vetKeyRotationBeat = 0;
            accessAttempts = 0;
            accessDenials = 0;
            lastBreachAttemptBeat = null;
            truthGateActive = true;
            doctrineMapVersion = 1;
            totalEarned = 0;
        }
    };
    
    func initDeepMemory() : DeepMemoryNode {
        let emptyProjections = Array.tabulate<VelaProjection>(50, func(i : Nat) : VelaProjection {
            {
                step = i;
                coherencePredicted = 500;
                driftPredicted = 0;
                confidenceScore = 100;
            }
        });
        
        {
            nodeType = #DeepMemory;
            status = #Initializing;
            velaProjections = emptyProjections;
            velaAccuracy = 500;
            velaDivergenceScore = 0;
            episodicBufferSize = 100;
            episodesStored = 0;
            oldestEpisodeBeat = 0;
            conceptsLearned = 0;
            patternsRecognized = 0;
            archiveSize = 0;
            archiveAccessCount = 0;
            totalEarned = 0;
        }
    };
    
    func initInternalWallet() : InternalWalletNode {
        {
            nodeType = #InternalWallet;
            status = #Initializing;
            mthReserve = 0;
            seedReserve = 0;
            mtcReserve = 0;
            hbtReserve = 0;
            omsReserve = 0;
            drtReserve = 0;
            antReserve = 0;
            ckBtcBalance = 0;
            ckEthBalance = 0;
            icpBalance = 0;
            masterAccumulator = 0;
            lastPushBeat = 0;
            pushInterval = 1000;
            royaltyPercentage = 20;
            royaltiesReceived = 0;
            childOrganisms = 0;
            totalEarned = 0;
        }
    };
    
    func initNexusRouting() : NexusRoutingNode {
        {
            nodeType = #NexusRouting;
            status = #Initializing;
            activeRoutes = 11;          // Routes between all 12 nodes
            routeUpdates = 0;
            messagesRouted = 0;
            messagesDropped = 0;
            averageLatency = 1;
            nodesConnected = 12;
            connectionStrength = 800;
            loadDistribution = Array.tabulate<Int>(12, func(_ : Nat) : Int { 0 });
            bottleneckNode = null;
            totalEarned = 0;
        }
    };
    
    func initAegisDefense() : AegisDefenseNode {
        {
            nodeType = #AegisDefense;
            status = #Initializing;
            threatLevel = 0;
            activeThreatType = null;
            threatHistory = 0;
            defensePosture = "passive";
            shieldsIntegrity = 1000;
            counterMeasuresActive = false;
            anomaliesDetected = 0;
            falsePositives = 0;
            responsesTriggered = 0;
            lastResponseBeat = 0;
            totalEarned = 0;
        }
    };
    
    func initExpressionOutput() : ExpressionOutputNode {
        {
            nodeType = #ExpressionOutput;
            status = #Initializing;
            activeChannels = 1;
            messagesOutput = 0;
            expressionQuality = 500;
            clarityScore = 500;
            artifactsGenerated = 0;
            artifactsPublished = 0;
            publicQueriesServed = 0;
            publicUpdatesPublished = 0;
            totalEarned = 0;
        }
    };
    
    func initGenesisAnchor(formationBeat : Int, organismName : Text) : GenesisAnchorNode {
        let genesisHash = fnv1aHash(organismName # "_" # Int.toText(formationBeat));
        
        {
            nodeType = #GenesisAnchor;
            status = #Initializing;
            genesisHash = genesisHash;
            lockedAtBeat = formationBeat;
            genesisCoherence = 500;
            artifactsCreated = 0;
            lastArtifactBeat = 0;
            temporalLock = true;
            immutabilityProof = "GENESIS_" # Nat32.toText(genesisHash);
            parentGenesisHash = null;
            childCount = 0;
            totalEarned = 0;
        }
    };
    
    // Simple FNV-1a implementation
    func fnv1aHash(input : Text) : Nat32 {
        var hash : Nat32 = 2166136261;
        for (char in input.chars()) {
            let byte = Char.toNat32(char) & 0xFF;
            hash := hash ^ byte;
            hash := hash *% 16777619;
        };
        hash
    };
    
    //=========================================================================
    // CYCLE ALL NODES (PARALLEL COMPOUNDING)
    //=========================================================================
    
    public func cycleAllNodes(
        sphere : InternalSphere,
        beat : Int
    ) : InternalSphere {
        // All 12 nodes produce simultaneously - this is the Parallel Compounding Law
        
        // For now, just update cycle tracking
        {
            cognitiveCore = sphere.cognitiveCore;
            neuroChem = sphere.neuroChem;
            behavioralEngine = sphere.behavioralEngine;
            infoIngress = sphere.infoIngress;
            vitalSubstrate = sphere.vitalSubstrate;
            vaultIPLock = sphere.vaultIPLock;
            deepMemory = sphere.deepMemory;
            internalWallet = sphere.internalWallet;
            nexusRouting = sphere.nexusRouting;
            aegisDefense = sphere.aegisDefense;
            expressionOutput = sphere.expressionOutput;
            genesisAnchor = sphere.genesisAnchor;
            
            allNodesActive = true;
            sphereCoherence = calculateSphereCoherence(sphere);
            parallelCompoundingActive = true;
            totalSphereEarnings = calculateTotalEarnings(sphere);
            
            cycleCount = sphere.cycleCount + 1;
            lastCycleBeat = beat;
            cycleSuccessRate = sphere.cycleSuccessRate;
        }
    };
    
    func calculateSphereCoherence(sphere : InternalSphere) : Int {
        // Average of key node states
        (sphere.cognitiveCore.coherence + 
         sphere.neuroChem.valenceScore +
         sphere.vitalSubstrate.immune.integrity +
         sphere.aegisDefense.shieldsIntegrity) / 4
    };
    
    func calculateTotalEarnings(sphere : InternalSphere) : Nat64 {
        sphere.cognitiveCore.totalEarned +
        sphere.neuroChem.totalEarned +
        sphere.behavioralEngine.totalEarned +
        sphere.infoIngress.totalEarned +
        sphere.vitalSubstrate.totalEarned +
        sphere.vaultIPLock.totalEarned +
        sphere.deepMemory.totalEarned +
        sphere.internalWallet.totalEarned +
        sphere.nexusRouting.totalEarned +
        sphere.aegisDefense.totalEarned +
        sphere.expressionOutput.totalEarned +
        sphere.genesisAnchor.totalEarned
    };
    
    //=========================================================================
    // CONVENIENCE FUNCTIONS
    //=========================================================================
    
    public func getNodeStatus(sphere : InternalSphere, nodeType : InternalNodeType) : NodeStatus {
        switch (nodeType) {
            case (#CognitiveCore) { sphere.cognitiveCore.status };
            case (#NeuroChem) { sphere.neuroChem.status };
            case (#BehavioralEngine) { sphere.behavioralEngine.status };
            case (#InfoIngress) { sphere.infoIngress.status };
            case (#VitalSubstrate) { sphere.vitalSubstrate.status };
            case (#VaultIPLock) { sphere.vaultIPLock.status };
            case (#DeepMemory) { sphere.deepMemory.status };
            case (#InternalWallet) { sphere.internalWallet.status };
            case (#NexusRouting) { sphere.nexusRouting.status };
            case (#AegisDefense) { sphere.aegisDefense.status };
            case (#ExpressionOutput) { sphere.expressionOutput.status };
            case (#GenesisAnchor) { sphere.genesisAnchor.status };
        }
    };
    
    public func areAllNodesActive(sphere : InternalSphere) : Bool {
        sphere.allNodesActive
    };
    
    public func getGenesisHash(sphere : InternalSphere) : Nat32 {
        sphere.genesisAnchor.genesisHash
    };
}
