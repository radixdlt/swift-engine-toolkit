public struct ExtractAbiRequest: Sendable, Codable, Hashable {
    // ===============
    // Struct members
    // ===============
    public let packageWasm: Array<UInt8>
    
    // =============
    // Constructors
    // =============
    
    public init(from packageWasm: Array<UInt8>) {
        self.packageWasm = packageWasm
    }
    
    public init(from packageWasm: String) {
        self.packageWasm = Array<UInt8>(hex: packageWasm)
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
        
        self = Self(from: try container.decode(String.self, forKey: .packageWasm))
    }
}

public struct ExtractAbiResponse: Sendable, Codable, Hashable {
    // ===============
    // Struct members
    // ===============
    public let code: Array<UInt8>
    public let abi: Array<UInt8>
    
    // =============
    // Constructors
    // =============
    
    public init(from code: Array<UInt8>, abi: Array<UInt8>) {
        self.code = code
        self.abi = abi
    }
    
    public init(from code: String, abi: String) {
        self.code = Array<UInt8>(hex: code)
        self.abi = Array<UInt8>(hex: abi)
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
        
        self = Self(from: try container.decode(String.self, forKey: .code), abi: try container.decode(String.self, forKey: .code))
    }
}
