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
	
	/// https://github.com/radixdlt/radixdlt-scrypto/blob/f4c41985ad9d1570fff7293fa90b77a896b3be2b/scrypto/src/core/network.rs#L43
	static let mainnet: Self = 0x01
	
	/// https://github.com/radixdlt/radixdlt-scrypto/blob/f4c41985ad9d1570fff7293fa90b77a896b3be2b/scrypto/src/core/network.rs#L19
	/// Decimal value: 242
	static let simulator: Self = 0xF2
	
	/// https://github.com/radixdlt/radixdlt-scrypto/blob/f4c41985ad9d1570fff7293fa90b77a896b3be2b/scrypto/src/core/network.rs#L27
	/// Decimal value: 10
	static let adapanet: Self = 0x0A
	
	/// https://github.com/radixdlt/radixdlt-scrypto/blob/f4c41985ad9d1570fff7293fa90b77a896b3be2b/scrypto/src/core/network.rs#L35
	/// Decimal value: 11
	static let nebunet: Self = 0x0B
	
}

public extension NetworkID {
    // Update this to betanet for betanet and mainnet post mainnet.
    static let primary: Self = .adapanet
}

public extension NetworkID {
   
    typealias AllCases = [Self]
   
    static var allCases: [NetworkID] {
        [.mainnet, .simulator, .adapanet, .nebunet]
    }
    
    static func all(but excluded: NetworkID) -> AllCases {
        var allBut = Self.allCases
        allBut.removeAll(where: { $0 == excluded })
        return allBut
    }
}
