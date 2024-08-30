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
    
    func client(withData data: Data = .init()) -> ApiClient {
        TestClient(data: data)
    }
    

    func testFetchingItemAtRouteFailsIfServiceThrowsError() async {
        let client = TestClient(error: TestError.baboooom)
        do {
            let _: TestMovie? = try await client.request(at: route, in: env)
            XCTFail("Should fail")
        } catch {
            let err = error as? TestError
            XCTAssertTrue(err == .baboooom)
        }
    }
    
    func testFetchingItemAtRouteFailsForInvalidData() async throws {
        let client = TestClient()
        do {
            let _: TestMovie? = try await client.request(at: route, in: env)
            XCTFail("Should fail")
        } catch {
            XCTAssertNotNil(error as? DecodingError)
        }
    }
    
    func testFetchingItemAtRouteFailsForInvalidResponse() async throws {
        let response = TestResponse.withStatusCode(100)
        let client = TestClient(response: response)
        do {
            let _: TestMovie? = try await client.request(at: route, in: env)
            XCTFail("Should fail")
        } catch {
            let error = error as? ApiError
            XCTAssertTrue(error?.isInvalidResponseStatusCode == true)
        }
    }
    
    func testFetchingItemAtRouteSucceedsIfServiceReturnsValidData() async throws {
        let movie = TestMovie(id: "", name: "Godfather")
        let data = try JSONEncoder().encode(movie)
        let client = client(withData: data)
        do {
            let movie: TestMovie = try await client.request(at: route, in: env)
            XCTAssertEqual(movie.name, "Godfather")
        } catch {
            XCTFail("Should fail")
        }
    }
    
    func testCanValidateResponseStatusCode() async throws {
        let client = client(withData: .init())
        XCTAssertFalse(client.validateStatusCode(199))
        XCTAssertTrue(client.validateStatusCode(200))
        XCTAssertTrue(client.validateStatusCode(299))
        XCTAssertFalse(client.validateStatusCode(300))
    }
}
