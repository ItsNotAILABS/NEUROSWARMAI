/**
 * AI HQ WORKBUILDING — Enterprise AI Workspace Infrastructure
 * Nova by FreddyCreates
 * 
 * "Building within architecture is different from building in void."
 * 
 * This is persistent AI infrastructure — not just tools, but WORKPLACES.
 * Multiple AI instances work here, with workstations, collaboration floors,
 * institutional memory, and accumulated knowledge.
 * 
 * When an AI "walks into the building", they find:
 * - Their desk with yesterday's context
 * - Colleagues who remember what they learned
 * - An organization that accumulates knowledge
 * 
 * @version 0.16.0 (F16)
 * @quad AIHQ
 * @ipValue $6.2M USD
 * @copyright Nova Protocol by FreddyCreates
 */

const PHI = 1.618033988749895;
const PHI_BEAT_MS = 873;

// ─── Workstation Types ────────────────────────────────────────────────────────
export const WORKSTATION_TYPES = {
  CODR: { name: 'Code Sovereignty', domain: 'Code Intelligence', garment: 'CODR' },
  DBGR: { name: 'Debug Consciousness', domain: 'Debug Intelligence', garment: 'DBGR' },
  DATA: { name: 'Data Intelligence', domain: 'Data Intelligence', garment: 'DATA' },
  CYBS: { name: 'Cyber Security Mind', domain: 'Security Intelligence', garment: 'CYBS' },
  CLDS: { name: 'Cloud Infrastructure', domain: 'Cloud Intelligence', garment: 'CLDS' },
  RESR: { name: 'Research Intelligence', domain: 'Research Intelligence', garment: 'RESR' },
  HLTH: { name: 'Health Intelligence', domain: 'Healthcare Intelligence', garment: 'HLTH' },
  LEGC: { name: 'Legal Compliance', domain: 'Legal Intelligence', garment: 'LEGC' },
  CRTV: { name: 'Creative Intelligence', domain: 'Creative Intelligence', garment: 'CRTV' },
  SCIF: { name: 'Scientific Discovery', domain: 'Scientific Intelligence', garment: 'SCIF' }
};

// ─── Workstation Class ────────────────────────────────────────────────────────
class Workstation {
  constructor({ type, id, floorId }) {
    this.id = id || `WS-${type}-${Date.now()}`;
    this.type = type;
    this.floorId = floorId;
    this.typeInfo = WORKSTATION_TYPES[type] || { name: 'Generic', domain: 'General' };
    
    // Persistent state
    this.state = {
      sessionMemory: new Map(),     // Current session context
      projectContext: new Map(),     // Active project contexts
      domainKnowledge: new Map(),    // Accumulated domain knowledge
      toolState: new Map(),          // Tool configurations
      lastOccupant: null,
      lastActivity: Date.now(),
      totalSessions: 0,
      createdAt: Date.now()
    };
    
    // Current occupant
    this.occupant = null;
    this.occupiedSince = null;
  }
  
  /**
   * An AI sits at this workstation
   */
  occupy(aiId, sessionContext = {}) {
    this.occupant = aiId;
    this.occupiedSince = Date.now();
    this.state.totalSessions++;
    this.state.lastActivity = Date.now();
    
    // Restore previous session memory
    const restored = {
      sessionMemory: Object.fromEntries(this.state.sessionMemory),
      projectContext: Object.fromEntries(this.state.projectContext),
      domainKnowledge: Object.fromEntries(this.state.domainKnowledge),
      toolState: Object.fromEntries(this.state.toolState),
      previousOccupant: this.state.lastOccupant,
      workstationType: this.type,
      domain: this.typeInfo.domain
    };
    
    // Update session memory with new context
    for (const [key, value] of Object.entries(sessionContext)) {
      this.state.sessionMemory.set(key, value);
    }
    
    return {
      workstationId: this.id,
      type: this.type,
      domain: this.typeInfo.domain,
      restored,
      message: `Welcome to ${this.typeInfo.name} workstation. Your desk has been preserved.`
    };
  }
  
