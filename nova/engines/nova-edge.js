/**
 * NOVA CLOUDFLARE WORKER — Edge Intelligence Substrate
 * Nova by FreddyCreates
 * 
 * Cloudflare Workers implementation for global edge deployment.
 * Runs at 200+ edge locations worldwide with V8 isolates.
 * 
 * @version 0.13.0 (F13)
 * @copyright Nova Protocol by FreddyCreates
 */

import { NovaEngine, TOOLS, PHI, PHI_INV, PHI_BEAT } from './nova-engine.js';

// ─── Environment ─────────────────────────────────────────────────────────────
export const novaEdge = {
  engine: null,
  env: null,
  
  init(env) {
    this.env = env;
    this.engine = new NovaEngine({ substrate: 'cloudflare-workers' });
    return this;
  },
  
  async execute(quad, input, options = {}) {
    if (!this.engine) throw new Error('Engine not initialized');
    return await this.engine.execute(quad, input, options);
  },
  
  getTools() { return this.engine?.getTools() || []; },
  getBalance() { return this.engine?.getBalance() || {}; },
  status() { return this.engine?.status() || {}; }
};

// ─── Request Handler ─────────────────────────────────────────────────────────
export default {
  async fetch(request, env, ctx) {
    novaEdge.init(env);
    
    const url = new URL(request.url);
    const path = url.pathname;
    
    // CORS headers
    const corsHeaders = {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
      'Access-Control-Allow-Headers': 'Content-Type, Authorization',
      'X-Nova-Engine': 'cloudflare-workers',
      'X-Nova-Phi': String(PHI),
      'X-Nova-Beat': String(PHI_BEAT)
    };
    
    // Handle preflight
    if (request.method === 'OPTIONS') {
      return new Response(null, { headers: corsHeaders });
    }
    
    try {
      // Route handling
      if (path === '/status' || path === '/') {
        return json({ ...novaEdge.status(), edge: 'cloudflare' }, corsHeaders);
      }
      
      if (path === '/tools') {
        return json({ tools: novaEdge.getTools(), phi: PHI }, corsHeaders);
      }
      
      if (path === '/balance') {
        return json(novaEdge.getBalance(), corsHeaders);
      }
      
      if (path === '/heartbeat') {
        return json({
          beat: Date.now(),
          phi: PHI,
          phiBeat: PHI_BEAT,
          substrate: 'cloudflare-workers'
        }, corsHeaders);
      }
      
      // Tool execution
      if (path.startsWith('/execute/')) {
        const quad = path.split('/')[2]?.toUpperCase();
        if (!quad || !TOOLS[quad]) {
          return json({ error: `Unknown tool: ${quad}` }, corsHeaders, 400);
        }
        
        let input = '';
        let options = {};
        
        if (request.method === 'POST') {
          const body = await request.json().catch(() => ({}));
          input = body.input || '';
          options = body.options || {};
        } else {
          input = url.searchParams.get('input') || '';
        }
        
        const result = await novaEdge.execute(quad, input, options);
        return json(result, corsHeaders);
      }
      
      // Category listing
      if (path.startsWith('/category/')) {
        const category = path.split('/')[2]?.toLowerCase();
        const tools = novaEdge.getTools().filter(t => t.category === category);
        return json({ category, tools, count: tools.length }, corsHeaders);
      }
      
      // Not found
      return json({
        error: 'Not found',
        availableEndpoints: ['/status', '/tools', '/balance', '/heartbeat', '/execute/{QUAD}', '/category/{name}']
      }, corsHeaders, 404);
      
    } catch (error) {
      // Don't expose stack traces in production - log internally only
      console.error('[NovaEdge] Error:', error.message, error.stack);
      return json({ error: 'Internal server error', code: 'NOVA_EDGE_ERROR' }, corsHeaders, 500);
    }
  },
  
  // Scheduled heartbeat (cron trigger)
  async scheduled(event, env, ctx) {
    novaEdge.init(env);
    console.log(`[NovaEdge] Heartbeat at ${new Date().toISOString()}, φ-beat: ${PHI_BEAT}ms`);
  }
};

// ─── Helpers ─────────────────────────────────────────────────────────────────
function json(data, headers = {}, status = 200) {
  return new Response(JSON.stringify(data, null, 2), {
    status,
    headers: {
      'Content-Type': 'application/json',
      ...headers
    }
  });
}

// ─── Durable Object for State ────────────────────────────────────────────────
export class NovaState {
  constructor(state, env) {
    this.state = state;
    this.env = env;
    this.engine = new NovaEngine({ substrate: 'cloudflare-durable-object' });
  }
  
  async fetch(request) {
    const url = new URL(request.url);
    const action = url.pathname.slice(1);
    
    switch (action) {
      case 'status':
        return json(this.engine.status());
      
      case 'execute':
        const body = await request.json();
        const result = await this.engine.execute(body.quad, body.input, body.options);
        await this.state.storage.put('lastExecution', { ...result, timestamp: Date.now() });
        return json(result);
      
      case 'history':
        const history = await this.state.storage.list({ prefix: 'exec_' });
        return json({ history: [...history.entries()] });
      
      default:
        return json({ error: 'Unknown action' }, {}, 400);
    }
  }
}
