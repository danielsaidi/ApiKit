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

 An ``ApiRoute`` should define a relative ``path`` within an
 ``ApiEnvironment`` and an ``httpMethod`` to use when making
 the request. You can use enums to group related routes in a
 single enum, and use associated values to define route data
 such as id, name, search queries etc. and use the data when
 defining request data.

 When a route defines ``formParams``, the URL request should
 use `application/x-www-form-urlencoded` as content type and
 ignore the ``postData``. The two are mutually exclusive and
 ``formParams`` should take precedence when both are defined.

 Both ``ApiEnvironment`` and ``ApiRoute`` can define headers
 and query parameters that should be merged when the request
 is created. The environment can use this to define api keys,
 secrets etc. while the route can define route-specific data.
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
     Convert `formParams` to encoded, `.utf8` data.
     */
    var formData: Data? {
        guard let formParams, !formParams.isEmpty else { return nil }
        var params = URLComponents()
        params.queryItems = encodedFormItems
        let paramString = params.query
        return paramString?.data(using: .utf8)
    }

    /**
     This function returns a `URLRequest` that is configured
     for the given `httpMethod` and the route's `queryItems`.
     */
    func urlRequest(for env: ApiEnvironment) -> URLRequest {
        let url = env.url.appendingPathComponent(path)
        guard var components = URLComponents(
            url: url,
            resolvingAgainstBaseURL: true
        ) else { fatalError("TODO THROW: Could not create URLComponents for \(url.absoluteString)") }
        components.queryItems = encodedQueryItems
        guard let requestUrl = components.url else { fatalError("Could not create URLRequest for \(url.absoluteString)") }
        var request = URLRequest(url: requestUrl)
        request.allHTTPHeaderFields = headers
        request.httpBody = formData ?? postData
        request.httpMethod = httpMethod.method
        let isFormRequest = formData != nil
        let contentType = isFormRequest ? "application/x-www-form-urlencoded" : "application/json"
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        return request
    }
}

public extension ApiRoute {
    
    /**
     Form encoded and sorted ``formParams``.
     */
    var encodedFormItems: [URLQueryItem]? {
        formParams?
            .map { URLQueryItem(name: $0.key, value: $0.value.formEncoded()) }
            .sorted { $0.name < $1.name }
    }
}
