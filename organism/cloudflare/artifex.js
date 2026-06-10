/**
 * ARTIFEX — SOVEREIGN Artifact Factory
 * Latin: "Artifex Documentorum Soveregni" — Sovereign Document Craftsman
 *
 * Cloudflare Worker — SOVEREIGN Surface III: ARTIFEX
 * Role: Real artifact generation — PDF (ISO 32000), XLSX (OOXML), PM Packs
 *
 * Routes:
 *   POST /generate/pdf      — PDF 1.4 binary from document schema
 *   POST /generate/xlsx     — XLSX (OOXML+ZIP) from tabular schema
 *   POST /generate/pack     — Full PM artifact pack (PDF + XLSX + tracker MD)
 *   POST /generate/roadmap  — Project roadmap PDF from project schema
 *   POST /session/start     — Open PM sandbox session
 *   POST /session/update    — Update session state
 *   POST /session/close     — Close session + TUNGSTEN reflection log
 *   GET  /status            — Worker health
 *   GET  /metrics           — Generation metrics
 *
 * PROTO-100–109 reserved for ARTIFEX protocol chain.
 *
 * PDF implementation: ISO 32000-1 §7 (object model), §8 (graphics), §9 (text).
 * XLSX implementation: ECMA-376 Part 1 (OOXML), ZIP stored (no compression).
 * No external dependencies. Pure Web API + typed arrays.
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

const PHI      = 1.618033988749895;
const PHI_INV  = 1 / PHI;
const PHI_BEAT = 873;
const VERSION  = '1.0.0';
const WORKER_ID = 'ARTIFEX-SOVEREIGN';
const LATIN     = 'Artifex Documentorum Soveregni';

let beatCount     = 0;
let artifactCount = 0;
let sessionCount  = 0;
const sessions    = new Map(); // sessionId → { context, log, ts, open }

/* ═══════════════════════════════════════════════════════════════════════
   UTILITIES
   ═══════════════════════════════════════════════════════════════════════ */

const ENC = new TextEncoder();

/** XML-escape a string for use inside XML element content or attributes. */
function xmlEsc(s) {
  return String(s)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;');
}

/**
 * Convert 0-based column index to spreadsheet letter (A, B, …, Z, AA, AB, …).
 * @param {number} col  0-based column index
 */
function colLetter(col) {
  let s = '';
  let n = col + 1;
  while (n > 0) {
    n--;
    s = String.fromCharCode(65 + (n % 26)) + s;
    n = Math.floor(n / 26);
  }
  return s;
}

/**
 * Encode a Date as DOS time+date words for ZIP local-file-header fields.
 * DOS time has 2-second resolution; date epoch is 1980-01-01.
 */
function dosDateTime(date) {
  const t = ((date.getHours() & 0x1F) << 11)
          | ((date.getMinutes() & 0x3F) << 5)
          | (Math.floor(date.getSeconds() / 2) & 0x1F);
  const d = (((date.getFullYear() - 1980) & 0x7F) << 9)
          | (((date.getMonth() + 1) & 0x0F) << 5)
          | (date.getDate() & 0x1F);
  return { time: t, date: d };
}

/**
 * CRC-32 per RFC 1952 / PKZIP spec.
 * Uses reflected polynomial 0xEDB88320 (bit-reversal of 0x04C11DB7).
 */
function crc32(data) {
  const table = new Uint32Array(256);
  for (let i = 0; i < 256; i++) {
    let c = i;
    for (let j = 0; j < 8; j++) {
      c = (c & 1) ? (0xEDB88320 ^ (c >>> 1)) : (c >>> 1);
    }
    table[i] = c;
  }
  let crc = 0xFFFFFFFF;
  for (let i = 0; i < data.length; i++) {
    crc = table[(crc ^ data[i]) & 0xFF] ^ (crc >>> 8);
  }
  return (crc ^ 0xFFFFFFFF) >>> 0;
}

/* ═══════════════════════════════════════════════════════════════════════
   ZIP BUILDER (PKZIP 2.0, stored / no compression)
   Implements PKZIP Application Note sections A, B, C.
   ═══════════════════════════════════════════════════════════════════════ */

/**
 * Build a valid .zip / .xlsx archive from an array of in-memory files.
 * Uses stored (method 0) compression — perfectly valid for OOXML.
 * @param {Array<{name: string, data: Uint8Array}>} files
 * @returns {Uint8Array}
 */
