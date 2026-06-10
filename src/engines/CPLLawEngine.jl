# ══════════════════════════════════════════════════════════════════
#  CPL-L LAW ENGINE — Constitutional Law Evaluator
#  Language: Cognitive Law Language (CPL-L)
#  Layer: CoreLaw · Version: 1.0.0 · φ-Aligned
# ══════════════════════════════════════════════════════════════════

module CPLLawEngine

using YAML

export apply_laws, load_law_file

"""
    load_law_file(path::String) -> Dict

Load a .cpl-l law file and return its parsed structure.
"""
function load_law_file(path::String)
    return YAML.load_file(path)
end

"""
    apply_laws(entity::Dict, laws::Vector{Dict}) -> Vector{String}

Evaluate all laws against an entity and return a list of violations or actions.
"""
function apply_laws(entity::Dict, laws::Vector{Dict})
    results = String[]
    for law in laws
        if haskey(law, "subjects")
            for subject in law["subjects"]
                if haskey(subject, "id") && subject["id"] == get(entity, "id", "")
                    if haskey(subject, "rules")
                        for rule in subject["rules"]
                            push!(results, "Applied rule $(get(rule, "name", "unknown")) to $(entity["id"])")
                        end
                    end
                end
            end
        end
    end
    return results
end

end # module CPLLawEngine