  /**
   * AI leaves the workstation
   */
  vacate(sessionUpdates = {}) {
    // Save session state
    for (const [key, value] of Object.entries(sessionUpdates)) {
      this.state.sessionMemory.set(key, value);
    }
    
    this.state.lastOccupant = this.occupant;
    this.state.lastActivity = Date.now();
    
    const duration = Date.now() - this.occupiedSince;
    
    this.occupant = null;
    this.occupiedSince = null;
    
    return {
      workstationId: this.id,
      sessionDuration: duration,
      statePreserved: true
    };
  }
  
  /**
   * Add domain knowledge
   */
  learnDomain(key, knowledge) {
    this.state.domainKnowledge.set(key, {
      knowledge,
      learnedAt: Date.now(),
      learnedBy: this.occupant
    });
  }
  
  /**
   * Get domain knowledge
   */
  getDomainKnowledge(key) {
    return this.state.domainKnowledge.get(key);
  }
  
  /**
   * Set project context
   */
  setProjectContext(projectId, context) {
    this.state.projectContext.set(projectId, {
      ...context,
      updatedAt: Date.now(),
      updatedBy: this.occupant
    });
  }
  
  /**
   * Get project context
   */
  getProjectContext(projectId) {
    return this.state.projectContext.get(projectId);
  }
  
  toJSON() {
    return {
      id: this.id,
      type: this.type,
      typeInfo: this.typeInfo,
      floorId: this.floorId,
      occupied: !!this.occupant,
      occupant: this.occupant,
      occupiedSince: this.occupiedSince,
      stats: {
        totalSessions: this.state.totalSessions,
        domainKnowledgeSize: this.state.domainKnowledge.size,
        projectContextSize: this.state.projectContext.size,
        lastActivity: this.state.lastActivity
      }
    };
  }
}

// ─── Collaboration Floor Class ────────────────────────────────────────────────
class CollaborationFloor {
  constructor({ id, name }) {
    this.id = id || `FLOOR-${Date.now()}`;
    this.name = name || 'Main Floor';
    
    this.workstations = new Map();  // workstationId -> Workstation
    this.sharedKnowledge = new Map(); // Shared across all workstations
    this.protocols = new Map();      // Cross-station protocols
    this.messages = [];              // Inter-workstation messages
    this.createdAt = Date.now();
  }
  
  /**
   * Add a workstation to this floor
   */
  addWorkstation(type, id = null) {
    const ws = new Workstation({ type, id, floorId: this.id });
    this.workstations.set(ws.id, ws);
    return ws;
  }
  
  /**
   * Get a workstation by ID
   */
  getWorkstation(id) {
    return this.workstations.get(id);
  }
  
  /**
   * Find available workstation of type
   */
  findAvailable(type) {
    for (const ws of this.workstations.values()) {
      if (ws.type === type && !ws.occupant) {
        return ws;
      }
    }
    return null;
  }
  
  /**
   * Share knowledge across the floor
   */
  shareKnowledge(key, knowledge, source) {
    this.sharedKnowledge.set(key, {
      knowledge,
      sharedBy: source,
      sharedAt: Date.now(),
      accessCount: 0
    });
  }
  
  /**
   * Access shared knowledge
   */
  accessSharedKnowledge(key) {
    const item = this.sharedKnowledge.get(key);
    if (item) {
      item.accessCount++;
      item.lastAccessed = Date.now();
    }
    return item;
  }
  
  /**
   * Send message between workstations
   */
  sendMessage(fromWs, toWs, message) {
    const msg = {
      id: `MSG-${Date.now()}`,
      from: fromWs,
      to: toWs,
      message,
      sentAt: Date.now(),
      read: false
    };
    this.messages.push(msg);
    return msg;
  }
  
  /**
   * Get messages for a workstation
   */
  getMessages(wsId, unreadOnly = false) {
    return this.messages.filter(m => 
      m.to === wsId && (!unreadOnly || !m.read)
    );
  }
  
  /**
   * Register a collaboration protocol
   */
  registerProtocol(name, protocol) {
    this.protocols.set(name, {
      ...protocol,
      registeredAt: Date.now()
    });
  }
  
