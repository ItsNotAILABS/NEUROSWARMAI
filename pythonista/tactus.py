#!/usr/bin/env python3
"""
TACTUS — Somatic Intelligence Engine for Nova (Python Edition)
Nova AIS: TACTUS-NOVA — Multimodal Haptic × Motion × IoT × Sensor

Alpha Engines: ALPHA-009 (TACTUS) × ALPHA-005 (FABRICA)
Modalities: haptic, motion, sensor, IoT, accelerometer, gyroscope

Real Math:
- Proprioception: Ia afferent = k_s(l-l₀) + k_d(dl/dt)
- PID homeostasis: u = -Kp·e - Kd·(de/dt) - Ki·∫e·dt
- Turing morphogenesis: du/dt = Du∇²u + f(u,v), dv/dt = Dv∇²v + g(u,v)
- φ-setpoints: all homeostatic targets = φ⁻¹ = 0.618

Nova by FreddyCreates — runs on Pythonista iOS with sensor access
"""

import math
import random
import time
from typing import List, Dict, Tuple, Optional, Callable
from dataclasses import dataclass
from phi import PHI, PHI_INV, PHI_BEAT, fib

# ─── PROPRIOCEPTION MODEL ────────────────────────────────────────────────────
# Muscle spindle afferent: Ia = k_s(l-l₀) + k_d(dl/dt)
# Encodes position and velocity of limb

@dataclass
class ProprioceptorState:
    """State of a proprioceptor (muscle spindle)."""
    length: float = PHI_INV       # Current length (normalized)
    length_0: float = PHI_INV     # Rest length (φ⁻¹)
    velocity: float = 0.0         # Rate of change
    k_s: float = 1.0              # Static gain
    k_d: float = 0.5              # Dynamic gain
    
    def afferent(self) -> float:
        """
        Compute Ia afferent firing rate.
        Ia = k_s(l-l₀) + k_d(dl/dt)
        """
        position_term = self.k_s * (self.length - self.length_0)
        velocity_term = self.k_d * self.velocity
        return position_term + velocity_term
    
    def update(self, new_length: float, dt: float = 0.01):
        """Update proprioceptor state."""
        self.velocity = (new_length - self.length) / dt
        self.length = new_length

class ProprioceptionModel:
    """
    Multi-joint proprioception model.
    
    Tracks position and velocity of multiple degrees of freedom.
    """
    
    def __init__(self, n_joints: int = 6):
        self.joints = [ProprioceptorState() for _ in range(n_joints)]
        self.n_joints = n_joints
    
    def sense(self) -> List[float]:
        """Get afferent signals from all joints."""
        return [j.afferent() for j in self.joints]
    
    def update(self, positions: List[float], dt: float = 0.01):
        """Update all joint positions."""
        for i, (joint, pos) in enumerate(zip(self.joints, positions)):
            joint.update(pos, dt)
    
    def total_deviation(self) -> float:
        """Total deviation from rest position (homeostatic error)."""
        return sum(abs(j.length - j.length_0) for j in self.joints)

# ─── PID HOMEOSTASIS ─────────────────────────────────────────────────────────
# u = -Kp·e - Kd·(de/dt) - Ki·∫e·dt
# φ-setpoint: target = φ⁻¹ = 0.618

@dataclass
class PIDController:
    """
    PID controller with φ-tuned gains.
    
    Homeostatic control for maintaining φ⁻¹ setpoint.
    """
    Kp: float = PHI          # Proportional gain = φ
    Ki: float = PHI_INV      # Integral gain = φ⁻¹
    Kd: float = 1.0          # Derivative gain
    setpoint: float = PHI_INV  # Target = φ⁻¹
    
    # State
    integral: float = 0.0
    prev_error: float = 0.0
    
    def compute(self, current: float, dt: float = 0.01) -> float:
        """
        Compute control signal.
        u = -Kp·e - Ki·∫e·dt - Kd·(de/dt)
        """
        error = current - self.setpoint
        
        # Integral term (with anti-windup)
        self.integral += error * dt
        self.integral = max(-1.0, min(1.0, self.integral))  # Clamp
        
        # Derivative term
        derivative = (error - self.prev_error) / dt if dt > 0 else 0.0
        self.prev_error = error
        
        # PID output
        u = -(self.Kp * error + self.Ki * self.integral + self.Kd * derivative)
        
        return u
    
    def reset(self):
        """Reset controller state."""
        self.integral = 0.0
        self.prev_error = 0.0

