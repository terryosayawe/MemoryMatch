//
//  MemoryMatchApp.swift
//  MemoryMatch
//
//  Created by Ogbemudia Terry Osayawe on 18.03.23.
//

import SwiftUI

@main
struct MemoryMatchApp: App {
    @StateObject private var userSettings = UserSettings()
    @State private var isAnimationComplete = false

    var body: some Scene {
        WindowGroup {
            if isAnimationComplete {
                if let difficulty = userSettings.difficulty {
                    MemoryMatchView(viewModel: MemoryMatchViewModel(difficulty: difficulty, theme: userSettings.theme ?? .objects))
                        .environmentObject(userSettings)
                } else {
                    DifficultySelectionView()
                        .environmentObject(userSettings)
                }
            } else {
                AnimatedSplashScreen(isAnimationComplete: $isAnimationComplete)
            }
        }
    }
}
