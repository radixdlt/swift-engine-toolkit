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
    
    case stringInstructions(String)
    case jsonInstructions([Instruction])
}

public extension ManifestInstructions {
    
    enum Kind: String, Codable, Hashable, Sendable {
        case string
        case json
    }

}

public typealias ManifestInstructionsKind = ManifestInstructions.Kind
