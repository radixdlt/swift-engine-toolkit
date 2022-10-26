public struct DeriveNonFungibleAddressRequest: Sendable, Codable, Hashable {
    // MARK: Stored properties
    public let resourceAddress: String
    public let nonFungibleId: [UInt8]
    
    // MARK: Init
    
    public init(resourceAddress: String, nonFungibleId: [UInt8]) {
        self.resourceAddress = resourceAddress
        self.nonFungibleId = nonFungibleId
    }
    
    public init(resourceAddress: String, nonFungibleIdHex: String) throws {
        self.init(resourceAddress: resourceAddress, nonFungibleId: try [UInt8](hex: nonFungibleIdHex))
    }
}

public extension DeriveNonFungibleAddressRequest {
    // MARK: CodingKeys
    private enum CodingKeys: String, CodingKey {
        case resourceAddress = "resource_address"
        case nonFungibleId = "non_fungible_id"
    }
    
    // MARK: Codable
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(resourceAddress, forKey: .resourceAddress)
        try container.encode(nonFungibleId.hex(), forKey: .nonFungibleId)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
       
        try self.init(resourceAddress:  container.decode(String.self, forKey: .resourceAddress), nonFungibleIdHex: container.decode(String.self, forKey: .nonFungibleId))
        
    }
}

public struct DeriveNonFungibleAddressResponse: Sendable, Codable, Hashable {
    // MARK: Stored properties
    public let nonFungibleAddress: String
    
    // MARK: Init
    
    public init(from nonFungibleAddress: String) {
        self.nonFungibleAddress = nonFungibleAddress
    }
    
    // MARK: CodingKeys
    private enum CodingKeys: String, CodingKey {
        case nonFungibleAddress = "non_fungible_address"
    }
}
