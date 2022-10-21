import Foundation

public enum Identifier: Sendable, Codable, Hashable, ExpressibleByIntegerLiteral, ExpressibleByStringLiteral {
    // ==============
    // Enum Variants
    // ==============
    case string(String)
    case u32(UInt32)
    public init(stringLiteral value: String) {
        self = .string(value)
    }
    public init(integerLiteral value: UInt32) {
        self = .u32(value)
    }
}

public extension Identifier {
    
    // MARK: Codable
    func encode(to encoder: Encoder) throws {
        var container: SingleValueEncodingContainer = encoder.singleValueContainer()
        
        switch self {
        case .string(let string):
            try container.encode(string)
        case .u32(let id):
            try container.encode(id)
        }
    }
    
    init(from decoder: Decoder) throws {
        let value: SingleValueDecodingContainer = try decoder.singleValueContainer()
        do {
            let id: UInt32 = try value.decode(UInt32.self)
            self = .u32(id)
        } catch {
            let string: String = try value.decode(String.self)
            self = .string(string)
        }
    }
}