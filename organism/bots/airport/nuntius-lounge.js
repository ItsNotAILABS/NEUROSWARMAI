/**
 * NUNTIUS LOUNGE — Organism Airport Bot V: Lounge Access Intelligence
 * (Latin: "Messenger of the Lounge")
 *
 * Cloudflare Worker — BOT-AIR-005
 * Role: Given a MERIDIANUS token tier, determines which airport lounges
 *       are accessible — Priority Pass, Amex Centurion, or MERIDIANUS
 *       sovereign access. Returns lounge details, amenities, and access rules.
 *
 * Routes:
 *   GET /access?airport=LAX&token=<id>     — Which lounges I can access
 *   GET /lounge?airport=LAX&name=<lounge>  — Lounge details
 *   GET /airports                          — Supported airports
 *   GET /status                            — Worker self-health check
 *   GET /metrics                           — Beat count + query metrics
 *
 * Token gate: NXS (NEXUS) tier = Priority Pass lounges
 *             PHT (PHANTOM) tier = Centurion + sovereign lounges
 *             GOL (GOLDEN) = Sovereign access everywhere
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

import { verifyToken, canAccess, TOKEN_TIERS } from '../shared/token-verify.js';

const PHI      = 1.618033988749895;
const PHI_INV  = 1 / PHI;
const BOT_ID   = 'BOT-AIR-005';
const BOT_NAME = 'NUNTIUS LOUNGE';
const BOT_LATIN= 'Nuntius Deversori Nobilium';
const VERSION  = '1.0.0';

let beatCount  = 0;
let queryCount = 0;

/* ─── Lounge access tier rules ──────────────────────────────────────────── */

// access: 'priority_pass' | 'centurion' | 'sovereign' | 'airline_card'
const ACCESS_TIERS = {
  priority_pass: { minTier: 4, label: 'Priority Pass / NXS+' },
  centurion:     { minTier: 6, label: 'Centurion / PHT+' },
  sovereign:     { minTier: 8, label: 'MERIDIANUS Sovereign / GOL' },
  airline_card:  { minTier: 1, label: 'Airline Credit Card' },
};

/* ─── Lounge database ───────────────────────────────────────────────────── */

