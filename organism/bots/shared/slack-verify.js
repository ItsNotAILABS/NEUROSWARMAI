/**
 * slack-verify.js — Slack Request Signature Verification
 * (Latin: "Verificatio Signaturae Slacki")
 *
 * Verifies Slack's HMAC-SHA256 request signature so that no untrusted
 * party can spoof slash commands or events. Uses the Web Crypto API
 * available in Cloudflare Workers — no external dependencies required.
 *
 * Reference: https://api.slack.com/authentication/verifying-requests-from-slack
 *
 * Usage:
 *   import { verifySlackRequest } from './shared/slack-verify.js';
 *   const ok = await verifySlackRequest(request, env.SLACK_SIGNING_SECRET);
 *   if (!ok) return new Response('Forbidden', { status: 403 });
 *
 * Environment variable required (Cloudflare Worker secret):
 *   SLACK_SIGNING_SECRET — from your Slack App's "Basic Information" page
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

/**
 * Verify an inbound Slack request.
 *
 * @param {Request} request         — the raw Cloudflare Worker Request
 * @param {string}  signingSecret   — SLACK_SIGNING_SECRET from env
 * @returns {Promise<boolean>}
 */
export async function verifySlackRequest(request, signingSecret) {
  if (!signingSecret) return false;

  const timestamp = request.headers.get('x-slack-request-timestamp');
  const slackSig  = request.headers.get('x-slack-signature');

  if (!timestamp || !slackSig) return false;

  // Reject requests older than 5 minutes to prevent replay attacks
  const now = Math.floor(Date.now() / 1000);
  if (Math.abs(now - parseInt(timestamp, 10)) > 300) return false;

  const rawBody    = await request.text();
  const baseString = `v0:${timestamp}:${rawBody}`;

  const encoder  = new TextEncoder();
  const keyData  = encoder.encode(signingSecret);
  const msgData  = encoder.encode(baseString);

  const cryptoKey = await crypto.subtle.importKey(
    'raw', keyData, { name: 'HMAC', hash: 'SHA-256' }, false, ['sign']
  );

  const sigBuffer = await crypto.subtle.sign('HMAC', cryptoKey, msgData);
  const sigHex    = 'v0=' + Array.from(new Uint8Array(sigBuffer))
    .map(b => b.toString(16).padStart(2, '0'))
    .join('');

  // Constant-time comparison (prevents timing attacks)
  return timingSafeEqual(sigHex, slackSig);
}

/**
 * Constant-time string comparison to prevent timing side-channel attacks.
 *
 * @param {string} a
 * @param {string} b
 * @returns {boolean}
 */
function timingSafeEqual(a, b) {
  if (a.length !== b.length) return false;
  let diff = 0;
  for (let i = 0; i < a.length; i++) {
    diff |= a.charCodeAt(i) ^ b.charCodeAt(i);
  }
  return diff === 0;
}

/**
 * Parse a Slack slash command body (application/x-www-form-urlencoded).
 *
 * @param {string} rawBody
 * @returns {Record<string, string>}
 */
export function parseSlackBody(rawBody) {
  const params = new URLSearchParams(rawBody);
  const result = {};
  for (const [k, v] of params.entries()) result[k] = v;
  return result;
}

/**
 * Build a Slack Block Kit response payload.
 *
 * @param {string} text       — main message text
 * @param {string} [emoji]    — leading emoji (default ⚡)
 * @param {string} [context]  — optional context line (muted footer)
 * @returns {object}          — Slack response_type: in_channel JSON
 */
export function slackResponse(text, emoji = '⚡', context = '') {
  const blocks = [
    {
      type: 'section',
      text: { type: 'mrkdwn', text: `${emoji} ${text}` },
    },
  ];

  if (context) {
    blocks.push({
      type: 'context',
      elements: [{ type: 'mrkdwn', text: context }],
    });
  }

  return {
    response_type: 'in_channel',
    blocks,
  };
}

/**
 * Build a Slack ephemeral (only-you) error response.
 *
 * @param {string} message
 * @returns {object}
 */
export function slackError(message) {
  return {
    response_type: 'ephemeral',
    text: `🔴 ${message}`,
  };
}
