@testable import EngineToolkit
import CryptoKit

extension Curve25519.Signing.PublicKey {
    func isValidSignature(_ signatureWrapper: Signature, for message: any DataProtocol) -> Bool {
        switch signatureWrapper {
        case let .eddsaEd25519(signatureString):
            let signatureData = Data(signatureString.bytes)
            return isValidSignature(signatureData, for: message)
        case .ecdsaSecp256k1: return false
        }
    }
}

final class TransactionBuildingTests: TestCase {
    
    func test_building_notarized_transaction() throws {

        let privateKeyA = Curve25519.Signing.PrivateKey()
        let privateKeyB = Curve25519.Signing.PrivateKey()
        let privateKeyC = Curve25519.Signing.PrivateKey()
        let notaryPrivateKey = Curve25519.Signing.PrivateKey()

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
        
        let isValid = notaryPrivateKey
            .publicKey
            .isValidSignature(
                notarized.notarySignature,
                for: compiledSignedTransactionIntent
            )
        
        XCTAssertTrue(isValid)
    }
}

public extension TransactionHeader {
    
    static func example(
        notaryPrivateKey: Curve25519.Signing.PrivateKey
    ) -> Self {
        
        Self(
            version: 0x01,
            networkId: 0xF2,
            startEpochInclusive: 0,
            endEpochExclusive: 10,
            nonce: 0,
            publicKey: .eddsaEd25519(
                EddsaEd25519PublicKeyString(bytes: [UInt8](notaryPrivateKey.publicKey.rawRepresentation))
            ),
            notaryAsSignatory: true,
            costUnitLimit: 10_000_000,
            tipPercentage: 0
        )
    }
}
