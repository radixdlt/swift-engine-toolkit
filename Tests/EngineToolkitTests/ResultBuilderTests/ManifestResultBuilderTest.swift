//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-10-07.
//

import Foundation
@testable import EngineToolkit

final class ManifestResultBuilderTest: TestCase {
    func test__complex_resultBuilder() throws {
        let expected = try sut.convertManifest(request: makeRequest(outputFormat: .json, manifest: .complex)).get()
        
        let built = try TransactionManifest {
            
            // Withdraw XRD from account
            CallMethod(
                componentAddress: "account_sim1q02r73u7nv47h80e30pc3q6ylsj7mgvparm3pnsm780qgsy064",
                methodName: "withdraw_by_amount"
            ) {
                Decimal_(5.0)
                ResourceAddress("resource_sim1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqzqu57yag")
            }
            
            // Buy GUM with XRD
            TakeFromWorktopByAmount(
                amount: 2.0,
                resourceAddress: "resource_sim1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqzqu57yag",
                bucket: "xrd"
            )
            CallMethod(
                componentAddress: "component_sim1q2f9vmyrmeladvz0ejfttcztqv3genlsgpu9vue83mcs835hum",
                methodName: "buy_gumball"
            ) { Bucket("xrd") }
            
            AssertWorktopContainsByAmount(
                amount: 3.0,
                resourceAddress: "resource_sim1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqzqu57yag"
            )
            AssertWorktopContains(resourceAddress: "resource_sim1qzhdk7tq68u8msj38r6v6yqa5myc64ejx3ud20zlh9gseqtux6")
            
            // Create a proof from bucket, clone it and drop both
            TakeFromWorktop(
                resourceAddress: "resource_sim1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqzqu57yag",
                bucket: "some_xrd"
            )
            CreateProofFromBucket(bucket: "some_xrd", proof: "proof1")
            CloneProof(from: "proof1", to: "proof2")
            DropProof("proof1")
            DropProof("proof2")
            
            // Create a proof from account and drop it
            CallMethod(
                componentAddress: "account_sim1q02r73u7nv47h80e30pc3q6ylsj7mgvparm3pnsm780qgsy064",
                methodName: "create_proof_by_amount"
            ) {
                Decimal_(5.0)
                ResourceAddress("resource_sim1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqzqu57yag")
            }
            
            PopFromAuthZone(proof: "proof3")
            DropProof("proof3")
            
            // Return a bucket to worktop
            ReturnToWorktop(bucket: "some_xrd")
            TakeFromWorktopByIds(
                [
                    try NonFungibleId(hex: "0905000000"),
                    try NonFungibleId(hex: "0907000000")
                ],
                resourceAddress: "resource_sim1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqzqu57yag",
                bucket: "nfts"
            )
            
            // Create a new fungible resource
            CreateResource {
                Enum("Fungible") { UInt8(0) }
                Map(keyType: .string, valueType: .string)
                Map(keyType: .enum, valueType: .tuple)
                Optional {
                    Enum("Fungible") { Decimal_(1.0) }
                }
            }
            
            // Cancel all buckets and move resources to account
            CallMethod(
                componentAddress: "account_sim1q02r73u7nv47h80e30pc3q6ylsj7mgvparm3pnsm780qgsy064",
                methodName: "deposit_batch"
            ) {
                Expression("ENTIRE_WORKTOP")
            }
            
            // Drop all proofs
            DropAllProofs()
            
            // Complicated method that takes all of the number types
            CallMethod(
                componentAddress: "component_sim1q2f9vmyrmeladvz0ejfttcztqv3genlsgpu9vue83mcs835hum",
                methodName: "complicated_method"
            ) {
                Decimal_(1)
                PreciseDecimal(2)
            }
        }
        
        XCTAssertEqual(built, expected)
    }
}
