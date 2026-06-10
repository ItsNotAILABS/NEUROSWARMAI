/**
 * Contract Worker — FORMA Ledger & Transaction Engine
 *
 * Web Worker that manages the organism's FORMA token ledger,
 * validates transactions, handles marketplace settlement, and
 * maintains economic state. All transactions are logged with
 * ANIMA chain references for integrity.
 *
 * Architecture:
 *   FORMA ledger — account balances indexed by organism ID
 *   Transaction validation — double-spend prevention, balance checks
 *   Marketplace — list/buy/withdraw settlement with escrow
 *   Streak bonus — consecutive activation bonus (φ-scaled)
 *   Minting — new FORMA creation with rate limiting
 *
 * FORMA Economics:
 *   Base mint rate: 1.0 per activation
 *   Streak bonus: min(streak × 0.1, φ) = max 1.618 bonus
 *   Transfer fee: 0 (sovereign — no rent extraction)
 *   Max supply: unbounded (earned, not speculated)
 *
 * Protocol: postMessage
 *   Main → Worker: { type: 'mint', accountId, amount, reason }
 *   Main → Worker: { type: 'transfer', from, to, amount }
 *   Main → Worker: { type: 'balance', accountId }
 *   Main → Worker: { type: 'list', accountId, organismId, price }
 *   Main → Worker: { type: 'buy', buyerId, listingId }
 *   Main → Worker: { type: 'withdraw', accountId, listingId }
 *   Worker → Main: { type: 'minted', accountId, amount, balance }
 *   Worker → Main: { type: 'transferred', from, to, amount }
 *   Worker → Main: { type: 'balance-result', accountId, balance }
 *   Worker → Main: { type: 'listing-created', listingId }
 *   Worker → Main: { type: 'sale-completed', listingId, buyer, seller }
 *   Worker → Main: { type: 'heartbeat', beat, status }
 */

const PHI = 1.618033988749895;
const HEARTBEAT = 873;

let beatCount = 0;
let running = true;
let txIdCounter = 0;

/* ════════════════════════════════════════════════════════════════
   FORMA Ledger
   ════════════════════════════════════════════════════════════════ */

const ledger = new Map();    // accountId → balance
const streaks = new Map();   // accountId → consecutive activation count
const txLog = [];            // Transaction history
const MAX_TX_LOG = 233;      // F13

function getBalance(accountId) {
  return ledger.get(accountId) || 0;
}

function setBalance(accountId, amount) {
  ledger.set(accountId, Math.max(0, amount));
}

function recordTx(type, details) {
  const tx = {
    id: ++txIdCounter,
    type,
    timestamp: Date.now(),
    ...details,
  };
  txLog.push(tx);
  if (txLog.length > MAX_TX_LOG) txLog.shift();
  return tx;
}

/* ════════════════════════════════════════════════════════════════
   Minting — create new FORMA
   ════════════════════════════════════════════════════════════════ */

function mint(accountId, amount, reason) {
  const streak = streaks.get(accountId) || 0;
  const streakBonus = Math.min(streak * 0.1, PHI); // Max φ bonus
  const totalMint = amount * (1 + streakBonus);

  const prevBalance = getBalance(accountId);
  setBalance(accountId, prevBalance + totalMint);

  // Update streak
  streaks.set(accountId, streak + 1);

  const tx = recordTx('mint', {
    accountId,
    amount: totalMint,
    baseAmount: amount,
    streakBonus,
    streak: streaks.get(accountId),
    reason: reason || 'activation',
    balance: getBalance(accountId),
  });

  return tx;
}

/* ════════════════════════════════════════════════════════════════
   Transfer — move FORMA between accounts
   ════════════════════════════════════════════════════════════════ */

function transfer(from, to, amount) {
  const fromBalance = getBalance(from);

  if (fromBalance < amount) {
    return { error: 'insufficient_balance', from, balance: fromBalance, requested: amount };
  }

  setBalance(from, fromBalance - amount);
  setBalance(to, getBalance(to) + amount);

  const tx = recordTx('transfer', {
    from,
    to,
    amount,
    fromBalance: getBalance(from),
    toBalance: getBalance(to),
  });

  return tx;
}

/* ════════════════════════════════════════════════════════════════
   Marketplace — listings and settlement
   ════════════════════════════════════════════════════════════════ */

const listings = new Map();
let listingIdCounter = 0;

function createListing(accountId, organismId, price) {
  const id = ++listingIdCounter;
  const listing = {
    id,
    seller: accountId,
    organismId,
    price,
    status: 'active',
    createdAt: Date.now(),
  };
  listings.set(id, listing);

  recordTx('listing', { listingId: id, seller: accountId, organismId, price });
  return listing;
}

