import Foundation

public struct Bucket: ValueProtocol, Sendable, Codable, Hashable, IdentifierConvertible {
    // Type name, used as a discriminator
    public static let kind: ValueKind = .bucket
    public func embedValue() -> Value {
        .bucket(self)
    }
    
    // MARK: Stored properties
    public let identifier: Identifier
    
    // MARK: Init
    
    public init(identifier: Identifier) {
        self.identifier = identifier
    }
}

public extension Bucket {
    
    // MARK: CodingKeys
    private enum CodingKeys: String, CodingKey {
        case identifier, type
    }
    
    // MARK: Codable
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Self.kind, forKey: .type)
        
        try container.encode(identifier, forKey: .identifier)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let kind: ValueKind = try container.decode(ValueKind.self, forKey: .type)
        if kind != Self.kind {
            throw InternalDecodingFailure.valueTypeDiscriminatorMismatch(expected: Self.kind, butGot: kind)
        }
        
        // Decoding `identifier`
        try self.init(identifier: container.decode(Identifier.self, forKey: .identifier))
    }
}
