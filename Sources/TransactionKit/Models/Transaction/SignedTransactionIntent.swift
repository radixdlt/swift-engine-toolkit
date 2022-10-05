//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-10-05.
//

import Foundation

public struct SignedTransactionIntent: Sendable, Codable, Hashable {
    public let transactionIntent: TransactionIntent
    public let signatures: [SignatureWithPublicKey]
    
    private enum CodingKeys: String, CodingKey {
        case transactionIntent = "transaction_intent"
        case signatures = "signatures"
    }
}
