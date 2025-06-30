//
//  StoryListItemView.swift
//  Stories
//
//  Created by Jeremy Ben Abu on 30/06/2025.
//

import SwiftUI

struct StoryListItemView: View {

    @EnvironmentObject var module: StoriesModule

    let user: UserStory
    let tapAction: () -> Void

    struct Constants {
        static let avatarImageSize: CGFloat = 80

        static let avatarDelimiterSize: CGFloat = 82
        static let avatarDelimiterWidth: CGFloat = 5

        static let avatarBorderSize: CGFloat = 95
        static let avatarBorderWidth: CGFloat = 4
    }

    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                // Seen/UnSeen circle
                Circle()
                    .strokeBorder(
                        user.allSeen ?
                        AngularGradient(colors: [.gray], center: .center) :
                        AngularGradient(
                            colors: [Color.purple, Color.blue, Color.pink, Color.orange, Color.purple],
                            center: .center
                        ),
                        lineWidth: Constants.avatarBorderWidth
                    )
                    .frame(width: Constants.avatarBorderSize, height: Constants.avatarBorderSize)

                // Delimiter circle
                Circle()
                    .stroke(Color(.systemBackground), lineWidth: Constants.avatarDelimiterWidth)
                    .frame(width: Constants.avatarDelimiterSize, height: Constants.avatarDelimiterSize)

                // Avatar image
                module.buildCacheImageView(url: user.avatarURL)
                .clipShape(Circle())
                .frame(width: Constants.avatarImageSize, height: Constants.avatarImageSize)
                .onTapGesture {
                    tapAction()
                }
            }

            // User name
            Text(user.name)
                .font(.caption)
                .lineLimit(1)
        }
    }
}
