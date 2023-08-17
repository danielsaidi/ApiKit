//
//  Yelp+Environment.swift
//  ApiKit
//
//  Created by Daniel Saidi on 2023-08-17.
//  Copyright © 2023 Daniel Saidi. All rights reserved.
//

import Foundation

public extension Yelp {

    enum ApiEnvironment: ApiKit.ApiEnvironment {

        case v3(apiToken: String)
    }
}

public extension Yelp.ApiEnvironment {
    
    var url: String {
        switch self {
        case .v3: return "https://api.yelp.com/v3/"
        }
    }
 
    var headers: [String: String]? {
        switch self {
        case .v3(let apiToken):
            return ["Authorization": "Bearer \(apiToken)"]
        }
    }
    
    var queryParams: [String: String]? {
        [:]
    }
}
