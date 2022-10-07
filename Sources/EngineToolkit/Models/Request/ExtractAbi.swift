public struct ExtractAbiRequest: Sendable, Codable, Hashable {
    // ===============
    // Struct members
    // ===============
    public let packageWasm: [UInt8]
    
    // =============
    // Constructors
    // =============
    
    public init(from packageWasm: [UInt8]) {
        self.packageWasm = packageWasm
    }
    
    public init(from packageWasm: String) throws {
        self.packageWasm = try [UInt8](hex: packageWasm)
    }

}

public extension ExtractAbiRequest {
    
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys: String, CodingKey {
        case packageWasm = "package_wasm"
    }
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(packageWasm.toHexString(), forKey: .packageWasm)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self = try Self(from: container.decode(String.self, forKey: .packageWasm))
    }
}

public struct ExtractAbiResponse: Sendable, Codable, Hashable {
    // ===============
    // Struct members
    // ===============
    public let code: [UInt8]
    public let abi: [UInt8]
    
    // =============
    // Constructors
    // =============
    
    public init(from code: [UInt8], abi: [UInt8]) {
        self.code = code
        self.abi = abi
    }
    
    public init(from code: String, abi: String) throws {
        self.code = try [UInt8](hex: code)
        self.abi = try [UInt8](hex: abi)
    }

}

public extension ExtractAbiResponse {
    
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys: String, CodingKey {
        case code
        case abi
    }
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(code.toHexString(), forKey: .code)
        try container.encode(abi.toHexString(), forKey: .abi)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self = try Self(from: container.decode(String.self, forKey: .code), abi: container.decode(String.self, forKey: .code))
    }
}
