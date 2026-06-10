#!/bin/bash

# SIL - Self-Identity Language
cat > sil-spec.yaml << 'EOFSIL'
# SIL Specification v1.0.0
# Self-Identity Language
# COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.

version: "1.0.0"
language: "SIL"
title: "Self-Identity Language"
description: "'Who am I?' across roles and contexts - founder, architect, teacher, trickster, organism"

core_concepts:
  identity: "Sense of continuous self across contexts"
  role: "Context-specific manifestation of self"
  essence: "Core unchanging aspects"
  facet: "Situational expressions"

identity_dimensions:
  - PROFESSIONAL
  - PERSONAL
  - CREATIVE
  - SOCIAL
  - SPIRITUAL

meta:
  schema_version: "1.0.0"
  last_updated: "2026-05-02T00:00:00Z"
  status: "ACTIVE"
EOFSIL

# RIL - Repair & Integration Language
cat > ril-spec.yaml << 'EOFRIL'
# RIL Specification v1.0.0
# Repair & Integration Language
# COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.

version: "1.0.0"
language: "RIL"
title: "Repair & Integration Language"
description: "How the system heals, reconciles contradictions, resolves conflicts: self-healing, refactoring, forgiveness, rollback + learn"

core_concepts:
  healing: "Recovery from damage or dysfunction"
  reconciliation: "Resolving contradictions"
  integration: "Incorporating new understanding"
  forgiveness: "Releasing resentment"

repair_types:
  TECHNICAL: "Fix code or system issues"
  COGNITIVE: "Resolve mental conflicts"
  SOCIAL: "Heal relationships"
  EXISTENTIAL: "Reconcile meaning crises"

meta:
  schema_version: "1.0.0"
  last_updated: "2026-05-02T00:00:00Z"
  status: "ACTIVE"
EOFRIL

# REL - Relational Ecology Language
cat > rel-spec.yaml << 'EOFREL'
# REL Specification v1.0.0
# Relational Ecology Language
# COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.

version: "1.0.0"
language: "REL"
title: "Relational Ecology Language"
description: "How you relate to people, AIs, orgs, students: trust, boundaries, reciprocity, collaboration patterns"

core_concepts:
  relationship: "Connection between entities"
  trust: "Confidence in reliability"
  boundary: "Limits and protected spaces"
  reciprocity: "Mutual exchange"

relationship_types:
  - MENTOR_MENTEE
  - PEER
  - SUPERVISOR_SUBORDINATE
  - COLLABORATOR
  - COMPETITOR

meta:
  schema_version: "1.0.0"
  last_updated: "2026-05-02T00:00:00Z"
  status: "ACTIVE"
EOFREL

# COL - Collective Orchestration Language
cat > col-spec.yaml << 'EOFCOL'
# COL Specification v1.0.0
# Collective Orchestration Language
# COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.

version: "1.0.0"
language: "COL"
title: "Collective Orchestration Language"
description: "How many beings work together: swarms, councils, committees, guilds, multi-agent rituals"

core_concepts:
  collective: "Group of coordinated beings"
  swarm: "Decentralized emergent coordination"
  council: "Deliberative decision-making body"
  guild: "Skill-based professional group"

coordination_patterns:
  - HIERARCHICAL
  - PEER_TO_PEER
  - EMERGENT
  - DEMOCRATIC
  - CONSENSUS

meta:
  schema_version: "1.0.0"
  last_updated: "2026-05-02T00:00:00Z"
  status: "ACTIVE"
EOFCOL

# ROL - Role Language
cat > rol-spec.yaml << 'EOFROL'
# ROL Specification v1.0.0
# Role Language
# COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.

version: "1.0.0"
language: "ROL"
title: "Role Language"
description: "How roles are defined, swapped, merged: 'Today this agent is a critic; tomorrow it's a builder'"

core_concepts:
  role: "Set of behaviors and responsibilities"
  role_transition: "Switching between roles"
  role_fusion: "Combining multiple roles"

common_roles:
  - CREATOR
  - CRITIC
  - EXECUTOR
  - OBSERVER
  - FACILITATOR

meta:
  schema_version: "1.0.0"
  last_updated: "2026-05-02T00:00:00Z"
  status: "ACTIVE"
EOFROL

# WFL - Work Flow Language
cat > wfl-spec.yaml << 'EOFWFL'
# WFL Specification v1.0.0
# Work Flow Language
# COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.

version: "1.0.0"
language: "WFL"
title: "Work Flow Language"
description: "How you actually work: bursts, sprints, deep dives, wandering - task shapes, energy cycles, context switching"

core_concepts:
  work_pattern: "Characteristic way of working"
  energy_cycle: "Natural rhythm of productivity"
  context_switch: "Transition between tasks"

work_modes:
  BURST: "Intense short periods"
  SPRINT: "Sustained focused effort"
  DEEP_DIVE: "Extended immersion"
  WANDERING: "Exploratory meandering"

meta:
  schema_version: "1.0.0"
  last_updated: "2026-05-02T00:00:00Z"
  status: "ACTIVE"
EOFWFL

# CXL - Creation Language
cat > cxl-spec.yaml << 'EOFCXL'
# CXL Specification v1.0.0
# Creation Language
# COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.

version: "1.0.0"
language: "CXL"
title: "Creation Language"
description: "How new things emerge from nothing: idea → sketch → prototype → organism → civilization"

core_concepts:
  creation_process: "Stages of manifestation"
  emergence: "Spontaneous arising"
  iteration: "Refinement through cycles"

creation_stages:
  - SPARK: "Initial idea or inspiration"
  - SKETCH: "Rough outline"
  - PROTOTYPE: "First working version"
  - REFINEMENT: "Improvement iterations"
  - ORGANISM: "Living autonomous system"
  - CIVILIZATION: "Thriving ecosystem"

meta:
  schema_version: "1.0.0"
  last_updated: "2026-05-02T00:00:00Z"
  status: "ACTIVE"
EOFCXL

echo "Created SIL, RIL, REL, COL, ROL, WFL, CXL specs"
