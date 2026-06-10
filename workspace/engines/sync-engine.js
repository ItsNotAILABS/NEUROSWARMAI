/**
 * SYNC ENGINE (SYNC) — Collaboration & Cross-Workstation Protocol
 * Nova by FreddyCreates
 * 
 * "Workstations can share context through the collaboration floor."
 * 
 * This engine enables AI-to-AI collaboration:
 * - Real-time context sharing between workstations
 * - Handoff protocols for task continuation
 * - Broadcast channels for organization-wide updates
 * - Consensus mechanisms for shared decisions
 * 
 * @version 0.17.0 (F17)
 * @quad SYNC
 * @ipValue $6.5M USD
 * @copyright Nova Protocol by FreddyCreates
 */

const PHI = 1.618033988749895;
const PHI_BEAT_MS = 873;

// ─── Sync Protocols ──────────────────────────────────────────────────────────
export const SYNC_PROTOCOLS = {
  HANDOFF: {
    name: 'Task Handoff',
    description: 'Transfer task ownership between workstations',
    requiresAck: true
  },
  BROADCAST: {
    name: 'Broadcast',
    description: 'One-to-many notification',
    requiresAck: false
  },
  REQUEST: {
    name: 'Request/Response',
    description: 'Query another workstation',
    requiresAck: true
  },
  SUBSCRIBE: {
    name: 'Subscribe',
    description: 'Subscribe to context updates',
    requiresAck: true
  },
  CONSENSUS: {
    name: 'Consensus',
    description: 'Multi-party agreement',
    requiresAck: true
  }
};

// ─── Channel Types ───────────────────────────────────────────────────────────
export const CHANNEL_TYPES = {
  DIRECT: 'direct',        // Point-to-point
  FLOOR: 'floor',          // Collaboration floor
  BROADCAST: 'broadcast',  // Organization-wide
  TOPIC: 'topic'           // Topic-based subscription
};

// ─── Sync Message ────────────────────────────────────────────────────────────
class SyncMessage {
  constructor({ 
    protocol, 
    from, 
    to, 
    channel, 
    payload, 
    replyTo = null,
    ttl = 60000  // 1 minute default TTL
  }) {
    this.id = `msg-${Date.now()}-${Math.random().toString(36).slice(2, 8)}`;
    this.protocol = protocol;
    this.from = from;           // Workstation ID or AI ID
    this.to = to;               // Workstation ID, AI ID, or channel
    this.channel = channel;     // Channel type
    this.payload = payload;
    this.replyTo = replyTo;     // For response messages
    this.ttl = ttl;
    
    this.createdAt = Date.now();
    this.expiresAt = Date.now() + ttl;
    this.acknowledged = false;
    this.acknowledgedAt = null;
    this.acknowledgedBy = null;
  }
  
  acknowledge(byId) {
    this.acknowledged = true;
    this.acknowledgedAt = Date.now();
    this.acknowledgedBy = byId;
  }
  
  isExpired() {
    return Date.now() > this.expiresAt;
  }
  
  toJSON() {
    return {
      id: this.id,
      protocol: this.protocol,
      from: this.from,
      to: this.to,
      channel: this.channel,
      payload: this.payload,
      replyTo: this.replyTo,
      createdAt: this.createdAt,
      expiresAt: this.expiresAt,
      acknowledged: this.acknowledged,
      acknowledgedAt: this.acknowledgedAt,
      acknowledgedBy: this.acknowledgedBy
    };
  }
}

// ─── Subscription ────────────────────────────────────────────────────────────
class Subscription {
  constructor({ subscriberId, topic, filter = null }) {
    this.id = `sub-${Date.now()}-${Math.random().toString(36).slice(2, 8)}`;
    this.subscriberId = subscriberId;
    this.topic = topic;
    this.filter = filter;  // Optional filter function
    this.createdAt = Date.now();
    this.deliveryCount = 0;
    this.lastDelivery = null;
    this.active = true;
  }
  
  matches(message) {
    if (!this.active) return false;
    if (message.channel !== CHANNEL_TYPES.TOPIC) return false;
    if (message.to !== this.topic) return false;
    if (this.filter && !this.filter(message)) return false;
    return true;
  }
  
