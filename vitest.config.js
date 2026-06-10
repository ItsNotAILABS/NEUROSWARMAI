/**
 * Vitest Configuration
 * Test framework configuration for the command-platform
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 */

import { defineConfig } from 'vitest/config';

export default defineConfig({
  test: {
    globals: true,
    environment: 'node',
    include: ['tests/**/*.test.js'],
    coverage: {
      provider: 'v8',
      reporter: ['text', 'json', 'html'],
      include: [
        'protocols/**/*.js',
        'sdk/**/*.js',
        'organism/**/*.js',
        'governance/**/*.js',
      ],
      exclude: [
        'node_modules/**',
        'tests/**',
        'dist/**',
      ],
    },
    testTimeout: 10000,
    hookTimeout: 10000,
  },
});
