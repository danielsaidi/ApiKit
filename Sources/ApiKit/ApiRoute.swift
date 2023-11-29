//
//  ApiRoute.swift
//  ApiKit
//
//  Created by Daniel Saidi on 2023-03-24.
//  Copyright © 2023 Daniel Saidi. All rights reserved.
//

import Foundation

/**
 This protocol can be implemented to define API routes.

 An ``ApiRoute`` must define an ``httpMethod`` as well as an
 environment-relative path, headers, query params, post data,
 etc. You can use an enum to define multiple routes, and use
 associated values to provide route-specific parameters.

 When a route defines ``formParams``, the URL request should
 use `application/x-www-form-urlencoded` as content type and
 ignore the ``postData``. The two are mutually exclusive and
 ``formParams`` should take precedence when both are defined.
 
 Both ``ApiEnvironment`` and ``ApiRoute`` can define headers
 and query parameters, which are then merged. An environment
 can use this to define global data, while routes can define
 route-specific data. 
 */
public protocol ApiRoute: ApiRequestData {

    /**
     The HTTP method that should be used for the route.
     */
    var httpMethod: HttpMethod { get }

    /**
     The route's ``ApiEnvironment`` relative path, that will
     appended to the environment's url.
     */
    var path: String { get }

    /**
     Optional form data, which will be sent as request body.
     */
    var formParams: [String: String]? { get }
    
    /**
     Optional post data, which will be sent as request body.
     */
    var postData: Data? { get }
}

public extension ApiRoute {

    /**
     Convert ``encodedFormItems`` to `.utf8` encoded data.
     */
    var encodedFormData: Data? {
        guard let formParams, !formParams.isEmpty else { return nil }
        var params = URLComponents()
        params.queryItems = encodedFormItems
        let paramString = params.query
        return paramString?.data(using: .utf8)
    }

    /**
     Convert ``formParams`` to form encoded query items.
     */
    var encodedFormItems: [URLQueryItem]? {
        formParams?
            .map { URLQueryItem(name: $0.key, value: $0.value.formEncoded()) }
            .sorted { $0.name < $1.name }
    }

    /**
     This function returns a `URLRequest` that is configured
     for the given `httpMethod` and the route's `queryItems`.
     */
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
