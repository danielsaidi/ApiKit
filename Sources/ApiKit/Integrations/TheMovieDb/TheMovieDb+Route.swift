//
//  TheMovieDb+Route.swift
//  ApiKit
//
//  Created by Daniel Saidi on 2023-08-17.
//  Copyright © 2023 Daniel Saidi. All rights reserved.
//

import Foundation

public extension TheMovieDb {

    enum Route: ApiRoute {

        case discoverMovies(page: Int)
        case movie(id: Int)
        case movieVideos(id: Int)
        case searchMovies(query: String, page: Int)
    }
}

public extension TheMovieDb.Route {

    var path: String {
        switch self {
        case .discoverMovies: return "discover/movie"
        case .movie(let id): return "movie/\(id)"
        case .movieVideos(let id): return "movie/\(id)/movies"
        case .searchMovies: return "search/movie"
        }
    }

    var httpMethod: HttpMethod { .get }

    var headers: [String: String]? { nil }

    var formParams: [String: String]? { nil }

    var postData: Data? { nil }
    
    var queryParams: [String: String]? {
        switch self {
        case .discoverMovies(let page): return ["language": "en-US", "sort-by": "popularity", "page": "\(page)"]
        case .movie: return nil
        case .movieVideos: return nil
        case .searchMovies(let query, let page): return ["query": query, "page": "\(page)"]
        }
    }
}
