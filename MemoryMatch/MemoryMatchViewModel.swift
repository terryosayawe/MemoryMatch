//
//  MemoryMatchViewModel.swift
//  MemoryMatch
//
//  Created by Ogbemudia Terry Osayawe on 19.03.23.
//

import SwiftUI
import Combine

class MemoryMatchViewModel: ObservableObject {
    @Published var cardData: [Int] = []
    @Published var flippedCards: Set<Int> = []
    @Published var matchedPairs: Set<Int> = []
    @Published var timeElapsed: Double = 0.0
    @Published var showAlert: Bool = false
    @Published var gameStarted: Bool = false
    @Published var difficulty: Difficulty
    
    private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private var timerCancellable: AnyCancellable?
    
    init(difficulty: Difficulty) {
        self.difficulty = difficulty
        startGame()
    }
    
    func handleCardTap(index: Int) {
        if self.flippedCards.count < 2 && !self.flippedCards.contains(index) && !self.matchedPairs.contains(self.cardData[index] % (difficulty.rawValue / 2)) {
            self.flippedCards.insert(index)
            if self.flippedCards.count == 2 {
                if cardsMatch() {
                    let matchedCardIndex = self.cardData[Array(self.flippedCards)[0]] % (difficulty.rawValue / 2)
                    self.matchedPairs.insert(matchedCardIndex)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.flippedCards.removeAll()
                        if self.matchedPairs.count == self.difficulty.rawValue / 2 {
                            self.showAlert = true
                            self.stopTimer()
                        }
                    }
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.flippedCards.removeAll()
                    }
                }
            }
        }
    }

    
    func cardsMatch() -> Bool {
        let indices = Array(flippedCards)
        return cardData[indices[0]] % 8 == cardData[indices[1]] % 8
    }
    
    func restartGame() {
        flippedCards.removeAll()
        matchedPairs.removeAll()
        timeElapsed = 0
        gameStarted = false
        startGame()
    }
    
    func startGame() {
        gameStarted = true
        
        var cards = [Int]()
        for i in 0..<(difficulty.rawValue / 2) {
            cards.append(i)
            cards.append(i)
        }
        cards.shuffle()
        cardData = cards
        
        timerCancellable = timer.sink { [weak self] _ in
            self?.timeElapsed += 1
        }
    }
    
    func stopTimer() {
        timerCancellable?.cancel()
    }
}
