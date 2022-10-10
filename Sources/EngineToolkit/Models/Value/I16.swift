import Foundation

extension Int16: ValueProtocol, ProxyCodable {
    // Type name, used as a discriminator
    public static let kind: ValueKind = .i16
    public func embedValue() -> Value {
        .i16(self)
    }

    public typealias ProxyEncodable = ProxyEncodableInt<Self>
    public typealias ProxyDecodable = ProxyDecodableInt<Self>
}

// =======================
// Coding Keys Definition
// =======================
private enum ProxyCodableIntCodingKeys: String, CodingKey {
    case value, type
}

public struct ProxyEncodableInt<I: FixedWidthInteger & Codable & ValueProtocol>: EncodableProxy {
    public typealias ToEncode = I
    public let toEncode: ToEncode
    public init(toEncode: ToEncode) {
        self.toEncode = toEncode
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: ProxyCodableIntCodingKeys.self)
        try container.encode(ToEncode.kind, forKey: .type)
        try container.encode(String(toEncode), forKey: .value)
    }
}

public struct ProxyDecodableInt<I: FixedWidthInteger & Codable & ValueProtocol>: DecodableProxy {
    public typealias Decoded = I
    public let decoded: Decoded
    public init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let container = try decoder.container(keyedBy: ProxyCodableIntCodingKeys.self)
        let kind: ValueKind = try container.decode(ValueKind.self, forKey: .type)
        if kind != Decoded.kind {
            throw InternalDecodingFailure.valueTypeDiscriminatorMismatch(expected: Decoded.kind, butGot: kind)
        }
        
        // Decoding `value`
        let valueString: String = try container.decode(String.self, forKey: .value)
        if let value = I(valueString) {
            self.decoded = value
        } else {
            throw InternalDecodingFailure.parsingError
        }
    }
}
