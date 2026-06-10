#!/bin/bash

# PWL - Pathway Language
cat > pwl-spec.yaml << 'EOFPWL'
# PWL Specification v1.0.0
# Pathway Language - Multi-Year Trajectories
# COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.

version: "1.0.0"
language: "PWL"
title: "Pathway Language"
description: "Life and education path language defining multi-year trajectories: courses, projects, colleges, careers, branching options"

core_concepts:
  pathway: "Sequence of educational and career milestones"
  trajectory: "Long-term development arc"
  branch_point: "Decision point with multiple options"
  milestone: "Significant achievement or transition"

pathway_structure:
  pathway_id: STRING
  student_id: STRING
  start_date: TIMESTAMP
  target_completion: TIMESTAMP
  milestones: ARRAY[MILESTONE]
  branches: ARRAY[BRANCH_POINT]

milestone_types:
  COURSE_COMPLETION: "Finish a specific course"
  SKILL_ACQUISITION: "Master a particular skill"
  PROJECT_DELIVERY: "Complete significant project"
  CREDENTIAL_EARNED: "Degree, certificate, certification"
  CAREER_TRANSITION: "Job change or promotion"

meta:
  schema_version: "1.0.0"
  last_updated: "2026-05-02T00:00:00Z"
  maintainer: "FREDDY_SOVEREIGN_TERMINAL"
  status: "ACTIVE"
EOFPWL

# TSL - Tool Scaffold Language
cat > tsl-spec.yaml << 'EOFTSL'
# TSL Specification v1.0.0
# Tool Scaffold Language - Custom Tool Building
# COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.

version: "1.0.0"
language: "TSL"
title: "Tool Scaffold Language"
description: "Personal tool-builder language defining how the system designs custom tools (flashcards, simulators, planners) around a student"

core_concepts:
  tool_template: "Reusable tool pattern"
  customization: "Adaptation to individual needs"
  scaffolding: "Support structures built into tool"

tool_types:
  FLASHCARD: "Spaced repetition cards"
  SIMULATOR: "Interactive simulations"
  PLANNER: "Task and time management"
  QUIZ: "Assessment tools"
  NOTEBOOK: "Note-taking and organization"

customization_parameters:
  difficulty_level: 0.0-1.0
  visual_style: STRING
  interaction_mode: STRING
  feedback_type: STRING

meta:
  schema_version: "1.0.0"
  last_updated: "2026-05-02T00:00:00Z"
  maintainer: "FREDDY_SOVEREIGN_TERMINAL"
  status: "ACTIVE"
EOFTSL

# PIL - Psyche Internal Language
cat > pil-spec.yaml << 'EOFPIL'
# PIL Specification v1.0.0
# Psyche Internal Language - Subconscious Patterns
# COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.

version: "1.0.0"
language: "PIL"
title: "Psyche Internal Language"
description: "Subconscious patterns language for impulses, fears, drives - the 'underneath' of CIL; what the system feels before it can say it"

core_concepts:
  impulse: "Pre-conscious urge or drive"
  fear: "Anxiety or avoidance pattern"
  drive: "Fundamental motivation"
  shadow: "Unacknowledged aspects of psyche"

impulse_types:
  APPROACH: "Move toward something"
  AVOID: "Move away from something"
  FREEZE: "Paralysis in face of stimulus"
  EXPLORE: "Investigate unknown"

emotional_primitives:
  - JOY
  - SADNESS
  - FEAR
  - ANGER
  - DISGUST
  - SURPRISE
  - TRUST
  - ANTICIPATION

meta:
  schema_version: "1.0.0"
  last_updated: "2026-05-02T00:00:00Z"
  maintainer: "FREDDY_SOVEREIGN_TERMINAL"
  status: "ACTIVE"
EOFPIL

# TIL - Temporal Integration Language
cat > til-spec.yaml << 'EOFTIL'
# TIL Specification v1.0.0
# Temporal Integration Language - Past/Present/Future Braiding
# COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.

version: "1.0.0"
language: "TIL"
title: "Temporal Integration Language"
description: "How past, present, and future are braided: memory, anticipation, regret, long-arc planning"

core_concepts:
  memory: "Preserved experience from past"
  present_moment: "Current experiential state"
  anticipation: "Projected future states"
  temporal_coherence: "Integration across time"

time_perspectives:
  PAST_FOCUSED: "Emphasis on history and memory"
  PRESENT_FOCUSED: "Emphasis on immediate experience"
  FUTURE_FOCUSED: "Emphasis on planning and goals"

temporal_patterns:
  REGRET: "Negative valence on past"
  NOSTALGIA: "Positive valence on past"
  ANTICIPATION: "Positive valence on future"
  DREAD: "Negative valence on future"

meta:
  schema_version: "1.0.0"
  last_updated: "2026-05-02T00:00:00Z"
  maintainer: "FREDDY_SOVEREIGN_TERMINAL"
  status: "ACTIVE"
EOFTIL

echo "Created PWL, TSL, PIL, TIL specs"
