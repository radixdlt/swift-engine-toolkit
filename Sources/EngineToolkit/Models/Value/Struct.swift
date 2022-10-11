import Foundation

public struct Struct: ValueProtocol, Sendable, Codable, Hashable, ExpressibleByRadixEngineValues {
    // Type name, used as a discriminator
    public static let kind: ValueKind = .struct
    public func embedValue() -> Value {
        .struct(self)
    }
    
    // MARK: Stored properties
    public let fields: [Value]
    
    // MARK: Init
    
    public init(fields: [Value]) {
        self.fields = fields
    }

}

public extension Struct {
    init(values fields: [Value]) {
        self.init(fields: fields)
    }
}

public extension Struct {
    
    // MARK: CodingKeys
    private enum CodingKeys: String, CodingKey {
        case fields, type
    }
    
    // MARK: Codable
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
        
        try self.init(fields: container.decode([Value].self, forKey: .fields))
    }
}
