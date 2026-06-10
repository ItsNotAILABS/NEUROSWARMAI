#!/usr/bin/env python3
"""
Data Tools — 4 Data Science Tools for Nova
Nova by FreddyCreates — Pythonista iOS

Tools:
- ANLD: Analyze — Data analysis
- TRFD: Transform — Data transformation
- VISD: Visualize — Data visualization
- PRED: Predict — Data prediction
"""

import math
import random
from typing import Dict, List, Optional, Union
from collections import Counter
from .base import NovaTool, PHI, PHI_INV, fib


# ─── ANALYZE TOOL ────────────────────────────────────────────────────────────
class AnalyzeTool(NovaTool):
    """
    ANLD — Data Analysis Tool
    
    Analyzes data with statistical methods and φ-weighted metrics.
    """
    
    QUAD = 'ANLD'
    NAME = 'Analyze Data'
    DESCRIPTION = 'Statistical data analysis with φ-weighted metrics'
    CATEGORY = 'data'
    FIB_INDEX = 17
    MODALITIES = ['structured', 'numerical', 'tabular']
    ALPHA_ENGINES = ['ALPHA-007 VERITAS', 'ALPHA-006 PROPHETA']
    
    def _run(self, data: Optional[List[float]] = None,
             n_samples: int = 100, **kwargs) -> Dict:
        """
        Analyze numerical data.
        
        Args:
            data: List of numerical values (generates synthetic if None)
            n_samples: Number of samples for synthetic data
        
        Returns:
            Dict with statistical analysis
        """
        # Generate synthetic data if none provided
        if data is None:
            # Generate φ-distributed data
            data = [random.gauss(PHI, PHI_INV) for _ in range(n_samples)]
        
        n = len(data)
        if n == 0:
            return {
                'error': 'No data provided',
                'confidence': 0.0,
                'completeness': 0.0,
            }
        
        # Basic statistics
        mean = sum(data) / n
        variance = sum((x - mean) ** 2 for x in data) / n
        std = math.sqrt(variance)
        
        sorted_data = sorted(data)
        median = sorted_data[n // 2] if n % 2 else (sorted_data[n // 2 - 1] + sorted_data[n // 2]) / 2
        
        min_val = min(data)
        max_val = max(data)
        range_val = max_val - min_val
        
        # Quartiles
        q1 = sorted_data[n // 4]
        q3 = sorted_data[3 * n // 4]
        iqr = q3 - q1
        
        # Skewness (simplified)
        skewness = sum((x - mean) ** 3 for x in data) / (n * std ** 3) if std > 0 else 0
        
        # Kurtosis (simplified)
        kurtosis = sum((x - mean) ** 4 for x in data) / (n * std ** 4) - 3 if std > 0 else 0
        
        # φ-metrics
        phi_ratio = mean / std if std > 0 else 0
        phi_distance = abs(phi_ratio - PHI)
        
        # Outliers (using IQR method)
        lower_bound = q1 - 1.5 * iqr
        upper_bound = q3 + 1.5 * iqr
        outliers = [x for x in data if x < lower_bound or x > upper_bound]
        
        return {
            'n': n,
            'statistics': {
                'mean': round(mean, 6),
                'median': round(median, 6),
                'std': round(std, 6),
                'variance': round(variance, 6),
                'min': round(min_val, 6),
                'max': round(max_val, 6),
                'range': round(range_val, 6),
            },
            'quartiles': {
                'q1': round(q1, 6),
                'q2': round(median, 6),
                'q3': round(q3, 6),
                'iqr': round(iqr, 6),
            },
            'shape': {
                'skewness': round(skewness, 6),
                'kurtosis': round(kurtosis, 6),
            },
            'phi_metrics': {
                'phi_ratio': round(phi_ratio, 6),
                'phi_distance': round(phi_distance, 6),
                'phi_aligned': phi_distance < PHI_INV,
            },
            'outliers': {
                'count': len(outliers),
                'percentage': round(len(outliers) / n * 100, 2),
            },
            'confidence': round(min(n / 100, 1.0), 4),
            'completeness': round(1.0, 4),
        }


# ─── TRANSFORM TOOL ──────────────────────────────────────────────────────────
class TransformTool(NovaTool):
    """
    TRFD — Data Transformation Tool
    
    Transforms data using various methods.
    """
    
    QUAD = 'TRFD'
    NAME = 'Transform Data'
    DESCRIPTION = 'Data transformation with φ-optimal scaling'
    CATEGORY = 'data'
    FIB_INDEX = 18
    MODALITIES = ['structured', 'numerical']
    ALPHA_ENGINES = ['ALPHA-005 FABRICA']
    
    def _run(self, data: Optional[List[float]] = None,
             method: str = 'normalize',
             n_samples: int = 50, **kwargs) -> Dict:
        """
        Transform data.
        
        Args:
            data: List of numerical values
            method: Transformation method (normalize, standardize, log, phi_scale)
            n_samples: Number of samples for synthetic data
        
        Returns:
            Dict with transformed data
        """
        # Generate synthetic data if none provided
        if data is None:
            data = [random.gauss(10, 3) for _ in range(n_samples)]
        
        n = len(data)
        if n == 0:
            return {
                'error': 'No data provided',
                'confidence': 0.0,
                'completeness': 0.0,
            }
        
        original_stats = {
            'mean': sum(data) / n,
            'min': min(data),
            'max': max(data),
        }
        
        # Apply transformation
        if method == 'normalize':
            # Min-max normalization to [0, 1]
            min_val, max_val = min(data), max(data)
            range_val = max_val - min_val
            if range_val > 0:
                transformed = [(x - min_val) / range_val for x in data]
            else:
                transformed = [0.5] * n
                
        elif method == 'standardize':
            # Z-score standardization
            mean = sum(data) / n
            std = math.sqrt(sum((x - mean) ** 2 for x in data) / n)
            if std > 0:
                transformed = [(x - mean) / std for x in data]
            else:
                transformed = [0.0] * n
                
        elif method == 'log':
            # Log transformation (with offset for non-positive values)
            min_val = min(data)
            offset = abs(min_val) + 1 if min_val <= 0 else 0
            transformed = [math.log(x + offset) for x in data]
            
        elif method == 'phi_scale':
            # Scale to φ-centered distribution
            mean = sum(data) / n
            std = math.sqrt(sum((x - mean) ** 2 for x in data) / n)
            if std > 0:
                transformed = [PHI + (x - mean) / std * PHI_INV for x in data]
            else:
                transformed = [PHI] * n
                
        else:
            transformed = data.copy()
        
        transformed_stats = {
            'mean': sum(transformed) / n,
            'min': min(transformed),
            'max': max(transformed),
        }
        
        return {
            'method': method,
            'n': n,
            'original': {
                'sample': [round(x, 4) for x in data[:5]],
                'stats': {k: round(v, 6) for k, v in original_stats.items()},
            },
            'transformed': {
                'sample': [round(x, 4) for x in transformed[:5]],
                'stats': {k: round(v, 6) for k, v in transformed_stats.items()},
            },
            'confidence': round(0.95, 4),
            'completeness': round(1.0, 4),
        }


# ─── VISUALIZE TOOL ──────────────────────────────────────────────────────────
class VisualizeTool(NovaTool):
    """
    VISD — Data Visualization Tool
    
    Generates visualization specifications.
    """
    
    QUAD = 'VISD'
    NAME = 'Visualize Data'
    DESCRIPTION = 'Data visualization with φ-proportioned layouts'
    CATEGORY = 'data'
    FIB_INDEX = 19
    MODALITIES = ['structured', 'visual']
    ALPHA_ENGINES = ['ALPHA-003 OPTICA']
    
    def _run(self, data: Optional[List[float]] = None,
             chart_type: str = 'histogram',
             n_samples: int = 100, **kwargs) -> Dict:
        """
        Generate visualization specification.
        
        Args:
            data: List of numerical values
            chart_type: Type of chart (histogram, line, scatter, bar)
            n_samples: Number of samples for synthetic data
        
        Returns:
            Dict with visualization specification
        """
        # Generate synthetic data if none provided
        if data is None:
            data = [random.gauss(PHI, PHI_INV) for _ in range(n_samples)]
        
        n = len(data)
        
        # Compute histogram bins (Fibonacci-based)
        n_bins = fib(7)  # 13 bins
        min_val, max_val = min(data), max(data)
        bin_width = (max_val - min_val) / n_bins
        
        bins = []
        for i in range(n_bins):
            bin_start = min_val + i * bin_width
            bin_end = bin_start + bin_width
            count = sum(1 for x in data if bin_start <= x < bin_end)
            bins.append({
                'start': round(bin_start, 4),
                'end': round(bin_end, 4),
                'count': count,
                'percentage': round(count / n * 100, 2),
            })
        
        # φ-proportioned dimensions
        width = 800
        height = int(width / PHI)  # Golden ratio aspect
        
        # Color palette (φ-spaced hues)
        colors = []
        for i in range(5):
            hue = (i * PHI_INV * 360) % 360
            colors.append(f'hsl({int(hue)}, 70%, 50%)')
        
        # Chart specification
        spec = {
            'type': chart_type,
            'dimensions': {
                'width': width,
                'height': height,
                'aspect_ratio': round(width / height, 4),
                'phi_proportioned': True,
            },
            'data': {
                'n': n,
                'range': [round(min_val, 4), round(max_val, 4)],
            },
            'axes': {
                'x': {
                    'label': 'Value',
                    'min': round(min_val, 4),
                    'max': round(max_val, 4),
                },
                'y': {
                    'label': 'Frequency' if chart_type == 'histogram' else 'Value',
                    'min': 0,
                    'max': max(b['count'] for b in bins) if bins else 0,
                },
            },
            'bins': bins if chart_type == 'histogram' else None,
            'colors': colors,
            'phi': PHI,
        }
        
        return {
            'specification': spec,
            'chart_type': chart_type,
            'n_bins': n_bins,
            'confidence': round(0.9, 4),
            'completeness': round(1.0, 4),
            'note': 'Render with matplotlib or chart library',
        }


# ─── PREDICT TOOL ────────────────────────────────────────────────────────────
class PredictTool(NovaTool):
    """
    PRED — Data Prediction Tool
    
    Predicts future values using Kalman filtering.
    """
    
    QUAD = 'PRED'
    NAME = 'Predict Data'
    DESCRIPTION = 'Time series prediction with Kalman filtering'
    CATEGORY = 'data'
    FIB_INDEX = 20
    MODALITIES = ['time-series', 'numerical']
    ALPHA_ENGINES = ['ALPHA-006 PROPHETA', 'ALPHA-007 VERITAS']
    
    def _run(self, data: Optional[List[float]] = None,
             n_predict: int = 5,
             n_samples: int = 50, **kwargs) -> Dict:
        """
        Predict future values.
        
        Args:
            data: Historical time series data
            n_predict: Number of future values to predict
            n_samples: Number of samples for synthetic data
        
        Returns:
            Dict with predictions
        """
        # Generate synthetic time series if none provided
        if data is None:
            # Generate trending data with noise
            trend = 0.1
            data = [i * trend + random.gauss(0, 0.5) for i in range(n_samples)]
        
        n = len(data)
        if n < 3:
            return {
                'error': 'Need at least 3 data points',
                'confidence': 0.0,
                'completeness': 0.0,
            }
        
        # Simple Kalman filter implementation
        # State: [position, velocity]
        x = [data[0], 0]  # Initial state
        P = [[1, 0], [0, 1]]  # Initial covariance
        
        # Process noise
        Q = [[0.1, 0], [0, 0.1]]
        
        # Measurement noise
        R = 0.5
        
        # State transition
        F = [[1, 1], [0, 1]]
        
        # Measurement matrix
        H = [1, 0]
        
        # Run filter on historical data
        filtered = []
        for z in data:
            # Predict
            x_pred = [F[0][0] * x[0] + F[0][1] * x[1],
                      F[1][0] * x[0] + F[1][1] * x[1]]
            
            # Simplified covariance prediction
            P_pred = [[P[0][0] + Q[0][0], P[0][1]],
                      [P[1][0], P[1][1] + Q[1][1]]]
            
            # Update
            y = z - (H[0] * x_pred[0] + H[1] * x_pred[1])  # Innovation
            S = H[0] * P_pred[0][0] * H[0] + R  # Innovation covariance
            K = [P_pred[0][0] * H[0] / S, P_pred[1][0] * H[0] / S]  # Kalman gain
            
            x = [x_pred[0] + K[0] * y, x_pred[1] + K[1] * y]
            P = [[(1 - K[0] * H[0]) * P_pred[0][0], P_pred[0][1]],
                 [P_pred[1][0], (1 - K[1] * H[1]) * P_pred[1][1]]]
            
            filtered.append(x[0])
        
        # Predict future values
        predictions = []
        x_future = x.copy()
        uncertainty = P[0][0]
        
        for i in range(n_predict):
            # Predict step
            x_future = [F[0][0] * x_future[0] + F[0][1] * x_future[1],
                        F[1][0] * x_future[0] + F[1][1] * x_future[1]]
            uncertainty += Q[0][0]
            
            # φ-weighted confidence decay
            conf = PHI_INV ** (i + 1)
            
            predictions.append({
                'step': i + 1,
                'value': round(x_future[0], 6),
                'uncertainty': round(math.sqrt(uncertainty), 6),
                'confidence': round(conf, 4),
            })
        
        # Compute metrics
        residuals = [data[i] - filtered[i] for i in range(n)]
        mse = sum(r ** 2 for r in residuals) / n
        rmse = math.sqrt(mse)
        
        return {
            'historical': {
                'n': n,
                'last_value': round(data[-1], 6),
                'trend': round(x[1], 6),
            },
            'predictions': predictions,
            'n_predicted': n_predict,
            'metrics': {
                'rmse': round(rmse, 6),
                'mse': round(mse, 6),
            },
            'kalman_state': {
                'position': round(x[0], 6),
                'velocity': round(x[1], 6),
            },
            'confidence': round(predictions[0]['confidence'] if predictions else 0, 4),
            'completeness': round(1.0, 4),
        }


# ─── Quick Access Functions ──────────────────────────────────────────────────
_analyze_tool = None
_transform_tool = None
_visualize_tool = None
_predict_tool = None

def analyze_data(data: Optional[List[float]] = None, **kwargs) -> Dict:
    """Quick access to data analysis."""
    global _analyze_tool
    if _analyze_tool is None:
        _analyze_tool = AnalyzeTool()
    return _analyze_tool.execute(data, **kwargs)

def transform_data(data: Optional[List[float]] = None, **kwargs) -> Dict:
    """Quick access to data transformation."""
    global _transform_tool
    if _transform_tool is None:
        _transform_tool = TransformTool()
    return _transform_tool.execute(data, **kwargs)

def visualize_data(data: Optional[List[float]] = None, **kwargs) -> Dict:
    """Quick access to data visualization."""
    global _visualize_tool
    if _visualize_tool is None:
        _visualize_tool = VisualizeTool()
    return _visualize_tool.execute(data, **kwargs)

def predict_data(data: Optional[List[float]] = None, **kwargs) -> Dict:
    """Quick access to data prediction."""
    global _predict_tool
    if _predict_tool is None:
        _predict_tool = PredictTool()
    return _predict_tool.execute(data, **kwargs)


# ─── Self-Test ───────────────────────────────────────────────────────────────
if __name__ == '__main__':
    print("╔════════════════════════════════════════════════════════════════╗")
    print("║              Data Tools — Self-Test                            ║")
    print("║              Nova by FreddyCreates                             ║")
    print("╚════════════════════════════════════════════════════════════════╝")
    print()
    
    print("─── ANALYZE ───")
    result = analyze_data()
    print(f"Mean: {result['statistics']['mean']}")
    print(f"Std: {result['statistics']['std']}")
    print(f"φ-aligned: {result['phi_metrics']['phi_aligned']}")
    print()
    
    print("─── TRANSFORM ───")
    result = transform_data(method='phi_scale')
    print(f"Method: {result['method']}")
    print(f"Original mean: {result['original']['stats']['mean']}")
    print(f"Transformed mean: {result['transformed']['stats']['mean']}")
    print()
    
    print("─── VISUALIZE ───")
    result = visualize_data()
    print(f"Chart: {result['chart_type']}")
    print(f"Dimensions: {result['specification']['dimensions']}")
    print()
    
    print("─── PREDICT ───")
    result = predict_data(n_predict=3)
    print(f"Predictions: {len(result['predictions'])}")
    for p in result['predictions']:
        print(f"  Step {p['step']}: {p['value']:.4f} ± {p['uncertainty']:.4f}")
    print()
    
    print("✓ Data tools ready.")
