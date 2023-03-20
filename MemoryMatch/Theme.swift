//
//  Theme.swift
//  MemoryMatch
//
//  Created by Ogbemudia Terry Osayawe on 19.03.23.
//

import Foundation


enum Theme: String, CaseIterable {
    case animals
    case objects
    
    var description: String {
        switch self {
        case .animals:
            return "Animals"
        case .objects:
            return "Objects"
        }
    }
}
