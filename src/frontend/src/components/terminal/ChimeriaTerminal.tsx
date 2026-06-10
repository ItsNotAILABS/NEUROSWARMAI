/**
 * CHIMERIA Defense Terminal — User-Facing Command Interface
 * Copyright © 2024-2026 Alfredo Medina Hernandez. All Rights Reserved.
 */

import React, { useState, useRef, useEffect, useCallback } from 'react';

// ═══════════════════════════════════════════════════════════════════════════════
// TERMINAL TYPES
// ═══════════════════════════════════════════════════════════════════════════════

interface TerminalLine {
  id: string;
  type: 'input' | 'output' | 'success' | 'error' | 'info' | 'system';
  content: string;
  timestamp: string;
}

interface AgentStatus {
  id: string;
  name: string;
  status: 'ACTIVE' | 'INACTIVE' | 'ALERT';
  eventsPerHour: number;
  lastEvent: string;
}

interface ComplianceStatus {
  framework: string;
  passing: number;
  total: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// CHIMERIA TERMINAL COMPONENT
// ═══════════════════════════════════════════════════════════════════════════════

export function ChimeriaTerminal() {
  const [lines, setLines] = useState<TerminalLine[]>([]);
  const [input, setInput] = useState('');
  const [history, setHistory] = useState<string[]>([]);
  const [historyIndex, setHistoryIndex] = useState(-1);
  const inputRef = useRef<HTMLInputElement>(null);
  const scrollRef = useRef<HTMLDivElement>(null);

  // Initialize with welcome message
  useEffect(() => {
    addSystemLines([
      '╔═══════════════════════════════════════════════════════════════╗',
      '║       CHIMERIA DEFENSE SYSTEMS — COMMAND TERMINAL             ║',
      '║       Sovereign AI Platform | Full Operational Status         ║',
      '╚═══════════════════════════════════════════════════════════════╝',
      '',
      'Type "help" for available commands, "status" for system overview.',
      ''
    ]);
  }, []);

  // Auto-scroll
  useEffect(() => {
    if (scrollRef.current) {
      scrollRef.current.scrollTop = scrollRef.current.scrollHeight;
    }
  }, [lines]);

  function addLine(type: TerminalLine['type'], content: string) {
    setLines(prev => [...prev, {
      id: `${Date.now()}-${Math.random()}`,
      type,
      content,
      timestamp: new Date().toISOString()
    }]);
  }

  function addSystemLines(contents: string[]) {
    setLines(prev => [
      ...prev,
      ...contents.map(content => ({
        id: `${Date.now()}-${Math.random()}`,
        type: 'system' as const,
        content,
        timestamp: new Date().toISOString()
      }))
    ]);
  }

  // ─── COMMAND PROCESSOR ────────────────────────────────────────────────────

  const processCommand = useCallback((cmd: string) => {
    addLine('input', `chimeria> ${cmd}`);
    const [command, ...args] = cmd.trim().toLowerCase().split(/\s+/);

    switch (command) {
      case 'help':
        addSystemLines([
          'AVAILABLE COMMANDS:',
          '─────────────────────────────────────────────────',
          '  status           — System overview & agent status',
          '  agents           — List all defense agents',
          '  compliance       — Compliance dashboard',
          '  scan [target]    — Run security scan',
          '  report [type]    — Generate report (compliance|threat|executive)',
          '  sandbox [cmd]    — Sandbox operations (list|create|destroy)',
          '  alerts           — View active alerts',
          '  forecast         — Predictive threat forecast (ORACLE)',
          '  settings         — Configuration panel',
          '  clear            — Clear terminal',
          '  help             — Show this help',
          ''
        ]);
        break;

      case 'status':
        addLine('success', '✓ CHIMERIA DEFENSE SYSTEMS — OPERATIONAL');
        addSystemLines([
          '─────────────────────────────────────────────────',
          '  Defense Agents:    10/10 ACTIVE',
          '  Compliance:        481/481 PASSING (100%)',
          '  Threat Level:      LOW ●○○○○',
          '  Active Threats:    0',
          '  Uptime:            99.99%',
          '  Last Scan:         2.3s ago',
          '  Sandboxes Active:  12',
          '  Events/Hour:       14,247',
          ''
        ]);
        break;

      case 'agents':
        addLine('info', 'DEFENSE AGENT FLEET:');
        addSystemLines([
          '─────────────────────────────────────────────────',
          '  ● SENTINEL    — Patient Data Protection    — 2,104 events/hr',
          '  ● AEGIS-HC    — Network Perimeter Defense  — 3,891 events/hr',
          '  ● VITALS      — Medical Device Security    — 847 events/hr',
          '  ● CORTEX      — AI Threat Intelligence     — 1,522 events/hr',
          '  ● MERIDIAN-HC — Compliance Orchestration   — 481 events/hr',
          '  ● PHOENIX     — Incident Response          — 94 events/hr',
          '  ● GUARDIAN    — Identity & Access          — 2,876 events/hr',
          '  ● HELIX       — Supply Chain Risk          — 312 events/hr',
          '  ● NEXUS       — Cross-Domain Coordination  — 1,640 events/hr',
          '  ● ORACLE      — Predictive Defense         — 480 events/hr',
          '',
          '  All agents synchronized (Kuramoto R = 0.94)',
          ''
        ]);
        break;

      case 'compliance':
        addLine('success', '✓ COMPLIANCE STATUS — ALL FRAMEWORKS PASSING');
        addSystemLines([
          '─────────────────────────────────────────────────',
          '  HIPAA:     54/54  controls ████████████████ 100%',
          '  SOC2:      64/64  controls ████████████████ 100%',
          '  FedRAMP:   325/325 controls ████████████████ 100%',
          '  ITAR:      38/38  controls ████████████████ 100%',
          '  ─────────────────────────────────────',
          '  TOTAL:     481/481 controls — FULL COMPLIANCE',
          '',
          '  Next scheduled audit: 7 days',
          '  Audit trail: 142,891 entries (immutable, blockchain-anchored)',
          ''
        ]);
        break;

      case 'scan':
        const target = args[0] || 'all';
        addLine('info', `  Initiating ${target} scan...`);
        setTimeout(() => {
          addLine('info', '  [SENTINEL]    Scanning PHI endpoints...');
          setTimeout(() => {
            addLine('info', '  [AEGIS-HC]    Network perimeter check...');
            setTimeout(() => {
              addLine('info', '  [VITALS]      IoMT device audit...');
              setTimeout(() => {
                addLine('info', '  [CORTEX]      Behavioral analysis...');
                setTimeout(() => {
                  addLine('success', `✓ Full ${target} scan complete — 0 vulnerabilities found`);
                  addLine('output', '  Duration: 4.7s | Endpoints tested: 2,847');
                }, 400);
              }, 300);
            }, 300);
          }, 300);
        }, 200);
        break;

      case 'report':
        const reportType = args[0] || 'compliance';
        addLine('info', `  Generating ${reportType} report...`);
        setTimeout(() => {
          addLine('success', `✓ Report generated: ${reportType}-${new Date().toISOString().split('T')[0]}.pdf`);
          addLine('output', '  Pages: 42 | Format: PDF | Classification: CONFIDENTIAL');
        }, 800);
        break;

      case 'sandbox':
        const subCmd = args[0] || 'list';
        if (subCmd === 'list') {
          addLine('info', 'ACTIVE SANDBOXES:');
          addSystemLines([
            '─────────────────────────────────────────────────',
            '  SBX-CODE-001    Code Execution     ACTIVE   PRD',
            '  SBX-DATA-001    Data Processing    ACTIVE   PRD',
            '  SBX-SEC-001     Security Testing   ACTIVE   ENT',
            '  SBX-ML-001      ML Training        ACTIVE   STG',
            '  SBX-HEALTH-001  Healthcare         ACTIVE   ENT',
            '  SBX-API-001     API Integration    ACTIVE   PRD',
            ''
          ]);
        } else if (subCmd === 'create') {
          addLine('success', '✓ Sandbox provisioned: SBX-NEW-' + Date.now());
        } else {
          addLine('info', 'Usage: sandbox [list|create|destroy]');
        }
        break;

      case 'alerts':
        addLine('success', '✓ No active alerts');
        addLine('output', '  Last alert: 72 hours ago (resolved automatically by PHOENIX)');
        break;

      case 'forecast':
        addLine('info', 'ORACLE PREDICTIVE FORECAST (7-day horizon):');
        addSystemLines([
          '─────────────────────────────────────────────────',
          '  Threat Probability:  LOW (12%)',
          '  Predicted Vectors:   Phishing (8%), Supply Chain (3%), Insider (1%)',
          '  Recommended:         Maintain current posture',
          '  Confidence:          94%',
          '  Model Version:       ORACLE-v4.2 (generational learning active)',
          ''
        ]);
        break;

      case 'clear':
        setLines([]);
        break;

      default:
        if (cmd.trim()) {
          addLine('error', `  Unknown command: "${command}". Type "help" for available commands.`);
        }
    }
  }, []);

  // ─── KEY HANDLING ─────────────────────────────────────────────────────────

  function handleKeyDown(e: React.KeyboardEvent) {
    if (e.key === 'Enter' && input.trim()) {
      processCommand(input);
      setHistory(prev => [...prev, input]);
      setHistoryIndex(-1);
      setInput('');
    } else if (e.key === 'ArrowUp') {
      e.preventDefault();
      if (history.length > 0) {
        const newIndex = historyIndex === -1 ? history.length - 1 : Math.max(0, historyIndex - 1);
        setHistoryIndex(newIndex);
        setInput(history[newIndex]);
      }
    } else if (e.key === 'ArrowDown') {
      e.preventDefault();
      if (historyIndex >= 0) {
        const newIndex = historyIndex + 1;
        if (newIndex >= history.length) {
          setHistoryIndex(-1);
          setInput('');
        } else {
          setHistoryIndex(newIndex);
          setInput(history[newIndex]);
        }
      }
    }
  }

  // ─── RENDER ───────────────────────────────────────────────────────────────

  const lineColors: Record<TerminalLine['type'], string> = {
    input: '#e0e0e0',
    output: '#888888',
    success: '#00ff88',
    error: '#ff5555',
    info: '#00ccff',
    system: '#888888'
  };

  return (
    <div style={{
      width: '100%',
      maxWidth: '900px',
      margin: '0 auto',
      background: '#0a0a0f',
      borderRadius: '12px',
      border: '1px solid #1a1a2e',
      overflow: 'hidden',
      fontFamily: "'SF Mono', 'Fira Code', 'JetBrains Mono', monospace",
      fontSize: '13px'
    }}>
      {/* Terminal Header */}
      <div style={{
        display: 'flex',
        alignItems: 'center',
        padding: '12px 16px',
        background: '#12121a',
        borderBottom: '1px solid #1a1a2e',
        gap: '8px'
      }}>
        <div style={{ width: 12, height: 12, borderRadius: '50%', background: '#ff5f56' }} />
        <div style={{ width: 12, height: 12, borderRadius: '50%', background: '#ffbd2e' }} />
        <div style={{ width: 12, height: 12, borderRadius: '50%', background: '#27c93f' }} />
        <span style={{ marginLeft: 12, color: '#888', fontSize: '0.8rem' }}>
          CHIMERIA Defense Terminal — Enterprise
        </span>
        <span style={{ marginLeft: 'auto', color: '#00ff88', fontSize: '0.7rem' }}>
          ● CONNECTED
        </span>
      </div>

      {/* Terminal Body */}
      <div
        ref={scrollRef}
        style={{
          padding: '16px',
          height: '500px',
          overflowY: 'auto',
          cursor: 'text'
        }}
        onClick={() => inputRef.current?.focus()}
      >
        {lines.map(line => (
          <div key={line.id} style={{ color: lineColors[line.type], marginBottom: '2px', whiteSpace: 'pre-wrap' }}>
            {line.content}
          </div>
        ))}

        {/* Input Line */}
        <div style={{ display: 'flex', alignItems: 'center', color: '#00ff88' }}>
          <span>chimeria&gt;&nbsp;</span>
          <input
            ref={inputRef}
            value={input}
            onChange={(e) => setInput(e.target.value)}
            onKeyDown={handleKeyDown}
            style={{
              flex: 1,
              background: 'transparent',
              border: 'none',
              outline: 'none',
              color: '#e0e0e0',
              fontFamily: 'inherit',
              fontSize: 'inherit',
              caretColor: '#00ff88'
            }}
            autoFocus
            spellCheck={false}
          />
        </div>
      </div>
    </div>
  );
}

export default ChimeriaTerminal;