function buildZIP(files) {
  const parts = [];
  const centralDirEntries = [];
  let localOffset = 0;
  const dt = dosDateTime(new Date());

  for (const file of files) {
    const nameBytes = ENC.encode(file.name);
    const fileData  = file.data;
    const fileCRC   = crc32(fileData);
    const fileSize  = fileData.length;

    // Local file header (30 bytes + filename)
    const lhLen = 30 + nameBytes.length;
    const lh    = new Uint8Array(lhLen);
    const lhv   = new DataView(lh.buffer);
    lhv.setUint32(0,  0x04034B50, true); // signature PK\x03\x04
    lhv.setUint16(4,  20,         true); // version needed: 2.0
    lhv.setUint16(6,  0,          true); // general purpose flags
    lhv.setUint16(8,  0,          true); // compression: stored
    lhv.setUint16(10, dt.time,    true);
    lhv.setUint16(12, dt.date,    true);
    lhv.setUint32(14, fileCRC,    true);
    lhv.setUint32(18, fileSize,   true); // compressed size = uncompressed (stored)
    lhv.setUint32(22, fileSize,   true);
    lhv.setUint16(26, nameBytes.length, true);
    lhv.setUint16(28, 0,          true); // extra field length
    lh.set(nameBytes, 30);

    parts.push(lh, fileData);

    // Central directory entry (46 bytes + filename)
    const cdLen = 46 + nameBytes.length;
    const cd    = new Uint8Array(cdLen);
    const cdv   = new DataView(cd.buffer);
    cdv.setUint32(0,  0x02014B50, true); // signature PK\x01\x02
    cdv.setUint16(4,  20,         true); // version made by
    cdv.setUint16(6,  20,         true); // version needed
    cdv.setUint16(8,  0,          true);
    cdv.setUint16(10, 0,          true); // stored
    cdv.setUint16(12, dt.time,    true);
    cdv.setUint16(14, dt.date,    true);
    cdv.setUint32(16, fileCRC,    true);
    cdv.setUint32(20, fileSize,   true);
    cdv.setUint32(24, fileSize,   true);
    cdv.setUint16(28, nameBytes.length, true);
    cdv.setUint16(30, 0,          true); // extra length
    cdv.setUint16(32, 0,          true); // comment length
    cdv.setUint16(34, 0,          true); // disk start
    cdv.setUint16(36, 0,          true); // internal attrs
    cdv.setUint32(38, 0,          true); // external attrs
    cdv.setUint32(42, localOffset, true); // relative offset of local header
    cd.set(nameBytes, 46);

    centralDirEntries.push(cd);
    localOffset += lhLen + fileSize;
  }

  // Central directory
  const cdOffset = localOffset;
  const cdSize   = centralDirEntries.reduce((s, c) => s + c.length, 0);

  // End of central directory record (22 bytes)
  const eocd = new Uint8Array(22);
  const ev   = new DataView(eocd.buffer);
  ev.setUint32(0,  0x06054B50,     true); // signature PK\x05\x06
  ev.setUint16(4,  0,              true); // this disk
  ev.setUint16(6,  0,              true); // CD start disk
  ev.setUint16(8,  files.length,   true); // entries on this disk
  ev.setUint16(10, files.length,   true); // total entries
  ev.setUint32(12, cdSize,         true);
  ev.setUint32(16, cdOffset,       true);
  ev.setUint16(20, 0,              true); // comment length

  const allParts = [...parts, ...centralDirEntries, eocd];
  const total    = allParts.reduce((s, p) => s + p.length, 0);
  const out      = new Uint8Array(total);
  let   off      = 0;
  for (const p of allParts) { out.set(p, off); off += p.length; }
  return out;
}

/* ═══════════════════════════════════════════════════════════════════════
   XLSX BUILDER (ECMA-376 OOXML)
   Minimum-viable workbook: Content_Types, rels, workbook, sheet, styles,
   sharedStrings. Fully parseable by Excel, Numbers, LibreOffice Calc.
   ═══════════════════════════════════════════════════════════════════════ */

/**
 * Build a real .xlsx binary.
 * @param {{title?:string, sheets: Array<{name:string, headers:string[], rows:Array<Array<string|number>>}>}} wb
 * @returns {Uint8Array}
 */
