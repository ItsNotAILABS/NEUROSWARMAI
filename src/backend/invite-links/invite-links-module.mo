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
import Map "mo:core/Map";
import Text "mo:core/Text";
import Runtime "mo:core/Runtime";
import Time "mo:core/Time";
import Blob "mo:core/Blob";
import Nat8 "mo:core/Nat8";
import Iter "mo:core/Iter";

module {
  public type InviteLinksSystemState = {
    var rsvps : Map.Map<Text, RSVP>;
    var inviteCodes : Map.Map<Text, InviteCode>;
  };

  public func initState() : InviteLinksSystemState {
    {
      var rsvps = Map.empty<Text, RSVP>();
      var inviteCodes = Map.empty<Text, InviteCode>();
    };
  };

  public type RSVP = {
    name : Text;
    attending : Bool;
    timestamp : Time.Time;
    inviteCode : Text;
  };

  public type InviteCode = {
    code : Text;
    created : Time.Time;
    used : Bool;
  };

  func blobToUUID(blob : Blob) : Text {
    let bytes = blob.toArray();
    func hex(n : Nat8) : Text {
      let digits = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'];
      Text.fromChar(digits[(n / 16).toNat()]) # Text.fromChar(digits[(n % 16).toNat()]);
    };
    var uuid = "";
    for (i in bytes.keys()) {
      if (i == 4 or i == 6 or i == 8 or i == 10) { uuid #= "-" };
      if (i < 16) { uuid #= hex(bytes[i]) };
    };
    uuid;
  };

  public func generateUUID(blob : Blob) : Text {
    blobToUUID(blob);
  };

  public func generateInviteCode(state : InviteLinksSystemState, code : Text) {
    let invite : InviteCode = {
      code;
      created = Time.now();
      used = false;
    };
    state.inviteCodes.add(code, invite);
  };

  public func submitRSVP(state : InviteLinksSystemState, name : Text, attending : Bool, inviteCode : Text) {
    switch (state.inviteCodes.get(inviteCode)) {
      case (null) {
        Runtime.trap("Invalid invite code");
      };
      case (?invite) {
        if (invite.used) {
          Runtime.trap("Invite code already used");
        };
        let rsvp : RSVP = {
          name;
          attending;
          timestamp = Time.now();
          inviteCode;
        };
        let updatedInvite : InviteCode = {
          invite with used = true
        };
        state.rsvps.add(name, rsvp);
        state.inviteCodes.add(inviteCode, updatedInvite);
      };
    };
  };

  public func getAllRSVPs(state : InviteLinksSystemState) : [RSVP] {
    state.rsvps.values().toArray();
  };

  public func getInviteCodes(state : InviteLinksSystemState) : [InviteCode] {
    state.inviteCodes.values().toArray();
  };
};
