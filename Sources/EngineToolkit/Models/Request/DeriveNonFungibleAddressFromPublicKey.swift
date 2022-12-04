public typealias DeriveNonFungibleAddressFromPublicKeyRequest = Engine.PublicKey

public struct DeriveNonFungibleAddressFromPublicKeyResponse: Sendable, Codable, Hashable {
    // MARK: Stored properties
    public let nonFungibleAddress: NonFungibleAddress
    
    // MARK: Init
    
    public init(nonFungibleAddress: NonFungibleAddress) {
        self.nonFungibleAddress = nonFungibleAddress
    }
    
    // MARK: CodingKeys
    private enum CodingKeys: String, CodingKey {
        case nonFungibleAddress = "non_fungible_address"
    }
}