function buildXLSX(wb) {
  const sheets = wb.sheets || [{ name: 'Sheet1', headers: [], rows: [] }];

  // ── Shared strings (all string cell values de-duplicated) ────────────
  const strIndex = new Map();
  const strList  = [];

  function addStr(s) {
    const k = String(s);
    if (!strIndex.has(k)) {
      strIndex.set(k, strList.length);
      strList.push(k);
    }
    return strIndex.get(k);
  }

  // Pre-scan to populate shared strings
  for (const sh of sheets) {
    for (const h of (sh.headers || [])) addStr(h);
    for (const row of (sh.rows || [])) {
      for (const cell of row) {
        if (typeof cell !== 'number') addStr(cell);
      }
    }
  }

  // ── Per-sheet XML ────────────────────────────────────────────────────
  const sheetXMLs = sheets.map((sh) => {
    const rows = [];
    let rowNum = 1;

    // Header row (style 1 = bold blue)
    if (sh.headers && sh.headers.length) {
      const cells = sh.headers.map((h, ci) => {
        const idx = addStr(h);
        return `<c r="${colLetter(ci)}${rowNum}" t="s" s="1"><v>${idx}</v></c>`;
      });
      rows.push(`<row r="${rowNum}">${cells.join('')}</row>`);
      rowNum++;
    }

    // Data rows (style 0 = normal)
    for (const row of (sh.rows || [])) {
      const cells = row.map((cell, ci) => {
        if (typeof cell === 'number') {
          return `<c r="${colLetter(ci)}${rowNum}"><v>${cell}</v></c>`;
        }
        const idx = addStr(String(cell));
        return `<c r="${colLetter(ci)}${rowNum}" t="s"><v>${idx}</v></c>`;
      });
      rows.push(`<row r="${rowNum}">${cells.join('')}</row>`);
      rowNum++;
    }

    return [
      `<?xml version="1.0" encoding="UTF-8" standalone="yes"?>`,
      `<worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main"`,
      ` xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">`,
      `<sheetData>${rows.join('')}</sheetData>`,
      `</worksheet>`,
    ].join('');
  });

  // ── Static XML fragments ─────────────────────────────────────────────
  const contentTypesXML = [
    `<?xml version="1.0" encoding="UTF-8" standalone="yes"?>`,
    `<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">`,
    `<Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>`,
    `<Default Extension="xml" ContentType="application/xml"/>`,
    `<Override PartName="/xl/workbook.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml"/>`,
    ...sheets.map((_, i) => `<Override PartName="/xl/worksheets/sheet${i + 1}.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/>`),
    `<Override PartName="/xl/sharedStrings.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sharedStrings+xml"/>`,
    `<Override PartName="/xl/styles.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.styles+xml"/>`,
    `</Types>`,
  ].join('');

  const rootRelsXML = [
    `<?xml version="1.0" encoding="UTF-8" standalone="yes"?>`,
    `<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">`,
    `<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="xl/workbook.xml"/>`,
    `</Relationships>`,
  ].join('');

  const workbookXML = [
    `<?xml version="1.0" encoding="UTF-8" standalone="yes"?>`,
    `<workbook xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main"`,
    ` xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">`,
    `<sheets>`,
    ...sheets.map((s, i) => `<sheet name="${xmlEsc(s.name || `Sheet${i + 1}`)}" sheetId="${i + 1}" r:id="rId${i + 1}"/>`),
    `</sheets>`,
    `</workbook>`,
  ].join('');

  const workbookRelsXML = [
    `<?xml version="1.0" encoding="UTF-8" standalone="yes"?>`,
    `<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">`,
    ...sheets.map((_, i) => `<Relationship Id="rId${i + 1}" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet" Target="worksheets/sheet${i + 1}.xml"/>`),
    `<Relationship Id="rId${sheets.length + 1}" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/sharedStrings" Target="sharedStrings.xml"/>`,
    `<Relationship Id="rId${sheets.length + 2}" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles" Target="styles.xml"/>`,
    `</Relationships>`,
  ].join('');

  const sharedStringsXML = [
    `<?xml version="1.0" encoding="UTF-8" standalone="yes"?>`,
    `<sst xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main"`,
    ` count="${strList.length}" uniqueCount="${strList.length}">`,
    ...strList.map(s => `<si><t>${xmlEsc(s)}</t></si>`),
    `</sst>`,
  ].join('');

  // Two styles: 0=normal, 1=bold+blue header
  const stylesXML = [
    `<?xml version="1.0" encoding="UTF-8" standalone="yes"?>`,
    `<styleSheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">`,
    `<fonts count="2">`,
    `<font><sz val="11"/><name val="Calibri"/></font>`,
    `<font><b/><sz val="11"/><name val="Calibri"/><color rgb="FF1F1F9B"/></font>`,
    `</fonts>`,
    `<fills count="2">`,
    `<fill><patternFill patternType="none"/></fill>`,
    `<fill><patternFill patternType="gray125"/></fill>`,
    `</fills>`,
    `<borders count="1"><border><left/><right/><top/><bottom/><diagonal/></border></borders>`,
    `<cellStyleXfs count="1"><xf numFmtId="0" fontId="0" fillId="0" borderId="0"/></cellStyleXfs>`,
    `<cellXfs count="2">`,
    `<xf numFmtId="0" fontId="0" fillId="0" borderId="0" xfId="0"/>`,
    `<xf numFmtId="0" fontId="1" fillId="0" borderId="0" xfId="0"/>`,
    `</cellXfs>`,
    `</styleSheet>`,
  ].join('');

  // ── Assemble ZIP file list ────────────────────────────────────────────
  const files = [
    { name: '[Content_Types].xml',       data: ENC.encode(contentTypesXML) },
    { name: '_rels/.rels',               data: ENC.encode(rootRelsXML) },
    { name: 'xl/workbook.xml',           data: ENC.encode(workbookXML) },
    { name: 'xl/_rels/workbook.xml.rels',data: ENC.encode(workbookRelsXML) },
    { name: 'xl/sharedStrings.xml',      data: ENC.encode(sharedStringsXML) },
    { name: 'xl/styles.xml',             data: ENC.encode(stylesXML) },
    ...sheetXMLs.map((xml, i) => ({ name: `xl/worksheets/sheet${i + 1}.xml`, data: ENC.encode(xml) })),
  ];

  return buildZIP(files);
}

