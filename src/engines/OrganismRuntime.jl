# ══════════════════════════════════════════════════════════════════
#  ORGANISM RUNTIME — Agents with Drives, Policies, and Self-Check
#  Dimension 3: Each organism is a mini-brain inside the larger brain.
#  Drives: stability, exploration, safety, learning_rate
#  Policies: trade-off rules between drives
#  Self-check: periodic CIL/PIL/RIL scanning
#  Version: 1.0.0 · φ-Aligned · 873ms PHI_BEAT
# ══════════════════════════════════════════════════════════════════

module OrganismRuntime

using Dates

export OrganismDrives, OrganismPolicy, OrganismState, OrganismAgent,
       create_organism, tick!, self_check!, should_escalate,
       adjust_drives!, get_health_report

# ─── Constants ─────────────────────────────────────────────────

const PHI = 1.618033988749895
const STRESS_THRESHOLD = 0.7
const SAFETY_FLOOR = 0.3

# ─── Types ─────────────────────────────────────────────────────

"""
    OrganismDrives

The motivational drives of an organism agent.
Each drive is a float in [0.0, 1.0].
"""
mutable struct OrganismDrives
    stability::Float64      # preference for predictable outcomes
    exploration::Float64    # willingness to try new approaches
    safety::Float64         # caution level, never sacrificed below floor
    learning_rate::Float64  # speed of adaptation from experience
end

"""
    OrganismPolicy

Trade-off rules that govern how the organism makes decisions
when drives conflict.
"""
struct OrganismPolicy
    name::String
    safety_floor::Float64                    # never let safety drop below this
    max_exploration_under_stress::Float64     # cap exploration when stressed
    stability_recovery_rate::Float64          # how fast stability recovers
    escalation_threshold::Float64             # when to escalate to supervisor
end

"""
    OrganismState

Internal cognitive state of the organism.
"""
mutable struct OrganismState
    stress_level::Float64           # current stress [0.0, 1.0]
    uncertainty::Float64            # current uncertainty [0.0, 1.0]
    task_success_streak::Int        # consecutive successes
    task_failure_streak::Int        # consecutive failures
    cil_tags::Vector{String}        # current CIL cognitive tags
    pil_patterns::Vector{String}    # detected PIL patterns
    ril_pending::Vector{String}     # pending RIL repair actions
    last_self_check::String         # timestamp of last self-check
    ticks::Int                      # total ticks processed
end

"""
    OrganismAgent

A fully realized organism agent with drives, policies, and state.
"""
mutable struct OrganismAgent
    id::String
    name::String
    archetype::String
    drives::OrganismDrives
    policy::OrganismPolicy
    state::OrganismState
    capabilities::Vector{String}
    limits::Vector{String}
end

# ─── Constructors ──────────────────────────────────────────────

function OrganismDrives()
    OrganismDrives(0.7, 0.5, 0.8, 0.3)
end

function OrganismPolicy(name::String="default")
    OrganismPolicy(name, SAFETY_FLOOR, 0.3, 0.1, 0.8)
end

function OrganismState()
    OrganismState(0.0, 0.0, 0, 0, String[], String[], String[], string(now()), 0)
end

"""
    create_organism(id, name, archetype; capabilities, limits) -> OrganismAgent

Create a new organism agent with default drives and policy.
"""
function create_organism(id::String, name::String, archetype::String;
                          capabilities::Vector{String}=String[],
                          limits::Vector{String}=String[])
    OrganismAgent(
        id, name, archetype,
        OrganismDrives(),
        OrganismPolicy(),
        OrganismState(),
        capabilities, limits
    )
end

# ─── Core Tick Loop ────────────────────────────────────────────

