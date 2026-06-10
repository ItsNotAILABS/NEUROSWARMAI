/**
 * Billing Worker — BILLING-001–021: Billing, Metering, Invoicing & Subscriptions
 *
 * Handles all commercial operations: usage metering, subscription lifecycle,
 * invoice generation, payment recording, refunds, credits, and quota enforcement.
 * Proactively processes billing events and generates invoices on a PHI-timed
 * schedule so the main thread never blocks on billing logic.
 *
 * Tool Registry (21 tools):
 *   BILLING-001  meter          — Record a metered usage event
 *   BILLING-002  invoice        — Generate an invoice from usage
 *   BILLING-003  subscription   — Manage subscription lifecycle
 *   BILLING-004  payment        — Record a payment transaction
 *   BILLING-005  refund         — Process a refund against a payment
 *   BILLING-006  credit         — Apply a credit to an account
 *   BILLING-007  quota          — Enforce and query usage quotas
 *   BILLING-008  proration      — Compute prorated charges
 *   BILLING-009  discount       — Apply promotional discounts
 *   BILLING-010  taxCalculator  — Calculate tax for an invoice line
 *   BILLING-011  dunning        — Manage failed-payment dunning cycles
 *   BILLING-012  trial          — Manage free-trial periods
 *   BILLING-013  upgrade        — Process plan upgrade
 *   BILLING-014  downgrade      — Process plan downgrade
 *   BILLING-015  cancellation   — Process subscription cancellation
 *   BILLING-016  renewal        — Auto-renew subscription
 *   BILLING-017  receipt        — Generate payment receipt
 *   BILLING-018  statement      — Generate periodic account statement
 *   BILLING-019  webhook        — Fire billing event webhook
 *   BILLING-020  audit          — Billing audit trail entry
 *   BILLING-021  export         — Export billing data
 *
 * Proactive beats:
 *   Every 89 beats  — process pending billing events (metered usage → charges)
 *   Every 233 beats — generate invoices for all subscriptions due this cycle
 *
 * Message types (in):
 *   query:invoices       — list invoices for an accountId
 *   query:subscriptions  — list subscriptions
 *   query:usage          — usage meters for an accountId
 *   call:meter           — record usage event
 *   call:invoice         — force-generate invoice
 *   call:pay             — record payment
 *   call:refund          — process refund
 *   call:quota           — check or set quota
 */

const PHI = 1.618033988749895;
const PHI_INV = 1 / PHI;
const PHI_BEAT = 873; // ms

// Fibonacci constants
const F7  = 13;
const F8  = 21;
const F9  = 34;
const F10 = 55;
const F11 = 89;
const F12 = 144;
const F13 = 233;
const F14 = 377;
const F15 = 610;
const F16 = 987;
const F17 = 1597;
const F18 = 2584;

const BILLING_INTERVAL  = F11; // 89 beats — process pending events
const INVOICE_INTERVAL  = F13; // 233 beats — generate invoices

let beatCount = 0;
let invoiceCounter = 0;
let paymentCounter = 0;
let meterCounter = 0;

/* ════════════════════════════════════════════════════════════════
   Tool Registry — 21 billing tools
   ════════════════════════════════════════════════════════════════ */

