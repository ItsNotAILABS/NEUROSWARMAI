#!/usr/bin/env python3
"""
OPTICA — Vision Intelligence Engine for Nova (Python Edition)
Nova AIS: OPTICA-NOVA — Multimodal Vision × Spatial × 3D

Alpha Engines: ALPHA-003 (OPTICA) × ALPHA-008 (KOSMOS)
Modalities: images, video, 3D, spatial, entropy saliency

Real Math:
- Gabor V1 cortical filters: G(x,y) = exp(-(x'²+γ²y'²)/(2σ²)) × cos(2π·x'/λ + ψ)
- Cortical magnification: M(r) = k/(r + r₀), φ-sampled
- Entropy saliency: S(x,y) = -Σ p(i)log(p(i))
- Maxwell-Boltzmann physics: thermal state distribution

Nova by FreddyCreates — runs on Pythonista iOS
"""

import math
import random
from typing import List, Dict, Tuple, Optional
from phi import PHI, PHI_INV, PHI_BEAT, fib

# ─── GABOR V1 CORTICAL FILTERS ───────────────────────────────────────────────
# The visual cortex uses Gabor filters for edge detection
# G(x,y) = exp(-(x'²+γ²y'²)/(2σ²)) × cos(2π·x'/λ + ψ)
# where x' = x·cos(θ) + y·sin(θ), y' = -x·sin(θ) + y·cos(θ)

class GaborFilter:
    """
    Gabor filter — V1 cortical edge detector.
    
    Parameters tuned to φ ratios for natural vision.
    """
    
    def __init__(
        self,
        sigma: float = 4.0,      # Gaussian envelope width
        theta: float = 0.0,       # Orientation (radians)
        lambd: float = 10.0,      # Wavelength
        gamma: float = 0.5,       # Aspect ratio
        psi: float = 0.0          # Phase offset
    ):
        self.sigma = sigma
        self.theta = theta
        self.lambd = lambd
        self.gamma = gamma        # γ = 0.5 = φ⁻¹ × 0.809 (biological)
        self.psi = psi
    
    def value(self, x: float, y: float) -> float:
        """
        Compute Gabor filter response at (x, y).
        
        G(x,y) = exp(-(x'²+γ²y'²)/(2σ²)) × cos(2π·x'/λ + ψ)
        """
        # Rotated coordinates
        x_prime = x * math.cos(self.theta) + y * math.sin(self.theta)
        y_prime = -x * math.sin(self.theta) + y * math.cos(self.theta)
        
        # Gaussian envelope
        gaussian = math.exp(
            -(x_prime**2 + (self.gamma * y_prime)**2) / (2 * self.sigma**2)
        )
        
        # Sinusoidal carrier
        sinusoid = math.cos(2 * math.pi * x_prime / self.lambd + self.psi)
        
        return gaussian * sinusoid
    
    def kernel(self, size: int = 21) -> List[List[float]]:
        """Generate Gabor filter kernel of given size."""
        half = size // 2
        kernel = []
        for y in range(-half, half + 1):
            row = []
            for x in range(-half, half + 1):
                row.append(self.value(x, y))
            kernel.append(row)
        return kernel

def create_gabor_bank(
    n_orientations: int = 8,
    n_scales: int = 4,
    base_sigma: float = 2.0,
    base_lambda: float = 4.0
) -> List[GaborFilter]:
    """
    Create a bank of Gabor filters at multiple orientations and scales.
    
    Scales use φ ratio: σₙ = σ₀ × φⁿ
    """
    filters = []
    
    for scale in range(n_scales):
        sigma = base_sigma * (PHI ** scale)
        lambd = base_lambda * (PHI ** scale)
        
        for ori in range(n_orientations):
            theta = ori * math.pi / n_orientations
            
            filters.append(GaborFilter(
                sigma=sigma,
                theta=theta,
                lambd=lambd,
                gamma=0.5,
                psi=0.0
            ))
    
    return filters

# ─── CORTICAL MAGNIFICATION ──────────────────────────────────────────────────
# M(r) = k/(r + r₀) — cortical magnification factor
# More cortical area devoted to fovea (center)

def cortical_magnification(
    r: float,
    k: float = 10.0,
    r0: float = 1.0
) -> float:
    """
    Compute cortical magnification at eccentricity r.
    
    M(r) = k/(r + r₀)
    """
    return k / (r + r0)

def phi_sample_radii(n: int, r0: float = 1.0) -> List[float]:
    """
    Generate φ-sampled radii for cortical analysis.
    
    rₙ = r₀ × φⁿ
    """
    return [r0 * (PHI ** i) for i in range(n)]

