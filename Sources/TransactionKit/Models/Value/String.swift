import Foundation

// TODO: The underscore is added here to avoid name collisions. Something better is needed.
public struct String_: Sendable, Codable, Hashable {
    // Type name, used as a discriminator
    public static let kind: ValueKind = .string
    
    // ===============
    // Struct members
    // ===============
    
    public let value: String
    
    // =============
    // Constructors
    // =============
    
    public init(from value: String) {
        self.value = value
    }
}

public extension String_ {
    
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
        var container: KeyedEncodingContainer = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Self.kind, forKey: .type)
        
        try container.encode(value, forKey: .value)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let values: KeyedDecodingContainer = try decoder.container(keyedBy: CodingKeys.self)
        let kind: ValueKind = try values.decode(ValueKind.self, forKey: .type)
        if kind != Self.kind {
            throw DecodeError.valueTypeDiscriminatorMismatch(Self.kind, kind)
        }
        
        // Decoding `value`
        value = try values.decode(String.self, forKey: .value)
    }
}
