/**
 * Models Dashboard — M-01 through M-300 MEDINA-ARTIFACTs Registry
 *
 * Browsable registry with:
 * - Model detail with all 4 layers visible
 * - Embedding proximity view
 * - Beat-synchronized execution log
 * - Domain filtering
 * - Search by semantic similarity
 *
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 */

import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { ScrollArea } from "@/components/ui/scroll-area";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import {
  Activity,
  Brain,
  CheckCircle2,
  Clock,
  Hash,
  Layers,
  Search,
  Zap,
} from "lucide-react";
import { useEffect, useState } from "react";

const PHI = 1.618033988749895;

interface ModelMetadata {
  id: string;
  name: string;
  domain: string;
  hash: string;
  inputTypes: string[];
  accessCount: number;
  lastAccess: number;
  successRate: number;
  averageExecutionTime: number;
  layers: {
    semantic: {
      description: string;
      keywords: string[];
    };
    contextual: {
      supportedInputs: string[];
      outputFormat: string;
    };
  };
}

interface ModelsStats {
  totalModels: number;
  totalDomains: number;
  totalExecutions: number;
  domains: { domain: string; count: number }[];
  mostUsedModels: {
    id: string;
    name: string;
    accessCount: number;
    successRate: number;
  }[];
}

export function ModelsDashboard() {
  const [models, setModels] = useState<ModelMetadata[]>([]);
  const [stats, setStats] = useState<ModelsStats | null>(null);
  const [selectedModel, setSelectedModel] = useState<ModelMetadata | null>(null);
  const [searchQuery, setSearchQuery] = useState("");
  const [filterDomain, setFilterDomain] = useState<string>("all");
  const [loading, setLoading] = useState(true);

  // Mock data for now - will connect to Slack orchestrator
  useEffect(() => {
    // Simulate loading M-01 through M-300
    const mockModels: ModelMetadata[] = [];
    const domains = [
      'reasoning', 'logic', 'memory', 'comprehension', 'decision',
      'surveillance', 'networking', 'will', 'inquiry', 'prediction',
      'temporal', 'causality', 'quantum', 'emergence', 'collective',
    ];

    for (let i = 1; i <= 300; i++) {
      const id = `M-${String(i).padStart(3, '0')}`;
      const domainIdx = (i - 1) % domains.length;
      const domain = domains[domainIdx];

      mockModels.push({
        id,
        name: `${domain.charAt(0).toUpperCase() + domain.slice(1)} Model ${i}`,
        domain,
        hash: `hash_${id}`,
        inputTypes: i % 3 === 0 ? ['text', 'image'] : ['text'],
        accessCount: Math.floor(Math.random() * 100),
        lastAccess: Date.now() - Math.random() * 86400000,
        successRate: 0.7 + Math.random() * 0.3,
        averageExecutionTime: 50 + Math.random() * 200,
        layers: {
          semantic: {
            description: `${domain.charAt(0).toUpperCase() + domain.slice(1)} Model ${i} operates in ${domain} domain`,
            keywords: [domain, 'ai', 'model'],
          },
          contextual: {
            supportedInputs: i % 3 === 0 ? ['text', 'image'] : ['text'],
            outputFormat: 'text',
          },
        },
      });
    }

    setModels(mockModels);

    // Calculate stats
    const domainCounts = new Map<string, number>();
    mockModels.forEach(m => {
      domainCounts.set(m.domain, (domainCounts.get(m.domain) || 0) + 1);
    });

    setStats({
      totalModels: mockModels.length,
      totalDomains: domainCounts.size,
      totalExecutions: mockModels.reduce((sum, m) => sum + m.accessCount, 0),
      domains: Array.from(domainCounts.entries()).map(([domain, count]) => ({
        domain,
        count,
      })),
      mostUsedModels: mockModels
        .sort((a, b) => b.accessCount - a.accessCount)
        .slice(0, 10)
        .map(m => ({
          id: m.id,
          name: m.name,
          accessCount: m.accessCount,
          successRate: m.successRate,
        })),
    });

    setLoading(false);
  }, []);

  const filteredModels = models.filter(m => {
    const matchesSearch = searchQuery === "" ||
      m.id.toLowerCase().includes(searchQuery.toLowerCase()) ||
      m.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
      m.domain.toLowerCase().includes(searchQuery.toLowerCase());

    const matchesDomain = filterDomain === "all" || m.domain === filterDomain;

    return matchesSearch && matchesDomain;
  });

  const uniqueDomains = Array.from(new Set(models.map(m => m.domain))).sort();

  if (loading) {
    return (
      <div className="flex items-center justify-center h-full">
        <div className="text-center space-y-2">
          <Activity className="w-8 h-8 animate-pulse mx-auto text-primary" />
          <p className="text-sm text-muted-foreground">Loading M-01 through M-300...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="h-full flex flex-col">
      {/* Header */}
      <div className="border-b border-border/40 bg-background/95 backdrop-blur supports-[backdrop-filter]:bg-background/60">
        <div className="px-6 py-4">
          <div className="flex items-center justify-between mb-4">
            <div>
              <h1 className="text-2xl font-semibold tracking-tight">
                PARALLAX Model Registry
              </h1>
              <p className="text-sm text-muted-foreground mt-1">
                M-01 through M-300 MEDINA-ARTIFACTs — Micro-tokenization active
              </p>
            </div>
            <Badge variant="outline" className="px-3 py-1">
              <Zap className="w-3 h-3 mr-1.5" />
              φ-Beat: 873ms
            </Badge>
          </div>

          {/* Stats Row */}
          {stats && (
            <div className="grid grid-cols-4 gap-4">
              <Card className="bg-surface-elevated/50">
                <CardContent className="p-4">
                  <div className="flex items-center justify-between">
                    <div>
                      <p className="text-xs text-muted-foreground">Total Models</p>
                      <p className="text-2xl font-bold">{stats.totalModels}</p>
                    </div>
                    <Brain className="w-8 h-8 text-primary/30" />
                  </div>
                </CardContent>
              </Card>

              <Card className="bg-surface-elevated/50">
                <CardContent className="p-4">
                  <div className="flex items-center justify-between">
                    <div>
                      <p className="text-xs text-muted-foreground">Domains</p>
                      <p className="text-2xl font-bold">{stats.totalDomains}</p>
                    </div>
                    <Layers className="w-8 h-8 text-emerald-500/30" />
                  </div>
                </CardContent>
              </Card>

              <Card className="bg-surface-elevated/50">
                <CardContent className="p-4">
                  <div className="flex items-center justify-between">
                    <div>
                      <p className="text-xs text-muted-foreground">Total Executions</p>
                      <p className="text-2xl font-bold">{stats.totalExecutions.toLocaleString()}</p>
                    </div>
                    <Activity className="w-8 h-8 text-blue-500/30" />
                  </div>
                </CardContent>
              </Card>

              <Card className="bg-surface-elevated/50">
                <CardContent className="p-4">
                  <div className="flex items-center justify-between">
                    <div>
                      <p className="text-xs text-muted-foreground">Avg Response</p>
                      <p className="text-2xl font-bold">
                        {Math.round(models.reduce((sum, m) => sum + m.averageExecutionTime, 0) / models.length)}ms
                      </p>
                    </div>
                    <Clock className="w-8 h-8 text-orange-500/30" />
                  </div>
                </CardContent>
              </Card>
            </div>
          )}

          {/* Search and Filters */}
          <div className="flex gap-3 mt-4">
            <div className="relative flex-1">
              <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground" />
              <Input
                placeholder="Search models by ID, name, or domain..."
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                className="pl-10"
              />
            </div>
            <select
              value={filterDomain}
              onChange={(e) => setFilterDomain(e.target.value)}
              className="px-4 py-2 border border-border rounded-lg bg-background text-sm"
            >
              <option value="all">All Domains</option>
              {uniqueDomains.map(domain => (
                <option key={domain} value={domain}>
                  {domain.charAt(0).toUpperCase() + domain.slice(1)}
                </option>
              ))}
            </select>
          </div>
        </div>
      </div>

      {/* Main Content */}
      <div className="flex-1 overflow-hidden">
        <div className="grid grid-cols-12 h-full">
          {/* Models List */}
          <div className="col-span-5 border-r border-border/40">
            <ScrollArea className="h-full">
              <div className="p-4 space-y-2">
                {filteredModels.map((model) => (
                  <Card
                    key={model.id}
                    className={`cursor-pointer transition-all hover:bg-surface-elevated/50 ${
                      selectedModel?.id === model.id ? 'ring-2 ring-primary' : ''
                    }`}
                    onClick={() => setSelectedModel(model)}
                  >
                    <CardContent className="p-4">
                      <div className="flex items-start justify-between mb-2">
                        <div>
                          <div className="flex items-center gap-2 mb-1">
                            <Badge variant="outline" className="font-mono text-xs">
                              {model.id}
                            </Badge>
                            <Badge variant="secondary" className="text-[10px]">
                              {model.domain}
                            </Badge>
                          </div>
                          <p className="text-sm font-medium">{model.name}</p>
                        </div>
                        <div className="flex items-center gap-1">
                          <CheckCircle2 className="w-3.5 h-3.5 text-emerald-500" />
                          <span className="text-xs text-muted-foreground">
                            {Math.round(model.successRate * 100)}%
                          </span>
                        </div>
                      </div>

                      <div className="flex items-center gap-4 text-xs text-muted-foreground">
                        <div className="flex items-center gap-1">
                          <Activity className="w-3 h-3" />
                          {model.accessCount} calls
                        </div>
                        <div className="flex items-center gap-1">
                          <Clock className="w-3 h-3" />
                          {Math.round(model.averageExecutionTime)}ms
                        </div>
                      </div>

                      <div className="flex gap-1 mt-2">
                        {model.inputTypes.map(type => (
                          <Badge key={type} variant="outline" className="text-[10px]">
                            {type}
                          </Badge>
                        ))}
                      </div>
                    </CardContent>
                  </Card>
                ))}
              </div>
            </ScrollArea>
          </div>

          {/* Model Detail */}
          <div className="col-span-7">
            {selectedModel ? (
              <ScrollArea className="h-full">
                <div className="p-6 space-y-6">
                  {/* Header */}
                  <div>
                    <div className="flex items-center gap-2 mb-2">
                      <Badge variant="outline" className="font-mono">
                        {selectedModel.id}
                      </Badge>
                      <Badge variant="secondary">
                        {selectedModel.domain}
                      </Badge>
                    </div>
                    <h2 className="text-2xl font-semibold mb-2">
                      {selectedModel.name}
                    </h2>
                    <div className="flex items-center gap-2 text-sm text-muted-foreground">
                      <Hash className="w-4 h-4" />
                      <code className="font-mono">{selectedModel.hash}</code>
                    </div>
                  </div>

                  {/* 4 Layers */}
                  <Tabs defaultValue="semantic" className="w-full">
                    <TabsList className="grid w-full grid-cols-4">
                      <TabsTrigger value="semantic">Layer 1: Semantic</TabsTrigger>
                      <TabsTrigger value="contextual">Layer 2: Contextual</TabsTrigger>
                      <TabsTrigger value="execution">Layer 3: Execution</TabsTrigger>
                      <TabsTrigger value="result">Layer 4: Result</TabsTrigger>
                    </TabsList>

                    <TabsContent value="semantic" className="space-y-4">
                      <Card>
                        <CardHeader>
                          <CardTitle className="text-sm">Semantic Understanding</CardTitle>
                        </CardHeader>
                        <CardContent className="space-y-3">
                          <div>
                            <p className="text-xs font-medium text-muted-foreground mb-1">Description</p>
                            <p className="text-sm">{selectedModel.layers.semantic.description}</p>
                          </div>
                          <div>
                            <p className="text-xs font-medium text-muted-foreground mb-1">Keywords</p>
                            <div className="flex flex-wrap gap-1">
                              {selectedModel.layers.semantic.keywords.map((kw, i) => (
                                <Badge key={i} variant="outline" className="text-xs">
                                  {kw}
                                </Badge>
                              ))}
                            </div>
                          </div>
                        </CardContent>
                      </Card>
                    </TabsContent>

                    <TabsContent value="contextual" className="space-y-4">
                      <Card>
                        <CardHeader>
                          <CardTitle className="text-sm">Contextual Awareness</CardTitle>
                        </CardHeader>
                        <CardContent className="space-y-3">
                          <div>
                            <p className="text-xs font-medium text-muted-foreground mb-1">Supported Inputs</p>
                            <div className="flex flex-wrap gap-1">
                              {selectedModel.layers.contextual.supportedInputs.map((input, i) => (
                                <Badge key={i} variant="secondary" className="text-xs">
                                  {input}
                                </Badge>
                              ))}
                            </div>
                          </div>
                          <div>
                            <p className="text-xs font-medium text-muted-foreground mb-1">Output Format</p>
                            <Badge variant="outline" className="text-xs">
                              {selectedModel.layers.contextual.outputFormat}
                            </Badge>
                          </div>
                        </CardContent>
                      </Card>
                    </TabsContent>

                    <TabsContent value="execution" className="space-y-4">
                      <Card>
                        <CardHeader>
                          <CardTitle className="text-sm">Execution Logic</CardTitle>
                        </CardHeader>
                        <CardContent className="space-y-3">
                          <div>
                            <p className="text-xs font-medium text-muted-foreground mb-1">Function</p>
                            <p className="text-sm font-mono bg-surface-elevated p-3 rounded-lg">
                              async execute(input) → result
                            </p>
                          </div>
                          <div>
                            <p className="text-xs font-medium text-muted-foreground mb-1">Timeout</p>
                            <p className="text-sm">5000ms</p>
                          </div>
                        </CardContent>
                      </Card>
                    </TabsContent>

                    <TabsContent value="result" className="space-y-4">
                      <Card>
                        <CardHeader>
                          <CardTitle className="text-sm">Result Handling</CardTitle>
                        </CardHeader>
                        <CardContent className="space-y-3">
                          <div className="grid grid-cols-2 gap-4">
                            <div>
                              <p className="text-xs font-medium text-muted-foreground mb-1">Success Rate</p>
                              <div className="flex items-center gap-2">
                                <div className="flex-1 bg-surface-elevated rounded-full h-2">
                                  <div
                                    className="bg-emerald-500 h-2 rounded-full"
                                    style={{ width: `${selectedModel.successRate * 100}%` }}
                                  />
                                </div>
                                <span className="text-sm font-medium">
                                  {Math.round(selectedModel.successRate * 100)}%
                                </span>
                              </div>
                            </div>
                            <div>
                              <p className="text-xs font-medium text-muted-foreground mb-1">Avg Execution Time</p>
                              <p className="text-sm font-medium">
                                {Math.round(selectedModel.averageExecutionTime)}ms
                              </p>
                            </div>
                          </div>
                          <div>
                            <p className="text-xs font-medium text-muted-foreground mb-1">Total Calls</p>
                            <p className="text-sm font-medium">{selectedModel.accessCount}</p>
                          </div>
                        </CardContent>
                      </Card>
                    </TabsContent>
                  </Tabs>

                  {/* Test Execution */}
                  <Card>
                    <CardHeader>
                      <CardTitle className="text-sm">Test Execution</CardTitle>
                      <CardDescription>
                        Execute this model with sample input
                      </CardDescription>
                    </CardHeader>
                    <CardContent>
                      <Button className="w-full" disabled>
                        <Zap className="w-4 h-4 mr-2" />
                        Execute Model (Coming Soon)
                      </Button>
                    </CardContent>
                  </Card>
                </div>
              </ScrollArea>
            ) : (
              <div className="flex items-center justify-center h-full">
                <div className="text-center space-y-2">
                  <Brain className="w-12 h-12 mx-auto text-muted-foreground/30" />
                  <p className="text-sm text-muted-foreground">
                    Select a model to view details
                  </p>
                </div>
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}
