import Foundation


public struct TransactionManifest: Sendable, Codable, Hashable {
    // ===============
    // Struct members
    // ===============
    
    public let instructions: ManifestInstructions
    public let blobs: [[UInt8]]
    
    // =============
    // Constructors
    // =============
    
    public init(
        instructions: ManifestInstructions,
        blobs: [[UInt8]] = []
    ) {
        self.instructions = instructions
        self.blobs = blobs
    }

}

