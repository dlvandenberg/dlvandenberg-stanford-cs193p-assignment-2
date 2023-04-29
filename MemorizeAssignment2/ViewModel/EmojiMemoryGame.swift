//
//  EmojiMemoryGame.swift
//  MemorizeAssignment2
//
//  Created by Dennis van den Berg on 28/04/2023.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    
    static let themes: [EmojiTheme] = [
        EmojiTheme(name: "Weather", colors: ["blue"], pairs: 6, emojis: ["☀️", "🌤️", "⛅️", "☁️", "🌦️", "🌧️", "🌩️"]),
        EmojiTheme(name: "Transport", colors: ["red"], emojis: ["🚗", "🚕", "🚙", "🚌", "🚎", "🚓", "🚒", "🚑"]),
        EmojiTheme(name: "Animals", colors: ["orange"], pairs: 5, emojis: ["🐶", "🐱", "🐭", "🦊", "🐻", "🐼"]),
        EmojiTheme(name: "Flags", colors: ["gray"], pairs: 10, emojis: ["🏴‍☠️", "🏁", "🏳️‍🌈", "🏳️‍⚧️", "🇺🇳", "🇦🇫", "🇨🇦", "🇱🇺", "🇱🇧", "🇱🇷", "🇳🇦", "🇳🇴", "🎌", "🇬🇱", "🇩🇪", "🇬🇮"]),
        // MARK: - Extra Credit 2. - Creating a Theme with a random number of pairs
        EmojiTheme.withRandomCards(name: "Food", colors: ["green"], emojis: ["🍔", "🍟", "🫑", "🍒", "🍏", "🍓", "🍖", "🥐", "🥞"]),
        // MARK: - Extra Credit 3. - Creating a Theme with a Gradient
        EmojiTheme(name: "Sports", colors: ["yellow", "red"], pairs: 9, emojis: ["⚽️", "🏀", "🏈", "⚾️", "🥎", "🏉", "🥏", "🎱", "🏏", "🏓", "🏒", "🏹", "🥊"])
    ]
    
    static func chooseTheme() -> EmojiTheme {
        EmojiMemoryGame.themes.randomElement()!
    }
    
    static func createMemoryGame(with theme: EmojiTheme) -> MemoryGame<String> {
        var numOfPairs = theme.pairs
        if numOfPairs < theme.emojis.count {
            numOfPairs = theme.emojis.count
        }
        
        let shuffledEmojis = theme.emojis.shuffled().unique()
        
        return MemoryGame<String>(numberOfPairsOfCards: numOfPairs) { pairIndex in
            shuffledEmojis[pairIndex]
        }
    }

    @Published private var model: MemoryGame<String>
    @Published private var activeTheme: EmojiTheme
    
    init() {
        let theme = EmojiMemoryGame.chooseTheme()
        model = EmojiMemoryGame.createMemoryGame(with: theme)
        activeTheme = theme
    }
    
    // MARK: - Available to View
    var cards: [MemoryGame<String>.Card] {
        model.cards
    }
    var themeName: String {
        activeTheme.name
    }
    
    // MARK: - Extra Credit 3. - Support Gradients 
    var themeColor: [Color] {
        var colors: [Color] = []
        for colorString in activeTheme.colors {
            switch colorString {
            case "blue": colors.append(Color.blue)
            case "red": colors.append(Color.red)
            case "orange": colors.append(Color.orange)
            case "green": colors.append(Color.green)
            case "gray": colors.append(Color.gray)
            case "purple": colors.append(Color.purple)
            case "yellow": colors.append(Color.yellow)
            default: colors.append(Color.red)
            }
        }
        return colors
    }
    var score: Int {
        model.score
    }
    
    // MARK: - Intent(s)
    func choose(_ card: MemoryGame<String>.Card) {
        model.chooseCard(card)
    }
    
    func newGame() {
        activeTheme = EmojiMemoryGame.chooseTheme()
        model = EmojiMemoryGame.createMemoryGame(with: activeTheme)
    }
}

