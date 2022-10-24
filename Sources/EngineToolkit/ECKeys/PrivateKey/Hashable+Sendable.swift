//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-10-24.
//

import Foundation
import K1
import CryptoKit

extension Data: @unchecked Sendable {}
public typealias EdDSASignature = Data
extension Curve25519.Signing.PublicKey: @unchecked Sendable {}
extension Curve25519.Signing.PublicKey: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.rawRepresentation)
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.rawRepresentation == rhs.rawRepresentation
    }
}
extension ECDSASignature: @unchecked Sendable {}
extension ECDSASignature: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.rawRepresentation)
    }
}
extension K1.PublicKey: @unchecked Sendable {}
extension K1.PublicKey: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(try! self.rawRepresentation(format: .compressed))
    }
}
