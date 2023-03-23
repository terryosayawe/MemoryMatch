//
//  ShakeEffect.swift
//  MemoryMatch
//
//  Created by Ogbemudia Terry Osayawe on 19.03.23.
//

import SwiftUI

struct ShakeEffect: GeometryEffect {
    var amount: CGFloat
    var times: CGFloat
    var current: CGFloat

    var animatableData: CGFloat {
        get { current }
        set { current = newValue }
    }

    func effectValue(size: CGSize) -> ProjectionTransform {
        let shakeAmount = amount * sin(current * .pi * times)
        return ProjectionTransform(CGAffineTransform(translationX: shakeAmount, y: 0))
    }
}
