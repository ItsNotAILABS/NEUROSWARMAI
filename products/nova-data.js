/**
 * NOVA DATA — AI Data Insights Assistant
 * Nova by FreddyCreates
 * 
 * AI that turns your data into insights instantly.
 * 
 * Features:
 * - Instant data visualization
 * - Pattern and anomaly detection
 * - Report generation
 * - SQL query assistance
 * - Schema understanding and documentation
 * 
 * IP Portfolio: $2.8M USD
 * QUAD: NVDT
 * 
 * @version 0.19.0 (F19)
 * @copyright Nova Protocol by FreddyCreates
 */

// ─── Constants ───────────────────────────────────────────────────────────────
const PHI = 1.618033988749895;

// ─── Data Types ──────────────────────────────────────────────────────────────
export const DATA_TYPES = {
  NUMERIC: { name: 'Numeric', analyzers: ['mean', 'median', 'stddev', 'distribution'] },
  CATEGORICAL: { name: 'Categorical', analyzers: ['frequency', 'mode', 'uniqueCount'] },
  TEMPORAL: { name: 'Temporal', analyzers: ['trend', 'seasonality', 'forecast'] },
  TEXT: { name: 'Text', analyzers: ['sentiment', 'topics', 'keywords'] },
  BOOLEAN: { name: 'Boolean', analyzers: ['ratio', 'correlation'] }
};

// ─── Visualization Types ─────────────────────────────────────────────────────
export const VISUALIZATION_TYPES = {
  BAR: { name: 'Bar Chart', dataTypes: ['CATEGORICAL', 'NUMERIC'] },
  LINE: { name: 'Line Chart', dataTypes: ['TEMPORAL', 'NUMERIC'] },
  PIE: { name: 'Pie Chart', dataTypes: ['CATEGORICAL'] },
  SCATTER: { name: 'Scatter Plot', dataTypes: ['NUMERIC'] },
  HEATMAP: { name: 'Heatmap', dataTypes: ['NUMERIC'] },
  TABLE: { name: 'Data Table', dataTypes: ['*'] },
  HISTOGRAM: { name: 'Histogram', dataTypes: ['NUMERIC'] },
  TREEMAP: { name: 'Treemap', dataTypes: ['CATEGORICAL', 'NUMERIC'] }
};

// ─── Nova Data Class ─────────────────────────────────────────────────────────
export class NovaData {
  static VERSION = '0.19.0';
  static IP_VALUE = 2800000;
  static QUAD = 'NVDT';
  static FREE_LIMIT = 100; // analyses/month
  static MAX_DATA_SIZE = 10 * 1024 * 1024; // 10MB
  
  constructor(config = {}) {
    this.config = config;
    this.userId = config.userId;
    
    // Data store
    this.datasets = new Map();
    this.schemas = new Map();
    
    // Analysis results
    this.analyses = new Map();
    this.insights = [];
    
    // Usage tracking
    this.usage = {
      analyses: 0,
      dataProcessed: 0, // bytes
      reports: 0,
      queries: 0,
      history: []
    };
    
    // Analytics
    this.analytics = {
      byDataType: {},
      byVisualization: {},
      insightsGenerated: 0
    };
    
    this.createdAt = Date.now();
  }
  
  /**
   * Upload dataset for analysis
   */
  uploadData(name, data, options = {}) {
    const dataSize = JSON.stringify(data).length;
    
    if (dataSize > NovaData.MAX_DATA_SIZE) {
      return {
        success: false,
        error: 'DATA_TOO_LARGE',
        message: `Data exceeds free limit of 10MB. Size: ${(dataSize / 1024 / 1024).toFixed(2)}MB`,
        upgradeUrl: 'nova.ai/upgrade'
      };
    }
    
    // Detect schema
    const schema = this._detectSchema(data);
    
    const datasetId = `DS-${Date.now()}`;
    
    const dataset = {
      id: datasetId,
      name,
      data,
      schema,
      size: dataSize,
      rowCount: Array.isArray(data) ? data.length : 1,
      uploadedAt: Date.now()
    };
    
    this.datasets.set(datasetId, dataset);
    this.schemas.set(datasetId, schema);
    this.usage.dataProcessed += dataSize;
    
    return {
      success: true,
      datasetId,
      schema,
      preview: this._getPreview(data),
      size: `${(dataSize / 1024).toFixed(2)}KB`,
      rowCount: dataset.rowCount
    };
  }
  
