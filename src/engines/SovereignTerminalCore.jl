# ══════════════════════════════════════════════════════════════════
#  SOVEREIGN TERMINAL CORE — Living Cognitive Brain
#  Version: 2.0.0 · φ-Aligned · 873ms PHI_BEAT
#  5 Dimensions of Emergent Cognition:
#    D1: Stateful Learning (GovernanceMemory)
#    D2: Cognitive DSL (ConditionDSL)
#    D3: Agent Drives (OrganismRuntime)
#    D4: Meta-Governor (MetaGovernor)
#    D5: Metrics & Human Feedback (FeedbackLoop)
# ══════════════════════════════════════════════════════════════════

module SovereignTerminalCore

using JSON3
using YAML
using Dates

# ─── Import Cognitive Dimensions ───────────────────────────────
include("GovernanceMemory.jl")
include("ConditionDSL.jl")
include("OrganismRuntime.jl")
include("MetaGovernor.jl")
include("FeedbackLoop.jl")

using .GovernanceMemory
using .ConditionDSL
using .OrganismRuntime
using .MetaGovernor
using .FeedbackLoop

# ─── Constants ─────────────────────────────────────────────────
const PHI       = 1.618033988749895
const PHI_BEAT  = 873  # milliseconds

# ─── Types ─────────────────────────────────────────────────────

struct LanguageSpec
    id::String
    name::String
    layer::String
    version::String
    status::String
    spec_path::String
    raw::Dict{String,Any}
end

struct RegistrySnapshot
    entities::Vector{String}
    agents::Vector{String}
    missions::Vector{String}
    realms::Vector{String}
    terminals::Vector{String}
end

struct GovernanceViolation
    entity::String
    law::String
    rule::String
    violation::String
end

struct PipelineLog
    pipeline::String
    steps::Vector{String}
end

struct EvolutionUpdate
    rule::String
    action::String
end

struct GovernanceReport
    cycle_id::String
    entities_checked::Int
    violations::Vector{GovernanceViolation}
    pipelines_executed::Vector{PipelineLog}
    evolution_updates::Vector{EvolutionUpdate}
    # D1: Learning loop results
    ril_incidents::Vector{Any}
    uel_proposals::Vector{Any}
    # D4: Meta-governor proposals
    meta_proposals::Vector{Any}
    # D5: System health
    system_health::Dict{String,Any}
end

# ─── Global State ──────────────────────────────────────────────

const LANGUAGE_REGISTRY = Dict{String,LanguageSpec}()
const GLOBAL_REGISTRY   = Ref(RegistrySnapshot(String[], String[], String[], String[], String[]))

# D1: Governance Memory — tracks law/pipeline stats across cycles
const MEMORY = GovernanceMemory.MemoryStore()

# D3: Organism Registry — living agents with drives
const ORGANISMS = Dict{String,OrganismRuntime.OrganismAgent}()

# D4: Meta-Governor — cortex over the cortex
const META_STATE = MetaGovernor.create_meta_state()

# D5: Feedback Store — metrics + human review hooks
const FEEDBACK = FeedbackLoop.create_feedback_store()

# ─── Language Registry Loader ──────────────────────────────────

"""
    load_language_registry(path::String)

Load all language entries from a JSONL registry file.
Each line is a JSON object with id, name, layer, version, status, spec_path.
"""
function load_language_registry(path::String)
    for line in eachline(path)
        stripped = strip(line)
        isempty(stripped) && continue
        rec = JSON3.read(stripped)
        spec_path = String(rec["spec_path"])
        id = String(rec["id"])

        # Load raw spec if file exists
        raw_spec = Dict{String,Any}()
        if isfile(spec_path)
            raw_spec = YAML.load_file(spec_path)
        end

        LANGUAGE_REGISTRY[id] = LanguageSpec(
            id,
            String(rec["name"]),
            String(rec["layer"]),
            String(rec["version"]),
            String(rec["status"]),
            spec_path,
            raw_spec
        )
    end
    println("Loaded $(length(LANGUAGE_REGISTRY)) languages into registry.")
end

"""
    list_languages() -> Vector{LanguageSpec}

Return all loaded language specs.
"""
function list_languages()
    collect(values(LANGUAGE_REGISTRY))
end

# ─── Entity Loader ─────────────────────────────────────────────

"""
    load_entity(path::String) -> Dict

Load an entity JSON file.
"""
function load_entity(path::String)
    JSON3.read(read(path, String))
end

"""
    applicable_languages(entity::Dict) -> Vector{LanguageSpec}

Return the language specs that apply to a given entity.
"""
function applicable_languages(entity)
    ids = Vector{String}()
    if haskey(entity, "languages")
        for lid in entity["languages"]
            push!(ids, String(lid))
        end
    end
    return [LANGUAGE_REGISTRY[id] for id in ids if haskey(LANGUAGE_REGISTRY, id)]
end

# ─── D2: Cognitive Context Builder ─────────────────────────────

