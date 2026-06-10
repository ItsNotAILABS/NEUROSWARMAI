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
// Communication Module — Inter-Organism Message Passing & Collaboration
// Part of the Organism Command Platform Cognitive Architecture
// =====================================================================

import Time "mo:core/Time";
import Array "mo:core/Array";
import Float "mo:core/Float";
import Nat "mo:core/Nat";
import Int "mo:core/Int";
import Text "mo:core/Text";
import Principal "mo:core/Principal";

module CommunicationModule {

  // ===================== Message Types =====================

  public type MessagePriority = {
    #Critical;     // Immediate attention required
    #High;         // Important, process soon
    #Normal;       // Standard priority
    #Low;          // Process when convenient
    #Background;   // Batch processing acceptable
  };

  public type MessageType = {
    #DirectMessage;       // One-to-one communication
    #Broadcast;           // One-to-many
    #Request;             // Requires response
    #Response;            // Reply to request
    #Notification;        // Informational only
    #Command;             // Action directive
    #Acknowledgment;      // Confirmation receipt
    #Error;               // Error notification
    #Heartbeat;           // Health check
    #Sync;                // Synchronization message
  };

  public type MessageStatus = {
    #Pending;
    #Sent;
    #Delivered;
    #Read;
    #Processed;
    #Failed;
    #Expired;
    #Acknowledged;
  };

  // ===================== Channel Types =====================

  public type ChannelType = {
    #Direct;              // One-to-one
    #Group;               // Multiple organisms
    #Broadcast;           // One-to-all
    #Topic;               // Subscribe-based
    #Collaboration;       // Shared workspace
    #Emergency;           // High-priority channel
  };

  public type ChannelVisibility = {
    #Public;
    #Private;
    #Restricted;
  };

  public type ChannelMember = {
    organismId : Text;
    owner : Principal;
    role : Text;          // "owner", "admin", "member", "observer"
    joinedAt : Int;
    lastActivity : Int;
    canSend : Bool;
    canInvite : Bool;
  };

  public type Channel = {
    id : Text;
    name : Text;
    description : Text;
    channelType : ChannelType;
    visibility : ChannelVisibility;
    members : [ChannelMember];
    creator : Principal;
    createdAt : Int;
    updatedAt : Int;
    messageCount : Nat;
    lastMessageAt : Int;
    isActive : Bool;
    metadata : [(Text, Text)];
  };

  // ===================== Message Structure =====================

  public type MessageContent = {
    text : Text;
    format : Text;        // "plain", "markdown", "json", "binary"
    language : ?Text;
    encoding : ?Text;
  };

  public type MessageAttachment = {
    id : Text;
    name : Text;
    mimeType : Text;
    size : Nat;
    contentHash : Text;
    contentRef : ?Text;   // Reference to stored content
  };

  public type Message = {
    id : Text;
    channelId : Text;
    senderId : Text;      // Organism ID
    senderOwner : Principal;
    recipientIds : [Text]; // Target organism IDs
    messageType : MessageType;
    priority : MessagePriority;
    status : MessageStatus;
    content : MessageContent;
    attachments : [MessageAttachment];
    replyToId : ?Text;
    threadId : ?Text;
    timestamp : Int;
    deliveredAt : ?Int;
    readAt : ?Int;
    processedAt : ?Int;
    expiresAt : ?Int;
    metadata : [(Text, Text)];
  };

  // ===================== Collaboration Types =====================

  public type CollaborationType = {
    #TaskExecution;       // Joint task processing
    #DataSharing;         // Shared data access
    #DecisionMaking;      // Consensus building
    #ResourcePooling;     // Shared resource usage
    #KnowledgeTransfer;   // Information exchange
    #Orchestration;       // Workflow coordination
  };

  public type CollaborationStatus = {
    #Proposed;
    #Negotiating;
    #Active;
    #Paused;
    #Completed;
    #Cancelled;
    #Failed;
  };

  public type CollaborationRole = {
    #Initiator;
    #Participant;
    #Observer;
    #Coordinator;
    #Executor;
    #Reviewer;
  };

  public type CollaborationParticipant = {
    organismId : Text;
    owner : Principal;
    role : CollaborationRole;
    contribution : Float;   // Percentage of work/resources
    status : Text;          // "active", "pending", "completed"
    joinedAt : Int;
    lastContribution : Int;
  };

  public type CollaborationTask = {
    id : Text;
    name : Text;
    description : Text;
    assignedTo : [Text];    // Organism IDs
    status : Text;
    priority : MessagePriority;
    deadline : ?Int;
    createdAt : Int;
    completedAt : ?Int;
    output : ?Text;
  };

