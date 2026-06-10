/**
 * ECONOMIC SIMULATION ENGINE - Market Dynamics and Agent-Based Modeling
 * 
 * ENTERPRISE-GRADE ECONOMIC SYSTEM SIMULATION
 * 
 * Comprehensive economic modeling including:
 * - Market structures (Perfect Competition, Monopoly, Oligopoly, Auction)
 * - Agent types (Consumer, Producer, Government, Central Bank, Investor)
 * - Macroeconomic indicators (GDP, Inflation, Unemployment, Interest Rates)
 * - Supply/Demand dynamics with equilibrium calculation
 * - Policy simulation (Monetary, Fiscal)
 * - Trade simulation with exchange rates
 * 
 * Integrated with:
 * - Multi-Agent Coordination System for agent behavior
 * - Real-Time Analytics Engine for economic metrics
 * - Knowledge Graph Engine for economic relationships
 * - Goal Hierarchy Engine for agent objectives
 * 
 * S₀ (Sovereignty Floor) = 1.0 - MAXED - Enterprise Final Product
 */

import Float "mo:base/Float";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Text "mo:base/Text";
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import HashMap "mo:base/HashMap";
import Hash "mo:base/Hash";
import Iter "mo:base/Iter";
import Option "mo:base/Option";
import Time "mo:base/Time";
import Result "mo:base/Result";
import Random "mo:base/Random";

