import Foundation

// TODO: The underscore is added here to avoid name collisions. Something better is needed.
public struct Set_: Sendable, Codable, Hashable {
    // Type name, used as a discriminator
    public static let kind: ValueKind = .set
    
    // ===============
    // Struct members
    // ===============
    
    public let elementType: ValueKind
    public let elements: Array<Value>
    
    // =============
    // Constructors
    // =============
    
    public init(from elementType: ValueKind, elements: Array<Value>) {
        // TODO: Validate that all elements are of type `elementType`
        self.elementType = elementType
        self.elements = elements
    }

}

public extension Set_ {
    
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
        var container: KeyedEncodingContainer = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Self.kind, forKey: .type)
        
        try container.encode(elements, forKey: .elements)
        try container.encode(elementType, forKey: .elementType)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let values: KeyedDecodingContainer = try decoder.container(keyedBy: CodingKeys.self)
        let kind: ValueKind = try values.decode(ValueKind.self, forKey: .type)
        if kind != Self.kind {
            throw DecodeError.valueTypeDiscriminatorMismatch(Self.kind, kind)
        }
        
        // Decoding `elementType`
        elementType = try values.decode(ValueKind.self, forKey: .elementType)
        
        // Decoding `elements`
        // TODO: Validate that all elements are of type `elementType`
        elements = try values.decode(Array<Value>.self, forKey: .elements)
    }
}
