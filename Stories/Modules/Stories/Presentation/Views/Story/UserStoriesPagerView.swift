//
//  StoryListItemView.swift
//  Stories
//
//  Created by Jeremy Ben Abu on 30/06/2025.
//

import SwiftUI

struct UserStoriesPagerView<ViewModel>: View where ViewModel: StoryListViewModel {

    @EnvironmentObject var module: StoriesModule
    @ObservedObject private var viewModel: ViewModel
    @Environment(\.dismiss) private var dismiss

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            TabView(selection: $viewModel.selectedUserStoryIndex) {
                ForEach(Array(viewModel.userStories.enumerated()), id: \.1.id) { index, userStory in
                    module.buildStoryView(
                        for: userStory,
                        onStoryAppear: { storyId in
                            viewModel.markStoryAsSeen(storyId: storyId)
                        }, onNextUserStory: {
                            if !viewModel.moveToNextUserStory() {
                                dismiss()
                            }
                        }, onPreviousUserStory: {
                            if !viewModel.moveToPreviousUserStory() {
                                dismiss()
                            }
                        }, onCloseTapped: {
                            dismiss()
                        }
                    ).tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
    }
}
