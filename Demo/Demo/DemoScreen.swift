//
//  DemoScreen.swift
//  Demo
//
//  Created by Daniel Saidi on 2023-03-28.
//  Copyright © 2023-2025 Daniel Saidi. All rights reserved.
//

import SwiftUI

enum DemoScreen: Hashable, View {

    case theMovieDb(apiKey: String)
}

extension DemoScreen {

    var body: some View {
        switch self {
        case .theMovieDb(let apiKey): TheMovieDbScreen(apiKey: apiKey)
        }
    }
}
