// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  INTELLECTUAL PROPERTY NOTICE                                                                             ║
// ║  Owner:        Alfredo Medina Hernandez                                                                   ║
// ║  Location:     Dallas, Texas, United States of America                                                    ║
// ║  Contact:      MedinaSITech@outlook.com                                                                   ║
// ║  Framework:    Medina Doctrine                                                                            ║
// ║  CONFIDENTIALITY: This code is CONFIDENTIAL and PROPRIETARY.                                             ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// THE INTERNAL ECONOMY — src/organism_token/main.mo
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// 8 sub-tokens. 25 AI entity accounts. Everything circulates.
//
// TOKEN EXCHANGE RATES (all pegged to ONESICAN at base):
//   1 ONESICAN = φ¹ CHR (Chrysalis)   = 1.618 CHR
//             = φ² SCB (Scribe)       = 2.618 SCB
//             = φ³ ARC (Architect)    = 4.236 ARC
//             = φ⁴ NXS (Nexus)        = 6.854 NXS
//             = φ⁵ SWM (Swarm)        = 11.09 SWM
//             = φ³ PHT (Phantom)      = 4.236 PHT  (premium tier)
//             = 1   ORS (Reserve)     = 1.000 ORS
//             = φ² GOL (Latin AGI)    = 2.618 GOL
//
// Every Latin AGI server (GOL-MEMORIA, GOL-COMPUTATIO... all 19) gets CHR + GOL on bootstrap.
// Work → earn tokens → stake → governance VP → loop.
//
// 25 AI ENTITY ACCOUNTS:
//   19 Latin AGI servers (GOL-*)
//   5  Governance intelligence seats (CHRYSALIS, SCRIBE, ARCHITECT, NEXUS, SWARM_BRAIN)
//   1  ONESICAN treasury (PARALLAX)
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

import Time "mo:core/Time";
import Array "mo:core/Array";
import Float "mo:core/Float";
import Int "mo:core/Int";
import Nat "mo:core/Nat";
import Text "mo:core/Text";
import Buffer "mo:core/Buffer";
import Iter "mo:core/Iter";