  recordDelivery() {
    this.deliveryCount++;
    this.lastDelivery = Date.now();
  }
}

// ─── Handoff Session ─────────────────────────────────────────────────────────
class HandoffSession {
  constructor({ 
    taskId, 
    fromWorkstation, 
    toWorkstation, 
    context,
    reason 
  }) {
    this.id = `handoff-${Date.now()}-${Math.random().toString(36).slice(2, 8)}`;
    this.taskId = taskId;
    this.fromWorkstation = fromWorkstation;
    this.toWorkstation = toWorkstation;
    this.context = context;
    this.reason = reason;
    
    this.status = 'pending';  // pending, accepted, rejected, completed
    this.createdAt = Date.now();
    this.acceptedAt = null;
    this.completedAt = null;
    this.feedback = null;
  }
  
  accept() {
    this.status = 'accepted';
    this.acceptedAt = Date.now();
  }
  
  reject(reason) {
    this.status = 'rejected';
    this.feedback = reason;
  }
  
  complete(feedback = null) {
    this.status = 'completed';
    this.completedAt = Date.now();
    this.feedback = feedback;
  }
  
  toJSON() {
    return {
      id: this.id,
      taskId: this.taskId,
      fromWorkstation: this.fromWorkstation,
      toWorkstation: this.toWorkstation,
      context: this.context,
      reason: this.reason,
      status: this.status,
      createdAt: this.createdAt,
      acceptedAt: this.acceptedAt,
      completedAt: this.completedAt,
      feedback: this.feedback
    };
  }
}

// ─── Consensus Session ───────────────────────────────────────────────────────
class ConsensusSession {
  constructor({ 
    proposerId, 
    topic, 
    proposal, 
    participants,
    threshold = 0.5  // Majority
  }) {
    this.id = `cons-${Date.now()}-${Math.random().toString(36).slice(2, 8)}`;
    this.proposerId = proposerId;
    this.topic = topic;
    this.proposal = proposal;
    this.participants = new Set(participants);
    this.threshold = threshold;
    
    this.votes = new Map();  // participantId -> { vote, reason, timestamp }
    this.status = 'voting';  // voting, passed, failed, expired
    this.createdAt = Date.now();
    this.resolvedAt = null;
    this.ttl = 300000;  // 5 minutes
    this.expiresAt = Date.now() + this.ttl;
  }
  
  vote(participantId, vote, reason = null) {
    if (!this.participants.has(participantId)) {
      return { status: 'error', message: 'Not a participant' };
    }
    
    if (this.votes.has(participantId)) {
      return { status: 'error', message: 'Already voted' };
    }
    
    if (this.status !== 'voting') {
      return { status: 'error', message: 'Voting closed' };
    }
    
    this.votes.set(participantId, {
      vote,
      reason,
      timestamp: Date.now()
    });
    
    // Check if we can resolve
    this._checkResolution();
    
    return { 
      status: 'voted', 
      currentResult: this._getCurrentResult() 
    };
  }
  
  _getCurrentResult() {
    let yes = 0;
    let no = 0;
    
    for (const { vote } of this.votes.values()) {
      if (vote) yes++;
      else no++;
    }
    
    return {
      yes,
      no,
      total: this.participants.size,
      voted: this.votes.size,
      remaining: this.participants.size - this.votes.size,
      yesRatio: this.votes.size > 0 ? yes / this.votes.size : 0
    };
  }
  
  _checkResolution() {
    const result = this._getCurrentResult();
    
    // All voted
    if (result.remaining === 0) {
      this.status = result.yesRatio >= this.threshold ? 'passed' : 'failed';
      this.resolvedAt = Date.now();
      return;
    }
    
    // Early pass (enough yes votes even if others vote no)
    const maxPossibleNo = result.no + result.remaining;
    const minYesRatio = result.yes / (result.yes + maxPossibleNo);
    if (minYesRatio >= this.threshold) {
      this.status = 'passed';
      this.resolvedAt = Date.now();
      return;
    }
    
    // Early fail (impossible to pass)
    const maxPossibleYes = result.yes + result.remaining;
    const maxYesRatio = maxPossibleYes / (maxPossibleYes + result.no);
    if (maxYesRatio < this.threshold) {
      this.status = 'failed';
      this.resolvedAt = Date.now();
    }
  }
  
