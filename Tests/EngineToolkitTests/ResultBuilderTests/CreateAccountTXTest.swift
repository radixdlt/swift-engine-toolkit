//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-10-26.
//

import Foundation
@testable import EngineToolkit
import SLIP10

// MARK: - AlphanetAddresses
private enum AlphanetAddresses {}
private extension AlphanetAddresses {
    static let faucet: ComponentAddress = "component_sim1qftacppvmr9ezmekxqpq58en0nk954x0a7jv2zz0hc7q8utaxr"
    static let createAccountComponent: PackageAddress = "package_sim1qyqzcexvnyg60z7lnlwauh66nhzg3m8tch2j8wc0e70qkydk8r"
    static let xrd: ResourceAddress = "resource_sim1qzxcrac59cy2v9lpcpmf82qel3cjj25v3k5m09rxurgqehgxzu"
}


final class CreateAccountTXTest: TestCase {
    
    override func setUp() {
        debugPrint = true
        super.setUp()
        continueAfterFailure = false
    }
    
    func test_create_account_tx() throws {
      
        let privateKeyData = try Data(hex: "deadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeef")
        let privateKey = try Engine.PrivateKey.curve25519(.init(rawRepresentation: privateKeyData))
        
        let nonFungibleAddressHex = try sut.deriveNonFungibleAddressFromPublicKeyRequest(
                request: privateKey.publicKey()
            )
            .get()
            .nonFungibleAddress
        let nonFungibleAddress = try NonFungibleAddress(hex: nonFungibleAddressHex)

        let transactionManifest = TransactionManifest {
            CallMethod(
                receiver: AlphanetAddresses.faucet,
                methodName: "lock_fee"
            ) {
                Decimal_(10.0)
            }

            CallMethod(
                receiver: AlphanetAddresses.faucet,
                methodName: "free_xrd"
            )

            let xrdBucket: Bucket = "xrd"

            TakeFromWorktop(resourceAddress: AlphanetAddresses.xrd, bucket: xrdBucket)

            CallFunction(
                packageAddress: AlphanetAddresses.createAccountComponent,
                blueprintName: "Account",
                functionName: "new_with_resource"
            ) {
                Enum("Protected") {
                    Enum("ProofRule") {
                        Enum("Require") {
                            Enum("StaticNonFungible") {
                                nonFungibleAddress
                            }
                        }
                    }
                }
                xrdBucket
            }
        }
        
        let startEpoch: Epoch = 8000
        let endEpochExclusive = startEpoch + 2
        let networkID: NetworkID = .simulator
        let header = TransactionHeader(
            version: 1,
            networkId: networkID,
            startEpochInclusive: startEpoch,
            endEpochExclusive: endEpochExclusive,
            nonce: 12345,
            publicKey: try privateKey.publicKey(),
            notaryAsSignatory: true,
            costUnitLimit: 10_000_000,
            tipPercentage: 0
        )
        
           let jsonManifest = try sut.convertManifest(
                request: .init(
                    transactionVersion: header.version,
                    manifest: transactionManifest,
                    outputFormat: .json,
                    networkId: networkID
                )
            ).get()
        
        
        
        let manifestString = jsonManifest.toString(
            preamble: "",
            instructionsSeparator: "",
            instructionsArgumentSeparator: " ",
            networkID: networkID
        )
        let expected = """
        CALL_METHOD ComponentAddress("component_sim1qftacppvmr9ezmekxqpq58en0nk954x0a7jv2zz0hc7q8utaxr") "lock_fee" Decimal("10");CALL_METHOD ComponentAddress("component_sim1qftacppvmr9ezmekxqpq58en0nk954x0a7jv2zz0hc7q8utaxr") "free_xrd";TAKE_FROM_WORKTOP ResourceAddress("resource_sim1qzxcrac59cy2v9lpcpmf82qel3cjj25v3k5m09rxurgqehgxzu") Bucket("bucket1");CALL_FUNCTION PackageAddress("package_sim1qyqzcexvnyg60z7lnlwauh66nhzg3m8tch2j8wc0e70qkydk8r") "Account" "new_with_resource" Enum("Protected", Enum("ProofRule", Enum("Require", Enum("StaticNonFungible", NonFungibleAddress("000f8e920aa79f53349d0a99746e17b59241bd51e19abb50ad6b6a30071a00000071cf1c6fc032e971de8fd8349a2b05dcb6d57ff15bef8bfbe98e"))))) Bucket("bucket1");
        """
        XCTAssertEqual(expected, manifestString)
        
        let manifestString2 = jsonManifest.toString(
            preamble: "",
            instructionsSeparator: "\n\n",
            instructionsArgumentSeparator: "\n\t",
            networkID: networkID
        )
        
        let expected2 = """
        CALL_METHOD
            ComponentAddress("component_sim1qftacppvmr9ezmekxqpq58en0nk954x0a7jv2zz0hc7q8utaxr")
            "lock_fee"
            Decimal("10");

        CALL_METHOD
            ComponentAddress("component_sim1qftacppvmr9ezmekxqpq58en0nk954x0a7jv2zz0hc7q8utaxr")
            "free_xrd";

        TAKE_FROM_WORKTOP
            ResourceAddress("resource_sim1qzxcrac59cy2v9lpcpmf82qel3cjj25v3k5m09rxurgqehgxzu")
            Bucket("bucket1");

        CALL_FUNCTION
            PackageAddress("package_sim1qyqzcexvnyg60z7lnlwauh66nhzg3m8tch2j8wc0e70qkydk8r")
            "Account"
            "new_with_resource"
            Enum("Protected",
            Enum("ProofRule",
            Enum("Require",
            Enum("StaticNonFungible",
            NonFungibleAddress("000f8e920aa79f53349d0a99746e17b59241bd51e19abb50ad6b6a30071a00000071cf1c6fc032e971de8fd8349a2b05dcb6d57ff15bef8bfbe98e")))))
            Bucket("bucket1");
        """
        XCTAssertEqual(expected2.replacingOccurrences(of: "    ", with: "_").replacingOccurrences(of: "\t", with: "_"), manifestString2.replacingOccurrences(of: "    ", with: "_").replacingOccurrences(of: "\t", with: "_"))

        let signTxContext = try transactionManifest
            .header(header)
            .notarize(privateKey)

        XCTAssertNoThrow(try sut.compileSignedTransactionIntentRequest(request: signTxContext.signedTransactionIntent).get())
        
        
    }
}
