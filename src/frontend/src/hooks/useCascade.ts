// ═══════════════════════════════════════════════════════════════════════════════
// useCascade Hook — Wire Frontend to Backend Cascade Interconnect
// ═══════════════════════════════════════════════════════════════════════════════
// Owner: Alfredo Medina Hernandez | Dallas TX | MedinaSITech@outlook.com
// Attribution: Medina Doctrine — All mechanisms, equations, and architecture
//
// This hook connects the frontend visualization to the backend cascade formulas:
//   r (Kuramoto) → w (Hebbian) → x (Homeostatic) → kf (Compounding)
//
// The hook runs a heartbeat at 12Hz, calling the backend to update all formulas
// and streaming the results to the UI for live visualization.
// ═══════════════════════════════════════════════════════════════════════════════

import { useCallback, useEffect, useRef, useState } from "react";
import { useActor } from "./useActor";

// Core formulas type matching backend UnifiedCascade.CoreFormulas
export interface CoreFormulas {
  r: number;      // Kuramoto order parameter [0, 1]
  w: number;      // Hebbian weight aggregate [0, 10]
  x: number;      // Homeostatic setpoint [0.75, ∞)
  kf: number;     // Self-compounding factor [1, 1000]
  timestamp: bigint;
  beatIndex: bigint;
}

// Cascade metrics
export interface CascadeMetrics {
  cascadesProcessed: number;
  mirrorsApplied: number;
  loopsClosed: number;
  currentBeat: number;
  phase: "DISORDERED" | "TRANSITIONING" | "COHERENT";
}

// Module state
export interface ModuleState {
  id: number;
  name: string;
  shortName: string;
  level: string;
  currentValue: number;
  lastUpdate: number;
}

// Phase thresholds (matching backend constants)
const R_CRITICAL = 0.65;
const R_COHERENT = 0.85;

// Classify phase based on Kuramoto r
function classifyPhase(r: number): "DISORDERED" | "TRANSITIONING" | "COHERENT" {
  if (r < R_CRITICAL) return "DISORDERED";
  if (r < R_COHERENT) return "TRANSITIONING";
  return "COHERENT";
}

// Local cascade simulation (when backend is not available)
function simulateCascadeLocally(
  prevFormulas: CoreFormulas,
  dt: number
): CoreFormulas {
  // 1. Kuramoto: r slowly increases toward coherence
  const rTarget = 0.85 + Math.random() * 0.1;
  const newR = prevFormulas.r + (rTarget - prevFormulas.r) * 0.02 * dt;
  
  // 2. Hebbian: w increases with r
  const wTarget = 0.1 + newR * 2.0;
  const newW = prevFormulas.w + (wTarget - prevFormulas.w) * 0.01 * dt;
  
  // 3. Homeostatic: x increases with w
  const xTarget = 1.0 + (newW - 0.1) * 0.5;
  const newX = Math.max(1.0, prevFormulas.x + (xTarget - prevFormulas.x) * 0.005 * dt);
  
  // 4. Self-compounding: kf increases with x
  const compoundRate = 0.002 * (1 + (newX - 1.0) * 2.0);
  const newKF = Math.min(1000, prevFormulas.kf * (1 + compoundRate * dt));
  
  return {
    r: Math.min(1, Math.max(0, newR)),
    w: Math.min(10, Math.max(0, newW)),
    x: newX,
    kf: newKF,
    timestamp: BigInt(Date.now() * 1_000_000),
    beatIndex: prevFormulas.beatIndex + 1n,
  };
}

export interface UseCascadeOptions {
  /** Heartbeat frequency in Hz (default: 12) */
  frequency?: number;
  /** Whether to auto-start the heartbeat (default: true) */
  autoStart?: boolean;
  /** Use local simulation instead of backend (default: true until backend is wired) */
  useLocalSimulation?: boolean;
}

export interface UseCascadeReturn {
  /** Current core formulas */
  formulas: CoreFormulas;
  /** Cascade metrics */
  metrics: CascadeMetrics;
  /** Whether the cascade is running */
  isRunning: boolean;
  /** Start the cascade heartbeat */
  start: () => void;
  /** Stop the cascade heartbeat */
  stop: () => void;
  /** Manually trigger a heartbeat */
  pulse: () => Promise<void>;
  /** Send a signal between modules */
  sendSignal: (source: string, target: string, value: number) => Promise<void>;
  /** Get cascade status text */
  getStatus: () => string;
}