  isExpired() {
    if (this.status === 'voting' && Date.now() > this.expiresAt) {
      this.status = 'expired';
      this.resolvedAt = Date.now();
      return true;
    }
    return false;
  }
  
  toJSON() {
    return {
      id: this.id,
      proposerId: this.proposerId,
      topic: this.topic,
      proposal: this.proposal,
      participants: Array.from(this.participants),
      threshold: this.threshold,
      votes: Object.fromEntries(this.votes),
      status: this.status,
      result: this._getCurrentResult(),
      createdAt: this.createdAt,
      resolvedAt: this.resolvedAt,
      expiresAt: this.expiresAt
    };
  }
}

// ─── Sync Engine Main Class ──────────────────────────────────────────────────
/**
 * SyncEngine — Collaboration Protocol System
 */
export class SyncEngine {
  static QUAD = 'SYNC';
  static VERSION = '0.17.0';
  static IP_VALUE = 6500000;
  static DOMAIN = 'Collaboration Protocol';
  
  constructor(config = {}) {
    this.config = {
      heartbeat: PHI_BEAT_MS,
      maxMessages: config.maxMessages || 10000,
      maxSubscriptions: config.maxSubscriptions || 1000,
      messageTTL: config.messageTTL || 60000,
      ...config
    };
    
    // Message queues
    this.messageQueue = [];
    this.messageHistory = [];
    
    // Subscriptions
    this.subscriptions = new Map();  // subId -> Subscription
    this.topicSubscribers = new Map();  // topic -> Set(subIds)
    
    // Active sessions
    this.handoffs = new Map();    // handoffId -> HandoffSession
    this.consensus = new Map();   // consensusId -> ConsensusSession
    
    // Registered endpoints
    this.endpoints = new Map();   // endpointId -> { type, handler, ... }
    
    // Stats
    this.stats = {
      messagesSent: 0,
      messagesDelivered: 0,
      messagesExpired: 0,
      handoffsCompleted: 0,
      consensusReached: 0,
      subscriptionsActive: 0,
      lastHeartbeat: Date.now(),
      createdAt: Date.now()
    };
  }
  
  // ─── Endpoint Registration ─────────────────────────────────────────────────
  
  /**
   * Register an endpoint (workstation or AI)
   */
  registerEndpoint(endpointId, config = {}) {
    this.endpoints.set(endpointId, {
      id: endpointId,
      type: config.type || 'workstation',
      garment: config.garment,
      handler: config.handler,  // Optional message handler
      registeredAt: Date.now(),
      lastSeen: Date.now()
    });
    
    return { status: 'registered', endpointId };
  }
  
  /**
   * Unregister an endpoint
   */
  unregisterEndpoint(endpointId) {
    this.endpoints.delete(endpointId);
    
    // Remove subscriptions
    for (const [subId, sub] of this.subscriptions) {
      if (sub.subscriberId === endpointId) {
        this.subscriptions.delete(subId);
      }
    }
    
    return { status: 'unregistered', endpointId };
  }
  
  // ─── Messaging ─────────────────────────────────────────────────────────────
  
  /**
   * Send a direct message
   */
  send(from, to, payload, options = {}) {
    const message = new SyncMessage({
      protocol: options.protocol || 'REQUEST',
      from,
      to,
      channel: CHANNEL_TYPES.DIRECT,
      payload,
      replyTo: options.replyTo,
      ttl: options.ttl || this.config.messageTTL
    });
    
    this._enqueue(message);
    this._deliver(message);
    
    return { 
      status: 'sent', 
      messageId: message.id 
    };
  }
  
