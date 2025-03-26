//
//  ApiClient.swift
//  ApiKit
//
//  Created by Daniel Saidi on 2023-03-25.
//  Copyright © 2023-2024 Daniel Saidi. All rights reserved.
//

import Foundation

/// This protocol can be implemented by any type that can be
/// used to perform API requests.
///
/// Use ``data(for:)`` to request raw data and ``request(_:)``
/// to request validated ``ApiResult``. You can also use the
/// generic ``request(with:)`` & ``request(at:in:)`` methods
/// to request generic, typed data.
///
/// This protocol is implemented by `URLSession`, so you can
/// use `URLSession` directly, without having to implement a
/// client class. But you can do it if you want to customize
/// how it performs certain operations.
public protocol ApiClient: AnyObject {
    
    /// Fetch data with the provided `URLRequest`.
    func data(
        for request: URLRequest
    ) async throws -> (Data, URLResponse)
}

extension URLSession: ApiClient {}

public extension ApiClient {
    
    /// Request an ``ApiResult`` with the provided request.
    ///
    /// This function returns an ``ApiResult`` with raw data
    /// and response properties.
    func request(
        _ request: URLRequest
    ) async throws -> ApiResult {
        let result = try await data(for: request)
        let data = result.0
        let response = result.1
        try validate(request: request, response: response, data: data)
        return ApiResult(data: data, response: response)
    }
    
    /// Request an ``ApiResult`` from the provided route.
    ///
    /// This function returns an ``ApiResult`` with raw data
    /// and response properties.
    func request(
        _ route: ApiRoute,
        in environment: ApiEnvironment
    ) async throws -> ApiResult {
        let request = try route.urlRequest(for: environment)
        return try await self.request(request)
    }

    /// Request a typed result with the provided request.
    ///
    /// This function returns a typed response instead of an
    /// ``ApiResult`` with raw data and response properties.
    func request<T: Decodable>(
        with request: URLRequest,
        decoder: JSONDecoder? = nil
    ) async throws -> T {
        let result = try await self.request(request)
        let data = result.data
        let decoder = decoder ?? JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }

    /// Request a typed result from the provided route.
    ///
    /// This function returns a typed response instead of an
    /// ``ApiResult`` with raw data and response properties. 
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
