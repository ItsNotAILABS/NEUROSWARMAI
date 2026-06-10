/**
 * ARTIFEX — Browser Web Worker
 * Latin: "Artifex Navigatoris" — Navigator's Craftsman
 *
 * Browser Web Worker — organism/web/artifex-worker.js
 * Layer 1 of the 3-layer organism architecture (session-bound).
 *
 * Responsibilities:
 *   - Generate downloadable PDF blobs client-side (real PDF 1.4 binary)
 *   - Generate downloadable XLSX blobs client-side (real OOXML+ZIP)
 *   - Build PM artifact packs in the browser
 *   - Communicate with ARTIFEX Cloudflare Worker for server-side generation
 *   - Maintain artifact session state across PHI_BEAT heartbeats
 *
 * Message API (postMessage protocol):
 *   → { type: 'generate_pdf',   doc: {...} }           ← { type: 'pdf_ready',  url, filename, sizeBytes }
 *   → { type: 'generate_xlsx',  wb: {...} }            ← { type: 'xlsx_ready', url, filename, sizeBytes }
 *   → { type: 'generate_pack',  project: {...} }       ← { type: 'pack_ready', url, filename, sizeBytes }
 *   → { type: 'remote_pdf',     doc: {...}, endpoint } ← { type: 'pdf_ready',  url, filename }
 *   → { type: 'remote_xlsx',    wb: {...},  endpoint } ← { type: 'xlsx_ready', url, filename }
 *   → { type: 'remote_pack',    project, endpoint }   ← { type: 'pack_ready', url, filename }
 *   → { type: 'revoke_url',     url }                 (cleans up object URL)
 *   → { type: 'heartbeat' }                           ← { type: 'heartbeat', beat, phi }
 *   → { type: 'status' }                              ← { type: 'status', ... }
 *
 * Tool ID range: ARTIFACT-001 to ARTIFACT-034
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

/* eslint-disable no-restricted-globals */
'use strict';

const PHI       = 1.618033988749895;
const PHI_INV   = 1 / PHI;
const PHI_BEAT  = 873;
const VERSION   = '1.0.0';
const WORKER_ID = 'ARTIFEX-BROWSER';
const LATIN     = 'Artifex Navigatoris';

let beatCount     = 0;
let artifactCount = 0;
const objectURLs  = new Set(); // track for cleanup

const ENC = new TextEncoder();

/* ═══════════════════════════════════════════════════════════════════════
   UTILITIES (mirrors organism/cloudflare/artifex.js — kept in sync)
   ═══════════════════════════════════════════════════════════════════════ */

function xmlEsc(s) {
  return String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');
}

function colLetter(col) {
  let s = '', n = col + 1;
  while (n > 0) { n--; s = String.fromCharCode(65 + (n % 26)) + s; n = Math.floor(n / 26); }
  return s;
}

function dosDateTime(date) {
  const t = ((date.getHours() & 0x1F) << 11) | ((date.getMinutes() & 0x3F) << 5) | (Math.floor(date.getSeconds() / 2) & 0x1F);
  const d = (((date.getFullYear() - 1980) & 0x7F) << 9) | (((date.getMonth() + 1) & 0x0F) << 5) | (date.getDate() & 0x1F);
  return { time: t, date: d };
}

function crc32(data) {
  const tbl = new Uint32Array(256);
  for (let i = 0; i < 256; i++) {
    let c = i;
    for (let j = 0; j < 8; j++) { c = (c & 1) ? (0xEDB88320 ^ (c >>> 1)) : (c >>> 1); }
    tbl[i] = c;
  }
  let crc = 0xFFFFFFFF;
  for (let i = 0; i < data.length; i++) { crc = tbl[(crc ^ data[i]) & 0xFF] ^ (crc >>> 8); }
  return (crc ^ 0xFFFFFFFF) >>> 0;
}

/* ═══════════════════════════════════════════════════════════════════════
   ZIP BUILDER
   ═══════════════════════════════════════════════════════════════════════ */

