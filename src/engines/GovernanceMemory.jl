# ══════════════════════════════════════════════════════════════════
#  GOVERNANCE MEMORY — Stateful Learning Layer for Laws & Pipelines
#  Dimension 1: Makes the brain self-reflective.
#  Tracks rule firings, conflicts, overrides, pipeline success/failure.
#  After each cycle: summarizes into RIL incidents + UEL evolution proposals.
#  Version: 1.0.0 · φ-Aligned · 873ms PHI_BEAT
# ══════════════════════════════════════════════════════════════════

module GovernanceMemory

using Dates

export LawStat, PipelineStat, MemoryStore,
       record_law_firing!, record_law_override!, record_law_conflict!,
       record_pipeline_result!,
       summarize_law_stats, summarize_pipeline_stats,
       generate_ril_incidents, generate_uel_proposals,
       run_learning_loop!

# ─── Types ─────────────────────────────────────────────────────

mutable struct LawStat
    rule_id::String
    fire_count::Int
    conflict_count::Int
    override_count::Int
    last_fired::String
    entities_affected::Vector{String}
end

mutable struct PipelineStat
    pipeline_id::String
    success_count::Int
    failure_count::Int
    escalation_count::Int
    last_run::String
    branches_taken::Dict{String,Int}
end

struct RILIncident
    id::String
    timestamp::String
    source::String
    pattern::String
    severity::String
    description::String
    proposed_action::String
end

struct UELProposal
    id::String
    timestamp::String
    rule_id::String
    trigger::String
    proposed_change::String
    evidence::Vector{String}
    confidence::Float64
end

mutable struct MemoryStore
    law_stats::Dict{String,LawStat}
    pipeline_stats::Dict{String,PipelineStat}
    incidents::Vector{RILIncident}
    proposals::Vector{UELProposal}
    cycle_count::Int
end

# ─── Constructor ───────────────────────────────────────────────

function MemoryStore()
    MemoryStore(
        Dict{String,LawStat}(),
        Dict{String,PipelineStat}(),
        RILIncident[],
        UELProposal[],
        0
    )
end

# ─── Law Recording ─────────────────────────────────────────────

function record_law_firing!(store::MemoryStore, rule_id::String, entity_id::String)
    ts = string(now())
    if !haskey(store.law_stats, rule_id)
        store.law_stats[rule_id] = LawStat(rule_id, 0, 0, 0, ts, String[])
    end
    stat = store.law_stats[rule_id]
    stat.fire_count += 1
    stat.last_fired = ts
    if !(entity_id in stat.entities_affected)
        push!(stat.entities_affected, entity_id)
    end
end

function record_law_override!(store::MemoryStore, rule_id::String, entity_id::String)
    record_law_firing!(store, rule_id, entity_id)
    store.law_stats[rule_id].override_count += 1
end

function record_law_conflict!(store::MemoryStore, rule_id::String, conflicting_rule::String)
    ts = string(now())
    if !haskey(store.law_stats, rule_id)
        store.law_stats[rule_id] = LawStat(rule_id, 0, 0, 0, ts, String[])
    end
    store.law_stats[rule_id].conflict_count += 1
end

# ─── Pipeline Recording ───────────────────────────────────────

function record_pipeline_result!(store::MemoryStore, pipeline_id::String, success::Bool, branch::String="main")
    ts = string(now())
    if !haskey(store.pipeline_stats, pipeline_id)
        store.pipeline_stats[pipeline_id] = PipelineStat(pipeline_id, 0, 0, 0, ts, Dict{String,Int}())
    end
    stat = store.pipeline_stats[pipeline_id]
    if success
        stat.success_count += 1
    else
        stat.failure_count += 1
    end
    stat.last_run = ts
    stat.branches_taken[branch] = get(stat.branches_taken, branch, 0) + 1
end

# ─── Summarization ─────────────────────────────────────────────

function summarize_law_stats(store::MemoryStore)
    summary = Dict{String,Any}[]
    for (id, stat) in store.law_stats
        push!(summary, Dict(
            "rule_id" => id,
            "fire_count" => stat.fire_count,
            "conflict_count" => stat.conflict_count,
            "override_count" => stat.override_count,
            "override_rate" => stat.fire_count > 0 ? stat.override_count / stat.fire_count : 0.0,
            "entities_affected" => length(stat.entities_affected)
        ))
    end
    sort!(summary, by=x -> x["override_rate"], rev=true)
    return summary
end

function summarize_pipeline_stats(store::MemoryStore)
    summary = Dict{String,Any}[]
    for (id, stat) in store.pipeline_stats
        total = stat.success_count + stat.failure_count
        push!(summary, Dict(
            "pipeline_id" => id,
            "total_runs" => total,
            "success_rate" => total > 0 ? stat.success_count / total : 0.0,
            "failure_rate" => total > 0 ? stat.failure_count / total : 0.0,
            "escalation_count" => stat.escalation_count,
            "branches" => stat.branches_taken
        ))
    end
    sort!(summary, by=x -> x["failure_rate"], rev=true)
    return summary
end

# ─── Learning Loop: RIL Incidents ──────────────────────────────