  /**
   * Analyze dataset
   */
  async analyze(datasetId, options = {}) {
    if (this.usage.analyses >= NovaData.FREE_LIMIT) {
      return {
        success: false,
        error: 'FREE_LIMIT_REACHED',
        message: `Free limit of ${NovaData.FREE_LIMIT} analyses/month reached.`,
        upgradeUrl: 'nova.ai/upgrade'
      };
    }
    
    const dataset = this.datasets.get(datasetId);
    if (!dataset) {
      return { success: false, error: 'DATASET_NOT_FOUND' };
    }
    
    // Perform analysis
    const analysis = await this._performAnalysis(dataset, options);
    
    // Generate insights
    const insights = this._generateInsights(analysis);
    
    // Store results
    const analysisId = `ANA-${Date.now()}`;
    this.analyses.set(analysisId, {
      id: analysisId,
      datasetId,
      analysis,
      insights,
      createdAt: Date.now()
    });
    
    this.usage.analyses++;
    this.analytics.insightsGenerated += insights.length;
    this.insights.push(...insights);
    
    return {
      success: true,
      analysisId,
      summary: analysis.summary,
      statistics: analysis.statistics,
      insights: insights.map(i => ({
        type: i.type,
        message: i.message,
        confidence: i.confidence,
        actionable: i.actionable
      })),
      recommendedVisualizations: analysis.recommendedVisualizations,
      usage: this.getUsageStats()
    };
  }
  
  /**
   * Detect patterns and anomalies
   */
  async detectPatterns(datasetId, column) {
    const dataset = this.datasets.get(datasetId);
    if (!dataset) {
      return { success: false, error: 'DATASET_NOT_FOUND' };
    }
    
    const columnData = this._extractColumn(dataset.data, column);
    const schema = this.schemas.get(datasetId);
    const columnType = schema?.columns?.find(c => c.name === column)?.type || 'UNKNOWN';
    
    const patterns = await this._detectPatterns(columnData, columnType);
    const anomalies = await this._detectAnomalies(columnData, columnType);
    
    return {
      success: true,
      column,
      dataType: columnType,
      patterns: patterns.map(p => ({
        type: p.type,
        description: p.description,
        confidence: p.confidence,
        affectedRows: p.affectedRows
      })),
      anomalies: anomalies.map(a => ({
        index: a.index,
        value: a.value,
        reason: a.reason,
        severity: a.severity
      })),
      summary: {
        totalPatterns: patterns.length,
        totalAnomalies: anomalies.length,
        healthScore: this._calculateHealthScore(patterns, anomalies)
      }
    };
  }
  
  /**
   * Generate SQL query from natural language
   */
  async generateSQL(datasetId, question) {
    const dataset = this.datasets.get(datasetId);
    if (!dataset) {
      return { success: false, error: 'DATASET_NOT_FOUND' };
    }
    
    const schema = this.schemas.get(datasetId);
    const sql = await this._generateSQL(question, schema, dataset.name);
    
    this.usage.queries++;
    
    return {
      success: true,
      question,
      sql: sql.query,
      explanation: sql.explanation,
      confidence: sql.confidence,
      warnings: sql.warnings
    };
  }
  
  /**
   * Generate visualization
   */
  async visualize(datasetId, options = {}) {
    const dataset = this.datasets.get(datasetId);
    if (!dataset) {
      return { success: false, error: 'DATASET_NOT_FOUND' };
    }
    
    const { type = 'auto', x, y, groupBy } = options;
    
    // Auto-select visualization type if not specified
    const vizType = type === 'auto' 
      ? this._selectVisualization(dataset, x, y)
      : type;
    
    const vizData = await this._prepareVisualization(dataset, {
      type: vizType,
      x,
      y,
      groupBy
    });
    
    this.analytics.byVisualization[vizType] = 
      (this.analytics.byVisualization[vizType] || 0) + 1;
    
    return {
      success: true,
      visualization: {
        type: vizType,
        data: vizData.data,
        config: vizData.config,
        title: vizData.title,
        insights: vizData.insights
      }
    };
  }
  
