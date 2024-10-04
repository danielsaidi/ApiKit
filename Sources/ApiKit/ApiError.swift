//
//  ApiError.swift
//  ApiKit
//
//  Created by Daniel Saidi on 2023-03-25.
//  Copyright © 2023-2024 Daniel Saidi. All rights reserved.
//

import Foundation

/// This enum defines api-specific errors that can be thrown
/// when an ``ApiClient`` communicates with any external API.
public enum ApiError: Error, Equatable, LocalizedError {
    
    /// This error should be thrown when an ``ApiEnvironment``
    /// has a url that can't be used to generate a `URL`.
    case invalidEnvironmentUrl(String)
    
    @available(*, deprecated, renamed: "unsuccessfulHttpStatusCode")
    case invalidResponseStatusCode(Int, URLRequest, URLResponse, Data)

    /// This error should be thrown when a URL request fails
    /// due to an invalid status code (outside of 100-599).
    case invalidHttpStatusCode(Int, URLRequest, URLResponse, Data)

    /// This error should be thrown when a `URLRequest` will
    /// fail to be created due to invalid `URLComponents`.
    case noUrlInComponents(URLComponents)

    /// This error should be thrown when a `URLRequest` will
    /// fail to be created due to an invalid `URL`.
    case failedToCreateComponentsFromUrl(URL)

    /// This error should be thrown when a URL request fails
    /// due to an unsuccessful status code (100-199, as well
    /// as 300-599).
    case unsuccessfulHttpStatusCode(Int, URLRequest, URLResponse, Data)
}

public extension ApiError {

    @available(*, deprecated, message: "This will be removed in 1.0. Switch over the error and use `unsuccessfulHttpStatusCode` instead.")
    var isInvalidResponseStatusCode: Bool {
        switch self {
        case .unsuccessfulHttpStatusCode: true
        default: false
        }
    }
}
