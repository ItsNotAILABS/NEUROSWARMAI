# ══════════════════════════════════════════════════════════════════
#  CONDITION DSL — Cognitive Expression Language for Laws & Pipelines
#  Dimension 2: Real cognitive DSL for emergent branching.
#  AST-based condition evaluator over entity/context/history/psyche/relations.
#  Used inside CPL-L conditions and CPL-P pipeline branches.
#  Version: 1.0.0 · φ-Aligned · 873ms PHI_BEAT
# ══════════════════════════════════════════════════════════════════

module ConditionDSL

export ConditionNode, Literal, FieldAccess, BinaryOp, UnaryOp, FunctionCall,
       parse_condition, evaluate_condition, CognitiveContext

# ─── AST Node Types ────────────────────────────────────────────

abstract type ConditionNode end

struct Literal <: ConditionNode
    value::Any
end

struct FieldAccess <: ConditionNode
    namespace::String   # entity, context, history, psyche, relations
    path::Vector{String}
end

struct BinaryOp <: ConditionNode
    op::Symbol          # :==, :!=, :<, :>, :<=, :>=, :&&, :||, :in, :contains
    left::ConditionNode
    right::ConditionNode
end

struct UnaryOp <: ConditionNode
    op::Symbol          # :!, :not
    operand::ConditionNode
end

struct FunctionCall <: ConditionNode
    name::String        # count, any, all, threshold, trust_level
    args::Vector{ConditionNode}
end

# ─── Cognitive Context ─────────────────────────────────────────

"""
    CognitiveContext

The full cognitive state available to condition evaluation.
Includes entity attributes, temporal context, psyche patterns,
relational state, and historical events.
"""
struct CognitiveContext
    entity::Dict{String,Any}      # entity.state.lifecycle, entity.id, etc.
    context::Dict{String,Any}     # current cycle context, mission, etc.
    history::Dict{String,Any}     # til events, past incidents, etc.
    psyche::Dict{String,Any}      # pil patterns, stress indicators
    relations::Dict{String,Any}   # rel trust levels, role bindings
end

function CognitiveContext()
    CognitiveContext(
        Dict{String,Any}(),
        Dict{String,Any}(),
        Dict{String,Any}(),
        Dict{String,Any}(),
        Dict{String,Any}()
    )
end

# ─── Field Resolution ─────────────────────────────────────────

"""
    resolve_field(ctx::CognitiveContext, fa::FieldAccess) -> Any

Navigate into the cognitive context to resolve a dotted field path.
e.g., entity.state.lifecycle → ctx.entity["state"]["lifecycle"]
"""
function resolve_field(ctx::CognitiveContext, fa::FieldAccess)
    # Select namespace
    ns = if fa.namespace == "entity"
        ctx.entity
    elseif fa.namespace == "context"
        ctx.context
    elseif fa.namespace == "history"
        ctx.history
    elseif fa.namespace == "psyche"
        ctx.psyche
    elseif fa.namespace == "relations"
        ctx.relations
    else
        return nothing
    end

    # Walk the path
    current = ns
    for key in fa.path
        if current isa Dict && haskey(current, key)
            current = current[key]
        elseif current isa Dict && haskey(current, Symbol(key))
            current = current[Symbol(key)]
        else
            return nothing
        end
    end
    return current
end

# ─── Function Evaluation ──────────────────────────────────────

function eval_function(name::String, args::Vector{Any}, ctx::CognitiveContext)
    if name == "count"
        val = length(args) > 0 ? args[1] : nothing
        return val isa AbstractVector ? length(val) : 0
    elseif name == "any"
        val = length(args) > 0 ? args[1] : nothing
        return val isa AbstractVector ? !isempty(val) : (val !== nothing && val != false)
    elseif name == "all"
        val = length(args) > 0 ? args[1] : nothing
        return val isa AbstractVector ? all(x -> x == true, val) : false
    elseif name == "threshold"
        val = length(args) > 0 ? args[1] : 0
        thresh = length(args) > 1 ? args[2] : 0
        return val isa Number && thresh isa Number ? val >= thresh : false
    elseif name == "trust_level"
        # relations.trust_level("oracle", "guardian")
        if length(args) >= 2
            from = string(args[1])
            to = string(args[2])
            key = "$(from)->$(to)"
            trust = get(ctx.relations, "trust_levels", Dict())
            return get(trust, key, "unknown")
        end
        return "unknown"
    elseif name == "contains"
        collection = length(args) > 0 ? args[1] : nothing
        item = length(args) > 1 ? args[2] : nothing
        if collection isa AbstractVector
            return item in collection
        elseif collection isa AbstractString && item isa AbstractString
            return occursin(item, collection)
        end
        return false
    else
        return nothing
    end
end

# ─── AST Evaluation ───────────────────────────────────────────

"""
    evaluate_condition(node::ConditionNode, ctx::CognitiveContext) -> Any

Recursively evaluate a condition AST against a cognitive context.
"""
function evaluate_condition(node::Literal, ctx::CognitiveContext)
    return node.value
end

function evaluate_condition(node::FieldAccess, ctx::CognitiveContext)
    return resolve_field(ctx, node)
end

function evaluate_condition(node::UnaryOp, ctx::CognitiveContext)
    val = evaluate_condition(node.operand, ctx)
    if node.op == :! || node.op == :not
        return !val
    end
    return nothing
