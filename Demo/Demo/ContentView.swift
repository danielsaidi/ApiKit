//
//  ContentView.swift
//  Demo
//
//  Created by Daniel Saidi on 2023-03-28.
//  Copyright © 2023 Daniel Saidi. All rights reserved.
//

import ApiKit
import SwiftUI

struct ContentView: View {

    var body: some View {
        NavigationStack {
            List {
                NavigationLink("The Movie DB", value: DemoScreen.theMovieDb)
            }
            .navigationTitle("ApiKit")
            .navigationDestination(for: DemoScreen.self, destination: view)
        }
    }
}

extension ContentView {

    @ViewBuilder
    func view(for screen: DemoScreen) -> some View {
        switch screen {
        case .theMovieDb: TheMovieDbScreen()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
