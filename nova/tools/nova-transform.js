// nova/tools/nova-transform.js — F18 (v25.84.0) — Data transformation pipeline
// Brand: Nova by FreddyCreates
const PHI = 1.618033988749895;
export const NOVA_TOOL = { id:'NT-018',name:'nova-transform',brand:'Nova',fib_index:18,fib_value:2584,version:'25.84.0',category:'data' };
export default async function handle(p={}) {
  const { action='detect', data, from, to } = p;
  switch(action) {
    case 'json-to-jsonl': {
      if(!Array.isArray(data)) return { error:'Provide array for json-to-jsonl' };
      return { result: data.map(r=>JSON.stringify(r)).join('\n'), count:data.length, phi:PHI };
    }
    case 'jsonl-to-json': {
      if(typeof data!=='string') return { error:'Provide JSONL string' };
      const parsed = data.split('\n').filter(Boolean).map(l=>JSON.parse(l));
      return { result:parsed, count:parsed.length, phi:PHI };
    }
    case 'json-to-yaml': {
      const toYaml = (obj,indent=0) => {
        const pad = '  '.repeat(indent);
        if(typeof obj!=='object'||obj===null) return JSON.stringify(obj);
        if(Array.isArray(obj)) return obj.map(v=>`${pad}- ${toYaml(v,indent+1)}`).join('\n');
        return Object.entries(obj).map(([k,v])=>{
          const vStr = typeof v==='object'&&v!==null?'\n'+toYaml(v,indent+1):JSON.stringify(v);
          return `${pad}${k}: ${vStr}`;
        }).join('\n');
      };
      return { result:toYaml(data), phi:PHI };
    }
    case 'detect': {
      if(typeof data==='string') {
        try { JSON.parse(data); return { format:'json', phi:PHI }; } catch{}
        if(data.includes(': ')) return { format:'yaml', phi:PHI };
        if(data.match(/^\{.*\}$/m)) return { format:'jsonl', phi:PHI };
        return { format:'text', phi:PHI };
      }
      return { format:typeof data==='object'?'json':'scalar', phi:PHI };
    }
    default: return { actions:['json-to-jsonl','jsonl-to-json','json-to-yaml','detect'], phi:PHI };
  }
}
