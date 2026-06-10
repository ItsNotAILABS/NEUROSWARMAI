# MAQUE — Message Artifact Query Unit Exchange
## Nova Internal Communication Protocol · v0.13.0

> **MAQUE is the language between machines. Every component of the organism speaks it.**

---

## What Is MAQUE?

MAQUE is not HTTP. It is not REST. It is not a queue. MAQUE is the protocol of identity — every message knows who sent it, who receives it, which processing thread (VIVI) it belongs to, and which FLOS pathway it travels.

### Four-Part Structure
```
MAQUE Message = {
  from:  QUAD,        // 4-letter sender code  (e.g. ANIM, LING, CURA)
  to:    QUAD,        // 4-letter receiver code
  verb:  string,      // 'query' | 'respond' | 'notify' | 'route' | 'report'
  via:   FLOS,        // Flow pathway name     (e.g. THINK, BUILD, TRUTH)
  vivi:  VIVI_ID,     // Processing vehicle ID
  phi:   number,      // φ-beat timestamp (873ms aligned)
  seq:   F(n),        // Fibonacci sequence number
  body:  {}           // Payload — any shape
}
```

---

## QUAD — Named Artifacts (4-letter codes)

Every engine, bot, agent, and protocol has a QUAD code. Four letters, full identity:

| QUAD | Full Name        | Role                         |
|------|-----------------|------------------------------|
| ANIM | ANIMUS           | Reasoning engine             |
| LING | LINGUA           | Language engine              |
| OPTI | OPTICA           | Vision engine                |
| MEMO | MEMORIA          | Memory engine                |
| FABR | FABRICA          | Build engine                 |
| PROP | PROPHETA         | Prediction engine            |
| VERI | VERITAS          | Truth engine                 |
| KOSM | KOSMOS           | Universe engine              |
| TACT | TACTUS           | Somatic engine               |
| NEXU | NEXUS            | Mesh/routing engine          |
| AEDI | AEDIFICATOR      | Builder bot                  |
| MEDI | MEDICUS          | Auto-fixer bot               |
| CURA | CURATOR          | PM/sprint bot                |
| LEGA | LEGATUS          | Code-quality bot             |
| AUCT | AUCTOR           | Research journal bot         |
| SALU | SALUS            | Health report bot            |
| PROG | PROGRESSUS       | Progress report bot          |
| COGN | COGNITIO         | Intelligence report bot      |
| CREA | CREATOR          | Creator economy report bot   |
| SOVR | SOVEREIGN        | Master agent                 |
| MERI | MERIDIANUS       | Architect agent              |
| ORGA | ORGANISM         | Engineer agent               |
| MAGI | MAGISTER         | Visionary agent              |
| MAQU | MAQUE            | This protocol                |
| VIVI | VIVI             | Processing vehicle           |
| FLOS | FLOS             | Flow substrate               |
| APEX | APEX             | Artifact format              |
| GRAM | GRAM             | Registry matrix              |

---

## VIVI — Viviarium Internal Vehicle Intelligence

VIVI is the processing context thread. It is spawned once and travels with the computation through every engine in a FLOS pathway. It accumulates state, agents, and history. It is the "consciousness" of a single unit of work.

```json
{
  "id":        "VIVI-ANIM-a3f9c1d2",
  "born":      1715126400000,
  "agents":    ["ANIM", "LING", "MEMO"],
  "history":   ["APEX-ANIM-F13-...", "APEX-LING-F21-..."],
  "coherence": 0.618,
  "depth":     3,
  "alive":     true,
  "phi_beat":  873
}
```

A VIVI can spawn child VIVIs for parallel FLOS paths. The organism can work on many things simultaneously — this is the **fleet multiplication** pattern.

---

## APEX — Artifact Protocol Exchange

Every artifact produced by the organism is wrapped in an APEX envelope:

```json
{
  "apex": {
    "id":        "APEX-AUCT-F13-1715126400000",
    "type":      "paper",
    "from":      "AUCT",
    "flos":      "THINK",
    "vivi":      "VIVI-AUCT-a3f9c1d2",
    "seq":       13,
    "phi":       0.6180339887,
    "born":      "2026-05-08T00:00:00.000Z",
    "payload":   { "title": "Paper VIII", "content": "..." },
    "signature": "a3f9c1d2e5f8b1c2"
  }
}
```

APEX is **immutable once formed**. The signature is a φ-seeded HMAC-SHA256 of the content.

---

## FLOS — Flow Pathways

```
THINK:  ANIM → LING → MEMO           (reasoning + language + memory)
BUILD:  FABR → AEDI → NEXU           (construction + building + routing)
SEE:    OPTI → KOSM → NEXU           (vision + physics + routing)
FEEL:   TACT → FABR → MEMO           (somatic + build + memory)
TRUTH:  VERI → PROP → ANIM           (truth + prediction + reasoning)
SPEAK:  LING → MEMO → NEXU           (language + memory + routing)
REPORT: ANIM → PROP → VERI → LING    (reason + predict + verify + express)
FULL:   NEXU → [all 10 ALPHA] → NEXU (full civilization pass)
```

---

## Usage

```js
import { message, spawnVivi, apex, route, FLOS, QUADS } from './maque.js';

// Spawn a processing vehicle
const vivi = spawnVivi('ANIM');

// Form a MAQUE message
const msg = message({
  from: 'ANIM', to: 'LING', verb: 'query', via: 'THINK', vivi, body: { input: 'analyze this' }
});

// Route through FLOS pathway with local handlers
const { results, vivi: finalVivi } = await route(msg, vivi, {
  ANIM: async (m, v) => ({ result: { reasoning: 'analysis complete' } }),
  LING: async (m, v) => ({ result: { language: 'output generated' } }),
  MEMO: async (m, v) => ({ result: { stored: true } }),
});

// Produce an APEX artifact
const art = apex({ type: 'analysis', from: 'ANIM', flosPath: 'THINK', viviId: vivi.id, seqIndex: 7, payload: results });
```

---

*MAQUE v0.13.0 · Nova Protocol Layer · φ-synchronized at 873ms*
