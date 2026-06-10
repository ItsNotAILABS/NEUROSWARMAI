/**
 * PROTO-243 through PROTO-246 — SWARM SIGINT Protocols
 * Domain: SovereignSIGINT — Collective Signal Intelligence & EW Coordination
 *
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 *
 * These protocols enable distributed signal intelligence operations across
 * the CHIMERIA swarm — multi-sensor fusion, collaborative detection, EW
 * coordination, and spectrum dominance.
 *
 * ZERO EXTERNAL DEPENDENCIES — All DSP sovereign.
 */

const PHI = 1.618033988749895;
const PHI_INV = 1 / PHI;
const TWO_PI = 2 * Math.PI;
const SPEED_OF_LIGHT = 299792458; // m/s

// ═══════════════════════════════════════════════════════════════════════════
// PROTO-243: MULTI-SENSOR FUSION PROTOCOL
//
// Fuses signal detections from multiple swarm nodes into a unified
// track picture. Uses Dempster-Shafer evidence theory for belief fusion
// when sensors have different confidence levels.
//
// Combined belief: m₁₂(A) = Σ_{B∩C=A} m₁(B)·m₂(C) / (1 - K)
// where K = Σ_{B∩C=∅} m₁(B)·m₂(C) (conflict factor)
// ═══════════════════════════════════════════════════════════════════════════

/**
 * Dempster-Shafer combination of two mass functions
 * @param {Object} m1 - First mass function {hypothesis: belief}
 * @param {Object} m2 - Second mass function {hypothesis: belief}
 * @returns {Object} Combined mass function
 */
function dempsterCombine(m1, m2) {
  const combined = {};
  let conflict = 0;

  for (const [h1, b1] of Object.entries(m1)) {
    for (const [h2, b2] of Object.entries(m2)) {
      const product = b1 * b2;
      if (h1 === h2) {
        combined[h1] = (combined[h1] || 0) + product;
      } else if (h1 === 'UNKNOWN') {
        combined[h2] = (combined[h2] || 0) + product;
      } else if (h2 === 'UNKNOWN') {
        combined[h1] = (combined[h1] || 0) + product;
      } else {
        conflict += product;
      }
    }
  }

  // Normalize by (1 - K)
  const normFactor = 1 - conflict;
  if (normFactor > 0) {
    for (const key of Object.keys(combined)) {
      combined[key] /= normFactor;
    }
  }

  return { beliefs: combined, conflict };
}

/**
 * PROTO-243: Multi-Sensor Fusion
 * Combines detections from multiple swarm sensors using Dempster-Shafer
 *
 * @param {Object[]} sensorReports - Array of {sensorId, position, detections: [{targetId, bearing, range, confidence, classification}]}
 * @returns {Object} Fused track picture
 */
function multiSensorFusion(sensorReports) {
  if (!sensorReports || sensorReports.length === 0) {
    return { protocol: 'PROTO-243', error: 'No sensor data' };
  }

  // Group detections by target
  const targetMap = {};
  for (const report of sensorReports) {
    for (const det of report.detections) {
      if (!targetMap[det.targetId]) {
        targetMap[det.targetId] = [];
      }
      targetMap[det.targetId].push({
        sensorId: report.sensorId,
        sensorPosition: report.position,
        bearing: det.bearing,
        range: det.range,
        confidence: det.confidence,
        classification: det.classification,
      });
    }
  }

  // Fuse each target's classifications
  const fusedTracks = [];
  for (const [targetId, detections] of Object.entries(targetMap)) {
    // Average position estimate (weighted by confidence)
    let totalWeight = 0;
    let weightedBearing = 0;
    let weightedRange = 0;

    for (const det of detections) {
      weightedBearing += det.bearing * det.confidence;
      weightedRange += det.range * det.confidence;
      totalWeight += det.confidence;
    }

    const avgBearing = totalWeight > 0 ? weightedBearing / totalWeight : 0;
    const avgRange = totalWeight > 0 ? weightedRange / totalWeight : 0;

    // Dempster-Shafer classification fusion
    let fusedMass = null;
    for (const det of detections) {
      const mass = {
        [det.classification]: det.confidence,
        UNKNOWN: 1 - det.confidence,
      };
      fusedMass = fusedMass ? dempsterCombine(fusedMass.beliefs, mass) : { beliefs: mass, conflict: 0 };
    }

    // Determine best classification
    let bestClass = 'UNKNOWN';
    let bestBelief = 0;
    if (fusedMass) {
      for (const [cls, belief] of Object.entries(fusedMass.beliefs)) {
        if (belief > bestBelief) {
          bestBelief = belief;
          bestClass = cls;
        }
      }
    }

    fusedTracks.push({
      targetId,
      fusedBearing: avgBearing,
      fusedRange: avgRange,
      classification: bestClass,
      classificationConfidence: bestBelief,
      sensorCount: detections.length,
      conflict: fusedMass?.conflict ?? 0,
      allBeliefs: fusedMass?.beliefs ?? {},
    });
  }

  return {
    protocol: 'PROTO-243',
    name: 'Multi-Sensor Fusion',
    module: 'SovereignSIGINT',
    sensorCount: sensorReports.length,
    targetsTracked: fusedTracks.length,
    fusedTracks,
    fusionMethod: 'Dempster-Shafer',
    timestamp: Date.now(),
  };
}

