//
//  ApiRoute.swift
//  ApiKit
//
//  Created by Daniel Saidi on 2023-03-24.
//  Copyright © 2023 Daniel Saidi. All rights reserved.
//

import Foundation

/**
 This protocol can be used to define API routes.

 Each route should define all information required to make a
 request to an API endpoint, including the ``HttpMethod`` to
 use, an environment root-relative path, request data etc.

 Routes can also specify ``formParams`` which are parameters
 that are send as URL encoded data within a request body. If
 this property defines any parameters, the URL requests will
 be setup to use `application/x-www-form-urlencoded` instead
 of `application/json` as content type.
 */
public protocol ApiRoute {

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
     The route's optional post data dictionary, which should
     be added as a .utf8 encoded `httpBody` data string when
     performing a request.
     */
    var formParams: [String: String] { get }
    
    /**
     The route's optional post data, that should be added as
     `httpBody` when performing a request. When defined, the
     property takes precedence over `postParams`.
     */
    var postData: Data? { get }
    
    /**
     The route's optional query data dictionary, that should
     be added as a .utf8 encoded `httpBody` data string when
     performing a request.
     */
    var queryParams: [String: String] { get }
}

public extension ApiRoute {

    /**
     Convert `formParams` to encoded, `.utf8` data.
     */
    var formData: Data? {
        if formParams.isEmpty { return nil }
        var params = URLComponents()
        params.queryItems = formParams
            .map { URLQueryItem(name: $0.key, value: $0.value.formEncoded()) }
            .sorted { $0.name < $1.name }
        let paramString = params.query
        return paramString?.data(using: .utf8)
    }
    
    /**
     The route's query items, which are mapped `queryParams`.
     */
    var queryItems: [URLQueryItem] {
        queryParams
            .map { URLQueryItem(name: $0.key, value: $0.value.urlEncoded()) }
            .sorted { $0.name < $1.name }
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
        components.queryItems = queryItems
        guard let requestUrl = components.url else { fatalError("Could not create URLRequest for \(url.absoluteString)") }
        var request = URLRequest(url: requestUrl)
        request.httpBody = formData ?? postData
        request.httpMethod = httpMethod.method
        let isFormRequest = formData != nil
        let contentType = isFormRequest ? "application/x-www-form-urlencoded" : "application/json"
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        return request
    }
}
