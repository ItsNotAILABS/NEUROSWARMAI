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

module QuantumSubstrate {

  // ═══════════════════════════════════════════════════════════════════════════════
  // PHYSICAL CONSTANTS (Normalized for substrate scale)
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public let PI : Float = 3.14159265358979323846;
  public let TWO_PI : Float = 6.28318530717958647692;
  public let E : Float = 2.71828182845904523536;
  public let HBAR : Float = 1.0;          // Normalized Planck constant
  public let KB : Float = 1.0;            // Normalized Boltzmann constant
  public let SQRT_2 : Float = 1.41421356237;
  public let SQRT_2_INV : Float = 0.70710678118;

  // ═══════════════════════════════════════════════════════════════════════════════
  // QUANTUM STATE — Complex amplitude representation
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type ComplexNumber = {
    re : Float;                   // Real part
    im : Float;                   // Imaginary part
  };
  
  public func complexZero() : ComplexNumber {
    { re = 0.0; im = 0.0 }
  };
  
  public func complexOne() : ComplexNumber {
    { re = 1.0; im = 0.0 }
  };
  
  public func complexAdd(a : ComplexNumber, b : ComplexNumber) : ComplexNumber {
    { re = a.re + b.re; im = a.im + b.im }
  };
  
  public func complexMul(a : ComplexNumber, b : ComplexNumber) : ComplexNumber {
    { 
      re = a.re * b.re - a.im * b.im;
      im = a.re * b.im + a.im * b.re;
    }
  };
  
  public func complexConj(a : ComplexNumber) : ComplexNumber {
    { re = a.re; im = -a.im }
  };
  
  public func complexNorm(a : ComplexNumber) : Float {
    sqrt(a.re * a.re + a.im * a.im)
  };
  
  public func complexNormSq(a : ComplexNumber) : Float {
    a.re * a.re + a.im * a.im
  };
  
  public type QuantumState = {
    amplitudes : [ComplexNumber]; // State vector (normalized)
    dim : Nat;                    // Hilbert space dimension
    basis : QuantumBasis;
  };
  
