//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-10-27.
//

import Foundation
import Tagged

public enum VersionTag: Sendable {}

/// Transaction Version
public typealias Version = Tagged<VersionTag, UInt8>
