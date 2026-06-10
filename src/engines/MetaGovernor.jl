# ══════════════════════════════════════════════════════════════════
#  META-GOVERNOR — The Cortex Over the Cortex
#  Dimension 4: Reads all stats, proposes language changes, pipeline
#  rewrites, new organisms, and phase transitions.
#  Uses LML (language evolution) and UEL (universe evolution) as its spine.
#  Version: 1.0.0 · φ-Aligned · 873ms PHI_BEAT
# ══════════════════════════════════════════════════════════════════

module MetaGovernor

using Dates

export MetaState, MetaProposal, MetaReport,
       create_meta_state, ingest_cycle_data!,
       analyze_and_propose!, generate_meta_report

# ─── Constants ─────────────────────────────────────────────────

const PHI = 1.618033988749895
const PROPOSAL_CONFIDENCE_THRESHOLD = 0.6

# ─── Types ─────────────────────────────────────────────────────

struct MetaProposal
    id::String
    timestamp::String
    category::String        # language_change, pipeline_rewrite, new_organism, phase_transition
    target::String          # what is being changed
    description::String
    evidence::Vector{String}
    confidence::Float64
    priority::String        # critical, high, medium, low
end

struct CycleDigest
    cycle_id::String
    timestamp::String
    entities_checked::Int
    violations::Int
    overrides::Int
    pipeline_failures::Int
    ril_incidents::Int
    uel_proposals::Int
    organism_health_avg::Float64
    education_outcomes::Dict{String,Any}
end

mutable struct MetaState
    cycle_digests::Vector{CycleDigest}
    proposals::Vector{MetaProposal}
    language_versions::Dict{String,String}
    phase::String
    phase_history::Vector{Dict{String,String}}
    proposal_counter::Int
end

struct MetaReport
    timestamp::String
    phase::String
    cycles_analyzed::Int
    proposals::Vector{MetaProposal}
    health_summary::Dict{String,Any}
    trend_analysis::Dict{String,Any}
end

# ─── Constructor ───────────────────────────────────────────────

function create_meta_state()
    MetaState(
        CycleDigest[],
        MetaProposal[],
        Dict{String,String}(),
        "genesis",
        Dict{String,String}[],
        0
    )
end

# ─── Ingest Cycle Data ─────────────────────────────────────────

"""
    ingest_cycle_data!(state::MetaState, data::Dict{String,Any})

Ingest a governance cycle's results into the meta-governor's memory.
"""
function ingest_cycle_data!(state::MetaState, data::Dict{String,Any})
    digest = CycleDigest(
        get(data, "cycle_id", string(now())),
        string(now()),
        get(data, "entities_checked", 0),
        get(data, "violations", 0),
        get(data, "overrides", 0),
        get(data, "pipeline_failures", 0),
        get(data, "ril_incidents", 0),
        get(data, "uel_proposals", 0),
        get(data, "organism_health_avg", 1.0),
        get(data, "education_outcomes", Dict{String,Any}())
    )
    push!(state.cycle_digests, digest)
end

# ─── Analysis & Proposal Generation ───────────────────────────

