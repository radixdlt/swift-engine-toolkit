import Foundation

public enum Option: Sendable, Codable, Hashable {
    // Type name, used as a discriminator
    public static let kind: ValueKind = .option
    
    // ==============
    // Enum Variants
    // ==============
    
    case some(Value)
    case none
}

public extension Option {
    
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys : String, CodingKey {
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
        var container: KeyedEncodingContainer = encoder.container(keyedBy: CodingKeys.self)
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
        let values: KeyedDecodingContainer = try decoder.container(keyedBy: CodingKeys.self)
        let kind: ValueKind = try values.decode(ValueKind.self, forKey: .type)
        if kind != Self.kind {
            throw DecodeError.valueTypeDiscriminatorMismatch(Self.kind, kind)
        }
        
        let discriminator = try values.decode(Discriminator.self, forKey: .variant)
        switch discriminator {
        case .some:
            let value: Value = try values.decode(Value.self, forKey: .field)
            self = .some(value)
        case .none:
            self = .none
        }
    }
}
