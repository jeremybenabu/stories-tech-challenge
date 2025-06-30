//
//  StoryViewModel.swift
//  Stories
//
//  Created by Jeremy Ben Abu on 30/06/2025.
//
import SwiftUI

struct StoryView<ViewModel>: View where ViewModel: StoryViewModel {

    @StateObject private var viewModel: ViewModel
    let onCloseTapped: () -> Void

    init(
        viewModel: ViewModel,
        onCloseTapped: @escaping () -> Void
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.onCloseTapped = onCloseTapped
    }

    var body: some View {
        ZStack {
            VStack {
                ZStack {
                    StoryMediaContentView(
                        story: viewModel.currentStory,
                        isPaused: viewModel.isPressing,
                        onReady: viewModel.onMediaReady
                    ).cornerRadius(20)
                    StoryTapZonesView(
                        leftZoneTapped: { viewModel.processPress($0, zone: .left) },
                        rightZoneTapped: { viewModel.processPress($0, zone: .right)}
                    )
                }
                HStack {
                    Spacer()
                    StoryLikeButtonView(isLiked: viewModel.currentStory.isLiked) {
                        Task { await viewModel.likeStory() }
                    }
                }
            }

            StoryOverlayGradiantView()
            VStack {
                StoryHeaderView(
                    userStory: viewModel.userStory,
                    onCloseTapped: onCloseTapped
                )
                StoryProgressView(viewModel: viewModel)
                Spacer()
            }
            .padding()
        }
        .onAppear {
            viewModel.notifyStoryAppear()
        }
        .onChange(of: viewModel.currentStoryIndex) { _, _ in
            viewModel.notifyStoryAppear()
        }
        .onDisappear {
            viewModel.resetTimerAndProgress()
        }
    }
}
