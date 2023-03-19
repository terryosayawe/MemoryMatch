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
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Memory Match")
                    .font(.largeTitle)
                    .bold()
                
                HStack {
                    Text("Matched Pairs: \(self.viewModel.matchedPairs.count)")
                        .font(.headline)
                    
                    Spacer()
                    
                    Text("Time: \(Int(self.viewModel.timeElapsed))s")
                        .font(.headline)
                }
                .padding(.horizontal)
                
                LazyVGrid(columns: Array(repeating: GridItem(.adaptive(minimum: 100, maximum: 100), spacing: 16), count: gridSize), spacing: 16) {
                    ForEach(0..<self.viewModel.cardData.count, id: \.self) { index in
                        Card(faceUp: self.viewModel.flippedCards.contains(index) || self.viewModel.matchedPairs.contains(self.viewModel.cardData[index] % (self.viewModel.difficulty.rawValue / 2))) {
                            Image("card_\(self.viewModel.cardData[index] % (self.viewModel.difficulty.rawValue / 2))")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(4)
                        }
                        .onTapGesture {
                            self.viewModel.handleCardTap(index: index)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding()
            .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
            .navigationBarItems(trailing: HStack {
                NavigationLink(destination: DifficultySelectionView()) {
                    Text("Settings")
                }
                Text("Difficulty: \(self.viewModel.difficulty.description)")
            })
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Congratulations!"),
                      message: Text("You've matched all \(self.viewModel.matchedPairs.count) pairs in \(Int(self.viewModel.timeElapsed)) seconds."),
                      dismissButton: .default(Text("Restart")) {
                    self.viewModel.restartGame()
                })
            }
            .onDisappear {
                self.viewModel.stopTimer()
            }
        }
    }
}


struct MemoryMatchView_Previews: PreviewProvider {
    @StateObject static var viewModel = MemoryMatchViewModel(difficulty: .easy)
    
    static var previews: some View {
        MemoryMatchView(viewModel: viewModel)
    }
}
