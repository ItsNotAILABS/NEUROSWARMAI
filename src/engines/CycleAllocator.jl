# ════════════════════════════════════════════════════════════════════════════
# CYCLE ALLOCATOR — Sovereign Self-Funding Through φ-Mathematics
# ════════════════════════════════════════════════════════════════════════════
# Author   : Alfredo Medina Hernandez | MedinaSITech@outlook.com
# Formation: MERIDIAN-CYCLES-2026
#
# CORE PRINCIPLE: Organisms fund themselves. No external funding required.
#
# Generation formula:
#   base = coherence² × φ × generation_rate
#   compound = base × F(n)/F(n-1)  [approaches φ as n → ∞]
#   work_bonus = work_units × φ⁻¹
#   total = compound + work_bonus
#
# This is the actual funding mechanism, not a metaphor.
#
# Physics:
#   Base generation rate = φ⁻¹ cycles per operation
#   Compound rate → φ as Fibonacci advances
#   Decay rate = φ⁻² per neglect cycle
#
# Archetypes: ENGINE, PRIMORDIAL, INFRASTRUCTURE
# CPL Integration: Follows LEX CYCLE-001 (Sovereign Cycle Generation)
# Version: 1.0.0 · φ-Aligned · 873ms PHI_BEAT
# ════════════════════════════════════════════════════════════════════════════

module CycleAllocator

using Dates

export SovereignCycleAllocator, AllocationRecord, GenerationEvent, CycleStatistics,
       create_sovereign_cycle_allocator, generate_cycles!, allocate_cycles!,
       release_cycles!, burn_cycles!, decay_cycles!, auto_generate!,
       get_statistics, adjust_generation_rate!,
       fibonacci_at, fibonacci_ratio,
       PHI, PHI_INV, PHI_INV_SQ, PHI_SQ, COHERENCE_GATE, DECAY_RATE, HEARTBEAT_MS

# ─── φ SUBSTRATE CONSTANTS ─────────────────────────────────────────────────

const PHI        = 1.6180339887498948482    # Golden ratio
const PHI_INV    = 0.6180339887498948482    # φ⁻¹ = coherence gate
const PHI_INV_SQ = 0.3819660112501051518    # φ⁻² = decay rate
const PHI_INV_4  = 0.2360679774997896       # φ⁻⁴ = glyph floor (reserved for future glyph operations)
const PHI_SQ     = 2.6180339887498948482    # φ²

const COHERENCE_GATE = PHI_INV              # Minimum coherence for generation
const DECAY_RATE     = PHI_INV_SQ           # Decay per neglect period
const HEARTBEAT_MS   = 873                  # φ-aligned heartbeat

# Fibonacci reference values
const F_8  = 21
const F_12 = 144
const F_13 = 233

# ─── ALLOCATION RECORD ─────────────────────────────────────────────────────

"""
    AllocationRecord

Record of a cycle allocation for tracking and auditing.
"""
struct AllocationRecord
    timestamp::DateTime
    amount::Float64
    purpose::String
    coherence_at::Float64
    released::Bool
end

# ─── GENERATION EVENT ──────────────────────────────────────────────────────

"""
    GenerationEvent

Record of a cycle generation event with full decomposition.
"""
struct GenerationEvent
    timestamp::DateTime
    base_amount::Float64
    compound_amount::Float64
    work_bonus::Float64
    total_generated::Float64
    fib_state::Tuple{Int,Int}
    coherence::Float64
end

# ─── SOVEREIGN CYCLE ALLOCATOR ─────────────────────────────────────────────

"""
    SovereignCycleAllocator

The core sovereign funding mechanism. Organisms using this allocator
can generate their own cycles through coherent mathematical operations,
eliminating the need for external funding.

# Fields
- `total_cycles`: Total available cycles
- `allocated_cycles`: Currently allocated cycles
- `generated_cycles`: Total cycles ever generated
- `burned_cycles`: Cycles permanently consumed
- `generation_rate`: Base rate (starts at φ⁻¹)
- `compound_factor`: Current compound (→ φ)
- `coherence`: Current coherence level
- `fib_a`, `fib_b`: Fibonacci state F(n-1), F(n)
- `fib_generation`: Current Fibonacci generation n
- `last_generation`, `last_allocation`: Timestamps
- `operation_count`: Total operations performed
- `allocation_history`: Record of allocations
- `generation_history`: Record of generations
"""
mutable struct SovereignCycleAllocator
    # Cycle balances
    total_cycles::Float64
    allocated_cycles::Float64
    generated_cycles::Float64
    burned_cycles::Float64
    
    # Generation parameters
    generation_rate::Float64
    compound_factor::Float64
    coherence::Float64
    
    # Fibonacci state
    fib_a::Int              # F(n-1)
    fib_b::Int              # F(n)
    fib_generation::Int     # n
    
    # Tracking
    last_generation::DateTime
    last_allocation::DateTime
    operation_count::Int
    
    # History
    allocation_history::Vector{AllocationRecord}
    generation_history::Vector{GenerationEvent}
