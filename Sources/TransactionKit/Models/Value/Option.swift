import Foundation

public enum Option: Sendable, Codable, Hashable {
    // Type name, used as a discriminator
    public static let kind: ValueKind = ValueKind.Option;
    
    // ==============
    // Enum Variants
    // ==============
    
    case Some(Value)
    case None
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
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Self.kind, forKey: .type)
        
        // Encode depending on whether this is a Some or None
        switch self {
            case .Some(let value):
                try container.encode("Some", forKey: .variant)
                try container.encode(value, forKey: .field)
            case .None:
                try container.encode("None", forKey: .variant)
        }
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let values: KeyedDecodingContainer = try decoder.container(keyedBy: CodingKeys.self)
        let kind: ValueKind = try values.decode(ValueKind.self, forKey: .type)
        if kind != Self.kind {
            throw DecodeError.ValueTypeDiscriminatorMismatch(Self.kind, kind)
        }
        
        let variant: String = try values.decode(String.self, forKey: .variant)
        switch variant {
        case "Some":
            let value: Value = try values.decode(Value.self, forKey: .field)
            self = Self.Some(value)
        case "None":
            self = Self.None
        default:
            // TODO: Need a nicer error here.
            throw DecodeError.ParsingError
        }
    }
}
