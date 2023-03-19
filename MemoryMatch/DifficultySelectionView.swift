//
//  DifficultySelectionView.swift
//  MemoryMatch
//
//  Created by Ogbemudia Terry Osayawe on 19.03.23.
//

import SwiftUI

struct DifficultySelectionView: View {
    @EnvironmentObject var userSettings: UserSettings
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Select Difficulty")
                    .font(.largeTitle)
                    .bold()
                
                ForEach(Difficulty.allCases, id: \.self) { level in
                    Button(action: {
                        userSettings.difficulty = level
                    }, label: {
                        Text(level.description)
                            .font(.title)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    })
                }
                
                Text("Select Theme")
                    .font(.title)
                    .bold()
                
                ForEach(Theme.allCases, id: \.self) { theme in
                    Button(action: {
                        userSettings.theme = theme
                    }, label: {
                        Text(theme.description)
                            .font(.title)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    })
                }
            }
            .padding()
            .navigationBarTitle("Memory Match", displayMode: .inline)
        }
    }
}



