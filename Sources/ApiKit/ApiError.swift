//
//  ApiError.swift
//  ApiKit
//
//  Created by Daniel Saidi on 2023-03-25.
//  Copyright © 2023-2025 Daniel Saidi. All rights reserved.
//

import Foundation

/// This enum defines api-specific errors that can be thrown
/// when an ``ApiClient`` communicates with any external API.
public enum ApiError: Error, Equatable, LocalizedError {
    
    /// This error should be thrown when an ``ApiEnvironment``
    /// has a url that can't be used to generate a `URL`.
    case invalidEnvironmentUrl(String)

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

    /// A custom localized description.
    var localizedDescription: String {
        switch self {
        case .invalidEnvironmentUrl: "Invalid Environment Url"
        case .invalidHttpStatusCode: "Invalid HTTP Status Code"
        case .noUrlInComponents: "No URL In Components"
        case .failedToCreateComponentsFromUrl: "Failed To Create Components From Url"
        case .unsuccessfulHttpStatusCode: "Unsuccessful HTTP Status Code"
        }
    }
}

public extension ApiError {
    
    /// Whether the error is a ``ApiError/invalidHttpStatusCode(_:_:_:_:)``
    var isInvalidHttpStatusCodeError: Bool {
        switch self {
        case .invalidHttpStatusCode: true
        default: false
        }
    }
    
    /// Whether the error is a ``ApiError/invalidHttpStatusCode(_:_:_:_:)``
    var isUnsuccessfulHttpStatusCodeError: Bool {
        switch self {
        case .unsuccessfulHttpStatusCode: true
        default: false
        }
    }
}
