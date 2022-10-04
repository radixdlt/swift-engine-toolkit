import Foundation

public struct NonFungibleId: Codable, Hashable, Sendable {
    // Type name, used as a discriminator
    public static let kind: ValueKind = .nonFungibleId
    
    // ===============
    // Struct members
    // ===============
    
    public let value: Array<UInt8>
    
    // =============
    // Constructors
    // =============
    
    init(from value: Array<UInt8>) {
        self.value = value
    }
    
    init(from value: String) throws {
        self.value = Array<UInt8>(hex: value)
    }

}

public extension NonFungibleId {
    
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys : String, CodingKey {
        case value, type
    }
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Self.kind, forKey: .type)
        
        try container.encode(value.toHexString(), forKey: .value)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let values: KeyedDecodingContainer = try decoder.container(keyedBy: CodingKeys.self)
        let kind: ValueKind = try values.decode(ValueKind.self, forKey: .type)
        if kind != Self.kind {
            throw DecodeError.valueTypeDiscriminatorMismatch(Self.kind, kind)
        }
        
        // Decoding `value`
        self = try Self(from: try values.decode(String.self, forKey: .value))
    }
}
