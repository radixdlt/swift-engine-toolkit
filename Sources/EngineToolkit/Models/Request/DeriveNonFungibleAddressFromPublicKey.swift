public typealias DeriveNonFungibleAddressFromPublicKeyRequest = Engine.PublicKey

public struct DeriveNonFungibleAddressFromPublicKeyResponse: Sendable, Codable, Hashable {
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
