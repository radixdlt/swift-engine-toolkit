//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-10-05.
//

import Foundation

public struct NetworkID: Sendable, Codable, Hashable, Identifiable, CaseIterable, CustomStringConvertible, ExpressibleByIntegerLiteral {
	public typealias ID = UInt8
	public typealias IntegerLiteralType = ID
	public var description: String { String(describing: id) }
	public let id: ID
	public init(_ id: ID) {
		self.id = id
	}
	public init(integerLiteral id: IntegerLiteralType) {
		self.init(id)
	}
}
public extension NetworkID {
	func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		try container.encode(self.id)
	}
	init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		self.id = try container.decode(NetworkID.ID.self)
	}
}

public extension NetworkID {
	
    /// Mainnet
	/// https://github.com/radixdlt/babylon-node/blob/main/common/src/main/java/com/radixdlt/networks/Network.java#L77
    /// Decimal value: 01
	static let mainnet: Self = 0x01
	
    /// Local Simulator
	/// https://github.com/radixdlt/babylon-node/blob/main/common/src/main/java/com/radixdlt/networks/Network.java#L104
	/// Decimal value: 242
	static let simulator: Self = 0xF2
    
    /// Hammunet
    /// https://github.com/radixdlt/babylon-node/blob/main/common/src/main/java/com/radixdlt/networks/Network.java#L95
    /// Decimal value: 34
    static let hammunet: Self = 0x22

	
}

public extension NetworkID {
    // Update this to betanet for betanet and mainnet post mainnet.
    static let primary: Self = .hammunet
}

public extension NetworkID {
   
    typealias AllCases = [Self]
   
    static var allCases: [NetworkID] {
        [.mainnet, .simulator, .hammunet]
    }
    
    static func all(but excluded: NetworkID) -> AllCases {
        var allBut = Self.allCases
        allBut.removeAll(where: { $0 == excluded })
        return allBut
    }
}
