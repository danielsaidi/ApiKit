//
//  ApiEnvironment.swift
//  ApiKit
//
//  Created by Daniel Saidi on 2023-03-24.
//  Copyright © 2023 Daniel Saidi. All rights reserved.
//

import Foundation

/**
 This protocol can be implemented to define API environments
 or specific API versions.

 An ``ApiEnvironment`` must define a root ``url`` to which a
 route ``ApiRoute/path`` can be applied.
 
 You can use enums to define environments and use associated
 values to provide environment-specific parameters.

 Both ``ApiEnvironment`` and ``ApiRoute`` can define headers
 and query parameters. An environment can use this to define
 global data, while a route defines route-specific data.
 */
public protocol ApiEnvironment: ApiRequestData {

    /// The base URL of the environment.
    var url: String { get }
}
