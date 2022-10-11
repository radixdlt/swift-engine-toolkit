//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-10-10.
//

import Foundation

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

import CryptoKit
public enum PrivateKey {
    case curve25519(Curve25519.Signing.PrivateKey)
}
extension PrivateKey {
    
    func sign(data: any DataProtocol) throws -> SignatureWithPublicKey {
        switch self {
        case let .curve25519(key):
            let signature = try key.signature(for: data)
            let publicKey = key.publicKey
            return .eddsaEd25519(
                EddsaEd25519PublicKeyString(bytes: [UInt8](publicKey.rawRepresentation)),
                EddsaEd25519SignatureString(bytes: [UInt8](signature))
            )
        }
    }
}

public extension TransactionIntent {
    func sign(with privateKey: Curve25519.Signing.PrivateKey) throws -> SignedTransactionIntent {
        try sign(with: .curve25519(privateKey))
    }
    
    func sign(with privateKey: PrivateKey) throws -> SignedTransactionIntent {
        let compiledTransactionIntent = try EngineToolkit().compileTransactionIntentRequest(request: self).get().compiledIntent
        let signature = try privateKey.sign(data: compiledTransactionIntent)
        return SignedTransactionIntent(transactionIntent: self, signatures: [signature])
    }
}


public extension SignedTransactionIntent {
    func sign(with privateKey: Curve25519.Signing.PrivateKey) throws -> Self {
        try sign(with: .curve25519(privateKey))
    }
    func sign(with privateKey: PrivateKey) throws -> Self {
        
        let signedTransactionIntent = SignedTransactionIntent(
            transactionIntent: transactionIntent,
            signatures: self.signatures
        )
        
        
        let compiledSignedTransactionIntent = try EngineToolkit().compileSignedTransactionIntentRequest(
            request: signedTransactionIntent
        ).get().compiledSignedIntent
        
        let signature = try privateKey.sign(data: compiledSignedTransactionIntent)
        
        return SignedTransactionIntent(
            transactionIntent: transactionIntent,
            signatures: signatures + [signature]
        )
    }
}

public extension SignedTransactionIntent {
    func notarize(_ notaryPrivateKey: Curve25519.Signing.PrivateKey) throws -> NotarizedTransaction {
        try notarize(.curve25519(notaryPrivateKey))
    }
    func notarize(_ notaryPrivateKey: PrivateKey) throws -> NotarizedTransaction {
        
        let signedTransactionIntent = SignedTransactionIntent(
            transactionIntent: transactionIntent,
            signatures: self.signatures
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
