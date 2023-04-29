//
//  MemorizeView.swift
//  MemorizeAssignment2
//
//  Created by Dennis van den Berg on 28/04/2023.
//

import SwiftUI

struct MemorizeView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    
    var body: some View {
        VStack {
            TopBarView(score: viewModel.score, theme: viewModel.themeName) {
                viewModel.newGame()
            }
            
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 75))]) {
                    ForEach(viewModel.cards) { card in
                        CardView(card, colors: viewModel.themeColor)
                            .aspectRatio(2/3, contentMode: .fit)
                            .onTapGesture {
                                viewModel.choose(card)
                            }
                    }
                }
            }
        }
       .padding(.horizontal)
    }
}

struct TopBarView: View {
    var score: Int
    var theme: String
    var newGame: () -> Void
    
    var body: some View {
        HStack(alignment: .center) {
            Text("Score: \(score)")
            
            Spacer()
            
            Text(theme)
                .font(.title)
            
            Spacer()
            
            Button("New Game") {
                newGame()
            }
        }
    }
}

struct CardView: View {
    let card: MemoryGame<String>.Card
    let colors: [Color]
    
    init(_ card: MemoryGame<String>.Card, colors: [Color]) {
        self.card = card
        self.colors = colors
    }
    
    var body: some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 20)
            
            if card.isFaceUp {
                shape.fill().foregroundColor(.white)
                
                shape.strokeBorder(lineWidth: 3)
                
                Text(card.content)
                    .font(.largeTitle)
                    .frame(width: /*@START_MENU_TOKEN@*/80.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/80.0/*@END_MENU_TOKEN@*/)
            } else if card.isMatched {
                shape.opacity(0)
            } else {
                if colors.count == 1 {
                    shape
                        .fill()
                        .foregroundColor(colors[0])
                } else {
                    shape.fill(LinearGradient(colors: colors, startPoint: .top, endPoint: .bottom))
                }
                
            }
        }
    }
}


struct MemorizeView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        MemorizeView(viewModel: game)
            .preferredColorScheme(.dark)
    }
}