end

function evaluate_condition(node::BinaryOp, ctx::CognitiveContext)
    left = evaluate_condition(node.left, ctx)
    right = evaluate_condition(node.right, ctx)

    if node.op == :(==)
        return left == right
    elseif node.op == :(!=)
        return left != right
    elseif node.op == :(<)
        return left !== nothing && right !== nothing && left < right
    elseif node.op == :(>)
        return left !== nothing && right !== nothing && left > right
    elseif node.op == :(<=)
        return left !== nothing && right !== nothing && left <= right
    elseif node.op == :(>=)
        return left !== nothing && right !== nothing && left >= right
    elseif node.op == :(&&)
        return (left == true) && (right == true)
    elseif node.op == :(||)
        return (left == true) || (right == true)
    elseif node.op == :in
        return right isa AbstractVector ? left in right : false
    elseif node.op == :contains
        if left isa AbstractVector
            return right in left
        elseif left isa AbstractString && right isa AbstractString
            return occursin(right, left)
        end
        return false
    end
    return nothing
end

function evaluate_condition(node::FunctionCall, ctx::CognitiveContext)
    evaluated_args = [evaluate_condition(arg, ctx) for arg in node.args]
    return eval_function(node.name, evaluated_args, ctx)
end

# ─── DSL Parser (String → AST) ────────────────────────────────

"""
    parse_condition(expr::String) -> ConditionNode

Parse a condition expression string into an AST.
Supports:
  - entity.state.lifecycle == "active"
  - history.events contains "high_risk_incident"
  - psyche.pattern == "rush_to_decision"
  - relations.trust_level("oracle","guardian") == "high"
  - count(history.incidents) > 5
  - entity.risk_score >= 0.7 && context.phase == "production"
"""
function parse_condition(expr::String)
    expr = strip(expr)

    # Handle && (AND)
    and_pos = find_binary_op(expr, "&&")
    if and_pos > 0
        left = parse_condition(expr[1:and_pos-1])
        right = parse_condition(expr[and_pos+2:end])
        return BinaryOp(:&&, left, right)
    end

    # Handle || (OR)
    or_pos = find_binary_op(expr, "||")
    if or_pos > 0
        left = parse_condition(expr[1:or_pos-1])
        right = parse_condition(expr[or_pos+2:end])
        return BinaryOp(:||, left, right)
    end

    # Handle NOT
    if startswith(expr, "!") || startswith(expr, "not ")
        inner = startswith(expr, "not ") ? expr[5:end] : expr[2:end]
        return UnaryOp(:!, parse_condition(inner))
    end

    # Handle comparison operators
    for (op_str, op_sym) in [("==", :(==)), ("!=", :(!=)), (">=", :(>=)),
                              ("<=", :(<=)), (">", :(>)), ("<", :(<)),
                              (" contains ", :contains), (" in ", :in)]
        pos = find_binary_op(expr, op_str)
        if pos > 0
            left = parse_condition(strip(expr[1:pos-1]))
            right = parse_condition(strip(expr[pos+length(op_str):end]))
            return BinaryOp(op_sym, left, right)
        end
    end

    # Handle function calls: name(args...)
    m = match(r"^(\w+)\((.+)\)$", expr)
    if m !== nothing
        fname = m.captures[1]
        args_str = m.captures[2]
        args = [parse_condition(strip(a)) for a in split_args(args_str)]
        return FunctionCall(fname, args)
    end

    # Handle string literals
    if startswith(expr, "\"") && endswith(expr, "\"")
        return Literal(expr[2:end-1])
    end

    # Handle numeric literals
    num = tryparse(Float64, expr)
    if num !== nothing
        int_val = tryparse(Int, expr)
        return Literal(int_val !== nothing ? int_val : num)
    end

    # Handle boolean literals
    if expr == "true"
        return Literal(true)
    elseif expr == "false"
        return Literal(false)
    end

    # Handle dotted field access: namespace.field.subfield
    if occursin('.', expr)
        parts = split(expr, '.')
        ns = string(parts[1])
        path = [string(p) for p in parts[2:end]]
        return FieldAccess(ns, path)
    end

    # Bare identifier
    return Literal(expr)
end

# ─── Helper: find operator position at top level ───────────────

function find_binary_op(expr::String, op::String)
    depth = 0
    i = 1
    while i <= length(expr) - length(op) + 1
        c = expr[i]
        if c == '(' || c == '['
            depth += 1
        elseif c == ')' || c == ']'
            depth -= 1
        elseif depth == 0 && expr[i:min(i+length(op)-1, end)] == op
            # Don't match inside strings
            in_string = count('"', expr[1:i-1]) % 2 != 0
            if !in_string
                return i
            end
        end
        i += 1
    end
    return 0
end

function split_args(s::String)
    args = String[]
    depth = 0
    current = ""
    for c in s
        if c == '(' || c == '['
            depth += 1
            current *= c
        elseif c == ')' || c == ']'
            depth -= 1
            current *= c
        elseif c == ',' && depth == 0
            push!(args, strip(current))
            current = ""
        else
            current *= c
        end
    end
    if !isempty(strip(current))
        push!(args, strip(current))
    end
    return args
end

end # module ConditionDSL
