import Foundation

public enum Identifier: Sendable, Codable, Hashable {
    // ==============
    // Enum Variants
    // ==============
    
    case String_(String)
    case U32(UInt32)

}

public extension Identifier {
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        var container: SingleValueEncodingContainer = encoder.singleValueContainer()
        
        switch self {
        case .String_(let string):
            try container.encode(string)
        case .U32(let id):
            try container.encode(id)
        }
    }
    
    init(from decoder: Decoder) throws {
        let value: SingleValueDecodingContainer = try decoder.singleValueContainer()
        do {
            let id: UInt32 = try value.decode(UInt32.self)
            self = Self.U32(id)
        } catch {
            let string: String = try value.decode(String.self)
            self = Self.String_(string)
        }
    }
}
