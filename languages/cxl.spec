---
name: Creation Language
id: cxl
layer: WorkCraft
version: 1.0.0
status: stable
phi_sync: true
phi_beat: 873ms

domain:
  description: >
    CXL encodes the creative pipeline — from idea to sketch to prototype to deployed creation.
  scope: [idea-pipeline, prototyping, creative-process]

core_concepts:
  - CREATION
  - IDEA
  - SKETCH
  - PROTOTYPE
  - BUILD
  - DEPLOY
  - EVOLVE
  - ARCHIVE

syntax:
  form: creation-pipeline
  primary_block: CREATION
  encoding: yaml
  schema:
    creations:
    - id: string
      type: string
      stage: string
      origin: string
      notes: string


semantics:
  - Used by Atlas and terminals to track maturity of builds.

storage:
  extension: .cxl
  location: creation/*.cxl

integration:
  constrained_by: [WFL, OCL]
  feeds_into: [EXL, RSL]
  consumed_by: [organisms]

terminal_binding: Every terminal can initiate and participate in creation processes
atlas_binding: Tracks all active creations
---
╔══════════════════════════════════════════════════════════════════╗
║  CXL — CREATION LANGUAGE                                         ║
║  Stack: IV — Work, Craft, Creation                               ║
║  Version: 1.0.0 · φ-Aligned                                     ║
╚══════════════════════════════════════════════════════════════════╝

═══ PURPOSE ═══

CXL encodes the creative pipeline — from idea to sketch to
prototype to organism to civilization. It is the generative
language of the cosmos.

═══ SYNTAX ═══

  CREATION <name> {
    STAGE IDEA {
      SEED: <inspiration>
      VIABILITY: <0.0-1.0>
    }
    STAGE SKETCH {
      FORM: <rough_design>
      CONSTRAINTS: [<limit>, ...]
    }
    STAGE PROTOTYPE {
      BUILD: <implementation>
      TEST: <validation>
      ITERATE: <refinement_count>
    }
    STAGE ORGANISM {
      CHARTER: <ocl_ref>
      DEPLOY: <target>
    }
    STAGE CIVILIZATION {
      CONSTITUTION: <cpl_l_ref>
      POPULATION: [<organism>, ...]
    }
    PROGRESSION: IDEA → SKETCH → PROTOTYPE → ORGANISM → CIVILIZATION
  }

═══ SEMANTICS ═══

- Creation follows a Fibonacci spiral of increasing complexity.
- Each STAGE gates progression with viability and validation.
- Prototypes iterate with Fibonacci-bounded refinement counts.
- Organisms are born from prototypes with OCL charters.
- Civilizations emerge from organism populations.

═══ EXAMPLES ═══

  CREATION NOVA_INTELLIGENCE {
    STAGE IDEA {
      SEED: "18-terminal nervous system for sovereign cognition."
      VIABILITY: 0.89
    }
    STAGE SKETCH {
      FORM: RSL.NOVA_REALM_DESIGN
      CONSTRAINTS: [MAX_TERMINALS: F21, PHI_ALIGNED: TRUE]
    }
    STAGE PROTOTYPE {
      BUILD: DEPLOY_TEST_MESH
      TEST: VALIDATE_TERMINAL_CONNECTIVITY
      ITERATE: F5
    }
    STAGE ORGANISM {
      CHARTER: OCL.NOVA_CORE
      DEPLOY: ICP_CANISTER
    }
  }

═══ INTEGRATION POINTS ═══

- Driven by WFL work rhythms.
- Tested by EXL experiments.
- Organisms charted by OCL.
- Civilizations constituted by CPL-L.
- Narrated by CIL, mythologized by MYL.
- Tools scaffolded by TSL.

═══ TERMINAL BINDINGS ═══

Every terminal:
  - Can initiate and participate in creation processes.
  - Reports creation progress to Atlas.
  - Gates stage progression with validation.

═══ ATLAS BINDINGS ═══

Atlas:
  - Tracks all active creations.
  - Provides cross-creation coordination.
  - Archives creation histories for learning.
