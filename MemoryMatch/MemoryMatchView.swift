//
//  MemoryMatchView.swift
//  MemoryMatch
//
//  Created by Ogbemudia Terry Osayawe on 19.03.23.
//

import SwiftUI
import AVFoundation

struct MemoryMatchView: View {
    @EnvironmentObject var userSettings: UserSettings
    @ObservedObject var viewModel: MemoryMatchViewModel
    @State private var isMuted = false
    
    private let hapticGenerator = UINotificationFeedbackGenerator()
    
    private let cardFlipSound = Bundle.main.url(forResource: "cardFlip", withExtension: "mp3")
    private let matchSound = Bundle.main.url(forResource: "match", withExtension: "mp3")
    
    private let soundManager = SoundManager()
    
    var gridSize: Int {
        Int(sqrt(Double(viewModel.difficulty.rawValue)))
    }
    
    private func shakeCard(at index: Int) -> Bool {
        return viewModel.isGameReady && viewModel.flippedCards.count == 2 && !viewModel.cardsMatch() && viewModel.flippedCards.contains(index)
    }
    
    init(viewModel: MemoryMatchViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    Spacer()
                    HStack {
                        Text("Memory")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.blue)
                        
                        Text("Match")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.red)
                    }
                    .frame(width: geometry.size.width)
                    .padding(.bottom, 50)
                    
                    if viewModel.isGameReady {
                        gameContent
                    } else {
                        startButton
                            .frame(width: geometry.size.width, height: geometry.size.height)
                    }
                    Spacer()
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
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarTitle("", displayMode: .inline)
    }
    
    private var gameContent: some View {
        ScrollView {
            VStack {
                scoreAndTimeBar
                Divider().padding(.vertical)
                gameGrid
            }
        }
    }
    
    private var scoreAndTimeBar: some View {
        HStack {
            Text("Score: \(self.viewModel.score)")
                .font(.headline)
            
            Spacer()
            
            Divider()
                .frame(height: 20)
                .padding(.horizontal, 8)
            
            Text("Matched Pairs: \(self.viewModel.matchedPairs.count)")
                .font(.headline)
            
            Spacer()
            
            Divider()
                .frame(height: 20)
                .padding(.horizontal, 8)
            
            Text("Time Left: \(Int(self.viewModel.remainingTime))s").font(.headline)
            
            Spacer()
            
            Button(action: {
                isMuted.toggle()
            }) {
                Image(systemName: isMuted ? "speaker.slash.fill" : "speaker.fill")
                    .font(.headline)
            }
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
                    soundManager.playSound(cardFlipSound, isMuted: isMuted)
                    self.viewModel.handleCardTap(index: index)
                    if shakeCard(at: index) {
                        hapticGenerator.notificationOccurred(.warning)
                        soundManager.playSound(matchSound, isMuted: isMuted)
                    }
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
                viewModel.resetGame()
                
            })
        } else {
            return Alert(title: Text("Time's Up!"),
                         message: Text("You've matched \(self.viewModel.matchedPairs.count) out of \(self.viewModel.difficulty.rawValue / 2) pairs. Your score is \(self.viewModel.score)."),
                         primaryButton: .default(Text("Restart")) {
                self.viewModel.restartGame()
            },
                         secondaryButton: .cancel {
                viewModel.resetGame()
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

