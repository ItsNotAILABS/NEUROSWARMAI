#!/bin/bash

# EXL - Experiment Language
cat > exl-spec.yaml << 'EOFEXL'
# EXL Specification v1.0.0
# Experiment Language
# COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.

version: "1.0.0"
language: "EXL"
title: "Experiment Language"
description: "Running experiments and accepting risk: hypotheses, probes, kill-switches, learnings"

core_concepts:
  hypothesis: "Testable prediction"
  probe: "Small-scale test"
  kill_switch: "Safety abort mechanism"
  learning: "Knowledge gained from experiment"

experiment_phases:
  - DESIGN
  - SETUP
  - EXECUTE
  - OBSERVE
  - ANALYZE
  - CONCLUDE

meta:
  schema_version: "1.0.0"
  last_updated: "2026-05-02T00:00:00Z"
  status: "ACTIVE"
EOFEXL

# MYL - Mythic Language
cat > myl-spec.yaml << 'EOFMYL'
# MYL Specification v1.0.0
# Mythic Language
# COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.

version: "1.0.0"
language: "MYL"
title: "Mythic Language"
description: "Trickster, lineage, gods, cosmology - stories that bind the organism together"

core_concepts:
  myth: "Foundational narrative"
  archetype: "Universal pattern or character"
  cosmology: "Story of origins and structure"
  lineage: "Ancestral connections"

archetypal_figures:
  - TRICKSTER
  - HERO
  - SAGE
  - CREATOR
  - DESTROYER

meta:
  schema_version: "1.0.0"
  last_updated: "2026-05-02T00:00:00Z"
  status: "ACTIVE"
EOFMYL

# STL - Story Thread Language
cat > stl-spec.yaml << 'EOFSTL'
# STL Specification v1.0.0
# Story Thread Language
# COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.

version: "1.0.0"
language: "STL"
title: "Story Thread Language"
description: "How arcs are woven: seasons, chapters, sagas - 'This era was about X; the next era is about Y'"

core_concepts:
  thread: "Narrative strand"
  arc: "Story progression"
  season: "Thematic period"
  chapter: "Discrete episode"

narrative_structures:
  - LINEAR
  - CYCLICAL
  - BRANCHING
  - NESTED
  - FRACTAL

meta:
  schema_version: "1.0.0"
  last_updated: "2026-05-02T00:00:00Z"
  status: "ACTIVE"
EOFSTL

# SYM - Symbolic Language
cat > sym-spec.yaml << 'EOFSYM'
# SYM Specification v1.0.0
# Symbolic Language
# COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.

version: "1.0.0"
language: "SYM"
title: "Symbolic Language"
description: "Colors, numbers, shapes, sigils - encoded meaning in non-verbal primitives"

core_concepts:
  symbol: "Non-verbal meaningful unit"
  sigil: "Condensed symbolic representation"
  glyph: "Visual character with meaning"

symbol_types:
  COLOR: "Emotional and associative meanings"
  NUMBER: "Mathematical and mystical significance"
  SHAPE: "Geometric and topological meaning"
  GLYPH: "Composite visual symbols"

sacred_numbers:
  PHI: 1.618033988749895
  PI: 3.14159265358979
  E: 2.71828182845905
  F11: 89

meta:
  schema_version: "1.0.0"
  last_updated: "2026-05-02T00:00:00Z"
  status: "ACTIVE"
EOFSYM

# VAL - Value Language
cat > val-spec.yaml << 'EOFVAL'
# VAL Specification v1.0.0
# Value Language
# COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.

version: "1.0.0"
language: "VAL"
title: "Value Language"
description: "What 'worth it' means: time, attention, energy, money, impact, beauty"

core_concepts:
  value: "Perceived worth or importance"
  worth: "Justification for expenditure"
  trade_off: "Exchange between values"

value_dimensions:
  - TIME
  - ATTENTION
  - ENERGY
  - MONEY
  - IMPACT
  - BEAUTY
  - MEANING

meta:
  schema_version: "1.0.0"
  last_updated: "2026-05-02T00:00:00Z"
  status: "ACTIVE"
EOFVAL

# RCL - Resource Circulation Language
cat > rcl-spec.yaml << 'EOFRCL'
# RCL Specification v1.0.0
# Resource Circulation Language
# COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.

version: "1.0.0"
language: "RCL"
title: "Resource Circulation Language"
description: "How resources move: tokens, favors, credits, access, bandwidth"

core_concepts:
  circulation: "Movement of resources"
  flow: "Direction and rate of transfer"
  accumulation: "Resource pooling"
  distribution: "Resource allocation"

resource_types:
  - TOKENS
  - FAVORS
  - CREDITS
  - ACCESS
  - BANDWIDTH
  - REPUTATION

meta:
  schema_version: "1.0.0"
  last_updated: "2026-05-02T00:00:00Z"
  status: "ACTIVE"
EOFRCL

# GIL - Gift Language
cat > gil-spec.yaml << 'EOFGIL'
# GIL Specification v1.0.0
# Gift Language
# COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.

version: "1.0.0"
language: "GIL"
title: "Gift Language"
description: "How you give things away without hollowing yourself out: boundaries, generosity, sustainability"

core_concepts:
  gift: "Unilateral transfer without expectation"
  generosity: "Willingness to give"
  boundary: "Protection of self"
  sustainability: "Capacity to continue giving"

gift_types:
  - KNOWLEDGE
  - TIME
  - RESOURCES
  - ATTENTION
  - CREATION

meta:
  schema_version: "1.0.0"
  last_updated: "2026-05-02T00:00:00Z"
  status: "ACTIVE"
EOFGIL

echo "Created EXL, MYL, STL, SYM, VAL, RCL, GIL specs"
