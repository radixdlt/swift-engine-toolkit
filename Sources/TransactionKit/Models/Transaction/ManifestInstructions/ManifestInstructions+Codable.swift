//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-10-05.
//

import Foundation

public extension ManifestInstructions {
    
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys: String, CodingKey {
        case type
        case value
    }
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
            case .stringInstructions(let value):
                try container.encode(ManifestInstructionsKind.string, forKey: .type)
                try container.encode(value, forKey: .value)
            case .jsonInstructions(let value):
                try container.encode(ManifestInstructionsKind.json, forKey: .type)
                try container.encode(value, forKey: .value)
        }
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let manifestInstructionsKind: ManifestInstructionsKind = try container.decode(ManifestInstructionsKind.self, forKey: .type)
        
        switch manifestInstructionsKind {
            case .string:
                let manifestInstructions: String = try container.decode(String.self, forKey: .value)
                self = Self.stringInstructions(manifestInstructions)
            case .json:
                let manifestInstructions: Array<Instruction> = try container.decode(Array<Instruction>.self, forKey: .value)
                self = Self.jsonInstructions(manifestInstructions)
        }
    }
}
