//
//  View+Animation.swift
//  Stories
//
//  Created by Jeremy Ben Abu on 30/06/2025.
//
import SwiftUI

extension View {
    func animatedAppearance(
        _ shouldAnimate: Bool,
        offset: CGSize = .zero,
        delay: Double = 0,
        duration: Double = 0.6
    ) -> some View {
        self
            .opacity(shouldAnimate ? 1 : 0)
            .offset(x: shouldAnimate ? 0 : offset.width, y: shouldAnimate ? 0 : offset.height)
            .animation(.easeOut(duration: duration).delay(delay), value: shouldAnimate)
    }
}
