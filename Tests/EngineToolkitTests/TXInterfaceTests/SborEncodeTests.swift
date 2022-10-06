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
        let decoded: Value = try sut.sborDecodeRequest(request: decodeRequest)
        XCTAssertEqual(decoded, vector.decoded, line: line)
        
        let encodeRequest = vector.decoded
        let encoded = try sut.sborEncodeRequest(request: encodeRequest)
        XCTAssertEqual(encoded.encodedValue, [UInt8](hex: vector.encoded))
        
    }
    typealias TestSuite = SborDecodeEncodeTestVectors
}

// NOTE: We will need to update these test vectors when SBOR gets updated.
enum SborDecodeEncodeTestVectors {
    private static let encoded: [String] = [
        "a120000000000077320a73efb0060000000000000000000000000000000000000000000000",
        "0c0c00000048656c6c6f20576f726c6421",
        "1200b1040000000c000000",
        "1300a2400000000000000000000000d1531fee3d622fe08fbe322151e4226dd6911475000000000000000000000000000000000000000000000000000000000000000000000000"
    ]
    
    private static let decoded: [Value] = [
        Value.decimalType(Decimal_(from: "123.43")),
        Value.stringType(String_(from: "Hello World!")),
        Value.optionType(Option.some(Value.bucketType(Bucket(from: Identifier.u32(12))))),
        Value.resultType(Result.ok(Value.preciseDecimalType(PreciseDecimal(from: "1233"))))
    ]
    typealias Vector = (encoded: String, decoded: Value)
    private static func vector(at index: Int) -> Vector {
        (encoded: Self.encoded[index], decoded: Self.decoded[index])
    }
    static var vectors: [Vector] {
        precondition(encoded.count == decoded.count)
        return (0..<encoded.count).map {
            vector(at: $0)
        }
    }
}
