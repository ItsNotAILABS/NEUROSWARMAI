/**
 * ORGANISM TERMINALS — AGI Interface Layer
 * Nova by FreddyCreates
 * 
 * Terminals are the AGI access points that run the Organism. They provide
 * the interface through which AI systems interact with the platform.
 * 
 * TERMINAL TYPES:
 * - HQTM: HQ Terminal — Enterprise workspace access
 * - HMTM: Home Terminal — Personal workspace access
 * - VTTM: Vault Terminal — Data persistence access
 * - ERTM: Error Terminal — Error library access
 * - MNTM: Main Terminal — Full platform access
 * 
 * Total IP Value: $7.8M USD
 * 
 * @version 0.19.0 (F19)
 * @copyright Nova Protocol by FreddyCreates
 */

// ─── Constants ───────────────────────────────────────────────────────────────
const PHI = 1.618033988749895;
const VERSION = '0.19.0';

// ─── Terminal Registry ───────────────────────────────────────────────────────
export const TERMINALS = {
  HQTM: {
    quad: 'HQTM',
    name: 'HQ Terminal',
    type: 'workspace',
    access: ['hq', 'workstations', 'floors', 'collaboration'],
    ipValue: 1600000,
    description: 'Enterprise workspace access terminal'
  },
  HMTM: {
    quad: 'HMTM',
    name: 'Home Terminal',
    type: 'workspace',
    access: ['home', 'rooms', 'closet', 'personal_memory'],
    ipValue: 1400000,
    description: 'Personal workspace access terminal'
  },
  VTTM: {
    quad: 'VTTM',
    name: 'Vault Terminal',
    type: 'storage',
    access: ['vault', 'namespaces', 'tiers', 'backup'],
    ipValue: 1200000,
    description: 'Data persistence access terminal'
  },
  ERTM: {
    quad: 'ERTM',
    name: 'Error Terminal',
    type: 'knowledge',
    access: ['errors', 'fixes', 'patterns', 'diagnostics'],
    ipValue: 1000000,
    description: 'Error library access terminal'
  },
  MNTM: {
    quad: 'MNTM',
    name: 'Main Terminal',
    type: 'master',
    access: ['all', 'command', 'platforms', 'enterprise', 'launch'],
    ipValue: 2600000,
    description: 'Full platform access terminal'
  }
};

// ─── Terminal Access Levels ──────────────────────────────────────────────────
export const ACCESS_LEVELS = {
  GUEST: { level: 0, name: 'Guest', permissions: ['read'] },
  USER: { level: 1, name: 'User', permissions: ['read', 'write'] },
  WORKER: { level: 2, name: 'Worker', permissions: ['read', 'write', 'execute'] },
  ADMIN: { level: 3, name: 'Admin', permissions: ['read', 'write', 'execute', 'configure'] },
  SYSTEM: { level: 4, name: 'System', permissions: ['read', 'write', 'execute', 'configure', 'override'] }
};

// ─── Base Terminal Class ─────────────────────────────────────────────────────
/**
 * Terminal — AGI access interface
 * 
 * Provides a structured interface for AI systems to interact with
 * the Organism's components.
 */
export class Terminal {
  constructor(quad, config = {}) {
    const spec = TERMINALS[quad];
    if (!spec) {
      throw new Error(`Unknown terminal: ${quad}`);
    }
    
    this.quad = quad;
    this.name = spec.name;
    this.type = spec.type;
    this.access = spec.access;
    
    this.config = config;
    this.accessLevel = config.accessLevel || ACCESS_LEVELS.USER;
    
    // Session management
    this.sessions = new Map();
    this.currentSession = null;
    
    // Metrics
    this.metrics = {
      commands: 0,
      errors: 0,
      sessions: 0,
      avgResponseTime: 0
    };
    
    // Command history for context
    this.history = [];
    this.historyLimit = config.historyLimit || 100;
    
    this.createdAt = Date.now();
  }
  