/* ═══════════════════════════════════════════════════════════════════════
   PDF BUILDER (ISO 32000-1, PDF 1.4)
   Object model: fonts → info → N*(content-stream + page) → pages → catalog
   All offsets computed before writing so xref is correct.
   Graphics: fill rg / stroke RG, line w+m+l+S, text BT/ET/Tm/Tj/Tf/Td
   ═══════════════════════════════════════════════════════════════════════ */

/**
 * Encode a string as a PDF literal string: (…) with \\ \( \) escapes.
 * Non-ASCII stripped to ASCII-safe equivalent so UTF-8 byte count == char count,
 * which keeps the /Length entry of each stream correct.
 */
function pdfStr(s) {
  const safe = String(s)
    .replace(/\u03c6/g, 'phi')
    .replace(/\u00a9/g, '(C)')
    .replace(/\u2014/g, '--')
    .replace(/\u2013/g, '-')
    .replace(/\u2019/g, "'")
    .replace(/[^\x20-\x7E]/g, '?');
  return '(' + safe.replace(/\\/g, '\\\\').replace(/\(/g, '\\(').replace(/\)/g, '\\)') + ')';
}

/**
 * Build a real PDF 1.4 binary.
 * @param {{title?:string, author?:string, subject?:string, pages:Array<{heading:string, lines:string[]}>}} doc
 * @returns {Uint8Array}
 */
