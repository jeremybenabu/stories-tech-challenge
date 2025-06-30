//
//  StoryProgressView.swift
//  Stories
//
//  Created by Jeremy Ben Abu on 30/06/2025.
//

import SwiftUI

struct StoryProgressView: View {

    @ObservedObject var viewModel: StoryViewModel

    var body: some View {
        HStack(spacing: 4) {
            ForEach(viewModel.userStory.stories.indices, id: \.self) { index in
                ProgressView(value: viewModel.progressValue(for: index), total: 1.0)
                    .progressViewStyle(LinearProgressViewStyle(tint: .white))
                    .frame(maxWidth: .infinity)
            }
        }
    }
}