const LOUNGES = {
  LAX: [
    {
      name:      'Delta Sky Club T2',
      terminal:  '2',
      access:    ['priority_pass', 'airline_card'],
      hours:     '5:00 AM – Last Departure',
      amenities: ['Hot food buffet', 'Open bar', 'Showers', 'High-speed WiFi', 'Massage chairs'],
      capacity:  200,
      location:  'Past security, Level 3',
    },
    {
      name:      'American Admirals Club T4',
      terminal:  '4',
      access:    ['airline_card'],
      hours:     '5:00 AM – 11:00 PM',
      amenities: ['Hot snacks', 'Open bar', 'Business center', 'WiFi'],
      capacity:  150,
      location:  'Gate 43, mezzanine level',
    },
    {
      name:      'United Club T7',
      terminal:  '7',
      access:    ['priority_pass', 'airline_card'],
      hours:     '5:00 AM – 11:00 PM',
      amenities: ['Continental buffet', 'Open bar', 'Showers', 'WiFi'],
      capacity:  180,
      location:  'Level 3, past security',
    },
    {
      name:      'Air France Lounge TBIT',
      terminal:  'B',
      access:    ['priority_pass', 'centurion', 'airline_card'],
      hours:     '6:00 AM – Last Departure',
      amenities: ['À la carte dining', 'Champagne', 'Spa treatments', 'Showers'],
      capacity:  120,
      location:  'TBIT, Level 4',
    },
    {
      name:      'MERIDIANUS Sovereign Lounge',
      terminal:  'B',
      access:    ['sovereign'],
      hours:     '24/7',
      amenities: ['Gourmet dining', 'φ-synchronized ambience', 'Private suites', 'Concierge', 'Starlink WiFi'],
      capacity:  21,
      location:  'Private — TBIT Level 5 (token-gated entry)',
      note:      'Requires GOL token. Access code generated at entry.',
    },
  ],
  JFK: [
    {
      name:      'Delta Sky Club T4',
      terminal:  '4',
      access:    ['priority_pass', 'airline_card'],
      hours:     '5:00 AM – Last Departure',
      amenities: ['Buffet', 'Bar', 'Showers', 'Spa', 'WiFi'],
      capacity:  250,
      location:  'Past security, Level 3',
    },
    {
      name:      'The Centurion Lounge JFK',
      terminal:  '4',
      access:    ['centurion'],
      hours:     '5:30 AM – 11:00 PM',
      amenities: ['Chef-curated menu', 'Spa treatments', 'Shower suites', 'Cocktail bar', 'Kids area'],
      capacity:  300,
      location:  'T4, Post-security near gates A1-A11',
    },
    {
      name:      'British Airways Galleries Club T8',
      terminal:  '8',
      access:    ['airline_card', 'priority_pass'],
      hours:     '6:00 AM – Last Departure',
      amenities: ['Afternoon tea', 'Bar', 'Showers', 'Business center'],
      capacity:  180,
      location:  'Terminal 8, Level 3',
    },
    {
      name:      'Emirates Lounge T4',
      terminal:  '4',
      access:    ['airline_card', 'centurion'],
      hours:     '6:00 AM – Last Departure',
      amenities: ['Fine dining', 'Champagne bar', 'Spa', 'Cigar room'],
      capacity:  100,
      location:  'T4 Concourse B',
    },
  ],
  ORD: [
    {
      name:      'United Club T1',
      terminal:  '1',
      access:    ['priority_pass', 'airline_card'],
      hours:     '5:00 AM – 11:00 PM',
      amenities: ['Buffet', 'Open bar', 'Showers', 'WiFi'],
      capacity:  200,
      location:  'Concourse B, Gate B6',
    },
    {
      name:      "Admirals Club T3",
      terminal:  '3',
      access:    ['airline_card'],
      hours:     '4:30 AM – 10:00 PM',
      amenities: ['Hot food', 'Bar', 'Business center', 'WiFi'],
      capacity:  220,
      location:  'Concourse H, Gate H5',
    },
    {
      name:      'American Airlines Flagship Lounge',
      terminal:  '3',
      access:    ['centurion', 'airline_card'],
      hours:     '5:00 AM – Last Departure',
      amenities: ['Chef-prepared meals', 'Premium bar', 'Flagship First Dining'],
      capacity:  89,
      location:  'Concourse K, Gate K14 (international)',
    },
  ],
  LHR: [
    {
      name:      'Lufthansa Business Lounge T2',
      terminal:  '2',
      access:    ['airline_card', 'priority_pass'],
      hours:     '5:00 AM – Last Departure',
      amenities: ['Hot buffet', 'Open bar', 'Showers', 'WiFi'],
      capacity:  250,
      location:  'T2 Satellite B',
    },
    {
      name:      'BA Galleries Club T5',
      terminal:  '5',
      access:    ['airline_card', 'priority_pass'],
      hours:     '5:00 AM – Last Departure',
      amenities: ['Buffet', 'Bar', 'Showers', 'Spa (paid)', 'WiFi'],
      capacity:  400,
      location:  'T5A, post-security',
    },
    {
      name:      'BA Galleries First T5',
      terminal:  '5',
      access:    ['airline_card', 'centurion'],
      hours:     '5:00 AM – Last Departure',
      amenities: ['À la carte dining', 'Champagne bar', 'Elemis spa', 'Private dining'],
      capacity:  144,
      location:  'T5A, above Galleries Club',
    },
    {
      name:      'Concorde Room T5',
      terminal:  '5',
      access:    ['sovereign'],
      hours:     '24/7',
      amenities: ['Exclusive dining', 'Daybeds', 'Concierge', 'Champagne on demand'],
      capacity:  34,
      location:  'T5A, restricted access',
      note:      'First Class or GOL tier only.',
    },
  ],
};

