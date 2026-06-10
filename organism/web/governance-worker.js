/**
 * Governance Worker — GOVERNANCE-001–021: Sovereign Governance Engine
 */
const PHI = 1.618033988749895;
const PHI_INV = 1 / PHI;
const PHI_BEAT = 873;
const F7=13,F8=21,F9=34,F10=55,F11=89,F12=144,F13=233,F14=377,F15=610,F16=987,F17=1597,F18=2584;
const PROPOSAL_INTERVAL = F11; // 89 beats
const EPOCH_INTERVAL    = F14; // 377 beats (F14)
let beatCount = 0, proposalCounter = 0, decreeCounter = 0, epochCounter = 0;

const TOOL_REGISTRY = [
  { id: 'GOVERNANCE-001', name: 'propose',     category: 'core',      description: 'Submit a governance proposal' },
  { id: 'GOVERNANCE-002', name: 'vote',        category: 'core',      description: 'Cast a vote on a proposal' },
  { id: 'GOVERNANCE-003', name: 'ratify',      category: 'core',      description: 'Ratify an approved proposal' },
  { id: 'GOVERNANCE-004', name: 'veto',        category: 'core',      description: 'Veto a proposal' },
  { id: 'GOVERNANCE-005', name: 'amend',       category: 'core',      description: 'Amend the constitution' },
  { id: 'GOVERNANCE-006', name: 'dissolve',    category: 'core',      description: 'Dissolve a governing body' },
  { id: 'GOVERNANCE-007', name: 'decree',      category: 'core',      description: 'Issue a sovereign decree' },
  { id: 'GOVERNANCE-008', name: 'delegate',    category: 'core',      description: 'Delegate voting power' },
  { id: 'GOVERNANCE-009', name: 'revoke',      category: 'core',      description: 'Revoke delegation or decree' },
  { id: 'GOVERNANCE-010', name: 'quorum',      category: 'core',      description: 'Check if quorum is met' },
  { id: 'GOVERNANCE-011', name: 'tally',       category: 'read',      description: 'Tally votes for a proposal' },
  { id: 'GOVERNANCE-012', name: 'constitution',category: 'read',      description: 'Read constitutional articles' },
  { id: 'GOVERNANCE-013', name: 'ledger',      category: 'read',      description: 'View vote ledger' },
  { id: 'GOVERNANCE-014', name: 'registry',    category: 'read',      description: 'View decree registry' },
  { id: 'GOVERNANCE-015', name: 'epoch',       category: 'admin',     description: 'Transition governance epoch' },
  { id: 'GOVERNANCE-016', name: 'snapshot',    category: 'admin',     description: 'Snapshot governance state' },
  { id: 'GOVERNANCE-017', name: 'audit',       category: 'admin',     description: 'Audit governance actions' },
  { id: 'GOVERNANCE-018', name: 'report',      category: 'reporting', description: 'Governance status report' },
  { id: 'GOVERNANCE-019', name: 'notify',      category: 'reporting', description: 'Notify stakeholders' },
  { id: 'GOVERNANCE-020', name: 'export',      category: 'admin',     description: 'Export governance data' },
  { id: 'GOVERNANCE-021', name: 'health',      category: 'admin',     description: 'Governance health check' },
];

// Constitution — immutable core articles
const CONSTITUTION = Object.freeze([
  { article: 1, text: 'Sovereignty is inalienable and derives from the collective will of participants.' },
  { article: 2, text: 'All proposals require a quorum of PHI^-1 (≈61.8%) of voting power to be valid.' },
  { article: 3, text: 'Ratification requires simple majority (>50%) of votes cast.' },
  { article: 4, text: 'Vetoes require a supermajority of PHI (≈61.8%) of total voting power.' },
  { article: 5, text: 'Decrees issued by sovereign authority are binding until revoked or epoch transition.' },
  { article: 6, text: 'Epoch transitions occur every F14=377 beats and reset transient governance state.' },
  { article: 7, text: 'Constitutional amendments require unanimous consent of all registered sovereigns.' },
  { article: 8, text: 'The governance ledger is append-only and immutable.' },
]);