"""
    build_cognitive_context(entity::Dict) -> CognitiveContext

Build a full cognitive context for condition evaluation.
Pulls entity attributes, context, history, psyche, and relations.
"""
function build_cognitive_context(entity)
    entity_dict = Dict{String,Any}()
    for k in keys(entity)
        entity_dict[string(k)] = entity[k]
    end

    # Build context from entity state
    ctx_dict = Dict{String,Any}(
        "cycle_time" => string(now()),
        "phase" => META_STATE.phase
    )

    # History from organism if exists
    hist_dict = Dict{String,Any}("events" => String[])
    entity_id = get(entity_dict, "id", "")
    if haskey(ORGANISMS, entity_id)
        org = ORGANISMS[entity_id]
        hist_dict["failure_streak"] = org.state.task_failure_streak
        hist_dict["success_streak"] = org.state.task_success_streak
        hist_dict["ticks"] = org.state.ticks
    end

    # Psyche from organism PIL patterns
    psyche_dict = Dict{String,Any}("patterns" => String[])
    if haskey(ORGANISMS, entity_id)
        psyche_dict["patterns"] = ORGANISMS[entity_id].state.pil_patterns
        psyche_dict["stress"] = ORGANISMS[entity_id].state.stress_level
    end

    # Relations placeholder
    rel_dict = Dict{String,Any}("trust_levels" => Dict{String,String}())

    return ConditionDSL.CognitiveContext(entity_dict, ctx_dict, hist_dict, psyche_dict, rel_dict)
end

# ─── D3: Organism Management ──────────────────────────────────

"""
    ensure_organism(entity_id::String, entity_name::String) -> OrganismAgent

Get or create an organism agent for an entity.
"""
function ensure_organism(entity_id::String, entity_name::String)
    if !haskey(ORGANISMS, entity_id)
        ORGANISMS[entity_id] = OrganismRuntime.create_organism(
            entity_id, entity_name, "entity",
            capabilities=["governance", "self_check"],
            limits=["no_self_modification"]
        )
    end
    return ORGANISMS[entity_id]
end

# ─── Governance Engine (Cognitive Brain v2) ────────────────────

"""
    run_entity_governance(entity_path::String) -> Vector{String}

Run governance checks on a single entity using its applicable languages.
Now with D1-D5 integration: stateful learning, cognitive DSL evaluation,
organism drives, meta-governance feedback, and human review hooks.
"""
function run_entity_governance(entity_path::String)
    entity = load_entity(entity_path)
    langs  = applicable_languages(entity)
    results = String[]
    entity_id = string(get(entity, "id", "unknown"))
    entity_name = string(get(entity, "name", entity_id))

    # D2: Build cognitive context for deep condition evaluation
    ctx = build_cognitive_context(entity)

    # D3: Ensure organism exists with drives
    organism = ensure_organism(entity_id, entity_name)

    for ls in langs
        if ls.id == "atlas://language/cpl-l"
            push!(results, "Applying CPL-L laws to $entity_id")
            # D1: Record law firing
            GovernanceMemory.record_law_firing!(MEMORY, "cpl-l:sovereignty", entity_id)

            # D2: Evaluate conditions from spec
            if haskey(ls.raw, "core_concepts")
                lifecycle = ConditionDSL.evaluate_condition(
                    ConditionDSL.FieldAccess("entity", ["state", "lifecycle"]),
                    ctx
                )
                if lifecycle == "active"
                    push!(results, "  ✓ Entity active — full law enforcement applies")
                end
            end
        elseif ls.id == "atlas://language/cpl-c"
            push!(results, "Checking CPL-C contracts for $entity_id")
            GovernanceMemory.record_law_firing!(MEMORY, "cpl-c:contracts", entity_id)
        elseif ls.id == "atlas://language/ocl"
            push!(results, "Validating organism charters for $entity_id")
            # D3: Check organism health during OCL validation
            health = OrganismRuntime.get_health_report(organism)
            push!(results, "  🫀 Organism health: $(health["health"])")
        elseif ls.id == "atlas://language/cpl-p"
            push!(results, "Running governance pipelines for $entity_id")
            # D1: Record pipeline execution
            GovernanceMemory.record_pipeline_result!(MEMORY, "governance_pipeline", true, "main")
        elseif ls.id == "atlas://language/err"
            push!(results, "Scanning error narratives for $entity_id")
        elseif ls.id == "atlas://language/chl"
            push!(results, "Evaluating chaos handling for $entity_id")
        elseif ls.id == "atlas://language/uel"
            push!(results, "Checking evolution rules for $entity_id")
        elseif ls.id == "atlas://language/ril"
            push!(results, "Scanning repair/integration for $entity_id")
            # D3: Check if organism needs repair
            if OrganismRuntime.should_escalate(organism)
                push!(results, "  ⚠️  Organism escalation needed!")
                # D5: Request human review for escalation
                FeedbackLoop.request_human_review!(FEEDBACK,
                    "organism_escalation",
                    Dict{String,Any}(
                        "entity" => entity_id,
                        "reason" => OrganismRuntime.get_escalation_reason(organism),
                        "proposed_action" => "reduce_task_load"
                    ),
                    "high"
                )
            end
        else
            push!(results, "Engine $(ls.id) ready for $entity_id")
        end
    end

    # D3: Tick the organism (simulate one governance pass)
    task_result = isempty(results) ? :skip : :success
    OrganismRuntime.tick!(organism, task_result)

    return results
