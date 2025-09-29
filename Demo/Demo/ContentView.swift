//
//  ContentView.swift
//  Demo
//
//  Created by Daniel Saidi on 2023-03-28.
//  Copyright © 2023-2025 Daniel Saidi. All rights reserved.
//

import ApiKit
import SwiftUI

struct ContentView: View {

    @AppStorage(Self.movieDbApiKey) var movieDbApiKey = ""
    @AppStorage(Self.yelpApiKey) var yelpApiKey = ""

    var body: some View {
        NavigationStack {
            List {
                screenSection(
                    title: "The Movie DB",
                    icon: "popcorn",
                    apiKey: $movieDbApiKey,
                    screen: .theMovieDb(apiKey: movieDbApiKey)
                )
                screenSection(
                    title: "Yelp",
                    icon: "fork.knife",
                    apiKey: $yelpApiKey,
                    screen: .yelp(apiKey: yelpApiKey)
                )
            }
            .navigationTitle("ApiKit")
            .navigationDestination(for: DemoScreen.self) { $0.body }
        }
    }
}

private extension ContentView {

    func screenSection(
        title: String,
        icon: String,
        apiKey: Binding<String>,
        screen: DemoScreen
    ) -> some View {
        Section {
            NavigationLink(value: screen) {
                Text("Explore")
            }
            TextField("Enter your API Key", text: apiKey)
        } header: {
            HStack {
                Image(systemName: icon)
                Text(title)
            }
        }
    }
}
#Preview {
    
    ContentView()
}
