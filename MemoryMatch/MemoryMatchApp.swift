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
    
    var body: some Scene {
        WindowGroup {
            if let difficulty = userSettings.difficulty {
                MemoryMatchView(viewModel: MemoryMatchViewModel(difficulty: difficulty))
                    .environmentObject(userSettings)
            } else {
                DifficultySelectionView()
                    .environmentObject(userSettings)
            }
        }
    }
}
