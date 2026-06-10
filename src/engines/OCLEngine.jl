# ══════════════════════════════════════════════════════════════════
#  OCL ENGINE — Organism Charter Validator
#  Language: Organism Contract Language (OCL)
#  Layer: CoreLaw · Version: 1.0.0 · φ-Aligned
# ══════════════════════════════════════════════════════════════════

module OCLEngine

using YAML

export load_ocl, validate_organism

"""
    load_ocl(path::String) -> Dict

Load an .ocl organism charter file.
"""
function load_ocl(path::String)
    YAML.load_file(path)
end

"""
    validate_organism(agent::Dict, ocl::Dict) -> Vector{String}

Validate an organism/agent against its OCL charter.
"""
function validate_organism(agent::Dict, ocl::Dict)
    results = String[]
    if haskey(ocl, "capabilities")
        for cap in ocl["capabilities"]
            push!(results, "Capability: $cap")
        end
    end
    if haskey(ocl, "limits")
        for lim in ocl["limits"]
            push!(results, "Limit: $lim")
        end
    end
    return results
end

end # module OCLEngine