class HomeostasisSystem:
    """
    Multi-variable homeostasis system.
    
    Maintains φ⁻¹ setpoint for multiple physiological variables.
    """
    
    def __init__(self, variables: List[str]):
        self.variables = variables
        self.controllers = {var: PIDController() for var in variables}
        self.states = {var: PHI_INV for var in variables}  # Start at setpoint
    
    def regulate(self, measurements: Dict[str, float], dt: float = 0.01) -> Dict[str, float]:
        """
        Compute regulation signals for all variables.
        """
        controls = {}
        for var in self.variables:
            if var in measurements:
                self.states[var] = measurements[var]
                controls[var] = self.controllers[var].compute(measurements[var], dt)
        return controls
    
    def homeostatic_error(self) -> float:
        """Total homeostatic error across all variables."""
        return sum(abs(s - PHI_INV) for s in self.states.values())
    
    def is_stable(self, threshold: float = 0.1) -> bool:
        """Check if system is stable (near setpoint)."""
        return self.homeostatic_error() < threshold * len(self.variables)

# ─── TURING MORPHOGENESIS ────────────────────────────────────────────────────
# Reaction-diffusion: du/dt = Du∇²u + f(u,v), dv/dt = Dv∇²v + g(u,v)
# Gray-Scott model: f = -uv² + F(1-u), g = uv² - (F+k)v

class TuringMorphogenesis:
    """
    Turing reaction-diffusion pattern generator.
    
    Uses Gray-Scott model with φ-tuned parameters.
    """
    
    def __init__(
        self,
        width: int = 64,
        height: int = 64,
        Du: float = 0.16,       # Activator diffusion
        Dv: float = 0.08,       # Inhibitor diffusion
        F: float = 0.055,       # Feed rate
        k: float = 0.062        # Kill rate
    ):
        self.width = width
        self.height = height
        self.Du = Du
        self.Dv = Dv
        self.F = F
        self.k = k
        
        # Initialize concentration fields
        self.u = [[1.0 for _ in range(width)] for _ in range(height)]
        self.v = [[0.0 for _ in range(width)] for _ in range(height)]
        
        # Seed initial perturbation (φ-sampled)
        cx, cy = width // 2, height // 2
        radius = int(width * PHI_INV * 0.2)
        for y in range(cy - radius, cy + radius):
            for x in range(cx - radius, cx + radius):
                if 0 <= x < width and 0 <= y < height:
                    if (x - cx)**2 + (y - cy)**2 < radius**2:
                        self.u[y][x] = 0.5
                        self.v[y][x] = 0.25 + random.uniform(-0.05, 0.05)
    
    def laplacian(self, field: List[List[float]], x: int, y: int) -> float:
        """Compute discrete Laplacian (∇²) at (x, y)."""
        w, h = self.width, self.height
        
        # 5-point stencil
        center = field[y][x]
        left = field[y][(x - 1) % w]
        right = field[y][(x + 1) % w]
        up = field[(y - 1) % h][x]
        down = field[(y + 1) % h][x]
        
        return left + right + up + down - 4 * center
    
    def step(self, dt: float = 1.0):
        """Advance one time step."""
        # Compute new concentrations
        new_u = [[0.0 for _ in range(self.width)] for _ in range(self.height)]
        new_v = [[0.0 for _ in range(self.width)] for _ in range(self.height)]
        
        for y in range(self.height):
            for x in range(self.width):
                u = self.u[y][x]
                v = self.v[y][x]
                
                # Reaction terms (Gray-Scott)
                uvv = u * v * v
                f_uv = -uvv + self.F * (1 - u)
                g_uv = uvv - (self.F + self.k) * v
                
                # Diffusion + reaction
                lapl_u = self.laplacian(self.u, x, y)
                lapl_v = self.laplacian(self.v, x, y)
                
                new_u[y][x] = u + dt * (self.Du * lapl_u + f_uv)
                new_v[y][x] = v + dt * (self.Dv * lapl_v + g_uv)
                
                # Clamp to [0, 1]
                new_u[y][x] = max(0, min(1, new_u[y][x]))
                new_v[y][x] = max(0, min(1, new_v[y][x]))
        
        self.u = new_u
        self.v = new_v
    
    def run(self, steps: int = 100, dt: float = 1.0):
        """Run simulation for multiple steps."""
        for _ in range(steps):
            self.step(dt)
    
    def pattern_entropy(self) -> float:
        """Compute pattern entropy (measure of complexity)."""
        from optica import compute_histogram, entropy
        flat = [self.v[y][x] for y in range(self.height) for x in range(self.width)]
        hist = compute_histogram(flat, bins=16)
        return entropy(hist)

