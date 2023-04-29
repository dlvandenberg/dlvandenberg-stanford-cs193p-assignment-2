//
//  EmojiTheme.swift
//  MemorizeAssignment2
//
//  Created by Dennis van den Berg on 28/04/2023.
//

import Foundation

struct EmojiTheme {
    private(set) var name: String
    private(set) var colors: [String]
    private(set) var pairs: Int
    private(set) var emojis: [String]
    
    init(name: String, colors: [String], pairs: Int, emojis: [String]) {
        self.name = name
        self.colors = colors
        self.emojis = emojis
        self.pairs = pairs
    }
    
    /*
     MARK: - Extra Credit 1.
     If `pairs` is not passed, the number of pairs will default to the passed `emoji` count.
     */
    init(name: String, colors: [String], emojis: [String]) {
        self.init(name: name, colors: colors, pairs: emojis.count, emojis: emojis)
    }
    
    // MARK: - Extra Credit 2. - Allowing creating of a Theme with a random number of pairs
    static func withRandomCards(name: String, colors: [String], emojis: [String]) -> EmojiTheme {
        let numOfPairs = Int.random(in: 2..<emojis.count)
        return EmojiTheme(name: name, colors: colors, pairs: numOfPairs, emojis: emojis)
    }
}