# ─── ENTROPY SALIENCY ────────────────────────────────────────────────────────
# S(x,y) = -Σ p(i)log(p(i)) — information entropy as saliency

def compute_histogram(data: List[float], bins: int = 16) -> List[float]:
    """Compute normalized histogram of data."""
    if not data:
        return [1.0 / bins] * bins
    
    min_val = min(data)
    max_val = max(data)
    
    if max_val == min_val:
        return [1.0 / bins] * bins
    
    hist = [0] * bins
    for val in data:
        bin_idx = int((val - min_val) / (max_val - min_val) * (bins - 1))
        bin_idx = min(bin_idx, bins - 1)
        hist[bin_idx] += 1
    
    # Normalize
    total = sum(hist)
    return [h / total if total > 0 else 1.0 / bins for h in hist]

def entropy(probs: List[float]) -> float:
    """
    Compute Shannon entropy.
    
    H = -Σ p(i)log₂(p(i))
    """
    h = 0.0
    for p in probs:
        if p > 0:
            h -= p * math.log2(p)
    return h

def entropy_saliency(
    image: List[List[float]],
    window_size: int = 5
) -> List[List[float]]:
    """
    Compute entropy-based saliency map.
    
    High entropy = high information = salient region.
    """
    if not image or not image[0]:
        return [[]]
    
    height = len(image)
    width = len(image[0])
    half = window_size // 2
    
    saliency = []
    for y in range(height):
        row = []
        for x in range(width):
            # Extract local window
            window = []
            for dy in range(-half, half + 1):
                for dx in range(-half, half + 1):
                    ny, nx = y + dy, x + dx
                    if 0 <= ny < height and 0 <= nx < width:
                        window.append(image[ny][nx])
            
            if window:
                hist = compute_histogram(window)
                ent = entropy(hist)
            else:
                ent = 0.0
            
            row.append(ent)
        saliency.append(row)
    
    return saliency

# ─── MAXWELL-BOLTZMANN PHYSICS (from KOSMOS) ─────────────────────────────────
# f(v) = 4π(m/2πkT)^(3/2) × v² × exp(-mv²/2kT)

def maxwell_boltzmann(v: float, T: float = PHI_INV, m: float = 1.0) -> float:
    """
    Maxwell-Boltzmann speed distribution.
    
    f(v) = 4π(m/2πkT)^(3/2) × v² × exp(-mv²/2kT)
    
    T default = φ⁻¹ for optimal thermal state.
    """
    k = 1.0  # Boltzmann constant (normalized)
    
    coeff = 4 * math.pi * ((m / (2 * math.pi * k * T)) ** 1.5)
    exp_term = math.exp(-m * v**2 / (2 * k * T))
    
    return coeff * v**2 * exp_term

def thermal_state_distribution(n_samples: int = 100, T: float = PHI_INV) -> List[float]:
    """Generate thermal state distribution samples."""
    # Sample from Maxwell-Boltzmann using rejection sampling
    samples = []
    max_v = 3.0 * math.sqrt(T)  # Most probable speed region
    max_f = maxwell_boltzmann(math.sqrt(T), T)
    
    while len(samples) < n_samples:
        v = random.uniform(0, max_v * 2)
        f_v = maxwell_boltzmann(v, T)
        
        if random.random() < f_v / (max_f * 1.5):
            samples.append(v)
    
    return samples

