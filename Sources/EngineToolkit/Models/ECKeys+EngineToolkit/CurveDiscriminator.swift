//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-10-24.
//

import Foundation

internal enum CurveDiscriminator: String, Codable {
    case ecdsaSecp256k1 = "EcdsaSecp256k1"
    case eddsaEd25519 = "EddsaEd25519"
}