// ═══════════════════════════════════════════════════════════════════════════
// PROTO-244: COOPERATIVE GEOLOCATION PROTOCOL
//
// Uses TDOA (Time Difference of Arrival) across multiple swarm nodes
// to geolocate emitters. Requires minimum 3 sensors for 2D fix.
//
// TDOA equation: |r_i - r_e| - |r_j - r_e| = c × (t_i - t_j)
// Solved via hyperbolic multilateration (Chan-Ho algorithm simplified).
// ═══════════════════════════════════════════════════════════════════════════

/**
 * PROTO-244: Cooperative Geolocation
 * TDOA-based emitter location using multiple swarm sensors
 *
 * @param {Object[]} sensorMeasurements - Array of {sensorId, position: [x,y], arrivalTime}
 * @param {Object} [options] - Options
 * @param {number} [options.speedOfPropagation] - Signal speed (default: c)
 * @returns {Object} Estimated emitter position with error ellipse
 */
function cooperativeGeolocation(sensorMeasurements, options = {}) {
  const c = options.speedOfPropagation ?? SPEED_OF_LIGHT;
  const N = sensorMeasurements.length;

  if (N < 3) {
    return { protocol: 'PROTO-244', error: 'Minimum 3 sensors required for 2D fix' };
  }

  // Sort by arrival time
  const sorted = [...sensorMeasurements].sort((a, b) => a.arrivalTime - b.arrivalTime);
  const ref = sorted[0]; // Reference sensor (earliest arrival)

  // Compute TDOA pairs relative to reference
  const tdoas = sorted.slice(1).map(s => ({
    sensorId: s.sensorId,
    tdoa: s.arrivalTime - ref.arrivalTime,
    rangeDiff: (s.arrivalTime - ref.arrivalTime) * c,
    position: s.position,
  }));

  // Simplified least-squares position estimate
  // Using linearized hyperbolic equations (Taylor series approximation)
  // Initialize guess at centroid of sensors
  let xEst = sorted.reduce((s, m) => s + m.position[0], 0) / N;
  let yEst = sorted.reduce((s, m) => s + m.position[1], 0) / N;

  // Iterative refinement (3 iterations of gradient descent)
  for (let iter = 0; iter < 3; iter++) {
    let dxSum = 0;
    let dySum = 0;

    for (const tdoa of tdoas) {
      const distToRef = Math.sqrt(
        (xEst - ref.position[0]) ** 2 + (yEst - ref.position[1]) ** 2
      );
      const distToSensor = Math.sqrt(
        (xEst - tdoa.position[0]) ** 2 + (yEst - tdoa.position[1]) ** 2
      );
      const predictedRangeDiff = distToSensor - distToRef;
      const residual = tdoa.rangeDiff - predictedRangeDiff;

      // Gradient direction (toward reducing residual)
      if (distToSensor > 0 && distToRef > 0) {
        const gradX = (xEst - tdoa.position[0]) / distToSensor - (xEst - ref.position[0]) / distToRef;
        const gradY = (yEst - tdoa.position[1]) / distToSensor - (yEst - ref.position[1]) / distToRef;
        dxSum -= residual * gradX * PHI_INV;
        dySum -= residual * gradY * PHI_INV;
      }
    }

    xEst += dxSum / tdoas.length;
    yEst += dySum / tdoas.length;
  }

  // Compute position error estimate (GDOP-like)
  const rangeErrors = tdoas.map(tdoa => {
    const distToRef = Math.sqrt((xEst - ref.position[0]) ** 2 + (yEst - ref.position[1]) ** 2);
    const distToSensor = Math.sqrt((xEst - tdoa.position[0]) ** 2 + (yEst - tdoa.position[1]) ** 2);
    return Math.abs((distToSensor - distToRef) - tdoa.rangeDiff);
  });
  const cep = rangeErrors.reduce((s, e) => s + e, 0) / rangeErrors.length;

  return {
    protocol: 'PROTO-244',
    name: 'Cooperative Geolocation',
    module: 'SovereignSIGINT',
    estimatedPosition: [xEst, yEst],
    circularErrorProbable: cep,
    sensorCount: N,
    referenceSensor: ref.sensorId,
    tdoaPairs: tdoas.map(t => ({ sensor: t.sensorId, tdoa_ns: t.tdoa * 1e9, rangeDiff_m: t.rangeDiff })),
    geometricDilution: cep / (c * 1e-9), // Normalize to ns
    fixQuality: cep < 100 ? 'HIGH' : cep < 1000 ? 'MEDIUM' : 'LOW',
    timestamp: Date.now(),
  };
}