"""
    analyze_and_propose!(state::MetaState) -> Vector{MetaProposal}

Analyze accumulated cycle data and generate meta-level proposals.
This is the "cortex over the cortex" — it rewrites the brain itself.
"""
function analyze_and_propose!(state::MetaState)
    new_proposals = MetaProposal[]
    ts = string(now())
    n = length(state.cycle_digests)
    n < 2 && return new_proposals  # Need at least 2 cycles for trend analysis

    recent = state.cycle_digests[max(1, n-4):n]  # last 5 cycles

    # ── Detect rising violation trend ──────────────────────────
    violation_trend = [d.violations for d in recent]
    if length(violation_trend) >= 3 && is_rising_trend(violation_trend)
        state.proposal_counter += 1
        push!(new_proposals, MetaProposal(
            "META-$(lpad(state.proposal_counter, 4, '0'))",
            ts,
            "language_change",
            "CPL-L",
            "Rising violation trend detected across $(length(recent)) cycles. Propose CPL-L v1.1 with explicit uncertainty thresholds and graduated enforcement.",
            ["Violations: $(join(violation_trend, " → "))"],
            0.75,
            "high"
        ))
    end

    # ── Detect chronic override pattern ────────────────────────
    override_trend = [d.overrides for d in recent]
    if sum(override_trend) > 10
        state.proposal_counter += 1
        push!(new_proposals, MetaProposal(
            "META-$(lpad(state.proposal_counter, 4, '0'))",
            ts,
            "language_change",
            "CDL",
            "High cumulative override rate ($(sum(override_trend)) overrides in $(length(recent)) cycles). Propose CDL doctrine revision to align rules with operational reality.",
            ["Overrides per cycle: $(join(override_trend, ", "))"],
            0.8,
            "high"
        ))
    end

    # ── Detect pipeline failure pattern ────────────────────────
    pipeline_failure_trend = [d.pipeline_failures for d in recent]
    if sum(pipeline_failure_trend) > 5
        state.proposal_counter += 1
        push!(new_proposals, MetaProposal(
            "META-$(lpad(state.proposal_counter, 4, '0'))",
            ts,
            "pipeline_rewrite",
            "governance_pipeline",
            "Persistent pipeline failures ($(sum(pipeline_failure_trend)) in $(length(recent)) cycles). Propose pipeline redesign with retry logic and fallback branches.",
            ["Failures per cycle: $(join(pipeline_failure_trend, ", "))"],
            0.7,
            "medium"
        ))
    end

    # ── Detect organism health degradation ─────────────────────
    health_trend = [d.organism_health_avg for d in recent]
    if length(health_trend) >= 3 && is_falling_trend(health_trend) && minimum(health_trend) < 0.5
        state.proposal_counter += 1
        push!(new_proposals, MetaProposal(
            "META-$(lpad(state.proposal_counter, 4, '0'))",
            ts,
            "new_organism",
            "risk_synthesizer",
            "Organism health is degrading ($(join([round(h, digits=2) for h in health_trend], " → "))). Propose dedicated Risk Synthesizer agent to offload risk analysis from stressed organisms.",
            ["Health trend: $(join([round(h, digits=2) for h in health_trend], " → "))"],
            0.65,
            "medium"
        ))
    end

    # ── Detect phase transition readiness ──────────────────────
    if n >= 10  # Need enough history
        avg_violations = sum(d.violations for d in recent) / length(recent)
        avg_health = sum(d.organism_health_avg for d in recent) / length(recent)

        if avg_violations < 2 && avg_health > 0.8 && state.phase != "production"
            state.proposal_counter += 1
            push!(new_proposals, MetaProposal(
                "META-$(lpad(state.proposal_counter, 4, '0'))",
                ts,
                "phase_transition",
                state.phase * " → production",
                "System stability metrics indicate readiness for phase transition. Avg violations: $(round(avg_violations, digits=1)), avg health: $(round(avg_health, digits=2)).",
                ["$(n) cycles analyzed", "avg_violations=$(round(avg_violations, digits=1))", "avg_health=$(round(avg_health, digits=2))"],
                0.85,
                "critical"
            ))
        end
    end

    # ── RIL/UEL feedback → propose education updates ───────────
    ril_trend = [d.ril_incidents for d in recent]
    if sum(ril_trend) > 8
        state.proposal_counter += 1
        push!(new_proposals, MetaProposal(
            "META-$(lpad(state.proposal_counter, 4, '0'))",
            ts,
            "language_change",
            "EDL",
            "High RIL incident rate ($(sum(ril_trend)) in $(length(recent)) cycles) suggests systemic confusion. Propose EDL curriculum update targeting identified failure patterns.",
            ["RIL incidents per cycle: $(join(ril_trend, ", "))"],
            0.7,
            "medium"
        ))
    end

    # Store proposals
    append!(state.proposals, new_proposals)

    if !isempty(new_proposals)
        println("  🏛️  Meta-governor: $(length(new_proposals)) proposals generated")
    end

    return new_proposals
end

# ─── Meta Report ───────────────────────────────────────────────

"""
    generate_meta_report(state::MetaState) -> MetaReport

Generate a comprehensive meta-governance report.
"""
function generate_meta_report(state::MetaState)
    n = length(state.cycle_digests)
    recent = n > 0 ? state.cycle_digests[max(1, n-4):n] : CycleDigest[]

    health_summary = Dict{String,Any}(
        "total_cycles" => n,
        "current_phase" => state.phase,
        "active_proposals" => length(state.proposals),
        "avg_violations" => n > 0 ? round(sum(d.violations for d in recent) / max(1, length(recent)), digits=1) : 0,
        "avg_organism_health" => n > 0 ? round(sum(d.organism_health_avg for d in recent) / max(1, length(recent)), digits=3) : 1.0
    )

    trend_analysis = Dict{String,Any}(
        "violation_trend" => n > 0 ? [d.violations for d in recent] : Int[],
        "override_trend" => n > 0 ? [d.overrides for d in recent] : Int[],
        "health_trend" => n > 0 ? [round(d.organism_health_avg, digits=3) for d in recent] : Float64[]
    )

    MetaReport(
        string(now()),
        state.phase,
        n,
        state.proposals,
        health_summary,
        trend_analysis
    )
end

# ─── Trend Detection Helpers ──────────────────────────────────

function is_rising_trend(values::Vector)
    length(values) < 3 && return false
    increases = sum(values[i] > values[i-1] for i in 2:length(values))
    return increases >= length(values) - 1  # Allow at most 1 dip
end

function is_falling_trend(values::Vector)
    length(values) < 3 && return false
    decreases = sum(values[i] < values[i-1] for i in 2:length(values))
    return decreases >= length(values) - 1
end

end # module MetaGovernor
