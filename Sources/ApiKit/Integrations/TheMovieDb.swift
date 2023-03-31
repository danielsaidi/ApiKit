//
//  TheMovieDb.swift
//  ApiKit
//
//  Created by Daniel Saidi on 2023-03-28.
//  Copyright © 2023 Daniel Saidi. All rights reserved.
//

import Foundation

/**
 This namespace contains a TMDB-specific set of environments,
 routes and data types.

 This namespace is currently quite limited in scope and only
 includes what we use in the demo app. Feel free to add more
 things to it, as well as more integrations.

 You can setup an api account at `https://themoviedb.org` to
 start using these types with ApiKit.
 */
public struct TheMovieDb {}


// MARK: - Environment

public extension TheMovieDb {

    enum Environment: ApiEnvironment {

        case production(apiKey: String)

        public var url: String {
            switch self {
            case .production: return "https://api.themoviedb.org/3"
            }
        }

        public var headers: [String: String]? { nil }

        public var queryParams: [String: String]? {
            switch self {
            case .production(let key): return ["api_key": key]
            }
        }
    }
}


// MARK: - Route

public extension TheMovieDb {

    enum Route: ApiRoute {

        case discoverMovies(page: Int)
        case movie(id: Int)
        case movieVideos(id: Int)
        case searchMovies(query: String, page: Int)

        public var path: String {
            switch self {
            case .discoverMovies: return "discover/movie"
            case .movie(let id): return "movie/\(id)"
            case .movieVideos(let id): return "movie/\(id)/movies"
            case .searchMovies: return "search/movie"
            }
        }

        public var queryParams: [String: String]? {
            switch self {
            case .discoverMovies(let page): return ["language": "en-US", "sort-by": "popularity", "page": "\(page)"]
            case .movie: return nil
            case .movieVideos: return nil
            case .searchMovies(let query, let page): return ["query": query, "page": "\(page)"]
            }
        }

        public var httpMethod: HttpMethod { .get }

        public var headers: [String: String]? { nil }

        public var formParams: [String: String]? { nil }

        public var postData: Data? { nil }
    }
}


// MARK: - Types

public extension TheMovieDb {

    struct Movie: Codable, Identifiable {
        public let id: Int
        public let imdbId: String?
        public let title: String
        public let originalTitle: String?
        public let originalLanguage: String?
        public let overview: String?
        public let tagline: String?
        public let genres: [MovieGenre]?

        public let releaseDate: String?
        public let budget: Int?
        public let runtime: Int?
        public let revenue: Int?
        public let popularity: Double?
        public let averateRating: Double?

        public let homepageUrl: String?
        public let backdropPath: String?
        public let posterPath: String?

        public let belongsToCollection: Bool?
        public let isAdultMovie: Bool?

        enum CodingKeys: String, CodingKey {
            case id
            case imdbId = "imdb_id"
            case title
            case originalTitle
            case originalLanguage
            case overview
            case tagline
            case genres

            case releaseDate = "release_date"
            case budget
            case runtime
            case revenue
            case popularity
            case averateRating = "vote_averate"

            case homepageUrl = "homepage"
            case backdropPath = "backdrop_path"
            case posterPath = "poster_path"

            case belongsToCollection = "belongs_to_collection"
            case isAdultMovie = "adult"
        }

        public func backdropUrl(width: Int) -> URL? {
            imageUrl(path: backdropPath ?? "", width: width)
        }

        public func posterUrl(width: Int) -> URL? {
            imageUrl(path: posterPath ?? "", width: width)
        }

        func imageUrl(path: String, width: Int) -> URL? {
            URL(string: "https://image.tmdb.org/t/p/w\(width)" + path)
        }
    }

    struct MovieGenre: Codable, Identifiable {
        public let id: Int
        public let name: String
    }

    struct MoviesPaginationResult: Codable {
        public let page: Int
        public let results: [Movie]
        public let totalPages: Int
        public let totalResults: Int

        enum CodingKeys: String, CodingKey {
            case page
            case results
            case totalPages = "total_pages"
            case totalResults = "total_results"
        }
    }
}
