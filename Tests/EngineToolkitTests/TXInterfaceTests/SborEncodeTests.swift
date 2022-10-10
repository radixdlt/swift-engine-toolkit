@testable import EngineToolkit

final class SborEncodeDecodeRequestTests: TestCase {
    
    override func setUp() {
        debugPrint = true
        super.setUp()
    }
    
    func test__encodeDecodeAddressRequest() throws {
        try TestSuite.vectors.enumerated().forEach { try doTest(vector: $1, index: $0) }
    }
}

private extension SborEncodeDecodeRequestTests {
    func doTest(
        vector: SborDecodeEncodeTestVectors.Vector,
        index: Int,
        networkID: NetworkID = .simulator,
        line: UInt = #line
    ) throws {
        guard index == 16 else { return }
        print("✨ vector @ \(index)")
        let decodeRequest = try SborDecodeRequest(
            encodedHex: vector.encoded
        )
        let decoded = try sut.sborDecodeRequest(request: decodeRequest).get()
        XCTAssertEqual(decoded, vector.decoded)//, line: line)
        
        let encodeRequest = vector.decoded
        let encoded = try sut.sborEncodeRequest(request: encodeRequest).get()
        XCTAssertEqual(encoded.encodedValue, try [UInt8](hex: vector.encoded))//, line: line)
        
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
            decoded: .unit(Unit())
        ),
        (
            encoded: "0100",
            decoded: .boolean(false)
        ),
        (
            encoded: "0101",
            decoded: .boolean(true)
        ),
        (
            encoded: "0701",
            decoded: .u8(1)
        ),
        (
            encoded: "080200",
            decoded: .u16(2)
        ),
        (
            encoded: "0903000000",
            decoded: .u32(3)
        ),
        (
            encoded: "0a0400000000000000",
            decoded: .u64(4)
        ),
        (
            encoded: "0b05000000000000000000000000000000",
            decoded: .u128("5")
        ),
        (
            encoded: "0206",
            decoded: .i8(6)
        ),
        (
            encoded: "030700",
            decoded: .i16(7)
        ),
        (
            encoded: "0408000000",
            decoded: .i32(8)
        ),
        (
            encoded: "050900000000000000",
            decoded: .i64(9)
        ),
        (
            encoded: "060a000000000000000000000000000000",
            decoded: .i128("10")
        ),
        
        (
            encoded: "0c0c00000048656c6c6f20576f726c6421",
            decoded: .string("Hello World!")
        ),
        
        (
            encoded: "1002000000070c0c050000005261646978",
            decoded: .struct(Struct {
                U8(12)
                String_("Radix")
            })
        ),
        (
            encoded: "11070000004661737443617202000000070c0c050000005261646978",
            decoded: .enum(Enum("FastCar") {
                    U8(12)
                    String_("Radix")
                })
        ),
        
        (
            encoded: "12000764",
            decoded: .option(.some(U8(100)))
        ),
        (
            encoded: "1201",
            decoded: .option(.none)
        ),
        
        (
            encoded: "13000000",
            decoded: .result(.success(.unit(Unit())))
        ),
        (
            encoded: "13010000",
            decoded: .result(.failure(.unit(Unit())))
        ),
        
        (
            encoded: "2007020000000c00",
            decoded: .array(try! Array_(
                elementType: .u8) {
                    U8(12)
                    U8(0)
                }
            )
        ),
        (
            encoded: "3107020000000c00",
            decoded: .set(try! Set_(
                elementType: .u8) {
                    U8(12)
                    U8(0)
                }
            )
        ),
        (
            encoded: "3007020000000c00",
            decoded: .list(try! List(
                elementType: .u8
            ) {
                U8(12)
                U8(0)
            }
            )
        ),
        (
            encoded: "2102000000070c0700",
            decoded: .tuple(Tuple {
                U8(12)
                U8(0)
            }
            )
        ),
        (
            encoded: "320707010000000c00",
            decoded: .map(
                try! Map(
                    keyType: .u8,
                    valueType: .u8
                ) {
                    U8(12)
                    U8(0)
                }
            )
        ),
    ]
}