# ─── MAIN SOMATIC ENGINE ─────────────────────────────────────────────────────
class TactusEngine:
    """
    TACTUS — The Somatic Intelligence Engine
    
    Combines proprioception, PID homeostasis, and Turing morphogenesis
    for embodied intelligence.
    """
    
    def __init__(self):
        self.proprioception = ProprioceptionModel(n_joints=6)
        self.homeostasis = HomeostasisSystem(['cpu', 'memory', 'latency', 'temperature'])
        self.morphogenesis = TuringMorphogenesis(width=32, height=32)
    
    def sense(self) -> Dict:
        """
        Sense current body state.
        
        In Pythonista, this can connect to real sensors.
        """
        import time
        start = time.time()
        
        # Try to get real sensor data (Pythonista-specific)
        accelerometer = self._get_accelerometer()
        gyroscope = self._get_gyroscope()
        
        # Proprioceptive signals
        proprio = self.proprioception.sense()
        
        elapsed = int((time.time() - start) * 1000)
        
        return {
            'action': 'sense',
            'accelerometer': accelerometer,
            'gyroscope': gyroscope,
            'proprioception': [round(p, 4) for p in proprio],
            'total_deviation': round(self.proprioception.total_deviation(), 4),
            'elapsed_ms': elapsed,
            'phi': PHI,
            'alpha': 'ALPHA-009',
        }
    
    def _get_accelerometer(self) -> Dict:
        """Get accelerometer data (Pythonista or synthetic)."""
        try:
            import motion
            motion.start_updates()
            time.sleep(0.1)
            data = motion.get_gravity()
            motion.stop_updates()
            return {'x': data[0], 'y': data[1], 'z': data[2], 'source': 'device'}
        except ImportError:
            # Synthetic data
            return {
                'x': random.gauss(0, 0.1),
                'y': random.gauss(0, 0.1),
                'z': random.gauss(-1.0, 0.1),  # Gravity
                'source': 'synthetic'
            }
    
    def _get_gyroscope(self) -> Dict:
        """Get gyroscope data (Pythonista or synthetic)."""
        try:
            import motion
            motion.start_updates()
            time.sleep(0.1)
            data = motion.get_attitude()
            motion.stop_updates()
            return {'roll': data[0], 'pitch': data[1], 'yaw': data[2], 'source': 'device'}
        except ImportError:
            # Synthetic data
            return {
                'roll': random.gauss(0, 0.1),
                'pitch': random.gauss(0, 0.1),
                'yaw': random.gauss(0, 0.1),
                'source': 'synthetic'
            }
    
    def regulate(self, measurements: Optional[Dict[str, float]] = None) -> Dict:
        """
        Compute homeostatic regulation signals.
        """
        import time
        start = time.time()
        
        # Default measurements (simulated system state)
        if measurements is None:
            measurements = {
                'cpu': 0.5 + random.gauss(0, 0.1),
                'memory': 0.6 + random.gauss(0, 0.05),
                'latency': 0.3 + random.gauss(0, 0.05),
                'temperature': PHI_INV + random.gauss(0, 0.02),
            }
        
        controls = self.homeostasis.regulate(measurements, dt=0.01)
        error = self.homeostasis.homeostatic_error()
        stable = self.homeostasis.is_stable()
        
        elapsed = int((time.time() - start) * 1000)
        
        return {
            'action': 'regulate',
            'measurements': {k: round(v, 4) for k, v in measurements.items()},
            'controls': {k: round(v, 4) for k, v in controls.items()},
            'homeostatic_error': round(error, 4),
            'is_stable': stable,
            'setpoint': PHI_INV,
            'pid_gains': {'Kp': PHI, 'Ki': PHI_INV, 'Kd': 1.0},
            'elapsed_ms': elapsed,
            'phi': PHI,
            'alpha': 'ALPHA-009',
        }
    
    def homeostasis_status(self) -> Dict:
        """Get current homeostasis status."""
        return {
            'action': 'homeostasis',
            'states': {k: round(v, 4) for k, v in self.homeostasis.states.items()},
            'error': round(self.homeostasis.homeostatic_error(), 4),
            'stable': self.homeostasis.is_stable(),
            'setpoint': PHI_INV,
            'phi': PHI,
            'alpha': 'ALPHA-009',
        }
    
    def body_state(self) -> Dict:
        """Get complete body state."""
        sense_data = self.sense()
        homeo_data = self.homeostasis_status()
        
        return {
            'action': 'body_state',
            'sensors': {
                'accelerometer': sense_data['accelerometer'],
                'gyroscope': sense_data['gyroscope'],
                'proprioception': sense_data['proprioception'],
            },
            'homeostasis': homeo_data,
            'deviation': sense_data['total_deviation'],
            'phi': PHI,
            'alpha': ['ALPHA-009', 'ALPHA-005'],
        }
    
    def morph(self, steps: int = 50) -> Dict:
        """
        Run Turing morphogenesis pattern generation.
        """
        import time
        start = time.time()
        
        self.morphogenesis.run(steps=steps)
        entropy = self.morphogenesis.pattern_entropy()
        
        # Sample pattern (8x8 downsampled)
        sample = []
        step_x = self.morphogenesis.width // 8
        step_y = self.morphogenesis.height // 8
        for y in range(0, self.morphogenesis.height, step_y):
            row = []
            for x in range(0, self.morphogenesis.width, step_x):
                row.append(round(self.morphogenesis.v[y][x], 2))
            sample.append(row)
        
        elapsed = int((time.time() - start) * 1000)
        
        return {
            'action': 'morph',
            'steps': steps,
            'dimensions': [self.morphogenesis.width, self.morphogenesis.height],
            'pattern_entropy': round(entropy, 4),
            'pattern_sample': sample[:8],  # 8x8 sample
            'parameters': {
                'Du': self.morphogenesis.Du,
                'Dv': self.morphogenesis.Dv,
                'F': self.morphogenesis.F,
                'k': self.morphogenesis.k,
            },
            'model': 'Gray-Scott reaction-diffusion',
            'elapsed_ms': elapsed,
            'phi': PHI,
            'alpha': 'ALPHA-005',
        }
    
    def status(self) -> Dict:
        """Return engine status."""
        return {
            'ais': 'TACTUS-NOVA',
            'brand': 'Nova',
            'platform': 'Pythonista iOS',
            'modalities': ['haptic', 'motion', 'sensor', 'iot'],
            'alpha': ['ALPHA-009 TACTUS', 'ALPHA-005 FABRICA'],
            'actions': ['sense', 'regulate', 'homeostasis', 'body_state', 'morph'],
            'math': {
                'proprioception': 'Ia = k_s(l-l₀) + k_d(dl/dt)',
                'pid': 'u = -Kp·e - Ki·∫e·dt - Kd·(de/dt)',
                'turing': 'du/dt = Du∇²u + f(u,v), dv/dt = Dv∇²v + g(u,v)',
            },
            'setpoint': PHI_INV,
            'n_joints': self.proprioception.n_joints,
            'phi': PHI,
            'phi_inv': PHI_INV,
        }