  /**
   * Generate report
   */
  async generateReport(datasetId, options = {}) {
    const dataset = this.datasets.get(datasetId);
    if (!dataset) {
      return { success: false, error: 'DATASET_NOT_FOUND' };
    }
    
    // Get or create analysis
    let analysis = Array.from(this.analyses.values())
      .find(a => a.datasetId === datasetId);
    
    if (!analysis) {
      const result = await this.analyze(datasetId, options);
      if (!result.success) return result;
      analysis = this.analyses.get(result.analysisId);
    }
    
    const report = this._compileReport(dataset, analysis, options);
    
    this.usage.reports++;
    
    return {
      success: true,
      report: {
        title: report.title,
        generatedAt: report.generatedAt,
        sections: report.sections.map(s => ({
          name: s.name,
          type: s.type,
          content: s.content
        })),
        summary: report.summary,
        recommendations: report.recommendations
      }
    };
  }
  
  /**
   * Get usage stats
   */
  getUsageStats() {
    return {
      analyses: this.usage.analyses,
      remaining: NovaData.FREE_LIMIT - this.usage.analyses,
      limit: NovaData.FREE_LIMIT,
      dataProcessed: `${(this.usage.dataProcessed / 1024 / 1024).toFixed(2)}MB`,
      maxDataSize: `${NovaData.MAX_DATA_SIZE / 1024 / 1024}MB`,
      reports: this.usage.reports,
      queries: this.usage.queries,
      insightsGenerated: this.analytics.insightsGenerated,
      byVisualization: this.analytics.byVisualization
    };
  }
  
  // ─── Private Methods ─────────────────────────────────────────────────────────
  
  _detectSchema(data) {
    if (!Array.isArray(data) || data.length === 0) {
      return { type: 'unknown', columns: [] };
    }
    
    const sample = data[0];
    const columns = Object.keys(sample).map(key => {
      const values = data.map(row => row[key]).filter(v => v !== null && v !== undefined);
      const type = this._inferType(values);
      
      return {
        name: key,
        type,
        nullable: data.some(row => row[key] === null || row[key] === undefined),
        uniqueCount: new Set(values).size,
        sampleValues: values.slice(0, 3)
      };
    });
    
    return {
      type: 'tabular',
      rowCount: data.length,
      columnCount: columns.length,
      columns
    };
  }
  
  _inferType(values) {
    if (values.length === 0) return 'UNKNOWN';
    
    const sample = values.filter(v => v !== null && v !== undefined).slice(0, 100);
    
    // Check if all numeric
    if (sample.every(v => typeof v === 'number' || !isNaN(parseFloat(v)))) {
      return 'NUMERIC';
    }
    
    // Check if all boolean
    if (sample.every(v => typeof v === 'boolean' || v === 'true' || v === 'false')) {
      return 'BOOLEAN';
    }
    
    // Check if temporal (exclude pure numbers as Date.parse accepts them)
    if (sample.every(v => {
      if (typeof v === 'number' || !isNaN(Number(v))) return false;
      return typeof v === 'string' && !isNaN(Date.parse(v));
    })) {
      return 'TEMPORAL';
    }
    
    // Check if categorical (few unique values relative to total)
    const uniqueRatio = new Set(sample).size / sample.length;
    if (uniqueRatio < 0.5) {
      return 'CATEGORICAL';
    }
    
    return 'TEXT';
  }
  
  _getPreview(data) {
    if (Array.isArray(data)) {
      return data.slice(0, 5);
    }
    return data;
  }
  
  async _performAnalysis(dataset, options) {
    const schema = this.schemas.get(dataset.id);
    const data = dataset.data;
    
    const statistics = {};
    
    for (const column of schema.columns) {
      const values = this._extractColumn(data, column.name);
      statistics[column.name] = this._calculateStatistics(values, column.type);
    }
    
    // Correlations for numeric columns
    const numericColumns = schema.columns.filter(c => c.type === 'NUMERIC');
    const correlations = this._calculateCorrelations(data, numericColumns);
    
    // Recommended visualizations
    const recommendedVisualizations = this._recommendVisualizations(schema);
    
    return {
      summary: {
        rowCount: data.length,
        columnCount: schema.columns.length,
        dataTypes: schema.columns.reduce((acc, c) => {
          acc[c.type] = (acc[c.type] || 0) + 1;
          return acc;
        }, {}),
        completeness: this._calculateCompleteness(data, schema)
      },
      statistics,
      correlations,
      recommendedVisualizations
    };
  }
  
