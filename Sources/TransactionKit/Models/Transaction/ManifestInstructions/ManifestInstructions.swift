//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-10-05.
//

import Foundation

public enum ManifestInstructions: Sendable, Codable, Hashable {
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
