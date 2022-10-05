//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-10-05.
//

import Foundation

public struct TransactionHeader: Sendable, Codable, Hashable {
    public let version: UInt8
    public let networkId: UInt8
    public let startEpochInclusive: UInt64
    public let endEpochExclusive: UInt64
    public let nonce: UInt64
    public let publicKey: PublicKey
    public let notaryAsSignature: Bool
    public let costUnitLimit: UInt32
    public let tipPercentage: UInt32
    
    private enum CodingKeys: String, CodingKey {
        case version = "version"
        case networkId = "network_id"
        case startEpochInclusive = "start_epoch_inclusive"
        case endEpochExclusive = "end_epoch_exclusive"
        case nonce = "nonce"
        case publicKey = "notary_public_key"
        case notaryAsSignature = "notary_as_signatory"
        case costUnitLimit = "cost_unit_limit"
        case tipPercentage = "tip_percentage"
    }
}