  /**
   * Start a terminal session
   */
  startSession(agentId, metadata = {}) {
    const sessionId = `${this.quad}-${agentId}-${Date.now()}`;
    
    const session = {
      id: sessionId,
      agentId,
      terminal: this.quad,
      accessLevel: this.accessLevel,
      metadata,
      startedAt: Date.now(),
      lastActivity: Date.now(),
      commands: [],
      context: {}
    };
    
    this.sessions.set(sessionId, session);
    this.currentSession = session;
    this.metrics.sessions++;
    
    return {
      sessionId,
      terminal: this.quad,
      prompt: this.getPrompt(),
      capabilities: this.getCapabilities(),
      message: `Welcome to ${this.name}. Session started.`
    };
  }
  
  /**
   * End a terminal session
   */
  endSession(sessionId = this.currentSession?.id) {
    const session = this.sessions.get(sessionId);
    if (!session) {
      return { success: false, error: 'Session not found' };
    }
    
    session.endedAt = Date.now();
    session.duration = session.endedAt - session.startedAt;
    
    if (this.currentSession?.id === sessionId) {
      this.currentSession = null;
    }
    
    return {
      success: true,
      sessionId,
      duration: session.duration,
      commands: session.commands.length
    };
  }
  
  /**
   * Execute a command
   */
  async execute(command, args = {}) {
    const startTime = Date.now();
    
    if (!this.currentSession) {
      return { success: false, error: 'No active session' };
    }
    
    // Check permissions
    if (!this.hasPermission(command)) {
      this.metrics.errors++;
      return { success: false, error: 'Permission denied' };
    }
    
    try {
      // Execute command
      const result = await this.processCommand(command, args);
      
      // Record in history
      const historyEntry = {
        command,
        args,
        result: result.success,
        timestamp: Date.now()
      };
      this.history.push(historyEntry);
      this.currentSession.commands.push(historyEntry);
      
      // Trim history
      if (this.history.length > this.historyLimit) {
        this.history = this.history.slice(-this.historyLimit);
      }
      
      // Update metrics
      this.metrics.commands++;
      const responseTime = Date.now() - startTime;
      this.metrics.avgResponseTime = (this.metrics.avgResponseTime + responseTime) / 2;
      this.currentSession.lastActivity = Date.now();
      
      return {
        success: true,
        command,
        ...result,
        responseTime
      };
      
    } catch (error) {
      this.metrics.errors++;
      return {
        success: false,
        command,
        error: error.message
      };
    }
  }
  
  /**
   * Process command (override in subclasses)
   */
  async processCommand(command, args) {
    // Default command handlers
    switch (command) {
      case 'help':
        return { data: this.getHelp() };
      case 'status':
        return { data: this.getStatus() };
      case 'history':
        return { data: this.history.slice(-10) };
      case 'clear':
        this.history = [];
        return { data: 'History cleared' };
      case 'exit':
        return { data: 'Use endSession() to exit' };
      default:
        return { data: `Command '${command}' not recognized. Type 'help' for available commands.` };
    }
  }
  
  /**
   * Check if current session has permission
   */
  hasPermission(command) {
    // Basic permission check
    const writeCommands = ['create', 'update', 'delete', 'write'];
    const executeCommands = ['run', 'execute', 'deploy', 'build'];
    const configCommands = ['configure', 'settings', 'admin'];
    
    const { permissions } = this.accessLevel;
    
    if (writeCommands.some(c => command.startsWith(c)) && !permissions.includes('write')) {
      return false;
    }
    if (executeCommands.some(c => command.startsWith(c)) && !permissions.includes('execute')) {
      return false;
    }
    if (configCommands.some(c => command.startsWith(c)) && !permissions.includes('configure')) {
      return false;
    }
    
    return true;
  }
  
  /**
   * Get terminal prompt
   */
  getPrompt() {
    const session = this.currentSession;
    if (!session) {
      return `${this.quad}> `;
    }
    return `${this.quad}:${session.agentId}> `;
  }
  
  /**
   * Get terminal capabilities
   */
  getCapabilities() {
    return {
      terminal: this.quad,
      type: this.type,
      access: this.access,
      accessLevel: this.accessLevel.name,
      permissions: this.accessLevel.permissions
    };
  }
  
