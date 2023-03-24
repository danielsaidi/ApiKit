//
//  ApiRoute.swift
//  SwiftKit
//
//  Created by Daniel Saidi on 2023-03-24.
//  Copyright © 2023 Daniel Saidi. All rights reserved.
//

import Foundation

/**
 This protocol represents an external api route, e.g. `login`
 or `user`. Each route is a separate action that defines all
 information required to perform an api request.
 */
public protocol ApiRoute {
    
    /**
     The route's environment-relative path, that is appended
     to the environment's url when performing a request.
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
     Create a `URLRequest` that is configured for being used
     with `Content-Type` `application/x-www-form-urlencoded`.
     */
    func formRequest(for env: ApiEnvironment) -> URLRequest {
        var req = urlRequest(for: env, httpMethod: .post)
        req.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        req.httpBody = formRequestData
        return req
    }

    /**
     Convert ``formParams`` to encoded, `.utf8` data.
     */
    var formRequestData: Data? {
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
     The route's url in a certain api environment.
     */
    func url(
        in environment: ApiEnvironment
    ) -> URL {
        environment.url.appendingPathComponent(path)
    }

    /**
     This function returns a `URLRequest` that is configured
     for the given `httpMethod` and the route's `queryItems`.
     */
    func urlRequest(
        for env: ApiEnvironment,
        httpMethod: HttpMethod = .get
    ) -> URLRequest {
        let url = self.url(in: env)
        guard var components = URLComponents(
            url: url,
            resolvingAgainstBaseURL: true
        ) else { fatalError("TODO THROW: Could not create URLComponents for \(url.absoluteString)") }
        components.queryItems = queryItems
        guard let requestUrl = components.url else { fatalError("Could not create URLRequest for \(url.absoluteString)") }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = httpMethod.method
        request.httpBody = postData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
}
