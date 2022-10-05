public struct SborDecodeRequest: Sendable, Codable, Hashable {
    // ===============
    // Struct members
    // ===============
    public let encodedValue: [UInt8]
    public let networkId: UInt8
    
    // =============
    // Constructors
    // =============
    
    public init(from encodedValue: [UInt8], networkId: UInt8) {
        self.encodedValue = encodedValue
        self.networkId = networkId
    }
    
    public init(from encodedValue: String, networkId: UInt8) {
        self.encodedValue = [UInt8](hex: encodedValue)
        self.networkId = networkId
    }
}

public extension SborDecodeRequest {
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys: String, CodingKey {
        case encodedValue = "encoded_value"
        case networkId = "network_id"
    }
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(encodedValue.toHexString(), forKey: .encodedValue)
        try container.encode(networkId, forKey: .networkId)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self = Self(from: try container.decode(String.self, forKey: .encodedValue), networkId: try container.decode(UInt8.self, forKey: .networkId))
        
    }
}

public typealias SborDecodeResponse = Value
