//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-10-06.
//

import Foundation
@testable import EngineToolkit
import XCTest

final class FailingJSONEncoder: JSONEncoder {}

final class TestOfErrors: TestCase {
    func test_errors() throws {
        sut.information()
    }
}
