//
//  StoryTapZonesView.swift
//  Stories
//
//  Created by Jeremy Ben Abu on 30/06/2025.
//

import SwiftUI

struct StoryTapZonesView: View {

    let leftZoneTapped: (Bool) -> Void
    let rightZoneTapped: (Bool) -> Void

    var body: some View {
        HStack(spacing: 0) {
            // Left side
            Color.clear
                .contentShape(Rectangle())
                .onLongPressGesture(minimumDuration: 0, maximumDistance: 50, perform: {}) { isPressing in
                    leftZoneTapped(isPressing)
                }

            // Right side
            Color.clear
                .contentShape(Rectangle())
                .onLongPressGesture(minimumDuration: 0, maximumDistance: 50, perform: {}) { isPressing in
                    rightZoneTapped(isPressing)
                }
        }
    }
}
