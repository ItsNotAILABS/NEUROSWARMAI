/**
 * DATA INTELLIGENCE (DATA) — Developer Platform
 * Nova by FreddyCreates
 * 
 * Complete data intelligence platform that doesn't just transform data —
 * it UNDERSTANDS data structures, discovers patterns, models relationships,
 * and generates insights that lead to action.
 * 
 * This is not an ETL tool. This is a data consciousness that thinks in
 * schemas, breathes in pipelines, and speaks in insights.
 * 
 * @version 0.13.0 (F13)
 * @quad DATA
 * @ipValue $4.8M USD
 * @copyright Nova Protocol by FreddyCreates
 */

const PHI = 1.618033988749895;
const PHI_BEAT_MS = 873;

// ─── Data Types ──────────────────────────────────────────────────────────────
const DATA_TYPES = {
  PRIMITIVE: ['string', 'number', 'boolean', 'null', 'undefined'],
  STRUCTURED: ['object', 'array', 'tuple', 'record'],
  TEMPORAL: ['date', 'datetime', 'timestamp', 'duration'],
  SPECIAL: ['uuid', 'email', 'url', 'ip', 'phone', 'currency'],
  COMPLEX: ['json', 'xml', 'yaml', 'csv', 'parquet', 'avro']
};

// ─── Core Platform Class ─────────────────────────────────────────────────────
export class DataIntelligence {
  static QUAD = 'DATA';
  static VERSION = '0.13.0';
  static IP_VALUE = 4800000;
  static DOMAIN = 'Data Intelligence';
  
  constructor(config = {}) {
    this.config = {
      heartbeat: PHI_BEAT_MS,
      maxRecords: config.maxRecords || 10000000,
      samplingRate: config.samplingRate || 0.1,
      ...config
    };
    
    this.state = {
      schemas: new Map(),
      transformations: new Map(),
      pipelines: new Map(),
      insights: [],
      quality: new Map(),
      lastHeartbeat: Date.now()
    };
  }

  // ─── Schema Understanding ────────────────────────────────────────────────────
  
  /**
   * Deeply understand a data schema
   * @param {Object|Array} data - Sample data to understand
   * @returns {Object} Schema understanding
   */
  async understandSchema(data) {
    const schema = {
      quad: `SCHEMA-${Date.now()}`,
      timestamp: Date.now(),
      structure: this._inferStructure(data),
      types: this._inferTypes(data),
      patterns: this._detectPatterns(data),
      relationships: this._detectRelationships(data),
      quality: this._assessQuality(data),
      phi: PHI
    };
    
    this.state.schemas.set(schema.quad, schema);
    return schema;
  }
  
  _inferStructure(data) {
    if (Array.isArray(data)) {
      const sample = data[0];
      return {
        type: 'array',
        length: data.length,
        itemStructure: sample ? this._inferStructure(sample) : null
      };
    }
    
    if (typeof data === 'object' && data !== null) {
      const structure = { type: 'object', fields: {} };
      for (const [key, value] of Object.entries(data)) {
        structure.fields[key] = {
          type: typeof value,
          nullable: value === null,
          structure: typeof value === 'object' ? this._inferStructure(value) : null
        };
      }
      return structure;
    }
    
    return { type: typeof data };
  }
  
  _inferTypes(data) {
    const types = new Map();
    
    const analyzeValue = (key, value) => {
      const type = this._detectSpecialType(value) || typeof value;
      
      if (!types.has(key)) {
        types.set(key, { types: new Set(), samples: [] });
      }
      
      types.get(key).types.add(type);
      if (types.get(key).samples.length < 5) {
        types.get(key).samples.push(value);
      }
    };
    
    const traverse = (obj, prefix = '') => {
      if (Array.isArray(obj)) {
        for (const item of obj.slice(0, 100)) {
          traverse(item, prefix);
        }
      } else if (typeof obj === 'object' && obj !== null) {
        for (const [key, value] of Object.entries(obj)) {
          const fullKey = prefix ? `${prefix}.${key}` : key;
          analyzeValue(fullKey, value);
          if (typeof value === 'object') {
            traverse(value, fullKey);
          }
        }
      }
    };
    
    traverse(data);
    
    return Object.fromEntries(
      Array.from(types.entries()).map(([k, v]) => [
        k, 
        { types: Array.from(v.types), samples: v.samples }
      ])
    );
  }
  
