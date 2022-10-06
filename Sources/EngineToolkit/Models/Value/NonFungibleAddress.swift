import Foundation

public struct NonFungibleAddress: Sendable, Codable, Hashable {
    // Type name, used as a discriminator
    public static let kind: ValueKind = .nonFungibleAddress
    
    // ===============
    // Struct members
    // ===============
    
    public let address: [UInt8]
    
    // =============
    // Constructors
    // =============
    
    public init(from address: [UInt8]) {
        self.address = address
    }
    
    public init(from address: String) throws {
        self.address = [UInt8](hex: address)
    }

}

public extension NonFungibleAddress {
    
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys: String, CodingKey {
        case address, type
    }
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Self.kind, forKey: .type)
        
        try container.encode(address.toHexString(), forKey: .address)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let kind: ValueKind = try container.decode(ValueKind.self, forKey: .type)
        if kind != Self.kind {
            throw DecodeError.valueTypeDiscriminatorMismatch(expected: Self.kind, butGot: kind)
        }
        
        // Decoding `address`
        self = try Self(from: try container.decode(String.self, forKey: .address))
    }
}
