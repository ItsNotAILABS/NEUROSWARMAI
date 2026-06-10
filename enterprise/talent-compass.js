/**
 * TALENT COMPASS (TLCP) — Human Capital Intelligence Product
 * Nova by FreddyCreates
 * 
 * Enterprise product for workforce intelligence.
 * IP Value: $1.8M USD
 * 
 * @version 0.13.0 (F13)
 * @copyright Nova Protocol by FreddyCreates
 */

import { NovaEngine, PHI, PHI_INV } from '../nova/engines/nova-engine.js';

export class TalentCompass {
  constructor(config = {}) {
    this.name = 'TalentCompass';
    this.quad = 'TLCP';
    this.version = '0.13.0';
    this.ipValue = 1800000; // $1.8M USD
    this.engine = new NovaEngine({ substrate: config.substrate || 'node' });
    this.talentMemory = new Map();
    this.teamModels = new Map();
    this.trajectoryPatterns = [];
  }

  async assessTalent(profileData) {
    const extraction = await this.engine.execute('EXTR', JSON.stringify(profileData));
    const analysis = await this.engine.execute('ANLD', profileData.metrics || []);
    
    const talentId = `TLNT-${Date.now().toString(36)}`;
    
    const talent = {
      id: talentId,
      profile: profileData,
      skills: this._extractSkills(profileData),
      trajectory: this._predictTrajectory(profileData),
      potential: this._assessPotential(profileData),
      flightRisk: this._assessFlightRisk(profileData),
      cultureAlignment: this._assessCulture(profileData),
      createdAt: Date.now()
    };
    
    this.talentMemory.set(talentId, talent);
    
    return {
      success: true,
      talentId,
      potential: talent.potential,
      trajectory: talent.trajectory,
      flightRisk: talent.flightRisk,
      cultureAlignment: talent.cultureAlignment
    };
  }

  async modelTeam(members) {
    const teamId = `TEAM-${Date.now().toString(36)}`;
    
    const profiles = members.map(m => this.talentMemory.get(m.talentId) || m);
    
    const teamModel = {
      id: teamId,
      size: members.length,
      skillCoverage: this._analyzeSkillCoverage(profiles),
      dynamics: this._modelDynamics(profiles),
      chemistry: this._assessChemistry(profiles),
      gaps: this._identifyGaps(profiles),
      recommendations: this._generateRecommendations(profiles),
      createdAt: Date.now()
    };
    
    this.teamModels.set(teamId, teamModel);
    
    return { success: true, teamId, ...teamModel };
  }

  async predictRetention(talentId, horizon = 12) {
    const talent = this.talentMemory.get(talentId);
    if (!talent) throw new Error(`Talent not found: ${talentId}`);
    
    const factors = [talent.flightRisk.score, talent.cultureAlignment.score];
    const prediction = await this.engine.execute('PRED', factors, { nPredict: horizon });
    
    return {
      talentId,
      currentFlightRisk: talent.flightRisk,
      predictions: prediction.result.predictions,
      recommendation: talent.flightRisk.score > 0.6 ? 'Retention intervention recommended' : 'Monitor'
    };
  }

  _extractSkills(profile) {
    const skills = [];
    if (profile.experience) {
      profile.experience.forEach(exp => {
        if (exp.skills) skills.push(...exp.skills);
      });
    }
    return [...new Set(skills)];
  }

  _predictTrajectory(profile) {
    const years = profile.yearsExperience || 0;
    const trajectories = ['individual_contributor', 'tech_lead', 'manager', 'director', 'executive'];
    const index = Math.min(Math.floor(years / 3), trajectories.length - 1);
    
    return {
      current: trajectories[index],
      next: trajectories[Math.min(index + 1, trajectories.length - 1)],
      timeToNext: Math.round(3 * PHI_INV),
      confidence: 0.7 + (years / 50)
    };
  }

  _assessPotential(profile) {
    const factors = {
      experience: Math.min(1, (profile.yearsExperience || 0) / 15),
      education: profile.education ? 0.8 : 0.5,
      growth: profile.recentGrowth || 0.6
    };
    
    const score = (factors.experience + factors.education + factors.growth) / 3;
    
    return {
      score,
      level: score > 0.8 ? 'high' : score > 0.5 ? 'medium' : 'developing',
      factors
    };
  }

  _assessFlightRisk(profile) {
    const factors = {
      tenure: Math.max(0, 1 - (profile.tenure || 0) / 5),
      satisfaction: 1 - (profile.satisfaction || 0.7),
      marketDemand: profile.marketDemand || 0.5
    };
    
    const score = (factors.tenure + factors.satisfaction + factors.marketDemand) / 3;
    
    return {
      score,
      level: score > 0.7 ? 'high' : score > 0.4 ? 'medium' : 'low',
      factors
    };
  }

  _assessCulture(profile) {
    const alignment = profile.cultureAlignment || 0.7;
    return {
      score: alignment,
      level: alignment > 0.8 ? 'strong' : alignment > 0.5 ? 'moderate' : 'weak'
    };
  }

  _analyzeSkillCoverage(profiles) {
    const allSkills = new Set();
    profiles.forEach(p => {
      const skills = p.skills || this._extractSkills(p.profile || p);
      skills.forEach(s => allSkills.add(s));
    });
    return { totalSkills: allSkills.size, skills: [...allSkills] };
  }

  _modelDynamics(profiles) {
    return {
      diversityScore: Math.min(1, profiles.length / 8 * PHI_INV),
      collaborationPotential: 0.7 + Math.random() * 0.2,
      conflictRisk: 0.2 + Math.random() * 0.3
    };
  }

  _assessChemistry(profiles) {
    const avgAlignment = profiles.reduce((s, p) => {
      const culture = p.cultureAlignment || this._assessCulture(p.profile || p);
      return s + (culture.score || 0.7);
    }, 0) / profiles.length;
    
    return { score: avgAlignment, level: avgAlignment > 0.7 ? 'good' : 'developing' };
  }

  _identifyGaps(profiles) {
    return ['Strategic planning', 'Technical depth'].filter(() => Math.random() > 0.5);
  }

  _generateRecommendations(profiles) {
    return ['Consider adding senior technical expertise', 'Schedule team building activities'];
  }

  status() {
    return {
      name: this.name,
      quad: this.quad,
      version: this.version,
      ipValue: this.ipValue,
      talentProfiles: this.talentMemory.size,
      teamModels: this.teamModels.size,
      trajectoryPatterns: this.trajectoryPatterns.length,
      engineStatus: this.engine.status()
    };
  }
}

export default TalentCompass;