  public type QuantumBasis = {
    #Computational;               // |0⟩, |1⟩, |2⟩, ...
    #Hadamard;                    // |+⟩, |-⟩, ...
    #Bell;                        // Entangled basis
    #Custom : [[ComplexNumber]];  // Custom basis vectors
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // 8 QUANTUM OPERATORS — Mathematical transformations
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type QuantumOperator = {
    id : Nat8;
    name : Text;
    symbol : Text;
    matrix : [[ComplexNumber]];   // Operator matrix
    isUnitary : Bool;
    isHermitian : Bool;
    eigenvalues : [Float];
  };
  
  public type OperatorIndex = {
    #Identity;        // I: Does nothing
    #PauliX;          // X: Bit flip (NOT gate)
    #PauliY;          // Y: Bit + phase flip
    #PauliZ;          // Z: Phase flip
    #Hadamard;        // H: Superposition creation
    #Phase;           // S: Phase gate (90°)
    #T;               // T: T gate (45°)
    #CNOT;            // CX: Controlled NOT (2-qubit)
  };
  
  // Identity operator
  public func identityOp() : QuantumOperator {
    {
      id = 0;
      name = "Identity";
      symbol = "I";
      matrix = [
        [{ re = 1.0; im = 0.0 }, { re = 0.0; im = 0.0 }],
        [{ re = 0.0; im = 0.0 }, { re = 1.0; im = 0.0 }],
      ];
      isUnitary = true;
      isHermitian = true;
      eigenvalues = [1.0, 1.0];
    }
  };
  
  // Pauli X (bit flip)
  public func pauliX() : QuantumOperator {
    {
      id = 1;
      name = "Pauli-X";
      symbol = "X";
      matrix = [
        [{ re = 0.0; im = 0.0 }, { re = 1.0; im = 0.0 }],
        [{ re = 1.0; im = 0.0 }, { re = 0.0; im = 0.0 }],
      ];
      isUnitary = true;
      isHermitian = true;
      eigenvalues = [1.0, -1.0];
    }
  };
  
  // Pauli Y
  public func pauliY() : QuantumOperator {
    {
      id = 2;
      name = "Pauli-Y";
      symbol = "Y";
      matrix = [
        [{ re = 0.0; im = 0.0 }, { re = 0.0; im = -1.0 }],
        [{ re = 0.0; im = 1.0 }, { re = 0.0; im = 0.0 }],
      ];
      isUnitary = true;
      isHermitian = true;
      eigenvalues = [1.0, -1.0];
    }
  };
  
  // Pauli Z (phase flip)
  public func pauliZ() : QuantumOperator {
    {
      id = 3;
      name = "Pauli-Z";
      symbol = "Z";
      matrix = [
        [{ re = 1.0; im = 0.0 }, { re = 0.0; im = 0.0 }],
        [{ re = 0.0; im = 0.0 }, { re = -1.0; im = 0.0 }],
      ];
      isUnitary = true;
      isHermitian = true;
      eigenvalues = [1.0, -1.0];
    }
  };
  
  // Hadamard (superposition)
  public func hadamardOp() : QuantumOperator {
    {
      id = 4;
      name = "Hadamard";
      symbol = "H";
      matrix = [
        [{ re = SQRT_2_INV; im = 0.0 }, { re = SQRT_2_INV; im = 0.0 }],
        [{ re = SQRT_2_INV; im = 0.0 }, { re = -SQRT_2_INV; im = 0.0 }],
      ];
      isUnitary = true;
      isHermitian = true;
      eigenvalues = [1.0, -1.0];
    }
  };
  
  // Phase gate (S)
  public func phaseGate() : QuantumOperator {
    {
      id = 5;
      name = "Phase";
      symbol = "S";
      matrix = [
        [{ re = 1.0; im = 0.0 }, { re = 0.0; im = 0.0 }],
        [{ re = 0.0; im = 0.0 }, { re = 0.0; im = 1.0 }],
      ];
      isUnitary = true;
      isHermitian = false;
      eigenvalues = [1.0, 1.0];  // |eigenvalue| = 1
    }
  };
  
  // T gate (π/8)
  public func tGate() : QuantumOperator {
    let cosPI4 = 0.92387953251;
    let sinPI4 = 0.38268343236;
    {
      id = 6;
      name = "T-Gate";
      symbol = "T";
      matrix = [
        [{ re = 1.0; im = 0.0 }, { re = 0.0; im = 0.0 }],
        [{ re = 0.0; im = 0.0 }, { re = cosPI4; im = sinPI4 }],
      ];
      isUnitary = true;
      isHermitian = false;
      eigenvalues = [1.0, 1.0];
    }
  };
  
  // CNOT (controlled NOT) - 4x4 for 2 qubits
  public func cnotOp() : QuantumOperator {
    {
      id = 7;
      name = "CNOT";
      symbol = "CX";
      matrix = [
        [{ re = 1.0; im = 0.0 }, { re = 0.0; im = 0.0 }, { re = 0.0; im = 0.0 }, { re = 0.0; im = 0.0 }],
        [{ re = 0.0; im = 0.0 }, { re = 1.0; im = 0.0 }, { re = 0.0; im = 0.0 }, { re = 0.0; im = 0.0 }],
        [{ re = 0.0; im = 0.0 }, { re = 0.0; im = 0.0 }, { re = 0.0; im = 0.0 }, { re = 1.0; im = 0.0 }],
        [{ re = 0.0; im = 0.0 }, { re = 0.0; im = 0.0 }, { re = 1.0; im = 0.0 }, { re = 0.0; im = 0.0 }],
      ];
      isUnitary = true;
      isHermitian = true;
      eigenvalues = [1.0, 1.0, 1.0, -1.0];
    }
  };
  
  // All 8 operators
  public func getOperators() : [QuantumOperator] {
    [identityOp(), pauliX(), pauliY(), pauliZ(), hadamardOp(), phaseGate(), tGate(), cnotOp()]
  };
  
  // Apply operator to state
  public func applyOperator(
    op : QuantumOperator,
    state : QuantumState
  ) : QuantumState {
    let n = state.dim;
    let m = op.matrix.size();
    
    if (n != m) {
      // Dimension mismatch — return original state
      return state;
    };
    
    // Matrix-vector multiplication
    let newAmps = Array.init<ComplexNumber>(n, func(i : Nat) : ComplexNumber {
      var sum = complexZero();
      for (j in Iter.range(0, n - 1)) {
        sum := complexAdd(sum, complexMul(op.matrix[i][j], state.amplitudes[j]));
      };
      sum
    });
    
    {
      amplitudes = Array.freeze(newAmps);
      dim = n;
      basis = state.basis;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // QUANTUM BATTERY — Superradiance charge, Shell 3 discharge
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type QuantumBattery = {
    capacity : Float;             // Maximum charge
    currentCharge : Float;        // Current charge level
    chargeRate : Float;           // Superradiance charge rate
    dischargeRate : Float;        // Discharge to Shell 3
    efficiency : Float;           // Charge-discharge efficiency
    temperature : Float;          // Effective temperature
    coherenceRequired : Float;    // Minimum coherence for operation
    numCells : Nat;               // Number of quantum cells
    cellStates : [QuantumState];  // State of each cell
    entanglementLevel : Float;    // Inter-cell entanglement
    resoneCoupling : Float;       // Coupling to RESONE
  };
  
  public func initQuantumBattery(numCells : Nat) : QuantumBattery {
    let cellStates = Array.tabulate<QuantumState>(numCells, func(i : Nat) : QuantumState {
      // Initialize in ground state |0⟩
      {
        amplitudes = [{ re = 1.0; im = 0.0 }, { re = 0.0; im = 0.0 }];
        dim = 2;
        basis = #Computational;
      }
    });
    
    {
      capacity = 100.0;
      currentCharge = 0.0;
      chargeRate = 0.1;
      dischargeRate = 0.05;
      efficiency = 0.95;
      temperature = 1.0;
      coherenceRequired = 0.5;
      numCells = numCells;
      cellStates = cellStates;
      entanglementLevel = 0.0;
      resoneCoupling = 0.1;
    }
  };
  
  // Superradiance charging: N² enhancement
  // Charge rate ∝ N² when cells are coherent
  public func superradianceCharge(
    battery : QuantumBattery,
    inputEnergy : Float,
    coherence : Float,
    dt : Float
  ) : QuantumBattery {
    // Superradiance factor: N² enhancement when coherent
    let n = Float.fromInt(battery.numCells);
    let superradianceFactor = if (coherence > battery.coherenceRequired) {
      n * n * coherence  // N² enhancement
    } else {
      n  // Linear (no enhancement)
    };
    
    // Effective charge rate
    let effectiveRate = battery.chargeRate * superradianceFactor * battery.efficiency;
    
    // New charge
    let energyAbsorbed = inputEnergy * effectiveRate * dt;
    let newCharge = battery.currentCharge + energyAbsorbed;
    
    // Update entanglement based on coherence
    let newEntanglement = coherence * (1.0 - battery.entanglementLevel) * 0.1 + battery.entanglementLevel * 0.99;
    
    {
      capacity = battery.capacity;
      currentCharge = Float.min(newCharge, battery.capacity);
      chargeRate = battery.chargeRate;
      dischargeRate = battery.dischargeRate;
      efficiency = battery.efficiency;
      temperature = battery.temperature;
      coherenceRequired = battery.coherenceRequired;
      numCells = battery.numCells;
      cellStates = battery.cellStates;
      entanglementLevel = newEntanglement;
      resoneCoupling = battery.resoneCoupling;
    }
  };
  
  // Discharge to Shell 3
  public func dischargeToShell3(
    battery : QuantumBattery,
    shell3Demand : Float,
    dt : Float
  ) : (QuantumBattery, Float) {
    // Calculate discharge amount
    let maxDischarge = battery.dischargeRate * dt * battery.entanglementLevel;
    let actualDischarge = Float.min(Float.min(shell3Demand, maxDischarge), battery.currentCharge);
    
    let newCharge = battery.currentCharge - actualDischarge;
    let energyDelivered = actualDischarge * battery.efficiency;
    
    // Discharge reduces entanglement
    let newEntanglement = battery.entanglementLevel * (1.0 - actualDischarge / battery.capacity * 0.1);
    
    let newBattery = {
      capacity = battery.capacity;
      currentCharge = newCharge;
      chargeRate = battery.chargeRate;
      dischargeRate = battery.dischargeRate;
      efficiency = battery.efficiency;
      temperature = battery.temperature;
      coherenceRequired = battery.coherenceRequired;
      numCells = battery.numCells;
      cellStates = battery.cellStates;
      entanglementLevel = newEntanglement;
      resoneCoupling = battery.resoneCoupling;
    };
    
    (newBattery, energyDelivered)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // FREE ENERGY F — Thermodynamic-Information Bridge
  // F = E - T·S (Helmholtz free energy)
  // F = ⟨E⟩ - kT·H (Quantum version with von Neumann entropy)
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type FreeEnergyReading = {
    totalF : Float;               // Total free energy
    internalEnergy : Float;       // ⟨E⟩ expected energy
    entropy : Float;              // S (von Neumann or Shannon)
    temperature : Float;          // T
    partitionZ : Float;           // Z partition function
    chemicalPotential : Float;    // μ
    components : FreeEnergyComponents;
    history : [Float];
    gradient : Float;             // dF/dt
  };
  
  public type FreeEnergyComponents = {
    electrochemical : Float;
    informational : Float;
    mechanical : Float;
    thermal : Float;
    quantum : Float;
  };
  
  public func computeFreeEnergy(
    internalEnergy : Float,
    entropy : Float,
    temperature : Float
  ) : Float {
    // F = E - T·S (Helmholtz)
    internalEnergy - temperature * entropy
  };
  
  public func computeVonNeumannEntropy(state : QuantumState) : Float {
    // S = -Σ p_i × log(p_i) where p_i = |amplitude_i|²
    var entropy : Float = 0.0;
    
    for (amp in state.amplitudes.vals()) {
      let p = complexNormSq(amp);
      if (p > 0.0001) {
        entropy -= p * ln(p);
      };
    };
    
    entropy
  };
  
  public func computeFullFreeEnergyReading(
    battery : QuantumBattery,
    externalEnergy : Float,
    externalEntropy : Float
  ) : FreeEnergyReading {
    // Compute total entropy from battery cells
    var totalEntropy : Float = externalEntropy;
    for (cellState in battery.cellStates.vals()) {
      totalEntropy += computeVonNeumannEntropy(cellState);
    };
    
    // Internal energy from charge
    let internalEnergy = battery.currentCharge + externalEnergy;
    
    // Free energy
    let totalF = computeFreeEnergy(internalEnergy, totalEntropy, battery.temperature);
    
    // Partition function approximation
    let partitionZ = exp(-totalF / (KB * battery.temperature));
    
    // Components (estimated)
    let components : FreeEnergyComponents = {
      electrochemical = battery.currentCharge * 0.3;
      informational = totalEntropy * battery.temperature * 0.25;
      mechanical = externalEnergy * 0.2;
      thermal = battery.temperature * totalEntropy * 0.15;
      quantum = battery.entanglementLevel * battery.currentCharge * 0.1;
    };
    
    {
      totalF = totalF;
      internalEnergy = internalEnergy;
      entropy = totalEntropy;
      temperature = battery.temperature;
      partitionZ = partitionZ;
      chemicalPotential = 0.0;
      components = components;
      history = [];
      gradient = 0.0;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // RESONE — Resonance coupling system
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type RESONE = {
    frequency : Float;            // Resonance frequency
    amplitude : Float;            // Resonance amplitude
    phase : Float;                // Current phase
    damping : Float;              // Damping coefficient
    coupling : [Float];           // Coupling to other systems
    quality : Float;              // Q factor
    bandwidth : Float;            // Resonance bandwidth
    energy : Float;               // Stored resonant energy
    detuning : Float;             // Frequency detuning
  };
  
  public func initRESONE(baseFrequency : Float) : RESONE {
    {
      frequency = baseFrequency;
      amplitude = 0.0;
      phase = 0.0;
      damping = 0.01;
      coupling = [0.1, 0.1, 0.1, 0.1, 0.1];  // 5 coupling channels
      quality = 100.0;
      bandwidth = baseFrequency / 100.0;
      energy = 0.0;
      detuning = 0.0;
    }
  };
  
  // Drive RESONE with external signal
  public func driveRESONE(
    resone : RESONE,
    driveFrequency : Float,
    driveAmplitude : Float,
    dt : Float
  ) : RESONE {
    // Detuning from resonance
    let detuning = driveFrequency - resone.frequency;
    
    // Lorentzian response
    let gamma = resone.damping;
    let response = 1.0 / sqrt(detuning * detuning + gamma * gamma);
    
    // Phase evolution
    let newPhase = resone.phase + TWO_PI * resone.frequency * dt;
    
    // Amplitude evolution (driven damped oscillator)
    let dAmp = driveAmplitude * response - resone.damping * resone.amplitude;
    let newAmplitude = resone.amplitude + dAmp * dt;
    
    // Energy
    let newEnergy = 0.5 * newAmplitude * newAmplitude * resone.frequency * resone.frequency;
    
    {
      frequency = resone.frequency;
      amplitude = newAmplitude;
      phase = wrapPhase(newPhase);
      damping = resone.damping;
      coupling = resone.coupling;
      quality = resone.quality;
      bandwidth = resone.bandwidth;
      energy = newEnergy;
      detuning = detuning;
    }
  };
  
  // Couple RESONE to quantum battery
  public func coupleResoneToBattery(
    resone : RESONE,
    battery : QuantumBattery,
    couplingStrength : Float,
    dt : Float
  ) : (RESONE, QuantumBattery) {
    // Energy exchange
    let energyTransfer = resone.energy * couplingStrength * dt;
    
    // Transfer from RESONE to battery
    let newResoneEnergy = resone.energy - energyTransfer;
    let newBatteryCharge = battery.currentCharge + energyTransfer * battery.efficiency;
    
    let newResone = {
      frequency = resone.frequency;
      amplitude = sqrt(2.0 * newResoneEnergy / (resone.frequency * resone.frequency));
      phase = resone.phase;
      damping = resone.damping;
      coupling = resone.coupling;
      quality = resone.quality;
      bandwidth = resone.bandwidth;
      energy = newResoneEnergy;
      detuning = resone.detuning;
    };
    
    let newBattery = {
      capacity = battery.capacity;
      currentCharge = Float.min(newBatteryCharge, battery.capacity);
      chargeRate = battery.chargeRate;
      dischargeRate = battery.dischargeRate;
      efficiency = battery.efficiency;
      temperature = battery.temperature;
      coherenceRequired = battery.coherenceRequired;
      numCells = battery.numCells;
      cellStates = battery.cellStates;
      entanglementLevel = battery.entanglementLevel;
      resoneCoupling = couplingStrength;
    };
    
    (newResone, newBattery)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // COMPLETE QUANTUM STATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type QuantumSubstrateState = {
    operators : [QuantumOperator];
    battery : QuantumBattery;
    freeEnergy : FreeEnergyReading;
    resone : RESONE;
    globalPhase : Float;
    decoherenceRate : Float;
    quantumAdvantage : Float;     // How much quantum helps
    lastUpdate : Int;
  };
  
  public func initQuantumSubstrateState() : QuantumSubstrateState {
    let battery = initQuantumBattery(16);  // 16 quantum cells
    let resone = initRESONE(12.0);         // 12 Hz resonance
    
    {
      operators = getOperators();
      battery = battery;
      freeEnergy = computeFullFreeEnergyReading(battery, 0.0, 0.0);
      resone = resone;
      globalPhase = 0.0;
      decoherenceRate = 0.01;
      quantumAdvantage = 1.0;
      lastUpdate = 0;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // QUANTUM TICK — One beat of quantum processing
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type QuantumTickResult = {
    batteryLevel : Float;
    freeEnergyF : Float;
    entanglement : Float;
    resoneEnergy : Float;
    energyDelivered : Float;
    quantumAdvantage : Float;
  };
  
  public func quantumTick(
    state : QuantumSubstrateState,
    inputEnergy : Float,
    coherence : Float,
    shell3Demand : Float,
    dt : Float,
    currentBeat : Int
  ) : (QuantumTickResult, QuantumSubstrateState) {
    // 1. Superradiance charge battery
    let chargedBattery = superradianceCharge(state.battery, inputEnergy, coherence, dt);
    
    // 2. Discharge to Shell 3
    let (discharged, delivered) = dischargeToShell3(chargedBattery, shell3Demand, dt);
    
    // 3. Update RESONE
    let drivenResone = driveRESONE(state.resone, 12.0, coherence * 0.1, dt);
    
    // 4. Couple RESONE to battery
    let (coupledResone, coupledBattery) = coupleResoneToBattery(
      drivenResone, discharged, state.battery.resoneCoupling, dt
    );
    
    // 5. Compute free energy
    let newFreeEnergy = computeFullFreeEnergyReading(coupledBattery, delivered, coherence * 0.5);
    
    // 6. Update global phase
    let newPhase = wrapPhase(state.globalPhase + TWO_PI * 12.0 * dt);
    
    // 7. Quantum advantage = entanglement * coherence * battery factor
    let quantumAdv = coupledBattery.entanglementLevel * coherence * 
                     (coupledBattery.currentCharge / coupledBattery.capacity);
    
    let result : QuantumTickResult = {
      batteryLevel = coupledBattery.currentCharge;
      freeEnergyF = newFreeEnergy.totalF;
      entanglement = coupledBattery.entanglementLevel;
      resoneEnergy = coupledResone.energy;
      energyDelivered = delivered;
      quantumAdvantage = quantumAdv;
    };
    
    let newState : QuantumSubstrateState = {
      operators = state.operators;
      battery = coupledBattery;
      freeEnergy = newFreeEnergy;
      resone = coupledResone;
      globalPhase = newPhase;
      decoherenceRate = state.decoherenceRate;
      quantumAdvantage = quantumAdv;
      lastUpdate = currentBeat;
    };
    
    (result, newState)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // HELPER FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  func sqrt(x : Float) : Float {
    if (x <= 0.0) { return 0.0 };
    var guess = x / 2.0;
    for (_ in Iter.range(0, 15)) {
      guess := (guess + x / guess) / 2.0;
    };
    guess
  };
  
  func exp(x : Float) : Float {
    if (x > 10.0) { return 22026.0 };
    if (x < -10.0) { return 0.0 };
    var result : Float = 1.0;
    var term : Float = 1.0;
    for (n in Iter.range(1, 25)) {
      term := term * x / Float.fromInt(n);
      result += term;
    };
    result
  };
  
  func ln(x : Float) : Float {
    if (x <= 0.0) { return -1000.0 };
    if (x == 1.0) { return 0.0 };
    var y = x - 1.0;
    if (y > 1.0) { y := 1.0 };
    if (y < -0.99) { y := -0.99 };
    var result : Float = 0.0;
    var term = y;
    for (n in Iter.range(1, 50)) {
      if (n % 2 == 1) {
        result += term / Float.fromInt(n);
      } else {
        result -= term / Float.fromInt(n);
      };
      term *= y;
    };
    result
  };
  
  func wrapPhase(phase : Float) : Float {
    var p = phase;
    while (p >= TWO_PI) { p -= TWO_PI };
    while (p < 0.0) { p += TWO_PI };
    p
  };

}
