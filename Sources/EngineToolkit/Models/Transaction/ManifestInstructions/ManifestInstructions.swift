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
		separator: String = "\n"
	) -> String {
		switch self {
		case let .string(manifestString):
			let instructionStrings = manifestString.split(separator: ";").map { $0.trimmingCharacters(in: .newlines) }
			return instructionStrings.joined(separator: separator)
		case let .json(instructions):
			return instructions.map {
				String(describing: $0)
			}
			.joined(separator: separator)
		}
	}
	
	var description: String {
		toString()
	}
}
