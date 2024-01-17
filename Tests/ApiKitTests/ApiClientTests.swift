//
//  ApiClientTests.swift
//  ApiKit
//
//  Created by Daniel Saidi on 2023-03-24.
//  Copyright © 2023 Daniel Saidi. All rights reserved.
//

import ApiKit
import XCTest

final class ApiClientTests: XCTestCase {

    private let route = TestRoute.movie(id: "ABC123")
    private let env = TestEnvironment.production

    func testFetchingItemtestFetchingItemAtEnvironmentRouteFailsIfServiceThrowsError() async {
        let client = TestClient(data: .init(), error: TestError.baboooom)
        do {
            let _: TestMovie? = try await client.fetchItem(at: route, in: env)
            XCTFail("Should fail")
        } catch {
            let err = error as? TestError
            XCTAssertTrue(err == .baboooom)
        }
    }

    func testFetchingItemtestFetchingItemAtEnvironmentRouteFailsIfServiceReturnsInvalidData() async throws {
        let person = TestPerson(id: "", firstName: "Al", lastName: "Pacino")
        let data = try JSONEncoder().encode(person)
        let client = TestClient(data: data, error: nil)
        do {
            let _: TestMovie? = try await client.fetchItem(at: route, in: env)
            XCTFail("Should fail")
        } catch {
            XCTAssertNotNil(error as? DecodingError)
        }
    }

    func testFetchingItemtestFetchingItemAtEnvironmentRouteSucceedsIfServiceReturnsValidData() async throws {
        let movie = TestMovie(id: "", name: "Godfather")
        let data = try JSONEncoder().encode(movie)
        let client = TestClient(data: data, error: nil)
        do {
            let movie: TestMovie = try await client.fetchItem(at: route, in: env)
            XCTAssertEqual(movie.name, "Godfather")
        } catch {
            XCTFail("Should fail")
        }
    }
}