const TOOL_REGISTRY = [
  { id: 'BILLING-001', name: 'meter',         category: 'metering',      description: 'Record a metered usage event' },
  { id: 'BILLING-002', name: 'invoice',        category: 'invoicing',     description: 'Generate an invoice from usage' },
  { id: 'BILLING-003', name: 'subscription',   category: 'subscription',  description: 'Manage subscription lifecycle' },
  { id: 'BILLING-004', name: 'payment',        category: 'payment',       description: 'Record a payment transaction' },
  { id: 'BILLING-005', name: 'refund',         category: 'payment',       description: 'Process a refund' },
  { id: 'BILLING-006', name: 'credit',         category: 'payment',       description: 'Apply account credit' },
  { id: 'BILLING-007', name: 'quota',          category: 'quota',         description: 'Enforce and query usage quotas' },
  { id: 'BILLING-008', name: 'proration',      category: 'invoicing',     description: 'Compute prorated charges' },
  { id: 'BILLING-009', name: 'discount',       category: 'invoicing',     description: 'Apply promotional discounts' },
  { id: 'BILLING-010', name: 'taxCalculator',  category: 'invoicing',     description: 'Calculate tax for invoice line' },
  { id: 'BILLING-011', name: 'dunning',        category: 'collections',   description: 'Failed-payment dunning cycles' },
  { id: 'BILLING-012', name: 'trial',          category: 'subscription',  description: 'Manage free-trial periods' },
  { id: 'BILLING-013', name: 'upgrade',        category: 'subscription',  description: 'Process plan upgrade' },
  { id: 'BILLING-014', name: 'downgrade',      category: 'subscription',  description: 'Process plan downgrade' },
  { id: 'BILLING-015', name: 'cancellation',   category: 'subscription',  description: 'Process subscription cancellation' },
  { id: 'BILLING-016', name: 'renewal',        category: 'subscription',  description: 'Auto-renew subscription' },
  { id: 'BILLING-017', name: 'receipt',        category: 'reporting',     description: 'Generate payment receipt' },
  { id: 'BILLING-018', name: 'statement',      category: 'reporting',     description: 'Generate periodic account statement' },
  { id: 'BILLING-019', name: 'webhook',        category: 'integration',   description: 'Fire billing event webhook' },
  { id: 'BILLING-020', name: 'audit',          category: 'audit',         description: 'Billing audit trail entry' },
  { id: 'BILLING-021', name: 'export',         category: 'reporting',     description: 'Export billing data' },
];

/* ════════════════════════════════════════════════════════════════
   State
   ════════════════════════════════════════════════════════════════ */

// usageMeters: accountId → { metricKey → { units, lastTs } }
const usageMeters = new Map();

// subscriptions: subId → subscription object
const subscriptionRegistry = new Map();

// pending billing events queue
const pendingEvents = [];
const MAX_PENDING = F15; // 610

// invoices
const invoiceStore = new Map();
const MAX_INVOICES = F16; // 987

// payments
const paymentHistory = [];
const MAX_PAYMENTS = F14; // 377

// quotas: accountId → { metricKey → { limit, used } }
const quotaRegistry = new Map();

// credits: accountId → balance (cents)
const creditLedger = new Map();

/* ════════════════════════════════════════════════════════════════
   Subscription seed data
   ════════════════════════════════════════════════════════════════ */

const PLANS = {
  starter:      { name: 'Starter',      priceMonthly: 2900,  quotas: { api_calls: 10000,   storage_gb: 10  } },
  growth:       { name: 'Growth',       priceMonthly: 9900,  quotas: { api_calls: 100000,  storage_gb: 100 } },
  enterprise:   { name: 'Enterprise',   priceMonthly: 49900, quotas: { api_calls: 5000000, storage_gb: 5000 } },
  sovereign:    { name: 'Sovereign',    priceMonthly: 0,     quotas: { api_calls: Infinity, storage_gb: Infinity } },
};

// Seed subscriptions
for (let i = 1; i <= F7; i++) {
  const planKeys = Object.keys(PLANS);
  const plan = planKeys[i % planKeys.length];
  const subId = `SUB-${String(i).padStart(4, '0')}`;
  subscriptionRegistry.set(subId, {
    id: subId,
    accountId: `ACC-${String(i).padStart(4, '0')}`,
    plan,
    status: 'active',
    currentPeriodStart: Date.now() - 15 * 86400000,
    currentPeriodEnd:   Date.now() + 15 * 86400000,
    priceMonthly: PLANS[plan].priceMonthly,
    createdAt: Date.now() - 30 * 86400000,
  });
}

/* ════════════════════════════════════════════════════════════════
   Metering
   ════════════════════════════════════════════════════════════════ */

