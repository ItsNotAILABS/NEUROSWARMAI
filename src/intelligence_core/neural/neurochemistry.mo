// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  NOVA INTELLIGENCE CORE — NEURAL PILLAR                                                                   ║
// ║  Neurochemistry, Synaptic Plasticity, Spike-Timing, Ion Channels                                         ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

import Float "mo:core/Float";
import Array "mo:core/Array";
import Iter "mo:core/Iter";
import NovaComputing "../computing/core";

module NovaNeuralChemistry {

  // ═══════════════════════════════════════════════════════════════════════════════
  // NEUROCHEMICAL SPECIES — 21 TRANSMITTER SYSTEM
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Neurotransmitter concentration state
  public type NeurochemState = {
    dopamine : Float;       // Reward, motivation
    serotonin : Float;      // Mood regulation, homeostasis
    norepinephrine : Float; // Arousal, attention
    acetylcholine : Float;  // Learning, memory encoding
    gaba : Float;           // Inhibition, calm
    glutamate : Float;      // Excitation, primary signaling
    oxytocin : Float;       // Social bonding, trust
    cortisol : Float;       // Stress response
    endorphin : Float;      // Pain modulation, reward
    anandamide : Float;     // Cannabinoid system, homeostasis
    histamine : Float;      // Wakefulness
    melatonin : Float;      // Circadian rhythm
    adrenaline : Float;     // Fight-or-flight
    bdnf : Float;           // Neuroplasticity factor
    ngf : Float;            // Nerve growth factor
    substance_p : Float;    // Pain signal
    vasopressin : Float;    // Social memory, aggression
    dynorphin : Float;      // Aversion signal
    orexin : Float;         // Arousal, appetite
    adenosine : Float;      // Sleep pressure
    nitric_oxide : Float;   // Retrograde signaling
  };

