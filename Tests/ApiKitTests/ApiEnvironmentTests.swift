//
//  ApiEnvironmentTests.swift
//  ApiKit
//
//  Created by Daniel Saidi on 2023-03-25.
//  Copyright © 2023-2024 Daniel Saidi. All rights reserved.
//

import XCTest
@testable import ApiKit

final class ApiEnvironmentTests: XCTestCase {

    func request(for route: TestRoute) -> URLRequest? {
        let env = TestEnvironment.production
        return try? env.urlRequest(for: route)
    }

    func testUrlRequestIsCreatedWithRoute() throws {
        XCTAssertNotNil(request(for: .movie(id: "ABC123")))
        XCTAssertNotNil(request(for: .formLogin(userName: "danielsaidi", password: "super-secret")))
        XCTAssertNotNil(request(for: .postLogin(userName: "danielsaidi", password: "super-secret")))
        XCTAssertNotNil(request(for: .search(query: "A nice movie", page: 1)))
    }
}
