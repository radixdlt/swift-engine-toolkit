import Foundation

public struct Tuple: Sendable, Codable, Hashable {
    // Type name, used as a discriminator
    public static let kind: ValueKind = .tuple
    
    // ===============
    // Struct members
    // ===============
    
    public let elements: [Value]
    
    // =============
    // Constructors
    // =============
    
    public init(from elements: [Value]) {
        self.elements = elements
    }
}

public extension Tuple {
    
 
    
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys: String, CodingKey {
        case elements, type
    }
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Self.kind, forKey: .type)
        
        try container.encode(elements, forKey: .elements)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let kind: ValueKind = try container.decode(ValueKind.self, forKey: .type)
        if kind != Self.kind {
            throw DecodeError.valueTypeDiscriminatorMismatch(Self.kind, kind)
        }
    
        // Decoding `elements`
        // TODO: Validate that all elements are of type `elementType`
        elements = try container.decode([Value].self, forKey: .elements)
    }
}
