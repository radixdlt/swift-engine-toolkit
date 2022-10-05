public struct EncodeAddressRequest: Sendable, Codable, Hashable {
    // ===============
    // Struct members
    // ===============
    public let address: Array<UInt8>
    public let networkId: UInt8
    
    // =============
    // Constructors
    // =============
    
    public init(from address: Array<UInt8>, networkId: UInt8) {
        self.address = address
        self.networkId = networkId
    }
    
    public init(from addressHex: String, networkId: UInt8) {
        self.address = Array<UInt8>(hex: addressHex)
        self.networkId = networkId
    }
}

public extension EncodeAddressRequest {
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys: String, CodingKey {
        case address = "address"
        case networkId = "network_id"
    }
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(address.toHexString(), forKey: .address)
        try container.encode(networkId, forKey: .networkId)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self = Self(from: try container.decode(String.self, forKey: .address), networkId: try container.decode(UInt8.self, forKey: .networkId))
        
    }
}

public typealias EncodeAddressResponse = Address
