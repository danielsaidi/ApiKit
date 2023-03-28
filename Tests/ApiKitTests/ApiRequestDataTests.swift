//
//  ApiRequestDataTests.swift
//  ApiKit
//
//  Created by Daniel Saidi on 2023-03-28.
//  Copyright © 2023 Daniel Saidi. All rights reserved.
//

import ApiKit
import XCTest

final class ApiRequestDataTests: XCTestCase {

    func testEncodedQueryItemsAreSortedAndEncoded() throws {
        let route = TestRoute.search(query: "let's search for &")
        let items = route.encodedQueryItems
        XCTAssertEqual(items.count, 1)
        XCTAssertEqual(items[0].name, "q")
        XCTAssertEqual(items[0].value, "let\'s%20search%20for%20%26")
    }
}