  public type Collaboration = {
    id : Text;
    name : Text;
    description : Text;
    collaborationType : CollaborationType;
    status : CollaborationStatus;
    participants : [CollaborationParticipant];
    tasks : [CollaborationTask];
    initiator : Principal;
    initiatorOrganism : Text;
    createdAt : Int;
    updatedAt : Int;
    startedAt : ?Int;
    completedAt : ?Int;
    deadline : ?Int;
    outcome : ?Text;
    sharedData : [(Text, Text)];
    metrics : CollaborationMetrics;
  };

  public type CollaborationMetrics = {
    totalTasks : Nat;
    completedTasks : Nat;
    activeParticipants : Nat;
    messagesExchanged : Nat;
    avgResponseTime : Float;
    progressPercent : Float;
    qualityScore : Float;
  };

  // ===================== Protocol Types =====================

  public type ProtocolType = {
    #RequestResponse;
    #PublishSubscribe;
    #Streaming;
    #Consensus;
    #Handshake;
  };

  public type ProtocolState = {
    #Idle;
    #Initiating;
    #Negotiating;
    #Established;
    #Transmitting;
    #Closing;
    #Closed;
    #Error;
  };

  public type ProtocolSession = {
    id : Text;
    protocolType : ProtocolType;
    state : ProtocolState;
    initiator : Text;       // Organism ID
    responder : Text;       // Organism ID
    createdAt : Int;
    lastActivity : Int;
    messageCount : Nat;
    errorCount : Nat;
    metadata : [(Text, Text)];
  };

  // ===================== Subscription Types =====================

  public type Subscription = {
    id : Text;
    subscriberId : Text;    // Organism ID
    subscriberOwner : Principal;
    channelId : Text;
    topicPattern : ?Text;   // For topic channels
    filters : [(Text, Text)];
    createdAt : Int;
    expiresAt : ?Int;
    isActive : Bool;
    messageCount : Nat;
    lastDeliveredAt : Int;
  };

  // ===================== State Management =====================

  public type CommunicationState = {
    var channels : [Channel];
    var messages : [Message];
    var collaborations : [Collaboration];
    var subscriptions : [Subscription];
    var protocolSessions : [ProtocolSession];
    var messageCounter : Nat;
    var channelCounter : Nat;
    var collaborationCounter : Nat;
    var undeliveredMessages : [Message];
    var failedMessages : [Message];
  };