function buildPDF(doc) {
  const pages = doc.pages && doc.pages.length ? doc.pages : [{ heading: doc.title || 'Document', lines: [] }];
  const N = pages.length;

  // Pre-calculate every object number so each page object knows its parent.
  const OBJ_FONT_BOLD = 1;  // Helvetica-Bold (headings)
  const OBJ_FONT_REG  = 2;  // Helvetica      (body)
  const OBJ_INFO      = 3;
  // For page i (0-based): content stream = 4+2*i, page dict = 5+2*i
  const OBJ_PAGES     = 4 + 2 * N;
  const OBJ_CATALOG   = 4 + 2 * N + 1;
  const TOTAL_OBJS    = 4 + 2 * N + 2; // includes free object 0

  const parts   = [];
  const offsets = new Array(TOTAL_OBJS).fill(0);
  let   pos     = 0;

  function write(s) {
    const b = typeof s === 'string' ? ENC.encode(s) : s;
    parts.push(b);
    pos += b.length;
  }

  // ── Header ─────────────────────────────────────────────────────────
  write('%PDF-1.4\n');

  // ── Fonts ───────────────────────────────────────────────────────────
  offsets[OBJ_FONT_BOLD] = pos;
  write(`${OBJ_FONT_BOLD} 0 obj\n<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica-Bold /Encoding /WinAnsiEncoding >>\nendobj\n`);

  offsets[OBJ_FONT_REG] = pos;
  write(`${OBJ_FONT_REG} 0 obj\n<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica /Encoding /WinAnsiEncoding >>\nendobj\n`);

  // ── Info dictionary ─────────────────────────────────────────────────
  const now = new Date();
  const datePDF = `D:${now.getUTCFullYear()}${String(now.getUTCMonth()+1).padStart(2,'0')}${String(now.getUTCDate()).padStart(2,'0')}${String(now.getUTCHours()).padStart(2,'0')}${String(now.getUTCMinutes()).padStart(2,'0')}${String(now.getUTCSeconds()).padStart(2,'0')}+00'00'`;
  offsets[OBJ_INFO] = pos;
  write(`${OBJ_INFO} 0 obj\n<< /Title ${pdfStr(doc.title || 'SOVEREIGN')} /Author ${pdfStr(doc.author || 'SOVEREIGN')} /Subject ${pdfStr(doc.subject || 'Medina Doctrine')} /Creator (ARTIFEX-SOVEREIGN v${VERSION}) /CreationDate ${pdfStr(datePDF)} >>\nendobj\n`);

  // ── Page content streams + page dictionaries ─────────────────────────
  const pageObjNums = [];

  for (let i = 0; i < N; i++) {
    const page   = pages[i];
    const cObjN  = 4 + 2 * i;      // content stream object number
    const pObjN  = 5 + 2 * i;      // page dictionary object number
    pageObjNums.push(pObjN);

    // Build content stream (pure ASCII — all operators defined in ISO 32000-1 §8–9)
    const s = [];

    // -- Page header band -----------------------------------------------
    s.push('BT');
    s.push('1 0 0 1 36 775 Tm');             // absolute position (ISO 32000 §9.4.2)
    s.push('/FB 10 Tf');                      // font alias /FB = Font Bold
    s.push('0.20 0.20 0.60 rg');             // fill colour (RGB) for text
    s.push(`${pdfStr('MERIDIANUS PLATFORM -- MEDINA DOCTRINE -- SOVEREIGN ARTIFACT')} Tj`);
    s.push('/FR 8 Tf');
    s.push('0.50 0.50 0.50 rg');
    s.push('0 -12 Td');
    s.push(`${pdfStr(`phi=1.618033988749895 -- phi-BEAT=873ms -- Copyright (C) 2024-2026 Alfredo Medina Hernandez`)} Tj`);

    // -- Heading --------------------------------------------------------
    s.push('/FB 16 Tf');
    s.push('0.05 0.05 0.05 rg');
    s.push('0 -28 Td');
    s.push(`${pdfStr(page.heading || '')} Tj`);
    s.push('ET');

    // -- Separator line -------------------------------------------------
    s.push('0.20 0.20 0.60 RG');             // stroke colour
    s.push('0.8 w');                          // line width (pt)
    s.push('36 720 m 576 720 l S');           // moveto, lineto, stroke

    // -- Body text ------------------------------------------------------
    s.push('BT');
    s.push('1 0 0 1 36 705 Tm');
    s.push('/FR 11 Tf');
    s.push('0.05 0.05 0.05 rg');

    for (const line of (page.lines || [])) {
      if (line === '') {
        s.push('0 -6 Td');
        continue;
      }
      if (line.startsWith('## ')) {
        s.push('/FB 13 Tf 0.10 0.10 0.40 rg');
        s.push(`${pdfStr(line.slice(3))} Tj`);
        s.push('/FR 11 Tf 0.05 0.05 0.05 rg 0 -22 Td');
      } else if (line.startsWith('- ') || line.startsWith('• ')) {
        s.push(`${pdfStr(line)} Tj 0 -15 Td`);
      } else {
        s.push(`${pdfStr(line)} Tj 0 -15 Td`);
      }
    }

    // -- Footer ---------------------------------------------------------
    s.push('1 0 0 1 36 30 Tm');              // absolute position for footer
    s.push('/FR 8 Tf 0.50 0.50 0.50 rg');
    s.push(`${pdfStr(`Page ${i + 1} of ${N}  |  ARTIFEX-SOVEREIGN  |  ${doc.title || 'Document'}`)} Tj`);
    s.push('ET');

    const streamStr  = s.join('\n');
    const streamData = ENC.encode(streamStr);

    // Write content stream object
    offsets[cObjN] = pos;
    write(`${cObjN} 0 obj\n<< /Length ${streamData.length} >>\nstream\n`);
    write(streamData);
    write('\nendstream\nendobj\n');

    // Write page dictionary — font resources use aliases /FB and /FR
    offsets[pObjN] = pos;
    write(`${pObjN} 0 obj\n<< /Type /Page /Parent ${OBJ_PAGES} 0 R /MediaBox [0 0 612 792] /Contents ${cObjN} 0 R /Resources << /Font << /FB ${OBJ_FONT_BOLD} 0 R /FR ${OBJ_FONT_REG} 0 R >> >> >>\nendobj\n`);
  }

  // ── Pages container ─────────────────────────────────────────────────
  offsets[OBJ_PAGES] = pos;
  write(`${OBJ_PAGES} 0 obj\n<< /Type /Pages /Kids [${pageObjNums.map(n => `${n} 0 R`).join(' ')}] /Count ${N} >>\nendobj\n`);

  // ── Catalog ─────────────────────────────────────────────────────────
  offsets[OBJ_CATALOG] = pos;
  write(`${OBJ_CATALOG} 0 obj\n<< /Type /Catalog /Pages ${OBJ_PAGES} 0 R >>\nendobj\n`);

  // ── Cross-reference table (ISO 32000-1 §7.5.4) ──────────────────────
  const xrefPos = pos;
  write(`xref\n0 ${TOTAL_OBJS}\n`);
  write('0000000000 65535 f \n');             // free entry for object 0
  for (let i = 1; i < TOTAL_OBJS; i++) {
    write(`${String(offsets[i]).padStart(10, '0')} 00000 n \n`);
  }

  // ── Trailer ─────────────────────────────────────────────────────────
  write(`trailer\n<< /Size ${TOTAL_OBJS} /Root ${OBJ_CATALOG} 0 R /Info ${OBJ_INFO} 0 R >>\nstartxref\n${xrefPos}\n%%EOF\n`);

  // ── Concatenate all byte parts ───────────────────────────────────────
  const total = parts.reduce((sum, p) => sum + p.length, 0);
  const out   = new Uint8Array(total);
  let   off   = 0;
  for (const p of parts) { out.set(p, off); off += p.length; }
  return out;
}

