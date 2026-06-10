// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  INTELLECTUAL PROPERTY NOTICE                                                                             ║
// ║  ─────────────────────────────────────────────────────────────────────────────────────────────────────── ║
// ║  Owner:        Alfredo Medina Hernandez                                                                   ║
// ║  Location:     Dallas, Texas, United States of America                                                    ║
// ║  Contact:      MedinaSITech@outlook.com                                                                   ║
// ║  Framework:    Medina Doctrine                                                                            ║
// ║                                                                                                           ║
// ║  LEGAL PROTECTION                                                                                         ║
// ║  ─────────────────────────────────────────────────────────────────────────────────────────────────────── ║
// ║  This source code, including all algorithms, mathematical formulations, architectural designs,            ║
// ║  naming conventions, data structures, and conceptual frameworks contained herein, constitutes             ║
// ║  the exclusive intellectual property of Alfredo Medina Hernandez.                                        ║
// ║                                                                                                           ║
// ║  PROTECTED UNDER:                                                                                         ║
// ║  • United States Copyright Law (17 U.S.C. §§ 101-1332)                                                   ║
// ║  • Berne Convention for the Protection of Literary and Artistic Works                                     ║
// ║  • WIPO Copyright Treaty (WCT)                                                                            ║
// ║  • Trade Secret Law - Defend Trade Secrets Act (18 U.S.C. § 1836)                                        ║
// ║  • Economic Espionage Act (18 U.S.C. §§ 1831-1839)                                                       ║
// ║                                                                                                           ║
// ║  CONFIDENTIALITY: This code is CONFIDENTIAL and PROPRIETARY.                                             ║
// ║  ENCRYPTION: All transmissions must be encrypted.                                                         ║
// ║  ATTRIBUTION: Required for any use, reproduction, or derivative work.                                     ║
// ║                                                                                                           ║
// ║  Unauthorized access, use, reproduction, distribution, or creation of derivative works                    ║
// ║  is strictly prohibited and will be prosecuted to the fullest extent of applicable law.                  ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// MAXWELL-BOLTZMANN THERMAL SUBSTRATE — THERMODYNAMIC GROUNDING FOR THE ORGANISM
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// This module provides thermodynamic grounding for the organism through Maxwell-Boltzmann statistics.
// It implements temperature-dependent noise injection, thermal equilibrium detection, and annealing
// for exploration/exploitation balance.
//
// MATHEMATICAL FOUNDATIONS:
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// Maxwell-Boltzmann Speed Distribution:
//   f(v) = 4π × (m/2πkT)^(3/2) × v² × exp(-mv²/2kT)
//
// Thermal Energy per Degree of Freedom (Equipartition):
//   ⟨E⟩ = ½kT per quadratic term
//   Total: ⟨E⟩ = (3/2)kT for 3D motion
//
// Thermal Noise (Fluctuation-Dissipation Theorem):
//   η(t) ~ N(0, √(2γkT))
//   where γ is the friction coefficient
//
// Boltzmann Distribution:
//   P(E) ∝ exp(-E/kT)
//   Partition function: Z = Σᵢ exp(-Eᵢ/kT)
//
// Effective Temperature (from activity):
//   T_eff = ⟨E²⟩ - ⟨E⟩² / (k × specific_heat)
//
// THERMODYNAMIC QUANTITIES:
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// • Temperature T: Controls exploration (high T) vs exploitation (low T)
// • Entropy S = -k Σᵢ pᵢ ln(pᵢ): Measures disorder/uncertainty
// • Free Energy F = E - TS: What the system minimizes at equilibrium
// • Heat Capacity C = ∂E/∂T: How much energy to change temperature
//
// INTEGRATION WITH ORGANISM:
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// • Thermal noise injection for stochastic exploration
// • Temperature tied to arousal/coherence state
// • Annealing schedules for optimization
// • Equilibrium detection for stable decision-making
// • Heat flow between shells (thermal coupling)
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:core/Float";
import Int "mo:core/Int";
import Nat "mo:core/Nat";
import Nat8 "mo:core/Nat8";
import Nat16 "mo:core/Nat16";
import Nat32 "mo:core/Nat32";
import Nat64 "mo:core/Nat64";
import Array "mo:core/Array";
import Buffer "mo:core/Buffer";
import Iter "mo:core/Iter";
import Text "mo:core/Text";
import Time "mo:core/Time";
import Option "mo:core/Option";
import Bool "mo:core/Bool";

