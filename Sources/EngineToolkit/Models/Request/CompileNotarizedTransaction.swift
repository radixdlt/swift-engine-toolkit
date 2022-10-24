import Bite
import Foundation

extension Array where Element == UInt8 {
    init(hex: String) throws {
        try self.init(Data(hex: hex))
    }
    func hex(options: Data.HexEncodingOptions = []) -> String {
        Data(self).hex(options: options)
    }
}

public typealias CompileNotarizedTransactionIntentRequest = NotarizedTransaction

public struct CompileNotarizedTransactionIntentResponse: Sendable, Codable, Hashable {
    // MARK: Stored properties
    public let compiledNotarizedIntent: [UInt8]
    
    // MARK: Init
    
    public init(from compiledNotarizedIntent: [UInt8]) {
        self.compiledNotarizedIntent = compiledNotarizedIntent
    }
    
    public init(from compiledNotarizedIntent: String) throws {
        self.compiledNotarizedIntent = try [UInt8](hex: compiledNotarizedIntent)
    }
}

public extension CompileNotarizedTransactionIntentResponse {
    
    // MARK: CodingKeys
    private enum CodingKeys: String, CodingKey {
        case compiledNotarizedIntent = "compiled_notarized_intent"
    }
    
    // MARK: Codable
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(compiledNotarizedIntent.hex(), forKey: .compiledNotarizedIntent)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self = try Self(from: try container.decode(String.self, forKey: .compiledNotarizedIntent))
    }
}
