//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-10-24.
//

import Foundation
import CryptoKit
import K1

public extension Engine {
    enum PrivateKey {
        case curve25519(Curve25519.Signing.PrivateKey)
        case secp256k1(K1.PrivateKey)
    }
}


public extension Engine.PrivateKey {
    func publicKey() throws -> Engine.PublicKey {
        try intoNonEngine()
            .publicKey()
            .intoEngine()
    }
}


public extension Engine.PrivateKey {
    func intoNonEngine() -> PrivateKey {
        switch self {
        case let .secp256k1(key): return .secp256k1(key)
        case let .curve25519(key): return .curve25519(key)
        }
    }
}
internal extension PrivateKey {
    func intoEngine() throws -> Engine.PrivateKey {
        switch self {
        case let .secp256k1(key): return .secp256k1(key)
        case let .curve25519(key): return .curve25519(key)
        }
    }
}

public extension Engine.PrivateKey {
    
    func sign(data: any DataProtocol) throws -> Engine.SignatureWithPublicKey {
        try intoNonEngine()
            .sign(data: data)
            .intoEngine()
    }
}

internal extension SignatureWithPublicKey {
    func intoEngine() throws -> Engine.SignatureWithPublicKey {
        switch self {
        case let .ecdsaSecp256k1(signature, publicKey):
            return try .ecdsaSecp256k1(
                signature: .init(bytes: [UInt8](signature.rawRepresentation)),
                publicKey: .init(bytes: [UInt8](publicKey.rawRepresentation(format: .compressed)))
            )
        case let .eddsaEd25519(signature, publicKey):
            return .eddsaEd25519(
                signature: Engine.EddsaEd25519Signature(bytes: [UInt8](signature)),
                publicKey: Engine.EddsaEd25519PublicKey(bytes: [UInt8](publicKey.rawRepresentation))
            )
        }
    }
}