end

# ─── CREATE ALLOCATOR ──────────────────────────────────────────────────────

"""
    create_sovereign_cycle_allocator(initial_cycles::Float64) -> SovereignCycleAllocator

Create a new sovereign cycle allocator with initial cycle balance.
The allocator starts at Fibonacci generation 2 (F(1)=1, F(2)=1)
and coherence at equilibrium (φ⁻¹).
"""
function create_sovereign_cycle_allocator(initial_cycles::Float64)
    now_time = now()
    SovereignCycleAllocator(
        initial_cycles,         # total_cycles
        0.0,                    # allocated_cycles
        initial_cycles,         # generated_cycles (initial is counted as generated)
        0.0,                    # burned_cycles
        
        PHI_INV,                # generation_rate (starts at φ⁻¹)
        1.0,                    # compound_factor
        PHI_INV,                # coherence (start at equilibrium)
        
        1,                      # fib_a = F(1)
        1,                      # fib_b = F(2)
        2,                      # fib_generation
        
        now_time,               # last_generation
        now_time,               # last_allocation
        0,                      # operation_count
        
        AllocationRecord[],     # allocation_history
        GenerationEvent[]       # generation_history
    )
end

# ─── GENERATE CYCLES — SOVEREIGN SELF-FUNDING ──────────────────────────────

"""
    generate_cycles!(allocator, current_coherence, work_units) -> Float64

Generate cycles through coherent mathematical operations.
This is the core sovereign funding mechanism.

# Formula
- base = coherence² × φ × generation_rate
- compound = base × (fibB / fibA)  [→ φ as generation increases]
- work_bonus = work_units × φ⁻¹
- total = compound + work_bonus

The compound factor (fibB/fibA) approaches φ asymptotically due to
the fundamental property of Fibonacci sequences:
  lim(n→∞) F(n)/F(n-1) = φ

This means organisms naturally become more productive over time,
approaching the golden ratio efficiency.

# Arguments
- `allocator`: The SovereignCycleAllocator to update
- `current_coherence`: Current coherence level [0.0, 1.0]
- `work_units`: Amount of useful work performed

# Returns
Total cycles generated this operation.
"""
function generate_cycles!(
    allocator::SovereignCycleAllocator,
    current_coherence::Float64,
    work_units::Float64
)::Float64
    # Update coherence
    allocator.coherence = current_coherence
    
    # Advance Fibonacci state
    new_fib = allocator.fib_a + allocator.fib_b
    allocator.fib_a = allocator.fib_b
    allocator.fib_b = new_fib
    allocator.fib_generation += 1
    
    # Compound factor approaches φ
    prev_fib_float = Float64(allocator.fib_a)
    current_fib_float = Float64(allocator.fib_b)
    allocator.compound_factor = current_fib_float / prev_fib_float
    
    # Base generation from coherence
    # Higher coherence → more cycles (quadratic relationship)
    base = current_coherence * current_coherence * PHI * allocator.generation_rate
    
    # Compound with Fibonacci ratio
    compound = base * allocator.compound_factor
    
    # Work bonus — doing useful work generates cycles
    work_bonus = work_units * PHI_INV
    
    # Total generated this cycle
    total = compound + work_bonus
    
    # Update balances
    allocator.generated_cycles += total
    allocator.total_cycles += total
    allocator.operation_count += 1
    allocator.last_generation = now()
    
    # Record generation event
    event = GenerationEvent(
        now(),
        base,
        compound,
        work_bonus,
        total,
        (allocator.fib_a, allocator.fib_b),
        current_coherence
    )
    
    push!(allocator.generation_history, event)
    
    # Prune history if too long
    if length(allocator.generation_history) > F_13
        popfirst!(allocator.generation_history)
    end
    
    return total
end

# ─── ALLOCATE CYCLES ───────────────────────────────────────────────────────