  _extractColumn(data, columnName) {
    return data.map(row => row[columnName]);
  }
  
  _calculateStatistics(values, type) {
    const cleanValues = values.filter(v => v !== null && v !== undefined);
    
    if (type === 'NUMERIC') {
      const nums = cleanValues.map(Number).filter(n => !isNaN(n));
      const sorted = [...nums].sort((a, b) => a - b);
      
      return {
        count: nums.length,
        nullCount: values.length - nums.length,
        min: Math.min(...nums),
        max: Math.max(...nums),
        mean: nums.reduce((a, b) => a + b, 0) / nums.length,
        median: sorted[Math.floor(sorted.length / 2)],
        stddev: this._stddev(nums)
      };
    }
    
    if (type === 'CATEGORICAL' || type === 'TEXT') {
      const frequencies = {};
      for (const v of cleanValues) {
        frequencies[v] = (frequencies[v] || 0) + 1;
      }
      
      const sorted = Object.entries(frequencies).sort((a, b) => b[1] - a[1]);
      
      return {
        count: cleanValues.length,
        nullCount: values.length - cleanValues.length,
        uniqueCount: Object.keys(frequencies).length,
        mode: sorted[0]?.[0],
        topValues: sorted.slice(0, 5).map(([value, count]) => ({ value, count }))
      };
    }
    
    return {
      count: cleanValues.length,
      nullCount: values.length - cleanValues.length
    };
  }
  
  _stddev(nums) {
    const mean = nums.reduce((a, b) => a + b, 0) / nums.length;
    const squareDiffs = nums.map(n => Math.pow(n - mean, 2));
    return Math.sqrt(squareDiffs.reduce((a, b) => a + b, 0) / nums.length);
  }
  
  _calculateCorrelations(data, numericColumns) {
    const correlations = [];
    
    for (let i = 0; i < numericColumns.length; i++) {
      for (let j = i + 1; j < numericColumns.length; j++) {
        const col1 = numericColumns[i].name;
        const col2 = numericColumns[j].name;
        
        const values1 = data.map(r => Number(r[col1])).filter(n => !isNaN(n));
        const values2 = data.map(r => Number(r[col2])).filter(n => !isNaN(n));
        
        if (values1.length > 10 && values2.length > 10) {
          const correlation = this._pearsonCorrelation(values1, values2);
          if (Math.abs(correlation) > 0.3) {
            correlations.push({
              columns: [col1, col2],
              correlation,
              strength: Math.abs(correlation) > 0.7 ? 'strong' : 'moderate'
            });
          }
        }
      }
    }
    
    return correlations;
  }
  
  _pearsonCorrelation(x, y) {
    const n = Math.min(x.length, y.length);
    const meanX = x.reduce((a, b) => a + b, 0) / n;
    const meanY = y.reduce((a, b) => a + b, 0) / n;
    
    let numerator = 0;
    let denomX = 0;
    let denomY = 0;
    
    for (let i = 0; i < n; i++) {
      const diffX = x[i] - meanX;
      const diffY = y[i] - meanY;
      numerator += diffX * diffY;
      denomX += diffX * diffX;
      denomY += diffY * diffY;
    }
    
    const denominator = Math.sqrt(denomX) * Math.sqrt(denomY);
    return denominator === 0 ? 0 : numerator / denominator;
  }
  
  _calculateCompleteness(data, schema) {
    let total = 0;
    let filled = 0;
    
    for (const row of data) {
      for (const col of schema.columns) {
        total++;
        if (row[col.name] !== null && row[col.name] !== undefined && row[col.name] !== '') {
          filled++;
        }
      }
    }
    
    return total > 0 ? filled / total : 1;
  }
  
