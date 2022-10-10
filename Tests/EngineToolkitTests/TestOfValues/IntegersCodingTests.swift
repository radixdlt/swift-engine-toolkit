//
//  File.swift
//
//
//  Created by Alexander Cyon on 2022-10-10.
//

import Foundation
@testable import EngineToolkit

final class IntegersCodingTests: TestCase {
    
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()

    func test_int8_json_encode() throws {
        let json = try encoder.encode(Value.i8(42))
        let expected = """
        {
          "type" : "I8",
          "value" : "42"
        }
        """
        XCTAssertEqual(
            expected,
            json.prettyPrintedJSONString?.trimmingCharacters(in: .whitespaces)
        )
    }
    
    func test_int8_json_decode() throws {
        let json = """
        {
          "type" : "I8",
          "value" : "42"
        }
        """.data(using: .utf8)!
        let value = try decoder.decode(Value.self, from: json)
        XCTAssertEqual(value, Value.i8(42))
    }
    
    func test_int16_json_encode() throws {
        let json = try encoder.encode(Value.i16(32767))
        let expected = """
        {
          "type" : "I16",
          "value" : "32767"
        }
        """
        XCTAssertEqual(
            expected,
            json.prettyPrintedJSONString?.trimmingCharacters(in: .whitespaces)
        )
    }
    
    func test_int16_json_decode() throws {
        let json = """
        {
          "type" : "I16",
          "value" : "32767"
        }
        """.data(using: .utf8)!
        let value = try decoder.decode(Value.self, from: json)
        XCTAssertEqual(value, Value.i16(32767))
    }
    
    func test_int32_json_encode() throws {
        let json = try encoder.encode(Value.i32(2147483647))
        let expected = """
        {
          "type" : "I32",
          "value" : "2147483647"
        }
        """
        XCTAssertEqual(
            expected,
            json.prettyPrintedJSONString?.trimmingCharacters(in: .whitespaces)
        )
    }
    
    func test_int32_json_decode() throws {
        let json = """
        {
          "type" : "I32",
          "value" : "2147483647"
        }
        """.data(using: .utf8)!
        let value = try decoder.decode(Value.self, from: json)
        XCTAssertEqual(value, Value.i32(2147483647))
    }
    
    func test_int64_json_encode() throws {
        let json = try encoder.encode(Value.i64(9223372036854775807))
        let expected = """
        {
          "type" : "I64",
          "value" : "9223372036854775807"
        }
        """
        XCTAssertEqual(
            expected,
            json.prettyPrintedJSONString?.trimmingCharacters(in: .whitespaces)
        )
    }
    
    func test_int64_json_decode() throws {
        let json = """
        {
          "type" : "I64",
          "value" : "9223372036854775807"
        }
        """.data(using: .utf8)!
        let value = try decoder.decode(Value.self, from: json)
        XCTAssertEqual(value, Value.i64(9223372036854775807))
    }
    
    func test_uint8_json_encode() throws {
        let json = try encoder.encode(Value.u8(255))
        let expected = """
        {
          "type" : "U8",
          "value" : "255"
        }
        """
        XCTAssertEqual(
            expected,
            json.prettyPrintedJSONString?.trimmingCharacters(in: .whitespaces)
        )
    }
    
    func test_uint8_json_decode() throws {
        let json = """
        {
          "type" : "U8",
          "value" : "255"
        }
        """.data(using: .utf8)!
        let value = try decoder.decode(Value.self, from: json)
        XCTAssertEqual(value, Value.u8(255))
    }
    
    func test_uint16_json_encode() throws {
        let json = try encoder.encode(Value.u16(65535))
        let expected = """
        {
          "type" : "U16",
          "value" : "65535"
        }
        """
        XCTAssertEqual(
            expected,
            json.prettyPrintedJSONString?.trimmingCharacters(in: .whitespaces)
        )
    }
    
    func test_uint16_json_decode() throws {
        let json = """
        {
          "type" : "U16",
          "value" : "65535"
        }
        """.data(using: .utf8)!
        let value = try decoder.decode(Value.self, from: json)
        XCTAssertEqual(value, Value.u16(65535))
    }
    
    func test_uint32_json_encode() throws {
        let json = try encoder.encode(Value.u32(4294967295))
        let expected = """
        {
          "type" : "U32",
          "value" : "4294967295"
        }
        """
        XCTAssertEqual(
            expected,
            json.prettyPrintedJSONString?.trimmingCharacters(in: .whitespaces)
        )
    }
    
    func test_uint32_json_decode() throws {
        let json = """
        {
          "type" : "U32",
          "value" : "4294967295"
        }
        """.data(using: .utf8)!
        let value = try decoder.decode(Value.self, from: json)
        XCTAssertEqual(value, Value.u32(4294967295))
    }
    
    func test_uint64_json_encode() throws {
        let json = try encoder.encode(Value.u64(18446744073709551615))
        let expected = """
        {
          "type" : "U64",
          "value" : "18446744073709551615"
        }
        """
        XCTAssertEqual(
            expected,
            json.prettyPrintedJSONString?.trimmingCharacters(in: .whitespaces)
        )
    }
    
    func test_uint64_json_decode() throws {
        let json = """
        {
          "type" : "U64",
          "value" : "18446744073709551615"
        }
        """.data(using: .utf8)!
        let value = try decoder.decode(Value.self, from: json)
        XCTAssertEqual(value, Value.u64(18446744073709551615))
    }
}
