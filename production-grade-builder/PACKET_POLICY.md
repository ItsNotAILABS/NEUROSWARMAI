# Production-Grade Packet Policy

**Version:** 1.0.0  
**Authority:** Medina Doctrine  
**Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.**  
**SPDX-License-Identifier: CPEL-1.0**

---

## Law

Every deliverable leaving this repository is a **production-grade packet**. A packet is not a loose folder of code — it is a self-contained, self-verifying unit that carries its own proof of correctness.

## Required Artifacts (All Surfaces)

| Artifact | Purpose |
|----------|---------|
| `README.md` | What it is, how to run, how to verify |
| `PACKET_POLICY.md` | This document (copied into every packet) |
| `manifest.json` | Machine-readable metadata: name, version, kind, files, checksums |
| `release_manifest.json` | Release-specific build info: timestamp, builder version, scores |
| `reports/build_report.md` | Human-readable build summary |
| `reports/scores.json` | Numeric quality gate scores |
| `tools/quality_gate.py` | Self-contained verification script (zero dependencies) |

## Deliverable Profiles

| Kind | Description |
|------|-------------|
| `static-app` | HTML/CSS/JS frontend bundles |
| `python-service` | Python backend service or library |
| `node-service` | Node.js backend service or library |
| `benchmark-engine` | Performance measurement engine |
| `local-api` | Local REST/gRPC API service |
| `ci-workflow` | CI/CD pipeline definitions |
| `dataset` | Structured data packages |
| `manifest` | Configuration/declaration files |
| `proof-pack` | Mathematical/cryptographic proof bundles |
| `research-packet` | Research papers, findings, references |
| `dashboard` | Monitoring/visualization UI |
| `docs` | Documentation packages |
| `deploy-scaffold` | Deployment infrastructure templates |
| `repo-surface` | Repository-level configuration/governance |

## Quality Gate Rules

A packet passes its quality gate if and only if:

1. **Structure** — All required artifacts exist
2. **Manifest integrity** — `manifest.json` lists every file; listed files exist
3. **README completeness** — README has ≥3 sections (headings)
4. **Policy presence** — `PACKET_POLICY.md` exists and is non-empty
5. **Gate executable** — `tools/quality_gate.py` runs and returns exit code 0
6. **Score threshold** — All scores in `reports/scores.json` are ≥ 0.7 (70%)

## Scaffolding Workflow

```
1. Choose deliverable kind from profile list
2. Run: python production-grade-builder/builder.py --kind <kind> --name <name> --output <dir>
3. Fill in real content (source, data, configs)
4. Run: python <output>/tools/quality_gate.py <output>
5. Gate passes → export production ZIP
```

## Enforcement

- No deliverable merges without a passing quality gate.
- The builder is the single source of truth for packet structure.
- Profiles evolve here; downstream packets inherit updates.

---

*This policy is the default law for every surface in the NEUROSWARMAI platform.*
