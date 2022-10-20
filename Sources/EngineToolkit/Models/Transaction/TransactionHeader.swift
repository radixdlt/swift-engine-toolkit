//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-10-05.
//

import Foundation

public struct TransactionHeader: Sendable, Codable, Hashable {
    public let version: UInt8
    public let networkId: NetworkID
    public let startEpochInclusive: UInt64
    public let endEpochExclusive: UInt64
    public let nonce: UInt64
    public let publicKey: PublicKey
    public let notaryAsSignatory: Bool
    public let costUnitLimit: UInt32
    public let tipPercentage: UInt32
    
    private enum CodingKeys: String, CodingKey {
        case version = "version"
        case networkId = "network_id"
        case startEpochInclusive = "start_epoch_inclusive"
        case endEpochExclusive = "end_epoch_exclusive"
        case nonce = "nonce"
        case publicKey = "notary_public_key"
        case notaryAsSignatory = "notary_as_signatory"
        case costUnitLimit = "cost_unit_limit"
        case tipPercentage = "tip_percentage"
    }
    
    // MARK: Init
    public init(
        version: UInt8,
        networkId: NetworkID,
        startEpochInclusive: UInt64,
        endEpochExclusive: UInt64,
        nonce: UInt64,
        publicKey: PublicKey,
        notaryAsSignatory: Bool,
        costUnitLimit: UInt32,
        tipPercentage: UInt32
    ) {
        self.version = version
        self.networkId = networkId
        self.startEpochInclusive = startEpochInclusive
        self.endEpochExclusive = endEpochExclusive
        self.nonce = nonce
        self.publicKey = publicKey
        self.notaryAsSignatory = notaryAsSignatory
        self.costUnitLimit = costUnitLimit
        self.tipPercentage = tipPercentage
    }
    
    // MARK: Codable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(String(version), forKey: .version)
        try container.encode(String(networkId.id), forKey: .networkId)
        try container.encode(String(startEpochInclusive), forKey: .startEpochInclusive)
        try container.encode(String(endEpochExclusive), forKey: .endEpochExclusive)
        try container.encode(String(nonce), forKey: .nonce)
        try container.encode(publicKey, forKey: .publicKey)
        try container.encode(notaryAsSignatory, forKey: .notaryAsSignatory)
        try container.encode(String(costUnitLimit), forKey: .costUnitLimit)
        try container.encode(String(tipPercentage), forKey: .tipPercentage)
    }
    
    public init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        try self.init(
            version: try UInt8(container.decode(String.self, forKey: .version)) ?? { throw InternalDecodingFailure.parsingError }(),
            networkId: NetworkID.init(try UInt8(container.decode(String.self, forKey: .networkId)) ?? { throw InternalDecodingFailure.parsingError }()),
            startEpochInclusive: try UInt64(container.decode(String.self, forKey: .startEpochInclusive)) ?? { throw InternalDecodingFailure.parsingError }(),
            endEpochExclusive: try UInt64(container.decode(String.self, forKey: .endEpochExclusive)) ?? { throw InternalDecodingFailure.parsingError }(),
            nonce: try UInt64(container.decode(String.self, forKey: .nonce)) ?? { throw InternalDecodingFailure.parsingError }(),
            publicKey: container.decode(PublicKey.self, forKey: .publicKey),
            notaryAsSignatory: container.decode(Bool.self, forKey: .notaryAsSignatory),
            costUnitLimit: try UInt32(container.decode(String.self, forKey: .costUnitLimit)) ?? { throw InternalDecodingFailure.parsingError }(),
            tipPercentage: try UInt32(container.decode(String.self, forKey: .tipPercentage)) ?? { throw InternalDecodingFailure.parsingError }()
        )
    }
}
