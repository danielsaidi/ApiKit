//
//  TheMovieDb+Environment.swift
//  ApiKit
//
//  Created by Daniel Saidi on 2023-08-17.
//  Copyright © 2023 Daniel Saidi. All rights reserved.
//

import Foundation

public extension TheMovieDb {

    enum ApiEnvironment: ApiKit.ApiEnvironment {

        case production(apiKey: String)
    }
}

public extension TheMovieDb.ApiEnvironment {
 
    var url: String {
        switch self {
        case .production: return "https://api.themoviedb.org/3"
        }
    }

    var headers: [String: String]? { nil }

    var queryParams: [String: String]? {
        switch self {
        case .production(let key): return ["api_key": key]
        }
    }
}
