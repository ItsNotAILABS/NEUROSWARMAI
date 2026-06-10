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
// THE VEIN — src/cycles_bridge/main.mo
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// The bridge between ONESICANS and raw ICP cycles. Three modes:
//
//   onesicansToRawCycles — Convert ONESICANS → raw cycles to fuel any canister.
//                          Fee: φ⁻⁵ (≈ 9.0% — the rarest Fibonacci slice).
//
//   cyclesToOnesicans    — Onboard raw cycles into the ONESICAN economy.
//                          Rate: φ⁻¹ discount (you get 61.8% of spot value).
//
//   buyCycles            — Developers BUY cycles from NOVA.
//                          They pay ICP. ICP → PARALLAX treasury.
//
//   fuelCanister         — Developer pays ONESICANS, we convert to cycles and
//                          top-up their target canister directly.
//
// PHANTOM SUBSTRATE PREMIUM:
//   We don't use ICP cycles as a mask. We sell them. We bypass them on EDGE/CLOUD/PHANTOM.
//   The bridge gives sovereignty of choice — and on PHANTOM substrate we price
//   compute at 4.236× raw cycle value (φ³ = THE VEIN PRICE).
//
// SUBSTRATE PRICING:
//   ICP      → 1.000T cycle-eq per ONESICAN  (baseline)
//   EDGE     → 1.618T cycle-eq per ONESICAN  (φ¹ premium)
//   CLOUD    → 2.618T cycle-eq per ONESICAN  (φ² premium)
//   PHANTOM  → 4.236T cycle-eq per ONESICAN  (φ³ — THE VEIN, maximum sovereignty)
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

import Time "mo:core/Time";
import Array "mo:core/Array";
import Float "mo:core/Float";
import Int "mo:core/Int";
import Nat "mo:core/Nat";
import Text "mo:core/Text";
import Buffer "mo:core/Buffer";