"""
    tick!(agent::OrganismAgent, task_result::Symbol) -> Dict{String,Any}

Process one tick of the organism's lifecycle.
task_result: :success, :failure, :skip, :escalate
Returns a status dict with any actions needed.
"""
function tick!(agent::OrganismAgent, task_result::Symbol)
    agent.state.ticks += 1
    actions = Dict{String,Any}("tick" => agent.state.ticks, "actions" => String[])

    # Update success/failure streaks
    if task_result == :success
        agent.state.task_success_streak += 1
        agent.state.task_failure_streak = 0
        # Reduce stress on success
        agent.state.stress_level = max(0.0, agent.state.stress_level - agent.policy.stability_recovery_rate)
        # Slight increase in exploration confidence
        agent.drives.exploration = min(1.0, agent.drives.exploration + 0.01 * agent.drives.learning_rate)
    elseif task_result == :failure
        agent.state.task_failure_streak += 1
        agent.state.task_success_streak = 0
        # Increase stress on failure
        agent.state.stress_level = min(1.0, agent.state.stress_level + 0.15)
        # Reduce exploration on failure
        agent.drives.exploration = max(0.1, agent.drives.exploration - 0.05 * agent.drives.learning_rate)
        # Increase safety
        agent.drives.safety = min(1.0, agent.drives.safety + 0.02)
    end

    # Apply policy constraints
    apply_policy!(agent)

    # Check if self-check is needed (every φ² ≈ 2.618 ticks, rounded to 3)
    if agent.state.ticks % 3 == 0
        self_check_results = self_check!(agent)
        actions["self_check"] = self_check_results
    end

    # Check escalation
    if should_escalate(agent)
        push!(actions["actions"], "ESCALATE")
        actions["escalation_reason"] = get_escalation_reason(agent)
    end

    return actions
end

# ─── Policy Application ───────────────────────────────────────

function apply_policy!(agent::OrganismAgent)
    # Enforce safety floor
    if agent.drives.safety < agent.policy.safety_floor
        agent.drives.safety = agent.policy.safety_floor
    end

    # Cap exploration under stress
    if agent.state.stress_level > STRESS_THRESHOLD
        agent.drives.exploration = min(agent.drives.exploration,
                                        agent.policy.max_exploration_under_stress)
    end

    # Stability recovery when not stressed
    if agent.state.stress_level < 0.3
        agent.drives.stability = min(1.0,
            agent.drives.stability + agent.policy.stability_recovery_rate * 0.1)
    end
end

# ─── Self-Check Loop ──────────────────────────────────────────

"""
    self_check!(agent::OrganismAgent) -> Dict{String,Any}

Periodic self-check:
1. Scan CIL for stress patterns (high uncertainty, repeated tags)
2. Scan PIL for triggered patterns
3. Emit RIL if thresholds are crossed
"""
function self_check!(agent::OrganismAgent)
    agent.state.last_self_check = string(now())
    results = Dict{String,Any}("issues" => String[], "repairs" => String[])

    # CIL stress scan: check for high uncertainty
    if agent.state.uncertainty > 0.7
        push!(results["issues"], "HIGH_UNCERTAINTY: $(round(agent.state.uncertainty, digits=2))")
        push!(agent.state.cil_tags, "uncertain")
    end

    # CIL stress scan: check for repeated failure
    if agent.state.task_failure_streak >= 3
        push!(results["issues"], "FAILURE_STREAK: $(agent.state.task_failure_streak) consecutive failures")
        push!(agent.state.cil_tags, "struggling")
    end

    # PIL pattern detection: rush to decision under stress
    if agent.state.stress_level > 0.6 && agent.drives.exploration < 0.2
        push!(agent.state.pil_patterns, "rush_to_decision")
        push!(results["issues"], "PIL_PATTERN: rush_to_decision detected")
    end

    # PIL pattern detection: avoidance
    if agent.state.task_failure_streak >= 2 && agent.drives.safety > 0.9
        push!(agent.state.pil_patterns, "avoidance")
        push!(results["issues"], "PIL_PATTERN: avoidance behavior detected")
    end

    # Emit RIL if thresholds crossed
    if agent.state.stress_level > STRESS_THRESHOLD
        repair = "STRESS_RELIEF: Reduce task load, increase stability drive"
        push!(agent.state.ril_pending, repair)
        push!(results["repairs"], repair)
    end

    if length(results["issues"]) > 0
        println("  🔍 Self-check [$(agent.id)]: $(length(results["issues"])) issues found")
    end

    return results
