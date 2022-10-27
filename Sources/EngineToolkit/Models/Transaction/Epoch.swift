//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-10-27.
//

import Foundation
import Tagged

public enum EpochTag: Sendable {}

/// Network Epoch
public typealias Epoch = Tagged<EpochTag, UInt64>

