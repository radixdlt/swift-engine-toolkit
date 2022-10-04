import Foundation

public struct Enum: Sendable, Codable, Hashable {
    // Type name, used as a discriminator
    public static let kind: ValueKind = .enum
    
    // ===============
    // Struct members
    // ===============
    
    public let variant: String
    public let fields: Array<Value>
    
    // =============
    // Constructors
    // =============
    
    init(from variant: String, fields: Array<Value>) {
        self.variant = variant
        self.fields = fields
    }
}

public extension Enum {
    
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys : String, CodingKey {
        case variant
        case type
        case fields
    }
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Self.kind, forKey: .type)
        
        try container.encode(variant, forKey: .variant)
        try container.encode(fields, forKey: .fields)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let values: KeyedDecodingContainer = try decoder.container(keyedBy: CodingKeys.self)
        let kind: ValueKind = try values.decode(ValueKind.self, forKey: .type)
        if kind != Self.kind {
            throw DecodeError.valueTypeDiscriminatorMismatch(Self.kind, kind)
        }
        
        // Decoding `variant`
        variant = try values.decode(String.self, forKey: .variant)
        // Decoding `fields`
        fields = try values.decode(Array<Value>.self, forKey: .fields)
    }
}
