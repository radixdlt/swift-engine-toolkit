//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-10-09.
//

import Foundation

public protocol IdentifierConvertible: ExpressibleByStringLiteral, ExpressibleByIntegerLiteral {
    var identifier: Identifier { get }
    init(identifier: Identifier)
}
public extension IdentifierConvertible {
    
    init(_ identifier: Identifier) {
        self.init(identifier: identifier)
    }
    
    init(identifier: String) {
        self.init(identifier: .string(identifier))
    }
    
    init(identifier: UInt32) {
        self.init(identifier: .u32(identifier))
    }
    
    init(stringLiteral value: String) {
        self.init(identifier: value)
    }
    init(integerLiteral value: UInt32) {
        self.init(identifier: value)
    }
}