//
//  Int+HttpStatusCodesTests.swift
//  ApiKit
//
//  Created by Daniel Saidi on 2024-10-04.
//  Copyright © 2024-2025 Daniel Saidi. All rights reserved.
//

import XCTest

@testable import ApiKit

final class Int_HttpStatusCodesTests: XCTestCase {

    func testIntegerCanValidateStatusCode() async throws {
        XCTAssertFalse(0.isValidHttpStatusCode)
        XCTAssertFalse(99.isValidHttpStatusCode)
        XCTAssertTrue(100.isValidHttpStatusCode)
        XCTAssertTrue(599.isValidHttpStatusCode)
        XCTAssertFalse(600.isValidHttpStatusCode)

        XCTAssertFalse(199.isSuccessfulHttpStatusCode)
        XCTAssertTrue(200.isSuccessfulHttpStatusCode)
        XCTAssertTrue(299.isSuccessfulHttpStatusCode)
        XCTAssertFalse(300.isSuccessfulHttpStatusCode)

        XCTAssertTrue(199.isUnsuccessfulHttpStatusCode)
        XCTAssertFalse(200.isUnsuccessfulHttpStatusCode)
        XCTAssertFalse(299.isUnsuccessfulHttpStatusCode)
        XCTAssertTrue(300.isUnsuccessfulHttpStatusCode)
    }
}
