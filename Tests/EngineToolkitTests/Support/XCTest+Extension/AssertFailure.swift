//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-10-07.
//

import Foundation
@testable import EngineToolkit
import XCTest

func XCTAssertThrowsFailure<Success, Failure: Swift.Error & Equatable>(
    _ expression: @autoclosure () -> Result<Success, Failure>,
    _ message: @autoclosure () -> String = "",
    file: StaticString = #filePath,
    line: UInt = #line,
    _ errorHandler: (_ failure: Failure) -> Void = { _ in }
) {
    let result = expression()
    
    let assertFailureTypeResult = result.mapError { (failure: Failure) -> Failure in
        errorHandler(failure)
        return failure
    }
    
    XCTAssertThrowsError(
        try assertFailureTypeResult.get(),
        message(),
        file: file,
        line: line
    )
}

func XCTAssertThrowsEngineError<Success>(
    _ expression: @autoclosure () -> Result<Success, EngineToolkit.Error>,
    _ message: @autoclosure () -> String = "",
    file: StaticString = #filePath,
    line: UInt = #line,
    _ errorHandler: (_ failure: EngineToolkit.Error) -> Void = { _ in }
) {
    XCTAssertThrowsFailure(
        expression(),
        message(),
        file: file,
        line: line,
        errorHandler
    )
}

func XCTAssert<Success>(
    _ expression: @autoclosure () -> Result<Success, EngineToolkit.Error>,
    throwsSpecificError specificError: EngineToolkit.Error,
    _ message: @autoclosure () -> String = "",
    file: StaticString = #filePath,
    line: UInt = #line
) {
    XCTAssertThrowsFailure(
        expression(),
        message(),
        file: file,
        line: line
    ) { failure in
        XCTAssertEqual(failure, specificError, message(), file: file, line: line)
    }
}