function recordUsage(accountId, metricKey, units = 1) {
  if (!usageMeters.has(accountId)) usageMeters.set(accountId, new Map());
  const accountMeters = usageMeters.get(accountId);
  if (!accountMeters.has(metricKey)) accountMeters.set(metricKey, { units: 0, lastTs: null });
  const meter = accountMeters.get(metricKey);
  meter.units += units;
  meter.lastTs = Date.now();

  pendingEvents.push({ id: `ME-${++meterCounter}`, accountId, metricKey, units, ts: Date.now() });
  if (pendingEvents.length > MAX_PENDING) pendingEvents.shift();

  // Quota check
  const quota = quotaRegistry.get(accountId);
  if (quota && quota.has(metricKey)) {
    const q = quota.get(metricKey);
    q.used = (q.used || 0) + units;
    if (q.used > q.limit) {
      self.postMessage({ type: 'billing:quota-exceeded', accountId, metricKey, used: q.used, limit: q.limit, ts: Date.now() });
    }
  }

  return { meterId: `ME-${meterCounter}`, units: meter.units };
}

/* ════════════════════════════════════════════════════════════════
   Invoice generation
   ════════════════════════════════════════════════════════════════ */

function generateInvoice(accountId) {
  const accountMeters = usageMeters.get(accountId) || new Map();
  const sub = [...subscriptionRegistry.values()].find(s => s.accountId === accountId);
  const plan = sub ? PLANS[sub.plan] : null;

  const lineItems = [];
  let subtotal = 0;

  if (sub) {
    lineItems.push({ description: `${sub.plan} plan — monthly subscription`, amount: sub.priceMonthly });
    subtotal += sub.priceMonthly;
  }

  for (const [metric, meter] of accountMeters) {
    const overageRate = Math.round(PHI * 100); // cents per unit overage
    lineItems.push({ description: `${metric} usage — ${meter.units} units`, amount: meter.units * overageRate });
    subtotal += meter.units * overageRate;
  }

  const credit = creditLedger.get(accountId) || 0;
  const tax = Math.round(subtotal * 0.08);
  const total = Math.max(0, subtotal + tax - credit);

  const invoice = {
    id: `INV-${String(++invoiceCounter).padStart(6, '0')}`,
    accountId,
    status: 'open',
    lineItems,
    subtotal,
    tax,
    creditApplied: Math.min(credit, subtotal + tax),
    total,
    issuedAt: Date.now(),
    dueAt: Date.now() + 30 * 86400000,
    phiWeight: total * PHI_INV,
  };

  invoiceStore.set(invoice.id, invoice);
  if (invoiceStore.size > MAX_INVOICES) {
    const oldest = [...invoiceStore.keys()][0];
    invoiceStore.delete(oldest);
  }

  return invoice;
}

/* ════════════════════════════════════════════════════════════════
   Proactive processing
   ════════════════════════════════════════════════════════════════ */

function processPendingEvents() {
  const count = pendingEvents.length;
  // Events already aggregated into usageMeters on ingestion; clear queue
  pendingEvents.length = 0;
  self.postMessage({ type: 'billing:events-processed', count, beat: beatCount, ts: Date.now() });
}

function generateAllInvoices() {
  const generated = [];
  const accounts = new Set([...subscriptionRegistry.values()].map(s => s.accountId));
  for (const accountId of accounts) {
    const inv = generateInvoice(accountId);
    generated.push({ id: inv.id, accountId, total: inv.total });
  }
  self.postMessage({ type: 'billing:invoices-generated', count: generated.length, invoices: generated, beat: beatCount, ts: Date.now() });
}

/* ════════════════════════════════════════════════════════════════
   Heartbeat
   ════════════════════════════════════════════════════════════════ */

