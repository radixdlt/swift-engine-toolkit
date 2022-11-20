//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-10-05.
//

import Foundation

public struct TransactionIntent: Sendable, Codable, Hashable {
    public let header: TransactionHeader
    public let manifest: TransactionManifest
    
    public init(header: TransactionHeader, manifest: TransactionManifest) {
        self.header = header
        self.manifest = manifest
    }
}

public extension TransactionIntent {
    func accountsRequiredToSign() throws -> Set<ComponentAddress> {
        try manifest.accountsRequiredToSign(
            networkId: header.networkId,
            version: header.version
        )
    }
}
