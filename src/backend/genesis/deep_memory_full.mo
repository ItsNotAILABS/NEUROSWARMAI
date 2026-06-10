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
import Nat64 "mo:core/Nat64";
import Array "mo:core/Array";
import Buffer "mo:core/Buffer";
import Text "mo:core/Text";
import Time "mo:core/Time";
import Option "mo:core/Option";
import Iter "mo:core/Iter";

module DeepMemoryFull {

  // ═══════════════════════════════════════════════════════════════════════════════
  // CANONICAL CONSTANTS — DO NOT MODIFY
  // ═══════════════════════════════════════════════════════════════════════════════
  
  // CANONICAL DECISION #5
  public let EPISODIC_BUFFER_SIZE : Nat = 200;
  public let CAUSAL_FIELDS_COUNT : Nat = 5;
  
  // CANONICAL DECISION #1
  public let HELIX_ALPHA : Float = 0.004;
  
  // CANONICAL DECISION #3
  public type SACESI = Nat64;
  
  // Decay parameters for causal pressure
  public let CAUSAL_DECAY_RATE : Float = 0.01;
  public let MIN_CAUSAL_WEIGHT : Float = 0.001;
  public let MAX_BACKWARD_PATH_LENGTH : Nat = 50;

  // ═══════════════════════════════════════════════════════════════════════════════
  // DRIVE TYPES — What was the organism doing?
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type DriveType = {
    #InformationHunger;
    #TaskSatisfaction;
    #QualityDrive;
    #ServiceDrive;
    #CoherenceDrive;
    #GrowthDrive;
    #CuriosityDrive;
    #SurvivalDrive;
    #SocialDrive;
    #RestDrive;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // EPISODE TYPE — THE CORE MEMORY UNIT WITH ALL 5 CAUSAL FIELDS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type Episode = {
    // ─────────────────────────────────────────────────────────────────────────────
    // IDENTITY
    // ─────────────────────────────────────────────────────────────────────────────
    epId : Nat64;                   // Unique episode identifier
    epTimestamp : Int;              // When this episode occurred
    epSequenceNumber : Nat;         // Position in temporal sequence
    
    // ─────────────────────────────────────────────────────────────────────────────
    // CONTENT — What happened?
    // ─────────────────────────────────────────────────────────────────────────────
    epEventType : EventType;        // Classification of what happened
    epContent : Text;               // Textual description/data
    epContext : EpisodeContext;     // Surrounding context
    epOutcome : EpisodeOutcome;     // How did it resolve?
    
    // ─────────────────────────────────────────────────────────────────────────────
    // CAUSAL FIELD 1: epBackwardPath
    // Trace back to causal ancestors — who/what caused this?
    // ─────────────────────────────────────────────────────────────────────────────
    epBackwardPath : [Nat64];       // List of ancestor episode IDs
    
    // ─────────────────────────────────────────────────────────────────────────────
    // CAUSAL FIELD 2: epCausalWeight
    // Strength of causal influence — how much does this affect the future?
    // ─────────────────────────────────────────────────────────────────────────────
    epCausalWeight : Float;         // [0, 1] — higher = more influential
    
    // ─────────────────────────────────────────────────────────────────────────────
    // CAUSAL FIELD 3: epParentEventId
    // Direct parent event reference — the immediate cause
    // ─────────────────────────────────────────────────────────────────────────────
    epParentEventId : ?Nat64;       // null if this is a root event
    
    // ─────────────────────────────────────────────────────────────────────────────
    // CAUSAL FIELD 4: epPriorStateHash
    // State hash before this episode — what was the organism's state?
    // ─────────────────────────────────────────────────────────────────────────────
    epPriorStateHash : SACESI;      // 64-bit state encoding
    
    // ─────────────────────────────────────────────────────────────────────────────
    // CAUSAL FIELD 5: epDriveAtEvent
    // Which drive was active — what motivated this?
    // ─────────────────────────────────────────────────────────────────────────────
    epDriveAtEvent : DriveType;     // The active drive during this episode
    
    // ─────────────────────────────────────────────────────────────────────────────
    // METADATA
    // ─────────────────────────────────────────────────────────────────────────────
    epEmotionalValence : Float;     // [-1, 1] — negative to positive
    epSalienceScore : Float;        // [0, 1] — how important/memorable
    epRetrievalCount : Nat;         // How many times retrieved
    epLastRetrieved : ?Int;         // When last accessed
    epConsolidated : Bool;          // Has been consolidated to long-term
  };
  
  public type EventType = {
    #TaskStarted;
    #TaskCompleted;
    #TaskFailed;
    #InformationAcquired;
    #DecisionMade;
    #ErrorOccurred;
    #LearningEvent;
    #CommunicationSent;
    #CommunicationReceived;
    #StateTransition;
    #CoherenceChange;
    #DriveActivation;
    #ExternalInteraction;
    #InternalProcess;
    #AnomalyDetected;
    #CheckpointCreated;
    #RecoveryPerformed;
  };
  