function buildZIP(files) {
  const parts = [], cds = [];
  let localOffset = 0;
  const dt = dosDateTime(new Date());

  for (const file of files) {
    const nb  = ENC.encode(file.name);
    const crc = crc32(file.data);
    const sz  = file.data.length;

    const lh  = new Uint8Array(30 + nb.length);
    const lhv = new DataView(lh.buffer);
    lhv.setUint32(0, 0x04034B50, true); lhv.setUint16(4,  20,      true);
    lhv.setUint16(6, 0,          true); lhv.setUint16(8,  0,       true);
    lhv.setUint16(10, dt.time,   true); lhv.setUint16(12, dt.date, true);
    lhv.setUint32(14, crc,       true); lhv.setUint32(18, sz,      true);
    lhv.setUint32(22, sz,        true); lhv.setUint16(26, nb.length, true);
    lhv.setUint16(28, 0,         true); lh.set(nb, 30);

    parts.push(lh, file.data);

    const cd  = new Uint8Array(46 + nb.length);
    const cdv = new DataView(cd.buffer);
    cdv.setUint32(0, 0x02014B50, true); cdv.setUint16(4,  20,      true);
    cdv.setUint16(6, 20,         true); cdv.setUint16(8,  0,       true);
    cdv.setUint16(10, 0,         true); cdv.setUint16(12, dt.time, true);
    cdv.setUint16(14, dt.date,   true); cdv.setUint32(16, crc,     true);
    cdv.setUint32(20, sz,        true); cdv.setUint32(24, sz,      true);
    cdv.setUint16(28, nb.length, true); cdv.setUint16(30, 0,       true);
    cdv.setUint16(32, 0,         true); cdv.setUint16(34, 0,       true);
    cdv.setUint16(36, 0,         true); cdv.setUint32(38, 0,       true);
    cdv.setUint32(42, localOffset, true); cd.set(nb, 46);
    cds.push(cd);
    localOffset += (30 + nb.length) + sz;
  }

  const cdOff = localOffset;
  const cdSz  = cds.reduce((s, c) => s + c.length, 0);
  const eocd  = new Uint8Array(22);
  const ev    = new DataView(eocd.buffer);
  ev.setUint32(0, 0x06054B50, true); ev.setUint16(4,  0,           true);
  ev.setUint16(6, 0,          true); ev.setUint16(8,  files.length, true);
  ev.setUint16(10, files.length, true); ev.setUint32(12, cdSz,     true);
  ev.setUint32(16, cdOff,     true); ev.setUint16(20, 0,           true);

  const all = [...parts, ...cds, eocd];
  const tot = all.reduce((s, p) => s + p.length, 0);
  const out = new Uint8Array(tot);
  let off = 0;
  for (const p of all) { out.set(p, off); off += p.length; }
  return out;
}

/* ═══════════════════════════════════════════════════════════════════════
   XLSX BUILDER
   ═══════════════════════════════════════════════════════════════════════ */

