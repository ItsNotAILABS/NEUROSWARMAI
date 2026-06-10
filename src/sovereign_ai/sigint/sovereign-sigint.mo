// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  SOVEREIGN AI — SIGNAL INTELLIGENCE (SIGINT) LIBRARY                                                      ║
// ║  Zero Third-Party Dependencies — ITAR/EAR Compliant — Air-Gap Ready — EW-Resilient                       ║
// ║                                                                                                           ║
// ║  EXPORT CONTROL: ITAR 22 CFR §121.1 Category XI — Military Electronics                                   ║
// ║  This module is DEFINITIVELY export-controlled. DO NOT EXPORT.                                            ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

import Float "mo:core/Float";
import Array "mo:core/Array";
import Iter "mo:core/Iter";
import Nat "mo:core/Nat";
import Int "mo:core/Int";
import SovereignTensor "../tensor/sovereign-tensor";

module SovereignSIGINT {

  // ═══════════════════════════════════════════════════════════════════════════════
  // TYPES — SIGNAL INTELLIGENCE
  // ═══════════════════════════════════════════════════════════════════════════════

  /// RF signal representation
  public type Signal = {
    samples : [Float];
    sampleRate : Float;      // Hz
    centerFrequency : Float; // Hz
    bandwidth : Float;       // Hz
    timestamp : Int;
  };

  /// Detected emitter
  public type Emitter = {
    frequency : Float;
    bandwidth : Float;
    power : Float;          // dBm
    bearing : Float;        // degrees
    confidence : Float;     // 0-1
    classification : EmitterClass;
  };

  /// Emitter classification
  public type EmitterClass = {
    #friendly;
    #hostile;
    #neutral;
    #unknown;
    #jammer;
  };

  /// Electronic warfare threat
  public type EWThreat = {
    threatType : ThreatType;
    frequency : Float;
    power : Float;
    bearing : Float;
    timeToImpact : Float;
    recommendedAction : CountermeasureAction;
  };

  /// Threat types in EW environment
  public type ThreatType = {
    #barrage_jammer;        // Broadband noise jammer
    #spot_jammer;           // Narrowband targeted jammer
    #sweep_jammer;          // Frequency-sweeping jammer
    #deception_jammer;      // False signal injection
    #drfm_repeater;        // Digital RF memory repeater
    #anti_radiation_missile; // Seeks RF emissions
  };

  /// Countermeasure actions
  public type CountermeasureAction = {
    #frequency_hop;
    #power_reduction;
    #emission_control;     // EMCON
    #spread_spectrum;
    #null_steering;
    #decoy_emission;
  };

