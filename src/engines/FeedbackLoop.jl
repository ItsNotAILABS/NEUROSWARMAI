# ══════════════════════════════════════════════════════════════════
#  FEEDBACK LOOP — Metrics Collection & Human Review Hooks
#  Dimension 5: Ground truth and external correction.
#  MML metrics: governance latency, incident rate, override rate,
#  education outcomes, user satisfaction.
#  Human feedback: review requests, decision storage, training signals.
#  Version: 1.0.0 · φ-Aligned · 873ms PHI_BEAT
# ══════════════════════════════════════════════════════════════════

module FeedbackLoop

using Dates

export MetricsCollector, HumanReviewRequest, HumanDecision, FeedbackStore,
       create_feedback_store, record_metric!, request_human_review!,
       record_human_decision!, get_metrics_summary, get_training_signals,
       compute_system_health

# ─── Constants ─────────────────────────────────────────────────

const PHI = 1.618033988749895

# ─── Types ─────────────────────────────────────────────────────

struct MetricEntry
    id::String
    name::String
    value::Float64
    unit::String
    timestamp::String
    source::String
end

struct HumanReviewRequest
    id::String
    timestamp::String
    category::String        # law_application, pipeline_escalation, organism_refusal
    context::Dict{String,Any}
    urgency::String         # critical, high, medium, low
    status::String          # pending, reviewed, expired
end

struct HumanDecision
    review_id::String
    timestamp::String
    decision::String        # approve, reject, modify, defer
    reasoning::String
    modifications::Dict{String,Any}
    reviewer::String
end

struct TrainingSignal
    timestamp::String
    category::String
    original_action::String
    human_decision::String
    agreement::Bool         # did the system agree with the human?
    lesson::String
end

mutable struct FeedbackStore
    metrics::Vector{MetricEntry}
    review_requests::Vector{HumanReviewRequest}
    human_decisions::Vector{HumanDecision}
    training_signals::Vector{TrainingSignal}
    metric_counter::Int
    review_counter::Int
end

# ─── Constructor ───────────────────────────────────────────────

function create_feedback_store()
    FeedbackStore(
        MetricEntry[],
        HumanReviewRequest[],
        HumanDecision[],
        TrainingSignal[],
        0, 0
    )
end

# ─── Metrics Collection ───────────────────────────────────────

"""
    record_metric!(store, name, value, unit, source)

Record a system metric observation.
"""
function record_metric!(store::FeedbackStore, name::String, value::Float64,
                         unit::String, source::String)
    store.metric_counter += 1
    push!(store.metrics, MetricEntry(
        "MML-$(lpad(store.metric_counter, 6, '0'))",
        name, value, unit, string(now()), source
    ))
end

"""
    record_governance_cycle_metrics!(store, cycle_data)

Record standard governance cycle metrics.
"""
function record_governance_cycle_metrics!(store::FeedbackStore, cycle_data::Dict{String,Any})
    ts = string(now())

    # Governance latency
    if haskey(cycle_data, "latency_ms")
        record_metric!(store, "governance_latency", Float64(cycle_data["latency_ms"]),
                        "ms", "governance_cycle")
    end

    # Incident rate
    if haskey(cycle_data, "incidents")
        record_metric!(store, "incident_rate", Float64(cycle_data["incidents"]),
                        "count", "governance_cycle")
    end

    # Override rate
    if haskey(cycle_data, "overrides") && haskey(cycle_data, "total_rules_applied")
        total = cycle_data["total_rules_applied"]
        if total > 0
            rate = Float64(cycle_data["overrides"]) / Float64(total)
            record_metric!(store, "override_rate", rate, "ratio", "governance_cycle")
        end
    end

    # Violation count
    if haskey(cycle_data, "violations")
        record_metric!(store, "violation_count", Float64(cycle_data["violations"]),
                        "count", "governance_cycle")
    end

    # Organism health
    if haskey(cycle_data, "organism_health_avg")
        record_metric!(store, "organism_health", cycle_data["organism_health_avg"],
                        "score", "organism_runtime")
    end
end

# ─── Human Review Hooks ───────────────────────────────────────

"""
    request_human_review!(store, category, context, urgency) -> String

Request a human review for a governance decision.
Returns the review request ID.
"""
function request_human_review!(store::FeedbackStore, category::String,
                                context::Dict{String,Any}, urgency::String)
    store.review_counter += 1
    id = "REVIEW-$(lpad(store.review_counter, 6, '0'))"

    push!(store.review_requests, HumanReviewRequest(
        id, string(now()), category, context, urgency, "pending"
    ))

    println("  👤 Human review requested: $id ($category, urgency=$urgency)")
    return id
