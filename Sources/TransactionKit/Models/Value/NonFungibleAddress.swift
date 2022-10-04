import Foundation

public struct NonFungibleAddress: Sendable, Codable, Hashable {
    // Type name, used as a discriminator
    public static let kind: ValueKind = .nonFungibleAddress
    
    // ===============
    // Struct members
    // ===============
    
    public let address: Array<UInt8>
    
    // =============
    // Constructors
    // =============
    
    init(from address: Array<UInt8>) {
        self.address = address
    }
    
    init(from address: String) throws {
        self.address = Array<UInt8>(hex: address)
    }

}

public extension NonFungibleAddress {
    
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys : String, CodingKey {
        case address, type
    }
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Self.kind, forKey: .type)
        
        try container.encode(address.toHexString(), forKey: .address)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let values: KeyedDecodingContainer = try decoder.container(keyedBy: CodingKeys.self)
        let kind: ValueKind = try values.decode(ValueKind.self, forKey: .type)
        if kind != Self.kind {
            throw DecodeError.valueTypeDiscriminatorMismatch(Self.kind, kind)
        }
        
        // Decoding `address`
        self = try Self(from: try values.decode(String.self, forKey: .address))
    }
}