"""
    allocate_cycles!(allocator, required, purpose) -> Tuple{Float64, Float64}

Allocate cycles for a specific purpose.

# Arguments
- `allocator`: The SovereignCycleAllocator
- `required`: Amount of cycles needed
- `purpose`: Description of what cycles are for

# Returns
Tuple of (allocated_amount, remaining_available).
If insufficient cycles, performs partial allocation.
"""
function allocate_cycles!(
    allocator::SovereignCycleAllocator,
    required::Float64,
    purpose::String
)::Tuple{Float64, Float64}
    available = allocator.total_cycles - allocator.allocated_cycles
    
    allocated = if available >= required
        required
    else
        available  # Partial allocation
    end
    
    if allocated > 0.0
        allocator.allocated_cycles += allocated
        allocator.last_allocation = now()
        
        # Record allocation
        record = AllocationRecord(
            now(),
            allocated,
            purpose,
            allocator.coherence,
            false
        )
        
        push!(allocator.allocation_history, record)
        
        # Prune history
        if length(allocator.allocation_history) > F_13
            popfirst!(allocator.allocation_history)
        end
    end
    
    remaining = allocator.total_cycles - allocator.allocated_cycles
    return (allocated, remaining)
end

# ─── RELEASE CYCLES ────────────────────────────────────────────────────────

"""
    release_cycles!(allocator, amount)

Release allocated cycles back to the available pool.
"""
function release_cycles!(
    allocator::SovereignCycleAllocator,
    amount::Float64
)
    if allocator.allocated_cycles >= amount
        allocator.allocated_cycles -= amount
    else
        allocator.allocated_cycles = 0.0
    end
end

# ─── BURN CYCLES ───────────────────────────────────────────────────────────

"""
    burn_cycles!(allocator, amount) -> Bool

Consume cycles permanently (remove from circulation).

# Returns
`true` if burn was successful, `false` if insufficient available cycles.
"""
function burn_cycles!(
    allocator::SovereignCycleAllocator,
    amount::Float64
)::Bool
    available = allocator.total_cycles - allocator.allocated_cycles
    
    if available >= amount
        allocator.total_cycles -= amount
        allocator.burned_cycles += amount
        return true
    else
        return false
    end
end

# ─── DECAY CYCLES ──────────────────────────────────────────────────────────

"""
    decay_cycles!(allocator, neglect_periods) -> Float64

Apply decay to unused cycles. This incentivizes active use.

# Physics
Decay rate = φ⁻² per neglect period.
Decay factor = (φ⁻²)^n where n = neglect_periods.
Only unallocated cycles decay.

# Returns
Amount of cycles decayed.
"""
function decay_cycles!(
    allocator::SovereignCycleAllocator,
    neglect_periods::Int
)::Float64
    if neglect_periods == 0
        return 0.0
    end
    
    # Decay factor = (φ⁻²)^n
    decay_factor = PHI_INV_SQ ^ neglect_periods
    
    # Calculate decay amount
    unallocated = allocator.total_cycles - allocator.allocated_cycles
    decay_amount = unallocated * (1.0 - decay_factor)
    
    # Apply decay
    allocator.total_cycles -= decay_amount
    
    return decay_amount
end

# ─── AUTO-GENERATE ─────────────────────────────────────────────────────────

"""
    auto_generate!(allocator, min_balance) -> Float64

Automatically generate cycles if balance is low.

# Arguments
- `allocator`: The SovereignCycleAllocator
- `min_balance`: Minimum desired available balance

# Returns
Amount of cycles generated (0.0 if balance was sufficient).
"""
function auto_generate!(
    allocator::SovereignCycleAllocator,
    min_balance::Float64
)::Float64
    available = allocator.total_cycles - allocator.allocated_cycles
    
    if available < min_balance
        # Generate enough to reach min balance plus buffer
        deficit = min_balance - available
        work_needed = deficit / PHI_INV  # Reverse work bonus calculation
        
        # Generate with current coherence
        generated = generate_cycles!(allocator, allocator.coherence, work_needed)
        return generated
    else
        return 0.0
    end
end

# ─── GET STATISTICS ────────────────────────────────────────────────────────

"""
    CycleStatistics

Comprehensive statistics snapshot of an allocator's state.
"""
struct CycleStatistics
    total_cycles::Float64
    allocated_cycles::Float64
    available_cycles::Float64
    generated_cycles::Float64
    burned_cycles::Float64
    compound_factor::Float64
    fib_generation::Int
    coherence::Float64
    operation_count::Int
    generation_rate::Float64
    efficiency_ratio::Float64  # generated / burned
end