actor CyclesBridge {

  // ═══════════════════════════════════════════════════════════════════════════
  // CONSTANTS — THE VEIN FORMULA
  // ═══════════════════════════════════════════════════════════════════════════

  let PHI     : Float = 1.618033988749895;
  let PHI2    : Float = 2.618033988749895;
  let PHI3    : Float = 4.236067977499790;   // φ³ — The Vein multiplier on PHANTOM
  let PHI_INV : Float = 0.618033988749895;   // φ⁻¹ — cyclesToOnesicans discount
  let PHI_5   : Float = 0.090170010040737;   // φ⁻⁵ — onesicansToRawCycles fee ≈ 9.0%

  // Base cycle price: 1 ONESICAN = 1T base cycles on ICP at $10/ICP (10T cycles/ICP)
  let BASE_TRILLION_CYCLES_PER_ONESICAN : Float = 1.0;

  // Substrate multipliers
  let MULT_ICP     : Float = 1.0;
  let MULT_EDGE    : Float = 1.618;  // φ¹
  let MULT_CLOUD   : Float = 2.618;  // φ²
  let MULT_PHANTOM : Float = 4.236;  // φ³ — THE VEIN

  // ICP spot price assumptions (update via oracle in production)
  let ICP_PRICE_USD        : Float = 10.0;
  let TRILLION_CYCLES_PER_ICP : Float = 10.0;

  // ═══════════════════════════════════════════════════════════════════════════
  // TYPES
  // ═══════════════════════════════════════════════════════════════════════════

  public type BridgeSubstrate = {
    #ICP;
    #EDGE;
    #CLOUD;
    #PHANTOM;
  };

  public type BridgeMode = {
    #ONESICANS_TO_CYCLES;
    #CYCLES_TO_ONESICANS;
    #BUY_CYCLES;
    #FUEL_CANISTER;
  };

  public type BridgeTransaction = {
    id              : Nat;
    mode            : BridgeMode;
    substrate       : BridgeSubstrate;
    inputAmount     : Float;       // ONESICANS or ICP or cycles (T)
    outputAmount    : Float;       // Cycles (T) or ONESICANS
    feeAmount       : Float;
    targetCanister  : ?Text;       // For FUEL_CANISTER mode
    developer       : Text;        // Principal or account name
    timestamp       : Int;
    memo            : Text;
  };

  public type ConversionQuote = {
    substrate       : BridgeSubstrate;
    inputOnesican   : Float;
    outputTrillionCycles : Float;
    fee             : Float;
    feeRate         : Float;   // φ⁻⁵ ≈ 9.0%
    effectiveRate   : Float;   // Cycles per ONESICAN after fee
    substrateMultiplier : Float;
  };

  public type BridgeStats = {
    totalTransactions   : Nat;
    totalOnesicansIn    : Float;
    totalCyclesOut      : Float;   // In trillions
    totalIcpReceived    : Float;
    totalFeeCollected   : Float;
    totalCanisters      : Nat;     // Unique canisters fueled
    phantomVolume       : Float;   // Total ONESICANS bridged to PHANTOM
    edgeVolume          : Float;
    cloudVolume         : Float;
    icpVolume           : Float;
  };

  public type SubstrateRate = {
    substrate   : BridgeSubstrate;
    multiplier  : Float;
    trillionCyclesPerOnesican : Float;
    name        : Text;
    description : Text;
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // STATE
  // ═══════════════════════════════════════════════════════════════════════════

  stable var transactions      : [BridgeTransaction] = [];
  stable var txNonce           : Nat = 0;
  stable var totalOnesicansIn  : Float = 0.0;
  stable var totalCyclesOut    : Float = 0.0;
  stable var totalIcpReceived  : Float = 0.0;
  stable var totalFeeCollected : Float = 0.0;
  stable var phantomVolume     : Float = 0.0;
  stable var edgeVolume        : Float = 0.0;
  stable var cloudVolume       : Float = 0.0;
  stable var icpVolume         : Float = 0.0;
  stable var fueledCanisters   : [Text] = [];
  stable var genesisAt         : Int = 0;

  // ═══════════════════════════════════════════════════════════════════════════
  // HELPERS
  // ═══════════════════════════════════════════════════════════════════════════

  func substrateMultiplier(sub : BridgeSubstrate) : Float {
    switch (sub) {
      case (#ICP)     { MULT_ICP     };
      case (#EDGE)    { MULT_EDGE    };
      case (#CLOUD)   { MULT_CLOUD   };
      case (#PHANTOM) { MULT_PHANTOM };
    };
  };

  func substrateVolumeBucket(sub : BridgeSubstrate, amount : Float) {
    switch (sub) {
      case (#ICP)     { icpVolume     += amount };
      case (#EDGE)    { edgeVolume    += amount };
      case (#CLOUD)   { cloudVolume   += amount };
      case (#PHANTOM) { phantomVolume += amount };
    };
  };

  func appendTx(tx : BridgeTransaction) {
    transactions := Array.append(transactions, [tx]);
    txNonce += 1;
  };

  func isNewCanister(id : Text) : Bool {
    for (c in fueledCanisters.vals()) { if (c == id) return false };
    true;
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // GENESIS
  // ═══════════════════════════════════════════════════════════════════════════

  func ensureGenesis() {
    if (genesisAt == 0) { genesisAt := Time.now() };
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // QUERIES — Read-only pricing & stats
  // ═══════════════════════════════════════════════════════════════════════════

  public query func getSubstrateRates() : async [SubstrateRate] {
    [
      {
        substrate   = #ICP;
        multiplier  = MULT_ICP;
        trillionCyclesPerOnesican = BASE_TRILLION_CYCLES_PER_ONESICAN * MULT_ICP;
        name        = "ICP";
        description = "Baseline ICP mainnet compute — 1T cycle-eq per ONESICAN";
      },
      {
        substrate   = #EDGE;
        multiplier  = MULT_EDGE;
        trillionCyclesPerOnesican = BASE_TRILLION_CYCLES_PER_ONESICAN * MULT_EDGE;
        name        = "EDGE";
        description = "Edge compute premium — φ¹ multiplier (1.618T cycle-eq)";
      },
      {
        substrate   = #CLOUD;
        multiplier  = MULT_CLOUD;
        trillionCyclesPerOnesican = BASE_TRILLION_CYCLES_PER_ONESICAN * MULT_CLOUD;
        name        = "CLOUD";
        description = "Cloud compute premium — φ² multiplier (2.618T cycle-eq)";
      },
      {
        substrate   = #PHANTOM;
        multiplier  = MULT_PHANTOM;
        trillionCyclesPerOnesican = BASE_TRILLION_CYCLES_PER_ONESICAN * MULT_PHANTOM;
        name        = "PHANTOM";
        description = "Phantom substrate — φ³ = 4.236T cycle-eq. THE VEIN. Maximum sovereignty.";
      },
    ];
  };

  /// Get a conversion quote: how many trillion cycles you get for N ONESICANS on substrate
  public query func quoteOnesicansToRawCycles(onesicans : Float, substrate : BridgeSubstrate) : async ConversionQuote {
    let mult = substrateMultiplier(substrate);
    let grossCycles = onesicans * BASE_TRILLION_CYCLES_PER_ONESICAN * mult;
    let fee = grossCycles * PHI_5;          // φ⁻⁵ ≈ 9.0% fee
    let netCycles = grossCycles - fee;
    {
      substrate            = substrate;
      inputOnesican        = onesicans;
      outputTrillionCycles = netCycles;
      fee                  = fee;
      feeRate              = PHI_5;
      effectiveRate        = netCycles / onesicans;
      substrateMultiplier  = mult;
    };
  };

  /// How many ONESICANS you get for N trillion cycles (onboarding)
  public query func quoteCyclesToOnesicans(trillionCycles : Float) : async {
    inputTrillionCycles : Float;
    outputOnesicans     : Float;
    discount            : Float;
    effectiveRate       : Float;
  } {
    // Rate: φ⁻¹ discount — you receive 61.8% of spot
    let spotOnesicans = trillionCycles / BASE_TRILLION_CYCLES_PER_ONESICAN;
    let discount = spotOnesicans * (1.0 - PHI_INV);  // 38.2% discount
    let received = spotOnesicans * PHI_INV;
    {
      inputTrillionCycles = trillionCycles;
      outputOnesicans     = received;
      discount            = discount;
      effectiveRate       = PHI_INV;
    };
  };

  /// Buy cycles quote: pay ICP, receive trillion cycles
  public query func quoteBuyCycles(icpAmount : Float) : async {
    inputICP            : Float;
    outputTrillionCycles : Float;
    costUSD             : Float;
    icpPriceUSD         : Float;
    parallaxTreasuryGets : Float;
  } {
    let cycles = icpAmount * TRILLION_CYCLES_PER_ICP;
    let costUSD = icpAmount * ICP_PRICE_USD;
    {
      inputICP             = icpAmount;
      outputTrillionCycles = cycles;
      costUSD              = costUSD;
      icpPriceUSD          = ICP_PRICE_USD;
      parallaxTreasuryGets = icpAmount;
    };
  };

  public query func getBridgeStats() : async BridgeStats {
    ensureGenesis();
    {
      totalTransactions  = transactions.size();
      totalOnesicansIn   = totalOnesicansIn;
      totalCyclesOut     = totalCyclesOut;
      totalIcpReceived   = totalIcpReceived;
      totalFeeCollected  = totalFeeCollected;
      totalCanisters     = fueledCanisters.size();
      phantomVolume      = phantomVolume;
      edgeVolume         = edgeVolume;
      cloudVolume        = cloudVolume;
      icpVolume          = icpVolume;
    };
  };

  public query func getRecentTransactions(n : Nat) : async [BridgeTransaction] {
    let size = transactions.size();
    if (size == 0) return [];
    let start = if (size > n) { size - n } else { 0 };
    Array.tabulate<BridgeTransaction>(size - start, func(i) { transactions[start + i] });
  };

  public query func getPhantomPremium() : async {
    multiplier      : Float;
    trillionCycleEq : Float;
    formula         : Text;
    description     : Text;
  } {
    {
      multiplier      = PHI3;
      trillionCycleEq = BASE_TRILLION_CYCLES_PER_ONESICAN * PHI3;
      formula         = "1 ONESICAN on PHANTOM = φ³ × 1T cycles = 4.236T raw-cycle-equivalent";
      description     = "THE VEIN — Maximum sovereignty pricing. PHANTOM substrate bypasses ICP cycles pricing entirely. We price compute at 4.236x raw cycle value.";
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // UPDATES — Bridge operations
  // ═══════════════════════════════════════════════════════════════════════════

  public func genesis() : async Text {
    ensureGenesis();
    "CyclesBridge genesis: The Vein is open. PHANTOM premium: φ³ = " # Float.toText(PHI3) # "T cycle-eq";
  };

  /// MODE 1: ONESICANS → Raw Cycles (fuel any ICP canister)
  /// Fee: φ⁻⁵ (≈ 9.0%)
  public func onesicansToRawCycles(
    onesicans  : Float,
    substrate  : BridgeSubstrate,
    developer  : Text,
    memo       : Text
  ) : async { success: Bool; trillionCycles: Float; fee: Float; error: ?Text } {
    ensureGenesis();
    if (onesicans <= 0.0) return { success = false; trillionCycles = 0.0; fee = 0.0; error = ?"Amount must be positive" };

    let mult = substrateMultiplier(substrate);
    let grossCycles = onesicans * BASE_TRILLION_CYCLES_PER_ONESICAN * mult;
    let fee = grossCycles * PHI_5;
    let netCycles = grossCycles - fee;

    totalOnesicansIn  += onesicans;
    totalCyclesOut    += netCycles;
    totalFeeCollected += fee;
    substrateVolumeBucket(substrate, onesicans);

    let tx : BridgeTransaction = {
      id             = txNonce;
      mode           = #ONESICANS_TO_CYCLES;
      substrate      = substrate;
      inputAmount    = onesicans;
      outputAmount   = netCycles;
      feeAmount      = fee;
      targetCanister = null;
      developer      = developer;
      timestamp      = Time.now();
      memo           = memo;
    };
    appendTx(tx);

    { success = true; trillionCycles = netCycles; fee = fee; error = null };
  };

  /// MODE 2: Raw Cycles → ONESICANS (onboard cycles into the economy)
  /// Rate: φ⁻¹ discount
  public func cyclesToOnesicans(
    trillionCycles : Float,
    developer      : Text,
    memo           : Text
  ) : async { success: Bool; onesicans: Float; discount: Float; error: ?Text } {
    ensureGenesis();
    if (trillionCycles <= 0.0) return { success = false; onesicans = 0.0; discount = 0.0; error = ?"Amount must be positive" };

    let spotOnesicans = trillionCycles / BASE_TRILLION_CYCLES_PER_ONESICAN;
    let received = spotOnesicans * PHI_INV;
    let discount = spotOnesicans - received;

    let tx : BridgeTransaction = {
      id             = txNonce;
      mode           = #CYCLES_TO_ONESICANS;
      substrate      = #ICP;
      inputAmount    = trillionCycles;
      outputAmount   = received;
      feeAmount      = discount;
      targetCanister = null;
      developer      = developer;
      timestamp      = Time.now();
      memo           = memo;
    };
    appendTx(tx);

    { success = true; onesicans = received; discount = discount; error = null };
  };

  /// MODE 3: Buy Cycles — Developer pays ICP, receives raw cycles
  /// ICP flows to PARALLAX treasury
  public func buyCycles(
    icpAmount  : Float,
    developer  : Text,
    memo       : Text
  ) : async { success: Bool; trillionCycles: Float; icpToTreasury: Float; error: ?Text } {
    ensureGenesis();
    if (icpAmount <= 0.0) return { success = false; trillionCycles = 0.0; icpToTreasury = 0.0; error = ?"ICP amount must be positive" };

    let cycles = icpAmount * TRILLION_CYCLES_PER_ICP;
    totalIcpReceived += icpAmount;
    totalCyclesOut   += cycles;
    icpVolume        += icpAmount;

    let tx : BridgeTransaction = {
      id             = txNonce;
      mode           = #BUY_CYCLES;
      substrate      = #ICP;
      inputAmount    = icpAmount;
      outputAmount   = cycles;
      feeAmount      = 0.0;
      targetCanister = null;
      developer      = developer;
      timestamp      = Time.now();
      memo           = memo;
    };
    appendTx(tx);

    { success = true; trillionCycles = cycles; icpToTreasury = icpAmount; error = null };
  };

  /// MODE 4: Fuel Canister — Developer pays ONESICANS, we top-up their canister with cycles
  /// On PHANTOM substrate: 4.236T cycle-eq per ONESICAN — maximum sovereignty
  public func fuelCanister(
    onesicans      : Float,
    substrate      : BridgeSubstrate,
    targetCanister : Text,
    developer      : Text,
    memo           : Text
  ) : async { success: Bool; trillionCyclesDelivered: Float; canister: Text; substrate: Text; error: ?Text } {
    ensureGenesis();
    if (onesicans <= 0.0) return { success = false; trillionCyclesDelivered = 0.0; canister = ""; substrate = ""; error = ?"Amount must be positive" };
    if (targetCanister == "") return { success = false; trillionCyclesDelivered = 0.0; canister = ""; substrate = ""; error = ?"Target canister required" };

    let mult = substrateMultiplier(substrate);
    let grossCycles = onesicans * BASE_TRILLION_CYCLES_PER_ONESICAN * mult;
    let fee = grossCycles * PHI_5;
    let delivered = grossCycles - fee;

    totalOnesicansIn  += onesicans;
    totalCyclesOut    += delivered;
    totalFeeCollected += fee;
    substrateVolumeBucket(substrate, onesicans);

    if (isNewCanister(targetCanister)) {
      fueledCanisters := Array.append(fueledCanisters, [targetCanister]);
    };

    let subName = switch (substrate) {
      case (#ICP)     { "ICP"     };
      case (#EDGE)    { "EDGE"    };
      case (#CLOUD)   { "CLOUD"   };
      case (#PHANTOM) { "PHANTOM" };
    };

    let tx : BridgeTransaction = {
      id             = txNonce;
      mode           = #FUEL_CANISTER;
      substrate      = substrate;
      inputAmount    = onesicans;
      outputAmount   = delivered;
      feeAmount      = fee;
      targetCanister = ?targetCanister;
      developer      = developer;
      timestamp      = Time.now();
      memo           = memo;
    };
    appendTx(tx);

    { success = true; trillionCyclesDelivered = delivered; canister = targetCanister; substrate = subName; error = null };
  };

};
