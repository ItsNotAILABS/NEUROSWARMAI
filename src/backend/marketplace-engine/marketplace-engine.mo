// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  INTELLECTUAL PROPERTY NOTICE                                                                             ║
// ║  ─────────────────────────────────────────────────────────────────────────────────────────────────────── ║
// ║  Owner:        Alfredo Medina Hernandez                                                                   ║
// ║  Location:     Dallas, Texas, United States of America                                                    ║
// ║  Contact:      MedinaSITech@outlook.com                                                                   ║
// ║  Framework:    Medina Doctrine                                                                            ║
// ║                                                                                                           ║
// ║  LEGAL PROTECTION                                                                                         ║
// ║  ─────────────────────────────────────────────────────────────────────────────────────────────────────── ║
// ║  This source code, including all algorithms, mathematical formulations, architectural designs,            ║
// ║  naming conventions, data structures, and conceptual frameworks contained herein, constitutes             ║
// ║  the exclusive intellectual property of Alfredo Medina Hernandez.                                        ║
// ║                                                                                                           ║
// ║  PROTECTED UNDER:                                                                                         ║
// ║  • United States Copyright Law (17 U.S.C. §§ 101-1332)                                                   ║
// ║  • Berne Convention for the Protection of Literary and Artistic Works                                     ║
// ║  • WIPO Copyright Treaty (WCT)                                                                            ║
// ║  • Trade Secret Law - Defend Trade Secrets Act (18 U.S.C. § 1836)                                        ║
// ║  • Economic Espionage Act (18 U.S.C. §§ 1831-1839)                                                       ║
// ║                                                                                                           ║
// ║  CONFIDENTIALITY: This code is CONFIDENTIAL and PROPRIETARY.                                             ║
// ║  ENCRYPTION: All transmissions must be encrypted.                                                         ║
// ║  ATTRIBUTION: Required for any use, reproduction, or derivative work.                                     ║
// ║                                                                                                           ║
// ║  Unauthorized access, use, reproduction, distribution, or creation of derivative works                    ║
// ║  is strictly prohibited and will be prosecuted to the fullest extent of applicable law.                  ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝
// =====================================================================
// Marketplace Engine — Advanced Auction, Escrow, and Pricing Algorithms
// Part of the Organism Command Platform Cognitive Architecture
// =====================================================================

import Time "mo:core/Time";
import Array "mo:core/Array";
import Float "mo:core/Float";
import Nat "mo:core/Nat";
import Int "mo:core/Int";
import Text "mo:core/Text";
import Principal "mo:core/Principal";

module MarketplaceEngine {

  // ===================== Pricing Types =====================

  public type PricingModel = {
    #Fixed;                   // Static price
    #Auction;                 // Highest bidder wins
    #DutchAuction;            // Price decreases over time
    #ReserveAuction;          // Minimum price threshold
    #BuyNow;                  // Instant purchase at fixed price
    #Negotiable;              // Open to offers
    #DynamicPricing;          // Algorithmic pricing
    #BundlePricing;           // Multiple organisms bundled
  };

  public type PriceHistory = {
    price : Float;
    timestamp : Int;
    event : Text;             // "listed", "sold", "relisted", "price_change"
  };

  public type PricingAnalytics = {
    currentPrice : Float;
    avgPrice30d : Float;
    minPrice30d : Float;
    maxPrice30d : Float;
    priceChange24h : Float;
    priceChange7d : Float;
    volatility : Float;
    demandScore : Float;      // 0-100 based on views, bids, etc.
    supplyScore : Float;      // 0-100 based on similar listings
    recommendedPrice : Float;
  };

  // ===================== Listing Types =====================

  public type ListingStatus = {
    #Draft;
    #Active;
    #Pending;                 // Awaiting approval
    #Sold;
    #Expired;
    #Cancelled;
    #Reserved;                // Held for specific buyer
    #InEscrow;
  };

  public type ListingVisibility = {
    #Public;
    #Private;
    #Unlisted;               // Accessible by direct link only
    #WhitelistOnly;
  };

  public type ListingOptions = {
    allowOffers : Bool;
    autoAcceptPrice : ?Float;  // Auto-accept offers above this
    reservePrice : ?Float;
    buyNowPrice : ?Float;
    startingBid : ?Float;
    bidIncrement : ?Float;
    duration : Int;            // Listing duration in nanoseconds
    extensionThreshold : ?Int; // Time before end when bids extend auction
    extensionDuration : ?Int;  // How much to extend by
  };

  public type Listing = {
    id : Text;
    organismId : Text;
    seller : Principal;
    sellerOrganism : ?Text;
    pricingModel : PricingModel;
    currentPrice : Float;
    originalPrice : Float;
    status : ListingStatus;
    visibility : ListingVisibility;
    options : ListingOptions;
    priceHistory : [PriceHistory];
    viewCount : Nat;
    watchCount : Nat;
    bidCount : Nat;
    offerCount : Nat;
    createdAt : Int;
    updatedAt : Int;
    expiresAt : Int;
    soldAt : ?Int;
    soldTo : ?Principal;
    finalPrice : ?Float;
    tags : [Text];
    description : Text;
    featured : Bool;
  };

  // ===================== Bid Types =====================

  public type BidStatus = {
    #Active;
    #Outbid;
    #Winning;
    #Won;
    #Lost;
    #Cancelled;
    #Expired;
  };

  public type Bid = {
    id : Text;
    listingId : Text;
    bidder : Principal;
    bidderOrganism : ?Text;
    amount : Float;
    maxBid : ?Float;           // For automatic bidding
    status : BidStatus;
    timestamp : Int;
    expiresAt : ?Int;
    message : ?Text;
  };

  public type BidHistory = {
    bidId : Text;
    amount : Float;
    bidder : Principal;
    timestamp : Int;
    isWinning : Bool;
  };

  // ===================== Offer Types =====================

  public type OfferStatus = {
    #Pending;
    #Accepted;
    #Rejected;
    #Countered;
    #Expired;
    #Cancelled;
    #InEscrow;
  };

  public type Offer = {
    id : Text;
    listingId : Text;
    offerer : Principal;
    offererOrganism : ?Text;
    amount : Float;
    counterAmount : ?Float;
    status : OfferStatus;
    message : ?Text;
    sellerResponse : ?Text;
    createdAt : Int;
    respondedAt : ?Int;
    expiresAt : Int;
  };

  // ===================== Escrow Types =====================

  public type EscrowStatus = {
    #Pending;
    #Funded;
    #Released;
    #Refunded;
    #Disputed;
    #Resolved;
  };

  public type EscrowParty = {
    principal : Principal;
    organismId : ?Text;
    role : Text;              // "buyer", "seller", "arbiter"
    hasApproved : Bool;
  };

  public type Escrow = {
    id : Text;
    listingId : Text;
    transactionType : Text;   // "sale", "auction", "offer"
    parties : [EscrowParty];
    amount : Float;
    fee : Float;
    status : EscrowStatus;
    fundedAt : ?Int;
    releasedAt : ?Int;
    createdAt : Int;
    deadline : Int;
    conditions : [Text];
    disputeReason : ?Text;
    resolution : ?Text;
  };

  // ===================== Transaction Types =====================

  public type TransactionType = {
    #DirectSale;
    #AuctionWin;
    #OfferAccepted;
    #BundleSale;
    #Transfer;                 // Free transfer
    #Gift;
  };

  public type Transaction = {
    id : Text;
    transactionType : TransactionType;
    listingId : ?Text;
    escrowId : ?Text;
    organismId : Text;
    seller : Principal;
    buyer : Principal;
    amount : Float;
    fee : Float;
    netAmount : Float;
    timestamp : Int;
    metadata : [(Text, Text)];
  };