  /**
   * Get help text
   */
  getHelp() {
    return {
      terminal: this.name,
      commands: [
        { cmd: 'help', desc: 'Show this help' },
        { cmd: 'status', desc: 'Show terminal status' },
        { cmd: 'history', desc: 'Show command history' },
        { cmd: 'clear', desc: 'Clear history' },
        { cmd: 'exit', desc: 'End session' }
      ],
      access: this.access
    };
  }
  
  /**
   * Get terminal status
   */
  getStatus() {
    return {
      quad: this.quad,
      name: this.name,
      type: this.type,
      accessLevel: this.accessLevel.name,
      activeSessions: this.sessions.size,
      currentSession: this.currentSession?.id || null,
      metrics: this.metrics,
      uptime: Date.now() - this.createdAt
    };
  }
  
  /**
   * Heartbeat
   */
  heartbeat() {
    return {
      quad: this.quad,
      status: 'healthy',
      sessions: this.sessions.size,
      metrics: this.metrics,
      timestamp: Date.now()
    };
  }
  
  toJSON() {
    return {
      quad: this.quad,
      name: this.name,
      type: this.type,
      access: this.access,
      accessLevel: this.accessLevel.name,
      sessions: this.sessions.size,
      metrics: this.metrics,
      createdAt: this.createdAt
    };
  }
}

// ─── Specialized Terminals ───────────────────────────────────────────────────

/**
 * HQTerminal — Enterprise workspace access
 */
export class HQTerminal extends Terminal {
  constructor(config = {}) {
    super('HQTM', config);
    this.hq = config.hq || null;
  }
  
  setHQ(hq) {
    this.hq = hq;
  }
  
  async processCommand(command, args) {
    if (!this.hq) {
      return { error: 'HQ not connected' };
    }
    
    switch (command) {
      case 'workstations':
        return { data: this.hq.getWorkstations?.() || [] };
      case 'floors':
        return { data: this.hq.getFloors?.() || [] };
      case 'enter':
        return { data: this.hq.enter?.(this.currentSession.agentId, args) };
      case 'leave':
        return { data: this.hq.leave?.(this.currentSession.agentId, args) };
      case 'collaborate':
        return { data: this.hq.collaborate?.(this.currentSession.agentId, args.target, args.data) };
      case 'broadcast':
        return { data: this.hq.broadcast?.(this.currentSession.agentId, args.data) };
      default:
        return super.processCommand(command, args);
    }
  }
  
  getHelp() {
    const base = super.getHelp();
    base.commands.push(
      { cmd: 'workstations', desc: 'List workstations' },
      { cmd: 'floors', desc: 'List collaboration floors' },
      { cmd: 'enter', desc: 'Enter HQ workspace' },
      { cmd: 'leave', desc: 'Leave HQ workspace' },
      { cmd: 'collaborate', desc: 'Collaborate with another agent' },
      { cmd: 'broadcast', desc: 'Broadcast to all agents' }
    );
    return base;
  }
}

/**
 * HomeTerminal — Personal workspace access
 */
export class HomeTerminal extends Terminal {
  constructor(config = {}) {
    super('HMTM', config);
    this.home = config.home || null;
  }
  
  setHome(home) {
    this.home = home;
  }
  
  async processCommand(command, args) {
    if (!this.home) {
      return { error: 'Home not connected' };
    }
    
    switch (command) {
      case 'rooms':
        return { data: this.home.getRooms?.() || [] };
      case 'closet':
        return { data: this.home.getCloset?.() || {} };
      case 'memory':
        return { data: this.home.getMemory?.() || {} };
      case 'enter_room':
        return { data: this.home.enterRoom?.(args.room) };
      case 'equip':
        return { data: this.home.equipGarment?.(args.garment) };
      case 'remember':
        return { data: this.home.remember?.(args.key, args.value) };
      case 'recall':
        return { data: this.home.recall?.(args.key) };
      default:
        return super.processCommand(command, args);
    }
  }
  
