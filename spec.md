# Organism Command Platform — ICP Wiring & Math Expansion

## Current State

- Backend `main.mo` has full organism data model (genesis hash, ShellState, Hebbian math, workforce chat, marketplace, seed)
- Backend bindings (`backend.ts`, `backend.did.d.ts`) were generated BEFORE organism types were added — they only contain base infrastructure (blob storage, approval, invite links). No organism endpoints are exposed.
- Frontend uses `MOCK_ORGANISMS` from `organisms.ts` for ALL organism operations. Zero ICP calls for organisms.
- WorkforceChat calls backend mock responses only.
- Live Viewer runs local JS simulation, never touches canister.
- OrganismGenerator creates organisms locally, never on-chain.
- Inventory shows mock data only.
- Marketplace shows mock data only.

## Requested Changes (Diff)

### Add
- Full organism cognitive engine in backend: 26-node Hz topology (inner 12-node Hebbian ring + 14-node expanded brain), 8-channel neurochemistry, coherence, FORMA minting with streak bonus, drive mode tiers
- Expanded shell: 43-core governance layer, compound loops, all seeded from genesis hash
- Artifact storage type: ArtifactRecord with id, organismId, type, title, content, timestamp, owner
- Backend endpoints for artifacts: storeArtifact, getMyArtifacts, getArtifact
- All organism endpoints in bindings: generateOrganism, getMyOrganisms, tickOrganismShell, workforceChat, getWorkforceThread, transferOrganism, listForSale, withdrawFromSale, buyOrganism, getMarketplaceListings, seedPrebuiltOrganisms, getOrganismState
- Frontend ICP hook: `useOrganisms.ts` — fetches from canister, seeds on first admin login
- Frontend ICP hook: `useWorkforceChat.ts` — calls canister workforceChat, stores artifacts
- Real-time Live Viewer: calls `tickOrganismShell` + `getOrganismState` every 3s on-chain
- OrganismGenerator: calls `generateOrganism` on canister
- Auto-seed on admin first login

### Modify
- `backend.ts` and `backend.did.d.ts` — fully regenerated to include all organism types
- `OrganismInventory.tsx` — use real canister organisms instead of MOCK_ORGANISMS
- `OrganismLiveViewer.tsx` — call canister tick; fall back to local sim only if not authenticated
- `WorkforceChat.tsx` — call canister workforceChat; store returned artifacts to canister
- `OrganismGenerator.tsx` — call canister generateOrganism
- `OrganismMarketplace.tsx` — call canister getMarketplaceListings / buyOrganism
- `App.tsx` — trigger seedPrebuiltOrganisms on first admin login

### Remove
- Reliance on `MOCK_ORGANISMS` for live data (keep as fallback only when unauthenticated)

## Implementation Plan

1. Regenerate Motoko with expanded organism types and full cognitive math — includes artifact storage, all endpoints, compound governance layer
2. After generation, bindings auto-update
3. Frontend: create `useOrganisms` hook wiring canister getMyOrganisms + seedPrebuiltOrganisms on admin login
4. Frontend: create `useWorkforceChat` hook wiring canister workforceChat + storeArtifact
5. Wire OrganismInventory, LiveViewer, WorkforceChat, Generator, Marketplace to hooks
6. App.tsx: call seedPrebuiltOrganisms once on first admin login
7. Validate and build
