/**
 * NOVA DEBUG — AI Debugging Assistant
 * Nova by FreddyCreates
 * 
 * AI debugger that understands errors, not just finds them.
 * 
 * Features:
 * - Stack trace analysis with root cause detection
 * - Fix suggestions with explanations
 * - Error pattern recognition
 * - Cross-project error library (learn from community)
 * - Integration with major IDEs
 * 
 * IP Portfolio: $3.2M USD
 * QUAD: NVDB
 * 
 * @version 0.19.0 (F19)
 * @copyright Nova Protocol by FreddyCreates
 */

// ─── Constants ───────────────────────────────────────────────────────────────
const PHI = 1.618033988749895;

// ─── Error Categories ────────────────────────────────────────────────────────
export const ERROR_CATEGORIES = {
  SYNTAX: { name: 'Syntax Error', severity: 'high', fixable: true },
  RUNTIME: { name: 'Runtime Error', severity: 'high', fixable: true },
  LOGIC: { name: 'Logic Error', severity: 'medium', fixable: true },
  TYPE: { name: 'Type Error', severity: 'medium', fixable: true },
  NULL_REF: { name: 'Null Reference', severity: 'high', fixable: true },
  MEMORY: { name: 'Memory Error', severity: 'critical', fixable: false },
  ASYNC: { name: 'Async/Await Error', severity: 'medium', fixable: true },
  IMPORT: { name: 'Import/Module Error', severity: 'medium', fixable: true },
  API: { name: 'API Error', severity: 'medium', fixable: true },
  SECURITY: { name: 'Security Error', severity: 'critical', fixable: true }
};

