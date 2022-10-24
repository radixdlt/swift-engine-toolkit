//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-10-10.
//

import Foundation
import CryptoKit
import K1
import SLIP10

public extension TransactionManifest {
    func header(_ header: TransactionHeader) -> TransactionIntent {
        .init(header: header, manifest: self)
    }
}

public extension TransactionIntent {
    func blobs(_ blobs: [[UInt8]]) -> Self {
        .init(header: header, manifest: .init(instructions: self.manifest.instructions, blobs: blobs))
    }
}

public extension TransactionIntent {
    func sign(with privateKey: Curve25519.Signing.PrivateKey) throws -> SignedTransactionIntent {
        try sign(with: Engine.PrivateKey.curve25519(privateKey))
    }
    
    func sign(with privateKey: K1.PrivateKey) throws -> SignedTransactionIntent {
        try sign(with: Engine.PrivateKey.secp256k1(privateKey))
    }
    
    func sign(with privateKey: PrivateKey) throws -> SignedTransactionIntent {
        try sign(with: privateKey.intoEngine())
    }
    
    func sign(with privateKey: Engine.PrivateKey) throws -> SignedTransactionIntent {
        let compiledTransactionIntent = try EngineToolkit().compileTransactionIntentRequest(request: self).get().compiledIntent
        let signature = try privateKey.sign(data: compiledTransactionIntent)
        return SignedTransactionIntent(intent: self, intentSignatures: [signature])
    }
}


public extension SignedTransactionIntent {
    func sign(with privateKey: Curve25519.Signing.PrivateKey) throws -> Self {
        try sign(with: Engine.PrivateKey.curve25519(privateKey))
    }
    
    func sign(with privateKey: K1.PrivateKey) throws -> Self {
        try sign(with: Engine.PrivateKey.secp256k1(privateKey))
    }
    
    
    func sign(with privateKey: PrivateKey) throws -> Self {
        try sign(with: privateKey.intoEngine())
    }
        
    func sign(with privateKey: Engine.PrivateKey) throws -> Self {
        
        let signedTransactionIntent = SignedTransactionIntent(
            intent: intent,
            intentSignatures: self.intentSignatures
        )
        
        let compiledSignedTransactionIntent = try EngineToolkit().compileSignedTransactionIntentRequest(
            request: signedTransactionIntent
        ).get().compiledSignedIntent
        
        let signature = try privateKey.sign(data: compiledSignedTransactionIntent)
        
        return SignedTransactionIntent(
            intent: intent,
            intentSignatures: intentSignatures + [signature]
        )
    }
}

public extension SignedTransactionIntent {
    
    func notarize(_ notaryPrivateKey: Curve25519.Signing.PrivateKey) throws -> NotarizedTransaction {
        try notarize(Engine.PrivateKey.curve25519(notaryPrivateKey))
    }
    
    func notarize(_ notaryPrivateKey: K1.PrivateKey) throws -> NotarizedTransaction {
        try notarize(Engine.PrivateKey.secp256k1(notaryPrivateKey))
    }
    
    func notarize(_ notaryPrivateKey: PrivateKey) throws -> NotarizedTransaction {
        try notarize(notaryPrivateKey.intoEngine())
    }
        
    func notarize(_ notaryPrivateKey: Engine.PrivateKey) throws -> NotarizedTransaction {
        
        let signedTransactionIntent = SignedTransactionIntent(
            intent: intent,
            intentSignatures: self.intentSignatures
        )
        
        let compiledSignedTransactionIntent = try EngineToolkit().compileSignedTransactionIntentRequest(
            request: signedTransactionIntent
        ).get().compiledSignedIntent
        
        // Notarize the signed intent to create a notarized transaction
        let notarySignature = try notaryPrivateKey.sign(data: compiledSignedTransactionIntent)
        
        return NotarizedTransaction(
            signedIntent: signedTransactionIntent,
            notarySignature: notarySignature.signature
        )
    }
}
