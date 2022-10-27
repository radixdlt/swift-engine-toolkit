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
    static let faucet: ComponentAddress = "system_tdx_a_1qsqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqs2ufe42"
    static let createAccountComponent: PackageAddress = "package_tdx_a_1qyqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqps373guw"
    static let xrd: ResourceAddress = "resource_tdx_a_1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqzqegh4k9"
}


final class CreateAccountTXTest: TestCase {
    
    override func setUp() {
        debugPrint = false
        super.setUp()
        continueAfterFailure = false
    }
    
    func test_create_account_tx() throws {
      
        let privateKeyData = try Data(hex: "deadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeef")
        let privateKey = try Engine.PrivateKey.curve25519(.init(rawRepresentation: privateKeyData))
        
        let nonFungibleAddress = try sut.deriveNonFungibleAddressFromPublicKeyRequest(
                request: privateKey.publicKey()
            )
            .get()
            .nonFungibleAddress

        let transactionManifest = TransactionManifest {
            CallMethod(
                componentAddress: AlphanetAddresses.faucet,
                methodName: "lock_fee"
            ) {
                Decimal_(10.0)
            }

            CallMethod(
                componentAddress: AlphanetAddresses.faucet,
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
        let networkID: NetworkID = .adapanet
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
        
        XCTAssertNoThrow(
            try sut.convertManifest(
                request: .init(
                    transactionVersion: header.version,
                    manifest: transactionManifest,
                    outputFormat: .string,
                    networkId: networkID
                )
            ).get()
        )

        let signTxContext = try transactionManifest
            .header(header)
            .notarize(privateKey)

        XCTAssertNoThrow(try sut.compileSignedTransactionIntentRequest(request: signTxContext.signedTransactionIntent).get())
        
        
    }
}
