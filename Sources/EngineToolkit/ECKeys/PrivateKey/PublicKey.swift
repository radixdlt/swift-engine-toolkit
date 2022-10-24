//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-10-24.
//

import Foundation
import K1
import CryptoKit

public enum PublicKey: Sendable, Hashable {
    case ecdsaSecp256k1(K1.PublicKey)
    case eddsaEd25519(Curve25519.Signing.PublicKey)
}

public extension PublicKey {
    func isValidSignature(
        _ signatureWrapper: Signature,
        for message: any DataProtocol
    ) -> Bool {
        switch (signatureWrapper, self) {

        case let (.ecdsaSecp256k1(ecdsaSecp256k1Signature), .ecdsaSecp256k1(ecdsaSecp256k1PublicKey)):
            return (try? ecdsaSecp256k1Signature.wasSigned(by: ecdsaSecp256k1PublicKey, hashedMessage: message)) ?? false
        
        case (.ecdsaSecp256k1, .eddsaEd25519):
            return false
            
        case (.eddsaEd25519, .ecdsaSecp256k1):
            return false
            
        case let (.eddsaEd25519(eddsaEd25519Signature), .eddsaEd25519(eddsaEd25519PublicKey)):
            return eddsaEd25519PublicKey.isValidSignature(eddsaEd25519Signature, for: message)
        }
    }
}

internal extension PublicKey {
    func intoEngine() throws -> Engine.PublicKey {
        switch self {
        case let .ecdsaSecp256k1(key):
            return try .ecdsaSecp256k1(key.intoEngine())
        case let .eddsaEd25519(key):
            return .eddsaEd25519(Engine.EddsaEd25519PublicKey(bytes: [UInt8](key.rawRepresentation)))
        }
    }
}
internal extension K1.PublicKey {
    func intoEngine() throws -> Engine.EcdsaSecp256k1PublicKey {
        try .init(bytes: self.rawRepresentation(format: .compressed))
    }
}

internal extension Engine.PublicKey {
    func intoNonEngine() throws -> PublicKey {
        switch self {
        case let .eddsaEd25519(key):
            return try .eddsaEd25519(Curve25519.Signing.PublicKey(rawRepresentation: key.bytes))
        case let .ecdsaSecp256k1(key):
            return try .ecdsaSecp256k1(.import(from: key.bytes))
        }
    }
}
