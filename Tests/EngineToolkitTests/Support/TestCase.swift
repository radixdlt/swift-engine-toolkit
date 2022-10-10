//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-10-05.
//

@_exported import Foundation
@_exported import XCTest
@_exported @testable import EngineToolkit

class TestCase: XCTestCase {
    
    var sut = EngineToolkit()
    var debugPrint = false
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        EngineToolkit._debugPrint = debugPrint
    }
    override func tearDown() {
        EngineToolkit._debugPrint = false
    }
    
    
}
