# ══════════════════════════════════════════════════════════════════
#  CPL-C CONTRACT ENGINE — Civilization Contract Evaluator
#  Language: Cognitive Contract Language (CPL-C)
#  Layer: CoreLaw · Version: 1.0.0 · φ-Aligned
# ══════════════════════════════════════════════════════════════════

module CPLContractEngine

using YAML

export load_contract, evaluate_contracts

"""
    load_contract(path::String) -> Dict

Load a .cpl-c contract file.
"""
function load_contract(path::String)
    YAML.load_file(path)
end

"""
    evaluate_contracts(entity::Dict, contracts::Vector{Dict}) -> Vector{String}

Evaluate contracts against an entity. Returns list of applicable contracts.
"""
function evaluate_contracts(entity::Dict, contracts::Vector{Dict})
    results = String[]
    for c in contracts
        if haskey(c, "parties")
            for (role, party) in c["parties"]
                if party == get(entity, "id", "")
                    push!(results, "Contract $(get(c, "id", "unknown")) applies to $(entity["id"]) as $(role)")
                end
            end
        end
    end
    return results
end

end # module CPLContractEngine