  // ===================== Fee Structure =====================

  public type FeeType = {
    #ListingFee;
    #TransactionFee;
    #PremiumFee;
    #FeaturedFee;
    #RenewalFee;
    #WithdrawalFee;
  };

  public type FeeConfig = {
    listingFeePercent : Float;
    transactionFeePercent : Float;
    premiumFeePercent : Float;
    featuredFeeFlat : Float;
    minimumFee : Float;
    maximumFee : ?Float;
  };

  // ===================== Watchlist Types =====================

  public type WatchlistEntry = {
    listingId : Text;
    watcher : Principal;
    watcherOrganism : ?Text;
    addedAt : Int;
    priceAlert : ?Float;
    notifyOnBid : Bool;
    notifyOnPriceChange : Bool;
    notifyOnExpiry : Bool;
  };

  // ===================== Search and Filter Types =====================

  public type SearchFilters = {
    priceMin : ?Float;
    priceMax : ?Float;
    pricingModels : [PricingModel];
    statuses : [ListingStatus];
    classes : [Text];
    specializations : [Text];
    sellers : [Principal];
    tags : [Text];
    minCoherence : ?Float;
    minGovernance : ?Float;
    createdAfter : ?Int;
    createdBefore : ?Int;
    sortBy : Text;            // "price", "date", "popularity", "ending"
    sortOrder : Text;         // "asc", "desc"
  };

  public type SearchResult = {
    listings : [Listing];
    totalCount : Nat;
    page : Nat;
    pageSize : Nat;
    facets : [(Text, [(Text, Nat)])];
  };

  // ===================== Market Analytics =====================

  public type MarketStats = {
    totalListings : Nat;
    activeListings : Nat;
    totalVolume24h : Float;
    totalVolume7d : Float;
    totalVolume30d : Float;
    avgPrice : Float;
    medianPrice : Float;
    floorPrice : Float;
    ceilingPrice : Float;
    totalTransactions : Nat;
    uniqueSellers : Nat;
    uniqueBuyers : Nat;
    lastUpdated : Int;
  };

  public type TrendingItem = {
    organismId : Text;
    listingId : ?Text;
    name : Text;
    class_ : Text;
    trendScore : Float;
    viewCount : Nat;
    bidCount : Nat;
    priceChange : Float;
    rank : Nat;
  };

  // ===================== State Management =====================

  public type MarketplaceState = {
    var listings : [Listing];
    var bids : [Bid];
    var offers : [Offer];
    var escrows : [Escrow];
    var transactions : [Transaction];
    var watchlists : [WatchlistEntry];
    var feeConfig : FeeConfig;
    var listingCounter : Nat;
    var bidCounter : Nat;
    var offerCounter : Nat;
    var escrowCounter : Nat;
    var transactionCounter : Nat;
    var collectedFees : Float;
    var marketStats : MarketStats;
  };

  public func initState() : MarketplaceState {
    {
      var listings = [];
      var bids = [];
      var offers = [];
      var escrows = [];
      var transactions = [];
      var watchlists = [];
      var feeConfig = {
        listingFeePercent = 0.01;      // 1%
        transactionFeePercent = 0.025;  // 2.5%
        premiumFeePercent = 0.05;       // 5%
        featuredFeeFlat = 10.0;
        minimumFee = 0.1;
        maximumFee = ?1000.0;
      };
      var listingCounter = 0;
      var bidCounter = 0;
      var offerCounter = 0;
      var escrowCounter = 0;
      var transactionCounter = 0;
      var collectedFees = 0.0;
      var marketStats = {
        totalListings = 0;
        activeListings = 0;
        totalVolume24h = 0.0;
        totalVolume7d = 0.0;
        totalVolume30d = 0.0;
        avgPrice = 0.0;
        medianPrice = 0.0;
        floorPrice = 0.0;
        ceilingPrice = 0.0;
        totalTransactions = 0;
        uniqueSellers = 0;
        uniqueBuyers = 0;
        lastUpdated = 0;
      };
    };
  };

  // ===================== Array Utilities =====================

  func arrayAppend<T>(a : [T], b : [T]) : [T] {
    let sa = a.size();
    let sb = b.size();
    if (sa == 0) return b;
    if (sb == 0) return a;
    Array.tabulate(sa + sb, func(i : Nat) : T {
      if (i < sa) a[i] else b[i - sa];
    });
  };

  func arrayFilter<T>(arr : [T], pred : T -> Bool) : [T] {
    var result : [T] = [];
    for (item in arr.vals()) {
      if (pred(item)) {
        result := arrayAppend(result, [item]);
      };
    };
    result;
  };

  func arrayFind<T>(arr : [T], pred : T -> Bool) : ?T {
    for (item in arr.vals()) {
      if (pred(item)) return ?item;
    };
    null;
  };

  func arrayMap<T, U>(arr : [T], f : T -> U) : [U] {
    Array.tabulate(arr.size(), func(i : Nat) : U { f(arr[i]) });
  };

