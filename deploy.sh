#!/bin/bash
set -e 
# Usage: deploy.sh

# Define cleanup function for exit
cleanup() {
    # Kill the icp-cli network process if it's running
    icp network stop
    exit $1
}

# Handle script interruption
trap 'cleanup 1' INT TERM


icp network start -d
icp canister create --environment local frontend
icp canister create --environment local backend
icp canister create --environment local multi_substrate
icp canister create --environment local python_substrate
export BACKEND_CANISTER_ID=$(icp canister settings show --environment local --id-only backend)
export MULTI_SUBSTRATE_CANISTER_ID=$(icp canister settings show --environment local --id-only multi_substrate)
export PYTHON_SUBSTRATE_CANISTER_ID=$(icp canister settings show --environment local --id-only python_substrate)
export STORAGE_GATEWAY_URL=http://localhost:6188
export II_URL=http://rdmx6-jaaaa-aaaaa-aaadq-cai.localhost:8000

icp deploy --environment local frontend backend multi_substrate python_substrate

# Start Python substrate bridge in background
echo "Starting Python Substrate Bridge..."
python3 src/python_substrate/substrate_bridge.py --host 127.0.0.1 --port 8100 &
PYTHON_BRIDGE_PID=$!
echo "Python Substrate Bridge started (PID: $PYTHON_BRIDGE_PID)"

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "  CHIMERIA Multi-Substrate Deployment Complete"
echo "═══════════════════════════════════════════════════════════════"
echo "  Backend Canister:          $BACKEND_CANISTER_ID"
echo "  Multi-Substrate Canister:  $MULTI_SUBSTRATE_CANISTER_ID"
echo "  Python Substrate Canister: $PYTHON_SUBSTRATE_CANISTER_ID"
echo "  Python Bridge:             127.0.0.1:8100 (PID: $PYTHON_BRIDGE_PID)"
echo "═══════════════════════════════════════════════════════════════"
echo ""
echo "Press Ctrl+C to stop the deployment and exit."
# This loop keeps the script running until interrupted by Ctrl+C.
while true; do
    sleep 2
done