public struct ExtractAbiRequest: Sendable, Codable, Hashable {
    // MARK: Stored properties
    public let packageWasm: [UInt8]
    
    // MARK: Init
    
    public init(packageWasm: [UInt8]) {
        self.packageWasm = packageWasm
    }
    
    public init(packageWasmHex: String) throws {
        try self.init(packageWasm: [UInt8](hex: packageWasmHex))
    }

}

public extension ExtractAbiRequest {
    
    // MARK: CodingKeys
    private enum CodingKeys: String, CodingKey {
        case packageWasm = "package_wasm"
    }
    
    // MARK: Codable
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(packageWasm.toHexString(), forKey: .packageWasm)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        try self.init(packageWasmHex: container.decode(String.self, forKey: .packageWasm))
    }
}

public struct ExtractAbiResponse: Sendable, Codable, Hashable {
    // MARK: Stored properties
    public let code: [UInt8]
    public let abi: [UInt8]
    
    // MARK: Init
    
    public init(code: [UInt8], abi: [UInt8]) {
        self.code = code
        self.abi = abi
    }
    
    public init(codeHex: String, abiHex: String) throws {
        try self.init(
            code: [UInt8](hex: codeHex),
            abi: [UInt8](hex: abiHex)
        )
    }

}

public extension ExtractAbiResponse {
    
    // MARK: CodingKeys
    private enum CodingKeys: String, CodingKey {
        case code
        case abi
    }
    
    // MARK: Codable
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(code.toHexString(), forKey: .code)
        try container.encode(abi.toHexString(), forKey: .abi)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self = try Self(
            codeHex: container.decode(String.self, forKey: .code),
            abiHex: container.decode(String.self, forKey: .abi)
        )
    }
}
