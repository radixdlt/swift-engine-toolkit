import Foundation

public struct EcdsaSecp256k1Signature: ValueProtocol, Sendable, Codable, Hashable {
    // Type name, used as a discriminator
    public static let kind: ValueKind = .ecdsaSecp256k1Signature
    public func embedValue() -> Value {
        .ecdsaSecp256k1Signature(self)
    }
    
    // MARK: Stored properties
    public let bytes: [UInt8]
    
    // MARK: Init
    
    public init(bytes: [UInt8]) {
        self.bytes = bytes
    }
    
    public init(signatureHex: String) throws {
        try self.init(bytes: [UInt8](hex: signatureHex))
    }

}

public extension EcdsaSecp256k1Signature {
    
    // MARK: CodingKeys
    private enum CodingKeys: String, CodingKey {
        case signature, type
    }
    
    // MARK: Codable
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Self.kind, forKey: .type)
        
        try container.encode(bytes.toHexString(), forKey: .signature)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let kind: ValueKind = try container.decode(ValueKind.self, forKey: .type)
        if kind != Self.kind {
            throw InternalDecodingFailure.valueTypeDiscriminatorMismatch(expected: Self.kind, butGot: kind)
        }
        
        // Decoding `signature`
        try self.init(signatureHex: container.decode(String.self, forKey: .signature))
    }
}