/* ═══════════════════════════════════════════════════════════════════════
   PM ARTIFACT PACK GENERATOR
   Converts a project schema into a 3-artifact pack: roadmap PDF,
   sprint XLSX, and a markdown tracker.
   ═══════════════════════════════════════════════════════════════════════ */

/**
 * @param {{name:string, description?:string, sprints:Array<{id:number,name:string,start:string,end:string,tasks:Array<{id:string,title:string,owner:string,priority:string,status:string,points:number}>}>, risks?:Array<{id:string,title:string,probability:string,impact:string,mitigation:string}>, stakeholders?:string[]}} project
 */
function buildPMPack(project) {
  const name         = project.name        || 'Untitled Project';
  const description  = project.description || '';
  const sprints      = project.sprints      || [];
  const risks        = project.risks        || [];
  const stakeholders = project.stakeholders || [];

  // ── Roadmap PDF ─────────────────────────────────────────────────────
  const pdfPages = [];

  // Cover page
  pdfPages.push({
    heading: name,
    lines: [
      description,
      '',
      `## Project Overview`,
      `Sprints: ${sprints.length}`,
      `Total tasks: ${sprints.reduce((s, sp) => s + sp.tasks.length, 0)}`,
      `Risks identified: ${risks.length}`,
      `Stakeholders: ${stakeholders.join(', ') || 'TBD'}`,
      '',
      `## Timeline`,
      sprints.length
        ? `Start: ${sprints[0].start}  |  End: ${sprints[sprints.length - 1].end}`
        : 'Timeline TBD',
    ],
  });

  // One page per sprint
  for (const sp of sprints) {
    pdfPages.push({
      heading: `${sp.name} (${sp.start} to ${sp.end})`,
      lines: [
        `## Tasks (${sp.tasks.length})`,
        ...sp.tasks.map(t => `- [${t.status}] ${t.id}: ${t.title} -- ${t.owner} (${t.priority}, ${t.points} pts)`),
        '',
        `## Sprint Goal`,
        sp.goal || 'Deliver planned tasks on time.',
      ],
    });
  }

  // Risk register page
  if (risks.length) {
    pdfPages.push({
      heading: 'Risk Register',
      lines: [
        '## Active Risks',
        ...risks.map(r => `- [${r.probability}/${r.impact}] ${r.id}: ${r.title} -- ${r.mitigation}`),
      ],
    });
  }

  const pdfBytes = buildPDF({
    title:   name,
    author:  'SOVEREIGN PM Engine',
    subject: 'Project Roadmap',
    pages:   pdfPages,
  });

  // ── Sprint Tracker XLSX ─────────────────────────────────────────────
  const xlsxSheets = sprints.map(sp => ({
    name: sp.name.slice(0, 31), // Excel sheet name limit 31 chars
    headers: ['ID', 'Title', 'Owner', 'Priority', 'Status', 'Points', 'Sprint', 'Start', 'End'],
    rows: sp.tasks.map(t => [
      t.id, t.title, t.owner, t.priority, t.status, t.points, sp.name, sp.start, sp.end,
    ]),
  }));

  if (!xlsxSheets.length) {
    xlsxSheets.push({ name: 'Tasks', headers: ['ID', 'Title', 'Owner', 'Status', 'Points'], rows: [] });
  }

  // Risk sheet
  if (risks.length) {
    xlsxSheets.push({
      name: 'Risk Register',
      headers: ['ID', 'Title', 'Probability', 'Impact', 'Mitigation'],
      rows: risks.map(r => [r.id, r.title, r.probability, r.impact, r.mitigation]),
    });
  }

  const xlsxBytes = buildXLSX({ title: name, sheets: xlsxSheets });

  // ── Markdown tracker ────────────────────────────────────────────────
  const mdLines = [
    `# ${name} — PM Tracker`,
    `> Generated by ARTIFEX-SOVEREIGN v${VERSION} | Medina Doctrine`,
    '',
    `## Project`,
    description,
    '',
    `## Sprints`,
  ];
  for (const sp of sprints) {
    mdLines.push(`### ${sp.name} (${sp.start} → ${sp.end})`);
    mdLines.push('| ID | Title | Owner | Priority | Status | Pts |');
    mdLines.push('|----|-------|-------|----------|--------|-----|');
    for (const t of sp.tasks) {
      mdLines.push(`| ${t.id} | ${t.title} | ${t.owner} | ${t.priority} | ${t.status} | ${t.points} |`);
    }
    mdLines.push('');
  }
  if (risks.length) {
    mdLines.push('## Risk Register');
    mdLines.push('| ID | Title | Prob | Impact | Mitigation |');
    mdLines.push('|----|-------|------|--------|------------|');
    for (const r of risks) {
      mdLines.push(`| ${r.id} | ${r.title} | ${r.probability} | ${r.impact} | ${r.mitigation} |`);
    }
  }
  const mdBytes = ENC.encode(mdLines.join('\n'));

  return { pdfBytes, xlsxBytes, mdBytes };
}

