import Foundation

// TODO: The underscore is added here to avoid name collisions. Something better is needed.
public struct Array_: Sendable, Codable, Hashable {
    // Type name, used as a discriminator
    public static let kind: ValueKind = .array
    
    // ===============
    // Struct members
    // ===============
    
    public let elementType: ValueKind
    public let elements: [Value]
    
    // =============
    // Constructors
    // =============
    
    public init(from elementType: ValueKind, elements: [Value]) {
        // TODO: Validate that all elements are of type `elementType`
        self.elementType = elementType
        self.elements = elements
    }
}

public extension Array_ {
    
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys: String, CodingKey {
        case elements, elementType = "element_type", type
    }
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Self.kind, forKey: .type)
        
        try container.encode(elements, forKey: .elements)
        try container.encode(elementType, forKey: .elementType)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let kind: ValueKind = try container.decode(ValueKind.self, forKey: .type)
        if kind != Self.kind {
            throw DecodeError.valueTypeDiscriminatorMismatch(Self.kind, kind)
        }
        
        // Decoding `elementType`
        elementType = try container.decode(ValueKind.self, forKey: .elementType)
        
        // Decoding `elements`
        // TODO: Validate that all elements are of type `elementType`
        elements = try container.decode([Value].self, forKey: .elements)
    }
}