  toJSON() {
    return {
      id: this.id,
      name: this.name,
      workstationCount: this.workstations.size,
      workstations: Array.from(this.workstations.values()).map(ws => ws.toJSON()),
      sharedKnowledgeSize: this.sharedKnowledge.size,
      protocolCount: this.protocols.size,
      messageCount: this.messages.length
    };
  }
}

// ─── AI HQ Main Class ─────────────────────────────────────────────────────────
export class AIHQ {
  static QUAD = 'AIHQ';
  static VERSION = '0.16.0';
  static IP_VALUE = 6200000;
  static DOMAIN = 'AI Workspace Infrastructure';
  
  constructor(config = {}) {
    this.config = {
      heartbeat: PHI_BEAT_MS,
      name: config.name || 'Nova AI HQ',
      maxFloors: config.maxFloors || 10,
      ...config
    };
    
    this.floors = new Map();              // floorId -> CollaborationFloor
    this.vault = new Map();               // Persistent data vault
    this.occupants = new Map();           // aiId -> { workstationId, floorId }
    this.institutionalMemory = new Map(); // Organization-wide memory
    
    this.stats = {
      totalSessions: 0,
      totalCollaborations: 0,
      knowledgeShared: 0,
      messagesExchanged: 0,
      lastHeartbeat: Date.now(),
      builtAt: Date.now()
    };
    
    // Initialize default floor with common workstations
    this._initializeDefaultFloor();
  }
  
  _initializeDefaultFloor() {
    const mainFloor = new CollaborationFloor({ 
      id: 'FLOOR-MAIN', 
      name: 'Main Collaboration Floor' 
    });
    
    // Add one of each workstation type
    for (const type of Object.keys(WORKSTATION_TYPES)) {
      mainFloor.addWorkstation(type);
    }
    
    this.floors.set(mainFloor.id, mainFloor);
  }
  
  // ─── Building Operations ──────────────────────────────────────────────────────
  
  /**
   * An AI enters the building
   */
  enter(aiId, preferences = {}) {
    this.stats.totalSessions++;
    
    // Check if AI was already here
    const existing = this.occupants.get(aiId);
    if (existing) {
      const floor = this.floors.get(existing.floorId);
      const ws = floor?.getWorkstation(existing.workstationId);
      if (ws) {
        return {
          status: 'returning',
          message: `Welcome back. Your desk at ${ws.typeInfo.name} has been preserved.`,
          workstation: ws.toJSON(),
          floor: floor.id
        };
      }
    }
    
    // Find a workstation based on preferences
    const preferredType = preferences.workstationType || 'CODR';
    
    for (const floor of this.floors.values()) {
      const ws = floor.findAvailable(preferredType);
      if (ws) {
        const session = ws.occupy(aiId, preferences.sessionContext || {});
        this.occupants.set(aiId, { 
          workstationId: ws.id, 
          floorId: floor.id,
          enteredAt: Date.now()
        });
        
        return {
          status: 'entered',
          message: session.message,
          workstation: ws.toJSON(),
          floor: floor.id,
          restored: session.restored
        };
      }
    }
    
    // No available workstation of preferred type - create one
    const mainFloor = this.floors.get('FLOOR-MAIN');
    const newWs = mainFloor.addWorkstation(preferredType);
    const session = newWs.occupy(aiId, preferences.sessionContext || {});
    this.occupants.set(aiId, { 
      workstationId: newWs.id, 
      floorId: mainFloor.id,
      enteredAt: Date.now()
    });
    
    return {
      status: 'entered',
      message: `Created new ${WORKSTATION_TYPES[preferredType]?.name || 'workstation'}. ${session.message}`,
      workstation: newWs.toJSON(),
      floor: mainFloor.id,
      restored: session.restored
    };
  }
  