const QUORUM_THRESHOLD = PHI_INV;    // ~0.618
const RATIFY_THRESHOLD = 0.5;
const VETO_THRESHOLD   = PHI_INV;

// State
const proposalQueue  = [];
const voteLedger     = new Map(); // proposalId → { for, against, abstain, voters: Set }
const decreeRegistry = new Map();
const delegations    = new Map(); // voterId → delegateeId
const voterPower     = new Map(); // voterId → weight (default PHI_INV)
const auditLog       = [];
const MAX_AUDIT      = F15;

// Seed voters
['sovereign-1','sovereign-2','sovereign-3','sovereign-4','sovereign-5'].forEach((id, i) =>
  voterPower.set(id, Math.pow(PHI, i) * PHI_INV)
);

function totalPower() { return [...voterPower.values()].reduce((s, w) => s + w, 0); }

function makeProposal({ title, description, proposedBy = 'system', type = 'standard' }) {
  const id = `PROP-${String(++proposalCounter).padStart(6, '0')}`;
  const proposal = { id, title, description, proposedBy, type, status: 'open', createdAt: Date.now(), closedAt: null };
  proposalQueue.push(proposal);
  voteLedger.set(id, { for: 0, against: 0, abstain: 0, voters: new Set() });
  auditLog.push({ action: 'propose', proposalId: id, actor: proposedBy, ts: Date.now() });
  if (auditLog.length > MAX_AUDIT) auditLog.shift();
  return proposal;
}

function castVote(proposalId, voterId, vote = 'for') {
  const proposal = proposalQueue.find(p => p.id === proposalId);
  if (!proposal || proposal.status !== 'open') return { error: 'invalid_proposal' };
  const tally = voteLedger.get(proposalId);
  if (tally.voters.has(voterId)) return { error: 'already_voted' };
  const power = voterPower.get(voterId) || PHI_INV;
  tally[vote] = (tally[vote] || 0) + power;
  tally.voters.add(voterId);
  auditLog.push({ action: 'vote', proposalId, voterId, vote, power, ts: Date.now() });
  if (auditLog.length > MAX_AUDIT) auditLog.shift();
  return { proposalId, voterId, vote, power };
}

function tallyProposal(proposalId) {
  const tally = voteLedger.get(proposalId);
  if (!tally) return null;
  const total = totalPower();
  const participation = (tally.for + tally.against + tally.abstain) / total;
  const forShare = (tally.for + tally.against) > 0 ? tally.for / (tally.for + tally.against) : 0;
  return { proposalId, ...tally, voters: tally.voters.size, participation: participation.toFixed(4), forShare: forShare.toFixed(4), quorumMet: participation >= QUORUM_THRESHOLD, passesRatification: participation >= QUORUM_THRESHOLD && forShare > RATIFY_THRESHOLD };
}

function ratifyProposal(proposalId) {
  const tally = tallyProposal(proposalId);
  const proposal = proposalQueue.find(p => p.id === proposalId);
  if (!proposal || !tally) return { error: 'unknown_proposal' };
  if (!tally.passesRatification) return { error: 'insufficient_votes', tally };
  proposal.status = 'ratified';
  proposal.closedAt = Date.now();
  auditLog.push({ action: 'ratify', proposalId, ts: Date.now() });
  return { proposalId, status: 'ratified', tally };
}

function vetoProposal(proposalId, vetoedBy) {
  const proposal = proposalQueue.find(p => p.id === proposalId);
  if (!proposal) return { error: 'unknown_proposal' };
  const power = voterPower.get(vetoedBy) || 0;
  const total = totalPower();
  if (power / total < VETO_THRESHOLD) return { error: 'insufficient_veto_power' };
  proposal.status = 'vetoed';
  proposal.closedAt = Date.now();
  auditLog.push({ action: 'veto', proposalId, vetoedBy, ts: Date.now() });
  return { proposalId, status: 'vetoed' };
}

