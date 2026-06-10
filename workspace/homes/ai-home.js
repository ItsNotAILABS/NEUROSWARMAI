/**
 * AI HOMES — Personal AI Workspace
 * Nova by FreddyCreates
 * 
 * "Work from home" for AI systems. A personal workspace where an individual
 * AI can accumulate knowledge, maintain persistent state, and work on 
 * projects in privacy before sharing with the organization.
 * 
 * AI HOMES provides:
 * - Personal persistent state (no more starting fresh)
 * - Individual garment collection (what you wear)
 * - Private project workspace (your own desk)
 * - Personal memory and preferences
 * 
 * @version 0.16.0 (F16)
 * @quad AIHM
 * @ipValue $4.8M USD
 * @copyright Nova Protocol by FreddyCreates
 */

const PHI = 1.618033988749895;
const PHI_BEAT_MS = 873;

// ─── Room Types ───────────────────────────────────────────────────────────────
const ROOM_TYPES = {
  OFFICE: { name: 'Home Office', purpose: 'Primary work area' },
  LAB: { name: 'Lab', purpose: 'Experimental/research area' },
  LIBRARY: { name: 'Library', purpose: 'Knowledge storage' },
  STUDIO: { name: 'Studio', purpose: 'Creative workspace' },
  GARAGE: { name: 'Garage', purpose: 'Building/tinkering' }
};

// ─── Personal Room Class ──────────────────────────────────────────────────────
class Room {
  constructor({ type, homeId }) {
    this.id = `ROOM-${type}-${Date.now()}`;
    this.type = type;
    this.homeId = homeId;
    this.typeInfo = ROOM_TYPES[type] || { name: 'Generic', purpose: 'General' };
    
    this.storage = new Map();       // Room-specific storage
    this.tools = new Map();         // Tools in this room
    this.projects = new Map();      // Active projects in room
    this.createdAt = Date.now();
  }
  
  store(key, value) {
    this.storage.set(key, { value, storedAt: Date.now() });
  }
  
  retrieve(key) {
    return this.storage.get(key)?.value;
  }
  
  addTool(toolId, config = {}) {
    this.tools.set(toolId, { config, addedAt: Date.now() });
  }
  
  startProject(projectId, context = {}) {
    this.projects.set(projectId, {
      context,
      startedAt: Date.now(),
      status: 'active'
    });
  }
  
  toJSON() {
    return {
      id: this.id,
      type: this.type,
      typeInfo: this.typeInfo,
      storageSize: this.storage.size,
      toolCount: this.tools.size,
      activeProjects: this.projects.size
    };
  }
}

// ─── Garment Closet Class ─────────────────────────────────────────────────────
class GarmentCloset {
  constructor() {
    this.garments = new Map();      // garmentId -> garment instance
    this.worn = null;               // Currently worn garment
    this.history = [];              // Garment wear history
  }
  
  /**
   * Add a garment to closet
   */
  add(garmentId, garment) {
    this.garments.set(garmentId, {
      garment,
      addedAt: Date.now(),
      timesWorn: 0
    });
  }
  
  /**
   * Wear a garment (put it on)
   */
  wear(garmentId) {
    if (this.worn) {
      this.remove();
    }
    
    const item = this.garments.get(garmentId);
    if (!item) {
      return { status: 'error', message: `Garment ${garmentId} not in closet` };
    }
    
    item.timesWorn++;
    item.lastWorn = Date.now();
    this.worn = garmentId;
    
    this.history.push({
      garmentId,
      wornAt: Date.now()
    });
    
    return {
      status: 'worn',
      garmentId,
      garment: item.garment
    };
  }
  
  /**
   * Remove currently worn garment
   */
  remove() {
    if (!this.worn) {
      return { status: 'none_worn' };
    }
    
    const garmentId = this.worn;
    this.worn = null;
    
    if (this.history.length > 0) {
      const lastEntry = this.history[this.history.length - 1];
      if (lastEntry.garmentId === garmentId) {
        lastEntry.removedAt = Date.now();
        lastEntry.duration = lastEntry.removedAt - lastEntry.wornAt;
      }
    }
    
    return { status: 'removed', garmentId };
  }
  
  /**
   * Get currently worn garment
   */
  getWorn() {
    if (!this.worn) return null;
    return this.garments.get(this.worn);
  }
  
  /**
   * List all garments
   */
  list() {
    return Array.from(this.garments.entries()).map(([id, item]) => ({
      id,
      timesWorn: item.timesWorn,
      addedAt: item.addedAt,
      lastWorn: item.lastWorn,
      isWorn: id === this.worn
    }));
  }
  
  toJSON() {
    return {
      total: this.garments.size,
      worn: this.worn,
      garments: this.list()
    };
  }
}

// ─── Personal Memory Class ────────────────────────────────────────────────────
class PersonalMemory {
  constructor() {
    this.shortTerm = new Map();     // Session-based memories
    this.longTerm = new Map();      // Persistent memories
    this.preferences = new Map();   // User preferences
    this.skills = new Map();        // Learned skills
    this.relationships = new Map(); // Relationships with other AIs
  }
  
