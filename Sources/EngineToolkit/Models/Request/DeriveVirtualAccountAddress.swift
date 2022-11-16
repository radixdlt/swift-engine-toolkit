public struct DeriveVirtualAccountAddressRequest: Sendable, Codable, Hashable {
    public let publicKey: Engine.PublicKey
    public let networkId: NetworkID
    
    public init(
        publicKey: Engine.PublicKey,
        networkId: NetworkID
    ) {
        self.publicKey = publicKey
        self.networkId = networkId
    }
    
    private enum CodingKeys: String, CodingKey {
        case publicKey = "public_key"
        case networkId = "network_id"
    }
}

public struct DeriveVirtualAccountAddressResponse: Sendable, Codable, Hashable {
    public let virtualAccountAddress: String
    
    public init(
        virtualAccountAddress: String
    ) {
        self.virtualAccountAddress = virtualAccountAddress
    }
    
    private enum CodingKeys: String, CodingKey {
        case virtualAccountAddress = "virtual_account_address"
    }
    
    func componentAddress() -> ComponentAddress {
        return ComponentAddress(address: self.virtualAccountAddress)
    }
}