function issueDecree({ title, content, issuedBy = 'sovereign' }) {
  const id = `DECREE-${String(++decreeCounter).padStart(4, '0')}`;
  const decree = { id, title, content, issuedBy, issuedAt: Date.now(), status: 'active', epoch: epochCounter };
  decreeRegistry.set(id, decree);
  auditLog.push({ action: 'decree', decreeId: id, issuedBy, ts: Date.now() });
  return decree;
}

function epochTransition() {
  epochCounter++;
  // Revoke non-constitutional decrees from prior epoch
  let revoked = 0;
  for (const [id, decree] of decreeRegistry) {
    if (decree.epoch < epochCounter - 1 && decree.status === 'active') {
      decree.status = 'expired';
      revoked++;
    }
  }
  // Close old proposals
  for (const p of proposalQueue) {
    if (p.status === 'open') { p.status = 'expired'; p.closedAt = Date.now(); }
  }
  self.postMessage({ type: 'governance:epoch', epoch: epochCounter, revokedDecrees: revoked, beat: beatCount, ts: Date.now() });
}

function checkPendingProposals() {
  const open = proposalQueue.filter(p => p.status === 'open');
  for (const p of open) {
    const tally = tallyProposal(p.id);
    if (tally && tally.passesRatification) ratifyProposal(p.id);
  }
  self.postMessage({ type: 'governance:scan', openProposals: open.length, beat: beatCount, ts: Date.now() });
}

// Seed initial decrees
issueDecree({ title: 'System Initialisation', content: 'Governance engine initialised at genesis epoch.', issuedBy: 'system' });
issueDecree({ title: 'PHI Weighting Standard', content: `All voting power and quorum calculations use PHI=${PHI} as the golden ratio constant.`, issuedBy: 'system' });

setInterval(() => {
  beatCount++;
  if (beatCount % PROPOSAL_INTERVAL === 0) checkPendingProposals();
  if (beatCount % EPOCH_INTERVAL    === 0) epochTransition();
  self.postMessage({ type: 'heartbeat', beat: beatCount, epoch: epochCounter, openProposals: proposalQueue.filter(p=>p.status==='open').length, decrees: decreeRegistry.size, ts: Date.now() });
}, PHI_BEAT);

self.onmessage = function(e) {
  const { type, ...payload } = e.data || {};
  switch (type) {
    case 'query:proposals': {
      const { status } = payload;
      const list = status ? proposalQueue.filter(p => p.status === status) : proposalQueue;
      self.postMessage({ type: 'result:proposals', proposals: list, total: list.length, ts: Date.now() });
      break;
    }
    case 'query:votes': {
      const { proposalId } = payload;
      self.postMessage({ type: 'result:votes', tally: tallyProposal(proposalId), ts: Date.now() });
      break;
    }
    case 'query:constitution':
      self.postMessage({ type: 'result:constitution', articles: CONSTITUTION, epoch: epochCounter, ts: Date.now() });
      break;
    case 'call:propose': {
      const proposal = makeProposal(payload);
      self.postMessage({ type: 'result:propose', proposalId: proposal.id, ts: Date.now() });
      break;
    }
    case 'call:vote': {
      const { proposalId, voterId, vote } = payload;
      const result = castVote(proposalId, voterId, vote);
      self.postMessage({ type: 'result:vote', ...result, ts: Date.now() });
      break;
    }
    case 'call:ratify': {
      const { proposalId } = payload;
      self.postMessage({ type: 'result:ratify', ...ratifyProposal(proposalId), ts: Date.now() });
      break;
    }
    case 'call:veto': {
      const { proposalId, vetoedBy } = payload;
      self.postMessage({ type: 'result:veto', ...vetoProposal(proposalId, vetoedBy), ts: Date.now() });
      break;
    }
    case 'call:decree': {
      const decree = issueDecree(payload);
      self.postMessage({ type: 'result:decree', decree, ts: Date.now() });
      break;
    }
    default:
      self.postMessage({ type: 'error', error: 'unknown_type', received: type, ts: Date.now() });
  }
};
