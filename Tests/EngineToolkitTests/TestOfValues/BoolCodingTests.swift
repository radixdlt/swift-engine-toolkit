//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-10-10.
//

import Foundation
@testable import EngineToolkit

final class BoolCodingTests: TestCase {
    
    func test_json_encode() throws {
        let encoder = JSONEncoder()
        let json = try encoder.encode(Value.boolean(true))
        let expected = """
        {
          "type" : "Bool",
          "value" : true
        }
        """
        XCTAssertEqual(
            expected,
            json.prettyPrintedJSONString?.trimmingCharacters(in: .whitespaces)
        )
    }
    
    func test_json_decode() throws {
        let decoder = JSONDecoder()
        let json = """
        {
          "type" : "Bool",
          "value" : true
        }
        """.data(using: .utf8)!
        let value = try decoder.decode(Value.self, from: json)
        XCTAssertEqual(value, Value.boolean(true))
    }
}