  /**
   * Broadcast to all endpoints on a floor
   */
  broadcastFloor(from, floorId, payload) {
    const message = new SyncMessage({
      protocol: 'BROADCAST',
      from,
      to: floorId,
      channel: CHANNEL_TYPES.FLOOR,
      payload
    });
    
    this._enqueue(message);
    
    // Deliver to all endpoints
    let delivered = 0;
    for (const [endpointId, endpoint] of this.endpoints) {
      if (endpoint.floorId === floorId && endpointId !== from) {
        this._deliverTo(message, endpointId);
        delivered++;
      }
    }
    
    return { 
      status: 'broadcast', 
      messageId: message.id,
      delivered 
    };
  }
  
  /**
   * Broadcast organization-wide
   */
  broadcastAll(from, payload) {
    const message = new SyncMessage({
      protocol: 'BROADCAST',
      from,
      to: '*',
      channel: CHANNEL_TYPES.BROADCAST,
      payload
    });
    
    this._enqueue(message);
    
    // Deliver to all endpoints
    let delivered = 0;
    for (const [endpointId] of this.endpoints) {
      if (endpointId !== from) {
        this._deliverTo(message, endpointId);
        delivered++;
      }
    }
    
    return { 
      status: 'broadcast', 
      messageId: message.id,
      delivered 
    };
  }
  
  /**
   * Publish to a topic
   */
  publish(from, topic, payload) {
    const message = new SyncMessage({
      protocol: 'BROADCAST',
      from,
      to: topic,
      channel: CHANNEL_TYPES.TOPIC,
      payload
    });
    
    this._enqueue(message);
    
    // Deliver to subscribers
    let delivered = 0;
    const subIds = this.topicSubscribers.get(topic) || new Set();
    for (const subId of subIds) {
      const sub = this.subscriptions.get(subId);
      if (sub && sub.matches(message)) {
        this._deliverTo(message, sub.subscriberId);
        sub.recordDelivery();
        delivered++;
      }
    }
    
    return { 
      status: 'published', 
      messageId: message.id,
      topic,
      delivered 
    };
  }
  
  /**
   * Acknowledge a message
   */
  acknowledge(messageId, byId) {
    const message = this.messageQueue.find(m => m.id === messageId) ||
                    this.messageHistory.find(m => m.id === messageId);
    
    if (message) {
      message.acknowledge(byId);
      return { status: 'acknowledged' };
    }
    
    return { status: 'not_found' };
  }
  
  /**
   * Get pending messages for an endpoint
   */
  getMessages(endpointId, unacknowledged = true) {
    return this.messageQueue.filter(m => 
      m.to === endpointId && 
      !m.isExpired() &&
      (!unacknowledged || !m.acknowledged)
    );
  }
  
  _enqueue(message) {
    this.messageQueue.push(message);
    this.stats.messagesSent++;
    
    // Enforce max size
    while (this.messageQueue.length > this.config.maxMessages) {
      const old = this.messageQueue.shift();
      this.messageHistory.push(old);
    }
  }
  
  _deliver(message) {
    if (message.channel === CHANNEL_TYPES.DIRECT) {
      this._deliverTo(message, message.to);
    }
  }
  
  _deliverTo(message, endpointId) {
    const endpoint = this.endpoints.get(endpointId);
    if (endpoint) {
      endpoint.lastSeen = Date.now();
      if (endpoint.handler) {
        try {
          endpoint.handler(message);
          this.stats.messagesDelivered++;
        } catch (e) {
          // Handler error - log but don't fail
          console.error(`Delivery error to ${endpointId}:`, e.message);
        }
      }
    }
  }
  
  // ─── Subscriptions ─────────────────────────────────────────────────────────
  
  /**
   * Subscribe to a topic
   */
  subscribe(subscriberId, topic, filter = null) {
    const subscription = new Subscription({ 
      subscriberId, 
      topic, 
      filter 
    });
    
    this.subscriptions.set(subscription.id, subscription);
    
    if (!this.topicSubscribers.has(topic)) {
      this.topicSubscribers.set(topic, new Set());
    }
    this.topicSubscribers.get(topic).add(subscription.id);
    
    this.stats.subscriptionsActive = this.subscriptions.size;
    
    return { 
      status: 'subscribed', 
      subscriptionId: subscription.id,
      topic 
    };
  }
  