/* ═══════════════════════════════════════════════════════════════════════
   SESSION MANAGEMENT (PM Sandbox)
   ═══════════════════════════════════════════════════════════════════════ */

function sessionId() {
  // φ-seeded random hex — 32 chars
  const buf = new Uint8Array(16);
  crypto.getRandomValues(buf);
  return Array.from(buf).map(b => b.toString(16).padStart(2, '0')).join('');
}

function startSession(userId, projectName) {
  const id = sessionId();
  const ts = Date.now();
  sessions.set(id, {
    id,
    userId:      userId || 'anon',
    projectName: projectName || 'Untitled',
    context:     {},
    log:         [`Session started: ${new Date(ts).toISOString()}`],
    ts,
    open:        true,
    beatAtOpen:  ++beatCount,
    phiSync:     PHI,
  });
  sessionCount++;
  return id;
}

function updateSession(id, context) {
  const s = sessions.get(id);
  if (!s || !s.open) return null;
  Object.assign(s.context, context);
  s.log.push(`Updated: ${new Date().toISOString()} — keys: ${Object.keys(context).join(',')}`);
  return s;
}

function closeSession(id) {
  const s = sessions.get(id);
  if (!s) return null;
  s.open = false;
  const durationMs = Date.now() - s.ts;
  const beatsElapsed = Math.round(durationMs / PHI_BEAT);
  // TUNGSTEN reflection log
  s.tungsten = {
    durationMs,
    beatsElapsed,
    phiBeats:          beatsElapsed * PHI,
    coherenceScore:    Math.min(PHI_INV, 0.5 + beatsElapsed * 0.01), // approaches phi^-1
    certaintyLevel:    beatsElapsed > 89 ? 'HIGH' : beatsElapsed > 34 ? 'MEDIUM' : 'LOW',
    playbook:          `Session closed after ${beatsElapsed} beats (${(durationMs / 1000).toFixed(1)}s)`,
    doctrineAligned:   true,
    memoryWriteAllowed: beatsElapsed >= 34, // Fibonacci threshold for pattern consolidation
  };
  s.log.push(`Session closed: ${new Date().toISOString()}`);
  return s;
}

/* ═══════════════════════════════════════════════════════════════════════
   REQUEST HANDLER
   ═══════════════════════════════════════════════════════════════════════ */

const CORS = {
  'Content-Type':                'application/json',
  'Access-Control-Allow-Origin': '*',
  'X-Worker-ID':                 WORKER_ID,
  'X-Worker-Latin':              LATIN,
  'X-Phi':                       String(PHI),
};

