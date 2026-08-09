# NEUROSWARMAI — MESIE evidence repro harness
# Runs full readiness when sibling MESIE repo is present; otherwise verifies embedded manifest.
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$NeuroRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
$MesieRoot = Join-Path (Split-Path $NeuroRoot -Parent) "Multi-Element-Spectral-Intelligence-Engine-MESIE-"

Write-Host "=== NEUROSWARMAI MESIE Evidence Repro ===" -ForegroundColor Cyan
Write-Host "NEUROSWARMAI: $NeuroRoot"
Write-Host "MESIE (expected): $MesieRoot"

if (Test-Path (Join-Path $MesieRoot "scripts\MESIE.ps1")) {
    Set-Location $MesieRoot
    . (Join-Path $MesieRoot "scripts\MESIE.ps1")
    Write-Host "Running full MESIE readiness harness..." -ForegroundColor Yellow
    python scripts/run_neuroswarm_readiness.py
    Write-Host "Full repro complete. Fresh evidence: deliverables\neuroswarmai_com\" -ForegroundColor Green
}
else {
    Write-Host "MESIE repo not found at sibling path — verifying embedded evidence pack." -ForegroundColor Yellow
    $manifest = Get-Content (Join-Path $PSScriptRoot "evidence_manifest.json") -Raw | ConvertFrom-Json
    Write-Host "Embedded verdict: $($manifest.verdict)"
    Write-Host "SDK: $($manifest.sdk_version) | MESIE: $($manifest.mesie_version)"
    Write-Host "Harness results: $($manifest.harness_results.Count) entries"
    foreach ($h in $manifest.harness_results) {
        $status = if ($h.ok) { "PASS" } else { "FAIL" }
        Write-Host "  [$status] $($h.harness) ($($h.elapsed_s)s)"
    }
    if (-not ($manifest.harness_results | Where-Object { -not $_.ok })) {
        Write-Host "Embedded evidence pack: all harnesses OK" -ForegroundColor Green
    }
}

Write-Host "Phantom QSHA manifest:" -ForegroundColor Cyan
Set-Location $NeuroRoot
python scripts/regenerate_phantom_manifest.py