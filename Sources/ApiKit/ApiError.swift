//
//  ApiError.swift
//  ApiKit
//
//  Created by Daniel Saidi on 2023-03-25.
//

import Foundation

/**
 This enum defines api-specific errors that can occur when
 communicating with an external api.
 */
public enum ApiError: Error {

    case noDataInResponse
}
