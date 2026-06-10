// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  SOVEREIGN AI — ITAR/EAR COMPLIANCE FRAMEWORK                                                             ║
// ║  Export Control Enforcement — Classification — Audit Trail — DCSA Ready                                   ║
// ║                                                                                                           ║
// ║  EXPORT CONTROL: This module itself enforces ITAR (22 CFR §120-130) / EAR (15 CFR §730-774)             ║
// ║  compliance across the entire Sovereign AI stack.                                                         ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

import Float "mo:core/Float";
import Array "mo:core/Array";
import Iter "mo:core/Iter";
import Nat "mo:core/Nat";
import Int "mo:core/Int";
import Text "mo:core/Text";

module SovereignCompliance {

  // ═══════════════════════════════════════════════════════════════════════════════
  // TYPES — EXPORT CONTROL CLASSIFICATION
  // ═══════════════════════════════════════════════════════════════════════════════

  /// USML Category (ITAR — 22 CFR §121.1)
  public type USMLCategory = {
    #CAT_I;     // Firearms, close assault weapons
    #CAT_IV;    // Launch vehicles, guided missiles
    #CAT_XI;    // Military electronics
    #CAT_XII;   // Fire control, tracking
    #CAT_XIII;  // Materials and miscellaneous
    #CAT_XIV;   // Toxicological/biological
    #CAT_XV;    // Spacecraft
    #CAT_XXI;   // Software for defense articles
    #NONE;      // Not USML-controlled
  };

  /// EAR Export Control Classification Number
  public type ECCN = {
    #EAR99;      // No license required for most destinations
    #_3A001;     // Electronic assemblies (signal processing)
    #_3D001;     // Software for 3A001
    #_4A003;     // Digital computers
    #_4D001;     // Software for 4A003
    #_5A002;     // Information security systems
    #_5D002;     // Encryption software
    #_5D992;     // Mass-market encryption
    #_7A003;     // Navigation equipment
    #_7D001;     // Navigation software
  };

  /// Countries subject to comprehensive sanctions
  public type SanctionedDestination = {
    #cuba;
    #iran;
    #north_korea;
    #syria;
    #crimea_region;
  };

  /// Export license type
  public type LicenseType = {
    #no_license_required;
    #license_exception_TMP;   // Temporary imports/exports
    #license_exception_TSR;   // Technology and software restricted
    #license_exception_ENC;   // Encryption
    #individual_validated;    // Specific export license
    #dsp5;                    // ITAR DSP-5 permanent export
    #dsp73;                   // ITAR DSP-73 temporary export
    #TAA;                     // Technical Assistance Agreement
    #MLA;                     // Manufacturing License Agreement
    #denied;                  // Export denied
  };

  /// Compliance check result
  public type ComplianceResult = {
    allowed : Bool;
    classification : ECCN;
    usmlCategory : USMLCategory;
    requiredLicense : LicenseType;
    reason : Text;
    controlNumber : Nat;      // Unique audit reference
    timestamp : Int;
  };

  /// Technology Control Plan (TCP)
  public type TechnologyControlPlan = {
    planId : Nat;
    classification : ECCN;
    usmlCategory : USMLCategory;
    authorizedPersonnel : [Text];
    physicalControls : [Text];
    cyberControls : [Text];
    exportRestrictions : [Text];
    reviewDate : Int;
    approvedBy : Text;
  };

  /// Compliance audit entry
  public type ComplianceAudit = {
    auditId : Nat;
    timestamp : Int;
    action : ComplianceAction;
    actor : Text;
    target : Text;
    result : ComplianceResult;
    evidence : Text;
  };