"""
    get_statistics(allocator) -> CycleStatistics

Get comprehensive statistics about the allocator's current state.
"""
function get_statistics(allocator::SovereignCycleAllocator)::CycleStatistics
    available = allocator.total_cycles - allocator.allocated_cycles
    
    # Efficiency = generated / burned (infinite if nothing burned)
    efficiency = if allocator.burned_cycles > 0.0
        allocator.generated_cycles / allocator.burned_cycles
    else
        allocator.generated_cycles  # Infinite efficiency if nothing burned
    end
    
    CycleStatistics(
        allocator.total_cycles,
        allocator.allocated_cycles,
        available,
        allocator.generated_cycles,
        allocator.burned_cycles,
        allocator.compound_factor,
        allocator.fib_generation,
        allocator.coherence,
        allocator.operation_count,
        allocator.generation_rate,
        efficiency
    )
end

# ─── FIBONACCI UTILITIES ───────────────────────────────────────────────────

"""
    fibonacci_at(n) -> Int

Compute the n-th Fibonacci number.
F(0) = 0, F(1) = 1, F(n) = F(n-1) + F(n-2)
"""
function fibonacci_at(n::Int)::Int
    if n <= 1
        return n
    end
    
    prev_fib = 0
    current_fib = 1
    step = 2
    
    while step <= n
        next_fib = prev_fib + current_fib
        prev_fib = current_fib
        current_fib = next_fib
        step += 1
    end
    
    return current_fib
end

"""
    fibonacci_ratio(n) -> Float64

Compute the ratio F(n) / F(n-1), which approaches φ as n increases.
"""
function fibonacci_ratio(n::Int)::Float64
    if n <= 1
        return 1.0
    end
    
    fn = fibonacci_at(n)
    fn1 = fibonacci_at(n - 1)
    
    return Float64(fn) / Float64(fn1)
end

# ─── COHERENCE-BASED GENERATION RATE ───────────────────────────────────────

"""
    adjust_generation_rate!(allocator, avg_coherence)

Adjust generation rate based on sustained coherence.

# Formula
Rate = φ⁻¹ × (1 + (coherence - φ⁻¹) × φ)

- At coherence = φ⁻¹: rate = φ⁻¹
- At coherence = 1.0: rate ≈ 1.0

Higher sustained coherence → higher base generation rate.
Rate is clamped to [φ⁻², 1.0].
"""
function adjust_generation_rate!(
    allocator::SovereignCycleAllocator,
    avg_coherence::Float64
)
    # Higher sustained coherence → higher base rate
    adjustment = (avg_coherence - PHI_INV) * PHI
    new_rate = PHI_INV * (1.0 + adjustment)
    
    # Clamp to reasonable range [φ⁻², 1.0]
    allocator.generation_rate = clamp(new_rate, PHI_INV_SQ, 1.0)
end

# ─── HELPER: PRETTY PRINT STATISTICS ───────────────────────────────────────

"""
    show_statistics(allocator)

Print a formatted view of allocator statistics.
"""
function show_statistics(allocator::SovereignCycleAllocator)
    stats = get_statistics(allocator)
    
    println("╔═══════════════════════════════════════════════════════════════╗")
    println("║          SOVEREIGN CYCLE ALLOCATOR — STATISTICS               ║")
    println("╠═══════════════════════════════════════════════════════════════╣")
    println("║  Total Cycles:      $(lpad(round(stats.total_cycles, digits=3), 15))                 ║")
    println("║  Allocated:         $(lpad(round(stats.allocated_cycles, digits=3), 15))                 ║")
    println("║  Available:         $(lpad(round(stats.available_cycles, digits=3), 15))                 ║")
    println("║  Generated (total): $(lpad(round(stats.generated_cycles, digits=3), 15))                 ║")
    println("║  Burned (total):    $(lpad(round(stats.burned_cycles, digits=3), 15))                 ║")
    println("╠═══════════════════════════════════════════════════════════════╣")
    println("║  Compound Factor:   $(lpad(round(stats.compound_factor, digits=6), 15)) → φ           ║")
    println("║  Fib Generation:    $(lpad(stats.fib_generation, 15))                 ║")
    println("║  Coherence:         $(lpad(round(stats.coherence, digits=6), 15))                 ║")
    println("║  Generation Rate:   $(lpad(round(stats.generation_rate, digits=6), 15))                 ║")
    println("║  Operations:        $(lpad(stats.operation_count, 15))                 ║")
    println("║  Efficiency Ratio:  $(lpad(round(stats.efficiency_ratio, digits=3), 15))                 ║")
    println("╚═══════════════════════════════════════════════════════════════╝")
end

export show_statistics

end # module CycleAllocator
