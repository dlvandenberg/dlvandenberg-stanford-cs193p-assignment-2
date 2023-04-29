//
//  MemorizeAssignment2App.swift
//  MemorizeAssignment2
//
//  Created by Dennis van den Berg on 28/04/2023.
//

import SwiftUI

@main
struct MemorizeAssignment2App: App {
    let game = EmojiMemoryGame()
    var body: some Scene {
        WindowGroup {
            MemorizeView(viewModel: game)
        }
    }
}