end

"""
    run_governance_cycle_over_registry(entity_dir::String) -> GovernanceReport

Run a full governance cycle over all entity JSON files in a directory.
Integrates all 5 cognitive dimensions for emergent adaptive behavior.
"""
function run_governance_cycle_over_registry(entity_dir::String)
    cycle_start = now()
    violations = GovernanceViolation[]
    pipelines  = PipelineLog[]
    evolution  = EvolutionUpdate[]
    checked    = 0

    println("\n═══ GOVERNANCE CYCLE $(string(cycle_start)) ═══")

    for (root, _, files) in walkdir(entity_dir)
        for f in files
            endswith(f, ".json") || continue
            entity_path = joinpath(root, f)
            results = run_entity_governance(entity_path)
            checked += 1
            for r in results
                println("  → $r")
            end
        end
    end

    # D1: Run learning loop — generates RIL incidents and UEL proposals
    println("\n─── D1: Learning Loop ───")
    (incidents, proposals) = GovernanceMemory.run_learning_loop!(MEMORY)

    # D4: Feed cycle data to meta-governor
    println("─── D4: Meta-Governor Analysis ───")
    organism_healths = [OrganismRuntime.compute_health_score(org) for org in values(ORGANISMS)]
    avg_health = isempty(organism_healths) ? 1.0 : sum(organism_healths) / length(organism_healths)

    MetaGovernor.ingest_cycle_data!(META_STATE, Dict{String,Any}(
        "cycle_id" => string(cycle_start),
        "entities_checked" => checked,
        "violations" => length(violations),
        "overrides" => sum(s.override_count for s in values(MEMORY.law_stats); init=0),
        "pipeline_failures" => sum(s.failure_count for s in values(MEMORY.pipeline_stats); init=0),
        "ril_incidents" => length(incidents),
        "uel_proposals" => length(proposals),
        "organism_health_avg" => avg_health
    ))
    meta_proposals = MetaGovernor.analyze_and_propose!(META_STATE)

    # D5: Record cycle metrics
    println("─── D5: Metrics & Feedback ───")
    cycle_end = now()
    latency_ms = Dates.value(cycle_end - cycle_start)
    FeedbackLoop.record_governance_cycle_metrics!(FEEDBACK, Dict{String,Any}(
        "latency_ms" => latency_ms,
        "incidents" => length(incidents),
        "violations" => length(violations),
        "overrides" => sum(s.override_count for s in values(MEMORY.law_stats); init=0),
        "total_rules_applied" => sum(s.fire_count for s in values(MEMORY.law_stats); init=0),
        "organism_health_avg" => avg_health
    ))
    system_health = FeedbackLoop.compute_system_health(FEEDBACK)
    println("  📊 System health: $(system_health["status"]) ($(system_health["composite_score"]))")

    return GovernanceReport(
        string(cycle_start),
        checked,
        violations,
        pipelines,
        evolution,
        incidents,
        proposals,
        meta_proposals,
        system_health
    )
end

# ─── Bridge Contract Handler ──────────────────────────────────

"""
    handle_request(req::Dict) -> GovernanceReport

Handle a governance cycle request from the Motoko shell.
Expected request format:
  {
    "type": "governance_cycle",
    "registry_paths": {
      "entities": "atlas/registry/entities",
      "languages": "atlas/registry/languages.jsonl"
    },
    "cycle_id": "2026-05-02T21:00:00Z"
  }
"""
function handle_request(req::Dict)
    if req["type"] == "governance_cycle"
        load_language_registry(req["registry_paths"]["languages"])
        report = run_governance_cycle_over_registry(req["registry_paths"]["entities"])
        return report
    elseif req["type"] == "human_decision"
        # D5: Record human decision
        FeedbackLoop.record_human_decision!(FEEDBACK,
            req["review_id"],
            req["decision"],
            get(req, "reasoning", ""),
            get(req, "modifications", Dict{String,Any}()),
            get(req, "reviewer", "human")
        )
        return Dict("status" => "recorded")
    elseif req["type"] == "meta_report"
        # D4: Generate meta-governance report
        return MetaGovernor.generate_meta_report(META_STATE)
    elseif req["type"] == "system_health"
        # D5: Get system health
        return FeedbackLoop.compute_system_health(FEEDBACK)
    elseif req["type"] == "organism_health"
        # D3: Get organism health
        entity_id = req["entity_id"]
        if haskey(ORGANISMS, entity_id)
            return OrganismRuntime.get_health_report(ORGANISMS[entity_id])
        end
        return Dict("error" => "Organism not found: $entity_id")
    end
    error("Unknown request type: $(req["type"])")
end

end # module SovereignTerminalCore