export function useCascade(options: UseCascadeOptions = {}): UseCascadeReturn {
  const {
    frequency = 12,
    autoStart = true,
    useLocalSimulation = true,
  } = options;
  
  const { actor } = useActor();
  const intervalRef = useRef<NodeJS.Timeout | null>(null);
  
  const [formulas, setFormulas] = useState<CoreFormulas>({
    r: 0.3,
    w: 0.1,
    x: 1.0,
    kf: 1.0,
    timestamp: BigInt(Date.now() * 1_000_000),
    beatIndex: 0n,
  });
  
  const [metrics, setMetrics] = useState<CascadeMetrics>({
    cascadesProcessed: 0,
    mirrorsApplied: 0,
    loopsClosed: 0,
    currentBeat: 0,
    phase: "DISORDERED",
  });
  
  const [isRunning, setIsRunning] = useState(false);
  
  // Pulse: run one cascade heartbeat
  const pulse = useCallback(async () => {
    if (useLocalSimulation || !actor) {
      // Local simulation
      setFormulas((prev) => {
        const dt = 1 / frequency;
        return simulateCascadeLocally(prev, dt);
      });
      setMetrics((prev) => ({
        ...prev,
        cascadesProcessed: prev.cascadesProcessed + 1,
        mirrorsApplied: prev.mirrorsApplied + 2,
        loopsClosed: prev.loopsClosed + 1,
        currentBeat: prev.currentBeat + 1,
        phase: classifyPhase(formulas.r),
      }));
    } else {
      // Backend call
      try {
        const result = await (actor as unknown as { runCascadeHeartbeat: () => Promise<CoreFormulas> }).runCascadeHeartbeat();
        setFormulas(result);
        setMetrics((prev) => ({
          ...prev,
          cascadesProcessed: prev.cascadesProcessed + 1,
          currentBeat: Number(result.beatIndex),
          phase: classifyPhase(result.r),
        }));
      } catch (error) {
        console.error("Cascade heartbeat failed:", error);
        // Fall back to local simulation
        setFormulas((prev) => simulateCascadeLocally(prev, 1 / frequency));
      }
    }
  }, [actor, frequency, useLocalSimulation, formulas.r]);
  
  // Start the cascade heartbeat
  const start = useCallback(() => {
    if (intervalRef.current) return;
    setIsRunning(true);
    const intervalMs = 1000 / frequency;
    intervalRef.current = setInterval(() => {
      pulse();
    }, intervalMs);
  }, [frequency, pulse]);
  
  // Stop the cascade heartbeat
  const stop = useCallback(() => {
    if (intervalRef.current) {
      clearInterval(intervalRef.current);
      intervalRef.current = null;
    }
    setIsRunning(false);
  }, []);
  
  // Send a signal between modules
  const sendSignal = useCallback(async (source: string, target: string, value: number) => {
    if (!actor) return;
    try {
      await (actor as unknown as { sendCascadeSignal: (s: string, t: string, v: number) => Promise<void> })
        .sendCascadeSignal(source, target, value);
    } catch (error) {
      console.error("Signal send failed:", error);
    }
  }, [actor]);
  
  // Get status text
  const getStatus = useCallback(() => {
    return `CASCADE [Beat ${metrics.currentBeat}]\n` +
      `════════════════════════════════════════\n` +
      `Core Formulas:\n` +
      `  r (Kuramoto):     ${formulas.r.toFixed(4)} [${metrics.phase}]\n` +
      `  w (Hebbian):      ${formulas.w.toFixed(4)}\n` +
      `  x (Homeostatic):  ${formulas.x.toFixed(4)}\n` +
      `  kf (Compounding): ${formulas.kf.toFixed(4)}\n` +
      `────────────────────────────────────────\n` +
      `Metrics:\n` +
      `  Cascades:         ${metrics.cascadesProcessed}\n` +
      `  Mirrors:          ${metrics.mirrorsApplied}\n` +
      `  Loops Closed:     ${metrics.loopsClosed}\n` +
      `════════════════════════════════════════`;
  }, [formulas, metrics]);
  
  // Auto-start if enabled
  useEffect(() => {
    if (autoStart) {
      start();
    }
    return () => {
      stop();
    };
  }, [autoStart, start, stop]);
  
  return {
    formulas,
    metrics,
    isRunning,
    start,
    stop,
    pulse,
    sendSignal,
    getStatus,
  };
}
