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
// ║  This source code constitutes the exclusive intellectual property of Alfredo Medina Hernandez.            ║
// ║  PROTECTED UNDER: 17 U.S.C. §§ 101-1332 | Berne Convention | WIPO | 18 U.S.C. § 1836                     ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// KNOWLEDGE GRAPH ENGINE — SEMANTIC RELATIONSHIP MAPPING
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// This module implements a comprehensive knowledge graph for the super-organism, enabling:
// 1. Entity and concept representation
// 2. Semantic relationship mapping
// 3. Graph traversal and querying
// 4. Knowledge inference and reasoning
// 5. Ontology management
//
// KNOWLEDGE GRAPH ARCHITECTURE:
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
//
// ┌─────────────────────────────────────────────────────────────────────────────────────────────────┐
// │                              KNOWLEDGE GRAPH ENGINE                                              │
// │                                                                                                 │
// │  ┌─────────────────────────────────────────────────────────────────────────────────────────┐  │
// │  │                           TRIPLE STORE (Subject-Predicate-Object)                        │  │
// │  │                                                                                          │  │
// │  │    [Entity A]──────relation──────▶[Entity B]                                            │  │
// │  │        │                              │                                                  │  │
// │  │        │ property                     │ property                                        │  │
// │  │        ▼                              ▼                                                  │  │
// │  │    [Value]                        [Value]                                               │  │
// │  └─────────────────────────────────────────────────────────────────────────────────────────┘  │
// │                                                                                                 │
// │  ┌───────────────┐    ┌───────────────┐    ┌───────────────┐    ┌───────────────┐             │
// │  │   Ontology    │    │   Reasoner    │    │   Indexer     │    │   Query       │             │
// │  │   Manager     │    │   Engine      │    │   Service     │    │   Engine      │             │
// │  └───────────────┘    └───────────────┘    └───────────────┘    └───────────────┘             │
// │                                                                                                 │
// │  ┌─────────────────────────────────────────────────────────────────────────────────────────┐  │
// │  │                        ENTITY TYPES                                                      │  │
// │  │  • Concepts   • Agents   • Tasks   • Goals   • Memories   • Relations   • Events        │  │
// │  └─────────────────────────────────────────────────────────────────────────────────────────┘  │
// └─────────────────────────────────────────────────────────────────────────────────────────────────┘
//
// MATHEMATICAL FOUNDATIONS:
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
//
// • Triple: (subject, predicate, object) ∈ E × R × (E ∪ L) where E = entities, R = relations, L = literals
// • TransE Embedding: ||h + r - t||₂ (head + relation ≈ tail)
// • PageRank: PR(v) = (1-d)/N + d × Σᵤ PR(u)/outdegree(u)
// • Semantic Similarity: sim(a,b) = cos(embedding(a), embedding(b))
// • Path Weight: w(path) = Πᵢ confidence(edgeᵢ)
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:core/Float";
import Int "mo:core/Int";
import Nat "mo:core/Nat";
import Nat8 "mo:core/Nat8";
import Nat64 "mo:core/Nat64";
import Array "mo:core/Array";
import Buffer "mo:core/Buffer";
import Iter "mo:core/Iter";
import Text "mo:core/Text";
import Time "mo:core/Time";
import Option "mo:core/Option";
import Bool "mo:core/Bool";

module KnowledgeGraphEngine {

  // ═══════════════════════════════════════════════════════════════════════════════
  // CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public let PI : Float = 3.14159265358979323846;
  public let E : Float = 2.71828182845904523536;
  
  /// S₀ SOVEREIGNTY FLOOR — MAXED FOR ENTERPRISE-GRADE FINAL PRODUCT
  public let S_ZERO_FLOOR : Float = 1.0;

  // ═══════════════════════════════════════════════════════════════════════════════
  // KNOWLEDGE GRAPH CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Maximum entities
  public let MAX_ENTITIES : Nat = 100000;
  
  /// Maximum relations
  public let MAX_RELATIONS : Nat = 50000;
  
  /// Maximum triples
  public let MAX_TRIPLES : Nat = 500000;
  
  /// Embedding dimension
  public let EMBEDDING_DIM : Nat = 64;
  
  /// PageRank damping factor
  public let PAGERANK_DAMPING : Float = 0.85;
  
  /// PageRank iterations
  public let PAGERANK_ITERATIONS : Nat = 20;
  
  /// Similarity threshold for inference
  public let SIMILARITY_THRESHOLD : Float = 0.7;
  
  /// Maximum path depth for queries
  public let MAX_PATH_DEPTH : Nat = 5;

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 1: ENTITY TYPES
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Entity type
  public type EntityType = {
    #Concept;         // Abstract concept
    #Instance;        // Concrete instance
    #Agent;           // Active entity
    #Task;            // Work item
    #Goal;            // Objective
    #Memory;          // Stored experience
    #Event;           // Temporal occurrence
    #Location;        // Spatial reference
    #Property;        // Attribute value
    #Class;           // Type/category
    #Relation;        // Relationship type
    #Action;          // Executable action
    #State;           // System state
    #Custom : Text;
  };
  
