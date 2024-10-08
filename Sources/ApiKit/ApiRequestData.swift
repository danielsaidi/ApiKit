//
//  ApiRequestData.swift
//  ApiKit
//
//  Created by Daniel Saidi on 2023-03-28.
//  Copyright © 2023-2024 Daniel Saidi. All rights reserved.
//

import Foundation

/// This protocol can be implemented by any types that could
/// be used to provide request data for a `URLRequest`.
public protocol ApiRequestData {

    /// Optional header parameters.
    var headers: [String: String]? { get }

    /// Optional query params.
    var queryParams: [String: String]? { get }
}

public extension ApiRequestData {

    /// Convert ``queryParams`` to url encoded query items.
    var encodedQueryItems: [URLQueryItem]? {
        queryParams?
            .map { URLQueryItem(name: $0.key, value: $0.value) }
            .sorted { $0.name < $1.name }
    }
}
