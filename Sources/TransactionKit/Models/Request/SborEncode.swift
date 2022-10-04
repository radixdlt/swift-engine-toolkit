public typealias SborEncodeRequest = Value

public struct SborEncodeResponse: Sendable, Codable, Hashable {
    // ===============
    // Struct members
    // ===============
    public let encodedValue: Array<UInt8>
    
    // =============
    // Constructors
    // =============
    
    public init(from encodedValue: Array<UInt8>) {
        self.encodedValue = encodedValue
    }
    
    public init(from encodedValue: String) {
        self.encodedValue = Array<UInt8>(hex: encodedValue)
    }

}

public extension SborEncodeResponse {
    
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys : String, CodingKey {
        case encodedValue = "encoded_value"
    }
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(encodedValue.toHexString(), forKey: .encodedValue)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let values: KeyedDecodingContainer = try decoder.container(keyedBy: CodingKeys.self)
        
        self = Self(from: try values.decode(String.self, forKey: .encodedValue))
        
    }
}
