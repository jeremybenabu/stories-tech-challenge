//
//  StoryListViewModel.swift
//  Stories
//
//  Created by Jeremy Ben Abu on 30/06/2025.
//
import SwiftUI
import Combine

final class StoryListViewModel: ObservableObject {

    @Published private(set) var userStories: [UserStory] = []
    @Published var selectedUserStoryIndex: Int = 0

    private var cancellables = Set<AnyCancellable>()

    private var loadingMore = false
    @Published private(set) var canLoadMore = false

    enum StoryListState: Equatable {
        case loading
        case loaded([UserStory])
        case error(String)
        case idle
    }

    @Published private(set) var state: StoryListState = .idle

    private let fetchStoriesUseCase: FetchStoriesUseCase
    private let observeStoriesUseCase: ObserveStoriesUseCase
    private let markStorySeenUseCase: MarkStorySeenUseCase
    private let clearLocalStorageUseCase: ClearLocalStorageUseCase

    init(
        fetchStoriesUseCase: FetchStoriesUseCase,
        observeStoriesUseCase: ObserveStoriesUseCase,
        markStorySeenUseCase: MarkStorySeenUseCase,
        clearLocalStorageUseCase: ClearLocalStorageUseCase
    ) {
        self.fetchStoriesUseCase = fetchStoriesUseCase
        self.observeStoriesUseCase = observeStoriesUseCase
        self.markStorySeenUseCase = markStorySeenUseCase
        self.clearLocalStorageUseCase = clearLocalStorageUseCase
        observeStoriesUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] updatedStories in
                self?.updateStories(updatedStories)
            }
            .store(in: &cancellables)
    }

    @MainActor
    func fetchStories() async {
        initState()
        await processFetchStories()
    }

    @MainActor
    func fetchMoreStories() async {
        guard canLoadMore, !loadingMore else { return }
        loadingMore = true
        await processFetchStories(false)
    }

    @MainActor
    func markStoryAsSeen(storyId: String) {
        Task {
            await markStorySeenUseCase.execute(storyId: storyId)
        }
    }

    func selectedUserStory(_ userStory: UserStory) {
        selectedUserStoryIndex = userStories.firstIndex(of: userStory) ?? 0
    }

    func moveToNextUserStory() -> Bool {
        guard selectedUserStoryIndex < userStories.count - 1 else { return false }
        selectedUserStoryIndex += 1
        return true
    }

    func moveToPreviousUserStory() -> Bool {
        guard selectedUserStoryIndex - 1 >= 0 else { return false }
        selectedUserStoryIndex -= 1
        return true
    }

    @MainActor
    func resetLocalData() async {
        await clearLocalStorageUseCase.execute()
        await fetchStories()
    }
}

private extension StoryListViewModel {

    @MainActor
    private func processFetchStories(_ firstLoad: Bool = true) async {
        do {
            let stories = try await fetchStoriesUseCase.execute(isFirstLoad: firstLoad)
            updateStories(stories)
        } catch let error as StoryError where error == .noMoreStoriesAvailable {
            canLoadMore = false
            updateStories(userStories)
        } catch {
            errorState(error.localizedDescription)
        }
    }

    private func updateStories(_ updatedStories: [UserStory]) {
        guard updatedStories != userStories else { return }
        userStories = updatedStories
        state = .loaded(updatedStories)
        loadingMore = false
    }

    private func initState() {
        canLoadMore = true
        loadingMore = true
        userStories.removeAll()
        self.state = .loading
    }

    private func errorState(_ message: String) {
        state = .error(message)
        loadingMore = false
    }
}
