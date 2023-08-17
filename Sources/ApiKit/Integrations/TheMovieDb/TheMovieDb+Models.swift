//
//  TheMovieDb+Models.swift
//  ApiKit
//
//  Created by Daniel Saidi on 2023-08-17.
//  Copyright © 2023 Daniel Saidi. All rights reserved.
//

import Foundation

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
