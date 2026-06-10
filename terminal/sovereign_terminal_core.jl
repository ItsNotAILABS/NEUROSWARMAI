# ═══════════════════════════════════════════════════════════════════════════════
# SOVEREIGN TERMINAL CORE — Julia Implementation
# ═══════════════════════════════════════════════════════════════════════════════
# COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
#
# Julia computational core for Freddy Sovereign Terminal
# Scans all agents, missions, realms, and components
# Maintains version registry and enforces CPL governance
# ═══════════════════════════════════════════════════════════════════════════════

using JSON3
using YAML
using Dates

# ═══════════════════════════════════════════════════════════════════════════════
# VERSION INFORMATION
# ═══════════════════════════════════════════════════════════════════════════════

const VERSION = "1.0.0"
const COMPONENT_ID = "SOVEREIGN_TERMINAL_CORE"
const COMPONENT_TYPE = "GOVERNANCE_ENGINE"

# ═══════════════════════════════════════════════════════════════════════════════
# MATHEMATICAL CONSTANTS
# ═══════════════════════════════════════════════════════════════════════════════

const PHI = 1.618033988749895
const S_ZERO = 0.0036313133
const PI = π
const E = ℯ
const PHI_BEAT = 873  # milliseconds
const F11 = 89

# ═══════════════════════════════════════════════════════════════════════════════
# COMPONENT SCANNER
# ═══════════════════════════════════════════════════════════════════════════════

"""
Scans directory for components with .meta.json sidecars
Returns array of component metadata
"""
function scan_components(root_path::String)
    components = []

    for (root, dirs, files) in walkdir(root_path)
        for file in files
            if endswith(file, ".meta.json")
                meta_path = joinpath(root, file)
                try
                    meta = JSON3.read(read(meta_path, String))
                    push!(components, meta)
                    println("[Scan] Found component: ", meta.component_id, " v", meta.version)
                catch e
                    @warn "Failed to parse meta file: $meta_path" exception=e
                end
            end
        end
    end

    return components
end

"""
Scans for Motoko (.mo) files and extracts version info
"""
function scan_motoko_modules(root_path::String)
    modules = []

    for (root, dirs, files) in walkdir(root_path)
        for file in files
            if endswith(file, ".mo")
                mo_path = joinpath(root, file)
                try
                    content = read(mo_path, String)

                    # Extract version information from module
                    version_match = match(r"VERSION\s*:\s*Text\s*=\s*\"([^\"]+)\"", content)
                    component_match = match(r"COMPONENT_ID\s*:\s*Text\s*=\s*\"([^\"]+)\"", content)
                    type_match = match(r"COMPONENT_TYPE\s*:\s*Text\s*=\s*\"([^\"]+)\"", content)

                    if !isnothing(version_match) && !isnothing(component_match)
                        module_info = Dict(
                            "component" => component_match.captures[1],
                            "version" => version_match.captures[1],
                            "type" => !isnothing(type_match) ? type_match.captures[1] : "MOTOKO_MODULE",
                            "location" => mo_path,
                            "language" => "Motoko"
                        )
                        push!(modules, module_info)
                        println("[Scan] Found Motoko module: ", module_info["component"], " v", module_info["version"])
                    end
                catch e
                    @warn "Failed to parse Motoko file: $mo_path" exception=e
                end
            end
        end
    end

    return modules
end

"""
Scans for JavaScript (.js) files with VERSION constants
"""
function scan_javascript_modules(root_path::String)
    modules = []

    for (root, dirs, files) in walkdir(root_path)
        for file in files
            if endswith(file, ".js") && !contains(file, "node_modules")
                js_path = joinpath(root, file)
                try
                    content = read(js_path, String)

                    # Extract version information
                    version_match = match(r"const\s+VERSION\s*=\s*['\"]([^'\"]+)['\"]", content)
                    component_match = match(r"const\s+COMPONENT_ID\s*=\s*['\"]([^'\"]+)['\"]", content)
                    type_match = match(r"const\s+COMPONENT_TYPE\s*=\s*['\"]([^'\"]+)['\"]", content)

                    if !isnothing(version_match) && !isnothing(component_match)
                        module_info = Dict(
                            "component" => component_match.captures[1],
                            "version" => version_match.captures[1],
                            "type" => !isnothing(type_match) ? type_match.captures[1] : "JAVASCRIPT_MODULE",
                            "location" => js_path,
                            "language" => "JavaScript"
                        )
                        push!(modules, module_info)
                        println("[Scan] Found JavaScript module: ", module_info["component"], " v", module_info["version"])
                    end
                catch e
                    @warn "Failed to parse JavaScript file: $js_path" exception=e
                end
            end
        end
    end

    return modules
end

# ═══════════════════════════════════════════════════════════════════════════════
# REGISTRY MANAGEMENT
# ═══════════════════════════════════════════════════════════════════════════════

"""
Loads the global registry from JSONL file
"""
function load_registry(registry_path::String)
    registry = []

    if isfile(registry_path)
        for line in eachline(registry_path)
            if !isempty(strip(line))
                try
                    entry = JSON3.read(line)
                    push!(registry, entry)
                catch e
                    @warn "Failed to parse registry line" exception=e
                end
            end
        end
    end

    return registry
end

"""
Appends entry to registry (append-only)
"""
function append_to_registry(registry_path::String, entry::Dict)
    open(registry_path, "a") do io
        println(io, JSON3.write(entry))
    end
    println("[Registry] Appended: ", entry["component"], " v", entry["version"])
