//
//  MemoryGame.swift
//  MemorizeAssignment2
//
//  Created by Dennis van den Berg on 28/04/2023.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: [Card]
    private var indexOfOneAndOnlyFaceUpCard: Int?
    private(set) var score: Int
    private var alreadySeenCardIndices: Set<Int>
    private var datetimeOnLastTurn: Date?
    
    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
        cards = []
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = createCardContent(pairIndex)
            cards.append(Card(id: (pairIndex*2), content: content))
            cards.append(Card(id: (pairIndex*2+1), content: content))
        }
        cards.shuffle()
        score = 0
        alreadySeenCardIndices = Set()
    }
    
    mutating func chooseCard(_ card: Card) {
        if let cardIndex = cards.firstIndex(where: { $0.id == card.id }),
           !cards[cardIndex].isFaceUp,
           !cards[cardIndex].isMatched
        {
            
            // MARK: - Extra Credit 4. - Bonus multiplier for quick pairs
            // Will grant a bonus multiplier for choosing pairs fast. But it also applies to the penalties given for mismatches with cards that have already been turned before.
            var secondsSinceLastTurn: TimeInterval?
            if let lastTurnedCardOn = datetimeOnLastTurn {
                secondsSinceLastTurn = Date.now.timeIntervalSince(lastTurnedCardOn)
            }
            
            if let potentialMatchIndex = indexOfOneAndOnlyFaceUpCard {
                var bonusMultiplier = calculateBonus(withSecondsSinceLastCardTurn: secondsSinceLastTurn)
                print("Bonus multiplier: \(bonusMultiplier)")
                
                // Second card selection -- Check for potential match
                if cards[cardIndex].content == cards[potentialMatchIndex].content {
                    cards[cardIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                    
                    score += 2 * Int(bonusMultiplier)
                    print("Found a match!")
                } else {
                    // Mismatch. Penalty for each card that has been already seen
                    let alreadySeenCards = alreadySeenCardIndices.filter({ $0 == cardIndex || $0 == potentialMatchIndex }).count
                    if alreadySeenCards > 0 {
                        print("\(alreadySeenCards) involved in mismatch has been seen already.")
                        
                        score -= alreadySeenCards * Int(bonusMultiplier)
                    }
                }
                indexOfOneAndOnlyFaceUpCard = nil
            } else {
                // New card selection -- Turn all cards face down
                for index in cards.indices {
                    // If card was not matched, but face up, mark as 'seen'
                    if cards[index].isFaceUp && !cards[index].isMatched {
                        alreadySeenCardIndices.insert(index)
                        print("Card involved in mismatch, marking it as 'seen': \(cards[index])")
                    }
                    cards[index].isFaceUp = false
                }
                indexOfOneAndOnlyFaceUpCard = cardIndex
            }
            
            cards[cardIndex].isFaceUp.toggle()
            datetimeOnLastTurn = Date.now
        }
    }
    
    func calculateBonus(withSecondsSinceLastCardTurn interval: TimeInterval?) -> Double {
        Double.maximum(10 - (interval ?? 9), 1)
    }
    
    struct Card: Identifiable {
        var id: Int
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var content: CardContent
    }
}
