/**
 * telegram.js — Telegram Bot API Helper
 * (Latin: "Nuntius Telegraphicus")
 *
 * Lightweight helper for sending messages via the Telegram Bot API
 * from any Cloudflare Worker in the organism/bots fleet.
 *
 * Environment variables required (Cloudflare Worker secrets):
 *   TELEGRAM_BOT_TOKEN — from @BotFather: "123456:ABC-..."
 *   TELEGRAM_CHAT_ID   — target chat/channel ID (e.g. your personal DM ID)
 *
 * Usage:
 *   import { sendTelegram } from './shared/telegram.js';
 *   await sendTelegram('Hello from VIGIL 🛰️', env);
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

const TELEGRAM_API = 'https://api.telegram.org';

/**
 * Send a plain-text or Markdown message to a Telegram chat.
 *
 * @param {string} text         — message body (Markdown V2 supported)
 * @param {object} env          — Cloudflare Worker env bindings
 * @param {object} [opts]       — optional overrides
 * @param {string} [opts.chatId]       — override default chat ID
 * @param {string} [opts.parseMode]    — 'MarkdownV2' | 'HTML' | '' (default: 'MarkdownV2')
 * @param {boolean} [opts.silent]      — send without notification sound
 * @returns {Promise<{ ok: boolean, result?: object, error?: string }>}
 */
export async function sendTelegram(text, env, opts = {}) {
  const token  = env?.TELEGRAM_BOT_TOKEN;
  const chatId = opts.chatId || env?.TELEGRAM_CHAT_ID;

  if (!token || !chatId) {
    return { ok: false, error: 'TELEGRAM_BOT_TOKEN or TELEGRAM_CHAT_ID not configured' };
  }

  const payload = {
    chat_id:              chatId,
    text:                 text.slice(0, 4096),
    parse_mode:           opts.parseMode ?? 'MarkdownV2',
    disable_notification: opts.silent ?? false,
  };

  try {
    const res  = await fetch(`${TELEGRAM_API}/bot${token}/sendMessage`, {
      method:  'POST',
      headers: { 'Content-Type': 'application/json' },
      body:    JSON.stringify(payload),
    });
    const data = await res.json();
    return data.ok
      ? { ok: true, result: data.result }
      : { ok: false, error: data.description || 'telegram_error' };
  } catch (err) {
    return { ok: false, error: err.message || 'fetch_error' };
  }
}

/**
 * Escape a string for Telegram MarkdownV2 format.
 * Telegram requires these characters to be escaped: _ * [ ] ( ) ~ ` > # + - = | { } . !
 *
 * @param {string} text
 * @returns {string}
 */
export function escapeMd(text) {
  return String(text).replace(/[_*[\]()~`>#+\-=|{}.!]/g, '\\$&');
}

/**
 * Build a formatted organism status message for Telegram.
 *
 * @param {string} title
 * @param {object} fields  — key-value pairs to display
 * @param {string} [footer]
 * @returns {string}       — MarkdownV2 formatted string
 */
export function buildStatusMessage(title, fields, footer = '') {
  const lines = [`*${escapeMd(title)}*`, ''];
  for (const [key, val] of Object.entries(fields)) {
    lines.push(`• *${escapeMd(key)}:* ${escapeMd(String(val))}`);
  }
  if (footer) {
    lines.push('');
    lines.push(`_${escapeMd(footer)}_`);
  }
  return lines.join('\n');
}
