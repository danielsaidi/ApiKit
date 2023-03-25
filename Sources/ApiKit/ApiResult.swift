//
//  ApiResult.swift
//  ApiKit
//
//  Created by Daniel Saidi on 2023-03-25.
//

import Foundation

/**
 This type is used by ``ApiClient``.
 */
public struct ApiResult {

    var data: Data?
    var response: URLResponse?
}
