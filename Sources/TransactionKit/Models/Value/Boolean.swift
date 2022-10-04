import Foundation

public struct Boolean: Sendable, Codable, Hashable {
    // Type name, used as a discriminator
    public static let kind: ValueKind = .bool
    
    // ===============
    // Struct members
    // ===============
    public let value: Bool
    
    // =============
    // Constructors
    // =============
    
    public init(from value: Bool) {
        self.value = value
    }
}

public extension Boolean {
    
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
        value = try values.decode(Bool.self, forKey: .value)
    }
}