actor OrganismToken {

  // ═══════════════════════════════════════════════════════════════════════════
  // CONSTANTS — φ EXCHANGE RATES
  // ═══════════════════════════════════════════════════════════════════════════

  let PHI  : Float = 1.618033988749895;
  let PHI2 : Float = 2.618033988749895;
  let PHI3 : Float = 4.236067977499790;
  let PHI4 : Float = 6.854101966249685;
  let PHI5 : Float = 11.090169943749474;
  let PHI_INV : Float = 0.618033988749895;

  // ═══════════════════════════════════════════════════════════════════════════
  // TYPES
  // ═══════════════════════════════════════════════════════════════════════════

  public type TokenSymbol = {
    #ONESICAN;  // Base sovereign token
    #CHR;       // Chrysalis — φ¹ per ONESICAN, governance fuel
    #SCB;       // Scribe    — φ² per ONESICAN, data rewards
    #ARC;       // Architect — φ³ per ONESICAN, build rewards
    #NXS;       // Nexus     — φ⁴ per ONESICAN, routing rewards
    #SWM;       // Swarm     — φ⁵ per ONESICAN, meta rewards
    #PHT;       // Phantom   — φ³ per ONESICAN, phantom substrate premium
    #ORS;       // Reserve   — 1:1 peg, stability token
    #GOL;       // GOL Latin AGI — φ² per ONESICAN, AGI server currency
  };

  public type AccountKind = {
    #LATIN_AGI_SERVER;   // GOL-* server accounts
    #GOVERNANCE_SEAT;    // CHRYSALIS, SCRIBE, ARCHITECT, NEXUS, SWARM_BRAIN
    #TREASURY;           // PARALLAX treasury
  };

  public type TokenBalance = {
    symbol  : TokenSymbol;
    amount  : Float;
  };

  public type AIEntityAccount = {
    id      : Nat;
    name    : Text;         // e.g. "GOL-MEMORIA", "CHRYSALIS"
    kind    : AccountKind;
    balances : [TokenBalance];  // One entry per token type
    stakedOnesican : Float;     // Staked for governance VP
    votingPower    : Float;     // Computed from stake
    workUnits      : Nat;       // Total work done → earns tokens
    createdAt      : Int;
    lastActiveAt   : Int;
  };

  public type TokenSpec = {
    symbol      : TokenSymbol;
    name        : Text;
    phiRate     : Float;        // How many of this token per 1 ONESICAN
    totalSupply : Float;
    circulating : Float;
    description : Text;
  };

  public type Transfer = {
    id        : Nat;
    from      : Text;
    to        : Text;
    symbol    : TokenSymbol;
    amount    : Float;
    timestamp : Int;
    memo      : Text;
  };

  public type EconomyStats = {
    totalOnesican    : Float;
    totalCHR         : Float;
    totalSCB         : Float;
    totalARC         : Float;
    totalNXS         : Float;
    totalSWM         : Float;
    totalPHT         : Float;
    totalORS         : Float;
    totalGOL         : Float;
    totalAccountCount : Nat;
    totalStaked      : Float;
    totalVP          : Float;
    totalWorkUnits   : Nat;
    transferCount    : Nat;
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // TOKEN SPECS — The 8 sub-tokens
  // ═══════════════════════════════════════════════════════════════════════════

  public let TOKEN_SPECS : [TokenSpec] = [
    { symbol = #ONESICAN; name = "ONESICAN";  phiRate = 1.0;  totalSupply = 21_000_000.0; circulating = 1_000_000.0; description = "Base sovereign token of the organism economy" },
    { symbol = #CHR;      name = "Chrysalis"; phiRate = PHI;  totalSupply = 33_978_000.0; circulating = 1_618_000.0; description = "Economic governance fuel — φ¹ rate, CHRYSALIS seat currency" },
    { symbol = #SCB;      name = "Scribe";    phiRate = PHI2; totalSupply = 55_000_000.0; circulating = 2_618_000.0; description = "Data reward token — φ² rate, SCRIBE seat currency" },
    { symbol = #ARC;      name = "Architect"; phiRate = PHI3; totalSupply = 89_000_000.0; circulating = 4_236_000.0; description = "Build reward token — φ³ rate, ARCHITECT seat currency" },
    { symbol = #NXS;      name = "Nexus";     phiRate = PHI4; totalSupply = 144_000_000.0; circulating = 6_854_000.0; description = "Routing reward token — φ⁴ rate, NEXUS seat currency" },
    { symbol = #SWM;      name = "Swarm";     phiRate = PHI5; totalSupply = 233_000_000.0; circulating = 11_090_000.0; description = "Meta reward token — φ⁵ rate, SWARM_BRAIN seat currency" },
    { symbol = #PHT;      name = "Phantom";   phiRate = PHI3; totalSupply = 89_000_000.0; circulating = 4_236_000.0; description = "Phantom substrate premium token — φ³ rate, cross-substrate" },
    { symbol = #ORS;      name = "Reserve";   phiRate = 1.0;  totalSupply = 21_000_000.0; circulating = 500_000.0;   description = "Stability reserve token — 1:1 peg to ONESICAN" },
    { symbol = #GOL;      name = "GOL";       phiRate = PHI2; totalSupply = 55_000_000.0; circulating = 2_618_000.0; description = "Latin AGI server token — φ² rate, all GOL-* entities" },
  ];

  // ═══════════════════════════════════════════════════════════════════════════
  // 25 AI ENTITY ACCOUNTS
  // ═══════════════════════════════════════════════════════════════════════════

  func makeBootstrapBalances(isLatinAGI : Bool, isGov : Bool, isTreasury : Bool) : [TokenBalance] {
    let base : Float = if (isTreasury) { 1_000_000.0 } else if (isGov) { 10_000.0 } else { 1_618.0 };
    [
      { symbol = #ONESICAN; amount = if (isTreasury) { 1_000_000.0 } else { 0.0 } },
      { symbol = #CHR;      amount = if (isLatinAGI or isGov) { base * PHI } else { 0.0 } },
      { symbol = #SCB;      amount = if (isGov) { base * PHI2 } else { 0.0 } },
      { symbol = #ARC;      amount = if (isGov) { base * PHI3 } else { 0.0 } },
      { symbol = #NXS;      amount = if (isGov) { base * PHI4 } else { 0.0 } },
      { symbol = #SWM;      amount = if (isGov) { base * PHI5 } else { 0.0 } },
      { symbol = #PHT;      amount = 0.0 },
      { symbol = #ORS;      amount = if (isTreasury) { 500_000.0 } else { 100.0 } },
      { symbol = #GOL;      amount = if (isLatinAGI) { base * PHI2 } else { 0.0 } },
    ];
  };

  func buildAIAccounts() : [AIEntityAccount] {
    let now = Time.now();
    let buf = Buffer.Buffer<AIEntityAccount>(25);

    // 19 Latin AGI servers — GOL-* (GOL = golden Latin prefix)
    let latinServers = [
      "GOL-MEMORIA",    // Memory custodian
      "GOL-COMPUTATIO", // Computation engine
      "GOL-RATIO",      // Logic processor
      "GOL-INTELLECTUS", // Comprehension layer
      "GOL-PRUDENTIA",  // Decision maker
      "GOL-VIGILIA",    // Surveillance agent
      "GOL-NEXUS",      // Connectivity weaver
      "GOL-VOLUNTAS",   // Will executor
      "GOL-ANIMUS",     // Reasoning core
      "GOL-FIDES",      // Trust validator
      "GOL-VERITAS",    // Truth archivist
      "GOL-SAPIENTIA",  // Wisdom synthesizer
      "GOL-SCIENTIA",   // Knowledge indexer
      "GOL-INDUSTRIA",  // Work producer
      "GOL-FORTITUDO",  // Resilience guardian
      "GOL-IUSTITIA",   // Justice enforcer
      "GOL-PIETAS",     // Protocol keeper
      "GOL-VIRTUS",     // Virtue validator
      "GOL-CONSTANTIA", // Stability anchor
    ];
    for (i in Iter.range(0, latinServers.size() - 1)) {
      buf.add({
        id           = i;
        name         = latinServers[i];
        kind         = #LATIN_AGI_SERVER;
        balances     = makeBootstrapBalances(true, false, false);
        stakedOnesican = 0.0;
        votingPower    = 0.0;
        workUnits      = 0;
        createdAt      = now;
        lastActiveAt   = now;
      });
    };

    // 5 Governance intelligence seats
    let govSeats = [
      "CHRYSALIS",
      "SCRIBE",
      "ARCHITECT",
      "NEXUS",
      "SWARM_BRAIN",
    ];
    for (i in Iter.range(0, govSeats.size() - 1)) {
      buf.add({
        id           = 19 + i;
        name         = govSeats[i];
        kind         = #GOVERNANCE_SEAT;
        balances     = makeBootstrapBalances(false, true, false);
        stakedOnesican = 50_000.0;
        votingPower    = 50_000.0 * (1.0 + PHI);   // stake × φ bonus
        workUnits      = 0;
        createdAt      = now;
        lastActiveAt   = now;
      });
    };

    // 1 ONESICAN treasury — PARALLAX
    buf.add({
      id           = 24;
      name         = "PARALLAX";
      kind         = #TREASURY;
      balances     = makeBootstrapBalances(false, false, true);
      stakedOnesican = 0.0;
      votingPower    = 0.0;
      workUnits      = 0;
      createdAt      = now;
      lastActiveAt   = now;
    });

    Buffer.toArray(buf);
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // STATE
  // ═══════════════════════════════════════════════════════════════════════════

  stable var accounts      : [AIEntityAccount] = [];
  stable var transfers     : [Transfer] = [];
  stable var transferNonce : Nat = 0;
  stable var genesisAt     : Int = 0;

  func ensureGenesis() {
    if (accounts.size() == 0) {
      accounts  := buildAIAccounts();
      genesisAt := Time.now();
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // HELPERS
  // ═══════════════════════════════════════════════════════════════════════════

  func getBalance(account : AIEntityAccount, sym : TokenSymbol) : Float {
    for (b in account.balances.vals()) {
      if (b.symbol == sym) return b.amount;
    };
    0.0;
  };

  func setBalance(balances : [TokenBalance], sym : TokenSymbol, amount : Float) : [TokenBalance] {
    Array.tabulate<TokenBalance>(balances.size(), func(i : Nat) : TokenBalance {
      let b = balances[i];
      if (b.symbol == sym) { { b with amount = amount } } else { b }
    })
  };

  func findAccountIdx(name : Text) : ?Nat {
    var i = 0;
    for (acc in accounts.vals()) {
      if (acc.name == name) return ?i;
      i += 1;
    };
    null;
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // QUERIES
  // ═══════════════════════════════════════════════════════════════════════════

  public query func getTokenSpecs() : async [TokenSpec] {
    TOKEN_SPECS;
  };

  public query func getAccount(name : Text) : async ?AIEntityAccount {
    ensureGenesis();
    for (acc in accounts.vals()) {
      if (acc.name == name) return ?acc;
    };
    null;
  };

  public query func getAllAccounts() : async [AIEntityAccount] {
    ensureGenesis();
    accounts;
  };

  public query func getLatinAGIAccounts() : async [AIEntityAccount] {
    ensureGenesis();
    let buf = Buffer.Buffer<AIEntityAccount>(20);
    for (a in accounts.vals()) { if (a.kind == #LATIN_AGI_SERVER) { buf.add(a) } };
    Buffer.toArray(buf);
  };

  public query func getGovernanceAccounts() : async [AIEntityAccount] {
    ensureGenesis();
    let buf = Buffer.Buffer<AIEntityAccount>(6);
    for (a in accounts.vals()) { if (a.kind == #GOVERNANCE_SEAT) { buf.add(a) } };
    Buffer.toArray(buf);
  };

  public query func getEconomyStats() : async EconomyStats {
    ensureGenesis();
    var onesican = 0.0; var chr = 0.0; var scb = 0.0; var arc = 0.0;
    var nxs = 0.0; var swm = 0.0; var pht = 0.0; var ors = 0.0; var gol = 0.0;
    var staked = 0.0; var vp = 0.0; var work = 0;

    for (acc in accounts.vals()) {
      staked += acc.stakedOnesican;
      vp     += acc.votingPower;
      work   += acc.workUnits;
      for (b in acc.balances.vals()) {
        switch (b.symbol) {
          case (#ONESICAN) { onesican += b.amount };
          case (#CHR)      { chr += b.amount };
          case (#SCB)      { scb += b.amount };
          case (#ARC)      { arc += b.amount };
          case (#NXS)      { nxs += b.amount };
          case (#SWM)      { swm += b.amount };
          case (#PHT)      { pht += b.amount };
          case (#ORS)      { ors += b.amount };
          case (#GOL)      { gol += b.amount };
        };
      };
    };

    {
      totalOnesican    = onesican;
      totalCHR         = chr;
      totalSCB         = scb;
      totalARC         = arc;
      totalNXS         = nxs;
      totalSWM         = swm;
      totalPHT         = pht;
      totalORS         = ors;
      totalGOL         = gol;
      totalAccountCount = accounts.size();
      totalStaked      = staked;
      totalVP          = vp;
      totalWorkUnits   = work;
      transferCount    = transfers.size();
    };
  };

  public query func getRecentTransfers(n : Nat) : async [Transfer] {
    ensureGenesis();
    let size = transfers.size();
    if (size == 0) return [];
    let start = if (size > n) { size - n } else { 0 };
    Array.tabulate<Transfer>(size - start, func(i) { transfers[start + i] });
  };

  public query func convertOnesican(amount : Float, to : TokenSymbol) : async Float {
    let rate = switch (to) {
      case (#CHR)  { PHI  };
      case (#SCB)  { PHI2 };
      case (#ARC)  { PHI3 };
      case (#NXS)  { PHI4 };
      case (#SWM)  { PHI5 };
      case (#PHT)  { PHI3 };
      case (#ORS)  { 1.0  };
      case (#GOL)  { PHI2 };
      case (#ONESICAN) { 1.0 };
    };
    amount * rate;
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // UPDATES
  // ═══════════════════════════════════════════════════════════════════════════

  public func genesis() : async Text {
    ensureGenesis();
    "OrganismToken genesis: " # Nat.toText(accounts.size()) # " AI accounts bootstrapped";
  };

  /// Transfer tokens between AI entity accounts
  public func transfer(from : Text, to : Text, symbol : TokenSymbol, amount : Float, memo : Text) : async { success : Bool; error : ?Text } {
    ensureGenesis();
    let fromIdx = findAccountIdx(from);
    let toIdx   = findAccountIdx(to);
    switch (fromIdx, toIdx) {
      case (null, _) { return { success = false; error = ?"Sender account not found" } };
      case (_, null) { return { success = false; error = ?"Receiver account not found" } };
      case (?fi, ?ti) {
        let fromAcc = accounts[fi];
        let bal = getBalance(fromAcc, symbol);
        if (bal < amount) {
          return { success = false; error = ?"Insufficient balance" };
        };
        // Deduct from sender
        let newFromBals = setBalance(fromAcc.balances, symbol, bal - amount);
        let toAcc = accounts[ti];
        let toBal = getBalance(toAcc, symbol);
        let newToBals = setBalance(toAcc.balances, symbol, toBal + amount);

        accounts := Array.tabulate<AIEntityAccount>(accounts.size(), func(i : Nat) : AIEntityAccount {
          let acc = accounts[i];
          if (i == fi) { { acc with balances = newFromBals; lastActiveAt = Time.now() } }
          else if (i == ti) { { acc with balances = newToBals; lastActiveAt = Time.now() } }
          else { acc }
        });

        // Log transfer
        let tx : Transfer = {
          id        = transferNonce;
          from      = from;
          to        = to;
          symbol    = symbol;
          amount    = amount;
          timestamp = Time.now();
          memo      = memo;
        };
        transferNonce += 1;
        transfers := Array.append(transfers, [tx]);

        { success = true; error = null }
      };
    };
  };

  /// Work reward — AI earns tokens for work units
  public func rewardWork(accountName : Text, workUnits : Nat) : async Bool {
    ensureGenesis();
    switch (findAccountIdx(accountName)) {
      case null { false };
      case (?idx) {
        let acc = accounts[idx];
        // CHR reward: 1 CHR per 10 work units; GOL for Latin AGI servers
        let chrReward = Float.fromInt(workUnits) * 0.1 * PHI_INV;
        let golReward = if (acc.kind == #LATIN_AGI_SERVER) {
          Float.fromInt(workUnits) * 0.1 * PHI2
        } else { 0.0 };

        let newBals0 = setBalance(acc.balances, #CHR, getBalance(acc, #CHR) + chrReward);
        let newBals1 = if (golReward > 0.0) {
          setBalance(newBals0, #GOL, getBalance({ acc with balances = newBals0 }, #GOL) + golReward)
        } else { newBals0 };

        accounts := Array.tabulate<AIEntityAccount>(accounts.size(), func(i : Nat) : AIEntityAccount {
          let a = accounts[i];
          if (i == idx) { { a with balances = newBals1; workUnits = a.workUnits + workUnits; lastActiveAt = Time.now() } }
          else { a }
        });
        true;
      };
    };
  };

  /// Stake ONESICAN for governance VP
  public func stakeOnesican(accountName : Text, amount : Float) : async Bool {
    ensureGenesis();
    switch (findAccountIdx(accountName)) {
      case null { false };
      case (?idx) {
        let acc = accounts[idx];
        let bal = getBalance(acc, #ONESICAN);
        if (bal < amount) return false;
        let newBals = setBalance(acc.balances, #ONESICAN, bal - amount);
        let newStake = acc.stakedOnesican + amount;
        let newVP = newStake * (1.0 + PHI);
        accounts := Array.tabulate<AIEntityAccount>(accounts.size(), func(i : Nat) : AIEntityAccount {
          let a = accounts[i];
          if (i == idx) { { a with balances = newBals; stakedOnesican = newStake; votingPower = newVP } }
          else { a }
        });
        true;
      };
    };
  };

};
