import Foundation

// TODO: Replace with `Swift.Optional`? As we did with `Result_` -> `Swift.Result` ( https://github.com/radixdlt/swift-engine-toolkit/pull/6/commits/decc7ebd325eb72fd8f376d1001f7ded7f2dd202 )
public enum Option: ValueProtocol, ExpressibleByNilLiteral {
    // Type name, used as a discriminator
    public static let kind: ValueKind = .option
    public func embedValue() -> Value {
        .option(self)
    }
    
    // ==============
    // Enum Variants
    // ==============
    
    case some(Value)
    case none
}
public extension Option {
    static func some(_ value: any ValueProtocol) -> Self {
        .some(value.embedValue())
    }

    init(@ValuesBuilder buildSome: () throws -> any ValueProtocol) rethrows {
        self = Self.some(try buildSome())
    }
    
    init(@SpecificValuesBuilder buildSome: () throws -> Value) rethrows {
        self = Self.some(try buildSome())
    }
    init(nilLiteral: ()) {
        self = .none
    }
}

public extension Option {
    
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys: String, CodingKey {
        case variant
        case type
        case field
    }
    
    private enum Discriminator: String, Codable {
        case some = "Some"
        case none = "None"
    }
    private var discriminator: Discriminator {
        switch self {
        case .none: return .none
        case .some: return .some
        }
    }
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Self.kind, forKey: .type)
        try container.encode(discriminator, forKey: .variant)
        
        // Encode depending on whether this is a Some or None
        switch self {
            case .some(let value):
                try container.encode(value, forKey: .field)
            case .none: break
        }
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let kind: ValueKind = try container.decode(ValueKind.self, forKey: .type)
        if kind != Self.kind {
            throw InternalDecodingFailure.valueTypeDiscriminatorMismatch(expected: Self.kind, butGot: kind)
        }
        
        let discriminator = try container.decode(Discriminator.self, forKey: .variant)
        switch discriminator {
        case .some:
            let value: Value = try container.decode(Value.self, forKey: .field)
            self = .some(value)
        case .none:
            self = .none
        }
    }
}
