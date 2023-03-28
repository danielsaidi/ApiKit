//
//  DemoEndpoint.swift
//  Demo
//
//  Created by Daniel Saidi on 2023-03-28.
//  Copyright © 2023 Daniel Saidi. All rights reserved.
//

import ApiKit
import Foundation

/**
 This endpoint can be used to integrate with TMDB, The Movie
 Database, and fetch movies to display in this demo app.

 You can register an API key at `https://themoviedb.org` and
 use it to setup the endpoint in `MoviesScreen`.
 */
enum TheMovieDbEndpoint: ApiEnvironment {

    case production(apiKey: String)

    var url: URL {
        guard let url = URL(string: "https://api.themoviedb.org/3/")
        switch
    }
}

/**
 These routes can be used with ``TheMovieDbEndpoint``.
 */
enum TheMovieDbRoute