# ─── Global Engine Instance ──────────────────────────────────────────────────
_engine = None

def get_engine() -> TactusEngine:
    """Get or create the global TACTUS engine."""
    global _engine
    if _engine is None:
        _engine = TactusEngine()
    return _engine

def sense() -> Dict:
    """Quick access to sensing."""
    return get_engine().sense()

def regulate(measurements: Optional[Dict[str, float]] = None) -> Dict:
    """Quick access to regulation."""
    return get_engine().regulate(measurements)

# ─── Self-Test ───────────────────────────────────────────────────────────────
if __name__ == '__main__':
    print("╔════════════════════════════════════════════════════════════════╗")
    print("║           TACTUS — Somatic Engine — Self-Test                  ║")
    print("║           Nova by FreddyCreates — Pythonista iOS               ║")
    print("╚════════════════════════════════════════════════════════════════╝")
    print()
    
    engine = TactusEngine()
    
    # Status
    status = engine.status()
    print(f"AIS: {status['ais']}")
    print(f"Platform: {status['platform']}")
    print(f"Setpoint (φ⁻¹): {status['setpoint']}")
    print()
    
    # Test sense
    print("─── Testing SENSE ───")
    sense_result = engine.sense()
    print(f"Accelerometer: {sense_result['accelerometer']}")
    print(f"Gyroscope: {sense_result['gyroscope']}")
    print(f"Proprioception: {sense_result['proprioception'][:3]}...")
    print(f"Total deviation: {sense_result['total_deviation']}")
    print()
    
    # Test regulate
    print("─── Testing REGULATE ───")
    reg_result = engine.regulate()
    print(f"Measurements: {reg_result['measurements']}")
    print(f"Controls: {reg_result['controls']}")
    print(f"Homeostatic error: {reg_result['homeostatic_error']}")
    print(f"Stable: {reg_result['is_stable']}")
    print()
    
    # Test body state
    print("─── Testing BODY STATE ───")
    body = engine.body_state()
    print(f"Deviation: {body['deviation']}")
    print(f"Homeostasis stable: {body['homeostasis']['stable']}")
    print()
    
    # Test morphogenesis
    print("─── Testing MORPHOGENESIS ───")
    morph = engine.morph(steps=20)
    print(f"Steps: {morph['steps']}")
    print(f"Pattern entropy: {morph['pattern_entropy']}")
    print(f"Pattern sample (first row): {morph['pattern_sample'][0]}")
    print()
    
    print("✓ TACTUS engine ready on Pythonista iOS.")
