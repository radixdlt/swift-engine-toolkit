//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-10-24.
//

import Foundation
import CryptoKit
import K1
import SLIP10

public extension Engine {
    enum PrivateKey {
        case curve25519(Curve25519.Signing.PrivateKey)
        case secp256k1(K1.PrivateKey)
    }
}


public extension Engine.PrivateKey {
    func publicKey() throws -> Engine.PublicKey {
        try SLIP10.PrivateKey(engine: self)
            .publicKey()
            .intoEngine()
    }
}


public extension Engine.PrivateKey {
    
	/// Expects a non hashed `data`, will SHA256 double hash it for secp256k1,
	/// but not for Curve25519, before signing.
    func sign(data: any DataProtocol) throws -> Engine.SignatureWithPublicKey {
        try signReturningHashOfMessage(data: data).signatureWithPublicKey
    }
    
    /// Expects a non hashed `data`, will SHA256 double hash it for secp256k1,
    /// but not for Curve25519, before signing.
    func signReturningHashOfMessage(data: any DataProtocol) throws -> (signatureWithPublicKey: Engine.SignatureWithPublicKey, hashOfMessage: Data) {
        let signatureAndMessage = try SLIP10.PrivateKey(engine: self).signReturningHashOfMessage(data: data)

        return try (
            signatureWithPublicKey: signatureAndMessage.signatureWithPublicKey.intoEngine(),
            hashOfMessage: signatureAndMessage.hashOfMessage
        )
    }
}

