//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-10-25.
//

import Foundation
import Bite

extension Array where Element == UInt8 {
    init(hex: String) throws {
        try self.init(Data(hex: hex))
    }
    func hex(options: Data.HexEncodingOptions = []) -> String {
        Data(self).hex(options: options)
    }
}