async function handleRequest(request, env) {
  const url    = new URL(request.url);
  const path   = url.pathname;
  beatCount++;

  if (request.method === 'OPTIONS') {
    return new Response(null, {
      status: 204,
      headers: {
        ...CORS,
        'Access-Control-Allow-Methods':  'GET,POST,OPTIONS',
        'Access-Control-Allow-Headers':  'Content-Type,Authorization',
      },
    });
  }

  // ── GET /status ─────────────────────────────────────────────────────
  if (path === '/status' && request.method === 'GET') {
    return new Response(JSON.stringify({
      worker: WORKER_ID, latin: LATIN, version: VERSION,
      status: 'alive', beat: beatCount, artifacts: artifactCount,
      sessions: { total: sessionCount, open: [...sessions.values()].filter(s => s.open).length },
      phi: PHI, ts: Date.now(),
    }), { headers: CORS });
  }

  // ── GET /metrics ────────────────────────────────────────────────────
  if (path === '/metrics' && request.method === 'GET') {
    return new Response(JSON.stringify({
      worker: WORKER_ID, beats: beatCount, artifacts: artifactCount,
      sessionCount, phi: PHI, phiBeat: PHI_BEAT, ts: Date.now(),
    }), { headers: CORS });
  }

  // ── POST /generate/pdf ───────────────────────────────────────────────
  if (path === '/generate/pdf' && request.method === 'POST') {
    let body;
    try { body = await request.json(); } catch { return err400('Invalid JSON'); }

    const pdfBytes = buildPDF({
      title:   body.title   || 'SOVEREIGN Document',
      author:  body.author  || 'SOVEREIGN',
      subject: body.subject || 'Medina Doctrine',
      pages:   body.pages   || [{ heading: body.title || 'Document', lines: body.lines || [] }],
    });

    artifactCount++;
    return new Response(pdfBytes, {
      headers: {
        'Content-Type':        'application/pdf',
        'Content-Disposition': `attachment; filename="${encodeURIComponent(body.title || 'document')}.pdf"`,
        'Content-Length':      String(pdfBytes.length),
        'X-Worker-ID':         WORKER_ID,
        'X-Artifact-Count':    String(artifactCount),
        'Access-Control-Allow-Origin': '*',
      },
    });
  }

  // ── POST /generate/xlsx ──────────────────────────────────────────────
  if (path === '/generate/xlsx' && request.method === 'POST') {
    let body;
    try { body = await request.json(); } catch { return err400('Invalid JSON'); }

    const xlsxBytes = buildXLSX({
      title:  body.title || 'SOVEREIGN Workbook',
      sheets: body.sheets || [{ name: 'Sheet1', headers: body.headers || [], rows: body.rows || [] }],
    });

    artifactCount++;
    return new Response(xlsxBytes, {
      headers: {
        'Content-Type':        'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
        'Content-Disposition': `attachment; filename="${encodeURIComponent(body.title || 'workbook')}.xlsx"`,
        'Content-Length':      String(xlsxBytes.length),
        'X-Worker-ID':         WORKER_ID,
        'X-Artifact-Count':    String(artifactCount),
        'Access-Control-Allow-Origin': '*',
      },
    });
  }

  // ── POST /generate/pack ──────────────────────────────────────────────
  if (path === '/generate/pack' && request.method === 'POST') {
    let body;
    try { body = await request.json(); } catch { return err400('Invalid JSON'); }

    const project = body.project;
    if (!project) return err400('Missing project schema');

    const { pdfBytes, xlsxBytes, mdBytes } = buildPMPack(project);

    // Return pack as a ZIP containing all three artifacts
    const packZip = buildZIP([
      { name: `${project.name || 'project'}-roadmap.pdf`,  data: pdfBytes  },
      { name: `${project.name || 'project'}-tracker.xlsx`, data: xlsxBytes },
      { name: `${project.name || 'project'}-tracker.md`,   data: mdBytes   },
    ]);

    artifactCount += 3;
    return new Response(packZip, {
      headers: {
        'Content-Type':        'application/zip',
        'Content-Disposition': `attachment; filename="${encodeURIComponent(project.name || 'pm-pack')}.zip"`,
        'Content-Length':      String(packZip.length),
        'X-Worker-ID':         WORKER_ID,
        'X-Pack-Contains':     'pdf,xlsx,md',
        'Access-Control-Allow-Origin': '*',
      },
    });
  }

  // ── POST /session/start ──────────────────────────────────────────────
  if (path === '/session/start' && request.method === 'POST') {
    let body = {};
    try { body = await request.json(); } catch { /* ok */ }
    const id = startSession(body.userId, body.projectName);
    return new Response(JSON.stringify({ session_id: id, phi: PHI, beat: beatCount, ts: Date.now() }), { headers: CORS });
  }

  // ── POST /session/update ─────────────────────────────────────────────
  if (path === '/session/update' && request.method === 'POST') {
    let body;
    try { body = await request.json(); } catch { return err400('Invalid JSON'); }
    const s = updateSession(body.session_id, body.context || {});
    if (!s) return err404('Session not found or closed');
    return new Response(JSON.stringify({ ok: true, session_id: body.session_id, log: s.log.slice(-3) }), { headers: CORS });
  }

  // ── POST /session/close ──────────────────────────────────────────────
  if (path === '/session/close' && request.method === 'POST') {
    let body;
    try { body = await request.json(); } catch { return err400('Invalid JSON'); }
    const s = closeSession(body.session_id);
    if (!s) return err404('Session not found');
    return new Response(JSON.stringify({ ok: true, session_id: body.session_id, tungsten: s.tungsten }), { headers: CORS });
  }

  return new Response(JSON.stringify({ error: 'not_found', worker: WORKER_ID }), { status: 404, headers: CORS });
}

function err400(msg) {
  return new Response(JSON.stringify({ error: 'bad_request', message: msg, worker: WORKER_ID }), { status: 400, headers: CORS });
}
function err404(msg) {
  return new Response(JSON.stringify({ error: 'not_found', message: msg, worker: WORKER_ID }), { status: 404, headers: CORS });
}

export default { async fetch(request, env) { return handleRequest(request, env); } };
