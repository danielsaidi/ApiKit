//
//  ApiRoute.swift
//  ApiKit
//
//  Created by Daniel Saidi on 2023-03-24.
//  Copyright © 2023-2024 Daniel Saidi. All rights reserved.
//

import Foundation

/// This protocol can be used to define API routes.
///
/// An ``ApiRoute`` must define an ``httpMethod`` as well as
/// an environment-relative ``path``, which will be appended
/// to the ``ApiEnvironment`` ``ApiEnvironment/url``.
///
/// An ``ApiRoute`` must also define ``httpMethod``, headers,
/// query parameters, etc. although some can be empty or nil.
///
/// When route defines ``formParams`` the request should use
/// `application/x-www-form-urlencoded` as content type, and
/// ignore the route ``postData`` if set. The two properties
/// are mutually exclusive, and ``formParams`` should always
/// take precedence when both are defined.
///
/// Both ``ApiEnvironment`` and ``ApiRoute`` can specify any
/// headers and query parameters they need. Environments can
/// define global headers and query parameters, while routes
/// can define route-specific ones. 
public protocol ApiRoute: Sendable, ApiRequestData {

    /// The HTTP method to use for the route.
    var httpMethod: HttpMethod { get }

    /// The route's ``ApiEnvironment`` relative path.
    var path: String { get }

    /// Optional form data, which is sent as request body.
    var formParams: [String: String]? { get }
    
    /// Optional post data, which is sent as request body.
    var postData: Data? { get }
}

public extension ApiRoute {

    /// Convert ``encodedFormItems`` to `.utf8` encoded data.
    var encodedFormData: Data? {
        guard let formParams, !formParams.isEmpty else { return nil }
        var params = URLComponents()
        params.queryItems = encodedFormItems
        let paramString = params.query
        return paramString?.data(using: .utf8)
    }

    /// Convert ``formParams`` to form encoded query items.
    var encodedFormItems: [URLQueryItem]? {
        formParams?
            .map { URLQueryItem(name: $0.key, value: $0.value.formEncoded()) }
            .sorted { $0.name < $1.name }
    }

    /// Get a `URLRequest` for the route and its properties.
    func urlRequest(for env: ApiEnvironment) throws -> URLRequest {
        guard let envUrl = URL(string: env.url) else { throw ApiError.invalidEnvironmentUrl(env.url) }
        let routeUrl = envUrl.appendingPathComponent(path)
        guard var components = urlComponents(from: routeUrl) else { throw ApiError.failedToCreateComponentsFromUrl(routeUrl) }
        components.queryItems = queryItems(for: env)
        guard let requestUrl = components.url else { throw ApiError.noUrlInComponents(components) }
        var request = URLRequest(url: requestUrl)
        let formData = encodedFormData
        request.allHTTPHeaderFields = headers(for: env)
        request.httpBody = formData ?? postData
        request.httpMethod = httpMethod.method
        let isFormRequest = formData != nil
        let contentType = isFormRequest ? "application/x-www-form-urlencoded" : "application/json"
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        return request
    }
}

public extension ApiEnvironment {

    /// Get a `URLRequest` for a certain ``ApiRoute``.
    func urlRequest(for route: ApiRoute) throws -> URLRequest {
        try route.urlRequest(for: self)
    }
}

private extension ApiRoute {

    func headers(for env: ApiEnvironment) -> [String: String] {
        var result = env.headers ?? [:]
        headers?.forEach {
            result[$0.key] = $0.value
        }
        return result
    }

    func queryItems(for env: ApiEnvironment) -> [URLQueryItem] {
        let routeData = encodedQueryItems ?? []
        let envData = env.encodedQueryItems ?? []
        return routeData + envData
    }

    func urlComponents(from url: URL) -> URLComponents? {
        URLComponents(url: url, resolvingAgainstBaseURL: true)
    }
}
