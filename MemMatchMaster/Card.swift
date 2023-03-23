//
//  Crad.swift
//  MemoryMatch
//
//  Created by Ogbemudia Terry Osayawe on 19.03.23.
//

import SwiftUI

struct Card<Content: View>: View {
    var isMatched: Bool
    var faceUp: Bool
    var content: Content
    
    init(isMatched: Bool = false, faceUp: Bool, @ViewBuilder content: () -> Content) {
        self.isMatched = isMatched
        self.faceUp = faceUp
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16).fill(Color.white)
            RoundedRectangle(cornerRadius: 16).stroke(lineWidth: 3)
            
            if faceUp {
                content
            } else {
                RoundedRectangle(cornerRadius: 16).fill(Color.gray)
            }
        }
        .aspectRatio(2 / 3, contentMode: .fit)
        .shadow(radius: 5)
        .rotation3DEffect(faceUp ? Angle(degrees: 0) : Angle(degrees: 180), axis: (x: 0.0, y: 1.0, z: 0.0))
        .opacity(isMatched ? 0 : 1)
    }
}