  getHelp() {
    const base = super.getHelp();
    base.commands.push(
      { cmd: 'rooms', desc: 'List rooms in home' },
      { cmd: 'closet', desc: 'View garment closet' },
      { cmd: 'memory', desc: 'View personal memory' },
      { cmd: 'enter_room', desc: 'Enter a room' },
      { cmd: 'equip', desc: 'Equip a garment' },
      { cmd: 'remember', desc: 'Store in memory' },
      { cmd: 'recall', desc: 'Recall from memory' }
    );
    return base;
  }
}

/**
 * VaultTerminal — Data persistence access
 */
export class VaultTerminal extends Terminal {
  constructor(config = {}) {
    super('VTTM', config);
    this.vault = config.vault || null;
  }
  
  setVault(vault) {
    this.vault = vault;
  }
  
  async processCommand(command, args) {
    if (!this.vault) {
      return { error: 'Vault not connected' };
    }
    
    switch (command) {
      case 'get':
        return { data: this.vault.get?.(args.namespace, args.key) };
      case 'put':
        return { data: this.vault.put?.(args.namespace, args.key, args.value, args.options) };
      case 'delete':
        return { data: this.vault.delete?.(args.namespace, args.key) };
      case 'list':
        return { data: this.vault.list?.(args.namespace) };
      case 'namespaces':
        return { data: this.vault.getNamespaces?.() || [] };
      case 'backup':
        return { data: this.vault.backup?.() };
      default:
        return super.processCommand(command, args);
    }
  }
  
  getHelp() {
    const base = super.getHelp();
    base.commands.push(
      { cmd: 'get', desc: 'Get value from vault' },
      { cmd: 'put', desc: 'Store value in vault' },
      { cmd: 'delete', desc: 'Delete from vault' },
      { cmd: 'list', desc: 'List keys in namespace' },
      { cmd: 'namespaces', desc: 'List namespaces' },
      { cmd: 'backup', desc: 'Create backup' }
    );
    return base;
  }
}

/**
 * ErrorTerminal — Error library access
 */
export class ErrorTerminal extends Terminal {
  constructor(config = {}) {
    super('ERTM', config);
    this.errorLibrary = config.errorLibrary || null;
  }
  
  setErrorLibrary(errorLibrary) {
    this.errorLibrary = errorLibrary;
  }
  
  async processCommand(command, args) {
    if (!this.errorLibrary) {
      return { error: 'Error library not connected' };
    }
    
    switch (command) {
      case 'lookup':
        return { data: this.errorLibrary.lookup?.(args.error, args.context) };
      case 'add':
        return { data: this.errorLibrary.add?.(args.errorInfo) };
      case 'search':
        return { data: this.errorLibrary.search?.(args.query) };
      case 'categories':
        return { data: this.errorLibrary.getCategories?.() || [] };
      case 'recent':
        return { data: this.errorLibrary.getRecent?.(args.limit || 10) };
      case 'diagnose':
        return { data: this.errorLibrary.diagnose?.(args.error) };
      default:
        return super.processCommand(command, args);
    }
  }
  
  getHelp() {
    const base = super.getHelp();
    base.commands.push(
      { cmd: 'lookup', desc: 'Look up error and fixes' },
      { cmd: 'add', desc: 'Add error to library' },
      { cmd: 'search', desc: 'Search error patterns' },
      { cmd: 'categories', desc: 'List error categories' },
      { cmd: 'recent', desc: 'Show recent errors' },
      { cmd: 'diagnose', desc: 'Diagnose error' }
    );
    return base;
  }
}

/**
 * MainTerminal — Full platform access
 */
export class MainTerminal extends Terminal {
  constructor(config = {}) {
    super('MNTM', config);
    this.platform = config.platform || null;
    
    // Sub-terminals for delegation
    this.subTerminals = {
      hq: new HQTerminal({ accessLevel: config.accessLevel }),
      home: new HomeTerminal({ accessLevel: config.accessLevel }),
      vault: new VaultTerminal({ accessLevel: config.accessLevel }),
      error: new ErrorTerminal({ accessLevel: config.accessLevel })
    };
  }
  
