import Foundation

public enum Result_: Sendable, Codable, Hashable {
    // Type name, used as a discriminator
    public static let kind: ValueKind = .result
    
    // ==============
    // Enum Variants
    // ==============
    
    case ok(Value)
    case error(Value)
 
}

public extension Result_ {
    
    private enum Variant: String, Codable, Equatable {
        case ok = "Ok"
        case error = "Error"
    }
    private var variant: Variant {
        switch self {
        case .error: return .error
        case .ok: return .ok
        }
    }
    
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
        try container.encode(variant, forKey: .variant)
        
        // Encode depending on whether this is a Some or None
        switch self {
            case .ok(let value):
                try container.encode(value, forKey: .field)
            case .error(let value):
                try container.encode(value, forKey: .field)
        }
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let kind = try container.decode(ValueKind.self, forKey: .type)
        if kind != Self.kind {
            throw InternalDecodingFailure.valueTypeDiscriminatorMismatch(expected: Self.kind, butGot: kind)
        }
        
        let variant = try container.decode(Variant.self, forKey: .variant)
        let value = try container.decode(Value.self, forKey: .field)
        switch variant {
        case .ok:
            self = .ok(value)
        case .error:
            self = .error(value)
        }
    }
}