end

"""
    record_human_decision!(store, review_id, decision, reasoning, modifications, reviewer)

Record a human's decision on a review request and generate a training signal.
"""
function record_human_decision!(store::FeedbackStore, review_id::String,
                                 decision::String, reasoning::String,
                                 modifications::Dict{String,Any}=Dict{String,Any}(),
                                 reviewer::String="human")
    push!(store.human_decisions, HumanDecision(
        review_id, string(now()), decision, reasoning, modifications, reviewer
    ))

    # Find the original review request
    review = nothing
    for r in store.review_requests
        if r.id == review_id
            review = r
            break
        end
    end

    # Generate training signal
    if review !== nothing
        agreement = decision == "approve"
        lesson = if decision == "reject"
            "System action was rejected: $reasoning"
        elseif decision == "modify"
            "System action was modified: $reasoning"
        elseif decision == "approve"
            "System action confirmed by human"
        else
            "Decision deferred: $reasoning"
        end

        push!(store.training_signals, TrainingSignal(
            string(now()),
            review.category,
            get(review.context, "proposed_action", "unknown"),
            decision,
            agreement,
            lesson
        ))
    end
end

# ─── Metrics Summary ──────────────────────────────────────────

"""
    get_metrics_summary(store; window_minutes=60) -> Dict{String,Any}

Get a summary of metrics within a time window.
"""
function get_metrics_summary(store::FeedbackStore; window_minutes::Int=60)
    # Group recent metrics by name
    metric_groups = Dict{String,Vector{Float64}}()
    for m in store.metrics
        if !haskey(metric_groups, m.name)
            metric_groups[m.name] = Float64[]
        end
        push!(metric_groups[m.name], m.value)
    end

    summary = Dict{String,Any}()
    for (name, values) in metric_groups
        n = length(values)
        summary[name] = Dict(
            "count" => n,
            "mean" => n > 0 ? round(sum(values) / n, digits=3) : 0.0,
            "min" => n > 0 ? round(minimum(values), digits=3) : 0.0,
            "max" => n > 0 ? round(maximum(values), digits=3) : 0.0,
            "latest" => n > 0 ? round(values[end], digits=3) : 0.0
        )
    end

    summary["_meta"] = Dict(
        "total_metrics" => length(store.metrics),
        "pending_reviews" => count(r -> r.status == "pending", store.review_requests),
        "total_training_signals" => length(store.training_signals),
        "human_agreement_rate" => compute_agreement_rate(store)
    )

    return summary
end

# ─── Training Signals ─────────────────────────────────────────

"""
    get_training_signals(store; category=nothing) -> Vector{TrainingSignal}

Get training signals, optionally filtered by category.
These feed back into law/pipeline evolution.
"""
function get_training_signals(store::FeedbackStore; category::Union{String,Nothing}=nothing)
    if category === nothing
        return store.training_signals
    end
    return filter(s -> s.category == category, store.training_signals)
end

# ─── System Health Composite ──────────────────────────────────

"""
    compute_system_health(store) -> Dict{String,Any}

Compute overall system health from all available metrics.
"""
function compute_system_health(store::FeedbackStore)
    # Get latest values for key metrics
    latest = Dict{String,Float64}()
    for m in store.metrics
        latest[m.name] = m.value  # Overwrites with most recent
    end

    # Compute composite health score (φ-weighted)
    components = Dict{String,Float64}()
    components["governance_health"] = 1.0 - get(latest, "override_rate", 0.0)
    components["organism_health"] = get(latest, "organism_health", 1.0)
    components["incident_health"] = max(0.0, 1.0 - get(latest, "incident_rate", 0.0) / 10.0)
    components["human_agreement"] = compute_agreement_rate(store)

    # φ-weighted composite
    weights = Dict(
        "governance_health" => PHI,
        "organism_health" => 1.0,
        "incident_health" => 1.0,
        "human_agreement" => PHI
    )

    total_weight = sum(values(weights))
    composite = sum(components[k] * weights[k] for k in keys(components)) / total_weight

    return Dict{String,Any}(
        "composite_score" => round(composite, digits=3),
        "components" => Dict(k => round(v, digits=3) for (k, v) in components),
        "status" => composite > 0.8 ? "healthy" :
                    composite > 0.6 ? "degraded" :
                    composite > 0.4 ? "stressed" : "critical"
    )
end

# ─── Helpers ───────────────────────────────────────────────────

function compute_agreement_rate(store::FeedbackStore)
    total = length(store.training_signals)
    total == 0 && return 1.0
    agreed = count(s -> s.agreement, store.training_signals)
    return round(agreed / total, digits=3)
end

end # module FeedbackLoop