  public type Result<T, E> = { #ok : T; #err : E };

  // ===================== Fee Calculation =====================

  public func calculateFee(
    state : MarketplaceState,
    amount : Float,
    feeType : FeeType,
  ) : Float {
    let percent = switch feeType {
      case (#ListingFee) state.feeConfig.listingFeePercent;
      case (#TransactionFee) state.feeConfig.transactionFeePercent;
      case (#PremiumFee) state.feeConfig.premiumFeePercent;
      case (#FeaturedFee) return state.feeConfig.featuredFeeFlat;
      case (#RenewalFee) state.feeConfig.listingFeePercent * 0.5;
      case (#WithdrawalFee) state.feeConfig.transactionFeePercent * 0.5;
    };
    
    var fee = amount * percent;
    fee := Float.max(fee, state.feeConfig.minimumFee);
    
    switch state.feeConfig.maximumFee {
      case (?max) { fee := Float.min(fee, max) };
      case null {};
    };
    
    fee;
  };

  // ===================== Price Algorithm =====================

  public func calculateRecommendedPrice(
    state : MarketplaceState,
    organismClass : Text,
    coherence : Float,
    governanceScore : Float,
    formaBalance : Float,
    activationCount : Nat,
    specializations : [Text],
  ) : Float {
    // Base price from class
    var basePrice : Float = switch organismClass {
      case "Avatar" 500.0;
      case "Entity" 250.0;
      case "Worker" 100.0;
      case _ 150.0;
    };
    
    // Coherence multiplier (0.75 to 1.0 maps to 1.0 to 2.0)
    let coherenceMultiplier = 1.0 + (coherence - 0.75) * 4.0;
    
    // Governance multiplier
    let governanceMultiplier = 0.8 + governanceScore * 0.4;
    
    // FORMA bonus
    let formaBonus = Float.sqrt(formaBalance) * 0.1;
    
    // Activation maturity
    let activationMultiplier = Float.min(1.5, 1.0 + activationCount.toFloat() * 0.001);
    
    // Specialization premium
    let specPremium = specializations.size().toFloat() * 10.0;
    
    // Market conditions adjustment
    let marketFactor = if (state.marketStats.activeListings > 100) 0.9 else 1.1;
    
    // Calculate final price
    var price = basePrice * coherenceMultiplier * governanceMultiplier * activationMultiplier * marketFactor;
    price := price + formaBonus + specPremium;
    
    // Round to 2 decimal places
    Float.floor(price * 100.0) / 100.0;
  };

  public func calculateDutchAuctionPrice(
    startPrice : Float,
    endPrice : Float,
    startTime : Int,
    endTime : Int,
    currentTime : Int,
  ) : Float {
    if (currentTime <= startTime) return startPrice;
    if (currentTime >= endTime) return endPrice;
    
    let elapsed = (currentTime - startTime).toFloat();
    let duration = (endTime - startTime).toFloat();
    let progress = elapsed / duration;
    
    let priceDrop = (startPrice - endPrice) * progress;
    Float.max(endPrice, startPrice - priceDrop);
  };

  // ===================== Listing Management =====================

  public func createListing(
    state : MarketplaceState,
    organismId : Text,
    seller : Principal,
    sellerOrganism : ?Text,
    pricingModel : PricingModel,
    price : Float,
    options : ListingOptions,
    visibility : ListingVisibility,
    description : Text,
    tags : [Text],
  ) : Result<Listing, Text> {
    // Validate price
    if (price <= 0.0) {
      return #err("Price must be positive");
    };
    
    // Check for existing active listing
    for (l in state.listings.vals()) {
      if (l.organismId == organismId and l.status == #Active) {
        return #err("Organism already has active listing");
      };
    };
    
    state.listingCounter += 1;
    let now = Time.now();
    
    let listing : Listing = {
      id = "listing-" # state.listingCounter.toText();
      organismId;
      seller;
      sellerOrganism;
      pricingModel;
      currentPrice = price;
      originalPrice = price;
      status = #Active;
      visibility;
      options;
      priceHistory = [{
        price;
        timestamp = now;
        event = "listed";
      }];
      viewCount = 0;
      watchCount = 0;
      bidCount = 0;
      offerCount = 0;
      createdAt = now;
      updatedAt = now;
      expiresAt = now + options.duration;
      soldAt = null;
      soldTo = null;
      finalPrice = null;
      tags;
      description;
      featured = false;
    };
    
    state.listings := arrayAppend(state.listings, [listing]);
    updateMarketStats(state);
    
    #ok(listing);
  };

  public func updateListingPrice(
    state : MarketplaceState,
    listingId : Text,
    newPrice : Float,
    seller : Principal,
  ) : Result<Listing, Text> {
    switch (findListing(state, listingId)) {
      case null #err("Listing not found");
      case (?listing) {
        if (listing.seller != seller) {
          return #err("Not the seller");
        };
        if (listing.status != #Active) {
          return #err("Listing not active");
        };
        if (listing.bidCount > 0 and newPrice > listing.currentPrice) {
          return #err("Cannot increase price with active bids");
        };
        
        let now = Time.now();
        let updated : Listing = {
          id = listing.id;
          organismId = listing.organismId;
          seller = listing.seller;
          sellerOrganism = listing.sellerOrganism;
          pricingModel = listing.pricingModel;
          currentPrice = newPrice;
          originalPrice = listing.originalPrice;
          status = listing.status;
          visibility = listing.visibility;
          options = listing.options;
          priceHistory = arrayAppend(listing.priceHistory, [{
            price = newPrice;
            timestamp = now;
            event = "price_change";
          }]);
          viewCount = listing.viewCount;
          watchCount = listing.watchCount;
          bidCount = listing.bidCount;
          offerCount = listing.offerCount;
          createdAt = listing.createdAt;
          updatedAt = now;
          expiresAt = listing.expiresAt;
          soldAt = listing.soldAt;
          soldTo = listing.soldTo;
          finalPrice = listing.finalPrice;
          tags = listing.tags;
          description = listing.description;
          featured = listing.featured;
        };
        
        upsertListing(state, updated);
        notifyWatchers(state, listingId, "price_change", newPrice);
        #ok(updated);
      };
    };
  };

  public func cancelListing(
    state : MarketplaceState,
    listingId : Text,
    seller : Principal,
  ) : Result<Listing, Text> {
    switch (findListing(state, listingId)) {
      case null #err("Listing not found");
      case (?listing) {
        if (listing.seller != seller) {
          return #err("Not the seller");
        };
        if (listing.status == #InEscrow) {
          return #err("Cannot cancel listing in escrow");
        };
        if (listing.status == #Sold) {
          return #err("Listing already sold");
        };
        
        // Cancel active bids
        cancelListingBids(state, listingId);
        
        // Cancel active offers
        cancelListingOffers(state, listingId);
        
        let now = Time.now();
        let updated : Listing = {
          id = listing.id;
          organismId = listing.organismId;
          seller = listing.seller;
          sellerOrganism = listing.sellerOrganism;
          pricingModel = listing.pricingModel;
          currentPrice = listing.currentPrice;
          originalPrice = listing.originalPrice;
          status = #Cancelled;
          visibility = listing.visibility;
          options = listing.options;
          priceHistory = listing.priceHistory;
          viewCount = listing.viewCount;
          watchCount = listing.watchCount;
          bidCount = listing.bidCount;
          offerCount = listing.offerCount;
          createdAt = listing.createdAt;
          updatedAt = now;
          expiresAt = listing.expiresAt;
          soldAt = listing.soldAt;
          soldTo = listing.soldTo;
          finalPrice = listing.finalPrice;
          tags = listing.tags;
          description = listing.description;
          featured = listing.featured;
        };
        
        upsertListing(state, updated);
        updateMarketStats(state);
        #ok(updated);
      };
    };
  };

  public func recordListingView(
    state : MarketplaceState,
    listingId : Text,
  ) : Result<(), Text> {
    switch (findListing(state, listingId)) {
      case null #err("Listing not found");
      case (?listing) {
        let updated : Listing = {
          id = listing.id;
          organismId = listing.organismId;
          seller = listing.seller;
          sellerOrganism = listing.sellerOrganism;
          pricingModel = listing.pricingModel;
          currentPrice = listing.currentPrice;
          originalPrice = listing.originalPrice;
          status = listing.status;
          visibility = listing.visibility;
          options = listing.options;
          priceHistory = listing.priceHistory;
          viewCount = listing.viewCount + 1;
          watchCount = listing.watchCount;
          bidCount = listing.bidCount;
          offerCount = listing.offerCount;
          createdAt = listing.createdAt;
          updatedAt = listing.updatedAt;
          expiresAt = listing.expiresAt;
          soldAt = listing.soldAt;
          soldTo = listing.soldTo;
          finalPrice = listing.finalPrice;
          tags = listing.tags;
          description = listing.description;
          featured = listing.featured;
        };
        upsertListing(state, updated);
        #ok(());
      };
    };
  };

  func findListing(state : MarketplaceState, id : Text) : ?Listing {
    arrayFind(state.listings, func(l : Listing) : Bool { l.id == id });
  };

  func upsertListing(state : MarketplaceState, updated : Listing) {
    var found = false;
    var newStore : [Listing] = [];
    for (l in state.listings.vals()) {
      if (l.id == updated.id) {
        newStore := arrayAppend(newStore, [updated]);
        found := true;
      } else {
        newStore := arrayAppend(newStore, [l]);
      };
    };
    if (not found) {
      newStore := arrayAppend(newStore, [updated]);
    };
    state.listings := newStore;
  };

  // ===================== Bid Management =====================

  public func placeBid(
    state : MarketplaceState,
    listingId : Text,
    bidder : Principal,
    bidderOrganism : ?Text,
    amount : Float,
    maxBid : ?Float,
    message : ?Text,
  ) : Result<Bid, Text> {
    switch (findListing(state, listingId)) {
      case null #err("Listing not found");
      case (?listing) {
        if (listing.status != #Active) {
          return #err("Listing not active");
        };
        if (listing.pricingModel != #Auction and listing.pricingModel != #ReserveAuction) {
          return #err("Listing does not accept bids");
        };
        if (listing.seller == bidder) {
          return #err("Cannot bid on own listing");
        };
        if (Time.now() > listing.expiresAt) {
          return #err("Auction has ended");
        };
        
        // Check minimum bid
        let minBid = switch listing.options.startingBid {
          case (?sb) sb;
          case null listing.currentPrice;
        };
        let increment = switch listing.options.bidIncrement {
          case (?bi) bi;
          case null 1.0;
        };
        let requiredBid = if (listing.bidCount == 0) minBid else listing.currentPrice + increment;
        
        if (amount < requiredBid) {
          return #err("Bid must be at least " # Float.toText(requiredBid));
        };
        
        // Mark previous bids as outbid
        outbidPreviousBids(state, listingId);
        
        state.bidCounter += 1;
        let now = Time.now();
        
        let bid : Bid = {
          id = "bid-" # state.bidCounter.toText();
          listingId;
          bidder;
          bidderOrganism;
          amount;
          maxBid;
          status = #Winning;
          timestamp = now;
          expiresAt = ?listing.expiresAt;
          message;
        };
        
        state.bids := arrayAppend(state.bids, [bid]);
        
        // Update listing
        var newExpiresAt = listing.expiresAt;
        
        // Check for auction extension
        switch (listing.options.extensionThreshold, listing.options.extensionDuration) {
          case (?threshold, ?duration) {
            if (listing.expiresAt - now < threshold) {
              newExpiresAt := now + duration;
            };
          };
          case _ {};
        };
        
        let updatedListing : Listing = {
          id = listing.id;
          organismId = listing.organismId;
          seller = listing.seller;
          sellerOrganism = listing.sellerOrganism;
          pricingModel = listing.pricingModel;
          currentPrice = amount;
          originalPrice = listing.originalPrice;
          status = listing.status;
          visibility = listing.visibility;
          options = listing.options;
          priceHistory = arrayAppend(listing.priceHistory, [{
            price = amount;
            timestamp = now;
            event = "bid";
          }]);
          viewCount = listing.viewCount;
          watchCount = listing.watchCount;
          bidCount = listing.bidCount + 1;
          offerCount = listing.offerCount;
          createdAt = listing.createdAt;
          updatedAt = now;
          expiresAt = newExpiresAt;
          soldAt = listing.soldAt;
          soldTo = listing.soldTo;
          finalPrice = listing.finalPrice;
          tags = listing.tags;
          description = listing.description;
          featured = listing.featured;
        };
        
        upsertListing(state, updatedListing);
        notifyWatchers(state, listingId, "new_bid", amount);
        
        #ok(bid);
      };
    };
  };

  public func cancelBid(
    state : MarketplaceState,
    bidId : Text,
    bidder : Principal,
  ) : Result<Bid, Text> {
    switch (findBid(state, bidId)) {
      case null #err("Bid not found");
      case (?bid) {
        if (bid.bidder != bidder) {
          return #err("Not the bidder");
        };
        if (bid.status != #Active and bid.status != #Winning) {
          return #err("Bid cannot be cancelled");
        };
        
        let updated : Bid = {
          id = bid.id;
          listingId = bid.listingId;
          bidder = bid.bidder;
          bidderOrganism = bid.bidderOrganism;
          amount = bid.amount;
          maxBid = bid.maxBid;
          status = #Cancelled;
          timestamp = bid.timestamp;
          expiresAt = bid.expiresAt;
          message = bid.message;
        };
        
        upsertBid(state, updated);
        
        // If was winning bid, update listing
        if (bid.status == #Winning) {
          revertToLastBid(state, bid.listingId);
        };
        
        #ok(updated);
      };
    };
  };

  func outbidPreviousBids(state : MarketplaceState, listingId : Text) {
    state.bids := arrayMap(state.bids, func(b : Bid) : Bid {
      if (b.listingId == listingId and (b.status == #Active or b.status == #Winning)) {
        {
          id = b.id;
          listingId = b.listingId;
          bidder = b.bidder;
          bidderOrganism = b.bidderOrganism;
          amount = b.amount;
          maxBid = b.maxBid;
          status = #Outbid;
          timestamp = b.timestamp;
          expiresAt = b.expiresAt;
          message = b.message;
        };
      } else b;
    });
  };

  func cancelListingBids(state : MarketplaceState, listingId : Text) {
    state.bids := arrayMap(state.bids, func(b : Bid) : Bid {
      if (b.listingId == listingId and (b.status == #Active or b.status == #Winning)) {
        {
          id = b.id;
          listingId = b.listingId;
          bidder = b.bidder;
          bidderOrganism = b.bidderOrganism;
          amount = b.amount;
          maxBid = b.maxBid;
          status = #Cancelled;
          timestamp = b.timestamp;
          expiresAt = b.expiresAt;
          message = b.message;
        };
      } else b;
    });
  };

  func revertToLastBid(state : MarketplaceState, listingId : Text) {
    var lastBid : ?Bid = null;
    var lastTimestamp : Int = 0;
    
    for (b in state.bids.vals()) {
      if (b.listingId == listingId and b.status == #Outbid and b.timestamp > lastTimestamp) {
        lastBid := ?b;
        lastTimestamp := b.timestamp;
      };
    };
    
    switch lastBid {
      case (?bid) {
        state.bids := arrayMap(state.bids, func(b : Bid) : Bid {
          if (b.id == bid.id) {
            {
              id = b.id;
              listingId = b.listingId;
              bidder = b.bidder;
              bidderOrganism = b.bidderOrganism;
              amount = b.amount;
              maxBid = b.maxBid;
              status = #Winning;
              timestamp = b.timestamp;
              expiresAt = b.expiresAt;
              message = b.message;
            };
          } else b;
        });
        
        // Update listing price
        switch (findListing(state, listingId)) {
          case (?listing) {
            let updated : Listing = {
              id = listing.id;
              organismId = listing.organismId;
              seller = listing.seller;
              sellerOrganism = listing.sellerOrganism;
              pricingModel = listing.pricingModel;
              currentPrice = bid.amount;
              originalPrice = listing.originalPrice;
              status = listing.status;
              visibility = listing.visibility;
              options = listing.options;
              priceHistory = listing.priceHistory;
              viewCount = listing.viewCount;
              watchCount = listing.watchCount;
              bidCount = listing.bidCount;
              offerCount = listing.offerCount;
              createdAt = listing.createdAt;
              updatedAt = Time.now();
              expiresAt = listing.expiresAt;
              soldAt = listing.soldAt;
              soldTo = listing.soldTo;
              finalPrice = listing.finalPrice;
              tags = listing.tags;
              description = listing.description;
              featured = listing.featured;
            };
            upsertListing(state, updated);
          };
          case null {};
        };
      };
      case null {};
    };
  };

  func findBid(state : MarketplaceState, id : Text) : ?Bid {
    arrayFind(state.bids, func(b : Bid) : Bool { b.id == id });
  };

  func upsertBid(state : MarketplaceState, updated : Bid) {
    var found = false;
    var newStore : [Bid] = [];
    for (b in state.bids.vals()) {
      if (b.id == updated.id) {
        newStore := arrayAppend(newStore, [updated]);
        found := true;
      } else {
        newStore := arrayAppend(newStore, [b]);
      };
    };
    if (not found) {
      newStore := arrayAppend(newStore, [updated]);
    };
    state.bids := newStore;
  };

  // ===================== Offer Management =====================

  public func makeOffer(
    state : MarketplaceState,
    listingId : Text,
    offerer : Principal,
    offererOrganism : ?Text,
    amount : Float,
    message : ?Text,
    expiresIn : Int,
  ) : Result<Offer, Text> {
    switch (findListing(state, listingId)) {
      case null #err("Listing not found");
      case (?listing) {
        if (listing.status != #Active) {
          return #err("Listing not active");
        };
        if (not listing.options.allowOffers and listing.pricingModel != #Negotiable) {
          return #err("Listing does not accept offers");
        };
        if (listing.seller == offerer) {
          return #err("Cannot offer on own listing");
        };
        
        state.offerCounter += 1;
        let now = Time.now();
        
        let offer : Offer = {
          id = "offer-" # state.offerCounter.toText();
          listingId;
          offerer;
          offererOrganism;
          amount;
          counterAmount = null;
          status = #Pending;
          message;
          sellerResponse = null;
          createdAt = now;
          respondedAt = null;
          expiresAt = now + expiresIn;
        };
        
        state.offers := arrayAppend(state.offers, [offer]);
        
        // Update listing offer count
        let updatedListing : Listing = {
          id = listing.id;
          organismId = listing.organismId;
          seller = listing.seller;
          sellerOrganism = listing.sellerOrganism;
          pricingModel = listing.pricingModel;
          currentPrice = listing.currentPrice;
          originalPrice = listing.originalPrice;
          status = listing.status;
          visibility = listing.visibility;
          options = listing.options;
          priceHistory = listing.priceHistory;
          viewCount = listing.viewCount;
          watchCount = listing.watchCount;
          bidCount = listing.bidCount;
          offerCount = listing.offerCount + 1;
          createdAt = listing.createdAt;
          updatedAt = now;
          expiresAt = listing.expiresAt;
          soldAt = listing.soldAt;
          soldTo = listing.soldTo;
          finalPrice = listing.finalPrice;
          tags = listing.tags;
          description = listing.description;
          featured = listing.featured;
        };
        upsertListing(state, updatedListing);
        
        // Check auto-accept
        switch listing.options.autoAcceptPrice {
          case (?autoPrice) {
            if (amount >= autoPrice) {
              ignore acceptOffer(state, offer.id, listing.seller, null);
            };
          };
          case null {};
        };
        
        #ok(offer);
      };
    };
  };

  public func acceptOffer(
    state : MarketplaceState,
    offerId : Text,
    seller : Principal,
    response : ?Text,
  ) : Result<Offer, Text> {
    switch (findOffer(state, offerId)) {
      case null #err("Offer not found");
      case (?offer) {
        if (offer.status != #Pending) {
          return #err("Offer not pending");
        };
        
        // Verify seller
        switch (findListing(state, offer.listingId)) {
          case null #err("Listing not found");
          case (?listing) {
            if (listing.seller != seller) {
              return #err("Not the seller");
            };
            
            let now = Time.now();
            let updated : Offer = {
              id = offer.id;
              listingId = offer.listingId;
              offerer = offer.offerer;
              offererOrganism = offer.offererOrganism;
              amount = offer.amount;
              counterAmount = offer.counterAmount;
              status = #Accepted;
              message = offer.message;
              sellerResponse = response;
              createdAt = offer.createdAt;
              respondedAt = ?now;
              expiresAt = offer.expiresAt;
            };
            
            upsertOffer(state, updated);
            
            // Create escrow
            ignore createEscrow(state, offer.listingId, "offer", offer.offerer, seller, offer.amount);
            
            #ok(updated);
          };
        };
      };
    };
  };

  public func rejectOffer(
    state : MarketplaceState,
    offerId : Text,
    seller : Principal,
    response : ?Text,
  ) : Result<Offer, Text> {
    switch (findOffer(state, offerId)) {
      case null #err("Offer not found");
      case (?offer) {
        if (offer.status != #Pending) {
          return #err("Offer not pending");
        };
        
        switch (findListing(state, offer.listingId)) {
          case null #err("Listing not found");
          case (?listing) {
            if (listing.seller != seller) {
              return #err("Not the seller");
            };
            
            let updated : Offer = {
              id = offer.id;
              listingId = offer.listingId;
              offerer = offer.offerer;
              offererOrganism = offer.offererOrganism;
              amount = offer.amount;
              counterAmount = offer.counterAmount;
              status = #Rejected;
              message = offer.message;
              sellerResponse = response;
              createdAt = offer.createdAt;
              respondedAt = ?Time.now();
              expiresAt = offer.expiresAt;
            };
            
            upsertOffer(state, updated);
            #ok(updated);
          };
        };
      };
    };
  };

  public func counterOffer(
    state : MarketplaceState,
    offerId : Text,
    seller : Principal,
    counterAmount : Float,
    response : ?Text,
  ) : Result<Offer, Text> {
    switch (findOffer(state, offerId)) {
      case null #err("Offer not found");
      case (?offer) {
        if (offer.status != #Pending) {
          return #err("Offer not pending");
        };
        
        switch (findListing(state, offer.listingId)) {
          case null #err("Listing not found");
          case (?listing) {
            if (listing.seller != seller) {
              return #err("Not the seller");
            };
            
            let updated : Offer = {
              id = offer.id;
              listingId = offer.listingId;
              offerer = offer.offerer;
              offererOrganism = offer.offererOrganism;
              amount = offer.amount;
              counterAmount = ?counterAmount;
              status = #Countered;
              message = offer.message;
              sellerResponse = response;
              createdAt = offer.createdAt;
              respondedAt = ?Time.now();
              expiresAt = offer.expiresAt;
            };
            
            upsertOffer(state, updated);
            #ok(updated);
          };
        };
      };
    };
  };

  func cancelListingOffers(state : MarketplaceState, listingId : Text) {
    state.offers := arrayMap(state.offers, func(o : Offer) : Offer {
      if (o.listingId == listingId and o.status == #Pending) {
        {
          id = o.id;
          listingId = o.listingId;
          offerer = o.offerer;
          offererOrganism = o.offererOrganism;
          amount = o.amount;
          counterAmount = o.counterAmount;
          status = #Cancelled;
          message = o.message;
          sellerResponse = ?"Listing cancelled";
          createdAt = o.createdAt;
          respondedAt = ?Time.now();
          expiresAt = o.expiresAt;
        };
      } else o;
    });
  };

  func findOffer(state : MarketplaceState, id : Text) : ?Offer {
    arrayFind(state.offers, func(o : Offer) : Bool { o.id == id });
  };

  func upsertOffer(state : MarketplaceState, updated : Offer) {
    var found = false;
    var newStore : [Offer] = [];
    for (o in state.offers.vals()) {
      if (o.id == updated.id) {
        newStore := arrayAppend(newStore, [updated]);
        found := true;
      } else {
        newStore := arrayAppend(newStore, [o]);
      };
    };
    if (not found) {
      newStore := arrayAppend(newStore, [updated]);
    };
    state.offers := newStore;
  };

  // ===================== Escrow Management =====================

  public func createEscrow(
    state : MarketplaceState,
    listingId : Text,
    transactionType : Text,
    buyer : Principal,
    seller : Principal,
    amount : Float,
  ) : Result<Escrow, Text> {
    state.escrowCounter += 1;
    let now = Time.now();
    let fee = calculateFee(state, amount, #TransactionFee);
    
    let escrow : Escrow = {
      id = "escrow-" # state.escrowCounter.toText();
      listingId;
      transactionType;
      parties = [
        { principal = buyer; organismId = null; role = "buyer"; hasApproved = false },
        { principal = seller; organismId = null; role = "seller"; hasApproved = false },
      ];
      amount;
      fee;
      status = #Pending;
      fundedAt = null;
      releasedAt = null;
      createdAt = now;
      deadline = now + 86400_000_000_000; // 24 hours
      conditions = ["Buyer confirms receipt", "Seller confirms transfer"];
      disputeReason = null;
      resolution = null;
    };
    
    state.escrows := arrayAppend(state.escrows, [escrow]);
    
    // Update listing status
    switch (findListing(state, listingId)) {
      case (?listing) {
        let updated : Listing = {
          id = listing.id;
          organismId = listing.organismId;
          seller = listing.seller;
          sellerOrganism = listing.sellerOrganism;
          pricingModel = listing.pricingModel;
          currentPrice = listing.currentPrice;
          originalPrice = listing.originalPrice;
          status = #InEscrow;
          visibility = listing.visibility;
          options = listing.options;
          priceHistory = listing.priceHistory;
          viewCount = listing.viewCount;
          watchCount = listing.watchCount;
          bidCount = listing.bidCount;
          offerCount = listing.offerCount;
          createdAt = listing.createdAt;
          updatedAt = now;
          expiresAt = listing.expiresAt;
          soldAt = listing.soldAt;
          soldTo = listing.soldTo;
          finalPrice = listing.finalPrice;
          tags = listing.tags;
          description = listing.description;
          featured = listing.featured;
        };
        upsertListing(state, updated);
      };
      case null {};
    };
    
    #ok(escrow);
  };

  public func fundEscrow(
    state : MarketplaceState,
    escrowId : Text,
    funder : Principal,
  ) : Result<Escrow, Text> {
    switch (findEscrow(state, escrowId)) {
      case null #err("Escrow not found");
      case (?escrow) {
        if (escrow.status != #Pending) {
          return #err("Escrow not pending");
        };
        
        // Verify funder is buyer
        var isBuyer = false;
        for (p in escrow.parties.vals()) {
          if (p.principal == funder and p.role == "buyer") {
            isBuyer := true;
          };
        };
        
        if (not isBuyer) {
          return #err("Only buyer can fund escrow");
        };
        
        let updated : Escrow = {
          id = escrow.id;
          listingId = escrow.listingId;
          transactionType = escrow.transactionType;
          parties = escrow.parties;
          amount = escrow.amount;
          fee = escrow.fee;
          status = #Funded;
          fundedAt = ?Time.now();
          releasedAt = escrow.releasedAt;
          createdAt = escrow.createdAt;
          deadline = escrow.deadline;
          conditions = escrow.conditions;
          disputeReason = escrow.disputeReason;
          resolution = escrow.resolution;
        };
        
        upsertEscrow(state, updated);
        #ok(updated);
      };
    };
  };

  public func approveEscrowRelease(
    state : MarketplaceState,
    escrowId : Text,
    approver : Principal,
  ) : Result<Escrow, Text> {
    switch (findEscrow(state, escrowId)) {
      case null #err("Escrow not found");
      case (?escrow) {
        if (escrow.status != #Funded) {
          return #err("Escrow not funded");
        };
        
        // Update approval
        var allApproved = true;
        let newParties = arrayMap(escrow.parties, func(p : EscrowParty) : EscrowParty {
          if (p.principal == approver) {
            { principal = p.principal; organismId = p.organismId; role = p.role; hasApproved = true };
          } else {
            if (not p.hasApproved) allApproved := false;
            p;
          }
        });
        
        // Check if buyer approval (main condition)
        var buyerApproved = false;
        for (p in newParties.vals()) {
          if (p.role == "buyer" and p.hasApproved) {
            buyerApproved := true;
          };
        };
        
        let newStatus = if (buyerApproved) #Released else #Funded;
        
        let updated : Escrow = {
          id = escrow.id;
          listingId = escrow.listingId;
          transactionType = escrow.transactionType;
          parties = newParties;
          amount = escrow.amount;
          fee = escrow.fee;
          status = newStatus;
          fundedAt = escrow.fundedAt;
          releasedAt = if (newStatus == #Released) ?Time.now() else escrow.releasedAt;
          createdAt = escrow.createdAt;
          deadline = escrow.deadline;
          conditions = escrow.conditions;
          disputeReason = escrow.disputeReason;
          resolution = escrow.resolution;
        };
        
        upsertEscrow(state, updated);
        
        // If released, complete the transaction
        if (newStatus == #Released) {
          ignore completeTransaction(state, escrow.listingId, escrowId);
        };
        
        #ok(updated);
      };
    };
  };

  public func disputeEscrow(
    state : MarketplaceState,
    escrowId : Text,
    disputer : Principal,
    reason : Text,
  ) : Result<Escrow, Text> {
    switch (findEscrow(state, escrowId)) {
      case null #err("Escrow not found");
      case (?escrow) {
        if (escrow.status != #Funded and escrow.status != #Pending) {
          return #err("Escrow cannot be disputed");
        };
        
        // Verify disputer is party
        var isParty = false;
        for (p in escrow.parties.vals()) {
          if (p.principal == disputer) isParty := true;
        };
        
        if (not isParty) {
          return #err("Only parties can dispute");
        };
        
        let updated : Escrow = {
          id = escrow.id;
          listingId = escrow.listingId;
          transactionType = escrow.transactionType;
          parties = escrow.parties;
          amount = escrow.amount;
          fee = escrow.fee;
          status = #Disputed;
          fundedAt = escrow.fundedAt;
          releasedAt = escrow.releasedAt;
          createdAt = escrow.createdAt;
          deadline = escrow.deadline;
          conditions = escrow.conditions;
          disputeReason = ?reason;
          resolution = escrow.resolution;
        };
        
        upsertEscrow(state, updated);
        #ok(updated);
      };
    };
  };

  func findEscrow(state : MarketplaceState, id : Text) : ?Escrow {
    arrayFind(state.escrows, func(e : Escrow) : Bool { e.id == id });
  };

  func upsertEscrow(state : MarketplaceState, updated : Escrow) {
    var found = false;
    var newStore : [Escrow] = [];
    for (e in state.escrows.vals()) {
      if (e.id == updated.id) {
        newStore := arrayAppend(newStore, [updated]);
        found := true;
      } else {
        newStore := arrayAppend(newStore, [e]);
      };
    };
    if (not found) {
      newStore := arrayAppend(newStore, [updated]);
    };
    state.escrows := newStore;
  };

  // ===================== Transaction Completion =====================

  func completeTransaction(
    state : MarketplaceState,
    listingId : Text,
    escrowId : Text,
  ) : Result<Transaction, Text> {
    switch (findListing(state, listingId)) {
      case null #err("Listing not found");
      case (?listing) {
        switch (findEscrow(state, escrowId)) {
          case null #err("Escrow not found");
          case (?escrow) {
            state.transactionCounter += 1;
            let now = Time.now();
            
            var buyer : Principal = listing.seller; // Default
            for (p in escrow.parties.vals()) {
              if (p.role == "buyer") buyer := p.principal;
            };
            
            let transactionType : TransactionType = switch escrow.transactionType {
              case "auction" #AuctionWin;
              case "offer" #OfferAccepted;
              case "bundle" #BundleSale;
              case _ #DirectSale;
            };
            
            let transaction : Transaction = {
              id = "tx-" # state.transactionCounter.toText();
              transactionType;
              listingId = ?listingId;
              escrowId = ?escrowId;
              organismId = listing.organismId;
              seller = listing.seller;
              buyer;
              amount = escrow.amount;
              fee = escrow.fee;
              netAmount = escrow.amount - escrow.fee;
              timestamp = now;
              metadata = [];
            };
            
            state.transactions := arrayAppend(state.transactions, [transaction]);
            state.collectedFees := state.collectedFees + escrow.fee;
            
            // Update listing
            let updatedListing : Listing = {
              id = listing.id;
              organismId = listing.organismId;
              seller = listing.seller;
              sellerOrganism = listing.sellerOrganism;
              pricingModel = listing.pricingModel;
              currentPrice = listing.currentPrice;
              originalPrice = listing.originalPrice;
              status = #Sold;
              visibility = listing.visibility;
              options = listing.options;
              priceHistory = arrayAppend(listing.priceHistory, [{
                price = escrow.amount;
                timestamp = now;
                event = "sold";
              }]);
              viewCount = listing.viewCount;
              watchCount = listing.watchCount;
              bidCount = listing.bidCount;
              offerCount = listing.offerCount;
              createdAt = listing.createdAt;
              updatedAt = now;
              expiresAt = listing.expiresAt;
              soldAt = ?now;
              soldTo = ?buyer;
              finalPrice = ?escrow.amount;
              tags = listing.tags;
              description = listing.description;
              featured = listing.featured;
            };
            
            upsertListing(state, updatedListing);
            updateMarketStats(state);
            
            #ok(transaction);
          };
        };
      };
    };
  };

  // ===================== Watchlist Management =====================

  public func addToWatchlist(
    state : MarketplaceState,
    listingId : Text,
    watcher : Principal,
    watcherOrganism : ?Text,
    priceAlert : ?Float,
    notifyOnBid : Bool,
    notifyOnPriceChange : Bool,
    notifyOnExpiry : Bool,
  ) : Result<WatchlistEntry, Text> {
    switch (findListing(state, listingId)) {
      case null #err("Listing not found");
      case (?listing) {
        // Check if already watching
        for (w in state.watchlists.vals()) {
          if (w.listingId == listingId and w.watcher == watcher) {
            return #err("Already watching");
          };
        };
        
        let entry : WatchlistEntry = {
          listingId;
          watcher;
          watcherOrganism;
          addedAt = Time.now();
          priceAlert;
          notifyOnBid;
          notifyOnPriceChange;
          notifyOnExpiry;
        };
        
        state.watchlists := arrayAppend(state.watchlists, [entry]);
        
        // Update listing watch count
        let updatedListing : Listing = {
          id = listing.id;
          organismId = listing.organismId;
          seller = listing.seller;
          sellerOrganism = listing.sellerOrganism;
          pricingModel = listing.pricingModel;
          currentPrice = listing.currentPrice;
          originalPrice = listing.originalPrice;
          status = listing.status;
          visibility = listing.visibility;
          options = listing.options;
          priceHistory = listing.priceHistory;
          viewCount = listing.viewCount;
          watchCount = listing.watchCount + 1;
          bidCount = listing.bidCount;
          offerCount = listing.offerCount;
          createdAt = listing.createdAt;
          updatedAt = listing.updatedAt;
          expiresAt = listing.expiresAt;
          soldAt = listing.soldAt;
          soldTo = listing.soldTo;
          finalPrice = listing.finalPrice;
          tags = listing.tags;
          description = listing.description;
          featured = listing.featured;
        };
        upsertListing(state, updatedListing);
        
        #ok(entry);
      };
    };
  };

  public func removeFromWatchlist(
    state : MarketplaceState,
    listingId : Text,
    watcher : Principal,
  ) : Result<(), Text> {
    var found = false;
    state.watchlists := arrayFilter(state.watchlists, func(w : WatchlistEntry) : Bool {
      if (w.listingId == listingId and w.watcher == watcher) {
        found := true;
        false;
      } else true;
    });
    
    if (found) {
      // Update listing watch count
      switch (findListing(state, listingId)) {
        case (?listing) {
          let updatedListing : Listing = {
            id = listing.id;
            organismId = listing.organismId;
            seller = listing.seller;
            sellerOrganism = listing.sellerOrganism;
            pricingModel = listing.pricingModel;
            currentPrice = listing.currentPrice;
            originalPrice = listing.originalPrice;
            status = listing.status;
            visibility = listing.visibility;
            options = listing.options;
            priceHistory = listing.priceHistory;
            viewCount = listing.viewCount;
            watchCount = if (listing.watchCount > 0) listing.watchCount - 1 else 0;
            bidCount = listing.bidCount;
            offerCount = listing.offerCount;
            createdAt = listing.createdAt;
            updatedAt = listing.updatedAt;
            expiresAt = listing.expiresAt;
            soldAt = listing.soldAt;
            soldTo = listing.soldTo;
            finalPrice = listing.finalPrice;
            tags = listing.tags;
            description = listing.description;
            featured = listing.featured;
          };
          upsertListing(state, updatedListing);
        };
        case null {};
      };
      #ok(());
    } else {
      #err("Not watching this listing");
    };
  };

  func notifyWatchers(state : MarketplaceState, listingId : Text, event : Text, value : Float) {
    // In a real implementation, this would queue notifications
    // For now, we just track the event for retrieval
  };

  public func getWatchlistForUser(
    state : MarketplaceState,
    watcher : Principal,
  ) : [WatchlistEntry] {
    arrayFilter(state.watchlists, func(w : WatchlistEntry) : Bool {
      w.watcher == watcher
    });
  };

  // ===================== Market Statistics =====================

  func updateMarketStats(state : MarketplaceState) {
    let activeListings = arrayFilter(state.listings, func(l : Listing) : Bool {
      l.status == #Active
    });
    
    let now = Time.now();
    let day = 86400_000_000_000;
    let week = day * 7;
    let month = day * 30;
    
    var volume24h : Float = 0.0;
    var volume7d : Float = 0.0;
    var volume30d : Float = 0.0;
    var priceSum : Float = 0.0;
    var floorPrice : Float = Float.fromInt(1000000); // Large initial value
    var ceilingPrice : Float = 0.0;
    var uniqueSellers : [Principal] = [];
    var uniqueBuyers : [Principal] = [];
    
    // Calculate volumes from transactions
    for (t in state.transactions.vals()) {
      if (now - t.timestamp <= day) volume24h += t.amount;
      if (now - t.timestamp <= week) volume7d += t.amount;
      if (now - t.timestamp <= month) volume30d += t.amount;
      
      // Track unique users
      var foundSeller = false;
      for (s in uniqueSellers.vals()) {
        if (s == t.seller) foundSeller := true;
      };
      if (not foundSeller) uniqueSellers := arrayAppend(uniqueSellers, [t.seller]);
      
      var foundBuyer = false;
      for (b in uniqueBuyers.vals()) {
        if (b == t.buyer) foundBuyer := true;
      };
      if (not foundBuyer) uniqueBuyers := arrayAppend(uniqueBuyers, [t.buyer]);
    };
    
    // Calculate price stats from active listings
    for (l in activeListings.vals()) {
      priceSum += l.currentPrice;
      if (l.currentPrice < floorPrice) floorPrice := l.currentPrice;
      if (l.currentPrice > ceilingPrice) ceilingPrice := l.currentPrice;
    };
    
    let avgPrice = if (activeListings.size() > 0) 
      priceSum / activeListings.size().toFloat()
    else 0.0;
    
    state.marketStats := {
      totalListings = state.listings.size();
      activeListings = activeListings.size();
      totalVolume24h = volume24h;
      totalVolume7d = volume7d;
      totalVolume30d = volume30d;
      avgPrice;
      medianPrice = avgPrice; // Simplified - would need sorting
      floorPrice = if (floorPrice == Float.fromInt(1000000)) 0.0 else floorPrice;
      ceilingPrice;
      totalTransactions = state.transactions.size();
      uniqueSellers = uniqueSellers.size();
      uniqueBuyers = uniqueBuyers.size();
      lastUpdated = now;
    };
  };

  public func getMarketStats(state : MarketplaceState) : MarketStats {
    state.marketStats;
  };

  public func getTrendingListings(
    state : MarketplaceState,
    limit : Nat,
  ) : [TrendingItem] {
    // Calculate trend score based on views, bids, and recency
    var trending : [TrendingItem] = [];
    var rank : Nat = 1;
    
    let activeListings = arrayFilter(state.listings, func(l : Listing) : Bool {
      l.status == #Active
    });
    
    // Simplified trending calculation
    for (l in activeListings.vals()) {
      let recencyFactor = 1.0 / (1.0 + (Time.now() - l.createdAt).toFloat() / 86400_000_000_000.0);
      let activityFactor = l.viewCount.toFloat() + l.bidCount.toFloat() * 10.0;
      let trendScore = recencyFactor * activityFactor;
      
      let item : TrendingItem = {
        organismId = l.organismId;
        listingId = ?l.id;
        name = ""; // Would need organism name from external source
        class_ = "";
        trendScore;
        viewCount = l.viewCount;
        bidCount = l.bidCount;
        priceChange = if (l.priceHistory.size() > 1)
          l.currentPrice - l.priceHistory[0].price
        else 0.0;
        rank;
      };
      
      trending := arrayAppend(trending, [item]);
      rank += 1;
    };
    
    // Would sort by trendScore here
    // Return top N
    if (trending.size() > limit) {
      var result : [TrendingItem] = [];
      var i : Nat = 0;
      while (i < limit) {
        result := arrayAppend(result, [trending[i]]);
        i += 1;
      };
      result;
    } else {
      trending;
    };
  };

  // ===================== Query Functions =====================

  public func getActiveListings(
    state : MarketplaceState,
    page : Nat,
    pageSize : Nat,
  ) : [Listing] {
    let active = arrayFilter(state.listings, func(l : Listing) : Bool {
      l.status == #Active and l.visibility == #Public
    });
    
    let start = page * pageSize;
    if (start >= active.size()) return [];
    
    var result : [Listing] = [];
    var i = start;
    while (i < active.size() and i < start + pageSize) {
      result := arrayAppend(result, [active[i]]);
      i += 1;
    };
    result;
  };

  public func getListingsByOrganism(
    state : MarketplaceState,
    organismId : Text,
  ) : [Listing] {
    arrayFilter(state.listings, func(l : Listing) : Bool {
      l.organismId == organismId
    });
  };

  public func getListingsBySeller(
    state : MarketplaceState,
    seller : Principal,
  ) : [Listing] {
    arrayFilter(state.listings, func(l : Listing) : Bool {
      l.seller == seller
    });
  };

  public func getBidsForListing(
    state : MarketplaceState,
    listingId : Text,
  ) : [Bid] {
    arrayFilter(state.bids, func(b : Bid) : Bool {
      b.listingId == listingId
    });
  };

  public func getOffersForListing(
    state : MarketplaceState,
    listingId : Text,
  ) : [Offer] {
    arrayFilter(state.offers, func(o : Offer) : Bool {
      o.listingId == listingId
    });
  };

  public func getTransactionsForOrganism(
    state : MarketplaceState,
    organismId : Text,
  ) : [Transaction] {
    arrayFilter(state.transactions, func(t : Transaction) : Bool {
      t.organismId == organismId
    });
  };

  public func getTransactionsForUser(
    state : MarketplaceState,
    user : Principal,
  ) : [Transaction] {
    arrayFilter(state.transactions, func(t : Transaction) : Bool {
      t.seller == user or t.buyer == user
    });
  };

  // ===================== Cleanup Functions =====================

  public func expireListings(state : MarketplaceState) {
    let now = Time.now();
    state.listings := arrayMap(state.listings, func(l : Listing) : Listing {
      if (l.status == #Active and now > l.expiresAt) {
        // Cancel bids and offers
        cancelListingBids(state, l.id);
        cancelListingOffers(state, l.id);
        
        {
          id = l.id;
          organismId = l.organismId;
          seller = l.seller;
          sellerOrganism = l.sellerOrganism;
          pricingModel = l.pricingModel;
          currentPrice = l.currentPrice;
          originalPrice = l.originalPrice;
          status = #Expired;
          visibility = l.visibility;
          options = l.options;
          priceHistory = l.priceHistory;
          viewCount = l.viewCount;
          watchCount = l.watchCount;
          bidCount = l.bidCount;
          offerCount = l.offerCount;
          createdAt = l.createdAt;
          updatedAt = now;
          expiresAt = l.expiresAt;
          soldAt = l.soldAt;
          soldTo = l.soldTo;
          finalPrice = l.finalPrice;
          tags = l.tags;
          description = l.description;
          featured = l.featured;
        };
      } else l;
    });
    
    // Expire pending offers
    state.offers := arrayMap(state.offers, func(o : Offer) : Offer {
      if (o.status == #Pending and now > o.expiresAt) {
        {
          id = o.id;
          listingId = o.listingId;
          offerer = o.offerer;
          offererOrganism = o.offererOrganism;
          amount = o.amount;
          counterAmount = o.counterAmount;
          status = #Expired;
          message = o.message;
          sellerResponse = o.sellerResponse;
          createdAt = o.createdAt;
          respondedAt = o.respondedAt;
          expiresAt = o.expiresAt;
        };
      } else o;
    });
    
    updateMarketStats(state);
  };

  public func finalizeAuctions(state : MarketplaceState) {
    let now = Time.now();
    
    for (l in state.listings.vals()) {
      if ((l.pricingModel == #Auction or l.pricingModel == #ReserveAuction) and
          l.status == #Active and now > l.expiresAt) {
        // Find winning bid
        var winningBid : ?Bid = null;
        for (b in state.bids.vals()) {
          if (b.listingId == l.id and b.status == #Winning) {
            winningBid := ?b;
          };
        };
        
        switch winningBid {
          case (?bid) {
            // Check reserve price
            let meetsReserve = switch l.options.reservePrice {
              case (?rp) bid.amount >= rp;
              case null true;
            };
            
            if (meetsReserve) {
              // Mark bid as won
              state.bids := arrayMap(state.bids, func(b : Bid) : Bid {
                if (b.id == bid.id) {
                  {
                    id = b.id;
                    listingId = b.listingId;
                    bidder = b.bidder;
                    bidderOrganism = b.bidderOrganism;
                    amount = b.amount;
                    maxBid = b.maxBid;
                    status = #Won;
                    timestamp = b.timestamp;
                    expiresAt = b.expiresAt;
                    message = b.message;
                  };
                } else if (b.listingId == l.id) {
                  {
                    id = b.id;
                    listingId = b.listingId;
                    bidder = b.bidder;
                    bidderOrganism = b.bidderOrganism;
                    amount = b.amount;
                    maxBid = b.maxBid;
                    status = #Lost;
                    timestamp = b.timestamp;
                    expiresAt = b.expiresAt;
                    message = b.message;
                  };
                } else b;
              });
              
              // Create escrow
              ignore createEscrow(state, l.id, "auction", bid.bidder, l.seller, bid.amount);
            };
          };
          case null {
            // No bids - expire listing
          };
        };
      };
    };
  };

};
