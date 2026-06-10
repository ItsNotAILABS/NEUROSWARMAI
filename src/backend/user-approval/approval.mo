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
import Iter "mo:core/Iter";
import Principal "mo:core/Principal";
import AccessControl "../authorization/access-control";

module {
  public type ApprovalStatus = {
    #approved;
    #rejected;
    #pending;
  };

  public type UserApprovalState = {
    var approvalStatus : Map.Map<Principal, ApprovalStatus>;
  };

  public func initState(accessControlState : AccessControl.AccessControlState) : UserApprovalState {
    var approvalStatus = Map.empty<Principal, ApprovalStatus>();
    for ((principal, role) in accessControlState.userRoles.entries()) {
      let status = if (role == #admin) {
        #approved;
      } else {
        #pending;
      };
      approvalStatus.add(principal, status);
    };
    { var approvalStatus };
  };

  public func isApproved(state : UserApprovalState, caller : Principal) : Bool {
    state.approvalStatus.get(caller) == ?#approved;
  };

  public func requestApproval(state : UserApprovalState, caller : Principal) {
    if (state.approvalStatus.get(caller) == null) {
      setApproval(state, caller, #pending);
    };
  };

  public func setApproval(state : UserApprovalState, user : Principal, approval : ApprovalStatus) {
    state.approvalStatus.add(user, approval);
  };

  public type UserApprovalInfo = {
    principal : Principal;
    status : ApprovalStatus;
  };

  public func listApprovals(state : UserApprovalState) : [UserApprovalInfo] {
    let infos = state.approvalStatus.map<Principal, ApprovalStatus, UserApprovalInfo>(
      func(principal, status) {
        {
          principal;
          status;
        };
      }
    );
    infos.values().toArray();
  };
};
