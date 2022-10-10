//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-10-10.
//

import Foundation

// non-`final` so that we can inherit from it in tests
public class EngineJSONDecoder: JSONDecoder {
    open override func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
        // Actually not needed to do any custom decoding, since we make use of ProxyDecodables in
        // `Value.init(from decoder: Decoder)`
        try super.decode(type, from: data)
    }
}