function buildXLSX(wb) {
  const sheets = wb.sheets || [{ name: 'Sheet1', headers: [], rows: [] }];
  const strIdx = new Map(), strList = [];
  function addStr(s) {
    const k = String(s);
    if (!strIdx.has(k)) { strIdx.set(k, strList.length); strList.push(k); }
    return strIdx.get(k);
  }
  for (const sh of sheets) {
    for (const h of (sh.headers || [])) addStr(h);
    for (const row of (sh.rows || [])) for (const cell of row) if (typeof cell !== 'number') addStr(cell);
  }

  const sheetXMLs = sheets.map((sh) => {
    const rows = []; let rowNum = 1;
    if (sh.headers && sh.headers.length) {
      rows.push(`<row r="${rowNum}">${sh.headers.map((h, ci) => `<c r="${colLetter(ci)}${rowNum}" t="s" s="1"><v>${addStr(h)}</v></c>`).join('')}</row>`);
      rowNum++;
    }
    for (const row of (sh.rows || [])) {
      rows.push(`<row r="${rowNum}">${row.map((cell, ci) => typeof cell === 'number' ? `<c r="${colLetter(ci)}${rowNum}"><v>${cell}</v></c>` : `<c r="${colLetter(ci)}${rowNum}" t="s"><v>${addStr(String(cell))}</v></c>`).join('')}</row>`);
      rowNum++;
    }
    return `<?xml version="1.0" encoding="UTF-8" standalone="yes"?><worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main"><sheetData>${rows.join('')}</sheetData></worksheet>`;
  });

  const ct = `<?xml version="1.0" encoding="UTF-8" standalone="yes"?><Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types"><Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/><Default Extension="xml" ContentType="application/xml"/><Override PartName="/xl/workbook.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml"/>${sheets.map((_,i)=>`<Override PartName="/xl/worksheets/sheet${i+1}.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/>`).join('')}<Override PartName="/xl/sharedStrings.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sharedStrings+xml"/><Override PartName="/xl/styles.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.styles+xml"/></Types>`;
  const rels = `<?xml version="1.0" encoding="UTF-8" standalone="yes"?><Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships"><Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="xl/workbook.xml"/></Relationships>`;
  const wb2  = `<?xml version="1.0" encoding="UTF-8" standalone="yes"?><workbook xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"><sheets>${sheets.map((s,i)=>`<sheet name="${xmlEsc(s.name||`Sheet${i+1}`)}" sheetId="${i+1}" r:id="rId${i+1}"/>`).join('')}</sheets></workbook>`;
  const wbr  = `<?xml version="1.0" encoding="UTF-8" standalone="yes"?><Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">${sheets.map((_,i)=>`<Relationship Id="rId${i+1}" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet" Target="worksheets/sheet${i+1}.xml"/>`).join('')}<Relationship Id="rId${sheets.length+1}" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/sharedStrings" Target="sharedStrings.xml"/><Relationship Id="rId${sheets.length+2}" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles" Target="styles.xml"/></Relationships>`;
  const ss   = `<?xml version="1.0" encoding="UTF-8" standalone="yes"?><sst xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" count="${strList.length}" uniqueCount="${strList.length}">${strList.map(s=>`<si><t>${xmlEsc(s)}</t></si>`).join('')}</sst>`;
  const styl = `<?xml version="1.0" encoding="UTF-8" standalone="yes"?><styleSheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main"><fonts count="2"><font><sz val="11"/><name val="Calibri"/></font><font><b/><sz val="11"/><name val="Calibri"/><color rgb="FF1F1F9B"/></font></fonts><fills count="2"><fill><patternFill patternType="none"/></fill><fill><patternFill patternType="gray125"/></fill></fills><borders count="1"><border><left/><right/><top/><bottom/><diagonal/></border></borders><cellStyleXfs count="1"><xf numFmtId="0" fontId="0" fillId="0" borderId="0"/></cellStyleXfs><cellXfs count="2"><xf numFmtId="0" fontId="0" fillId="0" borderId="0" xfId="0"/><xf numFmtId="0" fontId="1" fillId="0" borderId="0" xfId="0"/></cellXfs></styleSheet>`;

  return buildZIP([
    { name: '[Content_Types].xml',        data: ENC.encode(ct) },
    { name: '_rels/.rels',                data: ENC.encode(rels) },
    { name: 'xl/workbook.xml',            data: ENC.encode(wb2) },
    { name: 'xl/_rels/workbook.xml.rels', data: ENC.encode(wbr) },
    { name: 'xl/sharedStrings.xml',       data: ENC.encode(ss) },
    { name: 'xl/styles.xml',              data: ENC.encode(styl) },
    ...sheetXMLs.map((xml, i) => ({ name: `xl/worksheets/sheet${i+1}.xml`, data: ENC.encode(xml) })),
  ]);
}

/* ═══════════════════════════════════════════════════════════════════════
   PDF BUILDER
   ═══════════════════════════════════════════════════════════════════════ */

function pdfStr(s) {
  const safe = String(s).replace(/\u03c6/g,'phi').replace(/\u00a9/g,'(C)').replace(/\u2014/g,'--').replace(/\u2013/g,'-').replace(/[^\x20-\x7E]/g,'?');
  return '(' + safe.replace(/\\/g,'\\\\').replace(/\(/g,'\\(').replace(/\)/g,'\\)') + ')';
}

