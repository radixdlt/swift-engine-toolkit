import XCTest
@testable import TransactionKit

enum AddressDecodeEncodeTestVectors {
    private static let encoded: [String] = [
//        "package_sim1qyqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqsnznk7n",
//        "package_sim1qyqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqpsuluv44",
//        "package_sim1qy7rfwzgm99jp4lwngv8utfnzxd7zv2fq9p279rzzmws555ujt",
//        "package_sim1q8jy0frw4en9cdc63cyj2n7pdefj95lftvrdamjhhyqqlgshez",
//        "system_sim1qsqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqs9fh54n",
        "account_sim1qv0z2nsg5aqayjeszxa9uc6p82nalts0cm2sdna69g7sm3626z",
        "resource_sim1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqshxgp7h",
        "resource_sim1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqpqd60rqz",
        "resource_sim1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqzqu57yag",
        "resource_sim1qqe4m2jlrz5y82syz3y76yf9ztd4trj7fmlq4vf4gmzsf6wgzy",
    ]
    
    private static let decoded: [String] = [
        "01000000000000000000000000000000000000000000000000000100",
        "01000000000000000000000000000000000000000000000000000300",
        "013c34b848d94b20d7ee9a187e2d33119be131490142af146216dd00",
        "01e447a46eae665c371a8e09254fc16e5322d3e95b06deee57b90000",
        "04000000000000000000000000000000000000000000000000000100",
        "031e254e08a741d24b3011ba5e63413aa7dfae0fc6d506cfba2a3d00",
        "00000000000000000000000000000000000000000000000000000100",
        "00000000000000000000000000000000000000000000000000000200",
        "00000000000000000000000000000000000000000000000000000400",
        "00335daa5f18a843aa041449ed112512db558e5e4efe0ab13546c500",
    ]
    typealias Vector = (encoded: String, decoded: String)
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

final class EncodeDecodeAddressRequestTests: XCTestCase {
    
    private let sut = TX()
    
    func test__encodeDecodeAddressRequest() throws {
        try TestSuite.vectors.forEach { try doTest(vector: $0) }
    }
}

private extension EncodeDecodeAddressRequestTests {
    func doTest(
        vector: AddressDecodeEncodeTestVectors.Vector,
        networkID: NetworkID = .simulator,
        line: UInt = #line
    ) throws {
        print(vector)
        let encodeRequest = EncodeAddressRequest(
            addressHex: vector.decoded,
            networkId: networkID
        )
        let encoded = try sut.encodeAddressRequest(request: encodeRequest)
        let decodeRequest = DecodeAddressRequest(address: vector.encoded)
        let decoded = try sut.decodeAddressRequest(request: decodeRequest)
        
        XCTAssertEqual(decoded.address.address, vector.decoded, line: line)
    }
    typealias TestSuite = AddressDecodeEncodeTestVectors
}
