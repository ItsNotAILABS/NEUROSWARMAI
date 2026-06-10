// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  SOVEREIGN AI — EDGE NODE BUS PROTOCOL ENGINE                                                             ║
// ║  Zero Third-Party Dependencies — ITAR/EAR Compliant — Air-Gap Ready                                      ║
// ║                                                                                                           ║
// ║  SPI / I2C / UART Protocol Layer for Ultra-Cheap Tactical Edge Nodes                                      ║
// ║  Extreme Low-Overhead Communication — Deterministic Latency — EW-Resilient                                ║
// ║                                                                                                           ║
// ║  EXPORT CONTROL: This module may be subject to ITAR (22 CFR §120-130) / EAR (15 CFR §730-774)           ║
// ║  DO NOT EXPORT without proper BIS/DDTC authorization.                                                     ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

import Array "mo:core/Array";
import Nat "mo:core/Nat";
import Nat8 "mo:core/Nat8";
import Nat16 "mo:core/Nat16";
import Nat32 "mo:core/Nat32";
import Int "mo:core/Int";
import Iter "mo:core/Iter";
import Text "mo:core/Text";

module SovereignEdgeNode {

  // ═══════════════════════════════════════════════════════════════════════════════
  // TYPES — BUS PROTOCOL SELECTION
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Available bus protocols for edge node communication
  public type BusProtocol = {
    #SPI;        // Serial Peripheral Interface — high-speed, full-duplex
    #I2C;        // Inter-Integrated Circuit — multi-device, 2-wire
    #UART;       // Universal Async Receiver/Transmitter — point-to-point
  };

  /// Edge node operational status
  public type NodeStatus = {
    #ACTIVE;             // Operational and responding
    #SLEEPING;           // Low-power mode, wake-on-interrupt
    #FAULT;             // Hardware fault detected
    #UNREACHABLE;       // No response within timeout
    #COMPROMISED;       // Integrity check failed
    #ZEROIZED;          // Securely erased per DoD 5220.22-M
  };

  /// Edge node identity and capability
  public type EdgeNodeDescriptor = {
    nodeId : Nat16;                // Unique node ID (0x0001-0xFFFE)
    busAddress : Nat8;             // I2C address or SPI chip-select index
    protocol : BusProtocol;        // Communication protocol
    capabilities : NodeCapabilities;
    firmwareVersion : Nat32;       // Version as major.minor.patch packed
    status : NodeStatus;
    lastHeartbeat : Int;           // Timestamp of last successful ping
    qshaAttestation : [Nat8];     // 32-byte QSHA hash of firmware image
  };

