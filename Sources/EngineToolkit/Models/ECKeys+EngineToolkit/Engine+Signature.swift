//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-10-24.
//

import Foundation

public extension Engine {
    enum Signature: Sendable, Codable, Hashable {
        // ==============
        // Enum Variants
        // ==============
        
        case ecdsaSecp256k1(EcdsaSecp256k1Signature)
        case eddsaEd25519(EddsaEd25519Signature)
    }
}

private extension Engine.Signature {
   
    var discriminator: CurveDiscriminator {
        switch self {
        case .ecdsaSecp256k1: return .ecdsaSecp256k1
        case .eddsaEd25519: return .eddsaEd25519
        }
    }
}

public extension Engine.Signature {
    
    // MARK: CodingKeys
    private enum CodingKeys: String, CodingKey {
        case discriminator = "type"
        case signature
    }
    
    
    // MARK: Codable
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(discriminator, forKey: .discriminator)
        
        switch self {
            case .ecdsaSecp256k1(let signature):
                try container.encode(signature, forKey: .signature)
            case .eddsaEd25519(let signature):
                try container.encode(signature, forKey: .signature)
         }
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let discriminator = try container.decode(CurveDiscriminator.self, forKey: .discriminator)
        
        switch discriminator {
        case .ecdsaSecp256k1:
            self = .ecdsaSecp256k1(try container.decode(Engine.EcdsaSecp256k1Signature.self, forKey: .signature))
        case .eddsaEd25519:
            self = .eddsaEd25519(try container.decode(Engine.EddsaEd25519Signature.self, forKey: .signature))
        }
    }
}
