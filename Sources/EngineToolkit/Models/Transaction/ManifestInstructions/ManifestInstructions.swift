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
	
    @available(iOS, deprecated: 999, message: "Prefer using `String(describing: transactionManifest)` if you have that, which will result in much better printing.")
    @available(macOS, deprecated: 999, message: "Prefer using `String(describing: transactionManifest)` if you have that, which will result in much better printing.")
	var description: String {
        switch self {
        case let .string(string):
            return string
        case let .json(instructions):
            return String(describing: instructions)
        }
	}
}
