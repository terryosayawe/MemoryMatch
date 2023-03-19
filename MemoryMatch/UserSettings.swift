//
//  UserSettings.swift
//  MemoryMatch
//
//  Created by Ogbemudia Terry Osayawe on 19.03.23.
//

import SwiftUI
import Combine

class UserSettings: ObservableObject {
    @Published var difficulty: Difficulty? {
        didSet {
            if let rawValue = difficulty?.rawValue {
                UserDefaults.standard.set(rawValue, forKey: "difficulty")
            }
        }
    }

    init() {
        if let rawValue = UserDefaults.standard.value(forKey: "difficulty") as? Int {
            difficulty = Difficulty(rawValue: rawValue)
        }
    }
}
