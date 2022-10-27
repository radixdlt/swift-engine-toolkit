import Foundation
import CryptoKit
import SLIP10

public struct TransactionManifest: Sendable, Codable, Hashable, CustomStringConvertible {
    // MARK: Stored properties
    public let instructions: ManifestInstructions
    public let blobs: [[UInt8]]
    
    // MARK: Init
    
    public init(
        instructions: ManifestInstructions,
        blobs: [[UInt8]] = []
    ) {
        self.instructions = instructions
        self.blobs = blobs
    }
    
    public init(
        instructions: [Instruction],
        blobs: [[UInt8]] = []
    ) {
        self.init(
            instructions: .json(instructions),
            blobs: blobs
        )
    }
    
    public init(
        instructions: [any InstructionProtocol],
        blobs: [[UInt8]] = []
    ) {
        self.init(
            instructions: instructions.map { $0.embed() },
            blobs: blobs
        )
    }
}

public extension TransactionManifest {
	
	enum BlobOutputFormat {
		case excludeBlobs
		case includeBlobsByByteCountOnly
		case includeBlobs
        /// Blob + SHA256.twice hash of blob
        case includeBlobsWithHash
		public static let `default`: Self = .includeBlobsByByteCountOnly
	}
	
	func toStringBlobs(
		preamble: String = "BLOBS\n",
		label: String = "BLOB\n",
		formatting: BlobOutputFormat,
		separator: String = "\n"
	) -> String {
		let body: String
		switch formatting {
		case .excludeBlobs: return ""
		case .includeBlobsByByteCountOnly:
			body = blobs.enumerated().map { index, blob in
				"\(label)[\(index)]: #\(blob.count) bytes"
			}.joined(separator: separator)
		case .includeBlobs:
			body = blobs.enumerated().map { index, blob in
				"\(label)[\(index)]:\n\(blob.hex)\n"
			}.joined(separator: separator)
        case .includeBlobsWithHash:
            body = blobs.enumerated().map { index, blob in
                let hash = Data(SHA256.twice(data: blob))
                let hashHex = hash.hex
                return "\(label)[\(index)] hash = \(hashHex):\n\(blob.hex)\n"
            }.joined(separator: separator)
		}
		guard !body.isEmpty else {
			return ""
		}
		return [preamble, body].joined()
	}
	
	func toString(
		preamble: String = "~~~ MANIFEST ~~~\n",
		blobOutputFormat: BlobOutputFormat = .default,
		blobSeparator: String = "\n",
		blobPreamble: String = "BLOBS\n",
		blobLabel: String = "BLOB\n",
        instructionsSeparator: String = "\n\n",
        instructionsArgumentSeparator: String = "\n\t"
	) -> String {
		
		
		let instructionsString = instructions.toString(
            separator: instructionsSeparator,
            argumentSeparator: instructionsArgumentSeparator
		)
		
		let blobString = toStringBlobs(
			preamble: blobPreamble,
			label: blobLabel,
			formatting: blobOutputFormat,
			separator: blobSeparator
		)
		
		let manifestString = [preamble, instructionsString, blobString].joined()
		
		return manifestString
	}
	
	var description: String {
		toString()
	}
}


@resultBuilder
public struct InstructionsBuilder {}
public extension InstructionsBuilder {
    static func buildBlock(_ instructions: Instruction...) -> [Instruction] {
        instructions
    }
    static func buildBlock(_ instruction: Instruction) -> [Instruction] {
        [instruction]
    }
    static func buildBlock(_ instruction: Instruction) -> Instruction {
        instruction
    }
}

@resultBuilder
public struct SpecificInstructionsBuilder {}
public extension SpecificInstructionsBuilder {
    static func buildBlock(_ instructions: any InstructionProtocol...) -> [any InstructionProtocol] {
        instructions
    }
    static func buildBlock(_ instruction: any InstructionProtocol) -> [any InstructionProtocol] {
        [instruction]
    }
    static func buildBlock(_ instruction: any InstructionProtocol) -> any InstructionProtocol {
        instruction
    }
}

public extension TransactionManifest {
    init(@InstructionsBuilder buildInstructions: () throws -> [Instruction]) rethrows{
        try self.init(instructions: buildInstructions())
    }
    
    init(@SpecificInstructionsBuilder buildInstructions: () throws -> [any InstructionProtocol]) rethrows {
        try self.init(instructions: buildInstructions())
    }
}