end

"""
Updates registry with new component versions
"""
function update_registry(registry_path::String, components::Vector)
    # Load existing registry
    registry = load_registry(registry_path)
    registry_dict = Dict(entry.component => entry for entry in registry)

    # Check for updates
    for comp in components
        comp_id = comp["component"]
        comp_version = comp["version"]

        if haskey(registry_dict, comp_id)
            existing_version = registry_dict[comp_id].version
            if comp_version != existing_version
                println("[Registry] Version change detected: $comp_id $existing_version → $comp_version")

                # Append new version to registry
                append_to_registry(registry_path, comp)
            end
        else
            println("[Registry] New component detected: $comp_id v$comp_version")
            append_to_registry(registry_path, comp)
        end
    end
end

# ═══════════════════════════════════════════════════════════════════════════════
# CPL GOVERNANCE
# ═══════════════════════════════════════════════════════════════════════════════

"""
Loads CPL-L specification
"""
function load_cpl_l(spec_path::String)
    if isfile(spec_path)
        return YAML.load_file(spec_path)
    else
        @warn "CPL-L spec not found: $spec_path"
        return nothing
    end
end

"""
Loads CPL-C specification
"""
function load_cpl_c(spec_path::String)
    if isfile(spec_path)
        return YAML.load_file(spec_path)
    else
        @warn "CPL-C spec not found: $spec_path"
        return nothing
    end
end

"""
Loads CPL-P specification
"""
function load_cpl_p(spec_path::String)
    if isfile(spec_path)
        return YAML.load_file(spec_path)
    else
        @warn "CPL-P spec not found: $spec_path"
        return nothing
    end
end

"""
Validates component against CPL-L immutable rules
"""
function validate_against_cpl_l(component::Dict, cpl_l_spec)
    if isnothing(cpl_l_spec)
        return true
    end

    # Check version format
    version = component["version"]
    if !occursin(r"^\d+\.\d+\.\d+$", version)
        @warn "Invalid version format: $version (expected semver)"
        return false
    end

    # Additional CPL-L validation would go here

    return true
end

"""
Performs constitutional check as per CPL-L IR-001 through IR-005
"""
function constitutional_check(components::Vector, cpl_l_spec)
    println("\n[Constitutional Check] Starting governance cycle...")

    violations = []

    for comp in components
        # IR-001: Identity Preservation
        if !haskey(comp, "component") || isempty(comp["component"])
            push!(violations, Dict("component" => comp, "rule" => "IR-001", "reason" => "Missing component identity"))
        end

        # IR-002: Version Compliance
        if !validate_against_cpl_l(comp, cpl_l_spec)
            push!(violations, Dict("component" => comp, "rule" => "IR-002", "reason" => "Version validation failed"))
        end
    end

    if isempty(violations)
        println("[Constitutional Check] ✓ All components compliant")
    else
        println("[Constitutional Check] ⚠ Found ", length(violations), " violations:")
        for v in violations
            println("  - ", v["component"]["component"], ": ", v["rule"], " - ", v["reason"])
        end
    end

    return violations
end

# ═══════════════════════════════════════════════════════════════════════════════
# SOVEREIGN TERMINAL CORE
# ═══════════════════════════════════════════════════════════════════════════════

"""
Main sovereign terminal core function
"""
function sovereign_terminal_core(config_path::String)
    println("═══════════════════════════════════════════════════════════")
    println("FREDDY SOVEREIGN TERMINAL v$VERSION")
    println("Governance Engine — Julia Core")
    println("═══════════════════════════════════════════════════════════\n")

    # Load configuration
    config = YAML.load_file(config_path)
    root_path = config["scan"]["root_path"]
    registry_path = config["registry"]["path"]

    # Load CPL specifications
    cpl_l = load_cpl_l(config["cpl"]["cpl_l_path"])
    cpl_c = load_cpl_c(config["cpl"]["cpl_c_path"])
    cpl_p = load_cpl_p(config["cpl"]["cpl_p_path"])

    # Scan for components
    println("[Scan] Scanning for components in: $root_path\n")

    motoko_modules = scan_motoko_modules(joinpath(root_path, "src/backend/genesis"))
    js_modules = scan_javascript_modules(joinpath(root_path, "organism"))

    all_components = vcat(motoko_modules, js_modules)

    println("\n[Scan] Found ", length(all_components), " components total")

    # Update registry
    println("\n[Registry] Updating global registry...")
    update_registry(registry_path, all_components)

    # Constitutional check
    violations = constitutional_check(all_components, cpl_l)

    # Generate stats
    println("\n[Stats] Component Statistics:")
    println("  Total components: ", length(all_components))
    println("  Motoko modules: ", length(motoko_modules))
    println("  JavaScript modules: ", length(js_modules))
    println("  CPL violations: ", length(violations))

    # Return summary
    return Dict(
        "total_components" => length(all_components),
        "motoko_modules" => length(motoko_modules),
        "js_modules" => length(js_modules),
        "violations" => length(violations),
        "timestamp" => Dates.now()
    )
end

# ═══════════════════════════════════════════════════════════════════════════════
# MAIN ENTRY POINT
# ═══════════════════════════════════════════════════════════════════════════════

if abspath(PROGRAM_FILE) == @__FILE__
    config_path = joinpath(@__DIR__, "config.yaml")
    result = sovereign_terminal_core(config_path)

    println("\n[Complete] Sovereign terminal cycle finished")
    println("Timestamp: ", result["timestamp"])
end
