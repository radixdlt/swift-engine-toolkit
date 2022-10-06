import Foundation

public enum Result: Sendable, Codable, Hashable {
    // Type name, used as a discriminator
    public static let kind: ValueKind = .result
    
    // ==============
    // Enum Variants
    // ==============
    
    case ok(Value)
    case err(Value)
 
}

public extension Result {
    
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys: String, CodingKey {
        case variant
        case type
        case field
    }
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Self.kind, forKey: .type)
        
        // Encode depending on whether this is a Some or None
        switch self {
            case .ok(let value):
                try container.encode("Ok", forKey: .variant)
                try container.encode(value, forKey: .field)
            case .err(let value):
                try container.encode("Error", forKey: .variant)
                try container.encode(value, forKey: .field)
        }
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let kind: ValueKind = try container.decode(ValueKind.self, forKey: .type)
        if kind != Self.kind {
            throw DecodeError.valueTypeDiscriminatorMismatch(expected: Self.kind, butGot: kind)
        }
        
        let variant: String = try container.decode(String.self, forKey: .variant)
        let value: Value = try container.decode(Value.self, forKey: .field)
        switch variant {
        case "Ok":
            self = .ok(value)
        case "Err":
            self = .err(value)
        default:
            // TODO: Need a nicer error here.
            throw DecodeError.parsingError
        }
    }
}
