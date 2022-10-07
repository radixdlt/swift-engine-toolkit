public struct EncodeAddressRequest: Sendable, Codable, Hashable {
    // ===============
    // Struct members
    // ===============
    public let address: [UInt8]
    public let networkId: NetworkID
    
    // =============
    // Constructors
    // =============
    
	public init(address: [UInt8], networkId: NetworkID = .mainnet) {
        self.address = address
        self.networkId = networkId
    }
    
	public init(addressHex: String, networkId: NetworkID = .mainnet) throws {
        self.address = try [UInt8](hex: addressHex)
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
        
		try self.init(
			addressHex: container.decode(String.self, forKey: .address),
			networkId: container.decode(NetworkID.self, forKey: .networkId)
		)
        
    }
}

public typealias EncodeAddressResponse = Address
