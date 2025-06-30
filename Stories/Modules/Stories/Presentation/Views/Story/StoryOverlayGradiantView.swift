//
//  StoryOverlayGradiantView.swift
//  Stories
//
//  Created by Jeremy Ben Abu on 30/06/2025.
//

import SwiftUI

struct StoryOverlayGradiantView: View {

    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.black.opacity(0.7), .clear]),
            startPoint: .top,
            endPoint: .center
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .allowsHitTesting(false)
    }
}