  public type EpisodeContext = {
    ctxCoherenceLevel : Float;
    ctxActiveShells : [Nat];
    ctxActiveCouncils : [Text];
    ctxEnergyLevel : Float;
    ctxWorkflowId : ?Text;
    ctxTaskId : ?Nat;
  };
  
  public type EpisodeOutcome = {
    #Success : { reward : Float; learnings : [Text] };
    #Failure : { errorCode : Text; recovery : ?Text };
    #Partial : { progress : Float; blockers : [Text] };
    #Pending;
    #Interrupted : Text;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // EPISODIC BUFFER — 200 SLOTS (CANONICAL)
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type EpisodicBuffer = {
    // The 200 episode slots
    episodes : [var ?Episode];
    // Current write position (circular buffer)
    writeIndex : Nat;
    // Total episodes ever written
    totalEpisodes : Nat64;
    // Next episode ID
    nextEpId : Nat64;
    // Buffer statistics
    stats : BufferStatistics;
    // Causal index for fast ancestor lookup
    causalIndex : CausalIndex;
  };
  
  public type BufferStatistics = {
    avgCausalWeight : Float;
    avgSalience : Float;
    totalRetrievals : Nat;
    consolidatedCount : Nat;
    oldestTimestamp : Int;
    newestTimestamp : Int;
  };
  
  public type CausalIndex = {
    // Map from episode ID to buffer index
    idToIndex : [(Nat64, Nat)];
    // Map from parent ID to child IDs
    parentToChildren : [(Nat64, [Nat64])];
    // Root episodes (no parent)
    rootEpisodes : [Nat64];
  };
  
  public func initEpisodicBuffer() : EpisodicBuffer {
    {
      episodes = Array.init<?Episode>(EPISODIC_BUFFER_SIZE, null);
      writeIndex = 0;
      totalEpisodes = 0;
      nextEpId = 1;
      stats = {
        avgCausalWeight = 0.0;
        avgSalience = 0.0;
        totalRetrievals = 0;
        consolidatedCount = 0;
        oldestTimestamp = 0;
        newestTimestamp = 0;
      };
      causalIndex = {
        idToIndex = [];
        parentToChildren = [];
        rootEpisodes = [];
      };
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // EPISODE CREATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func createEpisode(
    buffer : EpisodicBuffer,
    eventType : EventType,
    content : Text,
    context : EpisodeContext,
    outcome : EpisodeOutcome,
    parentId : ?Nat64,
    priorState : SACESI,
    drive : DriveType,
    currentTime : Int
  ) : (EpisodicBuffer, Episode) {
    
    // Calculate backward path
    let backwardPath = switch (parentId) {
      case null { [] };
      case (?pid) {
        // Find parent and extend its path
        let parentPath = findBackwardPath(buffer, pid);
        if (parentPath.size() >= MAX_BACKWARD_PATH_LENGTH) {
          // Truncate oldest ancestors
          Array.append([pid], Array.subArray(parentPath, 0, MAX_BACKWARD_PATH_LENGTH - 1))
        } else {
          Array.append([pid], parentPath)
        }
      };
    };
    
    // Calculate causal weight based on context
    let causalWeight = calculateCausalWeight(eventType, outcome, context);
    
    // Calculate salience
    let salience = calculateSalience(eventType, outcome, context);
    
    // Calculate emotional valence
    let valence = calculateValence(outcome, drive);
    
    // Create the episode
    let episode : Episode = {
      epId = buffer.nextEpId;
      epTimestamp = currentTime;
      epSequenceNumber = Nat64.toNat(buffer.totalEpisodes);
      epEventType = eventType;
      epContent = content;
      epContext = context;
      epOutcome = outcome;
      epBackwardPath = backwardPath;
      epCausalWeight = causalWeight;
      epParentEventId = parentId;
      epPriorStateHash = priorState;
      epDriveAtEvent = drive;
      epEmotionalValence = valence;
      epSalienceScore = salience;
      epRetrievalCount = 0;
      epLastRetrieved = null;
      epConsolidated = false;
    };
    
    // Write to buffer
    buffer.episodes[buffer.writeIndex] := ?episode;
    
    // Update buffer state
    let newWriteIndex = (buffer.writeIndex + 1) % EPISODIC_BUFFER_SIZE;
    let newBuffer : EpisodicBuffer = {
      episodes = buffer.episodes;
      writeIndex = newWriteIndex;
      totalEpisodes = buffer.totalEpisodes + 1;
      nextEpId = buffer.nextEpId + 1;
      stats = updateStats(buffer.stats, episode, currentTime);
      causalIndex = updateCausalIndex(buffer.causalIndex, episode, buffer.writeIndex);
    };
    
    (newBuffer, episode)
  };
  
  func findBackwardPath(buffer : EpisodicBuffer, epId : Nat64) : [Nat64] {
    // Search for episode in buffer
    for (i in Iter.range(0, EPISODIC_BUFFER_SIZE - 1)) {
      switch (buffer.episodes[i]) {
        case (?ep) {
          if (ep.epId == epId) {
            return ep.epBackwardPath;
          };
        };
        case null {};
      };
    };
    []
  };
  
  func calculateCausalWeight(
    eventType : EventType,
    outcome : EpisodeOutcome,
    context : EpisodeContext
  ) : Float {
    var weight : Float = 0.5;  // Base weight
    
    // Event type contribution
    switch (eventType) {
      case (#DecisionMade) { weight += 0.2 };
      case (#StateTransition) { weight += 0.15 };
      case (#LearningEvent) { weight += 0.15 };
      case (#ErrorOccurred) { weight += 0.1 };
      case (#AnomalyDetected) { weight += 0.2 };
      case _ { weight += 0.05 };
    };
    
    // Outcome contribution
    switch (outcome) {
      case (#Success(s)) { weight += s.reward * 0.1 };
      case (#Failure(_)) { weight += 0.1 };  // Failures are important to remember
      case (#Partial(p)) { weight += p.progress * 0.05 };
      case _ {};
    };
    
    // Context contribution
    weight += context.ctxCoherenceLevel * 0.1;
    
    Float.min(1.0, weight)
  };
  
  func calculateSalience(
    eventType : EventType,
    outcome : EpisodeOutcome,
    context : EpisodeContext
  ) : Float {
    var salience : Float = 0.3;
    
    // High-salience events
    switch (eventType) {
      case (#TaskCompleted) { salience += 0.3 };
      case (#TaskFailed) { salience += 0.25 };
      case (#AnomalyDetected) { salience += 0.35 };
      case (#DecisionMade) { salience += 0.2 };
      case (#LearningEvent) { salience += 0.2 };
      case _ { salience += 0.1 };
    };
    
    // Outcome salience
    switch (outcome) {
      case (#Success(s)) { salience += s.reward * 0.2 };
      case (#Failure(_)) { salience += 0.2 };
      case _ {};
    };
    
    // Low coherence = high salience (something unusual)
    if (context.ctxCoherenceLevel < 0.7) {
      salience += 0.15;
    };
    
    Float.min(1.0, salience)
  };
  
  func calculateValence(outcome : EpisodeOutcome, drive : DriveType) : Float {
    var valence : Float = 0.0;
    
    switch (outcome) {
      case (#Success(s)) { valence := s.reward };
      case (#Failure(_)) { valence := -0.5 };
      case (#Partial(p)) { valence := p.progress - 0.5 };
      case (#Pending) { valence := 0.0 };
      case (#Interrupted(_)) { valence := -0.3 };
    };
    
    // Drive-based adjustment
    switch (drive) {
      case (#InformationHunger) { valence += 0.1 };  // Learning is positive
      case (#TaskSatisfaction) { valence += 0.1 };   // Completion is positive
      case (#RestDrive) { valence += 0.05 };         // Rest is mildly positive
      case _ {};
    };
    
    Float.max(-1.0, Float.min(1.0, valence))
  };
  
  func updateStats(
    stats : BufferStatistics,
    episode : Episode,
    currentTime : Int
  ) : BufferStatistics {
    {
      avgCausalWeight = stats.avgCausalWeight * 0.99 + episode.epCausalWeight * 0.01;
      avgSalience = stats.avgSalience * 0.99 + episode.epSalienceScore * 0.01;
      totalRetrievals = stats.totalRetrievals;
      consolidatedCount = stats.consolidatedCount;
      oldestTimestamp = if (stats.oldestTimestamp == 0) { currentTime } else { stats.oldestTimestamp };
      newestTimestamp = currentTime;
    }
  };
  
  func updateCausalIndex(
    index : CausalIndex,
    episode : Episode,
    bufferIndex : Nat
  ) : CausalIndex {
    // Add to ID index
    let newIdToIndex = Array.append(index.idToIndex, [(episode.epId, bufferIndex)]);
    
    // Update parent-child mapping
    var newParentToChildren = index.parentToChildren;
    switch (episode.epParentEventId) {
      case (?parentId) {
        var found = false;
        newParentToChildren := Array.map<(Nat64, [Nat64]), (Nat64, [Nat64])>(index.parentToChildren, func(entry : (Nat64, [Nat64])) : (Nat64, [Nat64]) {
          if (entry.0 == parentId) {
            found := true;
            (entry.0, Array.append(entry.1, [episode.epId]))
          } else { entry }
        });
        if (not found) {
          newParentToChildren := Array.append(newParentToChildren, [(parentId, [episode.epId])]);
        };
      };
      case null {
        // This is a root episode
      };
    };
    
    // Update root episodes
    let newRoots = switch (episode.epParentEventId) {
      case null { Array.append(index.rootEpisodes, [episode.epId]) };
      case _ { index.rootEpisodes };
    };
    
    {
      idToIndex = newIdToIndex;
      parentToChildren = newParentToChildren;
      rootEpisodes = newRoots;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // CAUSAL PRESSURE COMPUTATION
  // The past exerts mathematically computable pressure on the present
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type CausalPressure = {
    totalPressure : Float;
    dominantDrive : DriveType;
    influentialEpisodes : [(Nat64, Float)];  // (episode ID, contribution)
    pressureByDrive : [(DriveType, Float)];
    temporalGradient : Float;  // Is pressure increasing or decreasing?
  };
  
  public func computeCausalPressure(
    buffer : EpisodicBuffer,
    currentTime : Int
  ) : CausalPressure {
    var totalPressure : Float = 0.0;
    var driveContributions = Buffer.Buffer<(DriveType, Float)>(10);
    var episodeContributions = Buffer.Buffer<(Nat64, Float)>(50);
    
    // Initialize drive accumulators
    var driveAccum : [(DriveType, Float)] = [
      (#InformationHunger, 0.0),
      (#TaskSatisfaction, 0.0),
      (#QualityDrive, 0.0),
      (#ServiceDrive, 0.0),
      (#CoherenceDrive, 0.0),
      (#GrowthDrive, 0.0),
      (#CuriosityDrive, 0.0),
      (#SurvivalDrive, 0.0),
      (#SocialDrive, 0.0),
      (#RestDrive, 0.0)
    ];
    
    // Compute pressure from each episode
    for (i in Iter.range(0, EPISODIC_BUFFER_SIZE - 1)) {
      switch (buffer.episodes[i]) {
        case (?episode) {
          // Time decay
          let timeDelta = Float.fromInt(Int.abs(currentTime - episode.epTimestamp));
          let decay = Float.exp(-CAUSAL_DECAY_RATE * timeDelta / 1_000_000_000.0);
          
          // Episode contribution
          let contribution = episode.epCausalWeight * decay * episode.epSalienceScore;
          
          if (contribution > MIN_CAUSAL_WEIGHT) {
            totalPressure += contribution;
            episodeContributions.add((episode.epId, contribution));
            
            // Accumulate by drive
            driveAccum := Array.map<(DriveType, Float), (DriveType, Float)>(driveAccum, func(d : (DriveType, Float)) : (DriveType, Float) {
              if (sameDrive(d.0, episode.epDriveAtEvent)) {
                (d.0, d.1 + contribution)
              } else { d }
            });
          };
        };
        case null {};
      };
    };
    
    // Find dominant drive
    var maxDrive : DriveType = #InformationHunger;
    var maxContribution : Float = 0.0;
    for ((drive, contrib) in driveAccum.vals()) {
      if (contrib > maxContribution) {
        maxContribution := contrib;
        maxDrive := drive;
      };
    };
    
    // Compute temporal gradient (recent vs older)
    var recentPressure : Float = 0.0;
    var olderPressure : Float = 0.0;
    let midpoint = EPISODIC_BUFFER_SIZE / 2;
    
    for (i in Iter.range(0, EPISODIC_BUFFER_SIZE - 1)) {
      switch (buffer.episodes[(buffer.writeIndex + EPISODIC_BUFFER_SIZE - 1 - i) % EPISODIC_BUFFER_SIZE]) {
        case (?episode) {
          let contribution = episode.epCausalWeight * episode.epSalienceScore;
          if (i < midpoint) {
            recentPressure += contribution;
          } else {
            olderPressure += contribution;
          };
        };
        case null {};
      };
    };
    
    let gradient = if (olderPressure > 0.0) {
      (recentPressure - olderPressure) / olderPressure
    } else { 0.0 };
    
    // Sort episode contributions by magnitude
    let sortedContributions = Array.sort<(Nat64, Float)>(
      Buffer.toArray(episodeContributions),
      func(a : (Nat64, Float), b : (Nat64, Float)) : {#less; #equal; #greater} {
        if (a.1 > b.1) { #less }
        else if (a.1 < b.1) { #greater }
        else { #equal }
      }
    );
    
    {
      totalPressure = totalPressure;
      dominantDrive = maxDrive;
      influentialEpisodes = Array.subArray(sortedContributions, 0, Nat.min(10, sortedContributions.size()));
      pressureByDrive = driveAccum;
      temporalGradient = gradient;
    }
  };
  
  func sameDrive(a : DriveType, b : DriveType) : Bool {
    switch (a, b) {
      case (#InformationHunger, #InformationHunger) { true };
      case (#TaskSatisfaction, #TaskSatisfaction) { true };
      case (#QualityDrive, #QualityDrive) { true };
      case (#ServiceDrive, #ServiceDrive) { true };
      case (#CoherenceDrive, #CoherenceDrive) { true };
      case (#GrowthDrive, #GrowthDrive) { true };
      case (#CuriosityDrive, #CuriosityDrive) { true };
      case (#SurvivalDrive, #SurvivalDrive) { true };
      case (#SocialDrive, #SocialDrive) { true };
      case (#RestDrive, #RestDrive) { true };
      case _ { false };
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // EPISODE RETRIEVAL
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func retrieveEpisode(
    buffer : EpisodicBuffer,
    epId : Nat64,
    currentTime : Int
  ) : ?Episode {
    for (i in Iter.range(0, EPISODIC_BUFFER_SIZE - 1)) {
      switch (buffer.episodes[i]) {
        case (?ep) {
          if (ep.epId == epId) {
            // Update retrieval stats
            buffer.episodes[i] := ?{
              epId = ep.epId;
              epTimestamp = ep.epTimestamp;
              epSequenceNumber = ep.epSequenceNumber;
              epEventType = ep.epEventType;
              epContent = ep.epContent;
              epContext = ep.epContext;
              epOutcome = ep.epOutcome;
              epBackwardPath = ep.epBackwardPath;
              epCausalWeight = ep.epCausalWeight;
              epParentEventId = ep.epParentEventId;
              epPriorStateHash = ep.epPriorStateHash;
              epDriveAtEvent = ep.epDriveAtEvent;
              epEmotionalValence = ep.epEmotionalValence;
              epSalienceScore = ep.epSalienceScore;
              epRetrievalCount = ep.epRetrievalCount + 1;
              epLastRetrieved = ?currentTime;
              epConsolidated = ep.epConsolidated;
            };
            return ?ep;
          };
        };
        case null {};
      };
    };
    null
  };
  
  // Retrieve by drive type
  public func retrieveByDrive(
    buffer : EpisodicBuffer,
    drive : DriveType,
    maxResults : Nat
  ) : [Episode] {
    let results = Buffer.Buffer<Episode>(maxResults);
    
    for (i in Iter.range(0, EPISODIC_BUFFER_SIZE - 1)) {
      if (results.size() >= maxResults) {
        return Buffer.toArray(results);
      };
      
      switch (buffer.episodes[i]) {
        case (?ep) {
          if (sameDrive(ep.epDriveAtEvent, drive)) {
            results.add(ep);
          };
        };
        case null {};
      };
    };
    
    Buffer.toArray(results)
  };
  
  // Retrieve causal ancestors
  public func retrieveCausalAncestors(
    buffer : EpisodicBuffer,
    epId : Nat64,
    maxDepth : Nat
  ) : [Episode] {
    let ancestors = Buffer.Buffer<Episode>(maxDepth);
    
    // Find the episode
    var currentId : ?Nat64 = ?epId;
    var depth : Nat = 0;
    
    label ancestorLoop while (depth < maxDepth) {
      switch (currentId) {
        case null { break ancestorLoop };
        case (?id) {
          // Find this episode
          var found = false;
          for (i in Iter.range(0, EPISODIC_BUFFER_SIZE - 1)) {
            switch (buffer.episodes[i]) {
              case (?ep) {
                if (ep.epId == id and not found) {
                  if (depth > 0) {  // Don't include the starting episode
                    ancestors.add(ep);
                  };
                  currentId := ep.epParentEventId;
                  found := true;
                };
              };
              case null {};
            };
          };
          if (not found) {
            currentId := null;
          };
        };
      };
      depth += 1;
    };
    
    Buffer.toArray(ancestors)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // MEMORY CONSOLIDATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type ConsolidationResult = {
    consolidatedCount : Nat;
    avgSalienceConsolidated : Float;
    prunedCount : Nat;
  };
  
  public func consolidateMemory(
    buffer : EpisodicBuffer,
    salienceThreshold : Float
  ) : (EpisodicBuffer, ConsolidationResult) {
    var consolidatedCount : Nat = 0;
    var totalSalience : Float = 0.0;
    var prunedCount : Nat = 0;
    
    for (i in Iter.range(0, EPISODIC_BUFFER_SIZE - 1)) {
      switch (buffer.episodes[i]) {
        case (?ep) {
          if (ep.epSalienceScore >= salienceThreshold and not ep.epConsolidated) {
            // Mark as consolidated
            buffer.episodes[i] := ?{
              epId = ep.epId;
              epTimestamp = ep.epTimestamp;
              epSequenceNumber = ep.epSequenceNumber;
              epEventType = ep.epEventType;
              epContent = ep.epContent;
              epContext = ep.epContext;
              epOutcome = ep.epOutcome;
              epBackwardPath = ep.epBackwardPath;
              epCausalWeight = ep.epCausalWeight * 1.1;  // Boost weight
              epParentEventId = ep.epParentEventId;
              epPriorStateHash = ep.epPriorStateHash;
              epDriveAtEvent = ep.epDriveAtEvent;
              epEmotionalValence = ep.epEmotionalValence;
              epSalienceScore = ep.epSalienceScore;
              epRetrievalCount = ep.epRetrievalCount;
              epLastRetrieved = ep.epLastRetrieved;
              epConsolidated = true;
            };
            consolidatedCount += 1;
            totalSalience += ep.epSalienceScore;
          } else if (ep.epSalienceScore < salienceThreshold * 0.5 and ep.epConsolidated == false) {
            // Low salience, not consolidated — candidate for pruning
            // We don't actually delete, just note it
            prunedCount += 1;
          };
        };
        case null {};
      };
    };
    
    let result : ConsolidationResult = {
      consolidatedCount = consolidatedCount;
      avgSalienceConsolidated = if (consolidatedCount > 0) { totalSalience / Float.fromInt(consolidatedCount) } else { 0.0 };
      prunedCount = prunedCount;
    };
    
    (buffer, result)
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // ██████████████████████████████████████████████████████████████████████████████████████████████████████████████
  // ██                                                                                                          ██
  // ██  LOOP 7 CLOSURE: AXIS EPISODIC RING EMOTIONAL FINGERPRINT + MEMORY REPLAY                                ██
  // ██  10-FIELD EMOTIONAL EPISODES + CLOUD OF WITNESSES + MATRIARCH ELECTIONS                                  ██
  // ██                                                                                                          ██
  // ██████████████████████████████████████████████████████████████████████████████████████████████████████████████
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // THE 10 EMOTIONAL FINGERPRINT FIELDS:
  // ────────────────────────────────────
  // 1. arousal        — [0, 1] activation level (low = calm, high = excited)
  // 2. dopamine       — [0, 1] reward signal strength
  // 3. fear           — [0, 1] threat response level
  // 4. domainBitmask  — 16-bit domain classification
  // 5. eventHash      — SHA-256 hash of event content
  // 6. salienceScore  — [0, 1] importance weighting
  // 7. attribution    — Text source attribution
  // 8. valence        — [-1, 1] positive/negative affect
  // 9. surprise       — [0, 1] prediction error magnitude
  // 10. socialContext — [0, 1] social relevance
  //
  // CLOUD OF WITNESSES:
  // Episodes with kf > 0.8 are permanently elevated to the Cloud of Witnesses.
  // These are the organism's most important memories that guide future behavior.
  //
  // MATRIARCH ELECTIONS:
  // Within each cognitive domain, salience-weighted elections determine the
  // matriarch (dominant memory) that represents that domain's experience.
  //
  // MEMORY REPLAY:
  // High-salience episodes are re-presented to Shell 3 (Hebbian consolidation)
  // to strengthen their weight in the organism's cognitive substrate.
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

  /// 10-field emotional fingerprint
  public type EmotionalFingerprint = {
    arousal : Float;         // [0, 1] activation level
    dopamine : Float;        // [0, 1] reward signal
    fear : Float;            // [0, 1] threat response
    domainBitmask : Nat16;   // 16-bit domain classification
    eventHash : Nat64;       // Hash of event content
    salienceScore : Float;   // [0, 1] importance
    attribution : Text;      // Source attribution
    valence : Float;         // [-1, 1] positive/negative
    surprise : Float;        // [0, 1] prediction error
    socialContext : Float;   // [0, 1] social relevance
  };

  /// Episode with full emotional fingerprint
  public type EmotionalEpisode = {
    // Identity
    id : Nat64;
    beat : Nat;
    timestamp : Int;
    
    // Original 3 fields
    coherence : Float;
    omnis : Bool;
    
    // 10-field emotional fingerprint
    fingerprint : EmotionalFingerprint;
    
    // Cloud of Witnesses status
    isWitness : Bool;        // kf > 0.8 at creation
    witnessElevationBeat : ?Nat;
    
    // Matriarch status
    isMatriarch : Bool;
    matriarchDomain : ?Nat;
    
    // Replay tracking
    replayCount : Nat;
    lastReplayBeat : ?Nat;
    replayStrength : Float;
    
    // Shell 3 consolidation status
    consolidatedToShell3 : Bool;
    shell3Weight : Float;
  };

  /// AXIS episodic ring with emotional fingerprints
  public type AXISEpisodicRing = {
    var episodes : [var ?EmotionalEpisode];
    var capacity : Nat;
    var occupancy : Nat;
    var nextId : Nat64;
    var writeHead : Nat;
    
    // Cloud of Witnesses
    var cloudOfWitnesses : [EmotionalEpisode];
    var witnessCount : Nat;
    var lastWitnessElevation : Nat;
    
    // Matriarch tracking (per domain, 16 domains)
    var matriarchs : [var ?EmotionalEpisode];
    var matriarchElectionCount : Nat;
    
    // Replay system
    var replayQueue : [Nat64];       // Episode IDs queued for replay
    var replayInProgress : Bool;
    var currentReplayId : ?Nat64;
    var totalReplays : Nat;
    
    // VELA OLS tracking (T10, T30, T40, T50)
    var velaT10 : Float;             // 10-beat moving average
    var velaT30 : Float;             // 30-beat moving average
    var velaT40 : Float;             // 40-beat moving average
    var velaT50 : Float;             // 50-beat moving average
    
    // Statistics
    var avgArousal : Float;
    var avgDopamine : Float;
    var avgFear : Float;
    var avgSalience : Float;
  };

  /// Initialize AXIS episodic ring
  public func initAXISEpisodicRing(capacity : Nat) : AXISEpisodicRing {
    {
      var episodes = Array.init<?EmotionalEpisode>(capacity, func(_ : Nat) : ?EmotionalEpisode { null });
      var capacity = capacity;
      var occupancy = 0;
      var nextId = 1;
      var writeHead = 0;
      var cloudOfWitnesses = [];
      var witnessCount = 0;
      var lastWitnessElevation = 0;
      var matriarchs = Array.init<?EmotionalEpisode>(16, func(_ : Nat) : ?EmotionalEpisode { null });
      var matriarchElectionCount = 0;
      var replayQueue = [];
      var replayInProgress = false;
      var currentReplayId = null;
      var totalReplays = 0;
      var velaT10 = 0.75;
      var velaT30 = 0.75;
      var velaT40 = 0.75;
      var velaT50 = 0.75;
      var avgArousal = 0.5;
      var avgDopamine = 0.5;
      var avgFear = 0.2;
      var avgSalience = 0.5;
    }
  };

  /// Create emotional fingerprint
  public func createEmotionalFingerprint(
    arousal : Float,
    dopamine : Float,
    fear : Float,
    domainBitmask : Nat16,
    content : Text,
    salienceScore : Float,
    attribution : Text,
    valence : Float,
    surprise : Float,
    socialContext : Float
  ) : EmotionalFingerprint {
    // Compute event hash (simplified FNV-1a)
    var hash : Nat64 = 14695981039346656037;  // FNV offset basis
    for (c in content.chars()) {
      hash := (hash ^ Nat64.fromNat(Nat32.toNat(Char.toNat32(c)))) *% 1099511628211;
    };
    
    {
      arousal = Float.max(0.0, Float.min(1.0, arousal));
      dopamine = Float.max(0.0, Float.min(1.0, dopamine));
      fear = Float.max(0.0, Float.min(1.0, fear));
      domainBitmask = domainBitmask;
      eventHash = hash;
      salienceScore = Float.max(0.0, Float.min(1.0, salienceScore));
      attribution = attribution;
      valence = Float.max(-1.0, Float.min(1.0, valence));
      surprise = Float.max(0.0, Float.min(1.0, surprise));
      socialContext = Float.max(0.0, Float.min(1.0, socialContext));
    }
  };

  /// Add episode with emotional fingerprint to AXIS ring
  public func addEmotionalEpisode(
    ring : AXISEpisodicRing,
    coherence : Float,
    omnis : Bool,
    fingerprint : EmotionalFingerprint,
    currentBeat : Nat,
    kf : Float
  ) : Nat64 {
    let id = ring.nextId;
    ring.nextId += 1;
    
    // Check for Cloud of Witnesses elevation
    let isWitness = kf > 0.8;
    
    let episode : EmotionalEpisode = {
      id = id;
      beat = currentBeat;
      timestamp = Time.now();
      coherence = coherence;
      omnis = omnis;
      fingerprint = fingerprint;
      isWitness = isWitness;
      witnessElevationBeat = if (isWitness) { ?currentBeat } else { null };
      isMatriarch = false;
      matriarchDomain = null;
      replayCount = 0;
      lastReplayBeat = null;
      replayStrength = 1.0;
      consolidatedToShell3 = false;
      shell3Weight = 0.0;
    };
    
    // Write to ring buffer
    ring.episodes[ring.writeHead] := ?episode;
    ring.writeHead := (ring.writeHead + 1) % ring.capacity;
    if (ring.occupancy < ring.capacity) {
      ring.occupancy += 1;
    };
    
    // Add to Cloud of Witnesses if qualified
    if (isWitness) {
      ring.cloudOfWitnesses := Array.append(ring.cloudOfWitnesses, [episode]);
      ring.witnessCount += 1;
      ring.lastWitnessElevation := currentBeat;
    };
    
    // Queue for replay if high salience
    if (fingerprint.salienceScore > 0.7) {
      ring.replayQueue := Array.append(ring.replayQueue, [id]);
    };
    
    // Update VELA moving averages
    ring.velaT10 := 0.9 * ring.velaT10 + 0.1 * coherence;
    ring.velaT30 := 0.967 * ring.velaT30 + 0.033 * coherence;
    ring.velaT40 := 0.975 * ring.velaT40 + 0.025 * coherence;
    ring.velaT50 := 0.98 * ring.velaT50 + 0.02 * coherence;
    
    // Update statistics
    ring.avgArousal := 0.95 * ring.avgArousal + 0.05 * fingerprint.arousal;
    ring.avgDopamine := 0.95 * ring.avgDopamine + 0.05 * fingerprint.dopamine;
    ring.avgFear := 0.95 * ring.avgFear + 0.05 * fingerprint.fear;
    ring.avgSalience := 0.95 * ring.avgSalience + 0.05 * fingerprint.salienceScore;
    
    id
  };

  /// Run matriarch election for a domain
  public func runMatriarchElection(
    ring : AXISEpisodicRing,
    domain : Nat
  ) : ?EmotionalEpisode {
    if (domain >= 16) { return null };
    
    var bestCandidate : ?EmotionalEpisode = null;
    var bestScore : Float = -1.0;
    
    // Find episodes in this domain with highest salience-weighted score
    for (i in Iter.range(0, ring.capacity - 1)) {
      switch (ring.episodes[i]) {
        case null {};
        case (?ep) {
          // Check domain match
          let domainBit = Nat16.toNat(ep.fingerprint.domainBitmask) / Nat.pow(2, domain) % 2;
          if (domainBit == 1) {
            // Score = salience × coherence × (1 + isWitness)
            let score = ep.fingerprint.salienceScore * ep.coherence * (if (ep.isWitness) { 2.0 } else { 1.0 });
            if (score > bestScore) {
              bestScore := score;
              bestCandidate := ?ep;
            };
          };
        };
      };
    };
    
    // Update matriarch
    switch (bestCandidate) {
      case null {};
      case (?candidate) {
        ring.matriarchs[domain] := ?{
          id = candidate.id;
          beat = candidate.beat;
          timestamp = candidate.timestamp;
          coherence = candidate.coherence;
          omnis = candidate.omnis;
          fingerprint = candidate.fingerprint;
          isWitness = candidate.isWitness;
          witnessElevationBeat = candidate.witnessElevationBeat;
          isMatriarch = true;
          matriarchDomain = ?domain;
          replayCount = candidate.replayCount;
          lastReplayBeat = candidate.lastReplayBeat;
          replayStrength = candidate.replayStrength;
          consolidatedToShell3 = candidate.consolidatedToShell3;
          shell3Weight = candidate.shell3Weight;
        };
        ring.matriarchElectionCount += 1;
      };
    };
    
    bestCandidate
  };

  /// Replay episode to Shell 3 (Hebbian consolidation)
  public func replayToShell3(
    ring : AXISEpisodicRing,
    episodeId : Nat64,
    currentBeat : Nat
  ) : Float {
    var replayStrength : Float = 0.0;
    
    for (i in Iter.range(0, ring.capacity - 1)) {
      switch (ring.episodes[i]) {
        case null {};
        case (?ep) {
          if (ep.id == episodeId) {
            // Compute replay strength
            // Strength = salience × coherence × (1 - decay_since_creation)
            let age = currentBeat - ep.beat;
            let decay = Float.exp(-Float.fromInt(age) / 1000.0);
            replayStrength := ep.fingerprint.salienceScore * ep.coherence * decay;
            
            // Update episode
            ring.episodes[i] := ?{
              id = ep.id;
              beat = ep.beat;
              timestamp = ep.timestamp;
              coherence = ep.coherence;
              omnis = ep.omnis;
              fingerprint = ep.fingerprint;
              isWitness = ep.isWitness;
              witnessElevationBeat = ep.witnessElevationBeat;
              isMatriarch = ep.isMatriarch;
              matriarchDomain = ep.matriarchDomain;
              replayCount = ep.replayCount + 1;
              lastReplayBeat = ?currentBeat;
              replayStrength = ep.replayStrength + replayStrength;
              consolidatedToShell3 = true;
              shell3Weight = ep.shell3Weight + replayStrength * 0.1;
            };
            
            ring.totalReplays += 1;
          };
        };
      };
    };
    
    replayStrength
  };

  /// Process replay queue
  public func processReplayQueue(
    ring : AXISEpisodicRing,
    maxReplays : Nat,
    currentBeat : Nat
  ) : Nat {
    var replayed : Nat = 0;
    
    while (replayed < maxReplays and ring.replayQueue.size() > 0) {
      let episodeId = ring.replayQueue[0];
      
      // Remove from queue
      ring.replayQueue := if (ring.replayQueue.size() > 1) {
        Array.subArray(ring.replayQueue, 1, ring.replayQueue.size() - 1)
      } else { [] };
      
      // Replay to Shell 3
      ignore replayToShell3(ring, episodeId, currentBeat);
      replayed += 1;
    };
    
    replayed
  };

  /// Get AXIS ring summary
  public func getAXISSummary(ring : AXISEpisodicRing) : {
    occupancy : Nat;
    witnessCount : Nat;
    matriarchCount : Nat;
    totalReplays : Nat;
    replayQueueSize : Nat;
    velaT10 : Float;
    velaT30 : Float;
    velaT40 : Float;
    velaT50 : Float;
    avgArousal : Float;
    avgDopamine : Float;
    avgFear : Float;
    avgSalience : Float;
  } {
    var matriarchCount : Nat = 0;
    for (m in ring.matriarchs.vals()) {
      switch (m) {
        case (?_) { matriarchCount += 1 };
        case null {};
      };
    };
    
    {
      occupancy = ring.occupancy;
      witnessCount = ring.witnessCount;
      matriarchCount = matriarchCount;
      totalReplays = ring.totalReplays;
      replayQueueSize = ring.replayQueue.size();
      velaT10 = ring.velaT10;
      velaT30 = ring.velaT30;
      velaT40 = ring.velaT40;
      velaT50 = ring.velaT50;
      avgArousal = ring.avgArousal;
      avgDopamine = ring.avgDopamine;
      avgFear = ring.avgFear;
      avgSalience = ring.avgSalience;
    }
  };

}