function buildPDF(doc) {
  const pages = (doc.pages && doc.pages.length) ? doc.pages : [{ heading: doc.title || 'Document', lines: [] }];
  const N = pages.length;
  const OBJ_FONT_BOLD=1, OBJ_FONT_REG=2, OBJ_INFO=3;
  const OBJ_PAGES=4+2*N, OBJ_CATALOG=4+2*N+1, TOTAL_OBJS=4+2*N+2;
  const parts=[], offsets=new Array(TOTAL_OBJS).fill(0);
  let pos=0;
  function write(s) { const b = typeof s==='string' ? ENC.encode(s) : s; parts.push(b); pos+=b.length; }

  write('%PDF-1.4\n');
  offsets[OBJ_FONT_BOLD]=pos; write(`${OBJ_FONT_BOLD} 0 obj\n<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica-Bold /Encoding /WinAnsiEncoding >>\nendobj\n`);
  offsets[OBJ_FONT_REG]=pos;  write(`${OBJ_FONT_REG} 0 obj\n<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica /Encoding /WinAnsiEncoding >>\nendobj\n`);
  const now=new Date();
  const dp=`D:${now.getUTCFullYear()}${String(now.getUTCMonth()+1).padStart(2,'0')}${String(now.getUTCDate()).padStart(2,'0')}000000+00'00'`;
  offsets[OBJ_INFO]=pos; write(`${OBJ_INFO} 0 obj\n<< /Title ${pdfStr(doc.title||'SOVEREIGN')} /Author ${pdfStr(doc.author||'SOVEREIGN')} /Creator (ARTIFEX-BROWSER v${VERSION}) /CreationDate ${pdfStr(dp)} >>\nendobj\n`);

  const pageObjNums=[];
  for(let i=0;i<N;i++){
    const page=pages[i], cObjN=4+2*i, pObjN=5+2*i;
    pageObjNums.push(pObjN);
    const s=[];
    s.push('BT','1 0 0 1 36 775 Tm','/FB 10 Tf','0.20 0.20 0.60 rg',`${pdfStr('MERIDIANUS PLATFORM -- MEDINA DOCTRINE -- SOVEREIGN ARTIFACT')} Tj`,'/FR 8 Tf','0.50 0.50 0.50 rg','0 -12 Td',`${pdfStr('phi=1.618033988749895 -- Copyright (C) 2024-2026 Alfredo Medina Hernandez')} Tj`,'/FB 16 Tf','0.05 0.05 0.05 rg','0 -28 Td',`${pdfStr(page.heading||'')} Tj`,'ET','0.20 0.20 0.60 RG','0.8 w','36 720 m 576 720 l S','BT','1 0 0 1 36 705 Tm','/FR 11 Tf','0.05 0.05 0.05 rg');
    for(const line of (page.lines||[])){
      if(line===''){s.push('0 -6 Td');continue;}
      if(line.startsWith('## ')){s.push('/FB 13 Tf 0.10 0.10 0.40 rg',`${pdfStr(line.slice(3))} Tj`,'/FR 11 Tf 0.05 0.05 0.05 rg 0 -22 Td');}
      else{s.push(`${pdfStr(line)} Tj 0 -15 Td`);}
    }
    s.push('1 0 0 1 36 30 Tm','/FR 8 Tf','0.50 0.50 0.50 rg',`${pdfStr(`Page ${i+1} of ${N}  |  ARTIFEX-BROWSER  |  ${doc.title||''}`)} Tj`,'ET');
    const sd=ENC.encode(s.join('\n'));
    offsets[cObjN]=pos; write(`${cObjN} 0 obj\n<< /Length ${sd.length} >>\nstream\n`); write(sd); write('\nendstream\nendobj\n');
    offsets[pObjN]=pos; write(`${pObjN} 0 obj\n<< /Type /Page /Parent ${OBJ_PAGES} 0 R /MediaBox [0 0 612 792] /Contents ${cObjN} 0 R /Resources << /Font << /FB ${OBJ_FONT_BOLD} 0 R /FR ${OBJ_FONT_REG} 0 R >> >> >>\nendobj\n`);
  }
  offsets[OBJ_PAGES]=pos; write(`${OBJ_PAGES} 0 obj\n<< /Type /Pages /Kids [${pageObjNums.map(n=>`${n} 0 R`).join(' ')}] /Count ${N} >>\nendobj\n`);
  offsets[OBJ_CATALOG]=pos; write(`${OBJ_CATALOG} 0 obj\n<< /Type /Catalog /Pages ${OBJ_PAGES} 0 R >>\nendobj\n`);
  const xp=pos; write(`xref\n0 ${TOTAL_OBJS}\n`); write('0000000000 65535 f \n');
  for(let i=1;i<TOTAL_OBJS;i++) write(`${String(offsets[i]).padStart(10,'0')} 00000 n \n`);
  write(`trailer\n<< /Size ${TOTAL_OBJS} /Root ${OBJ_CATALOG} 0 R /Info ${OBJ_INFO} 0 R >>\nstartxref\n${xp}\n%%EOF\n`);
  const tot=parts.reduce((s,p)=>s+p.length,0), out=new Uint8Array(tot); let off=0;
  for(const p of parts){out.set(p,off);off+=p.length;} return out;
}

