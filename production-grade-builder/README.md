# Production-Grade Builder

**Reusable scaffolding engine for production-grade deliverable packets.**

Zero external dependencies. Runs on Python 3.10+ standard library only.

## Usage

```bash
# Scaffold a new deliverable
python production-grade-builder/builder.py --kind python-service --name my-service --output ./out/my-service

# List available profiles
python production-grade-builder/builder.py --list

# Run the builder's own quality gate
python production-grade-builder/tools/quality_gate.py production-grade-builder

# Run a generated packet's quality gate
python ./out/my-service/tools/quality_gate.py ./out/my-service
```

## Supported Profiles

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

## Architecture

```
production-grade-builder/
├── README.md              ← This file
├── PACKET_POLICY.md       ← The production-grade law
├── builder.py             ← Scaffolding CLI engine
├── profiles/              ← Profile definitions (JSON)
│   └── *.json
├── tools/
│   └── quality_gate.py    ← Self-verification gate
├── examples/              ← Verified example packets
│   ├── static-app/
│   ├── python-service/
│   └── benchmark-engine/
├── manifest.json          ← Builder's own manifest
├── release_manifest.json  ← Release metadata
└── reports/
    ├── build_report.md
    └── scores.json
```

## Verification

The builder is itself a production-grade packet. Run:

```bash
python production-grade-builder/tools/quality_gate.py production-grade-builder
```

## Copyright

© 2024–2026 Alfredo Medina Hernandez. All rights reserved.  
SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
