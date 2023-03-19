//
//  MemoryMatchView.swift
//  MemoryMatch
//
//  Created by Ogbemudia Terry Osayawe on 19.03.23.
//

import SwiftUI

struct MemoryMatchView: View {
    @EnvironmentObject var userSettings: UserSettings
    @ObservedObject var viewModel: MemoryMatchViewModel
    
    var gridSize: Int {
        Int(sqrt(Double(viewModel.difficulty.rawValue)))
    }
    
    private func shakeCard(at index: Int) -> Bool {
        return viewModel.isGameReady && viewModel.flippedCards.count == 2 && !viewModel.cardsMatch() && viewModel.flippedCards.contains(index)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Memory Match")
                    .font(.largeTitle)
                    .bold()
                
                if viewModel.isGameReady {
                    gameContent
                } else {
                    startButton
                }
            }
            .padding()
            .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
            .navigationBarItems(trailing: settingsButton)
            .alert(isPresented: $viewModel.showAlert) {
                gameEndAlert
            }
            .onDisappear {
                self.viewModel.stopTimer()
            }
        }
    }
    
    private var gameContent: some View {
        VStack {
            scoreAndTimeBar
            gameGrid
        }
    }
    
    private var scoreAndTimeBar: some View {
        HStack {
            Text("Score: \(self.viewModel.score)").font(.headline)
            Text("Matched Pairs: \(self.viewModel.matchedPairs.count)").font(.headline)
            Spacer()
            Text("Time: \(Int(self.viewModel.timeElapsed))s").font(.headline)
        }
        .padding(.horizontal)
    }
    
    private var gameGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.adaptive(minimum: 100, maximum: 100), spacing: 16), count: gridSize), spacing: 16) {
            ForEach(0..<self.viewModel.cardData.count, id: \.self) { index in
                Card(faceUp: self.viewModel.flippedCards.contains(index) || self.viewModel.matchedPairs.contains(self.viewModel.cardData[index] % (self.viewModel.difficulty.rawValue / 2))) {
                    Image("\(viewModel.theme.rawValue)_\(self.viewModel.cardData[index] % (self.viewModel.difficulty.rawValue / 2))")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .scaledToFit()
                        .padding(4)
                }
                .onTapGesture {
                    self.viewModel.handleCardTap(index: index)
                }
                .modifier(ShakeEffect(amount: shakeCard(at: index) ? 6 : 0, times: 2, current: shakeCard(at: index) ? 1 : 0))
            }
        }
        .padding(.horizontal)
    }
    
    private var startButton: some View {
        Button(action: {
            self.viewModel.prepareGame()
            self.viewModel.startGame()
        }) {
            Text("Start")
                .font(.title)
                .bold()
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }
    
    private var settingsButton: some View {
        HStack {
            NavigationLink(destination: DifficultySelectionView()) {
                Text("Settings")
            }
            Text("Difficulty: \(self.viewModel.difficulty.description)")
        }
    }
    
    private var gameEndAlert: Alert {
        if self.viewModel.matchedPairs.count == self.viewModel.difficulty.rawValue / 2 {
            return Alert(title: Text("Congratulations!"),
                         message: Text("You've matched all \(self.viewModel.matchedPairs.count) pairs in \(Int(self.viewModel.timeElapsed)) seconds. Your score is \(self.viewModel.score)."),
                         primaryButton: .default(Text("Restart")) {
                            self.viewModel.restartGame()
                         },
                         secondaryButton: .cancel {
                            viewModel.isGameReady = false
                         })
        } else {
            return Alert(title: Text("Time's Up!"),
                         message: Text("You've matched \(self.viewModel.matchedPairs.count) out of \(self.viewModel.difficulty.rawValue / 2) pairs. Your score is \(self.viewModel.score)."),
                         primaryButton: .default(Text("Restart")) {
                            self.viewModel.restartGame()
                         },
                         secondaryButton: .cancel {
                            viewModel.isGameReady = false
                         })
        }
    }
}

struct MemoryMatchView_Previews: PreviewProvider {
    @StateObject static var viewModel = MemoryMatchViewModel(difficulty: .easy, theme: .objects)
    
    static var previews: some View {
        MemoryMatchView(viewModel: viewModel)
    }
}

