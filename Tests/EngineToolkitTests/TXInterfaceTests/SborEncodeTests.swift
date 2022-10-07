@_exported @testable import EngineToolkit

final class SborEncodeDecodeRequestTests: TestCase {
    
    func test__encodeDecodeAddressRequest() throws {
        try TestSuite.vectors.forEach { try doTest(vector: $0) }
    }
}

private extension SborEncodeDecodeRequestTests {
    func doTest(
        vector: SborDecodeEncodeTestVectors.Vector,
        networkID: NetworkID = .simulator,
        line: UInt = #line
    ) throws {
   
        let decodeRequest = SborDecodeRequest(
            encodedHex: vector.encoded
        )
        let decoded: Value = try sut.sborDecodeRequest(request: decodeRequest).get()
        XCTAssertEqual(decoded, vector.decoded, line: line)
        
        let encodeRequest = vector.decoded
        let encoded = try sut.sborEncodeRequest(request: encodeRequest).get()
        XCTAssertEqual(encoded.encodedValue, [UInt8](hex: vector.encoded), line: line)
        
    }
    typealias TestSuite = SborDecodeEncodeTestVectors
}

// NOTE: We will need to update these test vectors if SBOR gets updated.
enum SborDecodeEncodeTestVectors {
    typealias Vector = (encoded: String, decoded: Value)
    static let vectors: [Vector] = [
        // SBOR Primitive Types
        (
            encoded: "0000",
            decoded: .unitType(Unit())
        ),
        (
            encoded: "0100",
            decoded: .booleanType(Boolean(from: false))
        ),
        (
            encoded: "0101",
            decoded: .booleanType(Boolean(from: true))
        ),
        
        (
            encoded: "0701",
            decoded: .u8Type(U8(from: 1))
        ),
        (
            encoded: "080200",
            decoded: .u16Type(U16(from: 2))
        ),
        (
            encoded: "0903000000",
            decoded: .u32Type(U32(from: 3))
        ),
        (
            encoded: "0a0400000000000000",
            decoded: .u64Type(U64(from: 4))
        ),
        (
            encoded: "0b05000000000000000000000000000000",
            decoded: .u128Type(U128(from: "5"))
        ),
        
        (
            encoded: "0206",
            decoded: .i8Type(I8(from: 6))
        ),
        (
            encoded: "030700",
            decoded: .i16Type(I16(from: 7))
        ),
        (
            encoded: "0408000000",
            decoded: .i32Type(I32(from: 8))
        ),
        (
            encoded: "050900000000000000",
            decoded: .i64Type(I64(from: 9))
        ),
        (
            encoded: "060a000000000000000000000000000000",
            decoded: .i128Type(I128(from: "10"))
        ),
        
        (
            encoded: "0c0c00000048656c6c6f20576f726c6421",
            decoded: .stringType(String_(from: "Hello World!"))
        ),
        
        (
            encoded: "1002000000070c0c050000005261646978",
            decoded: .structType(Struct(
                from: [
                    .u8Type(U8(from: 12)),
                    .stringType(String_(from: "Radix"))
                ]
            ))
        ),
        (
            encoded: "11070000004661737443617202000000070c0c050000005261646978",
            decoded: .enumType(Enum(
                from: "FastCar",
                fields: [
                    .u8Type(U8(from: 12)),
                    .stringType(String_(from: "Radix"))
                ]
            ))
        ),
        
        (
            encoded: "12000764",
            decoded: .optionType(.some(.u8Type(U8(from: 100))))
        ),
        (
            encoded: "1201",
            decoded: .optionType(.none)
        ),
        
        (
            encoded: "13000000",
            decoded: .resultType(.success(.unitType(Unit())))
        ),
        (
            encoded: "13010000",
            decoded: .resultType(.failure(.unitType(Unit())))
        ),
        
        (
            encoded: "2007020000000c00",
            decoded: .arrayType(Array_(
                from: .u8,
                elements: [
                    .u8Type(U8(from: 12)),
                    .u8Type(U8(from: 0)),
                ]
            ))
        ),
        (
            encoded: "3107020000000c00",
            decoded: .setType(Set_(
                from: .u8,
                elements: [
                    .u8Type(U8(from: 12)),
                    .u8Type(U8(from: 0)),
                ]
            ))
        ),
        (
            encoded: "3007020000000c00",
            decoded: .listType(List(
                from: .u8,
                elements: [
                    .u8Type(U8(from: 12)),
                    .u8Type(U8(from: 0)),
                ]
            ))
        ),
        (
            encoded: "2102000000070c0700",
            decoded: .tupleType(Tuple(
                from: [
                    .u8Type(U8(from: 12)),
                    .u8Type(U8(from: 0)),
                ]
            ))
        ),
        (
            encoded: "320707010000000c00",
            decoded: .mapType(Map(
                from: .u8,
                valueType: .u8,
                elements: [
                    .u8Type(U8(from: 12)),
                    .u8Type(U8(from: 0)),
                ]
            ))
        ),
    ]
}
