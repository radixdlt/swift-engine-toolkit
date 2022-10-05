import Foundation

public struct Struct: Sendable, Codable, Hashable {
    // Type name, used as a discriminator
    public static let kind: ValueKind = .struct
    
    // ===============
    // Struct members
    // ===============
    
    public let fields: [Value]
    
    // =============
    // Constructors
    // =============
    
    public init(from fields: [Value]) {
        self.fields = fields
    }

}

public extension Struct {
    
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys: String, CodingKey {
        case fields, type
    }
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Self.kind, forKey: .type)
        
        try container.encode(fields, forKey: .fields)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let kind: ValueKind = try container.decode(ValueKind.self, forKey: .type)
        if kind != Self.kind {
            throw InternalDecodingFailure.valueTypeDiscriminatorMismatch(expected: Self.kind, butGot: kind)
        }
        
        // Decoding `fields`
        fields = try container.decode([Value].self, forKey: .fields)
    }
}
