# NEUROSWARMAI — full stack verify (Python + Node + evidence + governance)
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$Root = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
Set-Location $Root

Write-Host "=== NEUROSWARMAI Stack Verify ===" -ForegroundColor Cyan

Write-Host "`n[1/5] Python: sovereign + drone-side engines" -ForegroundColor Yellow
python -m pytest tests/python/test_sovereign_native.py tests/python/test_drone_side_engines.py -v --tb=short

Write-Host "`n[2/5] Python: phantom_qsha (requires cryptography)" -ForegroundColor Yellow
$cryptoOk = python -c "import cryptography" 2>$null; if (-not $cryptoOk) { pip install -q cryptography 2>$null }
$cryptoOk = python -c "import cryptography" 2>$null
if ($LASTEXITCODE -eq 0) {
    python -m pytest tests/python/test_phantom_qsha.py -v --tb=line -q
} else {
    Write-Host "  SKIP: cryptography not available (CI/ubuntu installs wheel)" -ForegroundColor DarkYellow
}

Write-Host "`n[3/5] Node: swarm drone-side protocols" -ForegroundColor Yellow
pnpm exec vitest run tests/protocols/swarm-drone-side.test.js

Write-Host "`n[4/5] Evidence + Phantom manifest" -ForegroundColor Yellow
& (Join-Path $Root "evidence\mesie\reproduce_neuroswarmai.ps1")

Write-Host "`n[5/5] Governance: emit drone swarm event + CPL-L cycle" -ForegroundColor Yellow
node scripts/emit_drone_swarm_governance_event.js
node governance/governance-cycle.js

Write-Host "`nDone. Evidence: evidence\mesie\evidence_manifest.json" -ForegroundColor Green