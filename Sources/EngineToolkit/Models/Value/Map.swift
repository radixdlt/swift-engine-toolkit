import Foundation

public struct Map: Sendable, Codable, Hashable {
    // Type name, used as a discriminator
    public static let kind: ValueKind = .map
    
    // ===============
    // Struct members
    // ===============
    
    public let keyType: ValueKind
    public let valueType: ValueKind
    public let elements: [Value]
    
    // =============
    // Constructors
    // =============
    
    public init(from keyType: ValueKind, valueType: ValueKind, elements: [Value]) {
        // TODO: Validate keys and values types
        self.keyType = keyType
        self.valueType = valueType
        self.elements = elements
    }
}

public extension Map {
    
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys: String, CodingKey {
        case elements, keyType = "key_type", valueType = "value_type", type
    }
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Self.kind, forKey: .type)
        
        try container.encode(elements, forKey: .elements)
        try container.encode(keyType, forKey: .keyType)
        try container.encode(valueType, forKey: .valueType)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let kind: ValueKind = try container.decode(ValueKind.self, forKey: .type)
        if kind != Self.kind {
            throw InternalDecodingFailure.valueTypeDiscriminatorMismatch(expected: Self.kind, butGot: kind)
        }
        
        // Decoding `keyType` & `valueType`
        keyType = try container.decode(ValueKind.self, forKey: .keyType)
        valueType = try container.decode(ValueKind.self, forKey: .valueType)
        
        // Decoding `elements`
        // TODO: Validate that all elements are of type `elementType`
        elements = try container.decode([Value].self, forKey: .elements)
    }
}