"""
    generate_ril_incidents(store::MemoryStore) -> Vector{RILIncident}

Detect patterns in law/pipeline stats and generate RIL repair incidents.
"""
function generate_ril_incidents(store::MemoryStore)
    incidents = RILIncident[]
    ts = string(now())
    incident_counter = 0

    # High override rate → law may need revision
    for (id, stat) in store.law_stats
        if stat.fire_count >= 5 && (stat.override_count / stat.fire_count) > 0.3
            incident_counter += 1
            push!(incidents, RILIncident(
                "RIL-AUTO-$(lpad(incident_counter, 4, '0'))",
                ts,
                "GovernanceMemory/LawStats",
                "HIGH_OVERRIDE_RATE",
                "warning",
                "Rule $id has $(stat.override_count)/$(stat.fire_count) override rate ($(round(100*stat.override_count/stat.fire_count, digits=1))%). Humans frequently disagree.",
                "Review and revise rule $id; consider relaxing conditions or adding exceptions."
            ))
        end
    end

    # High conflict rate → laws may contradict
    for (id, stat) in store.law_stats
        if stat.conflict_count >= 3
            incident_counter += 1
            push!(incidents, RILIncident(
                "RIL-AUTO-$(lpad(incident_counter, 4, '0'))",
                ts,
                "GovernanceMemory/LawStats",
                "LAW_CONFLICT",
                "critical",
                "Rule $id has $(stat.conflict_count) conflicts with other rules.",
                "Resolve contradictions; consider priority ordering or scope narrowing."
            ))
        end
    end

    # Pipeline failure spikes
    for (id, stat) in store.pipeline_stats
        total = stat.success_count + stat.failure_count
        if total >= 5 && (stat.failure_count / total) > 0.4
            incident_counter += 1
            push!(incidents, RILIncident(
                "RIL-AUTO-$(lpad(incident_counter, 4, '0'))",
                ts,
                "GovernanceMemory/PipelineStats",
                "HIGH_FAILURE_RATE",
                "warning",
                "Pipeline $id has $(stat.failure_count)/$(total) failure rate ($(round(100*stat.failure_count/total, digits=1))%).",
                "Investigate failure causes; consider adding retry logic or fallback branches."
            ))
        end
    end

    return incidents
end

# ─── Learning Loop: UEL Evolution Proposals ────────────────────

"""
    generate_uel_proposals(store::MemoryStore) -> Vector{UELProposal}

Generate evolution proposals based on systemic patterns.
"""
function generate_uel_proposals(store::MemoryStore)
    proposals = UELProposal[]
    ts = string(now())
    proposal_counter = 0

    # Systemic override patterns → propose CDL/EDL updates
    high_override_rules = [id for (id, s) in store.law_stats
                           if s.fire_count >= 10 && (s.override_count / s.fire_count) > 0.5]
    if length(high_override_rules) >= 2
        proposal_counter += 1
        push!(proposals, UELProposal(
            "UEL-PROP-$(lpad(proposal_counter, 4, '0'))",
            ts,
            "UEL-DOCTRINE-REVISION",
            "SYSTEMIC_OVERRIDE_PATTERN",
            "Propose CDL doctrine revision: $(length(high_override_rules)) rules have >50% override rate. Doctrine may be misaligned with operational reality.",
            ["Rules: " * join(high_override_rules, ", ")],
            min(0.9, 0.5 + 0.1 * length(high_override_rules))
        ))
    end

    # Persistent pipeline failures → propose new organism
    chronic_failures = [id for (id, s) in store.pipeline_stats
                        if (s.success_count + s.failure_count) >= 10 &&
                           (s.failure_count / (s.success_count + s.failure_count)) > 0.5]
    if length(chronic_failures) >= 1
        proposal_counter += 1
        push!(proposals, UELProposal(
            "UEL-PROP-$(lpad(proposal_counter, 4, '0'))",
            ts,
            "UEL-PIPELINE-REWRITE",
            "CHRONIC_PIPELINE_FAILURE",
            "Propose pipeline redesign for $(length(chronic_failures)) chronically failing pipelines. Consider dedicated specialist organism.",
            ["Pipelines: " * join(chronic_failures, ", ")],
            min(0.95, 0.6 + 0.1 * length(chronic_failures))
        ))
    end

    return proposals
end

# ─── Main Learning Loop ───────────────────────────────────────

"""
    run_learning_loop!(store::MemoryStore) -> (Vector{RILIncident}, Vector{UELProposal})

Run the post-cycle learning loop:
1. Generate RIL incidents from law/pipeline stats
2. Generate UEL evolution proposals from systemic patterns
3. Store results in the memory store
"""
function run_learning_loop!(store::MemoryStore)
    store.cycle_count += 1

    incidents = generate_ril_incidents(store)
    append!(store.incidents, incidents)

    proposals = generate_uel_proposals(store)
    append!(store.proposals, proposals)

    println("  🧠 Learning loop cycle #$(store.cycle_count): $(length(incidents)) incidents, $(length(proposals)) proposals")
    return (incidents, proposals)
end

end # module GovernanceMemory
