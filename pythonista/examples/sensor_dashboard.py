#!/usr/bin/env python3
"""
Example: Real-Time Sensor Dashboard
Nova by FreddyCreates — Pythonista iOS

This example creates a real-time sensor dashboard using TACTUS.
On actual iOS, it reads accelerometer and gyroscope data.
"""

import time
from tactus import TactusEngine
from phi import PHI, PHI_INV, PHI_BEAT

def run_sensor_dashboard(duration: int = 30, interval: float = 0.5):
    """
    Run a sensor dashboard for specified duration.
    
    Args:
        duration: How long to run (seconds)
        interval: Time between readings (seconds)
    """
    print("╔════════════════════════════════════════════════════════════════╗")
    print("║           Nova Sensor Dashboard — Real-Time                    ║")
    print("╚════════════════════════════════════════════════════════════════╝")
    print()
    print(f"Duration: {duration}s | Interval: {interval}s | PHI_BEAT: {PHI_BEAT}ms")
    print("─" * 60)
    print()
    
    engine = TactusEngine()
    start_time = time.time()
    readings = []
    
    while time.time() - start_time < duration:
        # Sense current state
        sense = engine.sense()
        
        # Get homeostasis status
        homeo = engine.homeostasis_status()
        
        # Display
        elapsed = time.time() - start_time
        accel = sense['accelerometer']
        gyro = sense['gyroscope']
        
        print(f"[{elapsed:6.1f}s] ", end="")
        print(f"ACCEL: ({accel['x']:+.3f}, {accel['y']:+.3f}, {accel['z']:+.3f}) | ", end="")
        print(f"GYRO: ({gyro['roll']:+.3f}, {gyro['pitch']:+.3f}, {gyro['yaw']:+.3f}) | ", end="")
        print(f"STABLE: {homeo['stable']}")
        
        # Store reading
        readings.append({
            'time': elapsed,
            'accel': accel,
            'gyro': gyro,
            'error': homeo['error'],
        })
        
        # Wait for next reading
        time.sleep(interval)
    
    print()
    print("─" * 60)
    print("Summary:")
    print(f"  Total readings: {len(readings)}")
    print(f"  Source: {readings[0]['accel']['source']}")
    
    # Compute average homeostatic error
    avg_error = sum(r['error'] for r in readings) / len(readings)
    print(f"  Avg homeostatic error: {avg_error:.4f}")
    print(f"  Setpoint (φ⁻¹): {PHI_INV:.4f}")
    print()
    
    return readings

if __name__ == '__main__':
    # Run for 10 seconds with 0.5s intervals
    readings = run_sensor_dashboard(duration=10, interval=0.5)
    print("✓ Dashboard complete.")