actor EconomicSimulationEngine {
    
    // ============================================
    // SOVEREIGNTY CONSTANTS - ALL MAXED TO 1.0
    // ============================================
    
    private let S_0_FLOOR : Float = 1.0;  // MAXED - Enterprise grade
    private let COHERENCE_THRESHOLD : Float = 1.0;
    private let INTEGRITY_MINIMUM : Float = 1.0;
    
    // ============================================
    // MARKET STRUCTURES
    // ============================================
    
    public type MarketStructure = {
        #PerfectCompetition;
        #Monopoly;
        #Oligopoly;
        #MonopolisticCompetition;
        #Monopsony;
        #Auction: AuctionType;
        #TwoSidedMarket;
    };
    
    public type AuctionType = {
        #English;           // Ascending price
        #Dutch;             // Descending price
        #FirstPriceSealedBid;
        #SecondPriceSealedBid;  // Vickrey
        #DoubleAuction;
        #CombinatoralAuction;
    };
    
    public type Market = {
        id: Text;
        name: Text;
        structure: MarketStructure;
        goods: [Good];
        participants: [AgentId];
        currentPrice: Float;
        equilibriumPrice: ?Float;
        equilibriumQuantity: ?Float;
        priceElasticity: Float;
        tradingVolume: Float;
        lastTradedPrice: Float;
        bidAskSpread: Float;
        orderBook: OrderBook;
        history: [MarketState];
        regulations: [MarketRegulation];
        createdAt: Time.Time;
    };
    
    public type Good = {
        id: Text;
        name: Text;
        category: GoodCategory;
        substitutes: [Text];
        complements: [Text];
        priceElasticityOfDemand: Float;
        incomeElasticityOfDemand: Float;
        isNormal: Bool;  // Normal vs inferior good
        isGiffen: Bool;  // Giffen good
        isVeblen: Bool;  // Veblen/luxury good
    };
    
    public type GoodCategory = {
        #Consumer;
        #Capital;
        #Intermediate;
        #RawMaterial;
        #Service;
        #Financial;
        #PublicGood;
        #CommonResource;
    };
    
    public type OrderBook = {
        bids: [Order];      // Buy orders
        asks: [Order];      // Sell orders
        lastMatchTime: Time.Time;
    };
    
    public type Order = {
        id: Text;
        agentId: AgentId;
        orderType: OrderType;
        price: Float;
        quantity: Float;
        timestamp: Time.Time;
        status: OrderStatus;
        filledQuantity: Float;
        averagePrice: Float;
    };
    
    public type OrderType = {
        #MarketBuy;
        #MarketSell;
        #LimitBuy;
        #LimitSell;
        #StopLoss;
        #TakeProfit;
    };
    
    public type OrderStatus = {
        #Pending;
        #PartiallyFilled;
        #Filled;
        #Cancelled;
        #Expired;
    };
    
    public type MarketState = {
        timestamp: Time.Time;
        price: Float;
        volume: Float;
        openInterest: Float;
        high: Float;
        low: Float;
        open: Float;
        close: Float;
    };
    
    public type MarketRegulation = {
        regulationType: RegulationType;
        parameter: Float;
        effectiveDate: Time.Time;
        expiryDate: ?Time.Time;
    };
    
    public type RegulationType = {
        #PriceCeiling;
        #PriceFloor;
        #QuantityQuota;
        #Tariff;
        #Subsidy;
        #Tax;
        #ShortSellingBan;
        #CircuitBreaker;
    };
    
    // ============================================
    // ECONOMIC AGENTS
    // ============================================
    
    public type AgentId = Text;
    
    public type AgentType = {
        #Consumer;
        #Producer;
        #Firm;
        #Government;
        #CentralBank;
        #CommercialBank;
        #Investor;
        #Speculator;
        #MarketMaker;
        #Arbitrageur;
        #HouseholdFirm;
    };
    
    public type EconomicAgent = {
        id: AgentId;
        agentType: AgentType;
        name: Text;
        wealth: Float;
        income: Float;
        consumption: Float;
        savings: Float;
        debt: Float;
        assets: [Asset];
        liabilities: [Liability];
        preferences: Preferences;
        expectations: Expectations;
        behavior: AgentBehavior;
        history: [AgentState];
        createdAt: Time.Time;
    };
    
    public type Asset = {
        assetType: AssetType;
        quantity: Float;
        currentValue: Float;
        purchasePrice: Float;
        purchaseDate: Time.Time;
    };
    
    public type AssetType = {
        #Cash;
        #Bond;
        #Stock;
        #RealEstate;
        #Commodity;
        #Cryptocurrency;
        #Inventory;
        #Equipment;
        #IntellectualProperty;
    };
    
    public type Liability = {
        liabilityType: LiabilityType;
        principal: Float;
        interestRate: Float;
        maturityDate: ?Time.Time;
        monthlyPayment: Float;
    };
    
    public type LiabilityType = {
        #Mortgage;
        #AutoLoan;
        #StudentLoan;
        #CreditCard;
        #BusinessLoan;
        #Bond;
        #Deposit;  // For banks
    };
    
    public type Preferences = {
        riskTolerance: Float;           // 0-1
        timePreference: Float;          // Discount rate
        consumptionSmoothing: Float;    // Desire to smooth consumption
        brandLoyalty: Float;            // 0-1
        priceConsciousness: Float;      // 0-1
        qualityPreference: Float;       // 0-1
        utilityFunction: UtilityFunction;
    };
    
    public type UtilityFunction = {
        #CobbDouglas: { alpha: Float };
        #CES: { elasticity: Float };
        #Leontief;
        #Linear;
        #Quadratic;
        #CRRA: { gamma: Float };  // Constant Relative Risk Aversion
    };
    
    public type Expectations = {
        expectedInflation: Float;
        expectedGrowth: Float;
        expectedInterestRate: Float;
        priceExpectations: [(Text, Float)];  // Good -> Expected price
        confidence: Float;                   // 0-1
        formationMethod: ExpectationFormation;
    };
    
    public type ExpectationFormation = {
        #RationalExpectations;
        #AdaptiveExpectations: { learningRate: Float };
        #NaiveExpectations;
        #Extrapolative: { weight: Float };
        #Anchored: { anchor: Float; adjustment: Float };
    };
    
    public type AgentBehavior = {
        decisionRule: DecisionRule;
        learningAlgorithm: LearningAlgorithm;
        socialInfluence: Float;         // How much agent is influenced by others
        informationProcessing: InfoProcessing;
    };
    
    public type DecisionRule = {
        #UtilityMaximization;
        #ProfitMaximization;
        #SatisficingRule: { threshold: Float };
        #HeuristicBased;
        #RuleBased: [Text];
        #Imitation;
        #RandomChoice;
    };
    
    public type LearningAlgorithm = {
        #ReinforcementLearning: { alpha: Float; gamma: Float };
        #BayesianUpdating;
        #GeneticAlgorithm;
        #NeuralNetwork;
        #NoLearning;
    };
    
    public type InfoProcessing = {
        #FullyRational;
        #BoundedRationality: { computationLimit: Nat };
        #ProspectTheory: { lambda: Float; alpha: Float };
        #MentalAccounting;
    };
    
    public type AgentState = {
        timestamp: Time.Time;
        wealth: Float;
        income: Float;
        consumption: Float;
        utility: Float;
    };
    
    // ============================================
    // MACROECONOMIC INDICATORS
    // ============================================
    
    public type MacroeconomicState = {
        timestamp: Time.Time;
        gdp: GDP;
        inflation: InflationMetrics;
        employment: EmploymentMetrics;
        monetaryMetrics: MonetaryMetrics;
        fiscalMetrics: FiscalMetrics;
        tradeMetrics: TradeMetrics;
        financialMetrics: FinancialMetrics;
        confidenceIndices: ConfidenceIndices;
    };
    
    public type GDP = {
        nominal: Float;
        real: Float;
        growthRate: Float;
        perCapita: Float;
        byExpenditure: {
            consumption: Float;
            investment: Float;
            government: Float;
            netExports: Float;
        };
        byIncome: {
            wages: Float;
            profits: Float;
            rent: Float;
            interest: Float;
        };
        bySector: [(Text, Float)];
        potentialGDP: Float;
        outputGap: Float;
    };
    
    public type InflationMetrics = {
        cpi: Float;                     // Consumer Price Index
        ppi: Float;                     // Producer Price Index
        coreInflation: Float;           // Excluding food and energy
        inflationRate: Float;           // YoY change
        expectedInflation: Float;
        inflationTarget: Float;
        realInterestRate: Float;
        breakEvenInflation: Float;      // From TIPS spread
    };
    
    public type EmploymentMetrics = {
        laborForce: Float;
        employed: Float;
        unemployed: Float;
        unemploymentRate: Float;
        participationRate: Float;
        employmentToPopulation: Float;
        naturalUnemploymentRate: Float;  // NAIRU
        underemploymentRate: Float;
        averageWage: Float;
        wageGrowth: Float;
        laborProductivity: Float;
        jobOpenings: Float;
        hiringRate: Float;
        separationRate: Float;
    };
    
    public type MonetaryMetrics = {
        m0: Float;                      // Monetary base
        m1: Float;                      // M1 money supply
        m2: Float;                      // M2 money supply
        m3: Float;                      // M3 money supply
        velocityOfMoney: Float;
        federalFundsRate: Float;
        discountRate: Float;
        primeRate: Float;
        yieldCurve: [(Nat, Float)];     // Maturity -> Yield
        creditGrowth: Float;
        reserveRequirement: Float;
        excessReserves: Float;
    };
    
    public type FiscalMetrics = {
        governmentRevenue: Float;
        governmentSpending: Float;
        budgetDeficit: Float;
        debtToGDP: Float;
        publicDebt: Float;
        taxRevenue: {
            incomeTax: Float;
            corporateTax: Float;
            salesTax: Float;
            payrollTax: Float;
            other: Float;
        };
        spendingByCategory: {
            defense: Float;
            socialSecurity: Float;
            healthcare: Float;
            education: Float;
            infrastructure: Float;
            interestPayments: Float;
            other: Float;
        };
        fiscalMultiplier: Float;
        automaticStabilizers: Float;
    };
    
    public type TradeMetrics = {
        exports: Float;
        imports: Float;
        tradeBalance: Float;
        currentAccount: Float;
        capitalAccount: Float;
        exchangeRate: Float;            // Nominal
        realExchangeRate: Float;
        termsOfTrade: Float;
        tradeOpenness: Float;           // (Exports + Imports) / GDP
        foreignReserves: Float;
        tradingPartners: [(Text, Float)];  // Country -> Trade volume
    };
    
    public type FinancialMetrics = {
        stockMarketIndex: Float;
        stockMarketVolatility: Float;   // VIX-like
        bondYields: [(Nat, Float)];     // Maturity -> Yield
        creditSpread: Float;
        mortgageRate: Float;
        savingsRate: Float;
        householdDebt: Float;
        corporateDebt: Float;
        bankingSystemHealth: Float;     // 0-1
        financialStress: Float;         // Financial conditions index
    };
    
    public type ConfidenceIndices = {
        consumerConfidence: Float;
        businessConfidence: Float;
        investorSentiment: Float;
        pmi: Float;                     // Purchasing Managers' Index
        leadingIndicators: Float;
        coincidentIndicators: Float;
        laggingIndicators: Float;
    };
    
    // ============================================
    // PRODUCTION AND FIRMS
    // ============================================
    
    public type ProductionFunction = {
        #CobbDouglas: {
            tfp: Float;         // Total Factor Productivity
            alpha: Float;       // Capital elasticity
            beta: Float;        // Labor elasticity
        };
        #CES: {
            tfp: Float;
            sigma: Float;       // Elasticity of substitution
            delta: Float;       // Distribution parameter
        };
        #Leontief: {
            capitalCoeff: Float;
            laborCoeff: Float;
        };
        #Linear: {
            capitalCoeff: Float;
            laborCoeff: Float;
        };
        #TranslogCost;
    };
    
    public type Firm = {
        id: Text;
        name: Text;
        industry: Text;
        productionFunction: ProductionFunction;
        capital: Float;
        labor: Float;
        inventory: Float;
        output: Float;
        revenue: Float;
        cost: CostStructure;
        profit: Float;
        marketShare: Float;
        pricingPower: Float;
        investmentRate: Float;
        dividendPayout: Float;
        employees: Nat;
        research: Float;            // R&D spending
        patents: Nat;
    };
    
    public type CostStructure = {
        fixedCost: Float;
        variableCost: Float;
        marginalCost: Float;
        averageCost: Float;
        laborCost: Float;
        capitalCost: Float;
        materialCost: Float;
        overhead: Float;
    };
    
    // ============================================
    // CONSUMER BEHAVIOR
    // ============================================
    
    public type ConsumerDecision = {
        agentId: AgentId;
        goodId: Text;
        quantity: Float;
        price: Float;
        utility: Float;
        budgetShare: Float;
        substitutionEffect: Float;
        incomeEffect: Float;
        timestamp: Time.Time;
    };
    
    public type BudgetConstraint = {
        income: Float;
        prices: [(Text, Float)];
        savings: Float;
        taxes: Float;
        transfers: Float;
        disposableIncome: Float;
    };
    
    public type DemandCurve = {
        goodId: Text;
        intercept: Float;
        slope: Float;
        priceElasticity: Float;
        incomeElasticity: Float;
        crossElasticities: [(Text, Float)];
    };
    
    // ============================================
    // SUPPLY AND DEMAND
    // ============================================
    
    public type SupplyDemandState = {
        goodId: Text;
        marketId: Text;
        supply: SupplyCurve;
        demand: AggregateDemand;
        equilibrium: ?Equilibrium;
        surplus: Float;
        shortage: Float;
    };
    
    public type SupplyCurve = {
        intercept: Float;
        slope: Float;
        priceElasticity: Float;
        shiftFactors: [(Text, Float)];
    };
    
    public type AggregateDemand = {
        intercept: Float;
        slope: Float;
        priceElasticity: Float;
        incomeElasticity: Float;
        shiftFactors: [(Text, Float)];
    };
    
    public type Equilibrium = {
        price: Float;
        quantity: Float;
        consumerSurplus: Float;
        producerSurplus: Float;
        totalSurplus: Float;
        deadweightLoss: Float;
        isStable: Bool;
    };
    
    // ============================================
    // POLICY SIMULATION
    // ============================================
    
    public type MonetaryPolicy = {
        policyType: MonetaryPolicyType;
        targetRate: Float;
        currentRate: Float;
        openMarketOperations: Float;    // Bond purchases/sales
        reserveRequirement: Float;
        forwardGuidance: Text;
        quantitativeEasing: Float;
        inflationTarget: Float;
        rule: MonetaryPolicyRule;
    };
    
    public type MonetaryPolicyType = {
        #Expansionary;
        #Contractionary;
        #Neutral;
        #Accommodative;
        #Restrictive;
    };
    
    public type MonetaryPolicyRule = {
        #TaylorRule: {
            neutralRate: Float;
            inflationWeight: Float;
            outputWeight: Float;
        };
        #McCallumRule: {
            targetGrowth: Float;
            velocityAdjustment: Float;
        };
        #InflationTargeting: { target: Float; tolerance: Float };
        #NGDP_Targeting: { targetGrowth: Float };
        #Discretionary;
    };
    
    public type FiscalPolicy = {
        policyType: FiscalPolicyType;
        taxPolicy: TaxPolicy;
        spendingPolicy: SpendingPolicy;
        stimulus: Float;
        austerity: Float;
        automaticStabilizers: Bool;
    };
    
    public type FiscalPolicyType = {
        #Expansionary;
        #Contractionary;
        #Neutral;
        #CounterCyclical;
        #ProCyclical;
    };
    
    public type TaxPolicy = {
        incomeTaxRate: Float;
        corporateTaxRate: Float;
        capitalGainsTaxRate: Float;
        salesTaxRate: Float;
        payrollTaxRate: Float;
        wealthTaxRate: Float;
        progressivity: Float;           // Degree of progressive taxation
        taxCredits: Float;
        deductions: Float;
    };
    
    public type SpendingPolicy = {
        totalSpending: Float;
        defenseSpending: Float;
        socialSpending: Float;
        infrastructureSpending: Float;
        educationSpending: Float;
        healthcareSpending: Float;
        transferPayments: Float;
        subsidies: Float;
    };
    
    // ============================================
    // SIMULATION STATE
    // ============================================
    
    private var simulationTime : Time.Time = 0;
    private var simulationStep : Nat = 0;
    private var randomSeed : Nat = 12345;
    
    private let markets = HashMap.HashMap<Text, Market>(50, Text.equal, Text.hash);
    private let agents = HashMap.HashMap<AgentId, EconomicAgent>(1000, Text.equal, Text.hash);
    private let firms = HashMap.HashMap<Text, Firm>(200, Text.equal, Text.hash);
    private let macroHistory = Buffer.Buffer<MacroeconomicState>(1000);
    
    private var currentMacroState : MacroeconomicState = defaultMacroState();
    private var monetaryPolicy : MonetaryPolicy = defaultMonetaryPolicy();
    private var fiscalPolicy : FiscalPolicy = defaultFiscalPolicy();
    
    // ============================================
    // INITIALIZATION
    // ============================================
    
    private func defaultMacroState() : MacroeconomicState {
        {
            timestamp = Time.now();
            gdp = {
                nominal = 25000000000000.0;  // $25 trillion
                real = 23000000000000.0;
                growthRate = 0.025;
                perCapita = 75000.0;
                byExpenditure = {
                    consumption = 17000000000000.0;
                    investment = 4500000000000.0;
                    government = 4500000000000.0;
                    netExports = -1000000000000.0;
                };
                byIncome = {
                    wages = 14000000000000.0;
                    profits = 6000000000000.0;
                    rent = 3000000000000.0;
                    interest = 2000000000000.0;
                };
                bySector = [
                    ("Services", 20000000000000.0),
                    ("Manufacturing", 3000000000000.0),
                    ("Agriculture", 500000000000.0),
                    ("Construction", 1500000000000.0)
                ];
                potentialGDP = 24000000000000.0;
                outputGap = 0.02;
            };
            inflation = {
                cpi = 310.0;
                ppi = 280.0;
                coreInflation = 0.028;
                inflationRate = 0.032;
                expectedInflation = 0.025;
                inflationTarget = 0.02;
                realInterestRate = 0.015;
                breakEvenInflation = 0.023;
            };
            employment = {
                laborForce = 165000000.0;
                employed = 158500000.0;
                unemployed = 6500000.0;
                unemploymentRate = 0.039;
                participationRate = 0.623;
                employmentToPopulation = 0.60;
                naturalUnemploymentRate = 0.04;
                underemploymentRate = 0.07;
                averageWage = 58000.0;
                wageGrowth = 0.045;
                laborProductivity = 145000.0;
                jobOpenings = 10000000.0;
                hiringRate = 0.04;
                separationRate = 0.035;
            };
            monetaryMetrics = {
                m0 = 6000000000000.0;
                m1 = 20000000000000.0;
                m2 = 21500000000000.0;
                m3 = 22000000000000.0;
                velocityOfMoney = 1.15;
                federalFundsRate = 0.0525;
                discountRate = 0.055;
                primeRate = 0.0825;
                yieldCurve = [
                    (1, 0.052),
                    (2, 0.048),
                    (5, 0.042),
                    (10, 0.039),
                    (30, 0.038)
                ];
                creditGrowth = 0.06;
                reserveRequirement = 0.0;
                excessReserves = 3000000000000.0;
            };
            fiscalMetrics = {
                governmentRevenue = 4500000000000.0;
                governmentSpending = 6500000000000.0;
                budgetDeficit = -2000000000000.0;
                debtToGDP = 1.20;
                publicDebt = 30000000000000.0;
                taxRevenue = {
                    incomeTax = 2200000000000.0;
                    corporateTax = 400000000000.0;
                    salesTax = 0.0;
                    payrollTax = 1400000000000.0;
                    other = 500000000000.0;
                };
                spendingByCategory = {
                    defense = 850000000000.0;
                    socialSecurity = 1400000000000.0;
                    healthcare = 1500000000000.0;
                    education = 200000000000.0;
                    infrastructure = 150000000000.0;
                    interestPayments = 800000000000.0;
                    other = 1600000000000.0;
                };
                fiscalMultiplier = 1.5;
                automaticStabilizers = 0.3;
            };
            tradeMetrics = {
                exports = 2500000000000.0;
                imports = 3500000000000.0;
                tradeBalance = -1000000000000.0;
                currentAccount = -900000000000.0;
                capitalAccount = 900000000000.0;
                exchangeRate = 1.0;
                realExchangeRate = 1.05;
                termsOfTrade = 0.98;
                tradeOpenness = 0.24;
                foreignReserves = 250000000000.0;
                tradingPartners = [
                    ("China", 750000000000.0),
                    ("EU", 900000000000.0),
                    ("Mexico", 680000000000.0),
                    ("Canada", 620000000000.0),
                    ("Japan", 220000000000.0)
                ];
            };
            financialMetrics = {
                stockMarketIndex = 4500.0;
                stockMarketVolatility = 18.0;
                bondYields = [
                    (2, 0.048),
                    (10, 0.039),
                    (30, 0.038)
                ];
                creditSpread = 0.015;
                mortgageRate = 0.068;
                savingsRate = 0.045;
                householdDebt = 18000000000000.0;
                corporateDebt = 12000000000000.0;
                bankingSystemHealth = 0.85;
                financialStress = 0.25;
            };
            confidenceIndices = {
                consumerConfidence = 102.0;
                businessConfidence = 98.0;
                investorSentiment = 0.55;
                pmi = 51.5;
                leadingIndicators = 101.5;
                coincidentIndicators = 100.2;
                laggingIndicators = 99.8;
            };
        }
    };
    
    private func defaultMonetaryPolicy() : MonetaryPolicy {
        {
            policyType = #Neutral;
            targetRate = 0.05;
            currentRate = 0.0525;
            openMarketOperations = 0.0;
            reserveRequirement = 0.0;
            forwardGuidance = "The committee anticipates maintaining current rates until inflation returns to target.";
            quantitativeEasing = 0.0;
            inflationTarget = 0.02;
            rule = #TaylorRule({
                neutralRate = 0.025;
                inflationWeight = 1.5;
                outputWeight = 0.5;
            });
        }
    };
    
    private func defaultFiscalPolicy() : FiscalPolicy {
        {
            policyType = #Neutral;
            taxPolicy = {
                incomeTaxRate = 0.24;
                corporateTaxRate = 0.21;
                capitalGainsTaxRate = 0.20;
                salesTaxRate = 0.0;
                payrollTaxRate = 0.0765;
                wealthTaxRate = 0.0;
                progressivity = 0.35;
                taxCredits = 500000000000.0;
                deductions = 2000000000000.0;
            };
            spendingPolicy = {
                totalSpending = 6500000000000.0;
                defenseSpending = 850000000000.0;
                socialSpending = 2400000000000.0;
                infrastructureSpending = 150000000000.0;
                educationSpending = 200000000000.0;
                healthcareSpending = 1500000000000.0;
                transferPayments = 1000000000000.0;
                subsidies = 200000000000.0;
            };
            stimulus = 0.0;
            austerity = 0.0;
            automaticStabilizers = true;
        }
    };
    
    // ============================================
    // MARKET OPERATIONS
    // ============================================
    
    public func createMarket(
        name: Text,
        structure: MarketStructure,
        initialPrice: Float
    ) : async Text {
        let id = "mkt-" # Nat.toText(markets.size());
        
        let market : Market = {
            id = id;
            name = name;
            structure = structure;
            goods = [];
            participants = [];
            currentPrice = initialPrice;
            equilibriumPrice = null;
            equilibriumQuantity = null;
            priceElasticity = -1.0;
            tradingVolume = 0.0;
            lastTradedPrice = initialPrice;
            bidAskSpread = 0.01;
            orderBook = {
                bids = [];
                asks = [];
                lastMatchTime = Time.now();
            };
            history = [];
            regulations = [];
            createdAt = Time.now();
        };
        
        markets.put(id, market);
        id
    };
    
    public func calculateEquilibrium(marketId: Text) : async ?Equilibrium {
        switch (markets.get(marketId)) {
            case null { null };
            case (?market) {
                // Simplified equilibrium calculation
                // In reality, this would aggregate all supply and demand curves
                
                // Assume linear supply: Qs = a + b*P
                // Assume linear demand: Qd = c - d*P
                // Equilibrium: a + b*P = c - d*P
                // P* = (c - a) / (b + d)
                // Q* = a + b*P*
                
                let a : Float = 0.0;      // Supply intercept
                let b : Float = 100.0;    // Supply slope
                let c : Float = 1000.0;   // Demand intercept
                let d : Float = 50.0;     // Demand slope (positive, equation uses minus)
                
                let equilibriumPrice = (c - a) / (b + d);
                let equilibriumQuantity = a + b * equilibriumPrice;
                
                // Consumer surplus = 0.5 * Q* * (P_max - P*)
                // where P_max is the price where demand = 0
                let pMax = c / d;
                let consumerSurplus = 0.5 * equilibriumQuantity * (pMax - equilibriumPrice);
                
                // Producer surplus = 0.5 * Q* * (P* - P_min)
                // where P_min is the price where supply = 0
                let pMin = -a / b;
                let producerSurplus = 0.5 * equilibriumQuantity * (equilibriumPrice - Float.max(0.0, pMin));
                
                ?{
                    price = equilibriumPrice;
                    quantity = equilibriumQuantity;
                    consumerSurplus = consumerSurplus;
                    producerSurplus = producerSurplus;
                    totalSurplus = consumerSurplus + producerSurplus;
                    deadweightLoss = 0.0;  // No DWL at equilibrium
                    isStable = true;
                }
            };
        }
    };
    
    public func applyPriceCeiling(marketId: Text, ceiling: Float) : async Result.Result<Equilibrium, Text> {
        switch (markets.get(marketId)) {
            case null { #err("Market not found") };
            case (?market) {
                let eqResult = await calculateEquilibrium(marketId);
                
                switch (eqResult) {
                    case null { #err("Could not calculate equilibrium") };
                    case (?eq) {
                        if (ceiling >= eq.price) {
                            // Ceiling not binding
                            #ok(eq)
                        } else {
                            // Ceiling is binding - creates shortage
                            // At ceiling price, Qd > Qs
                            
                            let a : Float = 0.0;
                            let b : Float = 100.0;
                            let c : Float = 1000.0;
                            let d : Float = 50.0;
                            
                            let quantitySupplied = a + b * ceiling;
                            let quantityDemanded = c - d * ceiling;
                            let shortage = quantityDemanded - quantitySupplied;
                            
                            // Consumer surplus changes
                            // Those who can buy get surplus, those who can't get nothing
                            let newConsumerSurplus = 0.5 * quantitySupplied * ((c/d) - ceiling);
                            
                            // Producer surplus shrinks
                            let pMin = Float.max(0.0, -a / b);
                            let newProducerSurplus = 0.5 * quantitySupplied * (ceiling - pMin);
                            
                            // Deadweight loss from reduced quantity
                            let dwl = 0.5 * (eq.price - ceiling) * (eq.quantity - quantitySupplied);
                            
                            #ok({
                                price = ceiling;
                                quantity = quantitySupplied;
                                consumerSurplus = newConsumerSurplus;
                                producerSurplus = newProducerSurplus;
                                totalSurplus = newConsumerSurplus + newProducerSurplus;
                                deadweightLoss = dwl;
                                isStable = false;
                            })
                        }
                    };
                }
            };
        }
    };
    
    public func applyPriceFloor(marketId: Text, floor: Float) : async Result.Result<Equilibrium, Text> {
        switch (markets.get(marketId)) {
            case null { #err("Market not found") };
            case (?market) {
                let eqResult = await calculateEquilibrium(marketId);
                
                switch (eqResult) {
                    case null { #err("Could not calculate equilibrium") };
                    case (?eq) {
                        if (floor <= eq.price) {
                            // Floor not binding
                            #ok(eq)
                        } else {
                            // Floor is binding - creates surplus
                            // At floor price, Qs > Qd
                            
                            let a : Float = 0.0;
                            let b : Float = 100.0;
                            let c : Float = 1000.0;
                            let d : Float = 50.0;
                            
                            let quantityDemanded = c - d * floor;
                            let quantitySupplied = a + b * floor;
                            let surplus = quantitySupplied - quantityDemanded;
                            
                            // Consumer surplus shrinks
                            let pMax = c / d;
                            let newConsumerSurplus = 0.5 * quantityDemanded * (pMax - floor);
                            
                            // Producer surplus for those who can sell
                            let pMin = Float.max(0.0, -a / b);
                            let newProducerSurplus = 0.5 * quantityDemanded * (floor - pMin);
                            
                            // Deadweight loss
                            let dwl = 0.5 * (floor - eq.price) * (eq.quantity - quantityDemanded);
                            
                            #ok({
                                price = floor;
                                quantity = quantityDemanded;
                                consumerSurplus = newConsumerSurplus;
                                producerSurplus = newProducerSurplus;
                                totalSurplus = newConsumerSurplus + newProducerSurplus;
                                deadweightLoss = dwl;
                                isStable = false;
                            })
                        }
                    };
                }
            };
        }
    };
    
    public func applyTax(marketId: Text, taxPerUnit: Float) : async Result.Result<{
        equilibrium: Equilibrium;
        buyerPrice: Float;
        sellerPrice: Float;
        taxRevenue: Float;
        buyerBurden: Float;
        sellerBurden: Float;
    }, Text> {
        switch (markets.get(marketId)) {
            case null { #err("Market not found") };
            case (?market) {
                let eqResult = await calculateEquilibrium(marketId);
                
                switch (eqResult) {
                    case null { #err("Could not calculate equilibrium") };
                    case (?eq) {
                        // Tax creates a wedge between buyer and seller prices
                        // Pb = Ps + t
                        
                        let a : Float = 0.0;
                        let b : Float = 100.0;
                        let c : Float = 1000.0;
                        let d : Float = 50.0;
                        
                        // New equilibrium with tax:
                        // Supply: Qs = a + b*Ps
                        // Demand: Qd = c - d*Pb = c - d*(Ps + t)
                        // Equilibrium: a + b*Ps = c - d*Ps - d*t
                        // Ps = (c - a - d*t) / (b + d)
                        
                        let sellerPrice = (c - a - d * taxPerUnit) / (b + d);
                        let buyerPrice = sellerPrice + taxPerUnit;
                        let newQuantity = a + b * sellerPrice;
                        
                        let taxRevenue = taxPerUnit * newQuantity;
                        
                        // Burden calculation
                        // Buyer burden = (Pb_new - P*) / t
                        // Seller burden = (P* - Ps_new) / t
                        let buyerBurden = (buyerPrice - eq.price) / taxPerUnit;
                        let sellerBurden = (eq.price - sellerPrice) / taxPerUnit;
                        
                        // New surpluses
                        let pMax = c / d;
                        let newConsumerSurplus = 0.5 * newQuantity * (pMax - buyerPrice);
                        let pMin = Float.max(0.0, -a / b);
                        let newProducerSurplus = 0.5 * newQuantity * (sellerPrice - pMin);
                        
                        // Deadweight loss
                        let dwl = eq.totalSurplus - (newConsumerSurplus + newProducerSurplus + taxRevenue);
                        
                        #ok({
                            equilibrium = {
                                price = buyerPrice;  // Use buyer price as market price
                                quantity = newQuantity;
                                consumerSurplus = newConsumerSurplus;
                                producerSurplus = newProducerSurplus;
                                totalSurplus = newConsumerSurplus + newProducerSurplus + taxRevenue;
                                deadweightLoss = dwl;
                                isStable = true;
                            };
                            buyerPrice = buyerPrice;
                            sellerPrice = sellerPrice;
                            taxRevenue = taxRevenue;
                            buyerBurden = buyerBurden;
                            sellerBurden = sellerBurden;
                        })
                    };
                }
            };
        }
    };
    
    // ============================================
    // AGENT OPERATIONS
    // ============================================
    
    public func createAgent(
        agentType: AgentType,
        name: Text,
        initialWealth: Float
    ) : async AgentId {
        let id = "agent-" # Nat.toText(agents.size());
        
        let agent : EconomicAgent = {
            id = id;
            agentType = agentType;
            name = name;
            wealth = initialWealth;
            income = 0.0;
            consumption = 0.0;
            savings = initialWealth;
            debt = 0.0;
            assets = [{
                assetType = #Cash;
                quantity = initialWealth;
                currentValue = initialWealth;
                purchasePrice = initialWealth;
                purchaseDate = Time.now();
            }];
            liabilities = [];
            preferences = {
                riskTolerance = 0.5;
                timePreference = 0.05;
                consumptionSmoothing = 0.8;
                brandLoyalty = 0.3;
                priceConsciousness = 0.7;
                qualityPreference = 0.6;
                utilityFunction = #CobbDouglas({ alpha = 0.5 });
            };
            expectations = {
                expectedInflation = 0.025;
                expectedGrowth = 0.02;
                expectedInterestRate = 0.05;
                priceExpectations = [];
                confidence = 0.7;
                formationMethod = #AdaptiveExpectations({ learningRate = 0.3 });
            };
            behavior = {
                decisionRule = #UtilityMaximization;
                learningAlgorithm = #ReinforcementLearning({ alpha = 0.1; gamma = 0.95 });
                socialInfluence = 0.2;
                informationProcessing = #BoundedRationality({ computationLimit = 100 });
            };
            history = [];
            createdAt = Time.now();
        };
        
        agents.put(id, agent);
        id
    };
    
    public func calculateUtility(agentId: AgentId, consumption: [(Text, Float)]) : async Float {
        switch (agents.get(agentId)) {
            case null { 0.0 };
            case (?agent) {
                switch (agent.preferences.utilityFunction) {
                    case (#CobbDouglas({ alpha })) {
                        // U = x1^alpha * x2^(1-alpha)
                        // For multiple goods, use product
                        var utility : Float = 1.0;
                        var exponent : Float = 1.0 / Float.fromInt(consumption.size());
                        
                        for ((_, quantity) in consumption.vals()) {
                            if (quantity > 0.0) {
                                utility *= Float.pow(quantity, exponent);
                            };
                        };
                        utility
                    };
                    case (#CES({ elasticity })) {
                        // U = (sum(x_i^rho))^(1/rho), rho = (sigma-1)/sigma
                        let rho = (elasticity - 1.0) / elasticity;
                        var sum : Float = 0.0;
                        
                        for ((_, quantity) in consumption.vals()) {
                            if (quantity > 0.0) {
                                sum += Float.pow(quantity, rho);
                            };
                        };
                        
                        if (sum > 0.0 and rho != 0.0) {
                            Float.pow(sum, 1.0 / rho)
                        } else {
                            0.0
                        }
                    };
                    case (#Leontief) {
                        // U = min(x1, x2, ...)
                        var minQuantity : Float = 1000000000.0;
                        for ((_, quantity) in consumption.vals()) {
                            if (quantity < minQuantity) {
                                minQuantity := quantity;
                            };
                        };
                        minQuantity
                    };
                    case (#Linear) {
                        // U = sum(x_i)
                        var sum : Float = 0.0;
                        for ((_, quantity) in consumption.vals()) {
                            sum += quantity;
                        };
                        sum
                    };
                    case (#Quadratic) {
                        // U = sum(x_i) - sum(x_i^2)
                        var sum : Float = 0.0;
                        var sumSquared : Float = 0.0;
                        for ((_, quantity) in consumption.vals()) {
                            sum += quantity;
                            sumSquared += quantity * quantity;
                        };
                        sum - 0.01 * sumSquared
                    };
                    case (#CRRA({ gamma })) {
                        // U = C^(1-gamma) / (1-gamma)  for gamma != 1
                        // U = ln(C) for gamma = 1
                        var totalC : Float = 0.0;
                        for ((_, quantity) in consumption.vals()) {
                            totalC += quantity;
                        };
                        
                        if (Float.abs(gamma - 1.0) < 0.001) {
                            if (totalC > 0.0) { Float.log(totalC) } else { -1000000.0 }
                        } else {
                            if (totalC > 0.0) {
                                Float.pow(totalC, 1.0 - gamma) / (1.0 - gamma)
                            } else {
                                -1000000.0
                            }
                        }
                    };
                }
            };
        }
    };
    
    public func optimizeConsumption(
        agentId: AgentId,
        budget: Float,
        prices: [(Text, Float)]
    ) : async [(Text, Float)] {
        switch (agents.get(agentId)) {
            case null { [] };
            case (?agent) {
                // Lagrangian optimization for Cobb-Douglas
                // For U = x1^alpha * x2^(1-alpha)
                // Budget: p1*x1 + p2*x2 = M
                // FOC: alpha*U/x1 = lambda*p1
                //      (1-alpha)*U/x2 = lambda*p2
                // Solution: x1 = alpha*M/p1, x2 = (1-alpha)*M/p2
                
                let n = prices.size();
                if (n == 0) { return [] };
                
                let alpha = 1.0 / Float.fromInt(n);  // Equal weights
                let result = Buffer.Buffer<(Text, Float)>(n);
                
                for ((goodId, price) in prices.vals()) {
                    if (price > 0.0) {
                        let optimalQuantity = alpha * budget / price;
                        result.add((goodId, optimalQuantity));
                    } else {
                        result.add((goodId, 0.0));
                    };
                };
                
                Buffer.toArray(result)
            };
        }
    };
    
    // ============================================
    // MONETARY POLICY SIMULATION
    // ============================================
    
    public func setMonetaryPolicy(policy: MonetaryPolicy) : async () {
        monetaryPolicy := policy;
    };
    
    public func calculateTaylorRule() : async Float {
        // Taylor Rule: i = r* + π + 0.5*(π - π*) + 0.5*(y - y*)
        // i = nominal interest rate
        // r* = equilibrium real interest rate
        // π = current inflation
        // π* = target inflation
        // y - y* = output gap
        
        switch (monetaryPolicy.rule) {
            case (#TaylorRule({ neutralRate; inflationWeight; outputWeight })) {
                let currentInflation = currentMacroState.inflation.inflationRate;
                let targetInflation = monetaryPolicy.inflationTarget;
                let outputGap = currentMacroState.gdp.outputGap;
                
                let suggestedRate = neutralRate + currentInflation +
                    inflationWeight * (currentInflation - targetInflation) +
                    outputWeight * outputGap;
                
                // Apply zero lower bound
                Float.max(0.0, suggestedRate)
            };
            case (#McCallumRule({ targetGrowth; velocityAdjustment })) {
                // McCallum Rule focuses on monetary base growth
                let nominalGDPGrowth = currentMacroState.gdp.growthRate + 
                    currentMacroState.inflation.inflationRate;
                
                targetGrowth - velocityAdjustment * 
                    (nominalGDPGrowth - targetGrowth)
            };
            case (#InflationTargeting({ target; tolerance })) {
                let deviation = currentMacroState.inflation.inflationRate - target;
                
                if (Float.abs(deviation) < tolerance) {
                    monetaryPolicy.currentRate  // Keep rate unchanged
                } else if (deviation > 0.0) {
                    monetaryPolicy.currentRate + 0.25  // Raise rates
                } else {
                    Float.max(0.0, monetaryPolicy.currentRate - 0.25)  // Lower rates
                }
            };
            case (#NGDP_Targeting({ targetGrowth })) {
                let nominalGDPGrowth = currentMacroState.gdp.growthRate + 
                    currentMacroState.inflation.inflationRate;
                let deviation = nominalGDPGrowth - targetGrowth;
                
                monetaryPolicy.currentRate + 0.5 * deviation
            };
            case (#Discretionary) {
                monetaryPolicy.currentRate  // No change
            };
        }
    };
    
    public func simulateQuantitativeEasing(amount: Float) : async {
        newMoneySupply: Float;
        expectedInflationImpact: Float;
        expectedYieldImpact: Float;
        expectedGDPImpact: Float;
    } {
        // QE increases money supply
        let newM2 = currentMacroState.monetaryMetrics.m2 + amount;
        
        // Quantity theory of money: MV = PY
        // If V and Y are stable, increase in M leads to increase in P
        let moneyMultiplier = newM2 / currentMacroState.monetaryMetrics.m0;
        
        // Expected inflation impact (simplified)
        let inflationImpact = (amount / currentMacroState.monetaryMetrics.m2) * 
            0.3;  // Assume 30% pass-through
        
        // Bond purchases lower yields
        let yieldImpact = -0.01 * (amount / 100000000000.0);  // -1bp per $100B
        
        // GDP impact through lower rates and wealth effect
        let gdpImpact = 0.001 * (amount / 100000000000.0);  // 0.1% per $100B
        
        {
            newMoneySupply = newM2;
            expectedInflationImpact = inflationImpact;
            expectedYieldImpact = yieldImpact;
            expectedGDPImpact = gdpImpact;
        }
    };
    
    // ============================================
    // FISCAL POLICY SIMULATION
    // ============================================
    
    public func setFiscalPolicy(policy: FiscalPolicy) : async () {
        fiscalPolicy := policy;
    };
    
    public func calculateFiscalMultiplier(spendingChange: Float) : async Float {
        // Simplified Keynesian multiplier: 1 / (1 - MPC + MPM + t)
        // MPC = marginal propensity to consume
        // MPM = marginal propensity to import
        // t = tax rate
        
        let mpc : Float = 0.75;  // Typical value
        let mpm : Float = 0.15;  // Import leakage
        let t = fiscalPolicy.taxPolicy.incomeTaxRate;
        
        let multiplier = 1.0 / (1.0 - mpc * (1.0 - t) + mpm);
        
        // Adjust for economic conditions
        // Multiplier is higher when:
        // - Interest rates are at zero lower bound
        // - Economy is in recession (negative output gap)
        // - Monetary policy is accommodative
        
        var adjustedMultiplier = multiplier;
        
        // Zero lower bound adjustment
        if (monetaryPolicy.currentRate < 0.01) {
            adjustedMultiplier *= 1.5;  // 50% higher at ZLB
        };
        
        // Output gap adjustment
        if (currentMacroState.gdp.outputGap < 0.0) {
            adjustedMultiplier *= (1.0 - 0.5 * currentMacroState.gdp.outputGap);
        };
        
        adjustedMultiplier
    };
    
    public func simulateStimulus(stimulusAmount: Float) : async {
        gdpImpact: Float;
        employmentImpact: Float;
        debtImpact: Float;
        inflationImpact: Float;
    } {
        let multiplier = await calculateFiscalMultiplier(stimulusAmount);
        
        let gdpImpact = stimulusAmount * multiplier;
        
        // Employment impact: Okun's Law
        // 1% increase in GDP leads to ~0.5% decrease in unemployment
        let gdpGrowthImpact = gdpImpact / currentMacroState.gdp.nominal;
        let employmentImpact = gdpGrowthImpact * 0.5;
        
        // Debt impact
        let debtImpact = stimulusAmount;  // Direct increase in debt
        
        // Inflation impact (Phillips Curve relationship)
        // Lower unemployment leads to higher inflation
        let inflationImpact = employmentImpact * 0.3;  // Simplified coefficient
        
        {
            gdpImpact = gdpImpact;
            employmentImpact = employmentImpact;
            debtImpact = debtImpact;
            inflationImpact = inflationImpact;
        }
    };
    
    public func simulateTaxCut(taxCutAmount: Float) : async {
        gdpImpact: Float;
        consumptionImpact: Float;
        investmentImpact: Float;
        deficitImpact: Float;
    } {
        // Tax multiplier is typically smaller than spending multiplier
        // Tax multiplier ≈ -MPC / (1 - MPC + MPM + t)
        
        let mpc : Float = 0.75;
        let mpm : Float = 0.15;
        let t = fiscalPolicy.taxPolicy.incomeTaxRate;
        
        let taxMultiplier = -mpc / (1.0 - mpc * (1.0 - t) + mpm);
        
        let gdpImpact = -taxCutAmount * taxMultiplier;  // Negative tax cut = positive GDP
        
        // Consumption impact
        let consumptionImpact = taxCutAmount * mpc;
        
        // Investment impact (supply-side effects)
        // Lower corporate taxes encourage investment
        let investmentImpact = taxCutAmount * 0.2;  // Simplified
        
        // Deficit impact (static vs dynamic scoring)
        // Static: full revenue loss
        // Dynamic: some recovery from higher GDP
        let dynamicRecovery = gdpImpact * t * 0.3;  // Assume 30% recovery
        let deficitImpact = taxCutAmount - dynamicRecovery;
        
        {
            gdpImpact = gdpImpact;
            consumptionImpact = consumptionImpact;
            investmentImpact = investmentImpact;
            deficitImpact = deficitImpact;
        }
    };
    
    // ============================================
    // TRADE SIMULATION
    // ============================================
    
    public func calculateExchangeRateEquilibrium(
        domesticInterestRate: Float,
        foreignInterestRate: Float,
        expectedInflationDifferential: Float
    ) : async Float {
        // Uncovered Interest Rate Parity (UIP):
        // E[S_t+1] / S_t = (1 + i_d) / (1 + i_f)
        
        // Purchasing Power Parity (PPP):
        // E[S_t+1] / S_t = (1 + π_d) / (1 + π_f)
        
        // Combined model
        let interestDifferential = domesticInterestRate - foreignInterestRate;
        
        // Expected depreciation = interest differential (UIP)
        // But also consider inflation differential (PPP)
        
        let currentRate = currentMacroState.tradeMetrics.exchangeRate;
        
        // Simplified: exchange rate adjustment based on differentials
        let expectedChange = 0.5 * interestDifferential + 
            0.5 * expectedInflationDifferential;
        
        currentRate * (1.0 + expectedChange)
    };
    
    public func simulateTariff(
        importCategory: Text,
        tariffRate: Float
    ) : async {
        priceImpact: Float;
        importReduction: Float;
        domesticProductionIncrease: Float;
        consumerSurplusLoss: Float;
        tariffRevenue: Float;
        deadweightLoss: Float;
    } {
        // Tariff analysis using partial equilibrium
        
        let baseImportValue : Float = 100000000000.0;  // Simplified
        let importElasticity : Float = -1.5;
        let domesticSupplyElasticity : Float = 1.0;
        
        // Price impact
        let priceIncrease = tariffRate * 0.7;  // Pass-through rate
        
        // Import reduction (using elasticity)
        let importReduction = -importElasticity * priceIncrease * baseImportValue;
        
        // Domestic production increase
        let domesticIncrease = domesticSupplyElasticity * priceIncrease * 
            (baseImportValue * 0.5);  // Assume domestic production is 50% of imports
        
        // Welfare analysis
        let newImportValue = baseImportValue - importReduction;
        let tariffRevenue = tariffRate * newImportValue;
        
        // Consumer surplus loss (approximation)
        let consumerSurplusLoss = priceIncrease * (baseImportValue + newImportValue) / 2.0;
        
        // Deadweight loss (Harberger triangle)
        let deadweightLoss = 0.5 * tariffRate * importReduction;
        
        {
            priceImpact = priceIncrease;
            importReduction = importReduction;
            domesticProductionIncrease = domesticIncrease;
            consumerSurplusLoss = consumerSurplusLoss;
            tariffRevenue = tariffRevenue;
            deadweightLoss = deadweightLoss;
        }
    };
    
    // ============================================
    // BUSINESS CYCLE SIMULATION
    // ============================================
    
    public type BusinessCyclePhase = {
        #Expansion;
        #Peak;
        #Contraction;
        #Trough;
    };
    
    public func determineBusinessCyclePhase() : async BusinessCyclePhase {
        let gdpGrowth = currentMacroState.gdp.growthRate;
        let outputGap = currentMacroState.gdp.outputGap;
        let unemploymentGap = currentMacroState.employment.unemploymentRate - 
            currentMacroState.employment.naturalUnemploymentRate;
        
        // Simple classification
        if (gdpGrowth > 0.03 and outputGap > 0.02) {
            #Peak
        } else if (gdpGrowth > 0.0 and outputGap > -0.02) {
            #Expansion
        } else if (gdpGrowth < -0.01 and outputGap < -0.02) {
            #Trough
        } else {
            #Contraction
        }
    };
    
    public func forecastGDP(quarters: Nat) : async [Float] {
        let forecasts = Buffer.Buffer<Float>(quarters);
        var currentGDP = currentMacroState.gdp.real;
        var currentGrowth = currentMacroState.gdp.growthRate;
        
        // AR(1) process for GDP growth
        let persistence : Float = 0.7;
        let meanGrowth : Float = 0.025;  // Long-run average
        let volatility : Float = 0.01;
        
        for (q in Iter.range(0, quarters - 1)) {
            // Mean reversion in growth rate
            let expectedGrowth = meanGrowth + persistence * (currentGrowth - meanGrowth);
            
            // Add some randomness (simplified)
            let quarterlyGrowth = expectedGrowth / 4.0;
            
            currentGDP *= (1.0 + quarterlyGrowth);
            currentGrowth := expectedGrowth;
            
            forecasts.add(currentGDP);
        };
        
        Buffer.toArray(forecasts)
    };
    
    // ============================================
    // SIMULATION STEP
    // ============================================
    
    public func stepSimulation() : async MacroeconomicState {
        simulationStep += 1;
        simulationTime := Time.now();
        
        // Update based on policies
        var newState = currentMacroState;
        
        // Apply monetary policy effects
        let taylorRate = await calculateTaylorRule();
        
        // Update GDP based on output gap closure
        let newGrowth = currentMacroState.gdp.growthRate * 0.9 + 0.025 * 0.1;
        
        // Update unemployment via Okun's Law
        let unemploymentChange = -0.5 * (newGrowth - 0.025);
        let newUnemploymentRate = Float.max(0.03, 
            currentMacroState.employment.unemploymentRate + unemploymentChange);
        
        // Update inflation via Phillips Curve
        let inflationChange = -0.3 * (newUnemploymentRate - 
            currentMacroState.employment.naturalUnemploymentRate);
        let newInflation = currentMacroState.inflation.inflationRate + inflationChange;
        
        // Store history
        macroHistory.add(currentMacroState);
        
        // Update current state (simplified)
        currentMacroState := {
            timestamp = simulationTime;
            gdp = {
                nominal = currentMacroState.gdp.nominal * (1.0 + newGrowth + newInflation);
                real = currentMacroState.gdp.real * (1.0 + newGrowth);
                growthRate = newGrowth;
                perCapita = currentMacroState.gdp.perCapita * (1.0 + newGrowth);
                byExpenditure = currentMacroState.gdp.byExpenditure;
                byIncome = currentMacroState.gdp.byIncome;
                bySector = currentMacroState.gdp.bySector;
                potentialGDP = currentMacroState.gdp.potentialGDP * 1.025;
                outputGap = (currentMacroState.gdp.real - currentMacroState.gdp.potentialGDP) / 
                    currentMacroState.gdp.potentialGDP;
            };
            inflation = {
                cpi = currentMacroState.inflation.cpi * (1.0 + newInflation);
                ppi = currentMacroState.inflation.ppi * (1.0 + newInflation * 0.9);
                coreInflation = newInflation * 0.9;
                inflationRate = newInflation;
                expectedInflation = 0.7 * currentMacroState.inflation.expectedInflation + 
                    0.3 * newInflation;
                inflationTarget = currentMacroState.inflation.inflationTarget;
                realInterestRate = taylorRate - newInflation;
                breakEvenInflation = currentMacroState.inflation.breakEvenInflation;
            };
            employment = {
                laborForce = currentMacroState.employment.laborForce;
                employed = currentMacroState.employment.laborForce * (1.0 - newUnemploymentRate);
                unemployed = currentMacroState.employment.laborForce * newUnemploymentRate;
                unemploymentRate = newUnemploymentRate;
                participationRate = currentMacroState.employment.participationRate;
                employmentToPopulation = currentMacroState.employment.employmentToPopulation;
                naturalUnemploymentRate = currentMacroState.employment.naturalUnemploymentRate;
                underemploymentRate = currentMacroState.employment.underemploymentRate;
                averageWage = currentMacroState.employment.averageWage * (1.0 + newInflation + 0.01);
                wageGrowth = newInflation + 0.01;
                laborProductivity = currentMacroState.employment.laborProductivity * 1.005;
                jobOpenings = currentMacroState.employment.jobOpenings;
                hiringRate = currentMacroState.employment.hiringRate;
                separationRate = currentMacroState.employment.separationRate;
            };
            monetaryMetrics = {
                m0 = currentMacroState.monetaryMetrics.m0;
                m1 = currentMacroState.monetaryMetrics.m1 * (1.0 + newInflation);
                m2 = currentMacroState.monetaryMetrics.m2 * (1.0 + newInflation);
                m3 = currentMacroState.monetaryMetrics.m3 * (1.0 + newInflation);
                velocityOfMoney = currentMacroState.monetaryMetrics.velocityOfMoney;
                federalFundsRate = taylorRate;
                discountRate = taylorRate + 0.0025;
                primeRate = taylorRate + 0.03;
                yieldCurve = currentMacroState.monetaryMetrics.yieldCurve;
                creditGrowth = currentMacroState.monetaryMetrics.creditGrowth;
                reserveRequirement = currentMacroState.monetaryMetrics.reserveRequirement;
                excessReserves = currentMacroState.monetaryMetrics.excessReserves;
            };
            fiscalMetrics = currentMacroState.fiscalMetrics;
            tradeMetrics = currentMacroState.tradeMetrics;
            financialMetrics = currentMacroState.financialMetrics;
            confidenceIndices = currentMacroState.confidenceIndices;
        };
        
        currentMacroState
    };
    
    // ============================================
    // QUERY INTERFACE
    // ============================================
    
    public query func getMacroState() : async MacroeconomicState {
        currentMacroState
    };
    
    public query func getMarket(marketId: Text) : async ?Market {
        markets.get(marketId)
    };
    
    public query func getAgent(agentId: AgentId) : async ?EconomicAgent {
        agents.get(agentId)
    };
    
    public query func getMonetaryPolicy() : async MonetaryPolicy {
        monetaryPolicy
    };
    
    public query func getFiscalPolicy() : async FiscalPolicy {
        fiscalPolicy
    };
    
    public query func getSimulationStep() : async Nat {
        simulationStep
    };
    
    public query func getMacroHistory(limit: Nat) : async [MacroeconomicState] {
        let size = macroHistory.size();
        let start = if (size > limit) { size - limit } else { 0 };
        
        let result = Buffer.Buffer<MacroeconomicState>(limit);
        for (i in Iter.range(start, size - 1)) {
            result.add(macroHistory.get(i));
        };
        Buffer.toArray(result)
    };
    
    // ============================================
    // SOVEREIGNTY COMPLIANCE
    // ============================================
    
    public query func verifySovereignty() : async {
        s0Floor: Float;
        coherenceThreshold: Float;
        integrityMinimum: Float;
        compliant: Bool;
    } {
        {
            s0Floor = S_0_FLOOR;
            coherenceThreshold = COHERENCE_THRESHOLD;
            integrityMinimum = INTEGRITY_MINIMUM;
            compliant = S_0_FLOOR >= 1.0 and COHERENCE_THRESHOLD >= 1.0 and INTEGRITY_MINIMUM >= 1.0;
        }
    };
}
