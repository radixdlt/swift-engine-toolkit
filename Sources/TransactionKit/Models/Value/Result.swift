import Foundation

public enum Result: Sendable, Codable, Hashable {
    // Type name, used as a discriminator
    public static let kind: ValueKind = ValueKind.Result
    
    // ==============
    // Enum Variants
    // ==============
    
    case Ok(Value)
    case Err(Value)
 
}

public extension Result {
    
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
            case .Ok(let value):
                try container.encode("Ok", forKey: .variant)
                try container.encode(value, forKey: .field)
            case .Err(let value):
                try container.encode("Error", forKey: .variant)
                try container.encode(value, forKey: .field)
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
        let value: Value = try values.decode(Value.self, forKey: .field)
        switch variant {
        case "Ok":
            self = Self.Ok(value)
        case "Err":
            self = Self.Err(value)
        default:
            // TODO: Need a nicer error here.
            throw DecodeError.ParsingError
        }
    }
}