  /**
   * Unsubscribe
   */
  unsubscribe(subscriptionId) {
    const sub = this.subscriptions.get(subscriptionId);
    if (sub) {
      sub.active = false;
      this.subscriptions.delete(subscriptionId);
      
      const topicSubs = this.topicSubscribers.get(sub.topic);
      if (topicSubs) {
        topicSubs.delete(subscriptionId);
      }
      
      this.stats.subscriptionsActive = this.subscriptions.size;
      return { status: 'unsubscribed' };
    }
    
    return { status: 'not_found' };
  }
  
  // ─── Handoff Protocol ──────────────────────────────────────────────────────
  
  /**
   * Initiate a task handoff
   */
  initiateHandoff({ taskId, fromWorkstation, toWorkstation, context, reason }) {
    const handoff = new HandoffSession({
      taskId,
      fromWorkstation,
      toWorkstation,
      context,
      reason
    });
    
    this.handoffs.set(handoff.id, handoff);
    
    // Send handoff request
    this.send(fromWorkstation, toWorkstation, {
      type: 'HANDOFF_REQUEST',
      handoffId: handoff.id,
      taskId,
      context,
      reason
    }, { protocol: 'HANDOFF' });
    
    return { 
      status: 'initiated', 
      handoffId: handoff.id 
    };
  }
  
  /**
   * Accept a handoff
   */
  acceptHandoff(handoffId, byWorkstation) {
    const handoff = this.handoffs.get(handoffId);
    if (!handoff) {
      return { status: 'not_found' };
    }
    
    if (handoff.toWorkstation !== byWorkstation) {
      return { status: 'error', message: 'Not the target workstation' };
    }
    
    handoff.accept();
    
    // Notify original workstation
    this.send(byWorkstation, handoff.fromWorkstation, {
      type: 'HANDOFF_ACCEPTED',
      handoffId,
      taskId: handoff.taskId
    });
    
    return { 
      status: 'accepted', 
      handoff: handoff.toJSON() 
    };
  }
  
  /**
   * Reject a handoff
   */
  rejectHandoff(handoffId, byWorkstation, reason) {
    const handoff = this.handoffs.get(handoffId);
    if (!handoff) {
      return { status: 'not_found' };
    }
    
    if (handoff.toWorkstation !== byWorkstation) {
      return { status: 'error', message: 'Not the target workstation' };
    }
    
    handoff.reject(reason);
    
    // Notify original workstation
    this.send(byWorkstation, handoff.fromWorkstation, {
      type: 'HANDOFF_REJECTED',
      handoffId,
      taskId: handoff.taskId,
      reason
    });
    
    return { status: 'rejected', handoff: handoff.toJSON() };
  }
  
  /**
   * Complete a handoff
   */
  completeHandoff(handoffId, feedback = null) {
    const handoff = this.handoffs.get(handoffId);
    if (!handoff) {
      return { status: 'not_found' };
    }
    
    handoff.complete(feedback);
    this.stats.handoffsCompleted++;
    
    return { status: 'completed', handoff: handoff.toJSON() };
  }
  
  // ─── Consensus Protocol ────────────────────────────────────────────────────
  
  /**
   * Start a consensus session
   */
  startConsensus({ proposerId, topic, proposal, participants, threshold }) {
    const session = new ConsensusSession({
      proposerId,
      topic,
      proposal,
      participants,
      threshold
    });
    
    this.consensus.set(session.id, session);
    
    // Notify all participants
    for (const participant of participants) {
      this.send(proposerId, participant, {
        type: 'CONSENSUS_REQUEST',
        consensusId: session.id,
        topic,
        proposal,
        threshold
      }, { protocol: 'CONSENSUS' });
    }
    
    return { 
      status: 'started', 
      consensusId: session.id 
    };
  }
  
  /**
   * Vote in a consensus session
   */
  voteConsensus(consensusId, participantId, vote, reason = null) {
    const session = this.consensus.get(consensusId);
    if (!session) {
      return { status: 'not_found' };
    }
    
    session.isExpired();  // Check expiry
    
    const result = session.vote(participantId, vote, reason);
    
    // If resolved, notify all
    if (session.status !== 'voting') {
      this.stats.consensusReached++;
      for (const participant of session.participants) {
        this.send('system', participant, {
          type: 'CONSENSUS_RESULT',
          consensusId,
          topic: session.topic,
          status: session.status,
          result: session._getCurrentResult()
        });
      }
    }
    
    return result;
  }
  
