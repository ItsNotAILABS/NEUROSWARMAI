---
name: Atlas Configuration Language
id: acl
layer: Worlds
version: 1.0.0
status: stable
phi_sync: true
phi_beat: 873ms

domain:
  description: >
    ACL defines the ontology, archetypes, and relationships that Atlas uses to organize and connect all entities.
  scope: [ontology, archetypes, entity-relationships]

core_concepts:
  - ONTOLOGY
  - ARCHETYPE
  - RELATIONSHIP
  - REGISTER
  - CLASSIFY
  - CONNECT
  - EVOLVE
  - PRUNE

syntax:
  form: ontology-blocks
  primary_block: ONTOLOGY
  encoding: yaml
  schema:
    entity_types: [string]
    relation_types: [string]
    artefact_types: [string]


storage:
  extension: .acl
  location: atlas/ontology.acl

integration:
  constrained_by: [CPL-L]
  feeds_into: [RSL, TPL]
  consumed_by: [Atlas]

terminal_binding: Every terminal registers itself using ACL entity types
atlas_binding: ACL is Atlas's primary configuration language
---
╔══════════════════════════════════════════════════════════════════╗
║  ACL — ATLAS CONFIGURATION LANGUAGE                              ║
║  Stack: VI — Worlds, Realms, Atlas, Terminals                    ║
║  Version: 1.0.0 · φ-Aligned                                     ║
╚══════════════════════════════════════════════════════════════════╝

═══ PURPOSE ═══

ACL defines the ontology, archetypes, and relationships that Atlas
uses to understand and govern the entire Cognitive Cosmos.

═══ SYNTAX ═══

  ONTOLOGY <name> {
    ENTITY_TYPE <name> {
      PROPERTIES: [<prop>, ...]
      INHERITS: <parent_type>
      CONSTRAINTS: [<rule>, ...]
    }
    RELATIONSHIP <name> {
      FROM: <entity_type>
      TO: <entity_type>
      CARDINALITY: ONE_TO_ONE | ONE_TO_MANY | MANY_TO_MANY
      PROPERTIES: [<prop>, ...]
    }
    ARCHETYPE <name> {
      BASE: <entity_type>
      TEMPLATE: { <defaults> }
      SPAWNABLE: <boolean>
    }
  }

═══ SEMANTICS ═══

- ENTITY_TYPEs define the categories of things in the cosmos.
- RELATIONSHIPs define how entity types connect.
- ARCHETYPEs are pre-configured templates for common entities.
- The ontology is hierarchical with inheritance.
- Atlas reads ACL to understand the structure of reality.

═══ EXAMPLES ═══

  ONTOLOGY COGNITIVE_COSMOS {
    ENTITY_TYPE TERMINAL {
      PROPERTIES: [id, name, capabilities, state, health]
      INHERITS: ENTITY
      CONSTRAINTS: [HAS_TPL, HAS_CPL_L, HAS_CIL]
    }
    ENTITY_TYPE ORGANISM {
      PROPERTIES: [id, name, charter, psyche, identity]
      INHERITS: ENTITY
      CONSTRAINTS: [HAS_OCL, HAS_PIL, HAS_SIL]
    }
    RELATIONSHIP HOSTS {
      FROM: TERMINAL
      TO: ORGANISM
      CARDINALITY: ONE_TO_MANY
    }
    ARCHETYPE SOVEREIGN_TERMINAL {
      BASE: TERMINAL
      TEMPLATE: { capabilities: ALL_40_LANGUAGES, governance: TRUE }
      SPAWNABLE: FALSE
    }
  }

═══ INTEGRATION POINTS ═══

- Read by Atlas for governance decisions.
- Defines the schema for RSL realms.
- Types referenced by all other languages.
- Evolved by UEL and LML.
- Versioned in TIL.

═══ TERMINAL BINDINGS ═══

Every terminal:
  - Registers itself using ACL entity types.
  - Reports its archetype to Atlas.
  - Validates its relationships against ACL schema.

═══ ATLAS BINDINGS ═══

Atlas:
  - ACL is Atlas's primary configuration language.
  - All governance decisions reference ACL ontology.
  - Atlas validates the cosmos against ACL constraints.
