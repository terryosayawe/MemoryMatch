//
//  Difficulty.swift
//  MemoryMatch
//
//  Created by Ogbemudia Terry Osayawe on 19.03.23.
//

import Foundation

enum Difficulty: Int, CaseIterable {
    case easy = 16
    case medium = 36
    case hard = 64
    
    var description: String {
        switch self {
        case .easy:
            return "Easy (4x4)"
        case .medium:
            return "Medium (6x6)"
        case .hard:
            return "Hard (8x8)"
        }
    }
}