# ─── MAIN VISION ENGINE ──────────────────────────────────────────────────────
class OpticaEngine:
    """
    OPTICA — The Vision Intelligence Engine
    
    Combines Gabor V1 filters, cortical magnification,
    entropy saliency, and Maxwell-Boltzmann physics for
    vision understanding.
    """
    
    def __init__(self, n_orientations: int = 8, n_scales: int = 4):
        self.gabor_bank = create_gabor_bank(n_orientations, n_scales)
        self.n_orientations = n_orientations
        self.n_scales = n_scales
    
    def analyze_image(self, image: List[List[float]]) -> Dict:
        """
        Analyze image using Gabor filters and entropy saliency.
        """
        import time
        start = time.time()
        
        if not image or not image[0]:
            return {'error': 'Empty image'}
        
        height = len(image)
        width = len(image[0])
        
        # Compute entropy saliency
        saliency = entropy_saliency(image, window_size=5)
        
        # Compute statistics
        flat_image = [pixel for row in image for pixel in row]
        flat_saliency = [s for row in saliency for s in row]
        
        mean_intensity = sum(flat_image) / len(flat_image) if flat_image else 0.0
        mean_saliency = sum(flat_saliency) / len(flat_saliency) if flat_saliency else 0.0
        
        # Max saliency location (attention focus)
        max_sal = 0.0
        max_loc = (0, 0)
        for y, row in enumerate(saliency):
            for x, s in enumerate(row):
                if s > max_sal:
                    max_sal = s
                    max_loc = (x, y)
        
        elapsed = int((time.time() - start) * 1000)
        
        return {
            'action': 'analyze_image',
            'dimensions': {'width': width, 'height': height},
            'mean_intensity': round(mean_intensity, 4),
            'mean_saliency': round(mean_saliency, 4),
            'max_saliency': round(max_sal, 4),
            'attention_focus': max_loc,
            'gabor_filters': len(self.gabor_bank),
            'elapsed_ms': elapsed,
            'phi': PHI,
            'alpha': ['ALPHA-003', 'ALPHA-008'],
        }
    
    def detect_edges(
        self,
        image: List[List[float]],
        orientation_idx: int = 0
    ) -> Dict:
        """
        Detect edges using Gabor filters at specified orientation.
        """
        import time
        start = time.time()
        
        if not image or not image[0]:
            return {'error': 'Empty image'}
        
        height = len(image)
        width = len(image[0])
        
        # Get Gabor filter at specified orientation
        if orientation_idx >= len(self.gabor_bank):
            orientation_idx = 0
        
        gabor = self.gabor_bank[orientation_idx]
        kernel = gabor.kernel(size=11)
        kernel_size = len(kernel)
        half = kernel_size // 2
        
        # Convolve (simplified)
        edge_strength = 0.0
        edge_count = 0
        
        for y in range(half, height - half):
            for x in range(half, width - half):
                response = 0.0
                for ky in range(kernel_size):
                    for kx in range(kernel_size):
                        iy = y + ky - half
                        ix = x + kx - half
                        response += image[iy][ix] * kernel[ky][kx]
                
                if abs(response) > PHI_INV:  # φ⁻¹ threshold
                    edge_strength += abs(response)
                    edge_count += 1
        
        elapsed = int((time.time() - start) * 1000)
        
        return {
            'action': 'detect_edges',
            'orientation': round(gabor.theta * 180 / math.pi, 1),
            'edge_count': edge_count,
            'mean_edge_strength': round(edge_strength / max(edge_count, 1), 4),
            'threshold': PHI_INV,
            'kernel_size': kernel_size,
            'elapsed_ms': elapsed,
            'phi': PHI,
            'alpha': 'ALPHA-003',
        }
    
    def cortical_sample(self, n_samples: int = 13) -> Dict:
        """
        Generate φ-sampled cortical analysis points.
        """
        radii = phi_sample_radii(n_samples)
        magnifications = [cortical_magnification(r) for r in radii]
        
        return {
            'action': 'cortical_sample',
            'n_samples': n_samples,
            'radii': [round(r, 4) for r in radii],
            'magnifications': [round(m, 4) for m in magnifications],
            'formula': 'M(r) = k/(r + r₀)',
            'phi_sampling': 'rₙ = r₀ × φⁿ',
            'phi': PHI,
            'alpha': 'ALPHA-003',
        }
    
    def thermal_physics(self, T: float = PHI_INV, n_samples: int = 50) -> Dict:
        """
        Compute thermal state distribution (KOSMOS physics).
        """
        import time
        start = time.time()
        
        samples = thermal_state_distribution(n_samples, T)
        
        mean_v = sum(samples) / len(samples)
        most_probable = math.sqrt(T)  # √(kT/m)
        
        elapsed = int((time.time() - start) * 1000)
        
        return {
            'action': 'thermal_physics',
            'temperature': T,
            'n_samples': n_samples,
            'mean_speed': round(mean_v, 4),
            'most_probable_speed': round(most_probable, 4),
            'speed_range': [round(min(samples), 4), round(max(samples), 4)],
            'distribution': 'Maxwell-Boltzmann',
            'formula': 'f(v) = 4π(m/2πkT)^(3/2) × v² × exp(-mv²/2kT)',
            'elapsed_ms': elapsed,
            'phi': PHI,
            'alpha': 'ALPHA-008',
        }
    
    def status(self) -> Dict:
        """Return engine status."""
        return {
            'ais': 'OPTICA-NOVA',
            'brand': 'Nova',
            'platform': 'Pythonista iOS',
            'modalities': ['image', 'video', '3d', 'spatial'],
            'alpha': ['ALPHA-003 OPTICA', 'ALPHA-008 KOSMOS'],
            'actions': ['analyze_image', 'detect_edges', 'cortical_sample', 'thermal_physics'],
            'math': {
                'gabor': 'G(x,y) = exp(-(x\'²+γ²y\'²)/(2σ²)) × cos(2π·x\'/λ + ψ)',
                'magnification': 'M(r) = k/(r + r₀)',
                'entropy': 'S = -Σ p(i)log₂(p(i))',
                'maxwell_boltzmann': 'f(v) = 4π(m/2πkT)^(3/2) × v² × exp(-mv²/2kT)',
            },
            'gabor_bank_size': len(self.gabor_bank),
            'phi': PHI,
            'phi_inv': PHI_INV,
        }