/* ═══════════════════════════════════════════════════════════════════════
   PM PACK BUILDER
   ═══════════════════════════════════════════════════════════════════════ */

function buildPMPack(project) {
  const name    = project.name || 'Project';
  const sprints = project.sprints || [];
  const risks   = project.risks   || [];

  const pdfPages = [{ heading: name, lines: [project.description||'', '', `## Overview`, `Sprints: ${sprints.length}`, `Tasks: ${sprints.reduce((s,sp)=>s+sp.tasks.length,0)}`, `Risks: ${risks.length}`] }];
  for (const sp of sprints) {
    pdfPages.push({ heading: `${sp.name} (${sp.start} to ${sp.end})`, lines: [`## Tasks (${sp.tasks.length})`, ...sp.tasks.map(t=>`- [${t.status}] ${t.id}: ${t.title} -- ${t.owner} (${t.priority}, ${t.points} pts)`)] });
  }
  if (risks.length) pdfPages.push({ heading: 'Risk Register', lines: ['## Risks', ...risks.map(r=>`- [${r.probability}/${r.impact}] ${r.id}: ${r.title}`)] });

  const pdfBytes  = buildPDF({ title: name, author: 'SOVEREIGN PM', pages: pdfPages });
  const xlsxSheets = sprints.map(sp => ({ name: sp.name.slice(0,31), headers: ['ID','Title','Owner','Priority','Status','Points','Start','End'], rows: sp.tasks.map(t=>[t.id,t.title,t.owner,t.priority,t.status,t.points,sp.start,sp.end]) }));
  if (!xlsxSheets.length) xlsxSheets.push({ name: 'Tasks', headers: ['ID','Title','Owner','Status','Points'], rows: [] });
  if (risks.length) xlsxSheets.push({ name: 'Risk Register', headers: ['ID','Title','Probability','Impact','Mitigation'], rows: risks.map(r=>[r.id,r.title,r.probability,r.impact,r.mitigation]) });
  const xlsxBytes = buildXLSX({ title: name, sheets: xlsxSheets });

  const mdLines = [`# ${name}`, `> ARTIFEX-BROWSER v${VERSION}`, '', ...sprints.map(sp=>`### ${sp.name}\n| ID | Title | Owner | Status | Pts |\n|----|-------|-------|--------|-----|\n${sp.tasks.map(t=>`| ${t.id} | ${t.title} | ${t.owner} | ${t.status} | ${t.points} |`).join('\n')}`)];
  const mdBytes = ENC.encode(mdLines.join('\n'));

  return buildZIP([
    { name: `${name}-roadmap.pdf`,  data: pdfBytes  },
    { name: `${name}-tracker.xlsx`, data: xlsxBytes },
    { name: `${name}-tracker.md`,   data: mdBytes   },
  ]);
}

/* ═══════════════════════════════════════════════════════════════════════
   OBJECT URL HELPERS
   ═══════════════════════════════════════════════════════════════════════ */

function makeURL(bytes, mimeType) {
  const blob = new Blob([bytes], { type: mimeType });
  const url  = URL.createObjectURL(blob);
  objectURLs.add(url);
  return url;
}

/* ═══════════════════════════════════════════════════════════════════════
   REMOTE FETCH (calls ARTIFEX Cloudflare Worker)
   ═══════════════════════════════════════════════════════════════════════ */