/* ─── Access logic ──────────────────────────────────────────────────────── */

function getLoungesForTier(airport, tier) {
  const airportLounges = LOUNGES[airport.toUpperCase()] || [];
  return airportLounges.filter(lounge => {
    return lounge.access.some(accessType => {
      const rule = ACCESS_TIERS[accessType];
      return rule && tier >= rule.minTier;
    });
  }).map(lounge => ({
    ...lounge,
    accessVia: lounge.access.filter(a => tier >= (ACCESS_TIERS[a]?.minTier ?? 99)).map(a => ACCESS_TIERS[a]?.label),
  }));
}

/* ─── Request handler ───────────────────────────────────────────────────── */

async function handleRequest(request, env) {
  const url  = new URL(request.url);
  const path = url.pathname;
  const cors = {
    'Content-Type': 'application/json',
    'Access-Control-Allow-Origin': '*',
    'X-Bot-ID': BOT_ID,
    'X-Bot-Name': BOT_NAME,
  };

  if (request.method === 'OPTIONS') {
    return new Response(null, { status: 204, headers: { ...cors, 'Access-Control-Allow-Methods': 'GET', 'Access-Control-Allow-Headers': 'Content-Type' } });
  }

  if (path === '/status' && request.method === 'GET') {
    return new Response(JSON.stringify({
      botId: BOT_ID, worker: BOT_NAME, latinName: BOT_LATIN, version: VERSION,
      status: 'alive', beat: beatCount, queryCount, airports: Object.keys(LOUNGES).length, phi: PHI, ts: Date.now(),
    }), { headers: cors });
  }

  if (path === '/metrics' && request.method === 'GET') {
    return new Response(JSON.stringify({
      botId: BOT_ID, worker: BOT_NAME, beats: beatCount, queryCount, phi: PHI, ts: Date.now(),
    }), { headers: cors });
  }

  if (path === '/airports' && request.method === 'GET') {
    const list = Object.entries(LOUNGES).map(([code, ls]) => ({ code, lounges: ls.length }));
    return new Response(JSON.stringify({ botId: BOT_ID, airports: list }), { headers: cors });
  }

  if (path === '/access' && request.method === 'GET') {
    const airport = (url.searchParams.get('airport') || '').toUpperCase();
    const token   = url.searchParams.get('token') || '';
    if (!airport) return new Response(JSON.stringify({ error: 'airport param required', botId: BOT_ID }), { status: 400, headers: cors });

    const tokenResult = await verifyToken(token, env);
    const tier        = tokenResult.ok ? tokenResult.tier : 1;
    const accessible  = getLoungesForTier(airport, tier);

    beatCount++;
    queryCount++;
    return new Response(JSON.stringify({
      botId:      BOT_ID,
      airport,
      tier,
      symbol:     tokenResult.symbol || 'CHR',
      label:      tokenResult.label  || 'Basic',
      accessible,
      count:      accessible.length,
      phi:        PHI,
      ts:         Date.now(),
    }), { headers: cors });
  }

  if (path === '/lounge' && request.method === 'GET') {
    const airport = (url.searchParams.get('airport') || '').toUpperCase();
    const name    = url.searchParams.get('name')    || '';
    if (!airport || !name) return new Response(JSON.stringify({ error: 'airport and name params required', botId: BOT_ID }), { status: 400, headers: cors });

    const all    = LOUNGES[airport] || [];
    const lounge = all.find(l => l.name.toLowerCase().includes(name.toLowerCase()));
    if (!lounge) return new Response(JSON.stringify({ error: `Lounge "${name}" not found at ${airport}`, botId: BOT_ID }), { status: 404, headers: cors });

    beatCount++;
    queryCount++;
    return new Response(JSON.stringify({ botId: BOT_ID, ...lounge, ACCESS_TIERS }), { headers: cors });
  }

  return new Response(JSON.stringify({ error: 'not_found', botId: BOT_ID }), { status: 404, headers: cors });
}

addEventListener('fetch', event => event.respondWith(handleRequest(event.request, event.env ?? {})));