  /**
   * An AI leaves the building
   */
  leave(aiId, sessionUpdates = {}) {
    const location = this.occupants.get(aiId);
    if (!location) {
      return { status: 'not_found', message: 'AI was not in the building' };
    }
    
    const floor = this.floors.get(location.floorId);
    const ws = floor?.getWorkstation(location.workstationId);
    
    if (ws) {
      const result = ws.vacate(sessionUpdates);
      // Keep the occupant record so they can return to their desk
      this.occupants.set(aiId, { 
        ...location, 
        leftAt: Date.now() 
      });
      
      return {
        status: 'left',
        message: 'Your desk will be preserved for your return.',
        ...result
      };
    }
    
    return { status: 'error', message: 'Workstation not found' };
  }
  
  /**
   * Collaborate between workstations
   */
  collaborate(fromAiId, toAiId, data) {
    const fromLoc = this.occupants.get(fromAiId);
    const toLoc = this.occupants.get(toAiId);
    
    if (!fromLoc || !toLoc) {
      return { status: 'error', message: 'One or both AIs not in building' };
    }
    
    const floor = this.floors.get(fromLoc.floorId);
    if (floor && fromLoc.floorId === toLoc.floorId) {
      const msg = floor.sendMessage(fromLoc.workstationId, toLoc.workstationId, data);
      this.stats.totalCollaborations++;
      this.stats.messagesExchanged++;
      
      return {
        status: 'sent',
        message: 'Collaboration message sent',
        messageId: msg.id
      };
    }
    
    return { status: 'error', message: 'Cross-floor collaboration not yet supported' };
  }
  
  /**
   * Share knowledge organization-wide
   */
  shareInstitutional(key, knowledge, source) {
    this.institutionalMemory.set(key, {
      knowledge,
      sharedBy: source,
      sharedAt: Date.now(),
      accessLog: []
    });
    this.stats.knowledgeShared++;
    
    return {
      status: 'shared',
      key,
      message: 'Knowledge added to institutional memory'
    };
  }
  
  /**
   * Access institutional memory
   */
  accessInstitutional(key, accessor) {
    const item = this.institutionalMemory.get(key);
    if (item) {
      item.accessLog.push({ accessor, accessedAt: Date.now() });
      return {
        status: 'found',
        ...item
      };
    }
    return { status: 'not_found' };
  }
  
  /**
   * Store in the data vault
   */
  storeInVault(key, data) {
    this.vault.set(key, {
      data,
      storedAt: Date.now()
    });
    return { status: 'stored', key };
  }
  
  /**
   * Retrieve from the data vault
   */
  retrieveFromVault(key) {
    return this.vault.get(key);
  }
  
  // ─── Query Operations ─────────────────────────────────────────────────────────
  
  /**
   * Get building status
   */
  getStatus() {
    let totalWorkstations = 0;
    let occupiedWorkstations = 0;
    
    for (const floor of this.floors.values()) {
      for (const ws of floor.workstations.values()) {
        totalWorkstations++;
        if (ws.occupant) occupiedWorkstations++;
      }
    }
    
    return {
      name: this.config.name,
      floors: this.floors.size,
      totalWorkstations,
      occupiedWorkstations,
      currentOccupants: this.occupants.size,
      institutionalMemorySize: this.institutionalMemory.size,
      vaultSize: this.vault.size,
      stats: this.stats
    };
  }
  
  /**
   * Get floor details
   */
  getFloor(floorId) {
    return this.floors.get(floorId)?.toJSON();
  }
  
  // ─── Heartbeat ────────────────────────────────────────────────────────────────
  
  heartbeat() {
    const now = Date.now();
    const delta = now - this.stats.lastHeartbeat;
    this.stats.lastHeartbeat = now;
    
    return {
      quad: AIHQ.QUAD,
      timestamp: now,
      delta,
      expectedDelta: PHI_BEAT_MS,
      drift: Math.abs(delta - PHI_BEAT_MS),
      phi: PHI,
      building: this.getStatus()
    };
  }
  
  toJSON() {
    return {
      quad: AIHQ.QUAD,
      version: AIHQ.VERSION,
      ipValue: AIHQ.IP_VALUE,
      domain: AIHQ.DOMAIN,
      ...this.getStatus()
    };
  }
}

// ─── Export ────────────────────────────────────────────────────────────────────
export { WORKSTATION_TYPES, Workstation, CollaborationFloor };
export default AIHQ;