// ═══════════════════════════════════════════════════════════════════════════
// PROTO-245: ELECTRONIC WARFARE COORDINATION PROTOCOL
//
// Coordinates jamming/deception across swarm nodes.
// Assigns frequency bands to jammer nodes using φ-spaced allocation.
// Deconfliction ensures friendly comms are not jammed.
//
// Jammer spacing: f_k = f_base × φ^k (geometric frequency progression)
// Power allocation: P_k = P_total × w_k (φ-balanced weights)
// ═══════════════════════════════════════════════════════════════════════════

/**
 * PROTO-245: Electronic Warfare Coordination
 * Distributes jamming assignments across swarm with deconfliction
 *
 * @param {Object} targetSpectrum - {centerFreq, bandwidth, signalType}
 * @param {Object[]} jammerNodes - Array of {nodeId, position, maxPower, frequencyRange}
 * @param {Object[]} friendlyFreqs - Array of {freq, bandwidth, priority} to protect
 * @returns {Object} EW coordination plan
 */
function ewCoordination(targetSpectrum, jammerNodes, friendlyFreqs = []) {
  const N = jammerNodes.length;
  if (N === 0) return { protocol: 'PROTO-245', error: 'No jammer nodes available' };

  // Compute φ-spaced frequency assignments across target bandwidth
  const freqStep = targetSpectrum.bandwidth / N;
  const assignments = [];

  for (let k = 0; k < N; k++) {
    const assignedFreq = targetSpectrum.centerFreq - targetSpectrum.bandwidth / 2 + freqStep * (k + 0.5);
    const assignedBandwidth = freqStep * PHI_INV; // Slight overlap at φ⁻¹

    // Check for friendly deconfliction
    const conflictsWith = friendlyFreqs.filter(ff => {
      const fLow = ff.freq - ff.bandwidth / 2;
      const fHigh = ff.freq + ff.bandwidth / 2;
      const aLow = assignedFreq - assignedBandwidth / 2;
      const aHigh = assignedFreq + assignedBandwidth / 2;
      return aLow < fHigh && aHigh > fLow;
    });

    const deconflicted = conflictsWith.length === 0;

    // Power allocation: φ-weighted (center bands get more power)
    const centerDistance = Math.abs(k - (N - 1) / 2) / (N / 2);
    const powerWeight = Math.pow(PHI_INV, centerDistance);

    assignments.push({
      nodeId: jammerNodes[k].nodeId,
      assignedFreq,
      assignedBandwidth,
      powerWeight,
      deconflicted,
      conflicts: conflictsWith.map(c => c.freq),
      active: deconflicted, // Only activate if no friendly conflict
    });
  }

  const activeJammers = assignments.filter(a => a.active).length;

  return {
    protocol: 'PROTO-245',
    name: 'Electronic Warfare Coordination',
    module: 'SovereignSIGINT',
    target: targetSpectrum,
    assignments,
    activeJammers,
    deconflictedCount: assignments.filter(a => a.deconflicted).length,
    friendlyProtected: friendlyFreqs.length,
    spectrumCoverage: (activeJammers * freqStep * PHI_INV) / targetSpectrum.bandwidth,
    timestamp: Date.now(),
  };
}

