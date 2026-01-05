//
//  ApiClient.swift
//  ApiKit
//
//  Created by Daniel Saidi on 2023-03-25.
//  Copyright © 2023-2026 Daniel Saidi. All rights reserved.
//

import Foundation

/// This protocol can be implemented by any type that can perform API requests.
///
/// You can use ``data(for:)`` to request raw data and ``request(_:)``
/// to request a validated ``ApiResult``. You can use ``request(with:)``
/// and ``request(at:in:)`` to request and parse any decodable data.
///
/// This protocol is implemented by `URLSession`, so you can use the shared
/// session directly. You can create a custom implementation to customize how it
/// performs certain operations, for mocking, etc.
public protocol ApiClient: AnyObject {
    
    /// Fetch data with the provided `URLRequest`.
    func data(
        for request: URLRequest
    ) async throws -> (Data, URLResponse)
}

extension URLSession: ApiClient {}

public extension ApiClient {
    
    /// Request a raw ``ApiResult`` for the provided request.
    func request(
        _ request: URLRequest
    ) async throws -> ApiResult {
        let result = try await data(for: request)
        let data = result.0
        let response = result.1
        try validate(request: request, response: response, data: data)
        return ApiResult(data: data, response: response)
    }
    
    /// Request a raw ``ApiResult`` for the provided route.
    func request(
        _ route: ApiRoute,
        in environment: ApiEnvironment
    ) async throws -> ApiResult {
        let request = try route.urlRequest(for: environment)
        return try await self.request(request)
    }

    /// Request a typed result for the provided request.
    func request<T: Decodable>(
        with request: URLRequest,
        decoder: JSONDecoder? = nil
    ) async throws -> T {
        let result = try await self.request(request)
        let data = result.data
        let decoder = decoder ?? JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }

    /// Request a typed result for the provided route.
    func request<T: Decodable>(
        at route: ApiRoute,
        in environment: ApiEnvironment,
        decoder: JSONDecoder? = nil
    ) async throws -> T {
        let request = try route.urlRequest(for: environment)
        return try await self.request(with: request, decoder: decoder)
    }
    
    /// Validate the provided request, response and data.
    func validate(
        request: URLRequest,
        response: URLResponse,
        data: Data
    ) throws(ApiError) {
        guard let httpResponse = response as? HTTPURLResponse else { return }
        let statusCode = httpResponse.statusCode
        guard statusCode.isValidHttpStatusCode else {
            throw ApiError.invalidHttpStatusCode(statusCode, request, response, data)
        }
        guard statusCode.isSuccessfulHttpStatusCode else {
            throw ApiError.unsuccessfulHttpStatusCode(statusCode, request, response, data)
        }
    }
}