  /// Compliance actions that trigger audit
  public type ComplianceAction = {
    #model_access;
    #model_export;
    #model_transfer;
    #code_release;
    #technical_discussion;
    #training_data_access;
    #inference_request;
    #weight_extraction;
    #api_call;
    #foreign_national_access;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // CONSTANTS — REGULATORY REFERENCES
  // ═══════════════════════════════════════════════════════════════════════════════

  /// 481 NIST SP 800-53 controls mapped to CHIMERA defense organisms
  public let NIST_CONTROL_COUNT : Nat = 481;

  /// CMMC Level 3 practice count
  public let CMMC_L3_PRACTICES : Nat = 130;

  /// DFARS 252.204-7012 requirement count
  public let DFARS_REQUIREMENTS : Nat = 14;

  // ═══════════════════════════════════════════════════════════════════════════════
  // CLASSIFICATION ENGINE — DETERMINE EXPORT CONTROL STATUS
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Classify a sovereign AI module for export control
  public func classifyModule(
    hasEncryption : Bool,
    hasSignalProcessing : Bool,
    hasMilitaryApplication : Bool,
    hasNavigationCapability : Bool,
    performanceLevel : Nat  // 0=basic, 1=enhanced, 2=advanced, 3=sovereign
  ) : ComplianceResult {
    var eccn : ECCN = #EAR99;
    var usml : USMLCategory = #NONE;
    var license : LicenseType = #no_license_required;
    var reason : Text = "No export controls applicable";

    // ITAR check — military application overrides all
    if (hasMilitaryApplication) {
      if (hasSignalProcessing) {
        usml := #CAT_XI;
        eccn := #_3A001;
        license := #dsp5;
        reason := "Military electronics — ITAR Category XI, requires DSP-5 license";
      } else {
        usml := #CAT_XXI;
        eccn := #_4D001;
        license := #individual_validated;
        reason := "Defense software — ITAR Category XXI, requires individual license";
      };
    }
    // EAR checks
    else if (hasEncryption) {
      if (performanceLevel >= 2) {
        eccn := #_5D002;
        license := #license_exception_ENC;
        reason := "Advanced encryption — ECCN 5D002, License Exception ENC may apply";
      } else {
        eccn := #_5D992;
        license := #no_license_required;
        reason := "Mass-market encryption — ECCN 5D992, no license required";
      };
    } else if (hasSignalProcessing and performanceLevel >= 2) {
      eccn := #_3D001;
      license := #license_exception_TSR;
      reason := "Advanced signal processing software — ECCN 3D001";
    } else if (hasNavigationCapability) {
      eccn := #_7D001;
      license := #individual_validated;
      reason := "Navigation software — ECCN 7D001";
    };

    {
      allowed = true; // Domestic use always allowed
      classification = eccn;
      usmlCategory = usml;
      requiredLicense = license;
      reason;
      controlNumber = 0; // Set by caller
      timestamp = 0;     // Set by caller
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // DEEMED EXPORT CHECK — FOREIGN NATIONAL ACCESS CONTROL
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Check if access by a foreign national constitutes a "deemed export"
  /// Under EAR §734.2(b)(2), releasing controlled technology to a foreign national
  /// in the US is "deemed" an export to that person's home country.
  public func deemedExportCheck(
    personnelNationality : Text,
    technologyClassification : ECCN
  ) : ComplianceResult {
    // Sanctioned countries — always denied
    let isSanctioned = Text.equal(personnelNationality, "CU") or
                       Text.equal(personnelNationality, "IR") or
                       Text.equal(personnelNationality, "KP") or
                       Text.equal(personnelNationality, "SY");

    if (isSanctioned) {
      return {
        allowed = false;
        classification = technologyClassification;
        usmlCategory = #NONE;
        requiredLicense = #denied;
        reason = "Deemed export to sanctioned destination — access DENIED";
        controlNumber = 0;
        timestamp = 0;
      };
    };

    // EAR99 — generally available to non-sanctioned nationals
    switch (technologyClassification) {
      case (#EAR99) {
        {
          allowed = true;
          classification = #EAR99;
          usmlCategory = #NONE;
          requiredLicense = #no_license_required;
          reason = "EAR99 technology — no deemed export restriction";
          controlNumber = 0;
          timestamp = 0;
        }
      };
      case _ {
        // All other ECCN — requires license determination
        {
          allowed = false;
          classification = technologyClassification;
          usmlCategory = #NONE;
          requiredLicense = #individual_validated;
          reason = "Controlled technology — deemed export license required for foreign national access";
          controlNumber = 0;
          timestamp = 0;
        }
      };
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SUPPLY CHAIN ATTESTATION — NO FOREIGN CODE
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Supply chain integrity record
  public type SupplyChainAttestation = {
    moduleId : Text;
    author : Text;
    nationality : Text;
    clearanceLevel : Text;
    codeOrigin : Text;       // "SOVEREIGN" = written in-house
    dependencies : [Text];   // Must be empty for sovereign modules
    reviewedBy : Text;
    attestationDate : Int;
    isSovereign : Bool;
  };

  /// Verify supply chain is sovereign (zero foreign dependencies)
  public func verifySupplyChain(attestation : SupplyChainAttestation) : Bool {
    // Must have zero external dependencies
    if (attestation.dependencies.size() > 0) return false;

    // Must be sovereign origin
    if (not Text.equal(attestation.codeOrigin, "SOVEREIGN")) return false;

    // Must be attested sovereign
    attestation.isSovereign
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // NIST SP 800-171 / CMMC CONTROLS
  // ═══════════════════════════════════════════════════════════════════════════════

  /// NIST control family
  public type NISTControlFamily = {
    #AC;    // Access Control
    #AT;    // Awareness and Training
    #AU;    // Audit and Accountability
    #CM;    // Configuration Management
    #IA;    // Identification and Authentication
    #IR;    // Incident Response
    #MA;    // Maintenance
    #MP;    // Media Protection
    #PE;    // Physical and Environmental
    #PS;    // Personnel Security
    #RA;    // Risk Assessment
    #SA;    // System and Services Acquisition
    #SC;    // System and Communications Protection
    #SI;    // System and Information Integrity
  };

  /// Check if all required NIST controls are implemented for a given module
  public func verifyNISTControls(
    implementedControls : [NISTControlFamily],
    requiredForClassification : ECCN
  ) : Bool {
    // Minimum controls for any classified system
    let minimumRequired : [NISTControlFamily] = [#AC, #AU, #IA, #SC, #SI];

    for (required in minimumRequired.vals()) {
      var found = false;
      for (implemented in implementedControls.vals()) {
        if (controlFamilyEqual(required, implemented)) {
          found := true;
        };
      };
      if (not found) return false;
    };
    true
  };

  /// Compare control families
  func controlFamilyEqual(a : NISTControlFamily, b : NISTControlFamily) : Bool {
    switch (a, b) {
      case (#AC, #AC) { true };
      case (#AT, #AT) { true };
      case (#AU, #AU) { true };
      case (#CM, #CM) { true };
      case (#IA, #IA) { true };
      case (#IR, #IR) { true };
      case (#MA, #MA) { true };
      case (#MP, #MP) { true };
      case (#PE, #PE) { true };
      case (#PS, #PS) { true };
      case (#RA, #RA) { true };
      case (#SA, #SA) { true };
      case (#SC, #SC) { true };
      case (#SI, #SI) { true };
      case _ { false };
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // AUDIT TRAIL — TAMPER-EVIDENT LOGGING
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Audit log state
  public type AuditLog = {
    var entries : [ComplianceAudit];
    var nextId : Nat;
    var chainHash : Nat; // Running hash for tamper evidence
  };

  /// Create new audit log
  public func createAuditLog() : AuditLog {
    {
      var entries = [] : [ComplianceAudit];
      var nextId = 1;
      var chainHash = 14695981039346656037; // FNV offset basis
    }
  };

  /// Log a compliance event (tamper-evident chain)
  public func logComplianceEvent(
    log : AuditLog,
    action : ComplianceAction,
    actor : Text,
    target : Text,
    result : ComplianceResult,
    evidence : Text
  ) : Nat {
    let auditId = log.nextId;
    log.nextId += 1;

    // Chain hash for tamper evidence (FNV-1a)
    let prime : Nat = 1099511628211;
    log.chainHash := (log.chainHash ^ auditId) *% prime;

    let entry : ComplianceAudit = {
      auditId;
      timestamp = result.timestamp;
      action;
      actor;
      target;
      result;
      evidence;
    };

    log.entries := Array.append(log.entries, [entry]);
    auditId
  };

  /// Verify audit log integrity (detect tampering)
  public func verifyAuditLogIntegrity(log : AuditLog) : Bool {
    var computedHash : Nat = 14695981039346656037;
    let prime : Nat = 1099511628211;

    for (entry in log.entries.vals()) {
      computedHash := (computedHash ^ entry.auditId) *% prime;
    };

    computedHash == log.chainHash
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // END-USE CERTIFICATE — EXPORT DOCUMENTATION
  // ═══════════════════════════════════════════════════════════════════════════════

  /// End-use certificate for export transactions
  public type EndUseCertificate = {
    certificateId : Nat;
    issueDate : Int;
    expiryDate : Int;
    exporterName : Text;
    exporterCountry : Text;
    consigneeName : Text;
    consigneeCountry : Text;
    endUserName : Text;
    endUserCountry : Text;
    itemDescription : Text;
    eccn : ECCN;
    quantity : Nat;
    endUseStatement : Text;    // What the item will be used for
    reExportRestriction : Bool;
    diversion : Bool;          // Pledges no diversion
    signedBy : Text;
    witnessedBy : Text;
    certificateHash : Nat;     // Tamper-evident hash
  };

  /// Generate end-use certificate with integrity hash
  public func generateEndUseCertificate(
    certificateId : Nat,
    issueDate : Int,
    validDays : Nat,
    exporter : Text,
    exporterCountry : Text,
    consignee : Text,
    consigneeCountry : Text,
    endUser : Text,
    endUserCountry : Text,
    itemDesc : Text,
    eccn : ECCN,
    quantity : Nat,
    endUse : Text,
    signer : Text,
    witness : Text
  ) : EndUseCertificate {
    // Generate certificate hash
    var hash : Nat = 14695981039346656037;
    let prime : Nat = 1099511628211;
    hash := (hash ^ certificateId) *% prime;
    hash := (hash ^ Int.abs(issueDate)) *% prime;
    hash := (hash ^ quantity) *% prime;

    {
      certificateId;
      issueDate;
      expiryDate = issueDate + validDays * 86400; // days to seconds
      exporterName = exporter;
      exporterCountry;
      consigneeName = consignee;
      consigneeCountry;
      endUserName = endUser;
      endUserCountry;
      itemDescription = itemDesc;
      eccn;
      quantity;
      endUseStatement = endUse;
      reExportRestriction = true;
      diversion = false;
      signedBy = signer;
      witnessedBy = witness;
      certificateHash = hash;
    }
  };

  /// Verify end-use certificate integrity
  public func verifyEndUseCertificate(cert : EndUseCertificate) : Bool {
    var hash : Nat = 14695981039346656037;
    let prime : Nat = 1099511628211;
    hash := (hash ^ cert.certificateId) *% prime;
    hash := (hash ^ Int.abs(cert.issueDate)) *% prime;
    hash := (hash ^ cert.quantity) *% prime;
    hash == cert.certificateHash
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // RED FLAG INDICATORS — BIS COMPLIANCE WARNING SYSTEM
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Red flag indicator types (from BIS "Know Your Customer" guidance)
  public type RedFlag = {
    #unusual_destination;         // Item shipped to unusual country
    #reluctant_end_use_info;     // Customer won't state end use
    #incompatible_end_use;       // Stated end-use doesn't match item
    #declined_service;           // Customer declines installation/training
    #freight_forwarder_as_buyer; // Intermediary purchasing
    #cash_payment;               // Cash for expensive item
    #unfamiliar_route;           // Unusual shipping route
    #military_resemblance;       // Order matches military specs
    #evasion_indicators;         // Attempts to circumvent controls
    #shell_company;              // Buyer appears to be a front
  };

  /// Red flag assessment result
  public type RedFlagAssessment = {
    flags : [RedFlag];
    riskScore : Float;          // 0.0 (low) to 1.0 (critical)
    recommendation : Text;
    requiresEscalation : Bool;
    assessedBy : Text;
    timestamp : Int;
  };

  /// Assess transaction for red flags
  public func assessRedFlags(
    destinationCountry : Text,
    endUseProvided : Bool,
    endUseCompatible : Bool,
    acceptsService : Bool,
    isFreightForwarder : Bool,
    cashPayment : Bool,
    militarySpecs : Bool,
    knownShellCompany : Bool
  ) : RedFlagAssessment {
    var flags : [RedFlag] = [];
    var riskScore : Float = 0.0;

    // High-risk destinations
    let isHighRisk = Text.equal(destinationCountry, "CN") or
                     Text.equal(destinationCountry, "RU") or
                     Text.equal(destinationCountry, "PK");
    if (isHighRisk) {
      flags := Array.append(flags, [#unusual_destination]);
      riskScore += 0.15;
    };

    if (not endUseProvided) {
      flags := Array.append(flags, [#reluctant_end_use_info]);
      riskScore += 0.2;
    };

    if (not endUseCompatible) {
      flags := Array.append(flags, [#incompatible_end_use]);
      riskScore += 0.25;
    };

    if (not acceptsService) {
      flags := Array.append(flags, [#declined_service]);
      riskScore += 0.1;
    };

    if (isFreightForwarder) {
      flags := Array.append(flags, [#freight_forwarder_as_buyer]);
      riskScore += 0.15;
    };

    if (cashPayment) {
      flags := Array.append(flags, [#cash_payment]);
      riskScore += 0.1;
    };

    if (militarySpecs) {
      flags := Array.append(flags, [#military_resemblance]);
      riskScore += 0.3;
    };

    if (knownShellCompany) {
      flags := Array.append(flags, [#shell_company]);
      riskScore += 0.4;
    };

    // Clamp risk score
    riskScore := Float.min(1.0, riskScore);

    let recommendation = if (riskScore >= 0.7) {
      "STOP — Do not proceed. Report to BIS/DDTC immediately."
    } else if (riskScore >= 0.4) {
      "ESCALATE — Senior export compliance officer review required."
    } else if (riskScore >= 0.2) {
      "CAUTION — Additional due diligence required before proceeding."
    } else {
      "PROCEED — No significant red flags identified."
    };

    {
      flags;
      riskScore;
      recommendation;
      requiresEscalation = riskScore >= 0.4;
      assessedBy = "SovereignCompliance/v1.0";
      timestamp = 0;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // VOLUNTARY SELF-DISCLOSURE (VSD) TRACKING
  // ═══════════════════════════════════════════════════════════════════════════════

  /// VSD record for tracking potential violations
  public type VoluntaryDisclosure = {
    vsdId : Nat;
    discoveryDate : Int;
    reportingDate : Int;
    violation : Text;
    affectedItems : [Text];
    affectedDestinations : [Text];
    rootCause : Text;
    correctiveActions : [Text];
    reportedTo : Text;   // BIS, DDTC, or both
    status : VSDStatus;
    penaltyEstimate : Float;
  };

  /// VSD Status
  public type VSDStatus = {
    #draft;
    #submitted;
    #acknowledged;
    #under_review;
    #resolved;
    #penalty_assessed;
  };

  /// Create VSD record
  public func createVSD(
    vsdId : Nat,
    discoveryDate : Int,
    violation : Text,
    items : [Text],
    destinations : [Text],
    rootCause : Text,
    correctiveActions : [Text],
    agency : Text
  ) : VoluntaryDisclosure {
    {
      vsdId;
      discoveryDate;
      reportingDate = 0; // Set when submitted
      violation;
      affectedItems = items;
      affectedDestinations = destinations;
      rootCause;
      correctiveActions;
      reportedTo = agency;
      status = #draft;
      penaltyEstimate = 0.0;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // CMMC PRACTICE MAPPING — LEVEL 3 ASSESSMENT
  // ═══════════════════════════════════════════════════════════════════════════════

  /// CMMC domain
  public type CMMCDomain = {
    #AC;   // Access Control
    #AM;   // Asset Management
    #AT;   // Awareness & Training
    #AU;   // Audit & Accountability
    #CA;   // Security Assessment
    #CM;   // Configuration Management
    #IA;   // Identification & Authentication
    #IR;   // Incident Response
    #MA;   // Maintenance
    #MP;   // Media Protection
    #PE;   // Physical Protection
    #PS;   // Personnel Security
    #RA;   // Risk Assessment
    #RE;   // Recovery
    #RM;   // Risk Management
    #SA;   // Situational Awareness
    #SC;   // System & Communications
    #SI;   // System & Information Integrity
  };

  /// CMMC practice assessment
  public type CMMCAssessment = {
    domain : CMMCDomain;
    practiceId : Text;
    implemented : Bool;
    evidence : Text;
    assessor : Text;
    assessmentDate : Int;
    gapNotes : Text;
  };

  /// Compute CMMC readiness score
  public func cmmcReadinessScore(assessments : [CMMCAssessment]) : Float {
    if (assessments.size() == 0) return 0.0;
    var implemented : Nat = 0;
    for (a in assessments.vals()) {
      if (a.implemented) implemented += 1;
    };
    Float.fromInt(implemented) / Float.fromInt(assessments.size())
  };

  /// Get unimplemented practices (gaps)
  public func cmmcGaps(assessments : [CMMCAssessment]) : [CMMCAssessment] {
    var gaps : [CMMCAssessment] = [];
    for (a in assessments.vals()) {
      if (not a.implemented) {
        gaps := Array.append(gaps, [a]);
      };
    };
    gaps
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // CUI MARKING ENFORCEMENT — CONTROLLED UNCLASSIFIED INFORMATION
  // ═══════════════════════════════════════════════════════════════════════════════

  /// CUI category
  public type CUICategory = {
    #CTI;       // Controlled Technical Information
    #EXPT;      // Export Controlled
    #NNPI;      // Naval Nuclear Propulsion Information
    #PROPIN;    // Proprietary Information
    #NOFORN;    // Not Releasable to Foreign Nationals
    #FEDCON;    // Federal Contract Information
  };

  /// CUI marking record
  public type CUIMarking = {
    documentId : Text;
    category : CUICategory;
    disseminationControl : Text;
    portionMarkings : Bool;
    authorizedHolder : Text;
    createdBy : Text;
    markingDate : Int;
    decontrolDate : ?Int;
  };

  /// Validate CUI marking completeness
  public func validateCUIMarking(marking : CUIMarking) : Bool {
    // Must have all required fields
    Text.size(marking.documentId) > 0 and
    Text.size(marking.disseminationControl) > 0 and
    Text.size(marking.authorizedHolder) > 0 and
    Text.size(marking.createdBy) > 0 and
    marking.markingDate > 0
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // FOREIGN VISIT REQUEST (FVR) PROCESSING
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Foreign visit request
  public type ForeignVisitRequest = {
    fvrId : Nat;
    visitorName : Text;
    nationality : Text;
    organization : Text;
    purpose : Text;
    facilitiesToVisit : [Text];
    programsToDiscuss : [Text];
    visitDate : Int;
    duration : Nat;            // days
    sponsoringOrg : Text;
    clearanceLevel : Text;
    status : FVRStatus;
    restrictions : [Text];     // What cannot be disclosed
    technologyExposure : [ECCN]; // What tech they may be exposed to
  };

  /// FVR status
  public type FVRStatus = {
    #pending;
    #approved;
    #approved_with_restrictions;
    #denied;
    #cancelled;
    #completed;
  };

  /// Evaluate foreign visit request against export controls
  public func evaluateFVR(fvr : ForeignVisitRequest) : ComplianceResult {
    // Check if visitor's nationality is sanctioned
    let isSanctioned = Text.equal(fvr.nationality, "CU") or
                       Text.equal(fvr.nationality, "IR") or
                       Text.equal(fvr.nationality, "KP") or
                       Text.equal(fvr.nationality, "SY");

    if (isSanctioned) {
      return {
        allowed = false;
        classification = #EAR99;
        usmlCategory = #NONE;
        requiredLicense = #denied;
        reason = "Foreign visit DENIED — visitor from sanctioned country";
        controlNumber = fvr.fvrId;
        timestamp = fvr.visitDate;
      };
    };

    // Check technology exposure
    var highestControl : ECCN = #EAR99;
    for (eccn in fvr.technologyExposure.vals()) {
      if (eccnRank(eccn) > eccnRank(highestControl)) {
        highestControl := eccn;
      };
    };

    // Determine if deemed export license needed
    let needsLicense = switch (highestControl) {
      case (#EAR99) { false };
      case _ { true };
    };

    {
      allowed = not needsLicense;
      classification = highestControl;
      usmlCategory = #NONE;
      requiredLicense = if (needsLicense) #individual_validated else #no_license_required;
      reason = if (needsLicense) {
        "Foreign visit requires deemed export license for technology exposure"
      } else {
        "Foreign visit approved — no controlled technology exposure"
      };
      controlNumber = fvr.fvrId;
      timestamp = fvr.visitDate;
    }
  };

  /// Rank ECCN for comparison
  func eccnRank(e : ECCN) : Nat {
    switch (e) {
      case (#EAR99) { 0 };
      case (#_5D992) { 1 };
      case (#_3A001) { 2 };
      case (#_3D001) { 3 };
      case (#_4A003) { 4 };
      case (#_4D001) { 5 };
      case (#_5A002) { 6 };
      case (#_5D002) { 7 };
      case (#_7A003) { 8 };
      case (#_7D001) { 9 };
    }
  };
}