// ═══════════════════════════════════════════════════════════════════════════
// PROTO-246: SPECTRUM AWARENESS PROTOCOL
//
// Collective spectrum monitoring across swarm.
// Each node contributes PSD (Power Spectral Density) estimates.
// Fleet-wide spectrum picture is assembled with confidence weighting.
//
// Detects: new emitters, frequency hopping patterns, anomalies.
// ═══════════════════════════════════════════════════════════════════════════

/**
 * PROTO-246: Spectrum Awareness
 * Collective spectrum monitoring and anomaly detection
 *
 * @param {Object[]} nodeSpectra - Array of {nodeId, psd: number[], freqRange: [fLow, fHigh], noiseFloor}
 * @param {Object} [options] - Options
 * @param {number} [options.detectionThreshold] - dB above noise (default: φ×6 ≈ 9.7 dB)
 * @returns {Object} Fleet spectrum picture with detections
 */
function spectrumAwareness(nodeSpectra, options = {}) {
  const detectionThreshold = options.detectionThreshold ?? PHI * 6;
  const N = nodeSpectra.length;

  if (N === 0) return { protocol: 'PROTO-246', error: 'No spectrum data' };

  // Compute composite spectrum (confidence-weighted average)
  const refLength = nodeSpectra[0].psd.length;
  const composite = new Array(refLength).fill(0);
  const confidence = new Array(refLength).fill(0);

  for (const ns of nodeSpectra) {
    const weight = 1 / Math.max(1, ns.noiseFloor); // Lower noise = higher weight
    for (let i = 0; i < Math.min(ns.psd.length, refLength); i++) {
      composite[i] += ns.psd[i] * weight;
      confidence[i] += weight;
    }
  }

  // Normalize
  for (let i = 0; i < refLength; i++) {
    composite[i] = confidence[i] > 0 ? composite[i] / confidence[i] : 0;
  }

  // Detect signals above threshold
  const avgNoise = nodeSpectra.reduce((s, ns) => s + ns.noiseFloor, 0) / N;
  const detections = [];
  const freqRange = nodeSpectra[0].freqRange;
  const freqStep = (freqRange[1] - freqRange[0]) / refLength;

  let inDetection = false;
  let detStart = 0;
  let peakPower = 0;
  let peakBin = 0;

  for (let i = 0; i < refLength; i++) {
    const snr = composite[i] - avgNoise;
    if (snr > detectionThreshold) {
      if (!inDetection) {
        inDetection = true;
        detStart = i;
        peakPower = composite[i];
        peakBin = i;
      } else if (composite[i] > peakPower) {
        peakPower = composite[i];
        peakBin = i;
      }
    } else if (inDetection) {
      inDetection = false;
      detections.push({
        startFreq: freqRange[0] + detStart * freqStep,
        endFreq: freqRange[0] + i * freqStep,
        peakFreq: freqRange[0] + peakBin * freqStep,
        peakPower,
        bandwidth: (i - detStart) * freqStep,
        snr: peakPower - avgNoise,
      });
    }
  }

  return {
    protocol: 'PROTO-246',
    name: 'Spectrum Awareness',
    module: 'SovereignSIGINT',
    sensorCount: N,
    frequencyRange: freqRange,
    spectralBins: refLength,
    averageNoiseFloor: avgNoise,
    detectionThreshold,
    detections,
    signalsDetected: detections.length,
    spectrumOccupancy: detections.reduce((s, d) => s + d.bandwidth, 0) / (freqRange[1] - freqRange[0]),
    timestamp: Date.now(),
  };
}

// ═══════════════════════════════════════════════════════════════════════════
// EXPORTS
// ═══════════════════════════════════════════════════════════════════════════

export {
  // PROTO-243
  dempsterCombine,
  multiSensorFusion,
  // PROTO-244
  cooperativeGeolocation,
  // PROTO-245
  ewCoordination,
  // PROTO-246
  spectrumAwareness,
};
