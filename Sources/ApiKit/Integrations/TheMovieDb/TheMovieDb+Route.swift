//
//  TheMovieDb+Route.swift
//  ApiKit
//
//  Created by Daniel Saidi on 2023-08-17.
//  Copyright © 2023-2026 Daniel Saidi. All rights reserved.
//

import Foundation

public extension TheMovieDb {

    /// This type defines supported TheMovieDb routes.
    enum Route: ApiRoute {
        
        public typealias Movie = TheMovieDb.Movie
        public typealias MoviesPaginationResult = TheMovieDb.MoviesPaginationResult

        case discoverMovies(page: Int, sortBy: String = "popularity")
        case movie(id: Int)
        case searchMovies(query: String, page: Int)
    }
}

public extension TheMovieDb.Route {

    var path: String {
        switch self {
        case .discoverMovies: "discover/movie"
        case .movie(let id): "movie/\(id)"
        case .searchMovies: "search/movie"
        }
    }

    var httpMethod: HttpMethod { .get }

    var headers: [String: String]? { nil }

    var formParams: [String: String]? { nil }

    var postData: Data? { nil }
    
    var queryParams: [String: String]? {
        switch self {
        case .discoverMovies(let page, let sortBy): [
            "language": "en-US",
            "sort-by": sortBy,
            "page": "\(page)"
        ]
        case .movie: nil
        case .searchMovies(let query, let page): [
            "query": query,
            "page": "\(page)"
        ]
        }
    }
    
    var returnType: Any? {
        switch self {
        case .discoverMovies: [Movie].self
        case .movie: Movie.self
        case .searchMovies: MoviesPaginationResult.self
        }
    }
}
