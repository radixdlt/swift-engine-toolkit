import Foundation

// TODO: Replace with `Swift.Set`? As we did with `Result_` -> `Swift.Result` ( https://github.com/radixdlt/swift-engine-toolkit/pull/6/commits/decc7ebd325eb72fd8f376d1001f7ded7f2dd202 )
public struct Set_: ValueProtocol, Sendable, Codable, Hashable {
    // Type name, used as a discriminator
    public static let kind: ValueKind = .set
    public func embedValue() -> Value {
        .set(self)
    }
    
    // ===============
    // Struct members
    // ===============
    
    public let elementType: ValueKind
    public let elements: [Value]
    
    // =============
    // Constructors
    // =============
    public init(
        elementType: ValueKind,
        elements: [Value]
    ) throws {
        guard elements.allSatisfy({ $0.kind == elementType }) else {
            throw Error.homogeneousArrayRequired
        }
        self.elementType = elementType
        self.elements = elements
    }
    
    public init(
        elementType: ValueKind,
        @ValuesBuilder buildValues: () throws -> [ValueProtocol]
    ) throws {
        try self.init(
            elementType: elementType,
            elements: buildValues().map { $0.embedValue() }
        )
    }

    public init(
        elementType: ValueKind,
        @SpecificValuesBuilder buildValues: () throws -> [Value]
    ) throws {
        try self.init(
            elementType: elementType,
            elements: buildValues()
        )
    }

}



public extension Set_ {
    enum Error: String, Swift.Error, Sendable, Hashable {
        case homogeneousArrayRequired
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
            throw InternalDecodingFailure.valueTypeDiscriminatorMismatch(expected: Self.kind, butGot: kind)
        }
        
        try self.init(
            elementType: container.decode(ValueKind.self, forKey: .elementType),
            elements:  container.decode([Value].self, forKey: .elements)
        )
    }
}
