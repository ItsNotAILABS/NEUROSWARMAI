/**
 * CHIMERIA Defense — Client Onboarding Flow
 * Copyright © 2024-2026 Alfredo Medina Hernandez. All Rights Reserved.
 */

import React, { useState } from 'react';

// ═══════════════════════════════════════════════════════════════════════════════
// TYPES
// ═══════════════════════════════════════════════════════════════════════════════

interface OnboardingData {
  organizationName: string;
  contactEmail: string;
  contactName: string;
  industry: string;
  companySize: string;
  primaryNeeds: string[];
  tier: string;
}

type OnboardingStep = 'register' | 'assessment' | 'plan' | 'signing' | 'provisioning' | 'complete';

// ═══════════════════════════════════════════════════════════════════════════════
// ONBOARDING COMPONENT
// ═══════════════════════════════════════════════════════════════════════════════

export function ChimeriaOnboarding() {
  const [step, setStep] = useState<OnboardingStep>('register');
  const [data, setData] = useState<OnboardingData>({
    organizationName: '',
    contactEmail: '',
    contactName: '',
    industry: 'healthcare',
    companySize: 'enterprise',
    primaryNeeds: [],
    tier: ''
  });

  function updateData(field: keyof OnboardingData, value: string | string[]) {
    setData(prev => ({ ...prev, [field]: value }));
  }

  function toggleNeed(need: string) {
    setData(prev => ({
      ...prev,
      primaryNeeds: prev.primaryNeeds.includes(need)
        ? prev.primaryNeeds.filter(n => n !== need)
        : [...prev.primaryNeeds, need]
    }));
  }

  // ─── STYLES ─────────────────────────────────────────────────────────────

  const containerStyle: React.CSSProperties = {
    maxWidth: '640px',
    margin: '0 auto',
    padding: '48px 32px',
    fontFamily: "'SF Mono', 'Fira Code', monospace",
    color: '#e0e0e0',
    background: '#0a0a0f',
    borderRadius: '12px',
    border: '1px solid #1a1a2e'
  };

  const headingStyle: React.CSSProperties = {
    fontSize: '1.5rem',
    fontWeight: 700,
    marginBottom: '8px',
    background: 'linear-gradient(135deg, #00ff88, #00ccff)',
    WebkitBackgroundClip: 'text',
    WebkitTextFillColor: 'transparent'
  };

  const subtitleStyle: React.CSSProperties = {
    color: '#888',
    fontSize: '0.85rem',
    marginBottom: '32px'
  };

  const inputStyle: React.CSSProperties = {
    width: '100%',
    padding: '12px 16px',
    background: '#12121a',
    border: '1px solid #1a1a2e',
    borderRadius: '6px',
    color: '#e0e0e0',
    fontFamily: 'inherit',
    fontSize: '0.9rem',
    marginBottom: '16px',
    outline: 'none'
  };

  const selectStyle: React.CSSProperties = {
    ...inputStyle,
    appearance: 'none' as const
  };

  const buttonStyle: React.CSSProperties = {
    width: '100%',
    padding: '14px',
    background: 'linear-gradient(135deg, #00ff88, #00ccff)',
    border: 'none',
    borderRadius: '6px',
    color: '#0a0a0f',
    fontWeight: 700,
    fontSize: '0.9rem',
    cursor: 'pointer',
    fontFamily: 'inherit',
    textTransform: 'uppercase',
    letterSpacing: '1px',
    marginTop: '24px'
  };

  const checkboxContainerStyle: React.CSSProperties = {
    display: 'grid',
    gridTemplateColumns: 'repeat(2, 1fr)',
    gap: '8px',
    marginBottom: '16px'
  };

  const checkboxStyle: React.CSSProperties = {
    padding: '10px 14px',
    background: '#12121a',
    border: '1px solid #1a1a2e',
    borderRadius: '6px',
    fontSize: '0.8rem',
    cursor: 'pointer',
    transition: 'all 0.2s'
  };

  const stepIndicatorStyle: React.CSSProperties = {
    display: 'flex',
    justifyContent: 'center',
    gap: '8px',
    marginBottom: '32px'
  };

  const steps: OnboardingStep[] = ['register', 'assessment', 'plan', 'signing', 'provisioning', 'complete'];
  const currentStepIndex = steps.indexOf(step);

  // ─── STEP RENDERS ─────────────────────────────────────────────────────────

  function renderStepIndicator() {
    return (
      <div style={stepIndicatorStyle}>
        {steps.map((s, i) => (
          <div key={s} style={{
            width: '10px',
            height: '10px',
            borderRadius: '50%',
            background: i <= currentStepIndex ? '#00ff88' : '#1a1a2e',
            boxShadow: i === currentStepIndex ? '0 0 8px #00ff88' : 'none'
          }} />
        ))}
      </div>
    );
  }

  function renderRegister() {
    return (
      <>
        <h2 style={headingStyle}>Request Access</h2>
        <p style={subtitleStyle}>Begin your CHIMERIA Defense onboarding</p>

        <label style={{ color: '#888', fontSize: '0.75rem', display: 'block', marginBottom: '4px' }}>
          Organization Name
        </label>
        <input
          style={inputStyle}
          value={data.organizationName}
          onChange={e => updateData('organizationName', e.target.value)}
          placeholder="MedTech Corp"
        />

        <label style={{ color: '#888', fontSize: '0.75rem', display: 'block', marginBottom: '4px' }}>
          Contact Name
        </label>
        <input
          style={inputStyle}
          value={data.contactName}
          onChange={e => updateData('contactName', e.target.value)}
          placeholder="Dr. Sarah Chen"
        />

        <label style={{ color: '#888', fontSize: '0.75rem', display: 'block', marginBottom: '4px' }}>
          Email
        </label>
        <input
          style={inputStyle}
          type="email"
          value={data.contactEmail}
          onChange={e => updateData('contactEmail', e.target.value)}
          placeholder="sarah@medtech.com"
        />

        <label style={{ color: '#888', fontSize: '0.75rem', display: 'block', marginBottom: '4px' }}>
          Industry
        </label>
        <select
          style={selectStyle}
          value={data.industry}
          onChange={e => updateData('industry', e.target.value)}
        >
          <option value="healthcare">Healthcare</option>
          <option value="financial">Financial Services</option>
          <option value="government">Government / Defense</option>
          <option value="technology">Technology</option>
          <option value="pharmaceutical">Pharmaceutical</option>
          <option value="insurance">Insurance</option>
          <option value="other">Other</option>
        </select>

        <label style={{ color: '#888', fontSize: '0.75rem', display: 'block', marginBottom: '4px' }}>
          Organization Size
        </label>
        <select
          style={selectStyle}
          value={data.companySize}
          onChange={e => updateData('companySize', e.target.value)}
        >
          <option value="startup">Startup (1-50)</option>
          <option value="mid">Mid-Market (51-500)</option>
          <option value="enterprise">Enterprise (500+)</option>
          <option value="government">Government Agency</option>
        </select>

        <button style={buttonStyle} onClick={() => setStep('assessment')}>
          Continue → Security Assessment
        </button>
      </>
    );
  }

  function renderAssessment() {
    const needs = ['HIPAA', 'SOC2', 'FedRAMP', 'ITAR', 'PHI Protection', 'Network Defense',
      'Device Security', 'Threat Intel', 'Incident Response', 'Compliance Audit'];

    return (
      <>
        <h2 style={headingStyle}>Security Assessment</h2>
        <p style={subtitleStyle}>Select your compliance and defense requirements</p>

        <label style={{ color: '#888', fontSize: '0.75rem', display: 'block', marginBottom: '8px' }}>
          Primary Security Needs (select all that apply)
        </label>
        <div style={checkboxContainerStyle}>
          {needs.map(need => (
            <div
              key={need}
              style={{
                ...checkboxStyle,
                borderColor: data.primaryNeeds.includes(need) ? '#00ff88' : '#1a1a2e',
                background: data.primaryNeeds.includes(need) ? 'rgba(0,255,136,0.1)' : '#12121a',
                color: data.primaryNeeds.includes(need) ? '#00ff88' : '#888'
              }}
              onClick={() => toggleNeed(need)}
            >
              {data.primaryNeeds.includes(need) ? '✓ ' : '○ '}{need}
            </div>
          ))}
        </div>

        <button style={buttonStyle} onClick={() => setStep('plan')}>
          Continue → Recommended Plan
        </button>
      </>
    );
  }

  function renderPlan() {
    // Determine recommended tier based on needs
    const needsCount = data.primaryNeeds.length;
    const recommended = needsCount >= 6 ? 'ENTERPRISE' : needsCount >= 3 ? 'PROFESSIONAL' : 'STARTER';

    const plans = [
      { id: 'STARTER', name: 'Starter', price: '$499/mo', agents: 3, sandboxes: 3, highlight: recommended === 'STARTER' },
      { id: 'PROFESSIONAL', name: 'Professional', price: '$2,499/mo', agents: 6, sandboxes: 8, highlight: recommended === 'PROFESSIONAL' },
      { id: 'ENTERPRISE', name: 'Enterprise', price: '$9,999/mo', agents: 10, sandboxes: 24, highlight: recommended === 'ENTERPRISE' }
    ];

    return (
      <>
        <h2 style={headingStyle}>Recommended Plan</h2>
        <p style={subtitleStyle}>
          Based on your assessment, we recommend: <strong style={{ color: '#00ff88' }}>{recommended}</strong>
        </p>

        <div style={{ display: 'flex', flexDirection: 'column', gap: '12px', marginBottom: '24px' }}>
          {plans.map(plan => (
            <div
              key={plan.id}
              onClick={() => updateData('tier', plan.id)}
              style={{
                padding: '16px',
                background: '#12121a',
                border: `1px solid ${data.tier === plan.id ? '#00ff88' : plan.highlight ? '#00ccff' : '#1a1a2e'}`,
                borderRadius: '8px',
                cursor: 'pointer',
                display: 'flex',
                justifyContent: 'space-between',
                alignItems: 'center'
              }}
            >
              <div>
                <div style={{ fontWeight: 700, color: data.tier === plan.id ? '#00ff88' : '#e0e0e0' }}>
                  {plan.name} {plan.highlight && data.tier !== plan.id ? '← RECOMMENDED' : ''}
                </div>
                <div style={{ fontSize: '0.75rem', color: '#888', marginTop: '4px' }}>
                  {plan.agents} agents • {plan.sandboxes} sandboxes
                </div>
              </div>
              <div style={{ fontWeight: 700, color: '#00ccff' }}>{plan.price}</div>
            </div>
          ))}
        </div>

        <button
          style={{ ...buttonStyle, opacity: data.tier ? 1 : 0.5 }}
          onClick={() => data.tier && setStep('signing')}
          disabled={!data.tier}
        >
          Continue → Service Agreement
        </button>
      </>
    );
  }

  function renderSigning() {
    return (
      <>
        <h2 style={headingStyle}>Service Agreement</h2>
        <p style={subtitleStyle}>Review and sign your CHIMERIA Defense contract</p>

        <div style={{ background: '#12121a', border: '1px solid #1a1a2e', borderRadius: '8px', padding: '20px', marginBottom: '24px' }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '12px' }}>
            <span style={{ color: '#888' }}>Organization:</span>
            <span>{data.organizationName || 'N/A'}</span>
          </div>
          <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '12px' }}>
            <span style={{ color: '#888' }}>Plan:</span>
            <span style={{ color: '#00ff88' }}>{data.tier}</span>
          </div>
          <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '12px' }}>
            <span style={{ color: '#888' }}>Compliance:</span>
            <span>{data.primaryNeeds.join(', ') || 'Standard'}</span>
          </div>
          <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '12px' }}>
            <span style={{ color: '#888' }}>SLA:</span>
            <span>99.99% uptime</span>
          </div>
          <div style={{ display: 'flex', justifyContent: 'space-between' }}>
            <span style={{ color: '#888' }}>Data Residency:</span>
            <span>US Sovereign</span>
          </div>
        </div>

        <div style={{ fontSize: '0.75rem', color: '#888', marginBottom: '16px', lineHeight: '1.6' }}>
          By signing, you agree to the CHIMERIA Defense Systems Terms of Service,
          Data Processing Agreement, and Business Associate Agreement (BAA).
          Your data will be processed in accordance with HIPAA, SOC2, and applicable regulations.
        </div>

        <button style={buttonStyle} onClick={() => setStep('provisioning')}>
          Sign Electronically & Activate
        </button>
      </>
    );
  }

  function renderProvisioning() {
    // Simulate provisioning with auto-advance
    React.useEffect(() => {
      const timer = setTimeout(() => setStep('complete'), 3000);
      return () => clearTimeout(timer);
    }, []);

    return (
      <>
        <h2 style={headingStyle}>Provisioning Environment</h2>
        <p style={subtitleStyle}>Setting up your sovereign defense infrastructure...</p>

        <div style={{ display: 'flex', flexDirection: 'column', gap: '12px' }}>
          {[
            'Spinning up dedicated sandbox cluster...',
            'Initializing 10 AI defense agents...',
            'Configuring compliance engine (481 controls)...',
            'Generating API keys...',
            'Activating terminal access...',
            'Running first health check...'
          ].map((task, i) => (
            <div key={i} style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
              <span style={{ color: '#00ff88' }}>✓</span>
              <span style={{ color: '#888', fontSize: '0.85rem' }}>{task}</span>
            </div>
          ))}
        </div>

        <div style={{ marginTop: '32px', textAlign: 'center', color: '#00ccff', fontSize: '0.85rem' }}>
          Estimated time remaining: ~90 seconds
        </div>
      </>
    );
  }

  function renderComplete() {
    return (
      <>
        <h2 style={headingStyle}>✓ Environment Ready</h2>
        <p style={subtitleStyle}>Your CHIMERIA Defense platform is fully operational</p>

        <div style={{ background: '#12121a', border: '1px solid #00ff88', borderRadius: '8px', padding: '20px', marginBottom: '24px' }}>
          <div style={{ color: '#00ff88', fontWeight: 700, marginBottom: '12px' }}>ACCESS CREDENTIALS</div>
          <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '8px' }}>
            <span style={{ color: '#888' }}>Terminal:</span>
            <span style={{ fontFamily: 'monospace' }}>app.chimeria.defense</span>
          </div>
          <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '8px' }}>
            <span style={{ color: '#888' }}>API Gateway:</span>
            <span style={{ fontFamily: 'monospace' }}>api.chimeria.defense/v1/</span>
          </div>
          <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '8px' }}>
            <span style={{ color: '#888' }}>API Key:</span>
            <span style={{ fontFamily: 'monospace', color: '#00ccff' }}>chm_live_••••••••••••</span>
          </div>
          <div style={{ display: 'flex', justifyContent: 'space-between' }}>
            <span style={{ color: '#888' }}>Status:</span>
            <span style={{ color: '#00ff88' }}>● FULL OPERATIONAL</span>
          </div>
        </div>

        <button style={buttonStyle} onClick={() => window.location.href = '/terminal'}>
          Launch Command Terminal →
        </button>
      </>
    );
  }

  // ─── MAIN RENDER ──────────────────────────────────────────────────────────

  return (
    <div style={containerStyle}>
      {renderStepIndicator()}
      {step === 'register' && renderRegister()}
      {step === 'assessment' && renderAssessment()}
      {step === 'plan' && renderPlan()}
      {step === 'signing' && renderSigning()}
      {step === 'provisioning' && renderProvisioning()}
      {step === 'complete' && renderComplete()}
    </div>
  );
}

export default ChimeriaOnboarding;
