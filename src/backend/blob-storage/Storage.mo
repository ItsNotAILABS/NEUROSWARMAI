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
import Runtime "mo:core/Runtime";
import Principal "mo:core/Principal";
import Array "mo:core/Array";
import Prim "mo:prim";
import Cycles "mo:core/Cycles";
import Nat "mo:core/Nat";

module {
  public type ExternalBlob = Blob;

  public type State = {
    var authorizedPrincipals : [Principal];
  };

  public func new() : State {
    let authorizedPrincipals : [Principal] = [];
    {
      var authorizedPrincipals;
    };
  };

  public func getCashierPrincipal() : async Principal {
    switch (Prim.envVar<system>("CAFFFEINE_STORAGE_CASHIER_PRINCIPAL")) {
      case (null) {
        Runtime.trap("CAFFFEINE_STORAGE_CASHIER_PRINCIPAL environment variable is not set");
      };
      case (?cashierPrincipal) {
        Principal.fromText(cashierPrincipal);
      };
    };
  };

  // Authorization functions
  public func updateGatewayPrincipals(registry : State) : async () {
    let cashierPrincipal = await getCashierPrincipal();
    let cashierActor = actor (cashierPrincipal.toText()) : actor {
      storage_gateway_principal_list_v1 : () -> async [Principal];
    };

    registry.authorizedPrincipals := await cashierActor.storage_gateway_principal_list_v1();
  };

  public func isAuthorized(registry : State, caller : Principal) : Bool {
    let authorized = registry.authorizedPrincipals.find(
      func(principal) {
        Principal.equal(principal, caller);
      }
    ) != null;
    authorized;
  };

  public func refillCashier(
    _registry : State,
    cashier : Principal,
    refillInformation : ?{
      proposed_top_up_amount : ?Nat;
    },
  ) : async {
    success : ?Bool;
    topped_up_amount : ?Nat;
  } {
    let currentBalance = Cycles.balance();
    let reservedCycles : Nat = 400_000_000_000;

    let currentFreeCyclesCount : Nat = Nat.sub(currentBalance, reservedCycles);

    let cyclesToSend : Nat = switch (refillInformation) {
      case (null) { currentFreeCyclesCount };
      case (?info) {
        switch (info.proposed_top_up_amount) {
          case (null) { currentFreeCyclesCount };
          case (?proposed) { Nat.min(proposed, currentFreeCyclesCount) };
        };
      };
    };

    let targetCanister = actor (cashier.toText()) : actor {
      account_top_up_v1 : ({ account : Principal }) -> async ();
    };

    await (with cycles = cyclesToSend) targetCanister.account_top_up_v1({
      account = Prim.getSelfPrincipal<system>();
    });

    {
      success = ?true;
      topped_up_amount = ?cyclesToSend;
    };
  };
};
