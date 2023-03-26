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

    private let route = TestRoute.movie
    private let env = TestEnvironment.prod

    func testFetchingItemFailsIfServiceThrowsError() async {
        let client = TestClient(data: nil, error: TestError.baboooom)
        do {
            let _: TestMovie? = try await client.fetchItem(at: route, in: env)
            XCTFail("Should fail")
        } catch {
            let err = error as? TestError
            XCTAssertTrue(err == .baboooom)
        }
    }

    func testFetchingItemFailsIfServiceDoesNotReturnAnyData() async {
        let client = TestClient(data: nil, error: nil)
        do {
            let _: TestMovie? = try await client.fetchItem(at: route, in: env)
            XCTFail("Should fail")
        } catch {
            let err = error as? ApiError
            XCTAssertTrue(err?.isNoDataInResponse ?? false)
        }
    }

    func testFetchingItemFailsIfServiceReturnsInvalidData() async {
        let person = TestPerson(id: "", firstName: "Al", lastName: "Pacino")
        let data = try? JSONEncoder().encode(person)
        let client = TestClient(data: data, error: nil)
        do {
            let _: TestMovie? = try await client.fetchItem(at: route, in: env)
            XCTFail("Should fail")
        } catch {
            XCTAssertNotNil(error as? DecodingError)
        }
    }

    func testFetchingItemSucceedsIfServiceReturnsValidData() async {
        let movie = TestMovie(id: "", name: "Godfather")
        let data = try? JSONEncoder().encode(movie)
        let client = TestClient(data: data, error: nil)
        do {
            let movie: TestMovie = try await client.fetchItem(at: route, in: env)
            XCTAssertEqual(movie.name, "Godfather")
        } catch {
            XCTFail("Should fail")
        }
    }
}

private enum TestError: Error, Equatable {

    case baboooom
}

private struct TestMovie: Codable {

    var id: String
    var name: String
}

private struct TestPerson: Codable {

    var id: String
    var firstName: String
    var lastName: String
}

private enum TestEnvironment: ApiEnvironment {

    case prod

    var url: URL {
        let urlString = "http://api.imdb.com/"
        guard let url = URL(string: urlString) else { fatalError("Invalid url") }
        return url
    }
}

private enum TestRoute: ApiRoute {

    case movie

    var httpMethod: HttpMethod { .get }

    var path: String { "" }

    var formParams: [String: String] { [:] }

    var postData: Data? {
        let movie = TestMovie(id: "abc123", name: "Fargo")
        let encoder = JSONEncoder()
        return try? encoder.encode(movie)
    }

    var queryParams: [String: String] { [:] }
}

private class TestClient: ApiClient {

    init(
        data: Data?,
        error: Error?
    ) {
        self.data = data
        self.error = error
    }

    let data: Data?
    let error: Error?

    func fetch(
        _ request: URLRequest
    ) async throws -> ApiResult {
        if let error { throw error }
        return ApiResult(data: data, response: .init())
    }
}

private extension ApiError {

    var isNoDataInResponse: Bool {
        switch self {
        case .noDataInResponse: return true
        }
    }
}
