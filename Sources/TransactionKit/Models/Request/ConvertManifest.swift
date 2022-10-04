public struct ConvertManifestRequest: Sendable, Codable, Hashable {
    public let transactionVersion: UInt8
    public let networkId: UInt8
    public let manifestInstructionsOutputFormat: ManifestInstructionsKind
    public let manifest: TransactionManifest
    
    private enum CodingKeys : String, CodingKey {
        case transactionVersion = "transaction_version"
        case networkId = "network_id"
        case manifestInstructionsOutputFormat = "manifest_instructions_output_format"
        case manifest = "manifest"
    }
}

public typealias ConvertManifestResponse = TransactionManifest
