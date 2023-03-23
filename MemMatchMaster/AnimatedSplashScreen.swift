//
//  AnimatedSplashScreen.swift
//  MemoryMatch
//
//  Created by Ogbemudia Terry Osayawe on 21.03.23.
//

import SwiftUI

struct AnimatedSplashScreen: View {
    @Binding var isAnimationComplete: Bool
    @State private var logoScale: CGFloat = 0.0
    
    var body: some View {
        VStack {
            HStack {
                Text("Memory")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.blue)
                
                Text("Match")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.red)
            }
            .scaleEffect(logoScale)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            startAnimation()
        }
    }
    
    private func startAnimation() {
        withAnimation(.easeInOut(duration: 1.0)) {
            logoScale = 1.0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(.easeOut(duration: 1.0)) {
                isAnimationComplete = true
            }
        }
    }
}