  /// Kalman filter state for signal tracking
  public type KalmanState = {
    var x : [var Float];   // State estimate [freq, freq_rate, power, bearing]
    var P : SovereignTensor.Matrix;  // Error covariance
    F : SovereignTensor.Matrix;      // State transition
    H : SovereignTensor.Matrix;      // Observation model
    Q : SovereignTensor.Matrix;      // Process noise
    R : SovereignTensor.Matrix;      // Measurement noise
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SIGNAL DETECTION — SOVEREIGN ENERGY DETECTOR
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Energy detection: compute signal energy in time window
  public func signalEnergy(signal : Signal) : Float {
    var energy : Float = 0.0;
    for (s in signal.samples.vals()) {
      energy += s * s;
    };
    energy / Float.fromInt(signal.samples.size())
  };

  /// Constant False Alarm Rate (CFAR) detector
  /// Detects signals above adaptive threshold
  public func cfarDetect(
    spectrum : SovereignTensor.Vector,
    guardCells : Nat,
    trainCells : Nat,
    thresholdFactor : Float
  ) : [Nat] {
    let n = spectrum.size();
    var detections : [Nat] = [];
    let windowSize = guardCells + trainCells;

    for (i in Iter.range(windowSize, n - windowSize - 1)) {
      // Compute noise estimate from training cells
      var noiseSum : Float = 0.0;
      var count : Nat = 0;

      // Leading training cells
      for (j in Iter.range(i - windowSize, i - guardCells - 1)) {
        noiseSum += spectrum[j];
        count += 1;
      };
      // Trailing training cells
      for (j in Iter.range(i + guardCells + 1, i + windowSize)) {
        noiseSum += spectrum[j];
        count += 1;
      };

      let noiseEstimate = noiseSum / Float.fromInt(count);
      let threshold = noiseEstimate * thresholdFactor;

      // Detection decision
      if (spectrum[i] > threshold) {
        detections := Array.append(detections, [i]);
      };
    };
    detections
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // FREQUENCY ANALYSIS — SOVEREIGN FFT (NO FFTW)
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Goertzel algorithm — efficient single-frequency DFT
  /// More efficient than full FFT when looking for specific frequencies
  public func goertzel(samples : [Float], targetFreq : Float, sampleRate : Float) : Float {
    let n = samples.size();
    let k = Float.fromInt(n) * targetFreq / sampleRate;
    let omega = 6.2831853071795864769 * k / Float.fromInt(n);
    let coeff = 2.0 * Float.cos(omega);

    var s0 : Float = 0.0;
    var s1 : Float = 0.0;
    var s2 : Float = 0.0;

    for (sample in samples.vals()) {
      s0 := sample + coeff * s1 - s2;
      s2 := s1;
      s1 := s0;
    };

    // Power = s1² + s2² - coeff×s1×s2
    s1 * s1 + s2 * s2 - coeff * s1 * s2
  };

  /// Frequency estimation via zero-crossing rate
  public func zeroCrossingRate(samples : [Float]) : Float {
    let n = samples.size();
    if (n < 2) return 0.0;

    var crossings : Nat = 0;
    for (i in Iter.range(1, n - 1)) {
      if ((samples[i - 1] >= 0.0 and samples[i] < 0.0) or
          (samples[i - 1] < 0.0 and samples[i] >= 0.0)) {
        crossings += 1;
      };
    };
    Float.fromInt(crossings) / (2.0 * Float.fromInt(n))
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // KALMAN FILTER — SOVEREIGN SIGNAL TRACKING
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Initialize Kalman filter for emitter tracking
  public func initKalman(
    initialState : [Float],
    processNoise : Float,
    measurementNoise : Float
  ) : KalmanState {
    let stateDim = initialState.size();

    let x = Array.init<Float>(stateDim, 0.0);
    for (i in Iter.range(0, stateDim - 1)) {
      x[i] := initialState[i];
    };

    let P = SovereignTensor.identity(stateDim);
    let F = SovereignTensor.identity(stateDim);
    let H = SovereignTensor.identity(stateDim);
    let Q = SovereignTensor.scale(SovereignTensor.identity(stateDim), processNoise);
    let R = SovereignTensor.scale(SovereignTensor.identity(stateDim), measurementNoise);

    { var x = x; var P = P; F; H; Q; R }
  };

  /// Kalman predict step
  public func kalmanPredict(state : KalmanState) : () {
    // x = F × x
    let n = state.x.size();
    let newX = Array.init<Float>(n, 0.0);
    for (i in Iter.range(0, n - 1)) {
      var sum : Float = 0.0;
      for (j in Iter.range(0, n - 1)) {
        sum += SovereignTensor.get(state.F, i, j) * state.x[j];
      };
      newX[i] := sum;
    };
    for (i in Iter.range(0, n - 1)) {
      state.x[i] := newX[i];
    };

    // P = F × P × Fᵀ + Q
    let FP = SovereignTensor.matmul(state.F, state.P);
    let FT = SovereignTensor.transpose(state.F);
    let FPFT = SovereignTensor.matmul(FP, FT);
    state.P := SovereignTensor.add(FPFT, state.Q);
  };

  /// Kalman update step with measurement
  public func kalmanUpdate(state : KalmanState, measurement : [Float]) : () {
    let n = state.x.size();

    // Innovation: y = z - H × x
    let innovation = Array.init<Float>(n, 0.0);
    for (i in Iter.range(0, n - 1)) {
      var hx : Float = 0.0;
      for (j in Iter.range(0, n - 1)) {
        hx += SovereignTensor.get(state.H, i, j) * state.x[j];
      };
      innovation[i] := measurement[i] - hx;
    };

    // S = H × P × Hᵀ + R
    let HP = SovereignTensor.matmul(state.H, state.P);
    let HT = SovereignTensor.transpose(state.H);
    let HPHT = SovereignTensor.matmul(HP, HT);
    let S = SovereignTensor.add(HPHT, state.R);

    // K = P × Hᵀ × S⁻¹ (simplified for diagonal case)
    let PHT = SovereignTensor.matmul(state.P, HT);
    // Approximate S⁻¹ for diagonal dominance
    let K = SovereignTensor.zeros(n, n);
    for (i in Iter.range(0, n - 1)) {
      for (j in Iter.range(0, n - 1)) {
        let sVal = SovereignTensor.get(S, j, j);
        if (Float.abs(sVal) > SovereignTensor.EPSILON) {
          SovereignTensor.set(K, i, j, SovereignTensor.get(PHT, i, j) / sVal);
        };
      };
    };

    // x = x + K × innovation
    for (i in Iter.range(0, n - 1)) {
      var kInnovation : Float = 0.0;
      for (j in Iter.range(0, n - 1)) {
        kInnovation += SovereignTensor.get(K, i, j) * innovation[j];
      };
      state.x[i] += kInnovation;
    };

    // P = (I - K × H) × P
    let KH = SovereignTensor.matmul(K, state.H);
    let I = SovereignTensor.identity(n);
    let IminusKH = SovereignTensor.sub(I, KH);
    state.P := SovereignTensor.matmul(IminusKH, state.P);
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // EW COUNTERMEASURES — FREQUENCY HOPPING
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Generate frequency hopping sequence (sovereign PRNG — no foreign algorithm)
  public func generateHopSequence(
    baseFreq : Float,
    hopBandwidth : Float,
    numHops : Nat,
    seed : Nat
  ) : [Float] {
    let prng = SovereignTensor.prngInit(seed);
    Array.tabulate<Float>(numHops, func(_ : Nat) : Float {
      baseFreq + (SovereignTensor.prngNext(prng) - 0.5) * hopBandwidth
    })
  };

  /// Jammer detection — identifies abnormal energy in band
  public func detectJammer(
    spectrum : SovereignTensor.Vector,
    noiseFloor : Float,
    jamThreshold : Float
  ) : ?EWThreat {
    var maxPower : Float = 0.0;
    var maxIdx : Nat = 0;
    var aboveThreshold : Nat = 0;

    for (i in Iter.range(0, spectrum.size() - 1)) {
      if (spectrum[i] > maxPower) {
        maxPower := spectrum[i];
        maxIdx := i;
      };
      if (spectrum[i] > noiseFloor + jamThreshold) {
        aboveThreshold += 1;
      };
    };

    // Classify jammer type based on bandwidth
    let jamBandwidthRatio = Float.fromInt(aboveThreshold) / Float.fromInt(spectrum.size());

    if (maxPower > noiseFloor + jamThreshold) {
      let threatType = if (jamBandwidthRatio > 0.5) {
        #barrage_jammer
      } else if (jamBandwidthRatio > 0.1) {
        #sweep_jammer
      } else {
        #spot_jammer
      };

      ?{
        threatType;
        frequency = Float.fromInt(maxIdx); // Would be scaled to actual freq
        power = maxPower;
        bearing = 0.0; // Would require DF antenna
        timeToImpact = 0.0;
        recommendedAction = #frequency_hop;
      }
    } else {
      null
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // DIRECTION FINDING — SOVEREIGN PHASE INTERFEROMETRY
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Estimate angle of arrival using phase difference between antenna elements
  /// θ = arcsin(Δφ × λ / (2π × d))
  public func estimateAOA(
    phaseDifference : Float,
    wavelength : Float,
    antennaSpacing : Float
  ) : Float {
    let sinTheta = phaseDifference * wavelength / (6.2831853071795864769 * antennaSpacing);
    let clamped = Float.max(-1.0, Float.min(1.0, sinTheta));
    Float.arcsin(clamped) * 180.0 / 3.1415926535897932385 // Convert to degrees
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SPREAD SPECTRUM — ANTI-JAM COMMUNICATIONS
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Direct Sequence Spread Spectrum (DSSS) — spread signal with PN code
  public func dsssSpread(
    data : [Float],
    pnCode : [Float],
    chipRate : Nat
  ) : [Float] {
    let spreadLength = data.size() * chipRate;
    Array.tabulate<Float>(spreadLength, func(i : Nat) : Float {
      let dataIdx = i / chipRate;
      let chipIdx = i % pnCode.size();
      data[dataIdx] * pnCode[chipIdx]
    })
  };

  /// DSSS despread — correlate with known PN code to recover signal
  public func dsssDespread(
    received : [Float],
    pnCode : [Float],
    chipRate : Nat
  ) : [Float] {
    let dataLength = received.size() / chipRate;
    Array.tabulate<Float>(dataLength, func(i : Nat) : Float {
      var correlation : Float = 0.0;
      for (c in Iter.range(0, chipRate - 1)) {
        let chipIdx = (i * chipRate + c) % pnCode.size();
        correlation += received[i * chipRate + c] * pnCode[chipIdx];
      };
      correlation / Float.fromInt(chipRate)
    })
  };

  /// Generate maximal-length PN sequence (m-sequence) using LFSR
  /// No external crypto library — implemented from first principles
  public func generatePNSequence(length : Nat, seed : Nat) : [Float] {
    var lfsr : Nat = if (seed == 0) 1 else seed;
    Array.tabulate<Float>(length, func(_ : Nat) : Float {
      // Feedback polynomial: x⁶ + x⁵ + 1 (primitive for period 63)
      let bit = ((lfsr >> 5) ^ (lfsr >> 4)) & 1;
      lfsr := ((lfsr << 1) | bit) & 0x3F;
      if (lfsr & 1 == 1) 1.0 else -1.0
    })
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // WELCH PSD ESTIMATION — AVERAGED PERIODOGRAM (NO EXTERNAL LIBS)
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Welch's method for power spectral density estimation
  /// Segments signal, windows, DFTs, and averages for reduced variance
  public func welchPSD(
    signal : [Float],
    segmentLength : Nat,
    overlap : Nat
  ) : SovereignTensor.Vector {
    let n = signal.size();
    let step = segmentLength - overlap;
    var numSegments : Nat = 0;
    var pos : Nat = 0;

    // Count segments
    while (pos + segmentLength <= n) {
      numSegments += 1;
      pos += step;
    };

    if (numSegments == 0) return [];

    // Accumulate PSD from each segment
    let psd = Array.init<Float>(segmentLength, 0.0);
    pos := 0;

    for (_ in Iter.range(0, numSegments - 1)) {
      // Extract segment
      let segment = Array.tabulate<Float>(segmentLength, func(i : Nat) : Float {
        signal[pos + i]
      });

      // Apply Hanning window
      let windowed = Array.tabulate<Float>(segmentLength, func(i : Nat) : Float {
        let w = 0.5 * (1.0 - Float.cos(6.2831853071795864769 * Float.fromInt(i) / Float.fromInt(segmentLength - 1)));
        segment[i] * w
      });

      // Compute DFT power
      let power = SovereignTensor.powerSpectrum(windowed);
      for (k in Iter.range(0, segmentLength - 1)) {
        psd[k] += power[k];
      };
      pos += step;
    };

    // Average
    Array.tabulate<Float>(segmentLength, func(k : Nat) : Float {
      psd[k] / Float.fromInt(numSegments)
    })
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // CHIRP DETECTION — LINEAR FREQUENCY MODULATION DETECTION
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Chirp signal parameters
  public type ChirpParams = {
    startFreq : Float;
    endFreq : Float;
    duration : Float;
    sweepRate : Float;  // Hz/s
    detected : Bool;
    confidence : Float;
  };

  /// Detect linear chirp signals using instantaneous frequency analysis
  /// Computes frequency rate-of-change and tests for linearity
  public func detectChirp(
    samples : [Float],
    sampleRate : Float,
    minSweepRate : Float,
    maxSweepRate : Float
  ) : ?ChirpParams {
    let n = samples.size();
    if (n < 4) return null;

    // Estimate instantaneous frequency via zero-crossing intervals
    var crossings : [Nat] = [];
    for (i in Iter.range(1, n - 1)) {
      if ((samples[i - 1] >= 0.0 and samples[i] < 0.0) or
          (samples[i - 1] < 0.0 and samples[i] >= 0.0)) {
        crossings := Array.append(crossings, [i]);
      };
    };

    if (crossings.size() < 4) return null;

    // Compute instantaneous frequencies from crossing intervals
    var freqs : [Float] = [];
    for (i in Iter.range(1, crossings.size() - 1)) {
      let interval = Float.fromInt(crossings[i] - crossings[i - 1]);
      let freq = sampleRate / (2.0 * interval);
      freqs := Array.append(freqs, [freq]);
    };

    if (freqs.size() < 2) return null;

    // Linear regression on frequency vs time to find sweep rate
    let numFreqs = freqs.size();
    var sumX : Float = 0.0;
    var sumY : Float = 0.0;
    var sumXY : Float = 0.0;
    var sumXX : Float = 0.0;

    for (i in Iter.range(0, numFreqs - 1)) {
      let x = Float.fromInt(i);
      sumX += x;
      sumY += freqs[i];
      sumXY += x * freqs[i];
      sumXX += x * x;
    };

    let nf = Float.fromInt(numFreqs);
    let denom = nf * sumXX - sumX * sumX;
    if (Float.abs(denom) < 1.0e-10) return null;

    let slope = (nf * sumXY - sumX * sumY) / denom;
    let intercept = (sumY - slope * sumX) / nf;

    // Sweep rate in Hz/s
    let sweepRate = slope * sampleRate;

    // Check if within expected chirp parameters
    if (Float.abs(sweepRate) >= minSweepRate and Float.abs(sweepRate) <= maxSweepRate) {
      // Compute R² for confidence
      let meanY = sumY / nf;
      var ssRes : Float = 0.0;
      var ssTot : Float = 0.0;
      for (i in Iter.range(0, numFreqs - 1)) {
        let predicted = intercept + slope * Float.fromInt(i);
        let residual = freqs[i] - predicted;
        ssRes += residual * residual;
        let deviation = freqs[i] - meanY;
        ssTot += deviation * deviation;
      };
      let r2 = if (ssTot > 1.0e-10) 1.0 - ssRes / ssTot else 0.0;

      ?{
        startFreq = intercept;
        endFreq = intercept + slope * Float.fromInt(numFreqs);
        duration = Float.fromInt(n) / sampleRate;
        sweepRate;
        detected = r2 > 0.7;
        confidence = r2;
      }
    } else {
      null
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // TIME DIFFERENCE OF ARRIVAL (TDOA) — MULTI-SENSOR GEOLOCATION
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Sensor position in 2D (can extend to 3D)
  public type SensorPosition = {
    x : Float;
    y : Float;
  };

  /// TDOA measurement between sensor pairs
  public type TDOAMeasurement = {
    sensor1 : Nat;
    sensor2 : Nat;
    timeDifference : Float;  // seconds
  };

  /// Estimate emitter position from TDOA measurements (2D, 3+ sensors)
  /// Uses hyperbolic intersection (simplified iterative solution)
  public func tdoaLocalize(
    sensors : [SensorPosition],
    measurements : [TDOAMeasurement],
    speedOfPropagation : Float,
    maxIterations : Nat
  ) : SensorPosition {
    // Initial guess: centroid of sensors
    var estX : Float = 0.0;
    var estY : Float = 0.0;
    for (s in sensors.vals()) {
      estX += s.x;
      estY += s.y;
    };
    estX /= Float.fromInt(sensors.size());
    estY /= Float.fromInt(sensors.size());

    // Iterative refinement (Gauss-Newton style)
    for (_ in Iter.range(0, maxIterations - 1)) {
      var gradX : Float = 0.0;
      var gradY : Float = 0.0;

      for (m in measurements.vals()) {
        let s1 = sensors[m.sensor1];
        let s2 = sensors[m.sensor2];

        // Distance from estimate to each sensor
        let d1 = Float.sqrt((estX - s1.x) * (estX - s1.x) + (estY - s1.y) * (estY - s1.y));
        let d2 = Float.sqrt((estX - s2.x) * (estX - s2.x) + (estY - s2.y) * (estY - s2.y));

        // Expected time difference
        let expectedTD = (d1 - d2) / speedOfPropagation;
        let error = m.timeDifference - expectedTD;

        // Gradient of error w.r.t. position
        if (d1 > 1.0e-10 and d2 > 1.0e-10) {
          let dd1dx = (estX - s1.x) / d1;
          let dd1dy = (estY - s1.y) / d1;
          let dd2dx = (estX - s2.x) / d2;
          let dd2dy = (estY - s2.y) / d2;

          gradX += error * (dd1dx - dd2dx) / speedOfPropagation;
          gradY += error * (dd1dy - dd2dy) / speedOfPropagation;
        };
      };

      // Update estimate (step size)
      let stepSize : Float = 0.1;
      estX += stepSize * gradX;
      estY += stepSize * gradY;
    };

    { x = estX; y = estY }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // PULSE DESCRIPTOR WORD (PDW) EXTRACTION — RADAR ESM
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Pulse Descriptor Word — standard ESM output format
  public type PulseDescriptorWord = {
    timeOfArrival : Float;    // seconds
    pulseWidth : Float;       // seconds
    pulseAmplitude : Float;   // dBm
    frequency : Float;        // Hz
    phaseChange : Float;      // radians (intra-pulse)
    angleOfArrival : Float;   // degrees
    pulseRepetitionInterval : Float; // seconds between pulses
  };

  /// Extract pulse descriptor words from raw signal
  public func extractPDWs(
    signal : [Float],
    sampleRate : Float,
    threshold : Float
  ) : [PulseDescriptorWord] {
    let n = signal.size();
    var pdws : [PulseDescriptorWord] = [];
    var inPulse = false;
    var pulseStart : Nat = 0;
    var lastPulseStart : Float = 0.0;

    for (i in Iter.range(0, n - 1)) {
      let amplitude = Float.abs(signal[i]);

      if (not inPulse and amplitude > threshold) {
        // Rising edge — pulse start
        inPulse := true;
        pulseStart := i;
      } else if (inPulse and amplitude <= threshold) {
        // Falling edge — pulse end
        inPulse := false;
        let pulseEnd = i;
        let width = Float.fromInt(pulseEnd - pulseStart) / sampleRate;
        let toa = Float.fromInt(pulseStart) / sampleRate;

        // Compute peak amplitude within pulse
        var peakAmp : Float = 0.0;
        for (j in Iter.range(pulseStart, pulseEnd - 1)) {
          if (Float.abs(signal[j]) > peakAmp) {
            peakAmp := Float.abs(signal[j]);
          };
        };

        // Compute PRI from previous pulse
        let pri = if (lastPulseStart > 0.0) toa - lastPulseStart else 0.0;

        // Estimate frequency via zero crossings within pulse
        var crossCount : Nat = 0;
        for (j in Iter.range(pulseStart + 1, pulseEnd - 1)) {
          if ((signal[j-1] >= 0.0 and signal[j] < 0.0) or
              (signal[j-1] < 0.0 and signal[j] >= 0.0)) {
            crossCount += 1;
          };
        };
        let freq = Float.fromInt(crossCount) * sampleRate / (2.0 * Float.fromInt(pulseEnd - pulseStart));

        pdws := Array.append(pdws, [{
          timeOfArrival = toa;
          pulseWidth = width;
          pulseAmplitude = 20.0 * Float.log(peakAmp + 1.0e-20) / Float.log(10.0);
          frequency = freq;
          phaseChange = 0.0;
          angleOfArrival = 0.0;
          pulseRepetitionInterval = pri;
        }]);

        lastPulseStart := toa;
      };
    };
    pdws
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // PULSE DEINTERLEAVING — SEPARATE MULTIPLE RADAR EMITTERS
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Emitter track from deinterleaving
  public type EmitterTrack = {
    trackId : Nat;
    pdws : [PulseDescriptorWord];
    estimatedPRI : Float;
    estimatedFrequency : Float;
    classification : EmitterClass;
  };

  /// Deinterleave pulses into separate emitter tracks by PRI clustering
  public func deinterleave(
    pdws : [PulseDescriptorWord],
    priTolerance : Float,
    freqTolerance : Float
  ) : [EmitterTrack] {
    var tracks : [EmitterTrack] = [];
    var assigned : [var Bool] = Array.init<Bool>(pdws.size(), false);
    var nextTrackId : Nat = 0;

    for (i in Iter.range(0, pdws.size() - 1)) {
      if (not assigned[i]) {
        // Start new track with this PDW
        var trackPDWs : [PulseDescriptorWord] = [pdws[i]];
        assigned[i] := true;
        let refPRI = pdws[i].pulseRepetitionInterval;
        let refFreq = pdws[i].frequency;

        // Find all PDWs matching this track's PRI and frequency
        for (j in Iter.range(i + 1, pdws.size() - 1)) {
          if (not assigned[j]) {
            let priMatch = Float.abs(pdws[j].pulseRepetitionInterval - refPRI) < priTolerance;
            let freqMatch = Float.abs(pdws[j].frequency - refFreq) < freqTolerance;
            if (priMatch and freqMatch) {
              trackPDWs := Array.append(trackPDWs, [pdws[j]]);
              assigned[j] := true;
            };
          };
        };

        tracks := Array.append(tracks, [{
          trackId = nextTrackId;
          pdws = trackPDWs;
          estimatedPRI = refPRI;
          estimatedFrequency = refFreq;
          classification = #unknown;
        }]);
        nextTrackId += 1;
      };
    };
    tracks
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // ADAPTIVE NOTCH FILTER — NARROWBAND INTERFERENCE REMOVAL
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Adaptive notch filter state
  public type NotchFilterState = {
    var w0 : Float;   // Center frequency estimate (normalized)
    var a1 : Float;   // Filter coefficient
    var a2 : Float;   // Filter coefficient
    var x1 : Float;   // Delay line
    var x2 : Float;   // Delay line
    var y1 : Float;   // Output delay
    var y2 : Float;   // Output delay
    bandwidth : Float; // Notch bandwidth (normalized)
    mu : Float;       // Adaptation rate
  };

  /// Create adaptive notch filter
  public func createNotchFilter(initialFreq : Float, bandwidth : Float, mu : Float) : NotchFilterState {
    let r = 1.0 - 3.1415926535897932385 * bandwidth; // Pole radius
    {
      var w0 = initialFreq;
      var a1 = -2.0 * Float.cos(6.2831853071795864769 * initialFreq);
      var a2 = 1.0;
      var x1 = 0.0;
      var x2 = 0.0;
      var y1 = 0.0;
      var y2 = 0.0;
      bandwidth;
      mu;
    }
  };

  /// Process one sample through adaptive notch filter
  public func notchFilterSample(state : NotchFilterState, input : Float) : Float {
    // Second-order IIR notch: y[n] = x[n] + a1*x[n-1] + a2*x[n-2] - b1*y[n-1] - b2*y[n-2]
    let r = 1.0 - 3.1415926535897932385 * state.bandwidth;
    let b1 = r * state.a1;
    let b2 = r * r;

    let output = input + state.a1 * state.x1 + state.a2 * state.x2 - b1 * state.y1 - b2 * state.y2;

    // Adapt center frequency (LMS on output power)
    let gradient = -2.0 * output * (state.x1 - r * state.y1);
    state.a1 += state.mu * gradient;
    // Clamp a1 to valid range [-2, 2]
    state.a1 := Float.max(-2.0, Float.min(2.0, state.a1));

    // Update frequency estimate
    state.w0 := Float.arccos(-state.a1 / 2.0) / 6.2831853071795864769;

    // Shift delay lines
    state.x2 := state.x1;
    state.x1 := input;
    state.y2 := state.y1;
    state.y1 := output;

    output
  };

  /// Process entire signal through adaptive notch filter
  public func notchFilter(signal : [Float], initialFreq : Float, bandwidth : Float, mu : Float) : [Float] {
    let state = createNotchFilter(initialFreq, bandwidth, mu);
    Array.tabulate<Float>(signal.size(), func(i : Nat) : Float {
      notchFilterSample(state, signal[i])
    })
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SIGNAL-TO-NOISE RATIO ESTIMATION
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Estimate SNR in dB from signal samples
  public func estimateSNR(signal : [Float], noiseFloor : Float) : Float {
    var signalPower : Float = 0.0;
    for (s in signal.vals()) {
      signalPower += s * s;
    };
    signalPower /= Float.fromInt(signal.size());
    let noisePower = noiseFloor * noiseFloor;
    10.0 * Float.log(signalPower / noisePower) / Float.log(10.0)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // CROSS-CORRELATION — FOR TIME DELAY ESTIMATION
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Cross-correlation between two signals
  public func crossCorrelation(a : [Float], b : [Float], maxLag : Nat) : [Float] {
    let n = Nat.min(a.size(), b.size());
    Array.tabulate<Float>(2 * maxLag + 1, func(idx : Nat) : Float {
      let lag : Int = Int.abs(idx) - maxLag;
      var sum : Float = 0.0;
      for (i in Iter.range(0, n - 1)) {
        let j : Int = Int.abs(i) + lag;
        if (j >= 0 and j < n) {
          sum += a[i] * b[Int.abs(j)];
        };
      };
      sum / Float.fromInt(n)
    })
  };

  /// Find peak of cross-correlation (time delay estimate in samples)
  public func estimateTimeDelay(a : [Float], b : [Float], maxLag : Nat) : Int {
    let corr = crossCorrelation(a, b, maxLag);
    var maxVal : Float = corr[0];
    var maxIdx : Nat = 0;
    for (i in Iter.range(1, corr.size() - 1)) {
      if (corr[i] > maxVal) {
        maxVal := corr[i];
        maxIdx := i;
      };
    };
    Int.abs(maxIdx) - maxLag
  };
}
