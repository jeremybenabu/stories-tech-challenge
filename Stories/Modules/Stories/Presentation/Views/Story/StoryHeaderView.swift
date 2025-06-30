//
//  StoryHeaderView.swift
//  Stories
//
//  Created by Jeremy Ben Abu on 30/06/2025.
//

import SwiftUI

struct StoryHeaderView: View {

    @EnvironmentObject var module: StoriesModule

    let userStory: UserStory
    let onCloseTapped: () -> Void

    var body: some View {
        HStack {
            module.buildCacheImageView(url: userStory.avatarURL)
            .frame(width: 32, height: 32)
            .clipShape(Circle())

            Text(userStory.name)
                .foregroundColor(.white)
                .font(.subheadline)
                .bold()

            Spacer()
            Button(action: {
                onCloseTapped()
            }) {
                Image(systemName: "xmark")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .padding(12)
            }
            .accessibilityLabel("Close")
        }
    }
}
