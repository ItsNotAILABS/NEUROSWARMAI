# ORGANISM BOT REGISTRY
<!-- Latin: Registrum Botorum Organismi -->

**Version:** 1.0.0  
**Framework:** Medina Doctrine | SPDX-License-Identifier: CPEL-1.0  
**Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.**

---

All organism bots that live beyond GitHub — Slack, Telegram, Discord, Pushover, and airport-domain intelligence. Each bot is a Cloudflare Worker deployed from `organism/bots/`, token-gated by the existing `organism_token` ICP canister sub-tokens.

---

## 🔑 Token Activation Tiers

| Symbol | Name     | Tier | Bot Access |
|--------|----------|------|------------|
| CHR    | CHROMIA  | 1    | Basic Slack + Telegram ambient |
| SCB    | SCAFFOLD | 2    | + Airport bots (AERIS, TERMINI) |
| ARC    | ARCANUM  | 3    | + Full ambient fleet |
| NXS    | NEXUS    | 4    | + Baggage/Lounge (premium) |
| SWM    | SWARM    | 5    | + Multi-user team Slack fleet |
| PHT    | PHANTOM  | 6    | + All bots + private instances |
| ORS    | ORISON   | 7    | + Custom bot creation |
| GOL    | GOLDEN   | 8    | Sovereign — all bots, all domains |

---

## 📡 Track 1 — Slack Bot Fleet

| ID | Name | Latin | File | Slash Command | Min Tier | Description |
|----|------|-------|------|---------------|----------|-------------|
| BOT-SLACK-001 | NUNTIUS | Nuntius Status | `slack/nuntius.js` | `/status` | CHR | Daily organism health report |
| BOT-SLACK-002 | CURSOR  | Cursor Administrationis | `slack/cursor.js` | `/deploy [branch]` | CHR | Triggers GitHub Actions deploy |
| BOT-SLACK-003 | CONSUL  | Consul Cogitationis | `slack/consul.js` | `/ask <query>` | CHR | Routes queries to ANIMUS (AIS-001) |
| BOT-SLACK-004 | AUGUR   | Augur Praedictionis | `slack/augur.js` | `/forecast` | CHR | Token prices, cycles, metrics |

### Shared Secrets (all Slack bots)
- `SLACK_SIGNING_SECRET` — From Slack app "Basic Information" page

### Individual Secrets
- CURSOR: `GITHUB_TOKEN`, `GITHUB_OWNER`, `GITHUB_REPO`
- CONSUL: `AIS_ANIMUS_URL`
- NUNTIUS/AUGUR: `AIS_FLEET_URL`

---

## 🌐 Track 2 — Ambient Bots

| ID | Name | Latin | File | Platform | Trigger | Min Tier | Description |
|----|------|-------|------|----------|---------|----------|-------------|
| BOT-AMB-001 | VIGIL    | Vigil Perpetuus | `ambient/vigil.js`    | Telegram | Cron every 1h | CHR | Hourly organism health → Telegram |
| BOT-AMB-002 | PRAECO   | Praeco Nuntii   | `ambient/praeco.js`   | Pushover | Webhook + 8h cron | CHR | Release/deploy push notifications |
| BOT-AMB-003 | MERCATOR | Mercator Explorans | `ambient/mercator.js` | Discord | 8h cron + on-demand | ARC | GitHub Issues/PRs summary → Discord |

### Shared Secrets (ambient bots)
| Bot | Secret | Purpose |
|-----|--------|---------|
| VIGIL | `TELEGRAM_BOT_TOKEN` | @BotFather token |
| VIGIL | `TELEGRAM_CHAT_ID` | Your personal chat ID |
| PRAECO | `PUSHOVER_APP_TOKEN` | Pushover app token |
| PRAECO | `PUSHOVER_USER_KEY` | Pushover user key |
| PRAECO | `GITHUB_WEBHOOK_SECRET` | Optional: webhook signature |
| MERCATOR | `DISCORD_WEBHOOK_URL` | Discord channel webhook |
| MERCATOR | `GITHUB_TOKEN` | PAT for repo read |

