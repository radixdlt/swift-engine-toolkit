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
    
    static func toStringInstructions(
        _ instructions: ManifestInstructions,
        // If instructions are on JSON format we stringify them, which requires blobs (convertManifest)
        in manifest: TransactionManifest,
        separator: String = "\n",
        argumentSeparator: String = "\n\t"
    ) -> String {
        switch instructions {
        case let .string(manifestString):
            
            // Remove newline so that we can control number of newlines ourselves.
            let instructionStringsWithoutNewline = manifestString
                .split(separator: ";")
                .map { $0.trimmingCharacters(in: .newlines) }
                .map { $0 + ";" } // Re-add ";"
                .map {
                    // Make it possible to change separator between arguments inside the instruction
                    $0.split(separator: " ").joined(separator: argumentSeparator)
                }
            
            return instructionStringsWithoutNewline.joined(separator: separator)
            
        case .json(_): // use `_` because we convert to String anyway.
            // We dont wanna print JSON, so we go through conversion to STRING first
            let stringifiedManifest = try! EngineToolkit()
                .convertManifest(
                    request: .init(
                        transactionVersion: .default,
                        manifest: manifest, // need blobs
                        // Wanna convert from Self (`.json`) -> ManifestInstrictions.string
                        outputFormat: .string
                    )
                )
                .get()
            
            let stringifiedInstructions = stringifiedManifest.instructions
            
            // Recursively call `toString` on `stringifiedSelf`, with original arguments intact.
            return Self.toStringInstructions(
                stringifiedInstructions, // Use newly stringified instructions!
                in: manifest, // Don't care
                separator: separator, // passthrough
                argumentSeparator: argumentSeparator // passthrough
            )
        }
    }
    
    func toStringInstructions(
        separator: String = "\n",
        argumentSeparator: String = "\n\t"
    ) -> String {
        Self.toStringInstructions(
            instructions,
            // If instructions are on JSON format we stringify them, which requires blobs (convertManifest)
            in: self,
            separator: separator,
            argumentSeparator: argumentSeparator
        )
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
        
        let instructionsString = toStringInstructions(
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

