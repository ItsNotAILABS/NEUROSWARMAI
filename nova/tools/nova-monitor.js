// nova/tools/nova-monitor.js — F15 (v6.10.0) — Platform health monitor
// Brand: Nova by FreddyCreates
import os from 'os';
const PHI = 1.618033988749895;
const PHI_INV = 0.6180339887498949;
const PHI_BEAT = 873;
export const NOVA_TOOL = { id:'NT-015',name:'nova-monitor',brand:'Nova',fib_index:15,fib_value:610,version:'6.10.0',category:'ops' };
export default async function handle(p={}) {
  const { target='all' } = p;
  const cpuUsage = os.loadavg()[0] / os.cpus().length;
  const memTotal = os.totalmem();
  const memFree  = os.freemem();
  const memUsage = 1 - memFree/memTotal;
  const phiHealth = (1-Math.abs(cpuUsage-PHI_INV)) * (1-Math.abs(memUsage-PHI_INV));
  const status = {
    system: {
      platform: os.platform(), arch: os.arch(), hostname: os.hostname(),
      uptime_s: os.uptime(), cpus: os.cpus().length,
      load_avg: os.loadavg(),
      mem_total_mb: Math.round(memTotal/1024/1024),
      mem_free_mb:  Math.round(memFree/1024/1024),
      mem_usage:    memUsage.toFixed(3),
      cpu_usage:    cpuUsage.toFixed(3),
    },
    phi_health: {
      score:    phiHealth.toFixed(4),
      optimal:  PHI_INV,
      cpu_delta: Math.abs(cpuUsage-PHI_INV).toFixed(3),
      mem_delta: Math.abs(memUsage-PHI_INV).toFixed(3),
      phi_beat_ms: PHI_BEAT,
      status: phiHealth > 0.618 ? '✓ PHI-COHERENT' : '⚠ BELOW PHI',
    },
    nova: {
      tools: 20, ais: 15, cloudflare_workers: 73, web_workers: 37,
      icp_canisters: 8, github_actions: 27, agents: 4, languages: 40,
    },
    timestamp: new Date().toISOString(),
    phi: PHI,
  };
  if(target==='phi-beat') return { phi_beat_ms:PHI_BEAT, phi:PHI, ts:status.timestamp, health:phiHealth.toFixed(4) };
  return status;
}