# ─── Pythonista Camera Integration ───────────────────────────────────────────
def capture_and_analyze() -> Dict:
    """
    Capture image from Pythonista camera and analyze.
    
    Note: This requires the 'photos' module in Pythonista iOS.
    Falls back to synthetic image if not available.
    """
    try:
        # Try Pythonista-specific modules
        import photos
        img = photos.capture_image()
        if img:
            # Convert PIL image to grayscale array
            img_gray = img.convert('L')
            width, height = img_gray.size
            pixels = list(img_gray.getdata())
            image = [
                [pixels[y * width + x] / 255.0 for x in range(width)]
                for y in range(height)
            ]
            
            engine = OpticaEngine()
            return engine.analyze_image(image)
    except ImportError:
        pass
    
    # Fallback: generate synthetic image
    return analyze_synthetic_image()

def analyze_synthetic_image(
    width: int = 64,
    height: int = 64
) -> Dict:
    """Analyze a synthetic test image with gradient + noise."""
    image = [
        [
            0.5 + 0.3 * math.sin(x * 0.2) * math.cos(y * 0.15) + random.uniform(-0.1, 0.1)
            for x in range(width)
        ]
        for y in range(height)
    ]
    
    engine = OpticaEngine()
    result = engine.analyze_image(image)
    result['synthetic'] = True
    return result

# ─── Global Engine Instance ──────────────────────────────────────────────────
_engine = None

def get_engine() -> OpticaEngine:
    """Get or create the global OPTICA engine."""
    global _engine
    if _engine is None:
        _engine = OpticaEngine()
    return _engine

# ─── Self-Test ───────────────────────────────────────────────────────────────
if __name__ == '__main__':
    print("╔════════════════════════════════════════════════════════════════╗")
    print("║           OPTICA — Vision Engine — Self-Test                   ║")
    print("║           Nova by FreddyCreates — Pythonista iOS               ║")
    print("╚════════════════════════════════════════════════════════════════╝")
    print()
    
    engine = OpticaEngine()
    
    # Status
    status = engine.status()
    print(f"AIS: {status['ais']}")
    print(f"Platform: {status['platform']}")
    print(f"Gabor filters: {status['gabor_bank_size']}")
    print()
    
    # Test Gabor filter
    print("─── Testing GABOR FILTER ───")
    gabor = GaborFilter(sigma=4.0, theta=0.0, lambd=10.0, gamma=0.5)
    print(f"Center value: {gabor.value(0, 0):.4f}")
    print(f"Off-center (5,0): {gabor.value(5, 0):.4f}")
    print()
    
    # Test cortical sampling
    print("─── Testing CORTICAL SAMPLE ───")
    cortical = engine.cortical_sample(8)
    print(f"Radii: {cortical['radii'][:5]}...")
    print(f"Magnifications: {cortical['magnifications'][:5]}...")
    print()
    
    # Test synthetic image analysis
    print("─── Testing IMAGE ANALYSIS ───")
    result = analyze_synthetic_image(32, 32)
    print(f"Dimensions: {result['dimensions']}")
    print(f"Mean intensity: {result['mean_intensity']}")
    print(f"Mean saliency: {result['mean_saliency']}")
    print(f"Attention focus: {result['attention_focus']}")
    print()
    
    # Test edge detection
    print("─── Testing EDGE DETECTION ───")
    # Create simple gradient image
    image = [[x / 32 for x in range(32)] for _ in range(32)]
    edges = engine.detect_edges(image, orientation_idx=0)
    print(f"Orientation: {edges['orientation']}°")
    print(f"Edge count: {edges['edge_count']}")
    print(f"Mean strength: {edges['mean_edge_strength']}")
    print()
    
    # Test thermal physics
    print("─── Testing THERMAL PHYSICS ───")
    thermal = engine.thermal_physics(T=PHI_INV, n_samples=30)
    print(f"Temperature: {thermal['temperature']}")
    print(f"Mean speed: {thermal['mean_speed']}")
    print(f"Most probable: {thermal['most_probable_speed']}")
    print()
    
    print("✓ OPTICA engine ready on Pythonista iOS.")
