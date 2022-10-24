//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-10-24.
//

import Foundation
import CryptoKit
import K1

public enum PrivateKey {
    case curve25519(Curve25519.Signing.PrivateKey)
    case secp256k1(K1.PrivateKey)
}

public extension PrivateKey {
    
    func sign(data: any DataProtocol) throws -> SignatureWithPublicKey {
        switch self {
        case let .curve25519(key):
            let signature = try key.signature(for: data)
            let publicKey = key.publicKey
            return .eddsaEd25519(
                signature: signature,
                publicKey: publicKey
            )
        case let .secp256k1(key):
            let signature = try key.ecdsaSign(hashed: data)
            let publicKey = key.publicKey
            return .ecdsaSecp256k1(
                signature: signature,
                publicKey: publicKey
            )
        }
    }
}

public extension PrivateKey {
    func publicKey() -> PublicKey {
        switch self {
        case let .secp256k1(privateKey):
            return .ecdsaSecp256k1(privateKey.publicKey)
        case let .curve25519(privateKey):
            return .eddsaEd25519(privateKey.publicKey)
        }
    }
}
