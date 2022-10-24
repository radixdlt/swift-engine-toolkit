@testable import EngineToolkit
import CryptoKit


final class TransactionBuildingTests: TestCase {
    
    func test_building_notarized_transaction() throws {

        let privateKeyA = Engine.PrivateKey.curve25519(.init())
        let privateKeyB = Engine.PrivateKey.curve25519(.init())
        let privateKeyC = Engine.PrivateKey.curve25519(.init())
        let notaryPrivateKey = Engine.PrivateKey.curve25519(.init())

        let notarized = try TransactionManifest.complex
            .header(.example(notaryPrivateKey: notaryPrivateKey))
            .blobs([[0xde, 0xad], [0xbe, 0xef]])
            .sign(with: privateKeyA)
            .sign(with: privateKeyB)
            .sign(with: privateKeyC)
            .notarize(notaryPrivateKey)
        
        let signedTransactionIntent = SignedTransactionIntent(
            intent: notarized.signedIntent.intent,
            intentSignatures: notarized.signedIntent.intentSignatures
        )
        
        let compiledSignedTransactionIntent = try EngineToolkit().compileSignedTransactionIntentRequest(
            request: signedTransactionIntent
        ).get().compiledSignedIntent
        
        let isValid = try notaryPrivateKey
            .publicKey()
            .isValidSignature(
                notarized.notarySignature,
                for: compiledSignedTransactionIntent
            )
        
        XCTAssertTrue(isValid)
    }
}

public extension TransactionHeader {
    
    static func example(
        notaryPrivateKey: Engine.PrivateKey
    ) throws -> Self {
        
        try Self(
            version: 0x01,
            networkId: 0xF2,
            startEpochInclusive: 0,
            endEpochExclusive: 10,
            nonce: 0,
            publicKey: notaryPrivateKey.publicKey(),
            notaryAsSignatory: true,
            costUnitLimit: 10_000_000,
            tipPercentage: 0
        )
    }
}
