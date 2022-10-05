import Foundation

public struct NonFungibleId: Codable, Hashable, Sendable {
    // Type name, used as a discriminator
    public static let kind: ValueKind = .nonFungibleId
    
    // ===============
    // Struct members
    // ===============
    
    public let value: [UInt8]
    
    // =============
    // Constructors
    // =============
    
    public init(from value: [UInt8]) {
        self.value = value
    }
    
    public init(from value: String) throws {
        self.value = [UInt8](hex: value)
    }

}

public extension NonFungibleId {
    
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys: String, CodingKey {
        case value, type
    }
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Self.kind, forKey: .type)
        
        try container.encode(value.toHexString(), forKey: .value)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let kind: ValueKind = try container.decode(ValueKind.self, forKey: .type)
        if kind != Self.kind {
            throw DecodeError.valueTypeDiscriminatorMismatch(Self.kind, kind)
        }
        
        // Decoding `value`
        self = try Self(from: try container.decode(String.self, forKey: .value))
    }
}
