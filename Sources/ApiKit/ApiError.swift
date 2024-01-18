//
//  ApiError.swift
//  ApiKit
//
//  Created by Daniel Saidi on 2023-03-25.
//  Copyright © 2023 Daniel Saidi. All rights reserved.
//

import Foundation

/**
 This enum defines api-specific errors that can occur when a
 client communicates with an external API.
 */
public enum ApiError: Error, Equatable, LocalizedError {
    
    /// This error should be thrown when an ``ApiEnvironment``
    /// has a url that can't be used to generate a `URL`.
    case invalidEnvironmentUrl(String)
    
    /// This error should be thrown when a URL request fails
    /// because of an invalid response status code.
    case invalidResponseStatusCode(Int, URLRequest, URLResponse, Data)

    /// This error should be thrown when a `URLRequest` will
    /// fail to be created due to invalid `URLComponents`.
    case noUrlInComponents(URLComponents)

    /// This error should be thrown when a `URLRequest` will
    /// fail to be created due to an invalid `URL`.
    case failedToCreateComponentsFromUrl(URL)
}