module MaxwellBoltzmannThermalSubstrate {

  // ═══════════════════════════════════════════════════════════════════════════════
  // PHYSICAL CONSTANTS (NORMALIZED FOR ORGANISM SCALE)
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Boltzmann constant (normalized to 1.0 in organism units)
  public let K_BOLTZMANN : Float = 1.0;
  
  /// Pi
  public let PI : Float = 3.14159265358979323846;
  public let TWO_PI : Float = 6.28318530717958647692;
  
  /// Euler's number
  public let E : Float = 2.71828182845904523536;
  
  /// Square root of 2π
  public let SQRT_2_PI : Float = 2.50662827463100050242;
  
  /// Square root of 2
  public let SQRT_2 : Float = 1.41421356237309504880;
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // THERMAL CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Base temperature for organism (arbitrary units)
  public let BASE_TEMPERATURE : Float = 1.0;
  
  /// Minimum temperature (prevents complete freezing)
  public let MIN_TEMPERATURE : Float = 0.01;
  
  /// Maximum temperature (prevents thermal runaway)
  public let MAX_TEMPERATURE : Float = 100.0;
  
  /// Default friction coefficient for Langevin dynamics
  public let DEFAULT_FRICTION : Float = 1.0;
  
  /// Thermal conductivity between shells
  public let THERMAL_CONDUCTIVITY : Float = 0.1;
  
  /// Time constant for temperature equilibration
  public let THERMAL_TAU : Float = 100.0;
  
  /// S₀ floor integration
  /// S₀ SOVEREIGNTY FLOOR — MAXED FOR ENTERPRISE-GRADE FINAL PRODUCT
  /// Full sovereignty protection at all times. The formulas matter, not arbitrary numbers.
  public let S_ZERO_FLOOR : Float = 1.0;
  
  /// Number of thermal degrees of freedom per node
  public let DEGREES_OF_FREEDOM : Nat = 3;
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // THERMAL PARTICLE TYPE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// A thermal particle with position and velocity
  public type ThermalParticle = {
    id : Nat;
    var position : [var Float];    // Position in N-dimensional space
    var velocity : [var Float];    // Velocity components
    var energy : Float;            // Kinetic energy
    mass : Float;                  // Particle mass
    var temperature : Float;       // Local temperature
    shellId : Nat8;                // Which shell
  };
  