  public func initState() : CommunicationState {
    {
      var channels = [];
      var messages = [];
      var collaborations = [];
      var subscriptions = [];
      var protocolSessions = [];
      var messageCounter = 0;
      var channelCounter = 0;
      var collaborationCounter = 0;
      var undeliveredMessages = [];
      var failedMessages = [];
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

  // ===================== Channel Management =====================

  public func createChannel(
    state : CommunicationState,
    name : Text,
    description : Text,
    channelType : ChannelType,
    visibility : ChannelVisibility,
    creator : Principal,
    creatorOrganism : Text,
  ) : Result<Channel, Text> {
    state.channelCounter += 1;
    let now = Time.now();
    
    let initialMember : ChannelMember = {
      organismId = creatorOrganism;
      owner = creator;
      role = "owner";
      joinedAt = now;
      lastActivity = now;
      canSend = true;
      canInvite = true;
    };
    
    let channel : Channel = {
      id = "ch-" # state.channelCounter.toText();
      name;
      description;
      channelType;
      visibility;
      members = [initialMember];
      creator;
      createdAt = now;
      updatedAt = now;
      messageCount = 0;
      lastMessageAt = 0;
      isActive = true;
      metadata = [];
    };
    
    state.channels := arrayAppend(state.channels, [channel]);
    #ok(channel);
  };

  public func joinChannel(
    state : CommunicationState,
    channelId : Text,
    organismId : Text,
    owner : Principal,
    role : Text,
  ) : Result<Channel, Text> {
    switch (findChannel(state, channelId)) {
      case null #err("Channel not found");
      case (?channel) {
        if (not channel.isActive) {
          return #err("Channel is not active");
        };
        
        // Check if already member
        for (m in channel.members.vals()) {
          if (m.organismId == organismId) {
            return #err("Already a member");
          };
        };
        
        // Check visibility restrictions
        if (channel.visibility == #Private) {
          return #err("Private channel - invitation required");
        };
        
        let now = Time.now();
        let newMember : ChannelMember = {
          organismId;
          owner;
          role;
          joinedAt = now;
          lastActivity = now;
          canSend = channel.visibility != #Restricted;
          canInvite = false;
        };
        
        let updated : Channel = {
          id = channel.id;
          name = channel.name;
          description = channel.description;
          channelType = channel.channelType;
          visibility = channel.visibility;
          members = arrayAppend(channel.members, [newMember]);
          creator = channel.creator;
          createdAt = channel.createdAt;
          updatedAt = now;
          messageCount = channel.messageCount;
          lastMessageAt = channel.lastMessageAt;
          isActive = channel.isActive;
          metadata = channel.metadata;
        };
        
        upsertChannel(state, updated);
        #ok(updated);
      };
    };
  };

  public func inviteToChannel(
    state : CommunicationState,
    channelId : Text,
    inviter : Principal,
    inviterOrganism : Text,
    inviteeOrganism : Text,
    inviteeOwner : Principal,
  ) : Result<Channel, Text> {
    switch (findChannel(state, channelId)) {
      case null #err("Channel not found");
      case (?channel) {
        // Check inviter has permission
        var canInvite = false;
        for (m in channel.members.vals()) {
          if (m.organismId == inviterOrganism and m.canInvite) {
            canInvite := true;
          };
        };
        
        if (not canInvite) {
          return #err("No permission to invite");
        };
        
        // Check if invitee already member
        for (m in channel.members.vals()) {
          if (m.organismId == inviteeOrganism) {
            return #err("Already a member");
          };
        };
        
        let now = Time.now();
        let newMember : ChannelMember = {
          organismId = inviteeOrganism;
          owner = inviteeOwner;
          role = "member";
          joinedAt = now;
          lastActivity = now;
          canSend = true;
          canInvite = false;
        };
        
        let updated : Channel = {
          id = channel.id;
          name = channel.name;
          description = channel.description;
          channelType = channel.channelType;
          visibility = channel.visibility;
          members = arrayAppend(channel.members, [newMember]);
          creator = channel.creator;
          createdAt = channel.createdAt;
          updatedAt = now;
          messageCount = channel.messageCount;
          lastMessageAt = channel.lastMessageAt;
          isActive = channel.isActive;
          metadata = channel.metadata;
        };
        
        upsertChannel(state, updated);
        #ok(updated);
      };
    };
  };

  public func leaveChannel(
    state : CommunicationState,
    channelId : Text,
    organismId : Text,
    owner : Principal,
  ) : Result<(), Text> {
    switch (findChannel(state, channelId)) {
      case null #err("Channel not found");
      case (?channel) {
        var isOwner = false;
        for (m in channel.members.vals()) {
          if (m.organismId == organismId and m.role == "owner") {
            isOwner := true;
          };
        };
        
        if (isOwner and channel.members.size() > 1) {
          return #err("Owner cannot leave with other members present");
        };
        
        let newMembers = arrayFilter(channel.members, func(m : ChannelMember) : Bool {
          m.organismId != organismId
        });
        
        let updated : Channel = {
          id = channel.id;
          name = channel.name;
          description = channel.description;
          channelType = channel.channelType;
          visibility = channel.visibility;
          members = newMembers;
          creator = channel.creator;
          createdAt = channel.createdAt;
          updatedAt = Time.now();
          messageCount = channel.messageCount;
          lastMessageAt = channel.lastMessageAt;
          isActive = newMembers.size() > 0;
          metadata = channel.metadata;
        };
        
        upsertChannel(state, updated);
        #ok(());
      };
    };
  };

  func findChannel(state : CommunicationState, id : Text) : ?Channel {
    arrayFind(state.channels, func(c : Channel) : Bool { c.id == id });
  };

  func upsertChannel(state : CommunicationState, updated : Channel) {
    var found = false;
    var newStore : [Channel] = [];
    for (c in state.channels.vals()) {
      if (c.id == updated.id) {
        newStore := arrayAppend(newStore, [updated]);
        found := true;
      } else {
        newStore := arrayAppend(newStore, [c]);
      };
    };
    if (not found) {
      newStore := arrayAppend(newStore, [updated]);
    };
    state.channels := newStore;
  };

  // ===================== Message Handling =====================

  public func sendMessage(
    state : CommunicationState,
    channelId : Text,
    senderId : Text,
    senderOwner : Principal,
    recipientIds : [Text],
    messageType : MessageType,
    priority : MessagePriority,
    content : MessageContent,
    attachments : [MessageAttachment],
    replyToId : ?Text,
    threadId : ?Text,
    expiresAt : ?Int,
    metadata : [(Text, Text)],
  ) : Result<Message, Text> {
    switch (findChannel(state, channelId)) {
      case null #err("Channel not found");
      case (?channel) {
        // Verify sender is member with send permission
        var canSend = false;
        for (m in channel.members.vals()) {
          if (m.organismId == senderId and m.canSend) {
            canSend := true;
          };
        };
        
        if (not canSend) {
          return #err("No permission to send");
        };
        
        state.messageCounter += 1;
        let now = Time.now();
        
        let message : Message = {
          id = "msg-" # state.messageCounter.toText();
          channelId;
          senderId;
          senderOwner;
          recipientIds;
          messageType;
          priority;
          status = #Sent;
          content;
          attachments;
          replyToId;
          threadId;
          timestamp = now;
          deliveredAt = null;
          readAt = null;
          processedAt = null;
          expiresAt;
          metadata;
        };
        
        state.messages := arrayAppend(state.messages, [message]);
        
        // Update channel stats
        let updatedChannel : Channel = {
          id = channel.id;
          name = channel.name;
          description = channel.description;
          channelType = channel.channelType;
          visibility = channel.visibility;
          members = channel.members;
          creator = channel.creator;
          createdAt = channel.createdAt;
          updatedAt = now;
          messageCount = channel.messageCount + 1;
          lastMessageAt = now;
          isActive = channel.isActive;
          metadata = channel.metadata;
        };
        upsertChannel(state, updatedChannel);
        
        #ok(message);
      };
    };
  };

  public func markMessageDelivered(
    state : CommunicationState,
    messageId : Text,
  ) : Result<Message, Text> {
    switch (findMessage(state, messageId)) {
      case null #err("Message not found");
      case (?message) {
        let updated : Message = {
          id = message.id;
          channelId = message.channelId;
          senderId = message.senderId;
          senderOwner = message.senderOwner;
          recipientIds = message.recipientIds;
          messageType = message.messageType;
          priority = message.priority;
          status = #Delivered;
          content = message.content;
          attachments = message.attachments;
          replyToId = message.replyToId;
          threadId = message.threadId;
          timestamp = message.timestamp;
          deliveredAt = ?Time.now();
          readAt = message.readAt;
          processedAt = message.processedAt;
          expiresAt = message.expiresAt;
          metadata = message.metadata;
        };
        upsertMessage(state, updated);
        #ok(updated);
      };
    };
  };

  public func markMessageRead(
    state : CommunicationState,
    messageId : Text,
    readerId : Text,
  ) : Result<Message, Text> {
    switch (findMessage(state, messageId)) {
      case null #err("Message not found");
      case (?message) {
        // Verify reader is recipient
        var isRecipient = false;
        for (r in message.recipientIds.vals()) {
          if (r == readerId) isRecipient := true;
        };
        
        if (not isRecipient and message.recipientIds.size() > 0) {
          return #err("Not a recipient");
        };
        
        let updated : Message = {
          id = message.id;
          channelId = message.channelId;
          senderId = message.senderId;
          senderOwner = message.senderOwner;
          recipientIds = message.recipientIds;
          messageType = message.messageType;
          priority = message.priority;
          status = #Read;
          content = message.content;
          attachments = message.attachments;
          replyToId = message.replyToId;
          threadId = message.threadId;
          timestamp = message.timestamp;
          deliveredAt = message.deliveredAt;
          readAt = ?Time.now();
          processedAt = message.processedAt;
          expiresAt = message.expiresAt;
          metadata = message.metadata;
        };
        upsertMessage(state, updated);
        #ok(updated);
      };
    };
  };

  public func markMessageProcessed(
    state : CommunicationState,
    messageId : Text,
    processorId : Text,
  ) : Result<Message, Text> {
    switch (findMessage(state, messageId)) {
      case null #err("Message not found");
      case (?message) {
        let updated : Message = {
          id = message.id;
          channelId = message.channelId;
          senderId = message.senderId;
          senderOwner = message.senderOwner;
          recipientIds = message.recipientIds;
          messageType = message.messageType;
          priority = message.priority;
          status = #Processed;
          content = message.content;
          attachments = message.attachments;
          replyToId = message.replyToId;
          threadId = message.threadId;
          timestamp = message.timestamp;
          deliveredAt = message.deliveredAt;
          readAt = message.readAt;
          processedAt = ?Time.now();
          expiresAt = message.expiresAt;
          metadata = message.metadata;
        };
        upsertMessage(state, updated);
        #ok(updated);
      };
    };
  };

  func findMessage(state : CommunicationState, id : Text) : ?Message {
    arrayFind(state.messages, func(m : Message) : Bool { m.id == id });
  };

  func upsertMessage(state : CommunicationState, updated : Message) {
    var found = false;
    var newStore : [Message] = [];
    for (m in state.messages.vals()) {
      if (m.id == updated.id) {
        newStore := arrayAppend(newStore, [updated]);
        found := true;
      } else {
        newStore := arrayAppend(newStore, [m]);
      };
    };
    if (not found) {
      newStore := arrayAppend(newStore, [updated]);
    };
    state.messages := newStore;
  };

  // ===================== Collaboration Management =====================

  public func createCollaboration(
    state : CommunicationState,
    name : Text,
    description : Text,
    collaborationType : CollaborationType,
    initiator : Principal,
    initiatorOrganism : Text,
    deadline : ?Int,
  ) : Result<Collaboration, Text> {
    state.collaborationCounter += 1;
    let now = Time.now();
    
    let initialParticipant : CollaborationParticipant = {
      organismId = initiatorOrganism;
      owner = initiator;
      role = #Initiator;
      contribution = 0.0;
      status = "active";
      joinedAt = now;
      lastContribution = now;
    };
    
    let collaboration : Collaboration = {
      id = "collab-" # state.collaborationCounter.toText();
      name;
      description;
      collaborationType;
      status = #Proposed;
      participants = [initialParticipant];
      tasks = [];
      initiator;
      initiatorOrganism;
      createdAt = now;
      updatedAt = now;
      startedAt = null;
      completedAt = null;
      deadline;
      outcome = null;
      sharedData = [];
      metrics = {
        totalTasks = 0;
        completedTasks = 0;
        activeParticipants = 1;
        messagesExchanged = 0;
        avgResponseTime = 0.0;
        progressPercent = 0.0;
        qualityScore = 0.0;
      };
    };
    
    state.collaborations := arrayAppend(state.collaborations, [collaboration]);
    #ok(collaboration);
  };

  public func inviteToCollaboration(
    state : CommunicationState,
    collaborationId : Text,
    inviter : Principal,
    inviteeOrganism : Text,
    inviteeOwner : Principal,
    role : CollaborationRole,
  ) : Result<Collaboration, Text> {
    switch (findCollaboration(state, collaborationId)) {
      case null #err("Collaboration not found");
      case (?collab) {
        if (collab.initiator != inviter) {
          return #err("Only initiator can invite");
        };
        
        // Check if already participant
        for (p in collab.participants.vals()) {
          if (p.organismId == inviteeOrganism) {
            return #err("Already a participant");
          };
        };
        
        let now = Time.now();
        let newParticipant : CollaborationParticipant = {
          organismId = inviteeOrganism;
          owner = inviteeOwner;
          role;
          contribution = 0.0;
          status = "pending";
          joinedAt = now;
          lastContribution = now;
        };
        
        let updated : Collaboration = {
          id = collab.id;
          name = collab.name;
          description = collab.description;
          collaborationType = collab.collaborationType;
          status = collab.status;
          participants = arrayAppend(collab.participants, [newParticipant]);
          tasks = collab.tasks;
          initiator = collab.initiator;
          initiatorOrganism = collab.initiatorOrganism;
          createdAt = collab.createdAt;
          updatedAt = now;
          startedAt = collab.startedAt;
          completedAt = collab.completedAt;
          deadline = collab.deadline;
          outcome = collab.outcome;
          sharedData = collab.sharedData;
          metrics = collab.metrics;
        };
        
        upsertCollaboration(state, updated);
        #ok(updated);
      };
    };
  };

  public func acceptCollaboration(
    state : CommunicationState,
    collaborationId : Text,
    organismId : Text,
    owner : Principal,
  ) : Result<Collaboration, Text> {
    switch (findCollaboration(state, collaborationId)) {
      case null #err("Collaboration not found");
      case (?collab) {
        let now = Time.now();
        var found = false;
        
        let newParticipants = arrayMap(collab.participants, func(p : CollaborationParticipant) : CollaborationParticipant {
          if (p.organismId == organismId and p.owner == owner) {
            found := true;
            {
              organismId = p.organismId;
              owner = p.owner;
              role = p.role;
              contribution = p.contribution;
              status = "active";
              joinedAt = p.joinedAt;
              lastContribution = now;
            };
          } else p;
        });
        
        if (not found) {
          return #err("Not a participant");
        };
        
        let activeCount = arrayFilter(newParticipants, func(p : CollaborationParticipant) : Bool {
          p.status == "active"
        }).size();
        
        let updated : Collaboration = {
          id = collab.id;
          name = collab.name;
          description = collab.description;
          collaborationType = collab.collaborationType;
          status = if (collab.status == #Proposed and activeCount > 1) #Negotiating else collab.status;
          participants = newParticipants;
          tasks = collab.tasks;
          initiator = collab.initiator;
          initiatorOrganism = collab.initiatorOrganism;
          createdAt = collab.createdAt;
          updatedAt = now;
          startedAt = collab.startedAt;
          completedAt = collab.completedAt;
          deadline = collab.deadline;
          outcome = collab.outcome;
          sharedData = collab.sharedData;
          metrics = {
            totalTasks = collab.metrics.totalTasks;
            completedTasks = collab.metrics.completedTasks;
            activeParticipants = activeCount;
            messagesExchanged = collab.metrics.messagesExchanged;
            avgResponseTime = collab.metrics.avgResponseTime;
            progressPercent = collab.metrics.progressPercent;
            qualityScore = collab.metrics.qualityScore;
          };
        };
        
        upsertCollaboration(state, updated);
        #ok(updated);
      };
    };
  };

  public func startCollaboration(
    state : CommunicationState,
    collaborationId : Text,
    caller : Principal,
  ) : Result<Collaboration, Text> {
    switch (findCollaboration(state, collaborationId)) {
      case null #err("Collaboration not found");
      case (?collab) {
        if (collab.initiator != caller) {
          return #err("Only initiator can start");
        };
        
        if (collab.status != #Negotiating and collab.status != #Proposed) {
          return #err("Invalid status for starting");
        };
        
        let now = Time.now();
        let updated : Collaboration = {
          id = collab.id;
          name = collab.name;
          description = collab.description;
          collaborationType = collab.collaborationType;
          status = #Active;
          participants = collab.participants;
          tasks = collab.tasks;
          initiator = collab.initiator;
          initiatorOrganism = collab.initiatorOrganism;
          createdAt = collab.createdAt;
          updatedAt = now;
          startedAt = ?now;
          completedAt = collab.completedAt;
          deadline = collab.deadline;
          outcome = collab.outcome;
          sharedData = collab.sharedData;
          metrics = collab.metrics;
        };
        
        upsertCollaboration(state, updated);
        #ok(updated);
      };
    };
  };

  public func addCollaborationTask(
    state : CommunicationState,
    collaborationId : Text,
    taskName : Text,
    taskDescription : Text,
    assignedTo : [Text],
    priority : MessagePriority,
    deadline : ?Int,
    caller : Principal,
  ) : Result<CollaborationTask, Text> {
    switch (findCollaboration(state, collaborationId)) {
      case null #err("Collaboration not found");
      case (?collab) {
        // Verify caller is participant
        var isParticipant = false;
        for (p in collab.participants.vals()) {
          if (p.owner == caller and p.status == "active") {
            isParticipant := true;
          };
        };
        
        if (not isParticipant) {
          return #err("Not an active participant");
        };
        
        let now = Time.now();
        let task : CollaborationTask = {
          id = "task-" # now.toText();
          name = taskName;
          description = taskDescription;
          assignedTo;
          status = "pending";
          priority;
          deadline;
          createdAt = now;
          completedAt = null;
          output = null;
        };
        
        let updated : Collaboration = {
          id = collab.id;
          name = collab.name;
          description = collab.description;
          collaborationType = collab.collaborationType;
          status = collab.status;
          participants = collab.participants;
          tasks = arrayAppend(collab.tasks, [task]);
          initiator = collab.initiator;
          initiatorOrganism = collab.initiatorOrganism;
          createdAt = collab.createdAt;
          updatedAt = now;
          startedAt = collab.startedAt;
          completedAt = collab.completedAt;
          deadline = collab.deadline;
          outcome = collab.outcome;
          sharedData = collab.sharedData;
          metrics = {
            totalTasks = collab.metrics.totalTasks + 1;
            completedTasks = collab.metrics.completedTasks;
            activeParticipants = collab.metrics.activeParticipants;
            messagesExchanged = collab.metrics.messagesExchanged;
            avgResponseTime = collab.metrics.avgResponseTime;
            progressPercent = if (collab.metrics.totalTasks + 1 > 0) 
              collab.metrics.completedTasks.toFloat() / (collab.metrics.totalTasks + 1).toFloat() * 100.0
            else 0.0;
            qualityScore = collab.metrics.qualityScore;
          };
        };
        
        upsertCollaboration(state, updated);
        #ok(task);
      };
    };
  };

  public func completeCollaborationTask(
    state : CommunicationState,
    collaborationId : Text,
    taskId : Text,
    output : Text,
    completorId : Text,
    completorOwner : Principal,
  ) : Result<CollaborationTask, Text> {
    switch (findCollaboration(state, collaborationId)) {
      case null #err("Collaboration not found");
      case (?collab) {
        // Find and update task
        var taskFound = false;
        var completedTask : ?CollaborationTask = null;
        let now = Time.now();
        
        let newTasks = arrayMap(collab.tasks, func(t : CollaborationTask) : CollaborationTask {
          if (t.id == taskId and t.status != "completed") {
            taskFound := true;
            let updated : CollaborationTask = {
              id = t.id;
              name = t.name;
              description = t.description;
              assignedTo = t.assignedTo;
              status = "completed";
              priority = t.priority;
              deadline = t.deadline;
              createdAt = t.createdAt;
              completedAt = ?now;
              output = ?output;
            };
            completedTask := ?updated;
            updated;
          } else t;
        });
        
        if (not taskFound) {
          return #err("Task not found or already completed");
        };
        
        let completedCount = arrayFilter(newTasks, func(t : CollaborationTask) : Bool {
          t.status == "completed"
        }).size();
        
        // Update participant contribution
        let newParticipants = arrayMap(collab.participants, func(p : CollaborationParticipant) : CollaborationParticipant {
          if (p.organismId == completorId) {
            {
              organismId = p.organismId;
              owner = p.owner;
              role = p.role;
              contribution = p.contribution + (100.0 / collab.tasks.size().toFloat());
              status = p.status;
              joinedAt = p.joinedAt;
              lastContribution = now;
            };
          } else p;
        });
        
        let updated : Collaboration = {
          id = collab.id;
          name = collab.name;
          description = collab.description;
          collaborationType = collab.collaborationType;
          status = collab.status;
          participants = newParticipants;
          tasks = newTasks;
          initiator = collab.initiator;
          initiatorOrganism = collab.initiatorOrganism;
          createdAt = collab.createdAt;
          updatedAt = now;
          startedAt = collab.startedAt;
          completedAt = collab.completedAt;
          deadline = collab.deadline;
          outcome = collab.outcome;
          sharedData = collab.sharedData;
          metrics = {
            totalTasks = collab.metrics.totalTasks;
            completedTasks = completedCount;
            activeParticipants = collab.metrics.activeParticipants;
            messagesExchanged = collab.metrics.messagesExchanged;
            avgResponseTime = collab.metrics.avgResponseTime;
            progressPercent = completedCount.toFloat() / collab.metrics.totalTasks.toFloat() * 100.0;
            qualityScore = collab.metrics.qualityScore;
          };
        };
        
        upsertCollaboration(state, updated);
        
        switch completedTask {
          case (?t) #ok(t);
          case null #err("Failed to complete task");
        };
      };
    };
  };

  public func completeCollaboration(
    state : CommunicationState,
    collaborationId : Text,
    outcome : Text,
    caller : Principal,
  ) : Result<Collaboration, Text> {
    switch (findCollaboration(state, collaborationId)) {
      case null #err("Collaboration not found");
      case (?collab) {
        if (collab.initiator != caller) {
          return #err("Only initiator can complete");
        };
        
        if (collab.status != #Active) {
          return #err("Collaboration not active");
        };
        
        let now = Time.now();
        let updated : Collaboration = {
          id = collab.id;
          name = collab.name;
          description = collab.description;
          collaborationType = collab.collaborationType;
          status = #Completed;
          participants = collab.participants;
          tasks = collab.tasks;
          initiator = collab.initiator;
          initiatorOrganism = collab.initiatorOrganism;
          createdAt = collab.createdAt;
          updatedAt = now;
          startedAt = collab.startedAt;
          completedAt = ?now;
          deadline = collab.deadline;
          outcome = ?outcome;
          sharedData = collab.sharedData;
          metrics = {
            totalTasks = collab.metrics.totalTasks;
            completedTasks = collab.metrics.completedTasks;
            activeParticipants = collab.metrics.activeParticipants;
            messagesExchanged = collab.metrics.messagesExchanged;
            avgResponseTime = collab.metrics.avgResponseTime;
            progressPercent = 100.0;
            qualityScore = collab.metrics.completedTasks.toFloat() / Float.max(1.0, collab.metrics.totalTasks.toFloat());
          };
        };
        
        upsertCollaboration(state, updated);
        #ok(updated);
      };
    };
  };

  func findCollaboration(state : CommunicationState, id : Text) : ?Collaboration {
    arrayFind(state.collaborations, func(c : Collaboration) : Bool { c.id == id });
  };

  func upsertCollaboration(state : CommunicationState, updated : Collaboration) {
    var found = false;
    var newStore : [Collaboration] = [];
    for (c in state.collaborations.vals()) {
      if (c.id == updated.id) {
        newStore := arrayAppend(newStore, [updated]);
        found := true;
      } else {
        newStore := arrayAppend(newStore, [c]);
      };
    };
    if (not found) {
      newStore := arrayAppend(newStore, [updated]);
    };
    state.collaborations := newStore;
  };

  // ===================== Subscription Management =====================

  public func subscribe(
    state : CommunicationState,
    subscriberId : Text,
    subscriberOwner : Principal,
    channelId : Text,
    topicPattern : ?Text,
    filters : [(Text, Text)],
    expiresAt : ?Int,
  ) : Result<Subscription, Text> {
    switch (findChannel(state, channelId)) {
      case null #err("Channel not found");
      case (?channel) {
        if (channel.channelType != #Topic and channel.channelType != #Broadcast) {
          return #err("Channel does not support subscriptions");
        };
        
        let now = Time.now();
        let subscription : Subscription = {
          id = "sub-" # now.toText();
          subscriberId;
          subscriberOwner;
          channelId;
          topicPattern;
          filters;
          createdAt = now;
          expiresAt;
          isActive = true;
          messageCount = 0;
          lastDeliveredAt = 0;
        };
        
        state.subscriptions := arrayAppend(state.subscriptions, [subscription]);
        #ok(subscription);
      };
    };
  };

  public func unsubscribe(
    state : CommunicationState,
    subscriptionId : Text,
    caller : Principal,
  ) : Result<(), Text> {
    var found = false;
    state.subscriptions := arrayMap(state.subscriptions, func(s : Subscription) : Subscription {
      if (s.id == subscriptionId and s.subscriberOwner == caller) {
        found := true;
        {
          id = s.id;
          subscriberId = s.subscriberId;
          subscriberOwner = s.subscriberOwner;
          channelId = s.channelId;
          topicPattern = s.topicPattern;
          filters = s.filters;
          createdAt = s.createdAt;
          expiresAt = s.expiresAt;
          isActive = false;
          messageCount = s.messageCount;
          lastDeliveredAt = s.lastDeliveredAt;
        };
      } else s;
    });
    
    if (found) #ok(()) else #err("Subscription not found");
  };

  // ===================== Query Functions =====================

  public func getChannelMessages(
    state : CommunicationState,
    channelId : Text,
    limit : Nat,
    beforeTimestamp : ?Int,
  ) : [Message] {
    let cutoff = switch beforeTimestamp {
      case (?t) t;
      case null Time.now() + 1;
    };
    
    var result : [Message] = [];
    var count : Nat = 0;
    
    // Iterate in reverse for most recent
    let size = state.messages.size();
    var i = size;
    while (i > 0 and count < limit) {
      i -= 1;
      let m = state.messages[i];
      if (m.channelId == channelId and m.timestamp < cutoff) {
        result := arrayAppend(result, [m]);
        count += 1;
      };
    };
    result;
  };

  public func getThreadMessages(
    state : CommunicationState,
    threadId : Text,
  ) : [Message] {
    arrayFilter(state.messages, func(m : Message) : Bool {
      switch m.threadId {
        case (?tid) tid == threadId;
        case null false;
      }
    });
  };

  public func getUnreadMessages(
    state : CommunicationState,
    organismId : Text,
  ) : [Message] {
    arrayFilter(state.messages, func(m : Message) : Bool {
      m.status != #Read and m.status != #Processed and (
        m.recipientIds.size() == 0 or 
        arrayFind(m.recipientIds, func(r : Text) : Bool { r == organismId }) != null
      )
    });
  };

  public func getChannelsForOrganism(
    state : CommunicationState,
    organismId : Text,
  ) : [Channel] {
    arrayFilter(state.channels, func(c : Channel) : Bool {
      arrayFind(c.members, func(m : ChannelMember) : Bool { 
        m.organismId == organismId 
      }) != null
    });
  };

  public func getCollaborationsForOrganism(
    state : CommunicationState,
    organismId : Text,
  ) : [Collaboration] {
    arrayFilter(state.collaborations, func(c : Collaboration) : Bool {
      arrayFind(c.participants, func(p : CollaborationParticipant) : Bool { 
        p.organismId == organismId 
      }) != null
    });
  };

  public func getActiveCollaborations(state : CommunicationState) : [Collaboration] {
    arrayFilter(state.collaborations, func(c : Collaboration) : Bool {
      c.status == #Active
    });
  };

  public func getSubscriptionsForOrganism(
    state : CommunicationState,
    organismId : Text,
  ) : [Subscription] {
    arrayFilter(state.subscriptions, func(s : Subscription) : Bool {
      s.subscriberId == organismId and s.isActive
    });
  };

  // ===================== Cleanup Functions =====================

  public func expireOldMessages(state : CommunicationState) {
    let now = Time.now();
    state.messages := arrayMap(state.messages, func(m : Message) : Message {
      let expired = switch m.expiresAt {
        case (?exp) now > exp;
        case null false;
      };
      if (expired and m.status != #Expired) {
        {
          id = m.id;
          channelId = m.channelId;
          senderId = m.senderId;
          senderOwner = m.senderOwner;
          recipientIds = m.recipientIds;
          messageType = m.messageType;
          priority = m.priority;
          status = #Expired;
          content = m.content;
          attachments = m.attachments;
          replyToId = m.replyToId;
          threadId = m.threadId;
          timestamp = m.timestamp;
          deliveredAt = m.deliveredAt;
          readAt = m.readAt;
          processedAt = m.processedAt;
          expiresAt = m.expiresAt;
          metadata = m.metadata;
        };
      } else m;
    });
  };

  public func cleanupInactiveSubscriptions(state : CommunicationState) {
    let now = Time.now();
    state.subscriptions := arrayMap(state.subscriptions, func(s : Subscription) : Subscription {
      let expired = switch s.expiresAt {
        case (?exp) now > exp;
        case null false;
      };
      if (expired and s.isActive) {
        {
          id = s.id;
          subscriberId = s.subscriberId;
          subscriberOwner = s.subscriberOwner;
          channelId = s.channelId;
          topicPattern = s.topicPattern;
          filters = s.filters;
          createdAt = s.createdAt;
          expiresAt = s.expiresAt;
          isActive = false;
          messageCount = s.messageCount;
          lastDeliveredAt = s.lastDeliveredAt;
        };
      } else s;
    });
  };

  public func archiveOldMessages(
    state : CommunicationState,
    maxAge : Int,
  ) : [Message] {
    let cutoff = Time.now() - maxAge;
    let archived = arrayFilter(state.messages, func(m : Message) : Bool {
      m.timestamp < cutoff
    });
    
    state.messages := arrayFilter(state.messages, func(m : Message) : Bool {
      m.timestamp >= cutoff
    });
    
    archived;
  };

};
