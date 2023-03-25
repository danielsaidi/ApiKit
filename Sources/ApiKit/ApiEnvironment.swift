//
//  ApiEnvironment.swift
//  ApiKit
//
//  Created by Daniel Saidi on 2023-03-24.
//  Copyright © 2023 Daniel Saidi. All rights reserved.
//

import Foundation

/**
 This protocol represents an API environment with a specific
 root `url`, e.g. test, staging or production.
 */
public protocol ApiEnvironment {
    
    var url: URL { get }
}

public extension ApiEnvironment {

    /**
     Create a `URLRequest` that is configured for being used
     with `Content-Type` `application/x-www-form-urlencoded`.
     */
    func formRequest(for route: ApiRoute) -> URLRequest {
        route.formRequest(for: self)
    }

    /**
     This function returns a `URLRequest` that is configured
     for the given `httpMethod` and the route's `queryItems`.
     */
    func urlRequest(for route: ApiRoute) -> URLRequest {
        route.urlRequest(for: self)
    }
}
