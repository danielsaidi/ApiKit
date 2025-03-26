//
//  TheMovieDbScreen.swift
//  Demo
//
//  Created by Daniel Saidi on 2023-03-28.
//  Copyright © 2023-2024 Daniel Saidi. All rights reserved.
//

import ApiKit
import SwiftUI

struct TheMovieDbScreen: View {

    static let apiKey = DemoKeys.theMovieDb

    let session = URLSession.shared
    let environment = Environment.production(apiKey: Self.apiKey)
    let gridColumns = [GridItem(.adaptive(minimum: 100), alignment: .top)]

    @StateObject
    private var model = ViewModel()

    typealias Environment = TheMovieDb.Environment
    typealias Route = TheMovieDb.Route
    typealias Movie = TheMovieDb.Movie
    typealias MovieResult = TheMovieDb.MoviesPaginationResult

    class ViewModel: ObservableObject {

        @Published var discoverMovies = [Movie]()
        @Published var searchMovies = [Movie]()
        @Published var searchQuery = ""
    }

    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: gridColumns) {
                ForEach(movies) { movie in
                    gridItem(for: movie)
                }
            }.padding()
        }
        .task { fetchDiscoverData() }
        .searchable(text: $model.searchQuery)
        .onReceive(model.$searchQuery.throttle(for: 1, scheduler: RunLoop.main, latest: true), perform: search)
        .navigationTitle("The Movie DB")
    }
}

extension TheMovieDbScreen {

    func gridItem(for movie: Movie) -> some View {
        VStack {
            AsyncImage(
                url: movie.posterUrl(width: 300),
                content: { image in
                    image.resizable()
                        .cornerRadius(5)
                        .aspectRatio(contentMode: .fit)
                },
                placeholder: {
                    ProgressView()
                }
            ).accessibilityLabel(movie.title)
        }
    }
}

extension TheMovieDbScreen {

    var movies: [Movie] {
        model.searchMovies.isEmpty ? model.discoverMovies : model.searchMovies
    }

    func fetchDiscoverData() {
        Task {
            do {
                let result = try await fetchDiscoverData()
                updateDiscoverResult(with: result)
            } catch {
                print(error)
            }
        }
    }

    func fetchDiscoverData() async throws -> MovieResult {
        try await session.request<MovieResult>(
            at: Route.discoverMovies(page: 1),
            in: environment,
            decoder: nil
        )
    }

    func search(with query: String) {
        Task {
            do {
                let result = try await search(with: query)
                updateSearchResult(with: result)
            } catch {
                print(error)
            }
        }
    }

    func search(with query: String) async throws -> MovieResult {
        try await session.request(
            at: Route.searchMovies(query: query, page: 1),
            in: environment
        )
    }
}

@MainActor
extension TheMovieDbScreen {

    func updateDiscoverResult(with result: MovieResult) {
        model.discoverMovies = result.results
    }

    func updateSearchResult(with result: MovieResult) {
        model.searchMovies = result.results
    }
}

#Preview {
    
    TheMovieDbScreen()
        #if os(macOS)
        .frame(minWidth: 500)
        #endif
}
