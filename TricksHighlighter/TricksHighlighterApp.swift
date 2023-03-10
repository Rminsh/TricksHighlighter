//
//  TricksHighlighterApp.swift
//  TricksHighlighter
//
//  Created by Armin on 7/5/22.
//

import SwiftUI

@main
struct TricksHighlighterApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .commands {
            TextFormattingCommands()
        }
        #if os(macOS)
        .windowStyle(.hiddenTitleBar)
        .windowToolbarStyle(.unified)
        #endif
    }
}