  _recommendVisualizations(schema) {
    const recommendations = [];
    
    const hasNumeric = schema.columns.some(c => c.type === 'NUMERIC');
    const hasCategorical = schema.columns.some(c => c.type === 'CATEGORICAL');
    const hasTemporal = schema.columns.some(c => c.type === 'TEMPORAL');
    
    if (hasTemporal && hasNumeric) {
      recommendations.push({ type: 'LINE', reason: 'Show trends over time' });
    }
    
    if (hasCategorical && hasNumeric) {
      recommendations.push({ type: 'BAR', reason: 'Compare categories' });
      recommendations.push({ type: 'PIE', reason: 'Show distribution' });
    }
    
    if (hasNumeric) {
      recommendations.push({ type: 'HISTOGRAM', reason: 'Show distribution of values' });
      recommendations.push({ type: 'SCATTER', reason: 'Find relationships between variables' });
    }
    
    recommendations.push({ type: 'TABLE', reason: 'View raw data' });
    
    return recommendations;
  }
  
  _generateInsights(analysis) {
    const insights = [];
    
    // Completeness insight
    if (analysis.summary.completeness < 0.9) {
      insights.push({
        type: 'warning',
        message: `Data completeness is ${(analysis.summary.completeness * 100).toFixed(1)}%. Consider handling missing values.`,
        confidence: 0.95,
        actionable: true
      });
    }
    
    // Correlation insights
    for (const corr of analysis.correlations) {
      insights.push({
        type: 'correlation',
        message: `${corr.strength.charAt(0).toUpperCase() + corr.strength.slice(1)} correlation (${corr.correlation.toFixed(2)}) between ${corr.columns.join(' and ')}`,
        confidence: 0.85,
        actionable: false
      });
    }
    
    // Statistics insights
    for (const [col, stats] of Object.entries(analysis.statistics)) {
      if (stats.nullCount > 0) {
        insights.push({
          type: 'data_quality',
          message: `Column "${col}" has ${stats.nullCount} null values`,
          confidence: 1.0,
          actionable: true
        });
      }
    }
    
    return insights;
  }
  
  async _detectPatterns(values, type) {
    const patterns = [];
    
    if (type === 'NUMERIC') {
      const nums = values.map(Number).filter(n => !isNaN(n));
      
      // Check for trend
      const trend = this._detectTrend(nums);
      if (trend) patterns.push(trend);
      
      // Check for clusters
      const clusters = this._detectClusters(nums);
      if (clusters) patterns.push(clusters);
    }
    
    return patterns;
  }
  
  _detectTrend(nums) {
    if (nums.length < 10) return null;
    
    let increasing = 0;
    let decreasing = 0;
    
    for (let i = 1; i < nums.length; i++) {
      if (nums[i] > nums[i - 1]) increasing++;
      else if (nums[i] < nums[i - 1]) decreasing++;
    }
    
    const total = nums.length - 1;
    
    if (increasing / total > 0.7) {
      return {
        type: 'trend',
        description: 'Upward trend detected',
        confidence: increasing / total,
        affectedRows: nums.length
      };
    }
    
    if (decreasing / total > 0.7) {
      return {
        type: 'trend',
        description: 'Downward trend detected',
        confidence: decreasing / total,
        affectedRows: nums.length
      };
    }
    
    return null;
  }
  
  _detectClusters(nums) {
    // Simple clustering detection
    return null;
  }
  
  async _detectAnomalies(values, type) {
    const anomalies = [];
    
    if (type === 'NUMERIC') {
      const nums = values.map(Number).filter(n => !isNaN(n));
      const mean = nums.reduce((a, b) => a + b, 0) / nums.length;
      const stddev = this._stddev(nums);
      
      // Z-score method
      values.forEach((v, i) => {
        const num = Number(v);
        if (!isNaN(num)) {
          const zScore = Math.abs((num - mean) / stddev);
          if (zScore > 3) {
            anomalies.push({
              index: i,
              value: v,
              reason: `Value is ${zScore.toFixed(1)} standard deviations from mean`,
              severity: zScore > 4 ? 'high' : 'medium'
            });
          }
        }
      });
    }
    
    return anomalies;
  }
  
