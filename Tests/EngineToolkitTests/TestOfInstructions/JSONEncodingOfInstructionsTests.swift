//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-10-26.
//

import Foundation
@testable import EngineToolkit
import SLIP10


final class JSONEncodingOfInstructionsTests: TestCase {
    
    override func setUp() {
        debugPrint = true
        super.setUp()
        continueAfterFailure = false
    }
    
    func test_encode_call_method() throws {
        let callMethod = CallMethod(
            componentAddress: "system_tdx_a_1qsqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqs2ufe42",
            methodName: "lock_fee"
        ) {
            Decimal_(10.0)
        }
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .withoutEscapingSlashes]
        let jsonData = try encoder.encode(callMethod)
        let jsonString = try XCTUnwrap(String(data: jsonData, encoding: .utf8))
        let expectedJSON = """
        {
          "arguments" : [
            {
              "type" : "Decimal",
              "value" : "10"
            }
          ],
          "component_address" : {
            "type" : "ComponentAddress",
            "address" : "system_tdx_a_1qsqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqs2ufe42"
          },
          "instruction" : "CALL_METHOD",
          "method_name" : {
            "type" : "String",
            "value" : "lock_fee"
          }
        }
        """
        XCTAssertEqual(expectedJSON, jsonString)
    }
    
    func test_encode_call_function() throws {
        
        let callFunction = CallFunction(
            packageAddress: "package_tdx_a_1qyqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqps373guw",
            blueprintName: "Account",
            functionName: "new_with_resource"
        ) {
            Enum("Protected") {
                String("foobar")
            }
        }
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .withoutEscapingSlashes]
        let jsonData = try encoder.encode(callFunction)
        let jsonString = try XCTUnwrap(String(data: jsonData, encoding: .utf8))
        let expectedJSON = """
        {
          "function_name" : {
            "type" : "String",
            "value" : "new_with_resource"
          },
          "arguments" : [
            {
              "type" : "Enum",
              "variant" : "Protected",
              "fields" : [
                {
                  "type" : "String",
                  "value" : "foobar"
                }
              ]
            }
          ],
          "instruction" : "CALL_FUNCTION",
          "package_address" : {
            "type" : "PackageAddress",
            "address" : "package_tdx_a_1qyqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqps373guw"
          },
          "blueprint_name" : {
            "type" : "String",
            "value" : "Account"
          }
        }
        """
        XCTAssertEqual(expectedJSON, jsonString)
    }
}
