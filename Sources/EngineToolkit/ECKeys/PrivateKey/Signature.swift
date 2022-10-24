//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-10-24.
//

import Foundation
import CryptoKit
import K1

public enum Signature: Sendable, Hashable {
    case ecdsaSecp256k1(ECDSASignature)
    case eddsaEd25519(EdDSASignature)
}

internal extension Signature {
    func intoEngine() -> Engine.Signature {
        switch self {
        case let .ecdsaSecp256k1(signature):
            return .ecdsaSecp256k1(signature.intoEngine())
        case let .eddsaEd25519(signature):
            return .eddsaEd25519(Engine.EddsaEd25519Signature(bytes: [UInt8](signature)))
        }
    }
}

internal extension ECDSASignature {
    func intoEngine() -> Engine.EcdsaSecp256k1Signature {
        .init(bytes: [UInt8](rawRepresentation))
    }
}

internal extension Engine.Signature {
    func intoNonEngine() throws -> Signature {
        switch self {
        case let .eddsaEd25519(signature):
            // TODO validate
            return .eddsaEd25519(Data(signature.bytes))
        case let .ecdsaSecp256k1(signature):
            return try .ecdsaSecp256k1(.init(rawRepresentation: signature.bytes))
        }
    }
}