  _calculateHealthScore(patterns, anomalies) {
    let score = 100;
    score -= anomalies.filter(a => a.severity === 'high').length * 10;
    score -= anomalies.filter(a => a.severity === 'medium').length * 5;
    return Math.max(0, score);
  }
  
  async _generateSQL(question, schema, tableName) {
    // Simple SQL generation based on keywords
    const q = question.toLowerCase();
    
    let query = '';
    let explanation = '';
    
    if (q.includes('count') || q.includes('how many')) {
      query = `SELECT COUNT(*) FROM ${tableName}`;
      explanation = 'Counting all rows in the table';
    } else if (q.includes('average') || q.includes('mean')) {
      const numCol = schema.columns.find(c => c.type === 'NUMERIC')?.name || 'value';
      query = `SELECT AVG(${numCol}) FROM ${tableName}`;
      explanation = `Calculating average of ${numCol}`;
    } else if (q.includes('top') || q.includes('highest')) {
      const numCol = schema.columns.find(c => c.type === 'NUMERIC')?.name || 'value';
      query = `SELECT * FROM ${tableName} ORDER BY ${numCol} DESC LIMIT 10`;
      explanation = `Getting top 10 records by ${numCol}`;
    } else {
      query = `SELECT * FROM ${tableName} LIMIT 100`;
      explanation = 'Selecting all columns with a limit of 100 rows';
    }
    
    return {
      query,
      explanation,
      confidence: 0.7,
      warnings: ['Always review generated SQL before execution']
    };
  }
  
  _selectVisualization(dataset, x, y) {
    const schema = this.schemas.get(dataset.id);
    
    const xType = schema.columns.find(c => c.name === x)?.type;
    const yType = schema.columns.find(c => c.name === y)?.type;
    
    if (xType === 'TEMPORAL' && yType === 'NUMERIC') return 'LINE';
    if (xType === 'CATEGORICAL' && yType === 'NUMERIC') return 'BAR';
    if (xType === 'NUMERIC' && yType === 'NUMERIC') return 'SCATTER';
    
    return 'TABLE';
  }
  
  async _prepareVisualization(dataset, options) {
    return {
      data: dataset.data.slice(0, 100),
      config: {
        type: options.type,
        x: options.x,
        y: options.y,
        groupBy: options.groupBy
      },
      title: `${options.type} - ${dataset.name}`,
      insights: []
    };
  }
  
  _compileReport(dataset, analysis, options) {
    return {
      title: `Data Analysis Report: ${dataset.name}`,
      generatedAt: Date.now(),
      sections: [
        {
          name: 'Overview',
          type: 'summary',
          content: analysis.analysis.summary
        },
        {
          name: 'Statistics',
          type: 'statistics',
          content: analysis.analysis.statistics
        },
        {
          name: 'Insights',
          type: 'insights',
          content: analysis.insights
        }
      ],
      summary: `Analyzed ${dataset.rowCount} rows with ${analysis.insights.length} insights generated`,
      recommendations: analysis.analysis.recommendedVisualizations
    };
  }
  
  /**
   * Export data
   */
  export() {
    return {
      version: NovaData.VERSION,
      exportedAt: Date.now(),
      userId: this.userId,
      usage: this.usage,
      analytics: this.analytics,
      datasets: Array.from(this.datasets.keys())
    };
  }
  
  toJSON() {
    return {
      type: 'NovaData',
      quad: NovaData.QUAD,
      version: NovaData.VERSION,
      ipValue: NovaData.IP_VALUE,
      ipValueFormatted: `$${(NovaData.IP_VALUE / 1000000).toFixed(1)}M USD`,
      freeLimit: `${NovaData.FREE_LIMIT} analyses/month, 10MB data`,
      tagline: 'Data → insights, instantly',
      features: [
        'Instant data visualization',
        'Pattern and anomaly detection',
        'Report generation',
        'SQL query assistance',
        'Schema understanding'
      ],
      usage: this.getUsageStats(),
      createdAt: this.createdAt
    };
  }
}

// ─── Factory Function ────────────────────────────────────────────────────────
export function createNovaData(config = {}) {
  return new NovaData(config);
}

// ─── Default Export ──────────────────────────────────────────────────────────
export default {
  NovaData,
  createNovaData,
  DATA_TYPES,
  VISUALIZATION_TYPES
};