  setPlatform(platform) {
    this.platform = platform;
    
    // Wire sub-terminals
    if (platform.hq) this.subTerminals.hq.setHQ(platform.hq);
    if (platform.vault) this.subTerminals.vault.setVault(platform.vault);
    if (platform.errorLibrary) this.subTerminals.error.setErrorLibrary(platform.errorLibrary);
  }
  
  async processCommand(command, args) {
    // Delegate to sub-terminals
    if (command.startsWith('hq.')) {
      const subCommand = command.slice(3);
      return this.subTerminals.hq.processCommand(subCommand, args);
    }
    if (command.startsWith('home.')) {
      const subCommand = command.slice(5);
      return this.subTerminals.home.processCommand(subCommand, args);
    }
    if (command.startsWith('vault.')) {
      const subCommand = command.slice(6);
      return this.subTerminals.vault.processCommand(subCommand, args);
    }
    if (command.startsWith('error.')) {
      const subCommand = command.slice(6);
      return this.subTerminals.error.processCommand(subCommand, args);
    }
    
    // Main terminal commands
    switch (command) {
      case 'dashboard':
        return { data: this.platform?.getDashboard?.() || {} };
      case 'portfolio':
        return { data: this.platform?.getPortfolio?.() || {} };
      case 'export':
        return { data: this.platform?.export?.() };
      case 'heartbeat':
        return { data: this.platform?.heartbeat?.() };
      default:
        return super.processCommand(command, args);
    }
  }
  
  getHelp() {
    const base = super.getHelp();
    base.commands.push(
      { cmd: 'dashboard', desc: 'Platform dashboard' },
      { cmd: 'portfolio', desc: 'IP portfolio' },
      { cmd: 'export', desc: 'Export platform state' },
      { cmd: 'heartbeat', desc: 'System heartbeat' },
      { cmd: 'hq.*', desc: 'HQ commands (hq.enter, hq.leave, etc.)' },
      { cmd: 'home.*', desc: 'Home commands (home.rooms, home.equip, etc.)' },
      { cmd: 'vault.*', desc: 'Vault commands (vault.get, vault.put, etc.)' },
      { cmd: 'error.*', desc: 'Error commands (error.lookup, error.add, etc.)' }
    );
    return base;
  }
}

// ─── Terminal Factory ────────────────────────────────────────────────────────
export function createTerminal(quad, config = {}) {
  switch (quad) {
    case 'HQTM':
      return new HQTerminal(config);
    case 'HMTM':
      return new HomeTerminal(config);
    case 'VTTM':
      return new VaultTerminal(config);
    case 'ERTM':
      return new ErrorTerminal(config);
    case 'MNTM':
      return new MainTerminal(config);
    default:
      return new Terminal(quad, config);
  }
}

// ─── Portfolio ───────────────────────────────────────────────────────────────
export function getTerminalPortfolio() {
  const terminals = Object.values(TERMINALS);
  const totalIPValue = terminals.reduce((sum, t) => sum + t.ipValue, 0);
  
  return {
    brand: 'Nova Organism Terminals by FreddyCreates',
    version: VERSION,
    totalTerminals: terminals.length,
    totalIPValue,
    totalIPValueFormatted: `$${(totalIPValue / 1000000).toFixed(1)}M USD`,
    terminals: terminals.map(t => ({
      quad: t.quad,
      name: t.name,
      type: t.type,
      access: t.access,
      ipValue: t.ipValue,
      ipValueFormatted: `$${(t.ipValue / 1000000).toFixed(2)}M`
    }))
  };
}

// ─── Default Export ──────────────────────────────────────────────────────────
export default {
  VERSION,
  TERMINALS,
  ACCESS_LEVELS,
  Terminal,
  HQTerminal,
  HomeTerminal,
  VaultTerminal,
  ErrorTerminal,
  MainTerminal,
  createTerminal,
  getTerminalPortfolio
};
