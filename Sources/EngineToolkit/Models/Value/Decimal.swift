import Foundation

public struct Decimal_: ValueProtocol, Sendable, Codable, Hashable, ExpressibleByFloatLiteral, ExpressibleByIntegerLiteral {
    // Type name, used as a discriminator
    public static let kind: ValueKind = .decimal
    public func embedValue() -> Value {
        .decimal(self)
    }
    
    // ===============
    // Struct members
    // ===============
    
    // TODO: Convert this to a better numerical type
    public let value: Foundation.Decimal
    
    // =============
    // Constructors
    // =============
    
    public init(value: Foundation.Decimal) {
        self.value = value
    }
    
    public init(string: String) throws {
        try self.init(value: Decimal(string, format: .number, lenient: false))
    }
    
    public typealias FloatLiteralType = Double
    public init(floatLiteral: FloatLiteralType) {
        self.init(value: Foundation.Decimal(floatLiteral: floatLiteral))
    }
    
    public init(integerLiteral: Decimal.IntegerLiteralType) {
        self.init(value: Foundation.Decimal(integerLiteral: integerLiteral))
    }
}

public extension Decimal_ {
    
    private var string: String {
        // FIXME: investigate which `Locale` is being used here.. might need to use `NumberFormatter`, i.e.
        // does `"\(value)"` use "," or "." for decimals, and what does Scrypto expect?
        "\(value)"
    }
    
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys: String, CodingKey {
        case value, type
    }
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Self.kind, forKey: .type)
        
        try container.encode(string, forKey: .value)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let kind: ValueKind = try container.decode(ValueKind.self, forKey: .type)
        if kind != Self.kind {
            throw InternalDecodingFailure.valueTypeDiscriminatorMismatch(expected: Self.kind, butGot: kind)
        }
        
        // Decoding `value`
        let string = try container.decode(String.self, forKey: .value)
        try self.init(string: string)
    }
}
