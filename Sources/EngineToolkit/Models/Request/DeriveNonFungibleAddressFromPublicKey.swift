public typealias DeriveNonFungibleAddressFromPublicKeyRequest = PublicKey

public struct DeriveNonFungibleAddressFromPublicKeyResponse: Sendable, Codable, Hashable {
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
    private enum CodingKeys: String, CodingKey {
        case nonFungibleAddress = "non_fungible_address"
    }
}
