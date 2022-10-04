import Foundation

public enum Identifier: Sendable, Codable, Hashable {
    // ==============
    // Enum Variants
    // ==============
    
    case string(String)
    case u32(UInt32)

}

public extension Identifier {
    
    // ======================
    // Encoding and Decoding
    // ======================
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
