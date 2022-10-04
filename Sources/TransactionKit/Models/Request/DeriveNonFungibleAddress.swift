public struct DeriveNonFungibleAddressRequest: Sendable, Codable, Hashable {
    // ===============
    // Struct members
    // ===============
    public let resourceAddress: String
    public let nonFungibleId: Array<UInt8>
    
    // =============
    // Constructors
    // =============
    
    public init(from resourceAddress: String, nonFungibleId: Array<UInt8>) {
        self.resourceAddress = resourceAddress
        self.nonFungibleId = nonFungibleId
    }
    
    public init(from resourceAddress: String, nonFungibleId: String) {
        self.resourceAddress = resourceAddress
        self.nonFungibleId = Array<UInt8>(hex: nonFungibleId)
    }
}

public extension DeriveNonFungibleAddressRequest {
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys : String, CodingKey {
        case resourceAddress = "resource_address"
        case nonFungibleId = "non_fungible_id"
    }
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(resourceAddress, forKey: .resourceAddress)
        try container.encode(nonFungibleId.toHexString(), forKey: .nonFungibleId)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let values: KeyedDecodingContainer = try decoder.container(keyedBy: CodingKeys.self)
        
        self = Self(from: try values.decode(String.self, forKey: .resourceAddress), nonFungibleId: try values.decode(String.self, forKey: .nonFungibleId))
        
    }
}

public struct DeriveNonFungibleAddressResponse: Sendable, Codable, Hashable {
    // ===============
    // Struct members
    // ===============
    public let nonFungibleAddress: String
    
    // =============
    // Constructors
    // =============
    
    public init(from nonFungibleAddress: String) {
        self.nonFungibleAddress = nonFungibleAddress
    }
    
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys : String, CodingKey {
        case nonFungibleAddress = "non_fungible_address"
    }
}
