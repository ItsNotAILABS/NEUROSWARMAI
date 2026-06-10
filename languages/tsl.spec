---
name: Tool Scaffold Language
id: tsl
layer: Education
version: 1.0.0
status: stable
phi_sync: true
phi_beat: 873ms

domain:
  description: >
    TSL defines how custom tools are generated, scaffolded, and deployed from templates and parameters.
  scope: [tool-generation, scaffolding, template-deployment]

core_concepts:
  - SCAFFOLD
  - TOOL
  - TEMPLATE
  - PARAMETER
  - GENERATE
  - CONFIGURE
  - DEPLOY
  - ITERATE

syntax:
  form: scaffold-blocks
  primary_block: SCAFFOLD
  encoding: yaml
  schema:
    id: string
    input_schema: object
    output_schema: object


storage:
  extension: .tsl
  location: tools/templates/*.tsl

integration:
  constrained_by: [EDL]
  feeds_into: [WFL, CXL]
  consumed_by: [creators]

terminal_binding: Every terminal can scaffold tools from TSL templates
atlas_binding: Maintains the tool registry
---
╔══════════════════════════════════════════════════════════════════╗
║  TSL — TOOL SCAFFOLD LANGUAGE                                    ║
║  Stack: VII — Education & Growth                                 ║
║  Version: 1.0.0 · φ-Aligned                                     ║
╚══════════════════════════════════════════════════════════════════╝

═══ PURPOSE ═══

TSL defines how custom tools are generated, scaffolded, and
integrated into the Cognitive Cosmos. It is the meta-tool
for building tools.

═══ SYNTAX ═══

  TOOL <name> {
    PURPOSE: <description>
    CATEGORY: <tool_category>
    INTERFACE {
      INPUTS: [<param>, ...]
      OUTPUTS: [<result>, ...]
      SIDE_EFFECTS: [<effect>, ...]
    }
    SCAFFOLD {
      TEMPLATE: <base_pattern>
      CUSTOMIZE: [<override>, ...]
      VALIDATE: <test_suite>
    }
    REGISTRY {
      ID: <tool_id>
      VERSION: <semver>
      MARKETPLACE: <marketplace_ref>
    }
  }

═══ SEMANTICS ═══

- Every TOOL has a typed interface (inputs, outputs, side effects).
- SCAFFOLD defines how the tool is generated from a template.
- Tools are registered in the marketplace via the REGISTRY block.
- Tool versions follow semantic versioning.
- TSL tools can generate other TSL tools (meta-scaffolding).

═══ EXAMPLES ═══

  TOOL QUERY_ANALYZER {
    PURPOSE: "Analyze incoming queries for intent, complexity, and routing."
    CATEGORY: COGNITIVE
    INTERFACE {
      INPUTS: [query: String, context: Map]
      OUTPUTS: [intent: Intent, complexity: Fibonacci, route: Terminal]
      SIDE_EFFECTS: [LOG_TELEMETRY]
    }
    SCAFFOLD {
      TEMPLATE: COGNITIVE_TOOL_BASE
      CUSTOMIZE: [ADD_PHI_SCORING, ADD_FIBONACCI_COMPLEXITY]
      VALIDATE: TOOL_TEST_SUITE_V1
    }
    REGISTRY {
      ID: TOOL-261
      VERSION: 1.0.0
      MARKETPLACE: VOIS_MARKETPLACE
    }
  }

═══ INTEGRATION POINTS ═══

- Tools deployed into WFL workflows.
- Registered in marketplace (BCL/IIL).
- Used in SPL learning and EDL education.
- Monitored by MML.
- Created via CXL creation pipeline.
- Tested via EXL experiments.

═══ TERMINAL BINDINGS ═══

Every terminal:
  - Can scaffold tools from TSL templates.
  - Registers new tools with Atlas.
  - Validates tools before deployment.

═══ ATLAS BINDINGS ═══

Atlas:
  - Maintains the tool registry.
  - Validates tool quality and safety.
  - Distributes tools across terminals.