end

# ─── Escalation Logic ─────────────────────────────────────────

"""
    should_escalate(agent::OrganismAgent) -> Bool

Determine if the organism should escalate to its supervisor.
"""
function should_escalate(agent::OrganismAgent)
    # Escalate on high stress
    if agent.state.stress_level >= agent.policy.escalation_threshold
        return true
    end
    # Escalate on long failure streak
    if agent.state.task_failure_streak >= 5
        return true
    end
    # Escalate if multiple PIL patterns detected
    if length(agent.state.pil_patterns) >= 3
        return true
    end
    return false
end

function get_escalation_reason(agent::OrganismAgent)
    reasons = String[]
    if agent.state.stress_level >= agent.policy.escalation_threshold
        push!(reasons, "stress=$(round(agent.state.stress_level, digits=2))")
    end
    if agent.state.task_failure_streak >= 5
        push!(reasons, "failure_streak=$(agent.state.task_failure_streak)")
    end
    if length(agent.state.pil_patterns) >= 3
        push!(reasons, "pil_patterns=$(join(agent.state.pil_patterns, ","))")
    end
    return join(reasons, "; ")
end

# ─── Drive Adjustment ─────────────────────────────────────────

"""
    adjust_drives!(agent::OrganismAgent, adjustments::Dict{String,Float64})

Externally adjust an organism's drives (e.g., from meta-governor).
"""
function adjust_drives!(agent::OrganismAgent, adjustments::Dict{String,Float64})
    if haskey(adjustments, "stability")
        agent.drives.stability = clamp(adjustments["stability"], 0.0, 1.0)
    end
    if haskey(adjustments, "exploration")
        agent.drives.exploration = clamp(adjustments["exploration"], 0.0, 1.0)
    end
    if haskey(adjustments, "safety")
        agent.drives.safety = clamp(max(adjustments["safety"], agent.policy.safety_floor), 0.0, 1.0)
    end
    if haskey(adjustments, "learning_rate")
        agent.drives.learning_rate = clamp(adjustments["learning_rate"], 0.0, 1.0)
    end
end

# ─── Health Report ─────────────────────────────────────────────

"""
    get_health_report(agent::OrganismAgent) -> Dict{String,Any}

Get a comprehensive health report for the organism.
"""
function get_health_report(agent::OrganismAgent)
    Dict{String,Any}(
        "id" => agent.id,
        "name" => agent.name,
        "archetype" => agent.archetype,
        "drives" => Dict(
            "stability" => round(agent.drives.stability, digits=3),
            "exploration" => round(agent.drives.exploration, digits=3),
            "safety" => round(agent.drives.safety, digits=3),
            "learning_rate" => round(agent.drives.learning_rate, digits=3)
        ),
        "state" => Dict(
            "stress_level" => round(agent.state.stress_level, digits=3),
            "uncertainty" => round(agent.state.uncertainty, digits=3),
            "success_streak" => agent.state.task_success_streak,
            "failure_streak" => agent.state.task_failure_streak,
            "ticks" => agent.state.ticks,
            "cil_tags" => agent.state.cil_tags,
            "pil_patterns" => agent.state.pil_patterns,
            "ril_pending" => length(agent.state.ril_pending)
        ),
        "health" => compute_health_score(agent)
    )
end

function compute_health_score(agent::OrganismAgent)
    # Health is a φ-weighted composite
    stress_component = 1.0 - agent.state.stress_level
    stability_component = agent.drives.stability
    safety_component = agent.drives.safety
    failure_component = 1.0 - min(1.0, agent.state.task_failure_streak / 5.0)

    score = (stress_component * PHI + stability_component + safety_component + failure_component) / (PHI + 3.0)
    return round(score, digits=3)
end

end # module OrganismRuntime