  /// Default resting neurochemical state (all normalized 0..1)
  public func restingState() : NeurochemState {
    {
      dopamine = 0.5;
      serotonin = 0.6;
      norepinephrine = 0.4;
      acetylcholine = 0.5;
      gaba = 0.6;
      glutamate = 0.4;
      oxytocin = 0.3;
      cortisol = 0.2;
      endorphin = 0.3;
      anandamide = 0.4;
      histamine = 0.5;
      melatonin = 0.2;
      adrenaline = 0.1;
      bdnf = 0.5;
      ngf = 0.4;
      substance_p = 0.1;
      vasopressin = 0.3;
      dynorphin = 0.1;
      orexin = 0.5;
      adenosine = 0.3;
      nitric_oxide = 0.4;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // NEUROTRANSMITTER DYNAMICS
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Neurotransmitter release: vesicle fusion probability
  /// P(release) = 1 - exp(-Ca²⁺ / threshold)
  public func releaseProbability(calciumConcentration : Float, threshold : Float) : Float {
    1.0 - Float.exp(-calciumConcentration / Float.max(NovaComputing.EPSILON, threshold))
  };

  /// Reuptake dynamics: exponential decay back to baseline
  /// C(t+dt) = baseline + (C(t) - baseline) × exp(-dt/τ)
  public func reuptakeDecay(current : Float, baseline : Float, tau : Float, dt : Float) : Float {
    baseline + (current - baseline) * Float.exp(-dt / tau)
  };

  /// Receptor binding: Hill equation
  /// Response = Emax × [L]ⁿ / (Kd^n + [L]ⁿ)
  public func hillEquation(ligand : Float, kd : Float, n : Float, emax : Float) : Float {
    let ln = Float.pow(ligand, n);
    let kdn = Float.pow(kd, n);
    emax * ln / (kdn + ln)
  };

  /// Enzyme degradation: Michaelis-Menten kinetics
  /// v = Vmax × [S] / (Km + [S])
  public func michaelisMenten(substrate : Float, vmax : Float, km : Float) : Float {
    vmax * substrate / (km + substrate)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SYNAPTIC PLASTICITY
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Hebbian learning with weight normalization
  /// Δw = η × pre × post - λ × w (weight decay prevents explosion)
  public func hebbianNormalized(
    weight : Float,
    pre : Float,
    post : Float,
    learningRate : Float,
    decayRate : Float
  ) : Float {
    let newWeight = weight + learningRate * pre * post - decayRate * weight;
    NovaComputing.clamp(newWeight, -1.0, 1.0)
  };

  /// BCM (Bienenstock-Cooper-Munro) rule: sliding threshold
  /// Δw = η × pre × post × (post - θ)
  /// θ adjusts based on postsynaptic history
  public func bcmUpdate(
    weight : Float,
    pre : Float,
    post : Float,
    threshold : Float,
    learningRate : Float
  ) : Float {
    weight + learningRate * pre * post * (post - threshold)
  };

  /// Sliding threshold update: θ = <post²>
  public func bcmThresholdUpdate(currentTheta : Float, post : Float, tau : Float, dt : Float) : Float {
    currentTheta + (post * post - currentTheta) * (dt / tau)
  };

  /// STDP kernel: asymmetric exponential
  /// A+ × exp(-Δt/τ+)  if Δt > 0 (LTP)
  /// -A- × exp(Δt/τ-)  if Δt < 0 (LTD)
  public func stdpKernel(
    deltaT : Float,
    aPlus : Float,
    aMinus : Float,
    tauPlus : Float,
    tauMinus : Float
  ) : Float {
    if (deltaT > 0.0) {
      aPlus * Float.exp(-deltaT / tauPlus)
    } else if (deltaT < 0.0) {
      -aMinus * Float.exp(deltaT / tauMinus)
    } else {
      0.0
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // ION CHANNEL DYNAMICS — HODGKIN-HUXLEY MODEL
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Membrane potential update (simplified Hodgkin-Huxley)
  /// C dV/dt = I_ext - g_Na × m³h(V-E_Na) - g_K × n⁴(V-E_K) - g_L(V-E_L)
  public func membraneUpdate(
    v : Float,
    m : Float,
    h : Float,
    n : Float,
    iExt : Float,
    dt : Float
  ) : Float {
    let gNa : Float = 120.0;
    let gK : Float = 36.0;
    let gL : Float = 0.3;
    let eNa : Float = 50.0;
    let eK : Float = -77.0;
    let eL : Float = -54.4;
    let cm : Float = 1.0;

    let iNa = gNa * Float.pow(m, 3.0) * h * (v - eNa);
    let iK = gK * Float.pow(n, 4.0) * (v - eK);
    let iL = gL * (v - eL);

    v + (iExt - iNa - iK - iL) * dt / cm
  };

  /// Gating variable rate: α_m(V) = 0.1(V+40)/(1-exp(-(V+40)/10))
  public func alphaN(v : Float) : Float {
    let denom = 1.0 - Float.exp(-(v + 55.0) / 10.0);
    if (Float.abs(denom) < NovaComputing.EPSILON) {
      0.1
    } else {
      0.01 * (v + 55.0) / denom
    }
  };

  /// β_n(V) = 0.125 × exp(-(V+65)/80)
  public func betaN(v : Float) : Float {
    0.125 * Float.exp(-(v + 65.0) / 80.0)
  };

  /// Gating variable steady-state: n∞ = α/(α+β)
  public func gatingSteadyState(alpha : Float, beta : Float) : Float {
    alpha / (alpha + beta + NovaComputing.EPSILON)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SPIKE GENERATION
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Leaky integrate-and-fire neuron
  /// dV/dt = -(V - V_rest)/τ + I/C
  public func lifUpdate(
    voltage : Float,
    vRest : Float,
    tau : Float,
    current : Float,
    capacitance : Float,
    dt : Float
  ) : Float {
    voltage + (-(voltage - vRest) / tau + current / capacitance) * dt
  };

  /// Check if neuron fires (voltage exceeds threshold)
  public func shouldSpike(voltage : Float, threshold : Float) : Bool {
    voltage >= threshold
  };

  /// Post-spike reset
  public func resetVoltage(vReset : Float) : Float {
    vReset
  };

  /// Refractory period check
  public func isRefractory(timeSinceSpike : Float, refractoryPeriod : Float) : Bool {
    timeSinceSpike < refractoryPeriod
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // POPULATION DYNAMICS
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Wilson-Cowan population model
  /// dE/dt = (-E + S(w_EE×E - w_EI×I + I_ext)) / τ_E
  public func wilsonCowanExcitatory(
    e : Float,
    inhibitory : Float,
    wEE : Float,
    wEI : Float,
    iExt : Float,
    tau : Float,
    dt : Float
  ) : Float {
    let input = wEE * e - wEI * inhibitory + iExt;
    let response = NovaComputing.sigmoid(input);
    e + (-e + response) * dt / tau
  };

  /// Inhibitory population update
  public func wilsonCowanInhibitory(
    inhibitory : Float,
    excitatory : Float,
    wIE : Float,
    wII : Float,
    tau : Float,
    dt : Float
  ) : Float {
    let input = wIE * excitatory - wII * inhibitory;
    let response = NovaComputing.sigmoid(input);
    inhibitory + (-inhibitory + response) * dt / tau
  };

  /// Firing rate from membrane potential (soft threshold)
  public func firingRate(voltage : Float, threshold : Float, gain : Float) : Float {
    NovaComputing.sigmoid(gain * (voltage - threshold))
  };

}
