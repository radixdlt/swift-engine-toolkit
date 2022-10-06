public struct DecodeAddressRequest: Sendable, Codable, Hashable {
    // ===============
    // Struct members
    // ===============
    public let address: String
    
    // =============
    // Constructors
    // =============
   
    public init(address: String) {
        self.address = address
    }
}