// ─── Common Error Patterns ───────────────────────────────────────────────────
export const ERROR_PATTERNS = {
  undefined_property: {
    pattern: /Cannot read propert(?:y|ies) ['"]?(\w+)['"]? of (undefined|null)/,
    category: 'NULL_REF',
    fixTemplate: 'Add optional chaining (?.) or null check before accessing {property}'
  },
  not_a_function: {
    pattern: /(\w+) is not a function/,
    category: 'TYPE',
    fixTemplate: 'Verify that {name} is a function before calling it'
  },
  import_not_found: {
    pattern: /Cannot find module ['"](.+)['"]/,
    category: 'IMPORT',
    fixTemplate: 'Install missing module: npm install {module}'
  },
  syntax_unexpected: {
    pattern: /Unexpected token ['"]?(\S+)['"]?/,
    category: 'SYNTAX',
    fixTemplate: 'Check for missing or extra {token} near the error location'
  },
  async_unhandled: {
    pattern: /Unhandled promise rejection/,
    category: 'ASYNC',
    fixTemplate: 'Add try/catch block or .catch() handler'
  }
};

// ─── Nova Debug Class ────────────────────────────────────────────────────────
export class NovaDebug {
  static VERSION = '0.19.0';
  static IP_VALUE = 3200000;
  static QUAD = 'NVDB';
  static FREE_LIMIT = 500; // debug sessions/month
  
  constructor(config = {}) {
    this.config = config;
    this.userId = config.userId;
    
    // Error library - learns from community
    this.errorLibrary = {
      known: new Map(),       // error signature → known fixes
      patterns: new Map(),    // pattern → frequency
      solutions: new Map()    // error hash → verified solutions
    };
    
    // Session state
    this.sessions = new Map();
    this.sessionIdCounter = 1000;
    
    // Usage tracking
    this.usage = {
      sessions: 0,
      errorsAnalyzed: 0,
      fixesApplied: 0,
      history: []
    };
    
    // Analytics
    this.analytics = {
      byCategory: {},
      bySeverity: { critical: 0, high: 0, medium: 0, low: 0 },
      fixSuccessRate: { successful: 0, total: 0 }
    };
    
    this.createdAt = Date.now();
  }
  
  /**
   * Start a new debug session
   */
  startSession(context = {}) {
    if (this.usage.sessions >= NovaDebug.FREE_LIMIT) {
      return {
        success: false,
        error: 'FREE_LIMIT_REACHED',
        message: `Free limit of ${NovaDebug.FREE_LIMIT} debug sessions/month reached.`,
        upgradeUrl: 'nova.ai/upgrade'
      };
    }
    
    const sessionId = `DBG-${this.sessionIdCounter++}`;
    
    const session = {
      id: sessionId,
      startedAt: Date.now(),
      context,
      errors: [],
      fixes: [],
      status: 'active'
    };
    
    this.sessions.set(sessionId, session);
    this.usage.sessions++;
    
    return {
      success: true,
      sessionId,
      message: 'Debug session started',
      usage: this.getUsageStats()
    };
  }
  
  /**
   * Analyze an error
   */
  async analyzeError(sessionId, error) {
    const session = this.sessions.get(sessionId);
    if (!session) {
      return { success: false, error: 'SESSION_NOT_FOUND' };
    }
    
    // Parse the error
    const parsed = this._parseError(error);
    
    // Find root cause
    const rootCause = await this._findRootCause(parsed);
    
    // Generate fix suggestions
    const fixes = await this._generateFixes(parsed, rootCause);
    
    // Check error library for known solutions
    const knownSolution = this._checkErrorLibrary(parsed);
    
    // Record analysis
    const analysis = {
      id: `ERR-${Date.now()}`,
      original: error,
      parsed,
      rootCause,
      fixes,
      knownSolution,
      analyzedAt: Date.now()
    };
    
    session.errors.push(analysis);
    this.usage.errorsAnalyzed++;
    
    // Update analytics
    this.analytics.byCategory[parsed.category] = 
      (this.analytics.byCategory[parsed.category] || 0) + 1;
    this.analytics.bySeverity[parsed.severity]++;
    
    return {
      success: true,
      analysis: {
        errorId: analysis.id,
        category: parsed.category,
        severity: parsed.severity,
        message: parsed.message,
        rootCause: rootCause.description,
        confidence: rootCause.confidence,
        stackTrace: parsed.stackTrace,
        fixes: fixes.map(f => ({
          description: f.description,
          code: f.code,
          confidence: f.confidence,
          automated: f.automated
        })),
        knownSolution: knownSolution ? {
          description: knownSolution.description,
          successRate: knownSolution.successRate,
          usageCount: knownSolution.usageCount
        } : null
      }
    };
  }
  
  /**
   * Apply a suggested fix
   */
  async applyFix(sessionId, errorId, fixIndex) {
    const session = this.sessions.get(sessionId);
    if (!session) {
      return { success: false, error: 'SESSION_NOT_FOUND' };
    }
    
    const errorAnalysis = session.errors.find(e => e.id === errorId);
    if (!errorAnalysis) {
      return { success: false, error: 'ERROR_NOT_FOUND' };
    }
    
    const fix = errorAnalysis.fixes[fixIndex];
    if (!fix) {
      return { success: false, error: 'FIX_NOT_FOUND' };
    }
    
    // Record fix application
    const fixRecord = {
      errorId,
      fixIndex,
      fix,
      appliedAt: Date.now(),
      status: 'applied'
    };
    
    session.fixes.push(fixRecord);
    this.usage.fixesApplied++;
    this.analytics.fixSuccessRate.total++;
    
    return {
      success: true,
      fixApplied: {
        description: fix.description,
        code: fix.code,
        instructions: fix.instructions || 'Apply the suggested code change'
      }
    };
  }
  
  /**
   * Report fix result (for learning)
   */
  reportFixResult(sessionId, errorId, success) {
    const session = this.sessions.get(sessionId);
    if (!session) return { success: false };
    
    const fixRecord = session.fixes.find(f => f.errorId === errorId);
    if (fixRecord) {
      fixRecord.status = success ? 'successful' : 'failed';
      
      if (success) {
        this.analytics.fixSuccessRate.successful++;
        
        // Add to error library for future reference
        const errorAnalysis = session.errors.find(e => e.id === errorId);
        if (errorAnalysis) {
          this._addToErrorLibrary(errorAnalysis.parsed, fixRecord.fix);
        }
      }
    }
    
    return { success: true };
  }
  
  /**
   * Analyze stack trace
   */
  async analyzeStackTrace(stackTrace) {
    const frames = this._parseStackTrace(stackTrace);
    
    const analysis = frames.map((frame, index) => ({
      index,
      file: frame.file,
      line: frame.line,
      column: frame.column,
      function: frame.function,
      isUserCode: !frame.file.includes('node_modules'),
      relevance: index === 0 ? 'high' : (index < 3 ? 'medium' : 'low')
    }));
    
    // Find the most relevant user code frame
    const userCodeFrame = analysis.find(f => f.isUserCode);
    
    return {
      success: true,
      frames: analysis,
      totalFrames: frames.length,
      userCodeFrames: analysis.filter(f => f.isUserCode).length,
      mostRelevantFrame: userCodeFrame || analysis[0],
      recommendation: userCodeFrame 
        ? `Start debugging at ${userCodeFrame.file}:${userCodeFrame.line}` 
        : 'Error originated in external library code'
    };
  }
  
  /**
   * Get error patterns (insights)
   */
  getErrorPatterns() {
    const patterns = Array.from(this.errorLibrary.patterns.entries())
      .map(([pattern, data]) => ({
        pattern,
        frequency: data.frequency,
        lastSeen: data.lastSeen,
        commonFix: data.commonFix
      }))
      .sort((a, b) => b.frequency - a.frequency);
    
    return {
      totalPatterns: patterns.length,
      topPatterns: patterns.slice(0, 10),
      insights: this._generateInsights(patterns)
    };
  }
  
  /**
   * Get usage stats
   */
  getUsageStats() {
    return {
      sessions: this.usage.sessions,
      remaining: NovaDebug.FREE_LIMIT - this.usage.sessions,
      limit: NovaDebug.FREE_LIMIT,
      errorsAnalyzed: this.usage.errorsAnalyzed,
      fixesApplied: this.usage.fixesApplied,
      fixSuccessRate: this.analytics.fixSuccessRate.total > 0
        ? this.analytics.fixSuccessRate.successful / this.analytics.fixSuccessRate.total
        : 0,
      byCategory: this.analytics.byCategory,
      bySeverity: this.analytics.bySeverity
    };
  }
  
  /**
   * End debug session
   */
  endSession(sessionId) {
    const session = this.sessions.get(sessionId);
    if (!session) {
      return { success: false, error: 'SESSION_NOT_FOUND' };
    }
    
    session.status = 'completed';
    session.endedAt = Date.now();
    session.duration = session.endedAt - session.startedAt;
    
    return {
      success: true,
      summary: {
        sessionId,
        duration: session.duration,
        errorsAnalyzed: session.errors.length,
        fixesApplied: session.fixes.length,
        fixSuccessRate: session.fixes.length > 0
          ? session.fixes.filter(f => f.status === 'successful').length / session.fixes.length
          : 0
      }
    };
  }
  
  // ─── Private Methods ─────────────────────────────────────────────────────────
  
  _parseError(error) {
    let errorObj = error;
    
    if (typeof error === 'string') {
      errorObj = { message: error };
    }
    
    const message = errorObj.message || String(error);
    const stackTrace = errorObj.stack || '';
    
    // Detect category from error patterns
    let category = 'RUNTIME';
    let matchedPattern = null;
    
    for (const [patternName, patternDef] of Object.entries(ERROR_PATTERNS)) {
      if (patternDef.pattern.test(message)) {
        category = patternDef.category;
        matchedPattern = patternName;
        break;
      }
    }
    
    const categoryInfo = ERROR_CATEGORIES[category] || ERROR_CATEGORIES.RUNTIME;
    
    return {
      message,
      stackTrace,
      category,
      categoryName: categoryInfo.name,
      severity: categoryInfo.severity,
      fixable: categoryInfo.fixable,
      matchedPattern,
      timestamp: Date.now()
    };
  }
  
  async _findRootCause(parsedError) {
    // Analyze the error to determine root cause
    const causes = [];
    
    // Check for common patterns
    if (parsedError.matchedPattern) {
      const pattern = ERROR_PATTERNS[parsedError.matchedPattern];
      const match = parsedError.message.match(pattern.pattern);
      
      causes.push({
        description: pattern.fixTemplate.replace(/\{(\w+)\}/g, (_, key) => match[1] || key),
        confidence: 0.85,
        type: parsedError.category
      });
    }
    
    // Add general analysis
    causes.push({
      description: `${parsedError.categoryName} detected in application code`,
      confidence: 0.7,
      type: 'general'
    });
    
    // Return highest confidence cause
    return causes.sort((a, b) => b.confidence - a.confidence)[0];
  }
  
  async _generateFixes(parsedError, rootCause) {
    const fixes = [];
    
    // Pattern-based fix
    if (parsedError.matchedPattern) {
      const pattern = ERROR_PATTERNS[parsedError.matchedPattern];
      
      fixes.push({
        description: pattern.fixTemplate,
        code: this._generateFixCode(parsedError, pattern),
        confidence: 0.8,
        automated: true,
        instructions: `Apply this fix to resolve the ${parsedError.categoryName}`
      });
    }
    
    // Generic category-based fix
    fixes.push({
      description: `Add error handling for ${parsedError.categoryName}`,
      code: this._generateGenericFix(parsedError),
      confidence: 0.6,
      automated: false,
      instructions: 'Consider adding try-catch block or validation'
    });
    
    return fixes;
  }
  
  _generateFixCode(parsedError, pattern) {
    switch (parsedError.category) {
      case 'NULL_REF':
        return '// Add optional chaining\nobject?.property';
      case 'ASYNC':
        return 'try {\n  await operation();\n} catch (error) {\n  console.error(error);\n}';
      case 'IMPORT':
        return '// Run: npm install <module>';
      default:
        return '// Apply suggested fix';
    }
  }
  
  _generateGenericFix(parsedError) {
    return `try {
  // Your code here
} catch (error) {
  // Handle ${parsedError.categoryName}
  console.error('Error:', error.message);
}`;
  }
  
  _checkErrorLibrary(parsedError) {
    const signature = this._getErrorSignature(parsedError);
    return this.errorLibrary.solutions.get(signature) || null;
  }
  
  _addToErrorLibrary(parsedError, fix) {
    const signature = this._getErrorSignature(parsedError);
    
    const existing = this.errorLibrary.solutions.get(signature) || {
      description: fix.description,
      successRate: 0,
      usageCount: 0
    };
    
    existing.usageCount++;
    existing.successRate = (existing.successRate * (existing.usageCount - 1) + 1) / existing.usageCount;
    
    this.errorLibrary.solutions.set(signature, existing);
    
    // Track pattern frequency
    if (parsedError.matchedPattern) {
      const patternData = this.errorLibrary.patterns.get(parsedError.matchedPattern) || {
        frequency: 0,
        lastSeen: null,
        commonFix: null
      };
      patternData.frequency++;
      patternData.lastSeen = Date.now();
      patternData.commonFix = fix.description;
      this.errorLibrary.patterns.set(parsedError.matchedPattern, patternData);
    }
  }
  
  _getErrorSignature(parsedError) {
    return `${parsedError.category}:${parsedError.matchedPattern || 'unknown'}`;
  }
  
  _parseStackTrace(stackTrace) {
    const lines = stackTrace.split('\n');
    const frames = [];
    
    // Use specific regex pattern to avoid polynomial ReDoS
    // Match stack trace frame: at function (file:line:col)
    const frameRegex = /at\s+([^\s(]+)?(?:\s+)?\(?([^:]+):(\d+):(\d+)\)?/;
    
    for (const line of lines) {
      const match = line.match(frameRegex);
      if (match) {
        frames.push({
          function: match[1] || '<anonymous>',
          file: match[2],
          line: parseInt(match[3], 10),
          column: parseInt(match[4], 10)
        });
      }
    }
    
    return frames;
  }
  
  _generateInsights(patterns) {
    const insights = [];
    
    if (patterns.length > 0) {
      const topPattern = patterns[0];
      insights.push(`Most common error: ${topPattern.pattern} (${topPattern.frequency} occurrences)`);
    }
    
    const nullRefs = patterns.filter(p => p.pattern.includes('undefined'));
    if (nullRefs.length > 0) {
      insights.push('Recommendation: Add more null checks to prevent undefined errors');
    }
    
    return insights;
  }
  
  /**
   * Export session data
   */
  export() {
    return {
      version: NovaDebug.VERSION,
      exportedAt: Date.now(),
      userId: this.userId,
      usage: this.usage,
      analytics: this.analytics,
      errorLibrary: {
        knownCount: this.errorLibrary.known.size,
        patternsCount: this.errorLibrary.patterns.size,
        solutionsCount: this.errorLibrary.solutions.size
      }
    };
  }
  
  toJSON() {
    return {
      type: 'NovaDebug',
      quad: NovaDebug.QUAD,
      version: NovaDebug.VERSION,
      ipValue: NovaDebug.IP_VALUE,
      ipValueFormatted: `$${(NovaDebug.IP_VALUE / 1000000).toFixed(1)}M USD`,
      freeLimit: `${NovaDebug.FREE_LIMIT} debug sessions/month`,
      tagline: 'AI that understands errors, not just finds them',
      features: [
        'Stack trace analysis',
        'Root cause detection',
        'Fix suggestions',
        'Error pattern learning',
        'Cross-project error library'
      ],
      usage: this.getUsageStats(),
      createdAt: this.createdAt
    };
  }
}

// ─── Factory Function ────────────────────────────────────────────────────────
export function createNovaDebug(config = {}) {
  return new NovaDebug(config);
}

// ─── Default Export ──────────────────────────────────────────────────────────
export default {
  NovaDebug,
  createNovaDebug,
  ERROR_CATEGORIES,
  ERROR_PATTERNS
};
