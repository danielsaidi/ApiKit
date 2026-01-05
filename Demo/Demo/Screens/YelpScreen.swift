//
//  YelpScreen.swift
//  Demo
//
//  Created by Daniel Saidi on 2025-09-29.
//  Copyright © 2025-2026 Daniel Saidi. All rights reserved.
//

import ApiKit
import SwiftUI

struct YelpScreen: View {

    init(apiKey: String) {
        self.environment = .v3(apiToken: apiKey)
    }

    let session = URLSession.shared
    let environment: Yelp.Environment
    let gridColumns = [GridItem(.adaptive(minimum: 100), alignment: .top)]

    @StateObject
    private var model = ViewModel()

    typealias Item = Yelp.Restaurant
    typealias ItemResult = Yelp.RestaurantSearchResult

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
            }.padding()
        }
        .task { fetchDefaultItems() }
//        .searchable(text: $model.searchQuery)
//        .onReceive(model.$searchQuery.throttle(
//            for: 1,
//            scheduler: RunLoop.main,
//            latest: true
//        ), perform: search)
        .navigationTitle("Yelp")
    }
}

extension YelpScreen {

    func gridItem(for item: Item) -> some View {
        VStack {
            AsyncImage(
                url: item.imageUrl?.url,
                content: { image in
                    image.resizable()
                        .cornerRadius(5)
                        .aspectRatio(contentMode: .fit)
                },
                placeholder: {
                    ProgressView()
                }
            )
            .accessibilityLabel(item.name ?? item.id)
        }
    }
}

private extension String {

    var url: URL? {
        .init(string: self)
    }
}

extension YelpScreen {

    var items: [Item] {
        model.searchItems.isEmpty ? model.defaultItems : model.searchItems
    }

    func fetchDefaultItems() {
        Task {
            do {
                let result: ItemResult = try await session.request(
                    at: Yelp.Route.search(
                        params: .init(
                            skip: 0,
                            take: 25,
                            radius: 5_000,
                            coordinate: (lat: 59.3327, long: 18.0645)
                        )
                    ),
                    in: environment
                )
                updateDefaultItems(with: result)
            } catch {
                print(error)
            }
        }
    }
}

@MainActor
extension YelpScreen {

    func updateDefaultItems(with result: ItemResult) {
        model.defaultItems = result.businesses
    }
}

#Preview {

    struct Preview: View {

        @AppStorage(Self.yelpApiKey) var apiKey = ""

        var body: some View {
            YelpScreen(apiKey: apiKey)
                #if os(macOS)
                .frame(minWidth: 500)
                #endif
        }
    }

    return Preview()
}
