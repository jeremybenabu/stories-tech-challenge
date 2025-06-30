//
//  StoryLikeButtonView.swift
//  Stories
//
//  Created by Jeremy Ben Abu on 30/06/2025.
//

import SwiftUI

struct StoryLikeButtonView: View {

    let isLiked: Bool
    let likePressed: () -> Void

    @State private var heartScale: CGFloat = 1.0

    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.15, dampingFraction: 0.5, blendDuration: 0)) {
                heartScale = 1.5
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                withAnimation {
                    heartScale = 1.0
                }
            }
            likePressed()
        }) {
            Image(systemName: isLiked ? "heart.fill" : "heart")
                .font(.system(size: 20))
                .foregroundColor(.white)
                .padding(12)
                .scaleEffect(heartScale)
        }
    }
}
