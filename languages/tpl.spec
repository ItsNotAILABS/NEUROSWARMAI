---
name: Terminal Protocol Language
id: tpl
layer: Worlds
version: 1.0.0
status: stable
phi_sync: true
phi_beat: 873ms

domain:
  description: >
    TPL defines how terminals communicate with Atlas and each other — messages, channels, and protocols.
  scope: [terminal-communication, message-protocols, channels]

core_concepts:
  - MESSAGE
  - CHANNEL
  - HANDSHAKE
  - PRIORITY
  - TTL
  - SIGNATURE
  - BROADCAST
  - HEARTBEAT

syntax:
  form: protocol-blocks
  primary_block: MESSAGE
  encoding: yaml
  schema:
    command: string
    target: string
    payload: object


storage:
  extension: .tpl
  location: protocols/*.tpl

integration:
  constrained_by: [CPL-L]
  feeds_into: [all terminals]
  consumed_by: [all terminals, Atlas]

terminal_binding: Every terminal has a TPL message engine
atlas_binding: Is the central TPL message hub
---
╔══════════════════════════════════════════════════════════════════╗
║  TPL — TERMINAL PROTOCOL LANGUAGE                                ║
║  Stack: VI — Worlds, Realms, Atlas, Terminals                    ║
║  Version: 1.0.0 · φ-Aligned                                     ║
╚══════════════════════════════════════════════════════════════════╝

═══ PURPOSE ═══

TPL defines how terminals communicate with Atlas and each other.
It is the wire protocol of the Cognitive Cosmos — the nervous
system's signaling language.

═══ SYNTAX ═══

  MESSAGE <type> {
    FROM: <terminal_id>
    TO: <terminal_id> | ATLAS | BROADCAST
    PAYLOAD: <data>
    PRIORITY: <fibonacci_number>
    TTL: <hop_count>
    SIGNATURE: <auth_proof>
  }

  CHANNEL <name> {
    PARTICIPANTS: [<terminal>, ...]
    MODE: UNICAST | MULTICAST | BROADCAST
    ENCRYPTION: <algorithm>
    HEARTBEAT: <interval>
  }

  HANDSHAKE {
    INITIATOR: <terminal>
    RESPONDER: <terminal>
    PROTOCOL: [HELLO, CHALLENGE, VERIFY, ESTABLISHED]
  }

═══ SEMANTICS ═══

- MESSAGEs are the fundamental unit of terminal communication.
- Every message is signed for authentication.
- PRIORITY uses Fibonacci scaling (F1=low, F13=critical).
- TTL prevents infinite message propagation.
- CHANNELs are persistent communication paths.
- HANDSHAKEs establish secure terminal-to-terminal connections.

═══ EXAMPLES ═══

  MESSAGE HEALTH_REPORT {
    FROM: TERMINAL_ANIMUS
    TO: ATLAS
    PAYLOAD: { cpu: 0.34, memory: 0.618, uptime: 99.97 }
    PRIORITY: F5
    TTL: 3
    SIGNATURE: ED25519(TERMINAL_ANIMUS.KEY)
  }

  CHANNEL GOVERNANCE_BUS {
    PARTICIPANTS: [ANIMUS, RATIO, MEMORIA, PRUDENTIA, MERIDIANUS]
    MODE: MULTICAST
    ENCRYPTION: AES_256_GCM
    HEARTBEAT: 873ms
  }

═══ INTEGRATION POINTS ═══

- Every terminal speaks TPL.
- Atlas receives and routes TPL messages.
- CPL-L enforcement uses TPL for violation reports.
- CPL-P pipelines communicate via TPL.
- MML metrics are transmitted via TPL.
- SCL scheduling commands use TPL.

═══ TERMINAL BINDINGS ═══

Every terminal:
  - Has a TPL message engine.
  - Maintains channels with Atlas and peers.
  - Performs handshakes before communication.
  - Sends heartbeats on the PHI_BEAT interval.

═══ ATLAS BINDINGS ═══

Atlas:
  - Is the central TPL message hub.
  - Routes messages between terminals.
  - Monitors channel health.
  - Detects communication anomalies.
