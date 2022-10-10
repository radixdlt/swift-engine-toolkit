import Foundation

public struct NonFungibleAddress: ValueProtocol {
    // Type name, used as a discriminator
    public static let kind: ValueKind = .nonFungibleAddress
    public func embedValue() -> Value {
        .nonFungibleAddress(self)
    }
    
    // ===============
    // Struct members
    // ===============
    
    public let address: [UInt8]
    
    // =============
    // Constructors
    // =============
    
    public init(bytes: [UInt8]) {
        self.address = bytes
    }
    
    public init(hex: String) throws {
        try self.init(bytes:  [UInt8](hex: hex))
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
            throw InternalDecodingFailure.valueTypeDiscriminatorMismatch(expected: Self.kind, butGot: kind)
        }
        
        // Decoding `address`
        try self.init(hex: container.decode(String.self, forKey: .address))
    }
}
