//
//  TheMovieDb+Route.swift
//  ApiKit
//
//  Created by Daniel Saidi on 2023-08-17.
//  Copyright © 2023-2024 Daniel Saidi. All rights reserved.
//

import Foundation

public extension TheMovieDb {

    /// This type defines supported TheMovieDb routes.
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
        case .discoverMovies: "discover/movie"
        case .movie(let id): "movie/\(id)"
        case .movieVideos(let id): "movie/\(id)/movies"
        case .searchMovies: "search/movie"
        }
    }

    var httpMethod: HttpMethod { .get }

    var headers: [String: String]? { nil }

    var formParams: [String: String]? { nil }

    var postData: Data? { nil }
    
    var queryParams: [String: String]? {
        switch self {
        case .discoverMovies(let page): ["language": "en-US", "sort-by": "popularity", "page": "\(page)"]
        case .movie: nil
        case .movieVideos: nil
        case .searchMovies(let query, let page): ["query": query, "page": "\(page)"]
        }
    }
}