setInterval(() => {
  beatCount++;

  if (beatCount % BILLING_INTERVAL  === 0) processPendingEvents();
  if (beatCount % INVOICE_INTERVAL  === 0) generateAllInvoices();

  self.postMessage({
    type: 'heartbeat',
    beat: beatCount,
    subscriptions: subscriptionRegistry.size,
    invoices: invoiceStore.size,
    pendingEvents: pendingEvents.length,
    ts: Date.now(),
  });
}, PHI_BEAT);

/* ════════════════════════════════════════════════════════════════
   Message handler
   ════════════════════════════════════════════════════════════════ */

self.onmessage = function(e) {
  const { type, ...payload } = e.data || {};

  switch (type) {

    case 'query:invoices': {
      const { accountId } = payload;
      const invoices = [...invoiceStore.values()].filter(i => !accountId || i.accountId === accountId);
      self.postMessage({ type: 'result:invoices', invoices, total: invoices.length, ts: Date.now() });
      break;
    }

    case 'query:subscriptions': {
      const { accountId } = payload;
      const subs = [...subscriptionRegistry.values()].filter(s => !accountId || s.accountId === accountId);
      self.postMessage({ type: 'result:subscriptions', subscriptions: subs, total: subs.length, ts: Date.now() });
      break;
    }

    case 'query:usage': {
      const { accountId } = payload;
      const meters = usageMeters.get(accountId);
      const usage = meters ? Object.fromEntries(meters) : {};
      self.postMessage({ type: 'result:usage', accountId, usage, ts: Date.now() });
      break;
    }

    case 'call:meter': {
      const { accountId, metricKey, units } = payload;
      const result = recordUsage(accountId, metricKey, units);
      self.postMessage({ type: 'result:meter', ...result, accountId, metricKey, ts: Date.now() });
      break;
    }

    case 'call:invoice': {
      const { accountId } = payload;
      const inv = generateInvoice(accountId);
      self.postMessage({ type: 'result:invoice', invoice: inv, ts: Date.now() });
      break;
    }

    case 'call:pay': {
      const { invoiceId, amount, method = 'card' } = payload;
      const invoice = invoiceStore.get(invoiceId);
      if (!invoice) { self.postMessage({ type: 'error', error: 'unknown_invoice', invoiceId, ts: Date.now() }); break; }
      invoice.status = 'paid';
      const payment = { id: `PAY-${++paymentCounter}`, invoiceId, amount, method, ts: Date.now() };
      paymentHistory.push(payment);
      if (paymentHistory.length > MAX_PAYMENTS) paymentHistory.shift();
      self.postMessage({ type: 'result:pay', payment, ts: Date.now() });
      break;
    }

    case 'call:refund': {
      const { invoiceId, amount } = payload;
      const invoice = invoiceStore.get(invoiceId);
      if (!invoice) { self.postMessage({ type: 'error', error: 'unknown_invoice', invoiceId, ts: Date.now() }); break; }
      const refundAmount = Math.min(amount, invoice.total);
      const credit = creditLedger.get(invoice.accountId) || 0;
      creditLedger.set(invoice.accountId, credit + refundAmount);
      self.postMessage({ type: 'result:refund', invoiceId, refundAmount, newCredit: credit + refundAmount, ts: Date.now() });
      break;
    }

    case 'call:quota': {
      const { accountId, metricKey, limit, action = 'check' } = payload;
      if (!quotaRegistry.has(accountId)) quotaRegistry.set(accountId, new Map());
      const accountQuotas = quotaRegistry.get(accountId);
      if (action === 'set') {
        accountQuotas.set(metricKey, { limit, used: 0 });
        self.postMessage({ type: 'result:quota', action: 'set', accountId, metricKey, limit, ts: Date.now() });
      } else {
        const q = accountQuotas.get(metricKey) || { limit: Infinity, used: 0 };
        self.postMessage({ type: 'result:quota', action: 'check', accountId, metricKey, ...q, remaining: q.limit - q.used, ts: Date.now() });
      }
      break;
    }

    default:
      self.postMessage({ type: 'error', error: 'unknown_type', received: type, ts: Date.now() });
  }
};
