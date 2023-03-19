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
    @Published var score: Int = 0
    @Published var gameStarted: Bool = false
    @Published var difficulty: Difficulty
    @Published var theme: Theme
    @Published var isGameReady: Bool = false
    
    private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private var timerCancellable: AnyCancellable?
    
    init(difficulty: Difficulty, theme: Theme) {
        self.difficulty = difficulty
        self.theme = theme
    }
    
    func prepareGame() {
        isGameReady = true
    }
    
    func handleCardTap(index: Int) {
        if self.flippedCards.count < 2 && !self.flippedCards.contains(index) && !self.matchedPairs.contains(self.cardData[index] % (difficulty.rawValue / 2)) {
            self.flippedCards.insert(index)
            if self.flippedCards.count == 2 {
                if cardsMatch() {
                    let matchedCardIndex = self.cardData[Array(self.flippedCards)[0]] % (difficulty.rawValue / 2)
                    self.matchedPairs.insert(matchedCardIndex)
                    
                    self.checkGameEnd()
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
        guard indices.count == 2 else { return false }
        return cardData[indices[0]] % 8 == cardData[indices[1]] % 8
    }
    
    func restartGame() {
        flippedCards.removeAll()
        matchedPairs.removeAll()
        timeElapsed = 0
        score = 0
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
            if self?.timeElapsed == Double(self?.difficulty.rawValue ?? 0) * 2.0 {
                self?.stopTimer()
                self?.checkGameEnd()
            }
        }
        
    }
    
    fileprivate func gameEnd() {
        self.stopTimer()
        self.score += self.calculateScore()
        self.showAlert = true
    }
    
    func checkGameEnd() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.flippedCards.removeAll()
            if self.matchedPairs.count == self.difficulty.rawValue / 2 || self.timeElapsed == Double(self.difficulty.rawValue) * 2.0{
                self.gameEnd()
            }
        }
    }
    
    func stopTimer() {
        timerCancellable?.cancel()
    }
    
    func calculateScore() -> Int {
        let difficultyMultiplier: Double = {
            switch self.difficulty {
            case .easy:
                return 1.0
            case .medium:
                return 1.5
            case .hard:
                return 2.0
            case .veryEasy:
                return 0.5
            }
        }()
        
        let maxTimeElapsed = Double(self.difficulty.rawValue) * 2.0
        if self.timeElapsed >= maxTimeElapsed {
            let matchedPairsScore = Int(10 * difficultyMultiplier) * self.matchedPairs.count
            return max(matchedPairsScore, 0)
        }
        
        let baseScore = Int(100 * difficultyMultiplier)
        let timeBonus = Int((maxTimeElapsed - self.timeElapsed) * difficultyMultiplier)
        let score = baseScore + timeBonus
        return max(score, 0)
    }
    
}
