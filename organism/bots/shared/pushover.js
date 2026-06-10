/**
 * pushover.js — Pushover Notification Helper
 * (Latin: "Nuntius Urgentis")
 *
 * Sends push notifications via the Pushover API to any device
 * (iOS, Android, desktop) that has the Pushover app installed.
 * Zero platform lock-in — one API call, universal delivery.
 *
 * Environment variables required (Cloudflare Worker secrets):
 *   PUSHOVER_APP_TOKEN  — from pushover.net/apps
 *   PUSHOVER_USER_KEY   — your Pushover user/group key
 *
 * Usage:
 *   import { sendPushover } from './shared/pushover.js';
 *   await sendPushover('Deploy complete ✅', 'MERIDIANUS', env);
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

const PUSHOVER_API = 'https://api.pushover.net/1/messages.json';

// Pushover priority levels
export const PRIORITY = {
  LOWEST:  -2,   // no notification
  LOW:     -1,   // quiet
  NORMAL:   0,   // normal
  HIGH:     1,   // high-priority, bypass quiet hours
  EMERGENCY: 2,  // repeat until acknowledged (requires retry + expire)
};

// Pushover sound identifiers
export const SOUND = {
  DEFAULT:     '',
  PUSHOVER:    'pushover',
  BIKE:        'bike',
  BUGLE:       'bugle',
  CASHREGISTER:'cashregister',
  CLASSICAL:   'classical',
  COSMIC:      'cosmic',
  FALLING:     'falling',
  GAMELAN:     'gamelan',
  INCOMING:    'incoming',
  INTERMISSION:'intermission',
  MAGIC:       'magic',
  MECHANICAL:  'mechanical',
  PIANOBAR:    'pianobar',
  SIREN:       'siren',
  SPACEALARM:  'spacealarm',
  TUGBOAT:     'tugboat',
  ALIEN:       'alien',
  CLIMB:       'climb',
  PERSISTENT:  'persistent',
  ECHO:        'echo',
  UPDOWN:      'updown',
  VIBRATE:     'vibrate',
  NONE:        'none',
};

/**
 * Send a push notification via Pushover.
 *
 * @param {string} message        — notification body (max 1,024 characters)
 * @param {string} title          — notification title (max 250 characters)
 * @param {object} env            — Cloudflare Worker env bindings
 * @param {object} [opts]         — optional parameters
 * @param {number} [opts.priority]    — PRIORITY constant (default: NORMAL)
 * @param {string} [opts.sound]       — SOUND constant (default: '')
 * @param {string} [opts.url]         — supplementary URL
 * @param {string} [opts.url_title]   — URL title
 * @param {number} [opts.retry]       — seconds between retries (EMERGENCY only, min 30)
 * @param {number} [opts.expire]      — seconds before giving up (EMERGENCY only, max 10800)
 * @returns {Promise<{ ok: boolean, request?: string, error?: string }>}
 */
export async function sendPushover(message, title, env, opts = {}) {
  const token   = env?.PUSHOVER_APP_TOKEN;
  const userKey = env?.PUSHOVER_USER_KEY;

  if (!token || !userKey) {
    return { ok: false, error: 'PUSHOVER_APP_TOKEN or PUSHOVER_USER_KEY not configured' };
  }

  const form = new URLSearchParams({
    token,
    user:     userKey,
    message:  message.slice(0, 1024),
    title:    (title || '').slice(0, 250),
    priority: String(opts.priority ?? PRIORITY.NORMAL),
  });

  if (opts.sound)     form.set('sound', opts.sound);
  if (opts.url)       form.set('url', opts.url.slice(0, 512));
  if (opts.url_title) form.set('url_title', opts.url_title.slice(0, 100));

  if (opts.priority === PRIORITY.EMERGENCY) {
    form.set('retry',  String(Math.max(opts.retry  ?? 60, 30)));
    form.set('expire', String(Math.min(opts.expire ?? 3600, 10800)));
  }

  try {
    const res  = await fetch(PUSHOVER_API, {
      method:  'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body:    form.toString(),
    });
    const data = await res.json();
    return data.status === 1
      ? { ok: true,  request: data.request }
      : { ok: false, error:   (data.errors || []).join(', ') || 'pushover_error' };
  } catch (err) {
    return { ok: false, error: err.message || 'fetch_error' };
  }
}