async function fetchRemote(endpoint, route, body, mimeType) {
  const res  = await fetch(`${endpoint}${route}`, {
    method:  'POST',
    headers: { 'Content-Type': 'application/json' },
    body:    JSON.stringify(body),
  });
  if (!res.ok) throw new Error(`ARTIFEX remote ${route} → ${res.status}`);
  const buf  = await res.arrayBuffer();
  const url  = makeURL(new Uint8Array(buf), mimeType);
  return { url, sizeBytes: buf.byteLength };
}

/* ═══════════════════════════════════════════════════════════════════════
   MESSAGE HANDLER
   ═══════════════════════════════════════════════════════════════════════ */

onmessage = async function (event) {
  const { type, ...data } = event.data || {};

  try {
    if (type === 'generate_pdf') {
      const bytes    = buildPDF(data.doc || {});
      const url      = makeURL(bytes, 'application/pdf');
      const filename = `${(data.doc && data.doc.title) || 'document'}.pdf`;
      artifactCount++;
      postMessage({ type: 'pdf_ready', url, filename, sizeBytes: bytes.length, beat: beatCount, local: true });
      return;
    }

    if (type === 'generate_xlsx') {
      const bytes    = buildXLSX(data.wb || {});
      const url      = makeURL(bytes, 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
      const filename = `${(data.wb && data.wb.title) || 'workbook'}.xlsx`;
      artifactCount++;
      postMessage({ type: 'xlsx_ready', url, filename, sizeBytes: bytes.length, beat: beatCount, local: true });
      return;
    }

    if (type === 'generate_pack') {
      const bytes    = buildPMPack(data.project || {});
      const url      = makeURL(bytes, 'application/zip');
      const filename = `${(data.project && data.project.name) || 'pm-pack'}.zip`;
      artifactCount += 3;
      postMessage({ type: 'pack_ready', url, filename, sizeBytes: bytes.length, beat: beatCount, local: true });
      return;
    }

    if (type === 'remote_pdf' && data.endpoint) {
      const { url, sizeBytes } = await fetchRemote(data.endpoint, '/generate/pdf', data.doc || {}, 'application/pdf');
      artifactCount++;
      postMessage({ type: 'pdf_ready', url, sizeBytes, filename: `${(data.doc&&data.doc.title)||'document'}.pdf`, beat: beatCount, local: false });
      return;
    }

    if (type === 'remote_xlsx' && data.endpoint) {
      const { url, sizeBytes } = await fetchRemote(data.endpoint, '/generate/xlsx', data.wb || {}, 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
      artifactCount++;
      postMessage({ type: 'xlsx_ready', url, sizeBytes, filename: `${(data.wb&&data.wb.title)||'workbook'}.xlsx`, beat: beatCount, local: false });
      return;
    }

    if (type === 'remote_pack' && data.endpoint) {
      const { url, sizeBytes } = await fetchRemote(data.endpoint, '/generate/pack', { project: data.project || {} }, 'application/zip');
      artifactCount += 3;
      postMessage({ type: 'pack_ready', url, sizeBytes, filename: `${(data.project&&data.project.name)||'pm-pack'}.zip`, beat: beatCount, local: false });
      return;
    }

    if (type === 'revoke_url' && data.url) {
      URL.revokeObjectURL(data.url);
      objectURLs.delete(data.url);
      postMessage({ type: 'url_revoked', url: data.url });
      return;
    }

    if (type === 'status') {
      postMessage({ type: 'status', worker: WORKER_ID, latin: LATIN, version: VERSION, beat: beatCount, artifacts: artifactCount, openURLs: objectURLs.size, phi: PHI, phiBeat: PHI_BEAT, ts: Date.now() });
      return;
    }

    if (type === 'heartbeat') {
      postMessage({ type: 'heartbeat', beat: ++beatCount, phi: PHI, worker: WORKER_ID });
      return;
    }
  } catch (e) {
    postMessage({ type: 'error', error: String(e), worker: WORKER_ID, beat: beatCount });
  }
};

// PHI_BEAT heartbeat — keeps the worker alive and signals the orchestrator
setInterval(() => {
  beatCount++;
  postMessage({ type: 'heartbeat', beat: beatCount, phi: PHI, artifacts: artifactCount, worker: WORKER_ID });
}, PHI_BEAT);

// Medina Doctrine · Copyright © 2024–2026 Alfredo Medina Hernandez · ARTIFEX-BROWSER v1.0.0