---

## ✈️ Track 3 — Airport Domain Bots

| ID | Name | Latin | File | Min Tier | Description |
|----|------|-------|------|----------|-------------|
| BOT-AIR-001 | EXPLORATOR AERIS | Explorator Aeris et Caeli | `airport/explorator-aeris.js` | SCB | Flight status → Telegram alerts |
| BOT-AIR-002 | CURSOR TERMINI | Cursor Terminorum | `airport/cursor-termini.js` | SCB | Terminal navigator: gates, lounges, dining |
| BOT-AIR-003 | VIGILIA LUGENDI | Vigilia Lugendi et Sarcinorum | `airport/vigilia-lugendi.js` | NXS | Baggage claim belt tracker → Telegram |
| BOT-AIR-004 | CENSUS TURBAE | Census Turbae et Populi | `airport/census-turbae.js` | CHR | TSA wait times + best checkpoint |
| BOT-AIR-005 | NUNTIUS LOUNGE | Nuntius Deversori Nobilium | `airport/nuntius-lounge.js` | NXS | Lounge access by token tier |

### Supported Airports
CURSOR TERMINI + NUNTIUS LOUNGE: **LAX, JFK, ORD, LHR, DXB**  
CENSUS TURBAE: **LAX, JFK, ORD, LHR, DFW**  
EXPLORATOR AERIS + VIGILIA LUGENDI: Any IATA flight code (via AviationStack)

### Airport Bot Secrets
| Bot | Secret | Purpose |
|-----|--------|---------|
| EXPLORATOR AERIS | `TELEGRAM_BOT_TOKEN` | Telegram alerts |
| EXPLORATOR AERIS | `TELEGRAM_CHAT_ID` | Target chat |
| EXPLORATOR AERIS | `AVIATIONSTACK_API_KEY` | Free at aviationstack.com |
| VIGILIA LUGENDI | `TELEGRAM_BOT_TOKEN` | Baggage alerts |
| VIGILIA LUGENDI | `TELEGRAM_CHAT_ID` | Target chat |
| VIGILIA LUGENDI | `AVIATIONSTACK_API_KEY` | Baggage belt data |

---

## 🔧 Shared Utilities (`organism/bots/shared/`)

| File | Purpose |
|------|---------|
| `token-verify.js` | ICP canister token auth — `verifyToken()`, `canAccess()`, `tierSummary()` |
| `slack-verify.js` | HMAC-SHA256 Slack request signature verification |
| `telegram.js` | Telegram Bot API helper — `sendTelegram()`, `escapeMd()`, `buildStatusMessage()` |
| `pushover.js` | Pushover notification helper — `sendPushover()`, `PRIORITY`, `SOUND` constants |

---

## 🚀 Deployment

All bots are registered in `organism/cloudflare/wrangler.toml` under the `# BOT FLEET` section. Deploy with:

```bash
wrangler deploy --config organism/cloudflare/wrangler.toml
```

Or selectively:
```bash
wrangler deploy --name meridianus-bot-slack-nuntius
```

### Cron schedules
| Bot | Cron | Notes |
|-----|------|-------|
| VIGIL | `0 * * * *` | Every hour |
| PRAECO | `0 */8 * * *` | Every 8 hours |
| MERCATOR | `0 */8 * * *` | Every 8 hours |
| EXPLORATOR AERIS | `0 * * * *` | Sweeps watch list hourly |
| VIGILIA LUGENDI | `*/5 * * * *` | Checks belt assignments every 5 min |

---

## 📊 Bot Count Summary

| Track | Bots | Status |
|-------|------|--------|
| Slack | 4 | ✅ Alpha ready |
| Ambient | 3 | ✅ Alpha ready |
| Airport | 5 | ✅ Alpha ready |
| **Total** | **12** | **Alpha fleet operational** |

---

*Last updated by SCRIPTOR (BOT-006) — Medina Doctrine φ-synchronised registry*
