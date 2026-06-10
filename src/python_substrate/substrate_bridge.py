"""
CHIMERIA Python Substrate Bridge
Connects Pythonista intelligence engines to ICP multi-substrate canisters.

This bridge runs as a standalone service that:
1. Polls the python_substrate canister for pending tool invocations
2. Dispatches work to the appropriate Pythonista engine
3. Returns results back to the canister
4. Sends heartbeats to maintain engine status

Usage:
    python substrate_bridge.py [--host 127.0.0.1] [--port 8100]
"""

import asyncio
import json
import time
import sys
import os
from typing import Any

# Add pythonista to path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', '..', 'pythonista'))

from animus import AnimusEngine
from lingua import LinguaEngine
from optica import OpticaEngine
from tactus import TactusEngine
from nexus import NexusEngine


class SubstrateBridge:
    """Bridge between ICP python_substrate canister and Pythonista engines."""

    def __init__(self, host: str = "127.0.0.1", port: int = 8100):
        self.host = host
        self.port = port
        self.engines: dict[str, Any] = {}
        self.running = False
        self.heartbeat_interval = 30  # seconds
        self.poll_interval = 1  # seconds
        self._init_engines()

    def _init_engines(self):
        """Initialize all Pythonista engines."""
        self.engines = {
            "animus": AnimusEngine(),
            "lingua": LinguaEngine(),
            "optica": OpticaEngine(),
            "tactus": TactusEngine(),
            "nexus": NexusEngine(),
        }

    def get_engine(self, engine_id: str):
        """Get engine by ID."""
        return self.engines.get(engine_id)

    def invoke_tool(self, engine_id: str, tool_name: str, input_data: str) -> dict:
        """Invoke a tool on the specified engine."""
        engine = self.get_engine(engine_id)
        if engine is None:
            return {
                "success": False,
                "output": f"Engine not found: {engine_id}",
                "execution_time_ms": 0,
            }

        start_time = time.time()
        try:
            # Dispatch to appropriate engine method
            method = getattr(engine, tool_name, None)
            if method is None:
                return {
                    "success": False,
                    "output": f"Tool not found: {tool_name} on engine {engine_id}",
                    "execution_time_ms": 0,
                }

            result = method(input_data)
            elapsed_ms = int((time.time() - start_time) * 1000)

            return {
                "success": True,
                "output": json.dumps(result) if not isinstance(result, str) else result,
                "execution_time_ms": elapsed_ms,
            }
        except Exception as e:
            elapsed_ms = int((time.time() - start_time) * 1000)
            return {
                "success": False,
                "output": f"Error: {str(e)}",
                "execution_time_ms": elapsed_ms,
            }

    def health(self) -> dict:
        """Get bridge health status."""
        return {
            "status": "running" if self.running else "stopped",
            "host": self.host,
            "port": self.port,
            "engines": {
                eid: {"name": type(engine).__name__, "available": True}
                for eid, engine in self.engines.items()
            },
            "timestamp": int(time.time()),
        }

    async def start(self):
        """Start the bridge service."""
        self.running = True
        print(f"[CHIMERIA] Python Substrate Bridge starting on {self.host}:{self.port}")
        print(f"[CHIMERIA] Engines loaded: {list(self.engines.keys())}")
        print(f"[CHIMERIA] Bridge operational - ready for multi-substrate deployment")

        # Run heartbeat and poll loops concurrently
        await asyncio.gather(
            self._heartbeat_loop(),
            self._poll_loop(),
        )

    async def _heartbeat_loop(self):
        """Send periodic heartbeats to the canister."""
        while self.running:
            for engine_id in self.engines:
                # In production, this calls the canister's heartbeat method
                pass
            await asyncio.sleep(self.heartbeat_interval)

    async def _poll_loop(self):
        """Poll for pending invocations from the canister."""
        while self.running:
            # In production, this calls getPendingInvocations on the canister
            # and processes any returned work items
            await asyncio.sleep(self.poll_interval)

    def stop(self):
        """Stop the bridge service."""
        self.running = False
        print("[CHIMERIA] Python Substrate Bridge stopped")


def main():
    """Entry point for the substrate bridge."""
    host = "127.0.0.1"
    port = 8100

    # Parse CLI args
    args = sys.argv[1:]
    for i, arg in enumerate(args):
        if arg == "--host" and i + 1 < len(args):
            host = args[i + 1]
        elif arg == "--port" and i + 1 < len(args):
            port = int(args[i + 1])

    bridge = SubstrateBridge(host=host, port=port)

    try:
        asyncio.run(bridge.start())
    except KeyboardInterrupt:
        bridge.stop()


if __name__ == "__main__":
    main()
