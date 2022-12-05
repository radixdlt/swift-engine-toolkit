//
//  File.swift
//
//
//  Created by Alexander Cyon on 2022-10-10.
//

import Foundation
@testable import EngineToolkit

final class OptionalCodingTests: TestCase {
    
    func test_json_encode() throws {
        let encoder = JSONEncoder()
        let json = try encoder.encode(Value.option(.some(.string("hey"))))
        let expected = """
        {
          "type" : "Option",
          "variant" : "Some",
          "field" : {
            "type" : "String",
            "value" : "hey"
          }
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
          "type" : "Option",
          "variant" : "Some",
          "field" : {
            "type" : "String",
            "value" : "hey"
          }
        }
        """.data(using: .utf8)!
        let value = try decoder.decode(Value.self, from: json)
        XCTAssertEqual(value, Value.option(.some(.string("hey"))))
    }
}
