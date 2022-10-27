//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-10-05.
//

import Foundation

public enum ManifestInstructions: Sendable, Codable, Hashable, CustomStringConvertible {
    // ==============
    // Enum Variants
    // ==============
    
    case string(String)
    case json([Instruction])
}

public extension ManifestInstructions {
    
    enum Kind: String, Codable, Hashable, Sendable {
        case string = "String"
        case json = "JSON"
    }

}

public typealias ManifestInstructionsKind = ManifestInstructions.Kind

public extension ManifestInstructions {
	func toString(
		separator: String = "\n",
        argumentSeparator: String = "\n\t"
	) -> String {
		switch self {
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
                        // Create a manifest with `self`
                        manifest: TransactionManifest(
                            instructions: self
                        ),
                        // Wanna convert from Self (`.json`) -> ManifestInstrictions.string
                        outputFormat: .string
                    )
                )
                .get()
            
            let stringifiedSelf: Self = stringifiedManifest.instructions
            
            // Recursively call `toString` on `stringifiedSelf`, with original arguments intact.
            return stringifiedSelf.toString(separator: separator)
		}
	}
	
	var description: String {
		toString()
	}
}
