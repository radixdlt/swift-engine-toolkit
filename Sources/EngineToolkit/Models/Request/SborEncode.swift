public typealias SborEncodeRequest = Value

public struct SborEncodeResponse: Sendable, Codable, Hashable {
    // ===============
    // Struct members
    // ===============
    public let encodedValue: [UInt8]
    
    // =============
    // Constructors
    // =============
    
    public init(bytes: [UInt8]) {
        self.encodedValue = bytes
    }
    
    public init(hex: String) throws {
        try self.init(bytes: [UInt8](hex: hex))
    }

}

public extension SborEncodeResponse {
    
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys: String, CodingKey {
        case encodedValue = "encoded_value"
    }
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(encodedValue.toHexString(), forKey: .encodedValue)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        try self.init(hex: container.decode(String.self, forKey: .encodedValue))
        
    }
}
