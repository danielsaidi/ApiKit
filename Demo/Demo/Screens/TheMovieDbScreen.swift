//
//  TheMovieDbScreen.swift
//  Demo
//
//  Created by Daniel Saidi on 2023-03-28.
//  Copyright © 2023-2026 Daniel Saidi. All rights reserved.
//

import ApiKit
import SwiftUI

struct TheMovieDbScreen: View {

    init(apiKey: String) {
        self.environment = .production(apiKey: apiKey)
    }

    let session = URLSession.shared
    let environment: TheMovieDb.Environment
    let gridColumns = [GridItem(.adaptive(minimum: 100), alignment: .top)]

    @StateObject
    private var model = ViewModel()

    typealias Item = TheMovieDb.Movie
    typealias ItemResult = TheMovieDb.MoviesPaginationResult

    class ViewModel: ObservableObject {

        @Published var defaultItems = [Item]()
        @Published var searchItems = [Item]()
        @Published var searchQuery = ""
    }

    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: gridColumns) {
                ForEach(items) {
                    gridItem(for: $0)
                }
            }
            .padding()
        }
        .task { fetchDefaultItems() }
        .searchable(text: $model.searchQuery)
        .onReceive(model.$searchQuery.throttle(
            for: 1,
            scheduler: RunLoop.main,
            latest: true
        ), perform: search)
        .navigationTitle("The Movie DB")
    }
}

extension TheMovieDbScreen {

    func gridItem(for item: Item) -> some View {
        VStack {
            AsyncImage(
                url: item.posterUrl(width: 300),
                content: { image in
                    image.resizable()
                        .cornerRadius(5)
                        .aspectRatio(contentMode: .fit)
                },
                placeholder: {
                    ProgressView()
                }
            )
            .accessibilityLabel(item.title)
        }
    }
}

extension TheMovieDbScreen {

    var items: [Item] {
        model.searchItems.isEmpty ? model.defaultItems : model.searchItems
    }

    func fetchDefaultItems() {
        Task {
            do {
                let result: ItemResult = try await session.request(
                    at: TheMovieDb.Route.discoverMovies(page: 1),
                    in: environment
                )
                updateDefaultItems(with: result)
            } catch {
                print(error)
            }
        }
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

    func search(with query: String) async throws -> ItemResult {
        try await session.request(
            at: TheMovieDb.Route.searchMovies(query: query, page: 1),
            in: environment
        )
    }
}

@MainActor
extension TheMovieDbScreen {

    func updateDefaultItems(with result: ItemResult) {
        model.defaultItems = result.results
    }

    func updateSearchResult(with result: ItemResult) {
        model.searchItems = result.results
    }
}

#Preview {

    struct Preview: View {

        @AppStorage(Self.movieDbApiKey) var apiKey = ""

        var body: some View {
            TheMovieDbScreen(apiKey: apiKey)
                #if os(macOS)
                .frame(minWidth: 500)
                #endif
        }
    }

    return Preview()
}
