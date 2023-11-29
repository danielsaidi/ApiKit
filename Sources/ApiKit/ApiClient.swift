//
//  ApiClient.swift
//  ApiKit
//
//  Created by Daniel Saidi on 2023-03-25.
//  Copyright © 2023 Daniel Saidi. All rights reserved.
//

import Foundation

/**
 This protocol can be implemented by types that can make api
 requests and return the raw data.
 
 Use ``fetch(_:)`` to fetch raw data, and ``fetchItem(with:)``
 or ``fetchItem(at:in:)`` to fetch typed data.
 
 The protocol is implemented by `URLSession`, so you can use
 it without having to create a custom client implementation.
 
 If you must create a custom client implementation, you only
 have to implement ``fetch(_:)`` if you need to customize it.
 */
public protocol ApiClient: AnyObject {

    /// Perform a `URLRequest` and return the raw result.
    func fetch(_ request: URLRequest) async throws -> ApiResult
}

extension URLSession: ApiClient {}

public extension URLSession {

    func fetch(
        _ request: URLRequest
    ) async throws -> ApiResult {
        let result = try await data(for: request)
        let data = result.0
        let response = result.1
        return ApiResult(data: data, response: response)
    }
}

public extension ApiClient {

    /**
     Try to perform a `URLRequest` and return a result where
     the raw `Data` is mapped to a certain type.
     */
    func fetchItem<T: Decodable>(
        with request: URLRequest
    ) async throws -> T {
        let result = try await fetch(request)
        guard let data = result.data else { throw ApiError.noDataInResponse(result.response) }
        return try JSONDecoder().decode(T.self, from: data)
    }

    /**
     Try to perform a `URLRequest` and return a result where
     the raw `Data` is mapped to a certain type.
     */
    func fetchItem<T: Decodable>(
        at route: ApiRoute,
        in environment: ApiEnvironment
    ) async throws -> T {
        let request = try route.urlRequest(for: environment)
        return try await fetchItem(with: request)
    }
}
