import Foundation

public struct Hash: Sendable, Codable, Hashable {
    // Type name, used as a discriminator
    public static let kind: ValueKind = ValueKind.Hash
    
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
        // TODO: Validation of length of Hash
        self.value = Array<UInt8>(hex: value)
    }

}

public extension Hash {
    
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
            throw DecodeError.ValueTypeDiscriminatorMismatch(Self.kind, kind)
        }
        
        // Decoding `value`
        self = try Self(from: try values.decode(String.self, forKey: .value))
    }
}
