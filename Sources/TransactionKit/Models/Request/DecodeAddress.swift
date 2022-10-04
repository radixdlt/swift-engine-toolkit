public struct DecodeAddressRequest: Sendable, Codable, Hashable {
    // ===============
    // Struct members
    // ===============
    public let address: String
    
    // =============
    // Constructors
    // =============
    
    init(from address: String) {
        self.address = address
    }
}

public struct DecodeAddressResponse: Sendable, Codable, Hashable {
    // ===============
    // Struct members
    // ===============
    public let networkId: UInt8
    public let networkName: String
    public let entityType: AddressKind
    public let data: Array<UInt8>
    public let hrp: String
    public let address: Address
}

public extension DecodeAddressResponse {
    
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys : String, CodingKey {
        case networkId = "network_id"
        case networkName = "network_name"
        case entityType = "entity_type"
        case data
        case hrp
        case address
    }
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(networkId, forKey: .networkId)
        try container.encode(networkName, forKey: .networkName)
        try container.encode(entityType, forKey: .entityType)
        try container.encode(data.toHexString(), forKey: .data)
        try container.encode(hrp, forKey: .hrp)
        try container.encode(address, forKey: .address)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let values: KeyedDecodingContainer = try decoder.container(keyedBy: CodingKeys.self)
        
        networkId = try values.decode(UInt8.self, forKey: .networkId)
        networkName = try values.decode(String.self, forKey: .networkName)
        entityType = try values.decode(AddressKind.self, forKey: .entityType)
        data = Array<UInt8>(hex: try values.decode(String.self, forKey: .data))
        hrp = try values.decode(String.self, forKey: .hrp)
        address = try values.decode(Address.self, forKey: .address)
    }
}

public enum AddressKind: String, Codable, Sendable, Hashable {
    case Resource
    case Package

    case AccountComponent
    case SystemComponent
    case NormalComponent
}

public enum Address: Sendable, Codable, Hashable {
    case PackageAddress(PackageAddress)
    case ComponentAddress(ComponentAddress)
    case ResourceAddress(ResourceAddress)
}
