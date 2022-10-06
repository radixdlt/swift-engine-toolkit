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
    
    var sut = TX()
    var debugPrint = true
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        TX._debugPrint = debugPrint
    }
    override func tearDown() {
        TX._debugPrint = false
    }
    
    
}
