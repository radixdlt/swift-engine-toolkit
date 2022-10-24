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
    
    func sign(data: any DataProtocol) throws -> Engine.SignatureWithPublicKey {
        try SLIP10.PrivateKey(engine: self)
            .sign(data: data)
            .intoEngine()
    }
}

