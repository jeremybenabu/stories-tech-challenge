//
//  StoryListView.swift
//  Stories
//
//  Created by Jeremy Ben Abu on 30/06/2025.
//

import SwiftUI

struct StoryListView<ViewModel>: View where ViewModel: StoryListViewModel {

    @ObservedObject private var viewModel: ViewModel
    @ObservedObject private var module: StoriesModule

    @State private var selectedUserStory: UserStory? = nil
    @State private var shouldAnimate = false

    init(viewModel: ViewModel, module: StoriesModule) {
        self.viewModel = viewModel
        self.module = module
    }

    var body: some View {
        NavigationView {
            VStack {
                switch viewModel.state {
                case .loading, .idle:
                    progressView
                case .error(let error):
                    errorView(error)
                case .loaded(let stories):
                    ScrollView {
                        storyListView(stories)
                            .animatedAppearance(shouldAnimate, offset: CGSize(width: 20, height: 0))
                        AnimatedWelcomeView()
                            .animatedAppearance(shouldAnimate, offset: CGSize(width: 0, height: 20), delay: 0.2)
                    }
                    .onAppear {
                        shouldAnimate = true
                    }
                }
            }
            .navigationTitle("Stories")
            .toolbar { toolbarView }
            .task {
                await fetchStories()
            }
            .environmentObject(module)
        }
    }
}

// MARK: - Views
private extension StoryListView {
    var progressView: some View {
        ProgressView()
            .progressViewStyle(.circular)
    }

    func errorView(_ error: String) -> some View {
        ErrorView(errorTitle: Constants.errorTitle, errorDescription: error) {
            Task {
                await fetchStories()
            }
        }
    }

    var toolbarView: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: {
                Task {
                    await resetStories()
                }
            }) {
                Image(systemName: "arrow.counterclockwise")
                    .accessibilityLabel("Reset")
            }
        }
    }

    func storyListView(_ stories: [UserStory]) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 12) {
                    ForEach(stories, id: \.id) { user in
                        StoryListItemView(user: user) {
                            viewModel.selectedUserStory(user)
                            selectedUserStory = user
                        }
                    }
                    if viewModel.canLoadMore {
                        ProgressView()
                            .onAppear {
                                fetchMoreStories()
                            }
                    }
                }
                .padding(.horizontal)
            }
            .frame(height: 120)
        }
        .sheet(item: $selectedUserStory) { selectedUserStory in
            module.buildUserStoriesPagerView(viewModel: viewModel)
        }
    }
}

// MARK: - Actions
private extension StoryListView {
    func fetchStories() async {
        await viewModel.fetchStories()
    }

    func resetStories() async {
        await viewModel.resetLocalData()
    }

    func fetchMoreStories() {
        Task {
            await viewModel.fetchMoreStories()
        }
    }
}

#Preview {
    AppDependencyInjection().storyListView
}
