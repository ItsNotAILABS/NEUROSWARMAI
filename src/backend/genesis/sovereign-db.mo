// ══════════════════════════════════════════════════════════════════════════════════
// SOVEREIGN_DB.MO — Vector Embedding Registry for M-01 through M-300 Models
// ══════════════════════════════════════════════════════════════════════════════════
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
//
// This module stores M-01 through M-300 models as MEDINA-ARTIFACTs with:
// - Vector embeddings (Float64 arrays, 1,024 or 3,072 dims)
// - FNV-1a hashes for sovereign IDs
// - Semantic retrieval via cosine similarity
// - Stable persistence (organism's body, not memory)
// ══════════════════════════════════════════════════════════════════════════════════

import Float "mo:core/Float";
import Array "mo:core/Array";
import Text "mo:core/Text";
import Nat "mo:core/Nat";
import Nat32 "mo:core/Nat32";
import Nat64 "mo:core/Nat64";
import Int "mo:core/Int";
import Time "mo:core/Time";
import Buffer "mo:core/Buffer";

module SovereignDB {

  // ════════════════════════════════════════════════════════════════
  // TYPES
  // ════════════════════════════════════════════════════════════════

  /// MEDINA-ARTIFACT — 4-Layer Model Structure
  public type MedinaArtifact = {
    id: Text;              // M-001, M-002, etc.
    name: Text;
    domain: Text;
    hash: Text;            // FNV-1a hash (256-dim sovereign ID)
    embedding: [Float];    // Vector embedding (1,024 or 3,072 dims)
    inputTypes: [Text];    // ['text'], ['text', 'image'], etc.
    timestamp: Int;
    accessCount: Nat;
    lastAccess: Int;

    // 4 Layers
    semanticLayer: SemanticLayer;
    contextualLayer: ContextualLayer;
    executionLayer: ExecutionLayer;
    resultLayer: ResultLayer;
  };

  public type SemanticLayer = {
    description: Text;
    keywords: [Text];
  };

  public type ContextualLayer = {
    supportedInputs: [Text];
    outputFormat: Text;
  };

  public type ExecutionLayer = {
    timeout: Nat; // milliseconds
  };

  public type ResultLayer = {
    successRate: Float;
    averageExecutionTime: Float;
    totalExecutions: Nat;
  };

  /// Memory Entry for MEMORIA
  public type MemoriaEntry = {
    id: Text;
    content: Text;
    embedding: [Float];
    category: Text;
    hash: Text;
    timestamp: Int;
    accessCount: Nat;
    lastAccess: Int;
  };

  /// Formula Entry for CODEX MATHEMATICUS
  public type CodexFormula = {
    id: Text;
    name: Text;
    formula: Text;
    latex: Text;
    embedding: [Float];
    category: Text;
    tags: [Text];
    description: Text;
    timestamp: Int;
    accessCount: Nat;
  };

  // ════════════════════════════════════════════════════════════════
  // STATE
  // ════════════════════════════════════════════════════════════════

  public type State = {
    var models: [MedinaArtifact];
    var memories: [MemoriaEntry];
    var formulas: [CodexFormula];
    var totalModelExecutions: Nat;
    var totalMemoriaQueries: Nat;
    var totalCodexQueries: Nat;
  };

  public func initState(): State {
    {
      var models = [];
      var memories = [];
      var formulas = [];
      var totalModelExecutions = 0;
      var totalMemoriaQueries = 0;
      var totalCodexQueries = 0;
    }
  };

  // ════════════════════════════════════════════════════════════════
  // FNV-1a HASH (256-dim Micro-Token Compression)
  // ════════════════════════════════════════════════════════════════

  public func fnv1aHash(str: Text): Text {
    let FNV_PRIME: Nat32 = 0x01000193;
    let FNV_OFFSET: Nat32 = 0x811c9dc5;

    var hash: Nat32 = FNV_OFFSET;

    for (char in str.chars()) {
      let code = Nat32.fromNat(Nat32.toNat(Char.toNat32(char)));
      hash := hash ^ code;
      hash := hash *% FNV_PRIME; // wrapping multiplication
    };

    Nat32.toText(hash)
  };

