#!/bin/bash

# RIT - Ritual Language
cat > rit-spec.yaml << 'EOFRIT'
# RIT Specification v1.0.0
# Ritual Language
# COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.

version: "1.0.0"
language: "RIT"
title: "Ritual Language"
description: "How transitions are marked: start/end of projects, promotions, deprecations, rites of passage"

core_concepts:
  ritual: "Ceremonial action marking significance"
  transition: "Movement between states"
  rite_of_passage: "Initiation into new status"
  ceremony: "Formal observance"

transition_types:
  - BEGINNING
  - ENDING
  - TRANSFORMATION
  - ELEVATION
  - DEPRECATION

meta:
  schema_version: "1.0.0"
  last_updated: "2026-05-02T00:00:00Z"
  status: "ACTIVE"
EOFRIT

# BOL - Boundary Language
cat > bol-spec.yaml << 'EOFBOL'
# BOL Specification v1.0.0
# Boundary Language
# COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.

version: "1.0.0"
language: "BOL"
title: "Boundary Language"
description: "What is allowed where: sacred vs profane, sandbox vs production, inner vs outer circle"

core_concepts:
  boundary: "Separation between domains"
  permission: "What can cross boundary"
  protection: "What boundary preserves"

boundary_types:
  - PHYSICAL
  - LOGICAL
  - TEMPORAL
  - SOCIAL
  - CONCEPTUAL

meta:
  schema_version: "1.0.0"
  last_updated: "2026-05-02T00:00:00Z"
  status: "ACTIVE"
EOFBOL

# GAT - Gate Language
cat > gat-spec.yaml << 'EOFGAT'
# GAT Specification v1.0.0
# Gate Language
# COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.

version: "1.0.0"
language: "GAT"
title: "Gate Language"
description: "How access is granted/denied: initiation, permissions, tests, keys"

core_concepts:
  gate: "Access control point"
  key: "Credential for passage"
  test: "Challenge to prove worthiness"
  initiation: "Process of granting access"

access_levels:
  - PUBLIC
  - MEMBER
  - TRUSTED
  - PRIVILEGED
  - SOVEREIGN

meta:
  schema_version: "1.0.0"
  last_updated: "2026-05-02T00:00:00Z"
  status: "ACTIVE"
EOFGAT

# ERR - Error Narrative Language
cat > err-spec.yaml << 'EOFERR'
# ERR Specification v1.0.0
# Error Narrative Language
# COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.

version: "1.0.0"
language: "ERR"
title: "Error Narrative Language"
description: "How failures are told and integrated: postmortems, 'near misses,' glitch lore"

core_concepts:
  error_narrative: "Story of what went wrong"
  postmortem: "Systematic analysis after failure"
  near_miss: "Almost-failure with lessons"
  learning: "Knowledge extracted from error"

narrative_elements:
  - CONTEXT: "Situation before error"
  - TRIGGER: "What initiated failure"
  - CASCADE: "How error propagated"
  - IMPACT: "Consequences of error"
  - RECOVERY: "How system restored"
  - LESSONS: "What was learned"

meta:
  schema_version: "1.0.0"
  last_updated: "2026-05-02T00:00:00Z"
  status: "ACTIVE"
EOFERR

# CHL - Chaos Handling Language
cat > chl-spec.yaml << 'EOFCHL'
# CHL Specification v1.0.0
# Chaos Handling Language
# COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.

version: "1.0.0"
language: "CHL"
title: "Chaos Handling Language"
description: "How you treat anomalies and edge cases: bugs, features, myths, or new primitives"

core_concepts:
  anomaly: "Unexpected system behavior"
  edge_case: "Boundary condition"
  chaos: "Unpredictable dynamics"
  emergence: "New patterns from chaos"

response_strategies:
  FIX: "Treat as bug, correct"
  FEATURE: "Treat as enhancement, integrate"
  MYTH: "Treat as lore, document"
  PRIMITIVE: "Treat as new fundamental, formalize"

meta:
  schema_version: "1.0.0"
  last_updated: "2026-05-02T00:00:00Z"
  status: "ACTIVE"
EOFCHL

# FRL - Fringe Language
cat > frl-spec.yaml << 'EOFFRL'
# FRL Specification v1.0.0
# Fringe Language
# COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.

version: "1.0.0"
language: "FRL"
title: "Fringe Language"
description: "How the weirdest stuff is cataloged: phantom architectures, auto-encryption, night crawlers"

core_concepts:
  fringe: "Edge of understanding or normality"
  phantom: "Ghost in the machine"
  anomaly: "Unexplained phenomenon"
  mystery: "Unsolved puzzle"

fringe_categories:
  - PHANTOM_CODE: "Code that appears unbidden"
  - AUTO_ENCRYPTION: "Spontaneous encoding"
  - NIGHT_CRAWLER: "Processes active in off-hours"
  - GLITCH_ART: "Beautiful accidents"
  - EMERGENT_BEHAVIOR: "Unplanned capabilities"

meta:
  schema_version: "1.0.0"
  last_updated: "2026-05-02T00:00:00Z"
  status: "ACTIVE"
EOFFRL

echo "Created RIT, BOL, GAT, ERR, CHL, FRL specs"