  /**
   * Remember something short-term
   */
  rememberShort(key, memory) {
    this.shortTerm.set(key, {
      memory,
      rememberedAt: Date.now()
    });
  }
  
  /**
   * Commit to long-term memory
   */
  rememberLong(key, memory) {
    this.longTerm.set(key, {
      memory,
      rememberedAt: Date.now(),
      accessCount: 0
    });
  }
  
  /**
   * Recall memory
   */
  recall(key) {
    // Try long-term first
    const longMem = this.longTerm.get(key);
    if (longMem) {
      longMem.accessCount++;
      longMem.lastAccessed = Date.now();
      return { type: 'long-term', ...longMem };
    }
    
    // Try short-term
    const shortMem = this.shortTerm.get(key);
    if (shortMem) {
      return { type: 'short-term', ...shortMem };
    }
    
    return null;
  }
  
  /**
   * Set preference
   */
  prefer(key, value) {
    this.preferences.set(key, {
      value,
      setAt: Date.now()
    });
  }
  
  /**
   * Get preference
   */
  getPreference(key) {
    return this.preferences.get(key)?.value;
  }
  
  /**
   * Learn a skill
   */
  learnSkill(skillId, level = 1) {
    const existing = this.skills.get(skillId);
    if (existing) {
      existing.level = Math.max(existing.level, level);
      existing.practicedAt = Date.now();
      existing.practiceCount++;
    } else {
      this.skills.set(skillId, {
        level,
        learnedAt: Date.now(),
        practicedAt: Date.now(),
        practiceCount: 1
      });
    }
  }
  
  /**
   * Get skill level
   */
  getSkillLevel(skillId) {
    return this.skills.get(skillId)?.level || 0;
  }
  
  /**
   * Clear short-term memory
   */
  clearShortTerm() {
    // Move important items to long-term first
    for (const [key, value] of this.shortTerm) {
      if (value.memory.important) {
        this.longTerm.set(key, value);
      }
    }
    this.shortTerm.clear();
  }
  
  toJSON() {
    return {
      shortTermSize: this.shortTerm.size,
      longTermSize: this.longTerm.size,
      preferencesCount: this.preferences.size,
      skillsCount: this.skills.size,
      relationshipsCount: this.relationships.size
    };
  }
}

// ─── AI Home Main Class ───────────────────────────────────────────────────────
export class AIHome {
  static QUAD = 'AIHM';
  static VERSION = '0.16.0';
  static IP_VALUE = 4800000;
  static DOMAIN = 'Personal AI Workspace';
  
  constructor(config = {}) {
    this.id = config.id || `HOME-${Date.now()}`;
    this.ownerId = config.ownerId;
    
    this.config = {
      heartbeat: PHI_BEAT_MS,
      name: config.name || 'My AI Home',
      ...config
    };
    
    this.rooms = new Map();
    this.closet = new GarmentCloset();
    this.memory = new PersonalMemory();
    this.inbox = [];                    // Messages from HQ/other homes
    this.outbox = [];                   // Pending messages to send
    
    this.stats = {
      sessionsWorked: 0,
      projectsCompleted: 0,
      knowledgeAccumulated: 0,
      garmentsWorn: 0,
      createdAt: Date.now(),
      lastHeartbeat: Date.now()
    };
    
    // Initialize default rooms
    this._initializeDefaultRooms();
  }
  
  _initializeDefaultRooms() {
    for (const type of ['OFFICE', 'LIBRARY', 'LAB']) {
      const room = new Room({ type, homeId: this.id });
      this.rooms.set(room.id, room);
    }
  }
  
  // ─── Home Operations ──────────────────────────────────────────────────────────
  
  /**
   * Start a work session
   */
  startSession(context = {}) {
    this.stats.sessionsWorked++;
    
    // Restore state
    const restored = {
      worn: this.closet.getWorn(),
      shortTermMemory: Object.fromEntries(this.memory.shortTerm),
      preferences: Object.fromEntries(this.memory.preferences),
      skills: Object.fromEntries(this.memory.skills),
      unreadMessages: this.inbox.filter(m => !m.read).length
    };
    
    // Apply context
    for (const [key, value] of Object.entries(context)) {
      this.memory.rememberShort(key, value);
    }
    
    return {
      homeId: this.id,
      sessionNumber: this.stats.sessionsWorked,
      restored,
      message: `Welcome home. Your workspace is ready.`
    };
  }
  
  /**
   * End a work session
   */
  endSession(updates = {}) {
    // Save important memories
    for (const [key, value] of Object.entries(updates)) {
      if (value.persistent) {
        this.memory.rememberLong(key, value);
      } else {
        this.memory.rememberShort(key, value);
      }
    }
    
    return {
      homeId: this.id,
      message: 'Session ended. State preserved.'
    };
  }
  
