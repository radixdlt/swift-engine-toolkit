public struct InformationRequest: Sendable, Codable, Hashable {}
public struct InformationResponse: Sendable, Codable, Hashable {
    public let packageVersion: String
    
    private enum CodingKeys : String, CodingKey {
        case packageVersion = "package_version"
    }
}