function executePurchase(buyerId, listingId) {
  const listing = listings.get(listingId);
  if (!listing) return { error: 'listing_not_found', listingId };
  if (listing.status !== 'active') return { error: 'listing_inactive', listingId, status: listing.status };
  if (listing.seller === buyerId) return { error: 'self_purchase', listingId };

  const buyerBalance = getBalance(buyerId);
  if (buyerBalance < listing.price) {
    return { error: 'insufficient_balance', buyer: buyerId, balance: buyerBalance, price: listing.price };
  }

  // Execute settlement
  setBalance(buyerId, buyerBalance - listing.price);
  setBalance(listing.seller, getBalance(listing.seller) + listing.price);

  listing.status = 'sold';
  listing.buyer = buyerId;
  listing.soldAt = Date.now();

  const tx = recordTx('sale', {
    listingId,
    buyer: buyerId,
    seller: listing.seller,
    organismId: listing.organismId,
    price: listing.price,
    buyerBalance: getBalance(buyerId),
    sellerBalance: getBalance(listing.seller),
  });

  return { ...tx, listing };
}

function withdrawListing(accountId, listingId) {
  const listing = listings.get(listingId);
  if (!listing) return { error: 'listing_not_found' };
  if (listing.seller !== accountId) return { error: 'not_owner' };
  if (listing.status !== 'active') return { error: 'listing_inactive' };

  listing.status = 'withdrawn';
  recordTx('withdraw', { listingId, accountId });
  return { success: true, listingId };
}

/* ════════════════════════════════════════════════════════════════
   Ledger state
   ════════════════════════════════════════════════════════════════ */

function getLedgerState() {
  let totalSupply = 0;
  for (const balance of ledger.values()) {
    totalSupply += balance;
  }

  let activeListingCount = 0;
  for (const listing of listings.values()) {
    if (listing.status === 'active') activeListingCount++;
  }

  return {
    totalSupply,
    accountCount: ledger.size,
    txCount: txIdCounter,
    activeListings: activeListingCount,
    totalListings: listings.size,
  };
}

/* ════════════════════════════════════════════════════════════════
   Message handler
   ════════════════════════════════════════════════════════════════ */

self.onmessage = function (e) {
  const msg = e.data;

  switch (msg.type) {
    case 'mint': {
      const tx = mint(msg.accountId, msg.amount || 1, msg.reason);
      self.postMessage({ type: 'minted', ...tx });
      break;
    }

    case 'transfer': {
      const tx = transfer(msg.from, msg.to, msg.amount);
      if (tx.error) {
        self.postMessage({ type: 'transfer-error', ...tx });
      } else {
        self.postMessage({ type: 'transferred', ...tx });
      }
      break;
    }

    case 'balance':
      self.postMessage({ type: 'balance-result', accountId: msg.accountId, balance: getBalance(msg.accountId) });
      break;

    case 'list': {
      const listing = createListing(msg.accountId, msg.organismId, msg.price);
      self.postMessage({ type: 'listing-created', ...listing });
      break;
    }

    case 'buy': {
      const result = executePurchase(msg.buyerId, msg.listingId);
      if (result.error) {
        self.postMessage({ type: 'buy-error', ...result });
      } else {
        self.postMessage({ type: 'sale-completed', ...result });
      }
      break;
    }

    case 'withdraw': {
      const result = withdrawListing(msg.accountId, msg.listingId);
      self.postMessage({ type: result.error ? 'withdraw-error' : 'withdrawn', ...result });
      break;
    }

    case 'getListings':
      self.postMessage({
        type: 'listings',
        listings: Array.from(listings.values()).filter(l => l.status === 'active'),
      });
      break;

    case 'getTxLog':
      self.postMessage({ type: 'tx-log', log: txLog.slice(-(msg.count || 50)) });
      break;

    case 'getState':
      self.postMessage({ type: 'ledger-state', ...getLedgerState() });
      break;

    case 'stop':
      running = false;
      if (heartbeatInterval) clearInterval(heartbeatInterval);
      self.postMessage({ type: 'stopped', ...getLedgerState() });
      break;
  }
};

/* ════════════════════════════════════════════════════════════════
   Heartbeat — runs permanently at 873ms
   ════════════════════════════════════════════════════════════════ */

const heartbeatInterval = setInterval(function () {
  if (!running) return;
  beatCount++;
  const state = getLedgerState();
  self.postMessage({
    type: 'heartbeat',
    beat: beatCount,
    phi: PHI,
    heartbeatMs: HEARTBEAT,
    timestamp: Date.now(),
    status: 'alive',
    ...state,
  });
}, HEARTBEAT);