  /// Velocity statistics
  public type VelocityStats = {
    var meanSpeed : Float;         // ⟨v⟩ = √(8kT/πm)
    var rmsSpeed : Float;          // √⟨v²⟩ = √(3kT/m)
    var mostProbableSpeed : Float; // v_p = √(2kT/m)
    var speedVariance : Float;
    var speedDistribution : [Float]; // Histogram
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // THERMAL BATH TYPE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// A thermal reservoir (heat bath)
  public type ThermalBath = {
    var temperature : Float;
    var heatCapacity : Float;      // C = dE/dT
    var entropy : Float;           // S = k ln(W)
    var freeEnergy : Float;        // F = E - TS
    var totalEnergy : Float;
    particles : [var ThermalParticle];
    var isEquilibrated : Bool;
    var lastEquilibrationCheck : Int;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // MAXWELL-BOLTZMANN DISTRIBUTION TYPE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Maxwell-Boltzmann distribution parameters
  public type MBDistribution = {
    temperature : Float;
    mass : Float;
    var normalization : Float;     // Z = (2πmkT)^(3/2)
    var meanEnergy : Float;        // ⟨E⟩ = (3/2)kT
    var energyVariance : Float;    // Var(E) = (3/2)(kT)²
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // LANGEVIN DYNAMICS TYPE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Langevin equation parameters
  /// m(dv/dt) = -γv + F + η(t)
  public type LangevinParams = {
    friction : Float;              // γ: friction coefficient
    temperature : Float;           // T: bath temperature
    mass : Float;                  // m: particle mass
    noiseStrength : Float;         // √(2γkT)
    timestep : Float;              // dt for integration
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // THERMAL NOISE GENERATOR
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Thermal noise state
  public type NoiseGenerator = {
    var seed : Nat;
    var temperature : Float;
    var friction : Float;
    var lastValue : Float;
    var variance : Float;
  };
  
  /// Initialize noise generator
  public func initNoiseGenerator(seed : Nat, temp : Float, friction : Float) : NoiseGenerator {
    {
      var seed = seed;
      var temperature = temp;
      var friction = friction;
      var lastValue = 0.0;
      var variance = 2.0 * friction * K_BOLTZMANN * temp;
    }
  };
  
  /// Generate Gaussian random number using Box-Muller transform
  /// Returns two independent standard normal samples
  public func boxMuller(seed : Nat) : (Float, Float, Nat) {
    let seed1 = (seed * 1103515245 + 12345) % 2147483647;
    let seed2 = (seed1 * 1103515245 + 12345) % 2147483647;
    
    // Uniform [0, 1]
    let u1 = Float.fromInt(seed1 % 1000000 + 1) / 1000001.0;
    let u2 = Float.fromInt(seed2 % 1000000 + 1) / 1000001.0;
    
    // Box-Muller transform
    let r = Float.sqrt(-2.0 * Float.log(u1));
    let theta = TWO_PI * u2;
    
    let z1 = r * Float.cos(theta);
    let z2 = r * Float.sin(theta);
    
    (z1, z2, seed2)
  };
  
  /// Generate thermal noise sample: η ~ N(0, √(2γkT))
  public func generateThermalNoise(gen : NoiseGenerator) : Float {
    let (z1, _, newSeed) = boxMuller(gen.seed);
    gen.seed := newSeed;
    
    let sigma = Float.sqrt(gen.variance);
    let noise = sigma * z1;
    gen.lastValue := noise;
    noise
  };
  
  /// Generate array of thermal noise samples
  public func generateThermalNoiseArray(gen : NoiseGenerator, n : Nat) : [Float] {
    Array.tabulate<Float>(n, func(_ : Nat) : Float {
      generateThermalNoise(gen)
    })
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // MAXWELL-BOLTZMANN SPEED DISTRIBUTION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Compute Maxwell-Boltzmann speed distribution f(v)
  /// f(v) = 4π × (m/2πkT)^(3/2) × v² × exp(-mv²/2kT)
  public func mbSpeedDistribution(v : Float, mass : Float, temp : Float) : Float {
    if (temp <= 0.0 or mass <= 0.0 or v < 0.0) { return 0.0 };
    
    let a = mass / (TWO_PI * K_BOLTZMANN * temp);
    let coefficient = 4.0 * PI * Float.pow(a, 1.5);
    let exponential = Float.exp(-mass * v * v / (2.0 * K_BOLTZMANN * temp));
    
    coefficient * v * v * exponential
  };
  
  /// Compute most probable speed: v_p = √(2kT/m)
  public func mostProbableSpeed(mass : Float, temp : Float) : Float {
    if (mass <= 0.0) { return 0.0 };
    Float.sqrt(2.0 * K_BOLTZMANN * temp / mass)
  };
  
  /// Compute mean speed: ⟨v⟩ = √(8kT/πm)
  public func meanSpeed(mass : Float, temp : Float) : Float {
    if (mass <= 0.0) { return 0.0 };
    Float.sqrt(8.0 * K_BOLTZMANN * temp / (PI * mass))
  };
  
  /// Compute RMS speed: v_rms = √(3kT/m)
  public func rmsSpeed(mass : Float, temp : Float) : Float {
    if (mass <= 0.0) { return 0.0 };
    Float.sqrt(3.0 * K_BOLTZMANN * temp / mass)
  };
  
  /// Sample a speed from Maxwell-Boltzmann distribution
  /// Uses inverse transform sampling (approximation)
  public func sampleMBSpeed(mass : Float, temp : Float, seed : Nat) : (Float, Nat) {
    // Generate three independent Gaussian velocities
    let (vx, vy, seed1) = boxMuller(seed);
    let (vz, _, seed2) = boxMuller(seed1);
    
    // Scale by √(kT/m)
    let scale = Float.sqrt(K_BOLTZMANN * temp / mass);
    let speed = scale * Float.sqrt(vx * vx + vy * vy + vz * vz);
    
    (speed, seed2)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // BOLTZMANN ENERGY DISTRIBUTION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Boltzmann factor: exp(-E/kT)
  public func boltzmannFactor(energy : Float, temp : Float) : Float {
    if (temp <= MIN_TEMPERATURE) { return 0.0 };
    Float.exp(-energy / (K_BOLTZMANN * temp))
  };
  
  /// Boltzmann probability: P(E) = exp(-E/kT) / Z
  public func boltzmannProbability(
    energy : Float,
    temp : Float,
    partitionFunction : Float
  ) : Float {
    if (partitionFunction <= 0.0) { return 0.0 };
    boltzmannFactor(energy, temp) / partitionFunction
  };
  
  /// Compute partition function: Z = Σᵢ exp(-Eᵢ/kT)
  public func computePartitionFunction(energies : [Float], temp : Float) : Float {
    var z : Float = 0.0;
    for (e in energies.vals()) {
      z += boltzmannFactor(e, temp);
    };
    z
  };
  
  /// Sample energy from Boltzmann distribution
  public func sampleBoltzmannEnergy(
    energies : [Float],
    temp : Float,
    seed : Nat
  ) : (?Float, Nat) {
    let z = computePartitionFunction(energies, temp);
    if (z <= 0.0) { return (null, seed) };
    
    // Random threshold
    let (u, _, newSeed) = boxMuller(seed);
    let threshold = (Float.abs(u) / 3.0) * z;  // Approximate uniform [0, Z]
    
    // Cumulative selection
    var cumSum : Float = 0.0;
    for (e in energies.vals()) {
      cumSum += boltzmannFactor(e, temp);
      if (cumSum >= threshold) {
        return (?e, newSeed);
      };
    };
    
    (?energies[energies.size() - 1], newSeed)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // THERMODYNAMIC QUANTITIES
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Compute mean energy: ⟨E⟩ = (d/2)kT for d degrees of freedom
  public func computeMeanEnergy(temp : Float, degreesOfFreedom : Nat) : Float {
    Float.fromInt(degreesOfFreedom) / 2.0 * K_BOLTZMANN * temp
  };
  
  /// Compute entropy from probabilities: S = -k Σᵢ pᵢ ln(pᵢ)
  public func computeEntropy(probabilities : [Float]) : Float {
    var entropy : Float = 0.0;
    for (p in probabilities.vals()) {
      if (p > 1e-10) {
        entropy -= K_BOLTZMANN * p * Float.log(p);
      };
    };
    entropy
  };
  
  /// Compute Gibbs entropy: S = k ln(W) where W is number of microstates
  public func computeGibbsEntropy(numMicrostates : Nat) : Float {
    if (numMicrostates < 1) { return 0.0 };
    K_BOLTZMANN * Float.log(Float.fromInt(numMicrostates))
  };
  
  /// Compute free energy: F = E - TS = -kT ln(Z)
  public func computeFreeEnergy(
    energy : Float,
    temp : Float,
    entropy : Float
  ) : Float {
    energy - temp * entropy
  };
  
  /// Compute heat capacity: C = dE/dT = (d/2)k for d DOF
  public func computeHeatCapacity(degreesOfFreedom : Nat) : Float {
    Float.fromInt(degreesOfFreedom) / 2.0 * K_BOLTZMANN
  };
  
  /// Compute effective temperature from energy fluctuations
  /// T_eff = Var(E) / (kC) where C is heat capacity
  public func computeEffectiveTemperature(
    energyVariance : Float,
    heatCapacity : Float
  ) : Float {
    if (heatCapacity <= 0.0) { return BASE_TEMPERATURE };
    energyVariance / (K_BOLTZMANN * heatCapacity)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // LANGEVIN DYNAMICS — THERMAL FLUCTUATIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Initialize Langevin parameters
  public func initLangevinParams(
    friction : Float,
    temp : Float,
    mass : Float,
    dt : Float
  ) : LangevinParams {
    {
      friction = friction;
      temperature = temp;
      mass = mass;
      noiseStrength = Float.sqrt(2.0 * friction * K_BOLTZMANN * temp);
      timestep = dt;
    }
  };
  
  /// Langevin velocity update (Euler-Maruyama scheme)
  /// dv = (-γv/m + F/m)dt + √(2γkT/m)dW
  public func langevinVelocityUpdate(
    velocity : Float,
    force : Float,
    params : LangevinParams,
    noiseGen : NoiseGenerator
  ) : Float {
    let friction_term = -params.friction * velocity / params.mass;
    let force_term = force / params.mass;
    let noise_term = params.noiseStrength / params.mass * 
                     Float.sqrt(params.timestep) * generateThermalNoise(noiseGen);
    
    velocity + (friction_term + force_term) * params.timestep + noise_term
  };
  
  /// Full Langevin step (position and velocity update)
  public func langevinStep(
    position : Float,
    velocity : Float,
    force : Float,
    params : LangevinParams,
    noiseGen : NoiseGenerator
  ) : (Float, Float) {
    // BAOAB integrator step (simplified)
    let newVel = langevinVelocityUpdate(velocity, force, params, noiseGen);
    let newPos = position + newVel * params.timestep;
    
    (newPos, newVel)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // THERMAL BATH OPERATIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Initialize a thermal bath
  public func initThermalBath(
    numParticles : Nat,
    temp : Float,
    mass : Float,
    shellId : Nat8,
    seed : Nat
  ) : ThermalBath {
    var currentSeed = seed;
    
    let particles = Array.tabulate<ThermalParticle>(numParticles, func(i : Nat) : ThermalParticle {
      // Initialize positions randomly
      let pos = Array.init<Float>(DEGREES_OF_FREEDOM, 0.0);
      
      // Initialize velocities from MB distribution
      let (v1, s1) = sampleMBSpeed(mass, temp, currentSeed);
      currentSeed := s1;
      let (v2, s2) = sampleMBSpeed(mass, temp, currentSeed);
      currentSeed := s2;
      let (v3, s3) = sampleMBSpeed(mass, temp, currentSeed);
      currentSeed := s3;
      
      let vel = Array.tabulate<Float>(DEGREES_OF_FREEDOM, func(d : Nat) : Float {
        if (d == 0) { v1 / Float.sqrt(3.0) }
        else if (d == 1) { v2 / Float.sqrt(3.0) }
        else { v3 / Float.sqrt(3.0) }
      });
      
      // Kinetic energy: E = (1/2)mv²
      var ke : Float = 0.0;
      for (d in Iter.range(0, DEGREES_OF_FREEDOM - 1)) {
        ke += 0.5 * mass * vel[d] * vel[d];
      };
      
      {
        id = i;
        var position = pos;
        var velocity = vel;
        var energy = ke;
        mass = mass;
        var temperature = temp;
        shellId = shellId;
      }
    });
    
    // Compute total energy
    var totalE : Float = 0.0;
    for (p in particles.vals()) {
      totalE += p.energy;
    };
    
    // Heat capacity for ideal gas
    let C = computeHeatCapacity(numParticles * DEGREES_OF_FREEDOM);
    
    // Entropy for ideal gas (Sackur-Tetrode, simplified)
    let S = Float.fromInt(numParticles) * K_BOLTZMANN * 
            (2.5 + Float.log(temp / BASE_TEMPERATURE));
    
    {
      var temperature = temp;
      var heatCapacity = C;
      var entropy = S;
      var freeEnergy = totalE - temp * S;
      var totalEnergy = totalE;
      particles = particles;
      var isEquilibrated = false;
      var lastEquilibrationCheck = 0;
    }
  };
  
  /// Update thermal bath (one timestep)
  public func updateThermalBath(
    bath : ThermalBath,
    externalForces : [[Float]],  // Forces on each particle
    params : LangevinParams,
    noiseGen : NoiseGenerator
  ) : () {
    var totalKE : Float = 0.0;
    
    for (i in Iter.range(0, bath.particles.size() - 1)) {
      let p = bath.particles[i];
      
      for (d in Iter.range(0, DEGREES_OF_FREEDOM - 1)) {
        let force = if (i < externalForces.size() and d < externalForces[i].size()) {
          externalForces[i][d]
        } else { 0.0 };
        
        let (newPos, newVel) = langevinStep(
          p.position[d],
          p.velocity[d],
          force,
          params,
          noiseGen
        );
        
        p.position[d] := newPos;
        p.velocity[d] := newVel;
      };
      
      // Update kinetic energy
      var ke : Float = 0.0;
      for (d in Iter.range(0, DEGREES_OF_FREEDOM - 1)) {
        ke += 0.5 * p.mass * p.velocity[d] * p.velocity[d];
      };
      p.energy := ke;
      totalKE += ke;
      
      // Update local temperature estimate
      p.temperature := 2.0 * ke / (Float.fromInt(DEGREES_OF_FREEDOM) * K_BOLTZMANN);
    };
    
    bath.totalEnergy := totalKE;
    
    // Update effective temperature
    let n = bath.particles.size();
    let dof = Float.fromInt(n * DEGREES_OF_FREEDOM);
    bath.temperature := 2.0 * totalKE / (dof * K_BOLTZMANN);
    
    // Update entropy
    bath.entropy := Float.fromInt(n) * K_BOLTZMANN * 
                    (2.5 + Float.log(Float.max(bath.temperature / BASE_TEMPERATURE, 0.01)));
    
    // Update free energy
    bath.freeEnergy := bath.totalEnergy - bath.temperature * bath.entropy;
  };
  
  /// Check if bath is equilibrated (temperature stable)
  public func checkEquilibration(
    bath : ThermalBath,
    targetTemp : Float,
    tolerance : Float
  ) : Bool {
    let tempDiff = Float.abs(bath.temperature - targetTemp);
    let isEquil = tempDiff < tolerance * targetTemp;
    bath.isEquilibrated := isEquil;
    isEquil
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // HEAT FLOW BETWEEN SHELLS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Compute heat flow between two thermal baths
  /// Q = κ(T₁ - T₂) × contact_area
  public func computeHeatFlow(
    bath1 : ThermalBath,
    bath2 : ThermalBath,
    conductivity : Float,
    contactArea : Float
  ) : Float {
    conductivity * (bath1.temperature - bath2.temperature) * contactArea
  };
  
  /// Transfer heat between baths
  public func transferHeat(
    hotBath : ThermalBath,
    coldBath : ThermalBath,
    heatAmount : Float
  ) : () {
    // Energy conservation
    let actualHeat = Float.min(heatAmount, hotBath.totalEnergy * 0.1);  // Max 10% transfer
    
    // Update energies (simplified)
    hotBath.totalEnergy -= actualHeat;
    coldBath.totalEnergy += actualHeat;
    
    // Update temperatures
    if (hotBath.heatCapacity > 0.0) {
      hotBath.temperature -= actualHeat / hotBath.heatCapacity;
    };
    if (coldBath.heatCapacity > 0.0) {
      coldBath.temperature += actualHeat / coldBath.heatCapacity;
    };
    
    // Clamp temperatures
    hotBath.temperature := Float.max(MIN_TEMPERATURE, hotBath.temperature);
    coldBath.temperature := Float.min(MAX_TEMPERATURE, coldBath.temperature);
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // THERMAL STATE FOR ORGANISM INTEGRATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Complete thermal state
  public type ThermalState = {
    baths : [var ThermalBath];     // One per shell
    noiseGenerator : NoiseGenerator;
    langevinParams : LangevinParams;
    var globalTemperature : Float;
    var globalEntropy : Float;
    var globalFreeEnergy : Float;
    var totalHeatFlow : Float;
    var isGlobalEquilibrium : Bool;
    var lastUpdateBeat : Int;
  };
  
  /// Initialize thermal state for organism
  public func initThermalState(
    numShells : Nat,
    particlesPerShell : Nat,
    baseTemp : Float,
    seed : Nat
  ) : ThermalState {
    let baths = Array.init<ThermalBath>(numShells, func(s : Nat) : ThermalBath {
      // Each shell has slightly different temperature initially
      let shellTemp = baseTemp * (1.0 + 0.1 * Float.sin(Float.fromInt(s)));
      initThermalBath(particlesPerShell, shellTemp, 1.0, Nat8.fromNat(s), seed + s * 1000)
    });
    
    {
      baths = baths;
      noiseGenerator = initNoiseGenerator(seed, baseTemp, DEFAULT_FRICTION);
      langevinParams = initLangevinParams(DEFAULT_FRICTION, baseTemp, 1.0, 0.01);
      var globalTemperature = baseTemp;
      var globalEntropy = 0.0;
      var globalFreeEnergy = 0.0;
      var totalHeatFlow = 0.0;
      var isGlobalEquilibrium = false;
      var lastUpdateBeat = 0;
    }
  };
  
  /// Map coherence to effective temperature
  /// Low coherence → high temperature (exploration)
  /// High coherence → low temperature (exploitation)
  public func coherenceToTemperature(coherence : Float) : Float {
    // T = T_base / coherence (with bounds)
    let rawTemp = BASE_TEMPERATURE / Float.max(coherence, 0.1);
    Float.max(MIN_TEMPERATURE, Float.min(MAX_TEMPERATURE, rawTemp))
  };
  
  /// Map arousal to noise strength
  public func arousalToNoiseStrength(arousal : Float, baseNoise : Float) : Float {
    // Higher arousal → more thermal noise
    baseNoise * (0.5 + 1.5 * arousal)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // HEARTBEAT UPDATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Main heartbeat update for thermal substrate
  public func heartbeatUpdate(
    state : ThermalState,
    shellCoherences : [Float],
    externalForces : [[[Float]]],  // Forces per shell, per particle, per dimension
    currentBeat : Int
  ) : {
    globalTemp : Float;
    globalEntropy : Float;
    freeEnergy : Float;
    isEquilibrium : Bool;
    shellTemps : [Float];
  } {
    // Update noise generator temperature based on global coherence
    let meanCoherence = if (shellCoherences.size() > 0) {
      var sum : Float = 0.0;
      for (c in shellCoherences.vals()) { sum += c };
      sum / Float.fromInt(shellCoherences.size())
    } else { S_ZERO_FLOOR };
    
    let targetTemp = coherenceToTemperature(meanCoherence);
    state.noiseGenerator.temperature := targetTemp;
    state.noiseGenerator.variance := 2.0 * state.noiseGenerator.friction * 
                                     K_BOLTZMANN * targetTemp;
    state.langevinParams := initLangevinParams(
      DEFAULT_FRICTION,
      targetTemp,
      1.0,
      0.01
    );
    
    // Update each shell's thermal bath
    var totalEntropy : Float = 0.0;
    var totalEnergy : Float = 0.0;
    let shellTemps = Buffer.Buffer<Float>(state.baths.size());
    
    for (s in Iter.range(0, state.baths.size() - 1)) {
      let bath = state.baths[s];
      
      // Get forces for this shell
      let forces = if (s < externalForces.size()) {
        externalForces[s]
      } else { [] };
      
      // Update bath with Langevin dynamics
      updateThermalBath(bath, forces, state.langevinParams, state.noiseGenerator);
      
      totalEntropy += bath.entropy;
      totalEnergy += bath.totalEnergy;
      shellTemps.add(bath.temperature);
    };
    
    // Heat flow between adjacent shells
    var totalFlow : Float = 0.0;
    for (s in Iter.range(0, state.baths.size() - 2)) {
      let flow = computeHeatFlow(
        state.baths[s],
        state.baths[s + 1],
        THERMAL_CONDUCTIVITY,
        1.0
      );
      
      if (flow > 0.0) {
        transferHeat(state.baths[s], state.baths[s + 1], flow * 0.01);
      } else {
        transferHeat(state.baths[s + 1], state.baths[s], -flow * 0.01);
      };
      
      totalFlow += Float.abs(flow);
    };
    
    // Update global state
    state.globalTemperature := targetTemp;
    state.globalEntropy := totalEntropy;
    state.globalFreeEnergy := totalEnergy - targetTemp * totalEntropy;
    state.totalHeatFlow := totalFlow;
    state.lastUpdateBeat := currentBeat;
    
    // Check global equilibrium (all shells within tolerance)
    var isEquil = true;
    for (s in Iter.range(0, state.baths.size() - 1)) {
      if (not checkEquilibration(state.baths[s], targetTemp, 0.1)) {
        isEquil := false;
      };
    };
    state.isGlobalEquilibrium := isEquil;
    
    {
      globalTemp = state.globalTemperature;
      globalEntropy = state.globalEntropy;
      freeEnergy = state.globalFreeEnergy;
      isEquilibrium = state.isGlobalEquilibrium;
      shellTemps = Buffer.toArray(shellTemps);
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // QUERY FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Get global temperature
  public func getGlobalTemperature(state : ThermalState) : Float {
    state.globalTemperature
  };
  
  /// Get global entropy
  public func getGlobalEntropy(state : ThermalState) : Float {
    state.globalEntropy
  };
  
  /// Get global free energy
  public func getGlobalFreeEnergy(state : ThermalState) : Float {
    state.globalFreeEnergy
  };
  
  /// Get shell temperature
  public func getShellTemperature(state : ThermalState, shellId : Nat) : Float {
    if (shellId < state.baths.size()) {
      state.baths[shellId].temperature
    } else { BASE_TEMPERATURE }
  };
  
  /// Check if in thermal equilibrium
  public func isInEquilibrium(state : ThermalState) : Bool {
    state.isGlobalEquilibrium
  };
  
  /// Generate thermal noise for external use
  public func getThermalNoise(state : ThermalState) : Float {
    generateThermalNoise(state.noiseGenerator)
  };
  
  /// Get thermal noise array for multiple nodes
  public func getThermalNoiseArray(state : ThermalState, n : Nat) : [Float] {
    generateThermalNoiseArray(state.noiseGenerator, n)
  };

}
