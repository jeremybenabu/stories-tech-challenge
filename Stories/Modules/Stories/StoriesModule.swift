//
//  StoriesModule.swift
//  Stories
//
//  Created by Jeremy Ben Abu on 30/06/2025.
//

import Combine
import Foundation

protocol StoriesModuleProtocol {
    func buildStoryListView() -> StoryListView<StoryListViewModel>
    func buildUserStoriesPagerView(viewModel: StoryListViewModel) -> UserStoriesPagerView<StoryListViewModel>
    func buildStoryView(
        for userStory: UserStory,
        onStoryAppear: @escaping (String) -> Void,
        onNextUserStory: @escaping () -> Void,
        onPreviousUserStory: @escaping () -> Void,
        onCloseTapped: @escaping () -> Void
    ) -> StoryView<StoryViewModel>
}

final class StoriesModule: ObservableObject {
    private let storyRepository: StoryRepository
    private let imageCacheManager: ImageCacheManager

    init(
        storyRepository: StoryRepository? = nil,
        imageCacheManager: ImageCacheManager? = nil
    ) {
        self.storyRepository = storyRepository ?? Self.buildStoryRepository()
        self.imageCacheManager = imageCacheManager ?? DefaultImageCacheManager()
    }
}

extension StoriesModule: StoriesModuleProtocol {
    func buildStoryListView() -> StoryListView<StoryListViewModel> {
        StoryListView(viewModel: buildStoryListViewModel(), module: self)
    }

    func buildUserStoriesPagerView(viewModel: StoryListViewModel) -> UserStoriesPagerView<StoryListViewModel> {
        UserStoriesPagerView(viewModel: viewModel)
    }

    func buildStoryView(
        for userStory: UserStory,
        onStoryAppear: @escaping (String) -> Void,
        onNextUserStory: @escaping () -> Void,
        onPreviousUserStory: @escaping () -> Void,
        onCloseTapped: @escaping () -> Void
    ) -> StoryView<StoryViewModel> {
        StoryView(
            viewModel: buildStoryViewModel(
                for: userStory,
                onStoryAppear: onStoryAppear,
                onNextUserStory: onNextUserStory,
                onPreviousUserStory: onPreviousUserStory
            ),
            onCloseTapped: onCloseTapped
        )
    }

    func buildCacheImageView(url: URL, imageLoaded: (() -> Void)? = nil) -> CachingImageView {
        CachingImageView(url: url, imageLoader: imageCacheManager, imageLoaded: imageLoaded)
    }
}

// MARK: - View Model
private extension StoriesModule {
    func buildStoryListViewModel() -> StoryListViewModel {
        StoryListViewModel(
            fetchStoriesUseCase: buildFetchStoryUseCase(),
            observeStoriesUseCase: buildObserveStoriesUseCase(),
            markStorySeenUseCase: buildMarkStorySeenUseCase(),
            clearLocalStorageUseCase: buildClearLocalStorageUseCase()
        )
    }

    func buildStoryViewModel(
        for userStory: UserStory,
        onStoryAppear: @escaping (String) -> Void,
        onNextUserStory: @escaping () -> Void,
        onPreviousUserStory: @escaping () -> Void
    ) -> StoryViewModel {
        StoryViewModel(
            userStory: userStory,
            likeStoryUseCase: buildLikeStoryUseCase(),
            onNextUserStory: onNextUserStory,
            onPreviousUserStory: onPreviousUserStory,
            onStoryAppear: onStoryAppear
        )
    }
}

// MARK: - Use Case
private extension StoriesModule {
    func buildFetchStoryUseCase() -> FetchStoriesUseCase {
        DefaultFetchStoriesUseCase(repository: storyRepository)
    }

    func buildObserveStoriesUseCase() -> ObserveStoriesUseCase {
        DefaultObserveStoriesUseCase(repository: storyRepository)
    }

    func buildMarkStorySeenUseCase() -> MarkStorySeenUseCase {
        DefaultMarkStorySeenUseCase(repository: storyRepository)
    }

    func buildLikeStoryUseCase() -> LikeStoryUseCase {
        DefaultLikeStoryUseCase(repository: storyRepository)
    }

    func buildClearLocalStorageUseCase() -> ClearLocalStorageUseCase {
        DefaultClearLocalStorageUseCase(repository: storyRepository)
    }
}

// MARK: - Data Layer
private extension StoriesModule {

    static func buildStoryRepository() -> StoryRepository {
        DefaultStoryRepository(
           service: buildStoryService(),
           localStoryRepository: buildLocalStoryRepository()
       )
    }
    static func buildStoryService() -> StoryService {
        DefaultStoryService()
    }

    static func buildLocalStoryRepository() -> LocalStoryRepository {
        DefaultLocalStoryRepository(storage: buildStorageManager())
    }

    static func buildStorageManager() -> StorageManager {
        StorageManager(baseFileName: AppConfiguration.localStorageFileName)
    }
}