  /// What an edge node can do
  public type NodeCapabilities = {
    canInference : Bool;           // Can run NF4 quantized inference
    canSignal : Bool;              // Has ADC for signal acquisition
    canCrypto : Bool;              // Can compute QSHA commitments
    maxBatchSize : Nat;            // Max vectors per batch
    ramBytes : Nat32;              // Available RAM in bytes
    clockMhz : Nat16;             // CPU clock speed
    hasSecureBoot : Bool;          // Verified boot chain
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // TYPES — FRAME PROTOCOL (WIRE FORMAT)
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Frame header — all bus protocols use this common frame structure
  /// Total overhead: 12 bytes (minimal for tactical edge)
  public type FrameHeader = {
    magic : Nat16;           // 0x4E53 ("NS" — NeuroSwarm)
    version : Nat8;          // Protocol version
    frameType : FrameType;   // What this frame carries
    sequenceNum : Nat16;     // Sequence for ordering/dedup
    payloadLen : Nat16;      // Payload length in bytes
    sourceNode : Nat16;      // Source node ID
    destNode : Nat16;        // Destination node ID (0xFFFF = broadcast)
  };

  /// Frame types — what payload carries
  public type FrameType = {
    #HEARTBEAT;              // Keep-alive ping
    #INFERENCE_REQUEST;      // NF4 quantized inference request
    #INFERENCE_RESPONSE;     // Inference result
    #SIGNAL_DATA;            // Raw signal samples from ADC
    #QSHA_COMMITMENT;        // Phantom QSHA hash commitment
    #FIRMWARE_CHUNK;         // OTA firmware update chunk
    #COMMAND;                // Control command
    #ACK;                    // Acknowledgement
    #NACK;                   // Negative acknowledgement
    #ATTESTATION;            // Node attestation request/response
    #ZEROIZE;                // Secure destruction command
  };

  /// Complete wire frame
  public type Frame = {
    header : FrameHeader;
    payload : [Nat8];
    crc16 : Nat16;           // CRC-16/CCITT for integrity
  };

  /// Frame magic bytes
  public let FRAME_MAGIC : Nat16 = 0x4E53; // "NS"
  public let PROTOCOL_VERSION : Nat8 = 0x01;
  public let BROADCAST_ADDR : Nat16 = 0xFFFF;

  // ═══════════════════════════════════════════════════════════════════════════════
  // CRC-16/CCITT — SOVEREIGN IMPLEMENTATION
  // Polynomial: x^16 + x^12 + x^5 + 1 (0x1021)
  // ═══════════════════════════════════════════════════════════════════════════════

  /// CRC-16/CCITT polynomial
  let CRC16_POLY : Nat16 = 0x1021;

  /// Compute CRC-16/CCITT over byte array
  public func crc16(data : [Nat8]) : Nat16 {
    var crc : Nat16 = 0xFFFF;

    for (byte in data.vals()) {
      crc ^= Nat16.fromNat(Nat8.toNat(byte)) << 8;
      for (_ in Iter.range(0, 7)) {
        if ((crc & 0x8000) != 0) {
          crc := (crc << 1) ^ CRC16_POLY;
        } else {
          crc <<= 1;
        };
      };
    };
    crc
  };

  /// Verify CRC-16 of a frame
  public func verifyCrc(frame : Frame) : Bool {
    let frameBytes = serializeHeader(frame.header);
    let allData = Array.append(frameBytes, frame.payload);
    crc16(allData) == frame.crc16
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // FRAME SERIALIZATION — ZERO-COPY WIRE FORMAT
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Encode FrameType to byte
  func frameTypeToByte(ft : FrameType) : Nat8 {
    switch (ft) {
      case (#HEARTBEAT) 0x00;
      case (#INFERENCE_REQUEST) 0x01;
      case (#INFERENCE_RESPONSE) 0x02;
      case (#SIGNAL_DATA) 0x03;
      case (#QSHA_COMMITMENT) 0x04;
      case (#FIRMWARE_CHUNK) 0x05;
      case (#COMMAND) 0x06;
      case (#ACK) 0x07;
      case (#NACK) 0x08;
      case (#ATTESTATION) 0x09;
      case (#ZEROIZE) 0x0A;
    }
  };

  /// Decode byte to FrameType
  func byteToFrameType(b : Nat8) : FrameType {
    switch (Nat8.toNat(b)) {
      case (0) #HEARTBEAT;
      case (1) #INFERENCE_REQUEST;
      case (2) #INFERENCE_RESPONSE;
      case (3) #SIGNAL_DATA;
      case (4) #QSHA_COMMITMENT;
      case (5) #FIRMWARE_CHUNK;
      case (6) #COMMAND;
      case (7) #ACK;
      case (8) #NACK;
      case (9) #ATTESTATION;
      case (10) #ZEROIZE;
      case (_) #NACK;
    }
  };

  /// Serialize frame header to bytes (12 bytes)
  public func serializeHeader(header : FrameHeader) : [Nat8] {
    [
      Nat8.fromNat(Nat16.toNat(header.magic >> 8)),
      Nat8.fromNat(Nat16.toNat(header.magic & 0xFF)),
      header.version,
      frameTypeToByte(header.frameType),
      Nat8.fromNat(Nat16.toNat(header.sequenceNum >> 8)),
      Nat8.fromNat(Nat16.toNat(header.sequenceNum & 0xFF)),
      Nat8.fromNat(Nat16.toNat(header.payloadLen >> 8)),
      Nat8.fromNat(Nat16.toNat(header.payloadLen & 0xFF)),
      Nat8.fromNat(Nat16.toNat(header.sourceNode >> 8)),
      Nat8.fromNat(Nat16.toNat(header.sourceNode & 0xFF)),
      Nat8.fromNat(Nat16.toNat(header.destNode >> 8)),
      Nat8.fromNat(Nat16.toNat(header.destNode & 0xFF))
    ]
  };

  /// Deserialize frame header from bytes
  public func deserializeHeader(bytes : [Nat8]) : ?FrameHeader {
    if (bytes.size() < 12) return null;

    let magic = (Nat16.fromNat(Nat8.toNat(bytes[0])) << 8) | Nat16.fromNat(Nat8.toNat(bytes[1]));
    if (magic != FRAME_MAGIC) return null;

    ?{
      magic;
      version = bytes[2];
      frameType = byteToFrameType(bytes[3]);
      sequenceNum = (Nat16.fromNat(Nat8.toNat(bytes[4])) << 8) | Nat16.fromNat(Nat8.toNat(bytes[5]));
      payloadLen = (Nat16.fromNat(Nat8.toNat(bytes[6])) << 8) | Nat16.fromNat(Nat8.toNat(bytes[7]));
      sourceNode = (Nat16.fromNat(Nat8.toNat(bytes[8])) << 8) | Nat16.fromNat(Nat8.toNat(bytes[9]));
      destNode = (Nat16.fromNat(Nat8.toNat(bytes[10])) << 8) | Nat16.fromNat(Nat8.toNat(bytes[11]));
    }
  };

  /// Serialize complete frame to wire bytes
  public func serializeFrame(frame : Frame) : [Nat8] {
    let headerBytes = serializeHeader(frame.header);
    let withPayload = Array.append(headerBytes, frame.payload);
    let crcBytes : [Nat8] = [
      Nat8.fromNat(Nat16.toNat(frame.crc16 >> 8)),
      Nat8.fromNat(Nat16.toNat(frame.crc16 & 0xFF))
    ];
    Array.append(withPayload, crcBytes)
  };

  /// Deserialize wire bytes to frame
  public func deserializeFrame(bytes : [Nat8]) : ?Frame {
    if (bytes.size() < 14) return null; // 12 header + 2 CRC minimum

    switch (deserializeHeader(bytes)) {
      case (null) null;
      case (?header) {
        let payloadStart = 12;
        let payloadEnd = payloadStart + Nat16.toNat(header.payloadLen);
        if (bytes.size() < payloadEnd + 2) return null;

        let payload = Array.tabulate<Nat8>(Nat16.toNat(header.payloadLen), func(i : Nat) : Nat8 {
          bytes[payloadStart + i]
        });

        let crc16Val = (Nat16.fromNat(Nat8.toNat(bytes[payloadEnd])) << 8)
                     | Nat16.fromNat(Nat8.toNat(bytes[payloadEnd + 1]));

        ?{ header; payload; crc16 = crc16Val }
      };
    }
  };

  /// Build a complete frame with automatic CRC
  public func buildFrame(
    frameType : FrameType,
    sourceNode : Nat16,
    destNode : Nat16,
    sequenceNum : Nat16,
    payload : [Nat8]
  ) : Frame {
    let header : FrameHeader = {
      magic = FRAME_MAGIC;
      version = PROTOCOL_VERSION;
      frameType;
      sequenceNum;
      payloadLen = Nat16.fromNat(payload.size());
      sourceNode;
      destNode;
    };

    let headerBytes = serializeHeader(header);
    let allData = Array.append(headerBytes, payload);
    let crc = crc16(allData);

    { header; payload; crc16 = crc }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SPI PROTOCOL — FULL-DUPLEX HIGH-SPEED COMMUNICATION
  // Clock Phase/Polarity Modes, Chip-Select Management
  // ═══════════════════════════════════════════════════════════════════════════════

  /// SPI configuration
  public type SPIConfig = {
    clockHz : Nat32;         // SPI clock frequency
    mode : SPIMode;          // Clock polarity/phase
    bitOrder : BitOrder;     // MSB or LSB first
    chipSelect : Nat8;       // CS pin index
    maxTransferBytes : Nat16; // Maximum single transfer size
  };

  /// SPI clock mode (CPOL/CPHA)
  public type SPIMode = {
    #MODE0;  // CPOL=0, CPHA=0 — idle low, sample rising
    #MODE1;  // CPOL=0, CPHA=1 — idle low, sample falling
    #MODE2;  // CPOL=1, CPHA=0 — idle high, sample falling
    #MODE3;  // CPOL=1, CPHA=1 — idle high, sample rising
  };

  /// Bit order
  public type BitOrder = {
    #MSB_FIRST;
    #LSB_FIRST;
  };

  /// SPI transaction record
  public type SPITransaction = {
    config : SPIConfig;
    txData : [Nat8];         // Data sent (MOSI)
    rxData : [Nat8];         // Data received (MISO) — same length as tx
    timestamp : Int;
    durationUs : Nat32;      // Microseconds
    success : Bool;
  };

  /// Default SPI configuration for tactical edge nodes
  public func defaultSPIConfig(chipSelect : Nat8) : SPIConfig {
    {
      clockHz = 10_000_000; // 10 MHz — reliable on cheap hardware
      mode = #MODE0;
      bitOrder = #MSB_FIRST;
      chipSelect;
      maxTransferBytes = 256;
    }
  };

  /// Fragment a frame into SPI-sized transfers
  public func spiFragment(frame : Frame, maxBytes : Nat16) : [[Nat8]] {
    let wireBytes = serializeFrame(frame);
    let chunkSize = Nat16.toNat(maxBytes);
    let numChunks = (wireBytes.size() + chunkSize - 1) / chunkSize;

    Array.tabulate<[Nat8]>(numChunks, func(i : Nat) : [Nat8] {
      let start = i * chunkSize;
      let end = Nat.min(start + chunkSize, wireBytes.size());
      Array.tabulate<Nat8>(end - start, func(j : Nat) : Nat8 {
        wireBytes[start + j]
      })
    })
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // I2C PROTOCOL — MULTI-DEVICE TWO-WIRE INTERFACE
  // Address Management, ACK/NACK Handling, Clock Stretching
  // ═══════════════════════════════════════════════════════════════════════════════

  /// I2C configuration
  public type I2CConfig = {
    speedMode : I2CSpeed;
    address : Nat8;          // 7-bit device address
    tenBitAddr : Bool;       // Use 10-bit addressing
    maxRetries : Nat;        // Retries on NACK
    timeoutMs : Nat32;       // Transaction timeout
  };

  /// I2C speed modes
  public type I2CSpeed = {
    #STANDARD;    // 100 kHz
    #FAST;        // 400 kHz
    #FAST_PLUS;   // 1 MHz
    #HIGH_SPEED;  // 3.4 MHz
  };

  /// I2C transaction result
  public type I2CResult = {
    #SUCCESS : [Nat8];
    #NACK;
    #TIMEOUT;
    #BUS_ERROR;
    #ARB_LOST;   // Arbitration lost (multi-master)
  };

  /// I2C bus scan result — which addresses respond
  public type I2CScanResult = {
    respondingAddresses : [Nat8];
    scanDurationMs : Nat32;
  };

  /// Default I2C configuration
  public func defaultI2CConfig(address : Nat8) : I2CConfig {
    {
      speedMode = #FAST;     // 400 kHz for tactical responsiveness
      address;
      tenBitAddr = false;
      maxRetries = 3;
      timeoutMs = 50;        // 50ms timeout — tactical constraint
    }
  };

  /// Compute I2C address byte (7-bit address + R/W bit)
  public func i2cAddressByte(address : Nat8, read : Bool) : Nat8 {
    let shifted = Nat8.fromNat(Nat8.toNat(address) * 2);
    if (read) shifted | 0x01 else shifted
  };

  /// Build I2C write frame: [ADDR_W, REG, DATA...]
  public func i2cWriteFrame(address : Nat8, register : Nat8, data : [Nat8]) : [Nat8] {
    let addrByte = i2cAddressByte(address, false);
    Array.append([addrByte, register], data)
  };

  /// Build I2C read request: [ADDR_W, REG, ADDR_R]
  public func i2cReadRequest(address : Nat8, register : Nat8) : [Nat8] {
    [i2cAddressByte(address, false), register, i2cAddressByte(address, true)]
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // UART PROTOCOL — ASYNCHRONOUS SERIAL COMMUNICATION
  // Baud Rate, Parity, Stop Bits, Flow Control
  // ═══════════════════════════════════════════════════════════════════════════════

  /// UART configuration
  public type UARTConfig = {
    baudRate : Nat32;        // Bits per second
    dataBits : UARTDataBits;
    parity : UARTParity;
    stopBits : UARTStopBits;
    flowControl : FlowControl;
    rxBufferSize : Nat16;    // Receive buffer size
    txBufferSize : Nat16;    // Transmit buffer size
  };

  /// UART data width
  public type UARTDataBits = {
    #BITS_7;
    #BITS_8;
    #BITS_9;
  };

  /// UART parity
  public type UARTParity = {
    #NONE;
    #EVEN;
    #ODD;
  };

  /// UART stop bits
  public type UARTStopBits = {
    #STOP_1;
    #STOP_1_5;
    #STOP_2;
  };

  /// Flow control
  public type FlowControl = {
    #NONE;
    #RTS_CTS;   // Hardware flow control
    #XON_XOFF;  // Software flow control
  };

  /// Default UART configuration for tactical edge
  public func defaultUARTConfig() : UARTConfig {
    {
      baudRate = 921_600;    // 921.6 kbaud — max reliable on cheap hardware
      dataBits = #BITS_8;
      parity = #NONE;
      stopBits = #STOP_1;
      flowControl = #RTS_CTS; // Hardware flow control for reliability
      rxBufferSize = 512;
      txBufferSize = 512;
    }
  };

  /// Compute UART frame time in microseconds
  public func uartFrameTimeUs(config : UARTConfig, numBytes : Nat) : Nat32 {
    let bitsPerByte : Nat32 = switch (config.dataBits) {
      case (#BITS_7) 7;
      case (#BITS_8) 8;
      case (#BITS_9) 9;
    };
    let parityBits : Nat32 = switch (config.parity) {
      case (#NONE) 0;
      case (_) 1;
    };
    let stopBits : Nat32 = switch (config.stopBits) {
      case (#STOP_1) 1;
      case (#STOP_1_5) 2; // Round up
      case (#STOP_2) 2;
    };

    let totalBitsPerByte = 1 + bitsPerByte + parityBits + stopBits; // +1 for start bit
    let totalBits = totalBitsPerByte * Nat32.fromNat(numBytes);
    (totalBits * 1_000_000) / config.baudRate
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // EDGE NODE FLEET — TOPOLOGY AND MANAGEMENT
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Edge node fleet state
  public type EdgeFleet = {
    var nodes : [EdgeNodeDescriptor];
    var sequenceCounter : Nat16;
    masterNodeId : Nat16;           // This runtime's node ID
    maxNodes : Nat;                 // Maximum fleet size
  };

  /// Create a new edge fleet
  public func createFleet(masterNodeId : Nat16, maxNodes : Nat) : EdgeFleet {
    {
      var nodes = [] : [EdgeNodeDescriptor];
      var sequenceCounter = 0 : Nat16;
      masterNodeId;
      maxNodes;
    }
  };

  /// Register a node in the fleet
  public func registerNode(fleet : EdgeFleet, node : EdgeNodeDescriptor) : Bool {
    if (fleet.nodes.size() >= fleet.maxNodes) return false;

    // Check for duplicate ID
    for (existing in fleet.nodes.vals()) {
      if (existing.nodeId == node.nodeId) return false;
    };

    fleet.nodes := Array.append(fleet.nodes, [node]);
    true
  };

  /// Remove a node from the fleet
  public func removeNode(fleet : EdgeFleet, nodeId : Nat16) : Bool {
    let filtered = Array.filter<EdgeNodeDescriptor>(fleet.nodes, func(n : EdgeNodeDescriptor) : Bool {
      n.nodeId != nodeId
    });
    if (filtered.size() == fleet.nodes.size()) return false;
    fleet.nodes := filtered;
    true
  };

  /// Get next sequence number (wraps at 0xFFFF)
  public func nextSequence(fleet : EdgeFleet) : Nat16 {
    let seq = fleet.sequenceCounter;
    fleet.sequenceCounter := if (seq == 0xFFFF) 0 else seq + 1;
    seq
  };

  /// Find node by ID
  public func findNode(fleet : EdgeFleet, nodeId : Nat16) : ?EdgeNodeDescriptor {
    for (node in fleet.nodes.vals()) {
      if (node.nodeId == nodeId) return ?node;
    };
    null
  };

  /// Get all active nodes
  public func activeNodes(fleet : EdgeFleet) : [EdgeNodeDescriptor] {
    Array.filter<EdgeNodeDescriptor>(fleet.nodes, func(n : EdgeNodeDescriptor) : Bool {
      switch (n.status) {
        case (#ACTIVE) true;
        case (#SLEEPING) true;
        case (_) false;
      }
    })
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // INFERENCE DISPATCH — DISTRIBUTE NF4 INFERENCE TO EDGE NODES
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Inference dispatch payload format
  public type InferencePayload = {
    modelShardId : Nat8;       // Which shard to execute
    batchIndex : Nat8;         // Position in batch
    inputData : [Nat8];        // NF4-quantized input vector (4 bits per weight)
    inputLen : Nat16;          // Number of logical elements
  };

  /// Inference response payload
  public type InferenceResponsePayload = {
    batchIndex : Nat8;
    status : Nat8;             // 0=success, 1=overload, 2=fault
    outputData : [Nat8];       // NF4-quantized output
    outputLen : Nat16;
    latencyUs : Nat32;         // Execution time in microseconds
  };

  /// Serialize inference payload to bytes
  public func serializeInferencePayload(payload : InferencePayload) : [Nat8] {
    let header : [Nat8] = [
      payload.modelShardId,
      payload.batchIndex,
      Nat8.fromNat(Nat16.toNat(payload.inputLen >> 8)),
      Nat8.fromNat(Nat16.toNat(payload.inputLen & 0xFF))
    ];
    Array.append(header, payload.inputData)
  };

  /// Deserialize inference response from bytes
  public func deserializeInferenceResponse(bytes : [Nat8]) : ?InferenceResponsePayload {
    if (bytes.size() < 8) return null;

    let outputLen = (Nat16.fromNat(Nat8.toNat(bytes[2])) << 8) | Nat16.fromNat(Nat8.toNat(bytes[3]));
    let latencyUs = (Nat32.fromNat(Nat8.toNat(bytes[4])) << 24)
                  | (Nat32.fromNat(Nat8.toNat(bytes[5])) << 16)
                  | (Nat32.fromNat(Nat8.toNat(bytes[6])) << 8)
                  | Nat32.fromNat(Nat8.toNat(bytes[7]));

    let outputData = Array.tabulate<Nat8>(bytes.size() - 8, func(i : Nat) : Nat8 {
      bytes[8 + i]
    });

    ?{
      batchIndex = bytes[0];
      status = bytes[1];
      outputData;
      outputLen;
      latencyUs;
    }
  };

  /// Build inference request frame for an edge node
  public func buildInferenceRequest(
    fleet : EdgeFleet,
    destNode : Nat16,
    payload : InferencePayload
  ) : Frame {
    let seq = nextSequence(fleet);
    let payloadBytes = serializeInferencePayload(payload);
    buildFrame(#INFERENCE_REQUEST, fleet.masterNodeId, destNode, seq, payloadBytes)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SIGNAL ACQUISITION — COLLECT ADC DATA FROM EDGE NODES
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Signal acquisition request
  public type SignalAcquisitionRequest = {
    channelMask : Nat8;        // Which ADC channels to sample
    sampleCount : Nat16;       // Number of samples per channel
    sampleRateHz : Nat32;      // Requested sample rate
    gainDb : Nat8;             // Amplifier gain in dB
  };

  /// Serialize signal acquisition request
  public func serializeSignalRequest(req : SignalAcquisitionRequest) : [Nat8] {
    [
      req.channelMask,
      Nat8.fromNat(Nat16.toNat(req.sampleCount >> 8)),
      Nat8.fromNat(Nat16.toNat(req.sampleCount & 0xFF)),
      Nat8.fromNat(Nat32.toNat(req.sampleRateHz >> 24)),
      Nat8.fromNat(Nat32.toNat((req.sampleRateHz >> 16) & 0xFF)),
      Nat8.fromNat(Nat32.toNat((req.sampleRateHz >> 8) & 0xFF)),
      Nat8.fromNat(Nat32.toNat(req.sampleRateHz & 0xFF)),
      req.gainDb
    ]
  };

  /// Build signal acquisition frame
  public func buildSignalRequest(
    fleet : EdgeFleet,
    destNode : Nat16,
    req : SignalAcquisitionRequest
  ) : Frame {
    let seq = nextSequence(fleet);
    let payload = serializeSignalRequest(req);
    buildFrame(#SIGNAL_DATA, fleet.masterNodeId, destNode, seq, payload)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // HEARTBEAT — KEEP-ALIVE AND HEALTH MONITORING
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Heartbeat payload (minimal overhead)
  public type HeartbeatPayload = {
    uptimeSeconds : Nat32;
    cpuTempC : Nat8;           // Temperature in Celsius
    freeRamBytes : Nat32;
    batteryPct : Nat8;         // 0-100, or 0xFF for wired power
    errorCount : Nat16;        // Cumulative errors since boot
  };

  /// Serialize heartbeat
  public func serializeHeartbeat(hb : HeartbeatPayload) : [Nat8] {
    [
      Nat8.fromNat(Nat32.toNat(hb.uptimeSeconds >> 24)),
      Nat8.fromNat(Nat32.toNat((hb.uptimeSeconds >> 16) & 0xFF)),
      Nat8.fromNat(Nat32.toNat((hb.uptimeSeconds >> 8) & 0xFF)),
      Nat8.fromNat(Nat32.toNat(hb.uptimeSeconds & 0xFF)),
      hb.cpuTempC,
      Nat8.fromNat(Nat32.toNat(hb.freeRamBytes >> 24)),
      Nat8.fromNat(Nat32.toNat((hb.freeRamBytes >> 16) & 0xFF)),
      Nat8.fromNat(Nat32.toNat((hb.freeRamBytes >> 8) & 0xFF)),
      Nat8.fromNat(Nat32.toNat(hb.freeRamBytes & 0xFF)),
      hb.batteryPct,
      Nat8.fromNat(Nat16.toNat(hb.errorCount >> 8)),
      Nat8.fromNat(Nat16.toNat(hb.errorCount & 0xFF))
    ]
  };

  /// Deserialize heartbeat from payload bytes
  public func deserializeHeartbeat(bytes : [Nat8]) : ?HeartbeatPayload {
    if (bytes.size() < 12) return null;

    ?{
      uptimeSeconds = (Nat32.fromNat(Nat8.toNat(bytes[0])) << 24)
                    | (Nat32.fromNat(Nat8.toNat(bytes[1])) << 16)
                    | (Nat32.fromNat(Nat8.toNat(bytes[2])) << 8)
                    | Nat32.fromNat(Nat8.toNat(bytes[3]));
      cpuTempC = bytes[4];
      freeRamBytes = (Nat32.fromNat(Nat8.toNat(bytes[5])) << 24)
                   | (Nat32.fromNat(Nat8.toNat(bytes[6])) << 16)
                   | (Nat32.fromNat(Nat8.toNat(bytes[7])) << 8)
                   | Nat32.fromNat(Nat8.toNat(bytes[8]));
      batteryPct = bytes[9];
      errorCount = (Nat16.fromNat(Nat8.toNat(bytes[10])) << 8)
                 | Nat16.fromNat(Nat8.toNat(bytes[11]));
    }
  };

  /// Build heartbeat frame
  public func buildHeartbeat(fleet : EdgeFleet, hb : HeartbeatPayload) : Frame {
    let seq = nextSequence(fleet);
    let payload = serializeHeartbeat(hb);
    buildFrame(#HEARTBEAT, fleet.masterNodeId, BROADCAST_ADDR, seq, payload)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // ATTESTATION — VERIFY EDGE NODE FIRMWARE INTEGRITY
  // Uses QSHA commitment verification
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Attestation request payload
  public type AttestationRequest = {
    challenge : [Nat8];        // 32-byte random challenge
    expectedHash : [Nat8];     // Expected firmware QSHA hash
  };

  /// Attestation response payload
  public type AttestationResponse = {
    firmwareHash : [Nat8];     // QSHA of current firmware image
    challengeResponse : [Nat8]; // QSHA(challenge || firmwareHash)
    bootStages : Nat8;         // Number of verified boot stages
    tamperedBit : Bool;        // True if tamper detection triggered
  };

  /// Build attestation request frame
  public func buildAttestationRequest(
    fleet : EdgeFleet,
    destNode : Nat16,
    challenge : [Nat8]
  ) : Frame {
    let seq = nextSequence(fleet);
    buildFrame(#ATTESTATION, fleet.masterNodeId, destNode, seq, challenge)
  };

  /// Build zeroize command (secure destruction)
  public func buildZeroizeCommand(fleet : EdgeFleet, destNode : Nat16) : Frame {
    let seq = nextSequence(fleet);
    // Zeroize requires confirmation pattern: 0xDEAD repeated
    let payload : [Nat8] = [0xDE, 0xAD, 0xDE, 0xAD, 0xDE, 0xAD, 0xDE, 0xAD];
    buildFrame(#ZEROIZE, fleet.masterNodeId, destNode, seq, payload)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // BUS ARBITRATION — COLLISION DETECTION AND RETRY
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Retry policy for failed transmissions
  public type RetryPolicy = {
    maxRetries : Nat;
    baseDelayUs : Nat32;       // Base delay between retries
    backoffMultiplier : Nat;   // Exponential backoff factor
    jitterBits : Nat;          // Random jitter bits for collision avoidance
  };

  /// Default retry policy for tactical edge
  public func defaultRetryPolicy() : RetryPolicy {
    {
      maxRetries = 5;
      baseDelayUs = 100;       // 100µs base
      backoffMultiplier = 2;   // Double each retry
      jitterBits = 4;          // 0-15µs random jitter
    }
  };

  /// Compute retry delay for attempt N
  public func retryDelay(policy : RetryPolicy, attempt : Nat) : Nat32 {
    var delay = policy.baseDelayUs;
    for (_ in Iter.range(0, attempt - 1)) {
      delay *= Nat32.fromNat(policy.backoffMultiplier);
    };
    delay
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // THROUGHPUT ESTIMATION — PREDICT BUS CAPACITY
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Estimate max frames per second for given bus configuration
  public func estimateThroughput(protocol : BusProtocol, frameSize : Nat) : Nat {
    let bitsPerFrame = frameSize * 8;
    let busSpeedBps : Nat = switch (protocol) {
      case (#SPI) 10_000_000;   // 10 Mbps default
      case (#I2C) 400_000;      // 400 kbps Fast mode
      case (#UART) 921_600;     // 921.6 kbps
    };
    // Account for protocol overhead (~20%)
    let effectiveBps = busSpeedBps * 80 / 100;
    effectiveBps / bitsPerFrame
  };

  /// Estimate latency for a single frame in microseconds
  public func estimateLatency(protocol : BusProtocol, frameSize : Nat) : Nat32 {
    let bitsPerFrame = Nat32.fromNat(frameSize * 8);
    let busSpeedBps : Nat32 = switch (protocol) {
      case (#SPI) 10_000_000;
      case (#I2C) 400_000;
      case (#UART) 921_600;
    };
    (bitsPerFrame * 1_000_000) / busSpeedBps
  };
};
