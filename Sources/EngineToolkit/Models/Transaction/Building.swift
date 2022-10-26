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

public struct NotarizedNonNotarySignedButIntentSignedTransctionContext: Hashable {
    public internal(set) var transactionIntent: TransactionIntent
    public internal(set) var transactionIntentHash: Data
    public internal(set) var compileTransactionIntentResponse: CompileTransactionIntentResponse
    public internal(set) var signedTransactionIntent: SignedTransactionIntent
    
    
    fileprivate func with(
        compileSignedTransactionIntentResponse: CompileSignedTransactionIntentResponse,
        notarizedTransaction: NotarizedTransaction
    ) -> NotarizedSignedTransctionContext {
        .init(
            transactionIntent: self.transactionIntent,
            transactionIntentHash: self.transactionIntentHash,
            compileTransactionIntentResponse: self.compileTransactionIntentResponse,
            signedTransactionIntent: self.signedTransactionIntent,
            compileSignedTransactionIntentResponse: compileSignedTransactionIntentResponse,
            notarizedTransaction: notarizedTransaction
        )
    }
}

public struct NotarizedSignedTransctionContext: Hashable {
    public internal(set) var transactionIntent: TransactionIntent
    public internal(set) var transactionIntentHash: Data
    public internal(set) var compileTransactionIntentResponse: CompileTransactionIntentResponse
    public internal(set) var signedTransactionIntent: SignedTransactionIntent
    public internal(set) var compileSignedTransactionIntentResponse: CompileSignedTransactionIntentResponse
    public internal(set) var notarizedTransaction: NotarizedTransaction
    
}
public extension TransactionIntent {
    func sign(with privateKey: Curve25519.Signing.PrivateKey) throws -> NotarizedNonNotarySignedButIntentSignedTransctionContext {
        try sign(with: Engine.PrivateKey.curve25519(privateKey))
    }
    
    func sign(with privateKey: K1.PrivateKey) throws -> NotarizedNonNotarySignedButIntentSignedTransctionContext {
        try sign(with: Engine.PrivateKey.secp256k1(privateKey))
    }
    
    func sign(with privateKey: PrivateKey) throws -> NotarizedNonNotarySignedButIntentSignedTransctionContext {
        try sign(with: privateKey.intoEngine())
    }
    
    func sign(with privateKey: Engine.PrivateKey) throws -> NotarizedNonNotarySignedButIntentSignedTransctionContext {
        try sign(withMany: [privateKey])
    }
    
    func sign(withMany privateKeys: [Engine.PrivateKey]) throws -> NotarizedNonNotarySignedButIntentSignedTransctionContext {
       
        let compiledTransactionIntentResponse = try EngineToolkit()
            .compileTransactionIntentRequest(
                request: self
            ).get()
        let compiledTransactionIntent = compiledTransactionIntentResponse.compiledIntent
        
        let intentSignaturesWithHash = try privateKeys.map {
            try $0.signReturningHashOfMessage(data: compiledTransactionIntent)
        }
        let transactionIntentHash = intentSignaturesWithHash.first?.hashOfMessage ?? Data(SHA256.twice(data: compiledTransactionIntent))
        assert(intentSignaturesWithHash.map { $0.hashOfMessage }.allSatisfy { $0 == transactionIntentHash })
        
        let signedTransactionIntent = SignedTransactionIntent(
            intent: self,
            intentSignatures: intentSignaturesWithHash.map { $0.signatureWithPublicKey }
        )
        
        return NotarizedNonNotarySignedButIntentSignedTransctionContext(
            transactionIntent: self,
            transactionIntentHash: transactionIntentHash,
            compileTransactionIntentResponse: compiledTransactionIntentResponse,
            signedTransactionIntent: signedTransactionIntent
        )
    }
}


public extension NotarizedNonNotarySignedButIntentSignedTransctionContext {
    func sign(with privateKey: Curve25519.Signing.PrivateKey) throws -> NotarizedNonNotarySignedButIntentSignedTransctionContext {
        try sign(with: Engine.PrivateKey.curve25519(privateKey))
    }
    
    func sign(with privateKey: K1.PrivateKey) throws -> NotarizedNonNotarySignedButIntentSignedTransctionContext {
        try sign(with: Engine.PrivateKey.secp256k1(privateKey))
    }
    
    func sign(with privateKey: PrivateKey) throws -> NotarizedNonNotarySignedButIntentSignedTransctionContext {
        try sign(with: privateKey.intoEngine())
    }
        
    func sign(with privateKey: Engine.PrivateKey) throws -> NotarizedNonNotarySignedButIntentSignedTransctionContext {
       
        let compiledSignedTransactionIntent = try EngineToolkit().compileSignedTransactionIntentRequest(
            request: self.signedTransactionIntent
        ).get().compiledSignedIntent
        
        let (signature, _) = try privateKey.signReturningHashOfMessage(data: compiledSignedTransactionIntent)
        
        let signedTransactionIntent = SignedTransactionIntent(
            intent: self.transactionIntent,
            intentSignatures: self.signedTransactionIntent.intentSignatures + [signature]
        )
        var mutableSelf = self
        mutableSelf.signedTransactionIntent = signedTransactionIntent
        return mutableSelf
    }
}

public extension NotarizedNonNotarySignedButIntentSignedTransctionContext {
    
    func notarize(_ notaryPrivateKey: Curve25519.Signing.PrivateKey) throws -> NotarizedSignedTransctionContext {
        try notarize(Engine.PrivateKey.curve25519(notaryPrivateKey))
    }
    
    func notarize(_ notaryPrivateKey: K1.PrivateKey) throws -> NotarizedSignedTransctionContext {
        try notarize(Engine.PrivateKey.secp256k1(notaryPrivateKey))
    }
    
    func notarize(_ notaryPrivateKey: PrivateKey) throws -> NotarizedSignedTransctionContext {
        try notarize(notaryPrivateKey.intoEngine())
    }
        
    func notarize(_ notaryPrivateKey: Engine.PrivateKey) throws -> NotarizedSignedTransctionContext {
         
        let compileSignedTransactionIntentResponse = try EngineToolkit().compileSignedTransactionIntentRequest(
            request: signedTransactionIntent
        ).get()
            
        let compiledSignedTransactionIntent = compileSignedTransactionIntentResponse.compiledSignedIntent
        
        // Notarize the signed intent to create a notarized transaction
        let notarySignature = try notaryPrivateKey.sign(data: compiledSignedTransactionIntent)
        
        let notarizedTransaction = NotarizedTransaction(
            signedIntent: signedTransactionIntent,
            notarySignature: notarySignature.signature
        )
        
        return with(
            compileSignedTransactionIntentResponse: compileSignedTransactionIntentResponse,
            notarizedTransaction: notarizedTransaction
        )
    }
}