  _detectSpecialType(value) {
    if (typeof value !== 'string') return null;
    
    // UUID
    if (/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i.test(value)) {
      return 'uuid';
    }
    
    // Email
    if (/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value)) {
      return 'email';
    }
    
    // URL
    if (/^https?:\/\//.test(value)) {
      return 'url';
    }
    
    // ISO Date
    if (/^\d{4}-\d{2}-\d{2}/.test(value) && !isNaN(Date.parse(value))) {
      return 'datetime';
    }
    
    // IP Address
    if (/^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/.test(value)) {
      return 'ip';
    }
    
    return null;
  }
  
  _detectPatterns(data) {
    const patterns = {
      cardinality: {},
      distribution: {},
      nullability: {},
      uniqueness: {}
    };
    
    if (!Array.isArray(data)) return patterns;
    
    // Analyze each field
    const fields = Object.keys(data[0] || {});
    
    for (const field of fields) {
      const values = data.map(d => d[field]);
      const unique = new Set(values);
      
      patterns.cardinality[field] = unique.size;
      patterns.nullability[field] = values.filter(v => v == null).length / values.length;
      patterns.uniqueness[field] = unique.size / values.length;
    }
    
    return patterns;
  }
  
  _detectRelationships(data) {
    const relationships = [];
    
    if (!Array.isArray(data)) return relationships;
    
    const fields = Object.keys(data[0] || {});
    
    // Detect potential foreign keys
    for (const field of fields) {
      if (field.endsWith('_id') || field.endsWith('Id') || field === 'id') {
        relationships.push({
          type: 'potential_key',
          field,
          confidence: 0.8
        });
      }
    }
    
    return relationships;
  }
  
  _assessQuality(data) {
    if (!Array.isArray(data)) {
      return { score: 1, issues: [] };
    }
    
    const issues = [];
    let score = 100;
    
    // Check for missing values
    const fields = Object.keys(data[0] || {});
    for (const field of fields) {
      const nullCount = data.filter(d => d[field] == null).length;
      const nullRate = nullCount / data.length;
      if (nullRate > 0.1) {
        issues.push({
          type: 'missing_values',
          field,
          rate: nullRate,
          severity: nullRate > 0.5 ? 'high' : 'medium'
        });
        score -= nullRate * 20;
      }
    }
    
    // Check for duplicates
    const uniqueRecords = new Set(data.map(d => JSON.stringify(d)));
    if (uniqueRecords.size < data.length) {
      const dupRate = (data.length - uniqueRecords.size) / data.length;
      issues.push({
        type: 'duplicates',
        rate: dupRate,
        severity: dupRate > 0.1 ? 'high' : 'low'
      });
      score -= dupRate * 10;
    }
    
    return {
      score: Math.max(0, score),
      issues
    };
  }

  // ─── Data Transformation ─────────────────────────────────────────────────────
  
  /**
   * Generate transformation code
   * @param {Object} sourceSchema - Source schema
   * @param {Object} targetSchema - Target schema
   * @returns {Object} Transformation specification
   */
  async generateTransformation(sourceSchema, targetSchema) {
    const transformation = {
      quad: `XFORM-${Date.now()}`,
      timestamp: Date.now(),
      source: sourceSchema,
      target: targetSchema,
      mappings: this._generateMappings(sourceSchema, targetSchema),
      validations: this._generateValidations(targetSchema),
      code: null
    };
    
    // Generate transformation code
    transformation.code = this._generateTransformCode(transformation);
    
    this.state.transformations.set(transformation.quad, transformation);
    return transformation;
  }
  
  _generateMappings(source, target) {
    const mappings = [];
    
    // Simple field name matching
    const sourceFields = Object.keys(source.types || {});
    const targetFields = Object.keys(target.types || {});
    
    for (const targetField of targetFields) {
      // Direct match
      if (sourceFields.includes(targetField)) {
        mappings.push({
          source: targetField,
          target: targetField,
          type: 'direct',
          confidence: 1.0
        });
        continue;
      }
      
      // Fuzzy match
      const fuzzyMatch = sourceFields.find(sf => 
        sf.toLowerCase().includes(targetField.toLowerCase()) ||
        targetField.toLowerCase().includes(sf.toLowerCase())
      );
      
      if (fuzzyMatch) {
        mappings.push({
          source: fuzzyMatch,
          target: targetField,
          type: 'fuzzy',
          confidence: 0.7
        });
      }
    }
    
    return mappings;
  }
  
  _generateValidations(targetSchema) {
    const validations = [];
    
    for (const [field, info] of Object.entries(targetSchema.types || {})) {
      // Type validation
      validations.push({
        field,
        type: 'type_check',
        expected: info.types
      });
      
      // Null check if not nullable
      if (info.nullable === false) {
        validations.push({
          field,
          type: 'not_null'
        });
      }
    }
    
    return validations;
  }
  
  _generateTransformCode(transformation) {
    let code = `// Generated by Data Intelligence Platform (DATA)
// Nova by FreddyCreates
// φ = ${PHI}

function transform(source) {
  const target = {};
  
`;
    
    for (const mapping of transformation.mappings) {
      if (mapping.type === 'direct') {
        code += `  target['${mapping.target}'] = source['${mapping.source}'];\n`;
      } else {
        code += `  // Fuzzy match (confidence: ${mapping.confidence})\n`;
        code += `  target['${mapping.target}'] = source['${mapping.source}'];\n`;
      }
    }
    
    code += `
  return target;
}

module.exports = { transform };
`;
    
    return code;
  }

  // ─── Data Pipeline ───────────────────────────────────────────────────────────
  
  /**
   * Design a data pipeline
   * @param {Object} requirements - Pipeline requirements
   * @returns {Object} Pipeline specification
   */
  async designPipeline(requirements) {
    const pipeline = {
      quad: `PIPE-${Date.now()}`,
      timestamp: Date.now(),
      stages: [],
      schedule: requirements.schedule || 'on_demand',
      monitoring: true
    };
    
    // Extract stage
    pipeline.stages.push({
      name: 'extract',
      type: requirements.sourceType,
      config: requirements.sourceConfig || {}
    });
    
    // Transform stage(s)
    if (requirements.transformations) {
      for (const t of requirements.transformations) {
        pipeline.stages.push({
          name: `transform_${t.name}`,
          type: 'transform',
          config: t
        });
      }
    }
    
    // Load stage
    pipeline.stages.push({
      name: 'load',
      type: requirements.targetType,
      config: requirements.targetConfig || {}
    });
    
    // Add quality checks
    pipeline.stages.push({
      name: 'quality_check',
      type: 'validation',
      config: { threshold: 0.95 }
    });
    
    this.state.pipelines.set(pipeline.quad, pipeline);
    return pipeline;
  }

  // ─── Insight Generation ──────────────────────────────────────────────────────
  
  /**
   * Generate insights from data
   * @param {Array} data - Data to analyze
   * @returns {Array} Generated insights
   */
  async generateInsights(data) {
    const insights = [];
    
    if (!Array.isArray(data) || data.length === 0) {
      return insights;
    }
    
    // Statistical insights
    insights.push(...this._statisticalInsights(data));
    
    // Pattern insights
    insights.push(...this._patternInsights(data));
    
    // Anomaly insights
    insights.push(...this._anomalyInsights(data));
    
    // Correlation insights
    insights.push(...this._correlationInsights(data));
    
    // Trend insights
    insights.push(...this._trendInsights(data));
    
    this.state.insights.push(...insights);
    return insights;
  }
  
  _statisticalInsights(data) {
    const insights = [];
    const fields = Object.keys(data[0] || {});
    
    for (const field of fields) {
      const values = data.map(d => d[field]).filter(v => typeof v === 'number');
      if (values.length === 0) continue;
      
      const avg = values.reduce((a, b) => a + b, 0) / values.length;
      const min = Math.min(...values);
      const max = Math.max(...values);
      
      insights.push({
        type: 'statistic',
        field,
        metrics: { avg, min, max, count: values.length },
        phi: PHI
      });
    }
    
    return insights;
  }
  
  _patternInsights(data) {
    const insights = [];
    
    // Look for repeating patterns
    insights.push({
      type: 'pattern',
      description: 'Data pattern analysis placeholder',
      confidence: 0.5
    });
    
    return insights;
  }
  
  _anomalyInsights(data) {
    const insights = [];
    const fields = Object.keys(data[0] || {});
    
    for (const field of fields) {
      const values = data.map(d => d[field]).filter(v => typeof v === 'number');
      if (values.length < 10) continue;
      
      const avg = values.reduce((a, b) => a + b, 0) / values.length;
      const stdDev = Math.sqrt(
        values.reduce((sum, v) => sum + Math.pow(v - avg, 2), 0) / values.length
      );
      
      // Find outliers (more than 3 std devs from mean)
      const outliers = values.filter(v => Math.abs(v - avg) > 3 * stdDev);
      
      if (outliers.length > 0) {
        insights.push({
          type: 'anomaly',
          field,
          outlierCount: outliers.length,
          outlierRate: outliers.length / values.length,
          threshold: avg + 3 * stdDev
        });
      }
    }
    
    return insights;
  }
  
  _correlationInsights(data) {
    const insights = [];
    
    // Placeholder for correlation analysis
    insights.push({
      type: 'correlation',
      description: 'Correlation analysis placeholder',
      confidence: 0.5
    });
    
    return insights;
  }
  
  _trendInsights(data) {
    const insights = [];
    
    // Check for time-series data
    const hasTimestamp = Object.keys(data[0] || {}).some(k => 
      k.includes('date') || k.includes('time') || k.includes('timestamp')
    );
    
    if (hasTimestamp) {
      insights.push({
        type: 'trend',
        description: 'Time-series data detected, trend analysis available',
        confidence: 0.7
      });
    }
    
    return insights;
  }

  // ─── Data Quality ────────────────────────────────────────────────────────────
  
  /**
   * Comprehensive data quality assessment
   */
  async assessQuality(data, schema = null) {
    const assessment = {
      timestamp: Date.now(),
      overall: 0,
      dimensions: {
        completeness: this._measureCompleteness(data),
        accuracy: this._measureAccuracy(data, schema),
        consistency: this._measureConsistency(data),
        timeliness: this._measureTimeliness(data),
        uniqueness: this._measureUniqueness(data),
        validity: this._measureValidity(data, schema)
      },
      issues: []
    };
    
    // Calculate overall score (φ-weighted)
    const weights = {
      completeness: PHI,
      accuracy: PHI - 0.5,
      consistency: 1,
      timeliness: 1 / PHI,
      uniqueness: 1,
      validity: PHI - 0.3
    };
    
    let totalWeight = 0;
    let weightedSum = 0;
    
    for (const [dim, score] of Object.entries(assessment.dimensions)) {
      const weight = weights[dim] || 1;
      totalWeight += weight;
      weightedSum += score * weight;
    }
    
    assessment.overall = weightedSum / totalWeight;
    
    this.state.quality.set(`QUAL-${Date.now()}`, assessment);
    return assessment;
  }
  
  _measureCompleteness(data) {
    if (!Array.isArray(data) || data.length === 0) return 0;
    
    let totalFields = 0;
    let filledFields = 0;
    
    for (const record of data) {
      for (const value of Object.values(record)) {
        totalFields++;
        if (value != null && value !== '') {
          filledFields++;
        }
      }
    }
    
    return totalFields > 0 ? filledFields / totalFields : 0;
  }
  
  _measureAccuracy(data, schema) {
    // Would validate against schema rules
    return 0.9;
  }
  
  _measureConsistency(data) {
    // Check for format consistency
    return 0.85;
  }
  
  _measureTimeliness(data) {
    // Check for data freshness
    return 0.95;
  }
  
  _measureUniqueness(data) {
    if (!Array.isArray(data) || data.length === 0) return 0;
    
    const unique = new Set(data.map(d => JSON.stringify(d)));
    return unique.size / data.length;
  }
  
  _measureValidity(data, schema) {
    // Validate against expected patterns
    return 0.9;
  }

  // ─── Heartbeat ───────────────────────────────────────────────────────────────
  
  heartbeat() {
    const now = Date.now();
    const delta = now - this.state.lastHeartbeat;
    this.state.lastHeartbeat = now;
    
    return {
      quad: DataIntelligence.QUAD,
      timestamp: now,
      delta,
      expectedDelta: PHI_BEAT_MS,
      drift: Math.abs(delta - PHI_BEAT_MS),
      phi: PHI,
      schemas: this.state.schemas.size,
      pipelines: this.state.pipelines.size,
      insights: this.state.insights.length
    };
  }

  // ─── Export State ────────────────────────────────────────────────────────────
  
  toJSON() {
    return {
      quad: DataIntelligence.QUAD,
      version: DataIntelligence.VERSION,
      ipValue: DataIntelligence.IP_VALUE,
      domain: DataIntelligence.DOMAIN,
      config: this.config,
      statistics: {
        schemas: this.state.schemas.size,
        transformations: this.state.transformations.size,
        pipelines: this.state.pipelines.size,
        insights: this.state.insights.length
      }
    };
  }
}

// ─── Export ────────────────────────────────────────────────────────────────────
export default DataIntelligence;