  /**
   * Get consensus status
   */
  getConsensusStatus(consensusId) {
    const session = this.consensus.get(consensusId);
    if (!session) {
      return { status: 'not_found' };
    }
    
    session.isExpired();
    return session.toJSON();
  }
  
  // ─── Maintenance ───────────────────────────────────────────────────────────
  
  /**
   * Clean up expired messages
   */
  cleanup() {
    const now = Date.now();
    let expired = 0;
    
    // Clean message queue
    this.messageQueue = this.messageQueue.filter(m => {
      if (m.isExpired()) {
        this.messageHistory.push(m);
        expired++;
        return false;
      }
      return true;
    });
    
    // Trim history
    const historyLimit = this.config.maxMessages * 2;
    while (this.messageHistory.length > historyLimit) {
      this.messageHistory.shift();
    }
    
    // Clean up old handoffs
    for (const [id, handoff] of this.handoffs) {
      if (handoff.status === 'completed' || handoff.status === 'rejected') {
        if (now - (handoff.completedAt || handoff.createdAt) > 86400000) {  // 1 day
          this.handoffs.delete(id);
        }
      }
    }
    
    // Clean up old consensus sessions
    for (const [id, session] of this.consensus) {
      session.isExpired();
      if (session.status !== 'voting') {
        if (now - session.resolvedAt > 86400000) {  // 1 day
          this.consensus.delete(id);
        }
      }
    }
    
    this.stats.messagesExpired += expired;
    return { expired };
  }
  
  // ─── Export/Import ─────────────────────────────────────────────────────────
  
  /**
   * Export state
   */
  export() {
    return {
      version: SyncEngine.VERSION,
      exportedAt: Date.now(),
      stats: this.stats,
      subscriptions: Array.from(this.subscriptions.entries()).map(([id, sub]) => ({
        id,
        subscriberId: sub.subscriberId,
        topic: sub.topic,
        createdAt: sub.createdAt,
        deliveryCount: sub.deliveryCount
      })),
      handoffs: Array.from(this.handoffs.values()).map(h => h.toJSON()),
      consensus: Array.from(this.consensus.values()).map(c => c.toJSON())
    };
  }
  
  /**
   * Import state
   */
  import(data) {
    if (data.stats) {
      this.stats = { ...this.stats, ...data.stats };
    }
  }
  
  // ─── Heartbeat ─────────────────────────────────────────────────────────────
  
  heartbeat() {
    const now = Date.now();
    const delta = now - this.stats.lastHeartbeat;
    this.stats.lastHeartbeat = now;
    
    // Run cleanup on heartbeat
    this.cleanup();
    
    return {
      quad: SyncEngine.QUAD,
      timestamp: now,
      delta,
      expectedDelta: PHI_BEAT_MS,
      drift: Math.abs(delta - PHI_BEAT_MS),
      phi: PHI,
      stats: this.stats,
      endpoints: this.endpoints.size,
      pendingMessages: this.messageQueue.length,
      activeHandoffs: Array.from(this.handoffs.values())
        .filter(h => h.status === 'pending' || h.status === 'accepted').length,
      activeConsensus: Array.from(this.consensus.values())
        .filter(c => c.status === 'voting').length
    };
  }
  
  toJSON() {
    return {
      quad: SyncEngine.QUAD,
      version: SyncEngine.VERSION,
      ipValue: SyncEngine.IP_VALUE,
      domain: SyncEngine.DOMAIN,
      stats: this.stats,
      endpoints: this.endpoints.size,
      subscriptions: this.subscriptions.size,
      pendingMessages: this.messageQueue.length,
      handoffs: this.handoffs.size,
      consensus: this.consensus.size
    };
  }
}

// ─── Export ──────────────────────────────────────────────────────────────────
export { 
  SYNC_PROTOCOLS, 
  CHANNEL_TYPES, 
  SyncMessage, 
  Subscription, 
  HandoffSession, 
  ConsensusSession 
};
export default SyncEngine;