  /// Entity
  public type Entity = {
    entityId : Nat64;
    name : Text;
    entityType : EntityType;
    var description : Text;
    
    // Embedding
    var embedding : [Float];
    
    // Properties
    var properties : Buffer.Buffer<EntityProperty>;
    
    // Graph connections (cached)
    var outgoingEdges : [Nat64];     // Triple IDs
    var incomingEdges : [Nat64];     // Triple IDs
    
    // Metrics
    var pageRank : Float;
    var centralityScore : Float;
    var accessCount : Nat;
    
    // Metadata
    createdBeat : Int;
    var lastModifiedBeat : Int;
    var lastAccessedBeat : Int;
    var isActive : Bool;
  };
  
  /// Entity property
  public type EntityProperty = {
    key : Text;
    value : PropertyValue;
    var confidence : Float;
    sourceBeat : Int;
  };
  
  /// Property value types
  public type PropertyValue = {
    #Text : Text;
    #Number : Float;
    #Boolean : Bool;
    #EntityRef : Nat64;
    #List : [PropertyValue];
    #Map : [(Text, PropertyValue)];
    #Null;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 2: RELATIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Relation type category
  public type RelationCategory = {
    #Taxonomic;       // is-a, type-of
    #Partonomic;      // part-of, contains
    #Associative;     // related-to
    #Causal;          // causes, enables
    #Temporal;        // before, after, during
    #Spatial;         // near, in, contains
    #Functional;      // uses, produces
    #Attributive;     // has-property
    #Comparative;     // larger-than, similar-to
    #Custom;
  };
  
  /// Relation definition
  public type RelationDef = {
    relationId : Nat64;
    name : Text;
    category : RelationCategory;
    var description : Text;
    
    // Constraints
    domainTypes : [EntityType];       // Valid subject types
    rangeTypes : [EntityType];        // Valid object types
    
    // Properties
    var isSymmetric : Bool;
    var isTransitive : Bool;
    var isReflexive : Bool;
    var inverse : ?Nat64;             // Inverse relation ID
    
    // Embedding
    var embedding : [Float];
    
    createdBeat : Int;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 3: TRIPLES
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Triple (Subject-Predicate-Object)
  public type Triple = {
    tripleId : Nat64;
    subjectId : Nat64;
    predicateId : Nat64;             // Relation ID
    objectId : Nat64;                // Entity ID or literal
    var objectLiteral : ?PropertyValue;  // If object is literal
    
    // Confidence and provenance
    var confidence : Float;
    var source : TripleSource;
    var provenanceChain : [Nat64];   // Triple IDs that led to this
    
    // Temporal validity
    validFrom : ?Int;
    validTo : ?Int;
    
    createdBeat : Int;
    var lastVerifiedBeat : Int;
    var isActive : Bool;
  };
  
  /// Triple source
  public type TripleSource = {
    #Asserted;        // Explicitly stated
    #Inferred;        // Derived by reasoning
    #Learned;         // Learned from data
    #Imported;        // From external source
    #User;            // User input
    #System;          // System generated
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 4: ONTOLOGY
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Ontology class
  public type OntologyClass = {
    classId : Nat64;
    name : Text;
    var description : Text;
    parentClassId : ?Nat64;
    var childClassIds : [Nat64];
    var instanceCount : Nat;
    var properties : [ClassProperty];
    createdBeat : Int;
  };
  
  /// Class property definition
  public type ClassProperty = {
    propertyName : Text;
    propertyType : PropertyType;
    isRequired : Bool;
    defaultValue : ?PropertyValue;
  };
  
  /// Property type
  public type PropertyType = {
    #String;
    #Integer;
    #Float;
    #Boolean;
    #Date;
    #EntityRef : ?Nat64;             // Constrained to class
    #Enum : [Text];
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 5: QUERIES
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Query type
  public type QueryType = {
    #FindEntity;
    #FindTriples;
    #PathQuery;
    #PatternMatch;
    #Aggregation;
    #Inference;
  };
  
  /// Query pattern
  public type QueryPattern = {
    subject : QueryTerm;
    predicate : QueryTerm;
    object : QueryTerm;
  };
  
  /// Query term
  public type QueryTerm = {
    #Bound : Nat64;                  // Specific ID
    #Variable : Text;                // Variable to match
    #Wildcard;                       // Match any
    #TypeConstraint : EntityType;    // Match type
    #ValueConstraint : PropertyValue;
  };
  
  /// Query result
  public type QueryResult = {
    queryId : Nat64;
    var bindings : [[(Text, Nat64)]];  // Variable bindings
    var matchedTriples : [Nat64];
    var paths : [[Nat64]];             // For path queries
    var confidence : Float;
    executionTime : Nat;
    totalMatches : Nat;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 6: INFERENCE RULES
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Inference rule
  public type InferenceRule = {
    ruleId : Nat64;
    name : Text;
    var description : Text;
    antecedent : [QueryPattern];     // IF these patterns match
    consequent : QueryPattern;        // THEN add this triple
    var confidence : Float;
    var fireCount : Nat;
    var isEnabled : Bool;
    createdBeat : Int;
  };
  
  /// Inference result
  public type InferenceResult = {
    ruleId : Nat64;
    newTriple : Triple;
    supportingTriples : [Nat64];
    confidence : Float;
    beat : Int;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 7: INDEXES
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Index entry
  public type IndexEntry = {
    key : Text;
    entityIds : [Nat64];
  };
  
  /// Index type
  public type IndexType = {
    #ByName;
    #ByType;
    #ByProperty;
    #ByRelation;
    #FullText;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 8: COMPLETE KNOWLEDGE GRAPH STATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Complete knowledge graph state
  public type KnowledgeGraphState = {
    // Core data
    var entities : Buffer.Buffer<Entity>;
    var relations : Buffer.Buffer<RelationDef>;
    var triples : Buffer.Buffer<Triple>;
    
    // Ontology
    var classes : Buffer.Buffer<OntologyClass>;
    
    // Inference
    var inferenceRules : Buffer.Buffer<InferenceRule>;
    var inferenceResults : Buffer.Buffer<InferenceResult>;
    
    // Indexes
    var nameIndex : Buffer.Buffer<IndexEntry>;
    var typeIndex : Buffer.Buffer<IndexEntry>;
    
    // Statistics
    var totalEntities : Nat;
    var totalTriples : Nat;
    var totalInferences : Nat;
    var averagePageRank : Float;
    
    // Counters
    var entityIdCounter : Nat64;
    var relationIdCounter : Nat64;
    var tripleIdCounter : Nat64;
    var classIdCounter : Nat64;
    var ruleIdCounter : Nat64;
    var queryIdCounter : Nat64;
    var currentBeat : Int;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 9: INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Initialize knowledge graph
  public func initKnowledgeGraph() : KnowledgeGraphState {
    let state : KnowledgeGraphState = {
      var entities = Buffer.Buffer<Entity>(MAX_ENTITIES);
      var relations = Buffer.Buffer<RelationDef>(1000);
      var triples = Buffer.Buffer<Triple>(MAX_TRIPLES);
      
      var classes = Buffer.Buffer<OntologyClass>(500);
      
      var inferenceRules = Buffer.Buffer<InferenceRule>(100);
      var inferenceResults = Buffer.Buffer<InferenceResult>(1000);
      
      var nameIndex = Buffer.Buffer<IndexEntry>(MAX_ENTITIES);
      var typeIndex = Buffer.Buffer<IndexEntry>(100);
      
      var totalEntities = 0;
      var totalTriples = 0;
      var totalInferences = 0;
      var averagePageRank = 0.0;
      
      var entityIdCounter = 0;
      var relationIdCounter = 0;
      var tripleIdCounter = 0;
      var classIdCounter = 0;
      var ruleIdCounter = 0;
      var queryIdCounter = 0;
      var currentBeat = 0;
    };
    
    // Create default relations
    createDefaultRelations(state, 0);
    
    // Create default ontology classes
    createDefaultClasses(state, 0);
    
    // Create default inference rules
    createDefaultRules(state, 0);
    
    state
  };
  
  /// Create default relations
  func createDefaultRelations(state : KnowledgeGraphState, beat : Int) : () {
    // Taxonomic relations
    ignore createRelation(state, "is-a", #Taxonomic, true, true, beat);
    ignore createRelation(state, "type-of", #Taxonomic, false, true, beat);
    ignore createRelation(state, "instance-of", #Taxonomic, false, false, beat);
    
    // Partonomic relations
    ignore createRelation(state, "part-of", #Partonomic, false, true, beat);
    ignore createRelation(state, "contains", #Partonomic, false, true, beat);
    
    // Causal relations
    ignore createRelation(state, "causes", #Causal, false, true, beat);
    ignore createRelation(state, "enables", #Causal, false, false, beat);
    ignore createRelation(state, "prevents", #Causal, false, false, beat);
    
    // Temporal relations
    ignore createRelation(state, "before", #Temporal, false, true, beat);
    ignore createRelation(state, "after", #Temporal, false, true, beat);
    ignore createRelation(state, "during", #Temporal, false, false, beat);
    
    // Associative relations
    ignore createRelation(state, "related-to", #Associative, true, false, beat);
    ignore createRelation(state, "similar-to", #Associative, true, false, beat);
    
    // Functional relations
    ignore createRelation(state, "uses", #Functional, false, false, beat);
    ignore createRelation(state, "produces", #Functional, false, false, beat);
    
    // Attributive relations
    ignore createRelation(state, "has-property", #Attributive, false, false, beat);
    ignore createRelation(state, "has-value", #Attributive, false, false, beat);
  };
  
  /// Create default ontology classes
  func createDefaultClasses(state : KnowledgeGraphState, beat : Int) : () {
    // Root class
    ignore createClass(state, "Thing", null, beat);
    
    // Top-level classes
    ignore createClass(state, "Entity", ?0, beat);
    ignore createClass(state, "Event", ?0, beat);
    ignore createClass(state, "Property", ?0, beat);
    ignore createClass(state, "Relation", ?0, beat);
  };
  
  /// Create default inference rules
  func createDefaultRules(state : KnowledgeGraphState, beat : Int) : () {
    // Transitivity of is-a
    // IF A is-a B AND B is-a C THEN A is-a C
    
    // Symmetry of related-to
    // IF A related-to B THEN B related-to A
    
    // Inheritance of properties
    // IF A is-a B AND B has-property P THEN A has-property P
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 10: ENTITY MANAGEMENT
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Create entity
  public func createEntity(
    state : KnowledgeGraphState,
    name : Text,
    entityType : EntityType,
    description : Text,
    beat : Int
  ) : Nat64 {
    let entityId = state.entityIdCounter;
    state.entityIdCounter += 1;
    
    let entity : Entity = {
      entityId = entityId;
      name = name;
      entityType = entityType;
      var description = description;
      
      var embedding = Array.tabulate<Float>(EMBEDDING_DIM, func(_ : Nat) : Float { 0.0 });
      
      var properties = Buffer.Buffer<EntityProperty>(10);
      
      var outgoingEdges = [];
      var incomingEdges = [];
      
      var pageRank = 1.0 / Float.fromInt(state.totalEntities + 1);
      var centralityScore = 0.0;
      var accessCount = 0;
      
      createdBeat = beat;
      var lastModifiedBeat = beat;
      var lastAccessedBeat = beat;
      var isActive = true;
    };
    
    state.entities.add(entity);
    state.totalEntities += 1;
    
    // Update indexes
    updateNameIndex(state, entityId, name);
    updateTypeIndex(state, entityId, entityType);
    
    // Generate initial embedding
    generateEntityEmbedding(state, entityId);
    
    entityId
  };
  
  /// Update entity
  public func updateEntity(
    state : KnowledgeGraphState,
    entityId : Nat64,
    newDescription : ?Text,
    beat : Int
  ) : Bool {
    for (entity in state.entities.vals()) {
      if (entity.entityId == entityId) {
        switch (newDescription) {
          case (?desc) { entity.description := desc };
          case (null) {};
        };
        entity.lastModifiedBeat := beat;
        return true;
      };
    };
    false
  };
  
  /// Add property to entity
  public func addEntityProperty(
    state : KnowledgeGraphState,
    entityId : Nat64,
    key : Text,
    value : PropertyValue,
    confidence : Float,
    beat : Int
  ) : Bool {
    for (entity in state.entities.vals()) {
      if (entity.entityId == entityId) {
        let property : EntityProperty = {
          key = key;
          value = value;
          var confidence = confidence;
          sourceBeat = beat;
        };
        entity.properties.add(property);
        entity.lastModifiedBeat := beat;
        return true;
      };
    };
    false
  };
  
  /// Get entity by ID
  public func getEntity(state : KnowledgeGraphState, entityId : Nat64) : ?Entity {
    for (entity in state.entities.vals()) {
      if (entity.entityId == entityId) {
        entity.accessCount += 1;
        entity.lastAccessedBeat := state.currentBeat;
        return ?entity;
      };
    };
    null
  };
  
  /// Find entities by name
  public func findEntitiesByName(state : KnowledgeGraphState, name : Text) : [Nat64] {
    var results : [Nat64] = [];
    
    for (entry in state.nameIndex.vals()) {
      if (entry.key == name) {
        return entry.entityIds;
      };
    };
    
    // Fallback to linear search
    for (entity in state.entities.vals()) {
      if (entity.name == name) {
        results := Array.append(results, [entity.entityId]);
      };
    };
    
    results
  };
  
  /// Find entities by type
  public func findEntitiesByType(state : KnowledgeGraphState, entityType : EntityType) : [Nat64] {
    var results : [Nat64] = [];
    
    for (entity in state.entities.vals()) {
      if (entity.entityType == entityType and entity.isActive) {
        results := Array.append(results, [entity.entityId]);
      };
    };
    
    results
  };
  
  /// Update name index
  func updateNameIndex(state : KnowledgeGraphState, entityId : Nat64, name : Text) : () {
    for (entry in state.nameIndex.vals()) {
      if (entry.key == name) {
        // Already exists, would need to update
        return;
      };
    };
    
    let entry : IndexEntry = {
      key = name;
      entityIds = [entityId];
    };
    state.nameIndex.add(entry);
  };
  
  /// Update type index
  func updateTypeIndex(state : KnowledgeGraphState, entityId : Nat64, entityType : EntityType) : () {
    let typeKey = entityTypeToText(entityType);
    
    for (entry in state.typeIndex.vals()) {
      if (entry.key == typeKey) {
        // Would need to update entry
        return;
      };
    };
    
    let entry : IndexEntry = {
      key = typeKey;
      entityIds = [entityId];
    };
    state.typeIndex.add(entry);
  };
  
  /// Entity type to text
  func entityTypeToText(et : EntityType) : Text {
    switch (et) {
      case (#Concept) { "Concept" };
      case (#Instance) { "Instance" };
      case (#Agent) { "Agent" };
      case (#Task) { "Task" };
      case (#Goal) { "Goal" };
      case (#Memory) { "Memory" };
      case (#Event) { "Event" };
      case (#Location) { "Location" };
      case (#Property) { "Property" };
      case (#Class) { "Class" };
      case (#Relation) { "Relation" };
      case (#Action) { "Action" };
      case (#State) { "State" };
      case (#Custom(t)) { t };
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 11: RELATION MANAGEMENT
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Create relation
  public func createRelation(
    state : KnowledgeGraphState,
    name : Text,
    category : RelationCategory,
    isSymmetric : Bool,
    isTransitive : Bool,
    beat : Int
  ) : Nat64 {
    let relationId = state.relationIdCounter;
    state.relationIdCounter += 1;
    
    let relation : RelationDef = {
      relationId = relationId;
      name = name;
      category = category;
      var description = "";
      
      domainTypes = [];
      rangeTypes = [];
      
      var isSymmetric = isSymmetric;
      var isTransitive = isTransitive;
      var isReflexive = false;
      var inverse = null;
      
      var embedding = Array.tabulate<Float>(EMBEDDING_DIM, func(_ : Nat) : Float { 0.0 });
      
      createdBeat = beat;
    };
    
    state.relations.add(relation);
    relationId
  };
  
  /// Get relation by name
  public func getRelationByName(state : KnowledgeGraphState, name : Text) : ?RelationDef {
    for (relation in state.relations.vals()) {
      if (relation.name == name) {
        return ?relation;
      };
    };
    null
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 12: TRIPLE MANAGEMENT
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Create triple
  public func createTriple(
    state : KnowledgeGraphState,
    subjectId : Nat64,
    predicateId : Nat64,
    objectId : Nat64,
    confidence : Float,
    source : TripleSource,
    beat : Int
  ) : ?Nat64 {
    // Validate entities exist
    var subjectExists = false;
    var objectExists = false;
    var predicateExists = false;
    
    for (entity in state.entities.vals()) {
      if (entity.entityId == subjectId) { subjectExists := true };
      if (entity.entityId == objectId) { objectExists := true };
    };
    
    for (relation in state.relations.vals()) {
      if (relation.relationId == predicateId) { predicateExists := true };
    };
    
    if (not subjectExists or not objectExists or not predicateExists) {
      return null;
    };
    
    // Check for duplicate
    for (triple in state.triples.vals()) {
      if (triple.subjectId == subjectId and 
          triple.predicateId == predicateId and
          triple.objectId == objectId and
          triple.isActive) {
        return ?triple.tripleId;  // Already exists
      };
    };
    
    let tripleId = state.tripleIdCounter;
    state.tripleIdCounter += 1;
    
    let triple : Triple = {
      tripleId = tripleId;
      subjectId = subjectId;
      predicateId = predicateId;
      objectId = objectId;
      var objectLiteral = null;
      
      var confidence = confidence;
      var source = source;
      var provenanceChain = [];
      
      validFrom = ?beat;
      validTo = null;
      
      createdBeat = beat;
      var lastVerifiedBeat = beat;
      var isActive = true;
    };
    
    state.triples.add(triple);
    state.totalTriples += 1;
    
    // Update entity edge caches
    for (entity in state.entities.vals()) {
      if (entity.entityId == subjectId) {
        entity.outgoingEdges := Array.append(entity.outgoingEdges, [tripleId]);
      };
      if (entity.entityId == objectId) {
        entity.incomingEdges := Array.append(entity.incomingEdges, [tripleId]);
      };
    };
    
    // Check for inference triggers
    checkInferenceTriggers(state, tripleId, beat);
    
    ?tripleId
  };
  
  /// Create triple with literal object
  public func createTripleWithLiteral(
    state : KnowledgeGraphState,
    subjectId : Nat64,
    predicateId : Nat64,
    literal : PropertyValue,
    confidence : Float,
    beat : Int
  ) : ?Nat64 {
    let tripleId = state.tripleIdCounter;
    state.tripleIdCounter += 1;
    
    let triple : Triple = {
      tripleId = tripleId;
      subjectId = subjectId;
      predicateId = predicateId;
      objectId = 0;  // Not used
      var objectLiteral = ?literal;
      
      var confidence = confidence;
      var source = #Asserted;
      var provenanceChain = [];
      
      validFrom = ?beat;
      validTo = null;
      
      createdBeat = beat;
      var lastVerifiedBeat = beat;
      var isActive = true;
    };
    
    state.triples.add(triple);
    state.totalTriples += 1;
    
    ?tripleId
  };
  
  /// Find triples by pattern
  public func findTriples(
    state : KnowledgeGraphState,
    subjectId : ?Nat64,
    predicateId : ?Nat64,
    objectId : ?Nat64
  ) : [Triple] {
    var results : [Triple] = [];
    
    for (triple in state.triples.vals()) {
      if (not triple.isActive) {
        continue;
      };
      
      var matches = true;
      
      switch (subjectId) {
        case (?sid) { if (triple.subjectId != sid) { matches := false } };
        case (null) {};
      };
      
      switch (predicateId) {
        case (?pid) { if (triple.predicateId != pid) { matches := false } };
        case (null) {};
      };
      
      switch (objectId) {
        case (?oid) { if (triple.objectId != oid) { matches := false } };
        case (null) {};
      };
      
      if (matches) {
        results := Array.append(results, [triple]);
      };
    };
    
    results
  };
  
  /// Delete triple
  public func deleteTriple(state : KnowledgeGraphState, tripleId : Nat64, beat : Int) : Bool {
    for (triple in state.triples.vals()) {
      if (triple.tripleId == tripleId and triple.isActive) {
        triple.isActive := false;
        state.totalTriples -= 1;
        return true;
      };
    };
    false
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 13: ONTOLOGY MANAGEMENT
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Create ontology class
  public func createClass(
    state : KnowledgeGraphState,
    name : Text,
    parentClassId : ?Nat64,
    beat : Int
  ) : Nat64 {
    let classId = state.classIdCounter;
    state.classIdCounter += 1;
    
    let ontologyClass : OntologyClass = {
      classId = classId;
      name = name;
      var description = "";
      parentClassId = parentClassId;
      var childClassIds = [];
      var instanceCount = 0;
      var properties = [];
      createdBeat = beat;
    };
    
    state.classes.add(ontologyClass);
    
    // Update parent's children
    switch (parentClassId) {
      case (?pid) {
        for (parentClass in state.classes.vals()) {
          if (parentClass.classId == pid) {
            parentClass.childClassIds := Array.append(parentClass.childClassIds, [classId]);
          };
        };
      };
      case (null) {};
    };
    
    classId
  };
  
  /// Get class hierarchy
  public func getClassHierarchy(state : KnowledgeGraphState, classId : Nat64) : [Nat64] {
    var hierarchy : [Nat64] = [classId];
    var currentId : ?Nat64 = ?classId;
    
    label L loop {
      switch (currentId) {
        case (?cid) {
          for (ontologyClass in state.classes.vals()) {
            if (ontologyClass.classId == cid) {
              switch (ontologyClass.parentClassId) {
                case (?pid) {
                  hierarchy := Array.append([pid], hierarchy);
                  currentId := ?pid;
                };
                case (null) {
                  currentId := null;
                };
              };
            };
          };
        };
        case (null) { break L };
      };
    };
    
    hierarchy
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 14: INFERENCE ENGINE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Check inference triggers
  func checkInferenceTriggers(state : KnowledgeGraphState, newTripleId : Nat64, beat : Int) : () {
    for (rule in state.inferenceRules.vals()) {
      if (rule.isEnabled) {
        let result = tryApplyRule(state, rule, newTripleId, beat);
        switch (result) {
          case (?r) {
            state.inferenceResults.add(r);
            state.totalInferences += 1;
            rule.fireCount += 1;
          };
          case (null) {};
        };
      };
    };
  };
  
  /// Try to apply an inference rule
  func tryApplyRule(
    state : KnowledgeGraphState,
    rule : InferenceRule,
    triggerTripleId : Nat64,
    beat : Int
  ) : ?InferenceResult {
    // Simplified inference: check transitivity
    // If A relates B and B relates C, then A relates C (for transitive relations)
    
    // Find the trigger triple
    var triggerTriple : ?Triple = null;
    for (triple in state.triples.vals()) {
      if (triple.tripleId == triggerTripleId) {
        triggerTriple := ?triple;
      };
    };
    
    switch (triggerTriple) {
      case (?trigger) {
        // Check if relation is transitive
        for (relation in state.relations.vals()) {
          if (relation.relationId == trigger.predicateId and relation.isTransitive) {
            // Find triples where trigger.object is subject
            let chainTriples = findTriples(state, ?trigger.objectId, ?trigger.predicateId, null);
            
            for (chain in chainTriples.vals()) {
              // Create inferred triple: trigger.subject -> relation -> chain.object
              let newTripleId = createTriple(
                state,
                trigger.subjectId,
                trigger.predicateId,
                chain.objectId,
                trigger.confidence * chain.confidence,
                #Inferred,
                beat
              );
              
              switch (newTripleId) {
                case (?tid) {
                  // Find and update the new triple's provenance
                  for (newTriple in state.triples.vals()) {
                    if (newTriple.tripleId == tid) {
                      newTriple.provenanceChain := [triggerTripleId, chain.tripleId];
                    };
                  };
                  
                  return ?{
                    ruleId = rule.ruleId;
                    newTriple = {
                      tripleId = tid;
                      subjectId = trigger.subjectId;
                      predicateId = trigger.predicateId;
                      objectId = chain.objectId;
                      var objectLiteral = null;
                      var confidence = trigger.confidence * chain.confidence;
                      var source = #Inferred;
                      var provenanceChain = [triggerTripleId, chain.tripleId];
                      validFrom = ?beat;
                      validTo = null;
                      createdBeat = beat;
                      var lastVerifiedBeat = beat;
                      var isActive = true;
                    };
                    supportingTriples = [triggerTripleId, chain.tripleId];
                    confidence = trigger.confidence * chain.confidence;
                    beat = beat;
                  };
                };
                case (null) {};
              };
            };
          };
          
          // Check for symmetric relations
          if (relation.relationId == trigger.predicateId and relation.isSymmetric) {
            // Create reverse triple
            let reverseTripleId = createTriple(
              state,
              trigger.objectId,
              trigger.predicateId,
              trigger.subjectId,
              trigger.confidence,
              #Inferred,
              beat
            );
            
            switch (reverseTripleId) {
              case (?tid) {
                return ?{
                  ruleId = rule.ruleId;
                  newTriple = {
                    tripleId = tid;
                    subjectId = trigger.objectId;
                    predicateId = trigger.predicateId;
                    objectId = trigger.subjectId;
                    var objectLiteral = null;
                    var confidence = trigger.confidence;
                    var source = #Inferred;
                    var provenanceChain = [triggerTripleId];
                    validFrom = ?beat;
                    validTo = null;
                    createdBeat = beat;
                    var lastVerifiedBeat = beat;
                    var isActive = true;
                  };
                  supportingTriples = [triggerTripleId];
                  confidence = trigger.confidence;
                  beat = beat;
                };
              };
              case (null) {};
            };
          };
        };
      };
      case (null) {};
    };
    
    null
  };
  
  /// Run full inference
  public func runInference(state : KnowledgeGraphState, beat : Int) : Nat {
    var newInferences : Nat = 0;
    
    for (triple in state.triples.vals()) {
      if (triple.isActive and triple.source != #Inferred) {
        checkInferenceTriggers(state, triple.tripleId, beat);
      };
    };
    
    newInferences
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 15: GRAPH ALGORITHMS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Compute PageRank
  public func computePageRank(state : KnowledgeGraphState) : () {
    let n = state.entities.size();
    if (n == 0) { return };
    
    // Initialize
    let initialRank = 1.0 / Float.fromInt(n);
    for (entity in state.entities.vals()) {
      entity.pageRank := initialRank;
    };
    
    // Iterate
    for (_ in Iter.range(0, PAGERANK_ITERATIONS - 1)) {
      // Compute new ranks
      for (entity in state.entities.vals()) {
        var newRank = (1.0 - PAGERANK_DAMPING) / Float.fromInt(n);
        
        // Sum contributions from incoming edges
        for (tripleId in entity.incomingEdges.vals()) {
          for (triple in state.triples.vals()) {
            if (triple.tripleId == tripleId and triple.isActive) {
              // Find source entity
              for (source in state.entities.vals()) {
                if (source.entityId == triple.subjectId) {
                  let outDegree = source.outgoingEdges.size();
                  if (outDegree > 0) {
                    newRank += PAGERANK_DAMPING * source.pageRank / Float.fromInt(outDegree);
                  };
                };
              };
            };
          };
        };
        
        entity.pageRank := newRank;
      };
    };
    
    // Update average
    var sum : Float = 0.0;
    for (entity in state.entities.vals()) {
      sum += entity.pageRank;
    };
    state.averagePageRank := sum / Float.fromInt(n);
  };
  
  /// Find shortest path between entities
  public func findShortestPath(
    state : KnowledgeGraphState,
    startId : Nat64,
    endId : Nat64
  ) : ?[Nat64] {
    // BFS
    var visited : [Nat64] = [];
    var queue : [(Nat64, [Nat64])] = [(startId, [startId])];  // (entityId, path)
    
    label BFS loop {
      if (queue.size() == 0) {
        break BFS;
      };
      
      let (currentId, currentPath) = queue[0];
      queue := Array.subArray(queue, 1, queue.size() - 1);
      
      if (currentId == endId) {
        return ?currentPath;
      };
      
      // Check if already visited
      var isVisited = false;
      for (v in visited.vals()) {
        if (v == currentId) { isVisited := true };
      };
      
      if (isVisited) {
        continue BFS;
      };
      
      visited := Array.append(visited, [currentId]);
      
      // Find neighbors
      for (entity in state.entities.vals()) {
        if (entity.entityId == currentId) {
          for (tripleId in entity.outgoingEdges.vals()) {
            for (triple in state.triples.vals()) {
              if (triple.tripleId == tripleId and triple.isActive) {
                let newPath = Array.append(currentPath, [triple.objectId]);
                
                if (newPath.size() <= MAX_PATH_DEPTH) {
                  queue := Array.append(queue, [(triple.objectId, newPath)]);
                };
              };
            };
          };
        };
      };
    };
    
    null
  };
  
  /// Compute semantic similarity between entities
  public func computeSimilarity(state : KnowledgeGraphState, entityId1 : Nat64, entityId2 : Nat64) : Float {
    var emb1 : ?[Float] = null;
    var emb2 : ?[Float] = null;
    
    for (entity in state.entities.vals()) {
      if (entity.entityId == entityId1) { emb1 := ?entity.embedding };
      if (entity.entityId == entityId2) { emb2 := ?entity.embedding };
    };
    
    switch (emb1, emb2) {
      case (?e1, ?e2) {
        // Cosine similarity
        var dotProduct : Float = 0.0;
        var norm1 : Float = 0.0;
        var norm2 : Float = 0.0;
        
        for (i in Iter.range(0, EMBEDDING_DIM - 1)) {
          dotProduct += e1[i] * e2[i];
          norm1 += e1[i] * e1[i];
          norm2 += e2[i] * e2[i];
        };
        
        if (norm1 > 0.0 and norm2 > 0.0) {
          dotProduct / (Float.sqrt(norm1) * Float.sqrt(norm2))
        } else {
          0.0
        }
      };
      case (_, _) { 0.0 };
    }
  };
  
  /// Generate entity embedding
  func generateEntityEmbedding(state : KnowledgeGraphState, entityId : Nat64) : () {
    for (entity in state.entities.vals()) {
      if (entity.entityId == entityId) {
        // Simple embedding based on entity properties
        // In practice, would use TransE or similar
        let seed = Nat64.toNat(entityId) % 1000;
        entity.embedding := Array.tabulate<Float>(EMBEDDING_DIM, func(i : Nat) : Float {
          Float.sin(Float.fromInt(seed + i) * 0.1)
        });
      };
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 16: MAIN HEARTBEAT UPDATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Main knowledge graph heartbeat
  public func heartbeatUpdate(state : KnowledgeGraphState, beat : Int) : KnowledgeGraphHeartbeatResult {
    state.currentBeat := beat;
    
    // 1. Run inference (every 100 beats)
    var newInferences : Nat = 0;
    if (beat % 100 == 0) {
      newInferences := runInference(state, beat);
    };
    
    // 2. Update PageRank (every 1000 beats)
    if (beat % 1000 == 0) {
      computePageRank(state);
    };
    
    // 3. Clean up inactive triples (every 10000 beats)
    if (beat % 10000 == 0) {
      cleanupInactiveTriples(state, beat);
    };
    
    {
      beat = beat;
      totalEntities = state.totalEntities;
      totalTriples = state.totalTriples;
      totalInferences = state.totalInferences;
      newInferences = newInferences;
      averagePageRank = state.averagePageRank;
      classCount = state.classes.size();
      relationCount = state.relations.size();
    }
  };
  
  /// Knowledge graph heartbeat result
  public type KnowledgeGraphHeartbeatResult = {
    beat : Int;
    totalEntities : Nat;
    totalTriples : Nat;
    totalInferences : Nat;
    newInferences : Nat;
    averagePageRank : Float;
    classCount : Nat;
    relationCount : Nat;
  };
  
  /// Cleanup inactive triples
  func cleanupInactiveTriples(state : KnowledgeGraphState, beat : Int) : () {
    // Would remove old inactive triples
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 17: QUERY FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Get total entity count
  public func getTotalEntityCount(state : KnowledgeGraphState) : Nat {
    state.totalEntities
  };
  
  /// Get total triple count
  public func getTotalTripleCount(state : KnowledgeGraphState) : Nat {
    state.totalTriples
  };
  
  /// Get total inference count
  public func getTotalInferenceCount(state : KnowledgeGraphState) : Nat {
    state.totalInferences
  };
  
  /// Get average PageRank
  public func getAveragePageRank(state : KnowledgeGraphState) : Float {
    state.averagePageRank
  };
  
  /// Get entity neighbors
  public func getEntityNeighbors(state : KnowledgeGraphState, entityId : Nat64) : [Nat64] {
    var neighbors : [Nat64] = [];
    
    for (entity in state.entities.vals()) {
      if (entity.entityId == entityId) {
        for (tripleId in entity.outgoingEdges.vals()) {
          for (triple in state.triples.vals()) {
            if (triple.tripleId == tripleId and triple.isActive) {
              neighbors := Array.append(neighbors, [triple.objectId]);
            };
          };
        };
        for (tripleId in entity.incomingEdges.vals()) {
          for (triple in state.triples.vals()) {
            if (triple.tripleId == tripleId and triple.isActive) {
              neighbors := Array.append(neighbors, [triple.subjectId]);
            };
          };
        };
      };
    };
    
    neighbors
  };
  
  /// Get top entities by PageRank
  public func getTopEntitiesByPageRank(state : KnowledgeGraphState, count : Nat) : [(Nat64, Float)] {
    var ranked : [(Nat64, Float)] = [];
    
    for (entity in state.entities.vals()) {
      if (entity.isActive) {
        ranked := Array.append(ranked, [(entity.entityId, entity.pageRank)]);
      };
    };
    
    // Sort by PageRank descending
    ranked := Array.sort(ranked, func(a : (Nat64, Float), b : (Nat64, Float)) : { #less; #equal; #greater } {
      if (a.1 > b.1) { #less } else if (a.1 < b.1) { #greater } else { #equal }
    });
    
    // Take top N
    Array.subArray(ranked, 0, Nat.min(count, ranked.size()))
  };

}