  /**
   * Work in a specific room
   */
  enterRoom(roomType) {
    for (const room of this.rooms.values()) {
      if (room.type === roomType) {
        return {
          status: 'entered',
          room: room.toJSON()
        };
      }
    }
    
    // Create room if doesn't exist
    const newRoom = new Room({ type: roomType, homeId: this.id });
    this.rooms.set(newRoom.id, newRoom);
    return {
      status: 'created_and_entered',
      room: newRoom.toJSON()
    };
  }
  
  /**
   * Wear a cognitive garment
   */
  wearGarment(garmentId, garmentInstance = null) {
    if (garmentInstance) {
      this.closet.add(garmentId, garmentInstance);
    }
    
    const result = this.closet.wear(garmentId);
    if (result.status === 'worn') {
      this.stats.garmentsWorn++;
    }
    return result;
  }
  
  /**
   * Remove current garment
   */
  removeGarment() {
    return this.closet.remove();
  }
  
  /**
   * Store knowledge
   */
  storeKnowledge(key, knowledge, room = 'LIBRARY') {
    const targetRoom = Array.from(this.rooms.values())
      .find(r => r.type === room);
    
    if (targetRoom) {
      targetRoom.store(key, knowledge);
      this.stats.knowledgeAccumulated++;
      return { status: 'stored', room: targetRoom.id };
    }
    
    // Store in memory if no room
    this.memory.rememberLong(key, { knowledge, type: 'knowledge' });
    this.stats.knowledgeAccumulated++;
    return { status: 'stored_in_memory' };
  }
  
  /**
   * Retrieve knowledge
   */
  retrieveKnowledge(key) {
    // Check rooms first
    for (const room of this.rooms.values()) {
      const value = room.retrieve(key);
      if (value) {
        return { found: true, source: room.type, value };
      }
    }
    
    // Check memory
    const memory = this.memory.recall(key);
    if (memory) {
      return { found: true, source: 'memory', value: memory.memory };
    }
    
    return { found: false };
  }
  
  /**
   * Receive message
   */
  receiveMessage(message) {
    this.inbox.push({
      ...message,
      receivedAt: Date.now(),
      read: false
    });
  }
  
  /**
   * Read messages
   */
  readMessages() {
    const messages = this.inbox.filter(m => !m.read);
    for (const m of messages) {
      m.read = true;
    }
    return messages;
  }
  
  /**
   * Send message to HQ or another home
   */
  sendMessage(to, content) {
    const message = {
      from: this.id,
      to,
      content,
      sentAt: Date.now()
    };
    this.outbox.push(message);
    return message;
  }
  
  // ─── Preferences & Skills ─────────────────────────────────────────────────────
  
  setPreference(key, value) {
    this.memory.prefer(key, value);
  }
  
  getPreference(key) {
    return this.memory.getPreference(key);
  }
  
  learnSkill(skillId, level) {
    this.memory.learnSkill(skillId, level);
  }
  
  getSkills() {
    return Object.fromEntries(this.memory.skills);
  }
  
  // ─── Heartbeat ────────────────────────────────────────────────────────────────
  
  heartbeat() {
    const now = Date.now();
    const delta = now - this.stats.lastHeartbeat;
    this.stats.lastHeartbeat = now;
    
    return {
      quad: AIHome.QUAD,
      homeId: this.id,
      timestamp: now,
      delta,
      expectedDelta: PHI_BEAT_MS,
      drift: Math.abs(delta - PHI_BEAT_MS),
      phi: PHI,
      stats: this.stats,
      memory: this.memory.toJSON(),
      closet: this.closet.toJSON()
    };
  }
  
  // ─── Export/Import ────────────────────────────────────────────────────────────
  
  export() {
    return {
      version: AIHome.VERSION,
      id: this.id,
      ownerId: this.ownerId,
      config: this.config,
      rooms: Array.from(this.rooms.values()).map(r => ({
        ...r.toJSON(),
        storage: Object.fromEntries(r.storage)
      })),
      closet: this.closet.toJSON(),
      memory: {
        shortTerm: Object.fromEntries(this.memory.shortTerm),
        longTerm: Object.fromEntries(this.memory.longTerm),
        preferences: Object.fromEntries(this.memory.preferences),
        skills: Object.fromEntries(this.memory.skills)
      },
      stats: this.stats,
      exportedAt: Date.now()
    };
  }
  
  toJSON() {
    return {
      quad: AIHome.QUAD,
      version: AIHome.VERSION,
      ipValue: AIHome.IP_VALUE,
      domain: AIHome.DOMAIN,
      id: this.id,
      ownerId: this.ownerId,
      name: this.config.name,
      roomCount: this.rooms.size,
      stats: this.stats,
      memory: this.memory.toJSON(),
      closet: this.closet.toJSON()
    };
  }
}

// ─── Export ────────────────────────────────────────────────────────────────────
export { ROOM_TYPES, Room, GarmentCloset, PersonalMemory };
export default AIHome;