  // ════════════════════════════════════════════════════════════════
  // VECTOR OPERATIONS
  // ════════════════════════════════════════════════════════════════

  /// Compute cosine similarity between two vectors
  public func cosineSimilarity(vec1: [Float], vec2: [Float]): Float {
    if (vec1.size() != vec2.size()) return 0.0;

    var dotProduct: Float = 0.0;
    var norm1: Float = 0.0;
    var norm2: Float = 0.0;

    for (i in vec1.keys()) {
      dotProduct += vec1[i] * vec2[i];
      norm1 += vec1[i] * vec1[i];
      norm2 += vec2[i] * vec2[i];
    };

    if (norm1 == 0.0 or norm2 == 0.0) return 0.0;

    dotProduct / (Float.sqrt(norm1) * Float.sqrt(norm2))
  };

  // ════════════════════════════════════════════════════════════════
  // MODEL REGISTRY OPERATIONS
  // ════════════════════════════════════════════════════════════════

  /// Register a model
  public func registerModel(
    state: State,
    id: Text,
    name: Text,
    domain: Text,
    embedding: [Float],
    inputTypes: [Text],
  ): Text {
    let hash = fnv1aHash(id # name # domain);

    let model: MedinaArtifact = {
      id;
      name;
      domain;
      hash;
      embedding;
      inputTypes;
      timestamp = Time.now();
      accessCount = 0;
      lastAccess = Time.now();
      semanticLayer = {
        description = name # " operates in " # domain # " domain";
        keywords = [];
      };
      contextualLayer = {
        supportedInputs = inputTypes;
        outputFormat = "text";
      };
      executionLayer = {
        timeout = 5000;
      };
      resultLayer = {
        successRate = 0.0;
        averageExecutionTime = 0.0;
        totalExecutions = 0;
      };
    };

    let buffer = Buffer.Buffer<MedinaArtifact>(state.models.size() + 1);
    for (m in state.models.vals()) {
      buffer.add(m);
    };
    buffer.add(model);
    state.models := Buffer.toArray(buffer);

    hash
  };

  /// Get model by ID
  public func getModel(state: State, modelId: Text): ?MedinaArtifact {
    for (model in state.models.vals()) {
      if (model.id == modelId) {
        return ?model;
      };
    };
    null
  };

  /// Get models by domain
  public func getModelsByDomain(state: State, domain: Text): [MedinaArtifact] {
    let buffer = Buffer.Buffer<MedinaArtifact>(0);
    for (model in state.models.vals()) {
      if (model.domain == domain) {
        buffer.add(model);
      };
    };
    Buffer.toArray(buffer)
  };

  /// Query models by semantic proximity (top-K)
  public func queryModels(state: State, queryEmbedding: [Float], topK: Nat): [MedinaArtifact] {
    // Compute similarities
    type ScoredModel = (MedinaArtifact, Float);
    let buffer = Buffer.Buffer<ScoredModel>(state.models.size());

    for (model in state.models.vals()) {
      let similarity = cosineSimilarity(queryEmbedding, model.embedding);
      buffer.add((model, similarity));
    };

    let scored = Buffer.toArray(buffer);

    // Sort by similarity descending (simple bubble sort for now)
    let sorted = Array.sort<ScoredModel>(
      scored,
      func(a: ScoredModel, b: ScoredModel): { #less; #equal; #greater } {
        if (a.1 > b.1) #less
        else if (a.1 < b.1) #greater
        else #equal
      }
    );

    // Take top-K
    let limit = Nat.min(topK, sorted.size());
    Array.tabulate<MedinaArtifact>(limit, func(i) { sorted[i].0 })
  };

  // ════════════════════════════════════════════════════════════════
  // MEMORIA OPERATIONS
  // ════════════════════════════════════════════════════════════════

  /// Store memory
  public func storeMemory(
    state: State,
    content: Text,
    embedding: [Float],
    category: Text,
  ): Text {
    let id = "mem_" # Int.toText(Time.now());
    let hash = fnv1aHash(content);

    let memory: MemoriaEntry = {
      id;
      content;
      embedding;
      category;
      hash;
      timestamp = Time.now();
      accessCount = 0;
      lastAccess = Time.now();
    };

    let buffer = Buffer.Buffer<MemoriaEntry>(state.memories.size() + 1);
    for (m in state.memories.vals()) {
      buffer.add(m);
    };
    buffer.add(memory);
    state.memories := Buffer.toArray(buffer);

    id
  };

  /// Query memories by semantic proximity
  public func queryMemoria(state: State, queryEmbedding: [Float], topK: Nat): [MemoriaEntry] {
    state.totalMemoriaQueries += 1;

    type ScoredMemory = (MemoriaEntry, Float);
    let buffer = Buffer.Buffer<ScoredMemory>(state.memories.size());

    for (memory in state.memories.vals()) {
      let similarity = cosineSimilarity(queryEmbedding, memory.embedding);
      buffer.add((memory, similarity));
    };

    let scored = Buffer.toArray(buffer);

    let sorted = Array.sort<ScoredMemory>(
      scored,
      func(a: ScoredMemory, b: ScoredMemory): { #less; #equal; #greater } {
        if (a.1 > b.1) #less
        else if (a.1 < b.1) #greater
        else #equal
      }
    );

    let limit = Nat.min(topK, sorted.size());
    Array.tabulate<MemoriaEntry>(limit, func(i) { sorted[i].0 })
  };

  // ════════════════════════════════════════════════════════════════
  // CODEX OPERATIONS
  // ════════════════════════════════════════════════════════════════

  /// Store formula
  public func storeFormula(
    state: State,
    name: Text,
    formula: Text,
    latex: Text,
    embedding: [Float],
    category: Text,
    tags: [Text],
    description: Text,
  ): Text {
    let id = "formula_" # Int.toText(Time.now());

    let formulaEntry: CodexFormula = {
      id;
      name;
      formula;
      latex;
      embedding;
      category;
      tags;
      description;
      timestamp = Time.now();
      accessCount = 0;
    };

    let buffer = Buffer.Buffer<CodexFormula>(state.formulas.size() + 1);
    for (f in state.formulas.vals()) {
      buffer.add(f);
    };
    buffer.add(formulaEntry);
    state.formulas := Buffer.toArray(buffer);

    id
  };

  /// Query formulas by semantic proximity
  public func queryCodex(state: State, queryEmbedding: [Float], topK: Nat): [CodexFormula] {
    state.totalCodexQueries += 1;

    type ScoredFormula = (CodexFormula, Float);
    let buffer = Buffer.Buffer<ScoredFormula>(state.formulas.size());

    for (formula in state.formulas.vals()) {
      let similarity = cosineSimilarity(queryEmbedding, formula.embedding);
      buffer.add((formula, similarity));
    };

    let scored = Buffer.toArray(buffer);

    let sorted = Array.sort<ScoredFormula>(
      scored,
      func(a: ScoredFormula, b: ScoredFormula): { #less; #equal; #greater } {
        if (a.1 > b.1) #less
        else if (a.1 < b.1) #greater
        else #equal
      }
    );

    let limit = Nat.min(topK, sorted.size());
    Array.tabulate<CodexFormula>(limit, func(i) { sorted[i].0 })
  };

  // ════════════════════════════════════════════════════════════════
  // STATS
  // ════════════════════════════════════════════════════════════════

  public func getStats(state: State): {
    totalModels: Nat;
    totalMemories: Nat;
    totalFormulas: Nat;
    totalModelExecutions: Nat;
    totalMemoriaQueries: Nat;
    totalCodexQueries: Nat;
  } {
    {
      totalModels = state.models.size();
      totalMemories = state.memories.size();
      totalFormulas = state.formulas.size();
      totalModelExecutions = state.totalModelExecutions;
      totalMemoriaQueries = state.totalMemoriaQueries;
      totalCodexQueries = state.totalCodexQueries;
    }
  };
}
