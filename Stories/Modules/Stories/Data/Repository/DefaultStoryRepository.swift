//
//  DefaultStoryRepository.swift
//  Stories
//
//  Created by Jeremy Ben Abu on 30/06/2025.
//

import Combine
import Foundation

final class DefaultStoryRepository: StoryRepository {

    private let service: StoryService
    private let localStoryRepository: LocalStoryRepository

    @Published private var currentStories: [UserStory] = []

    var storiesPublisher: AnyPublisher<[UserStory], Never> {
        $currentStories.eraseToAnyPublisher()
    }

    private var cancellables = Set<AnyCancellable>()

    init(service: StoryService, localStoryRepository: LocalStoryRepository) {
        self.service = service
        self.localStoryRepository = localStoryRepository
    }

    func getCurrentPageIndex() async -> Int {
        await localStoryRepository.getLastPageIndex()
    }

    func fetchStories(isFirstLoad: Bool) async throws -> [UserStory] {
        let pageToFetch = isFirstLoad ? 0 : await localStoryRepository.getLastPageIndex() + 1
        if let localStories = try await fetchStoriesFromLocal(pageToFetch) {
            currentStories = localStories
        } else {
            currentStories = try await fetchStoriesFromRemote(pageToFetch)
        }

        return currentStories
    }

    func markStoryAsSeen(_ id: String) async {
        await localStoryRepository.markStorySeen(id)
        currentStories = await localStoryRepository.loadStories().toDomain()
    }

    func likeStory(_ id: String) async -> UserStory? {
        let updatedUser = await localStoryRepository.likeStoryPressed(id)
        currentStories = await localStoryRepository.loadStories().toDomain()
        return updatedUser?.toDomain
    }

    func clearLocalStorage() async {
        await localStoryRepository.clearLocalStorage()
    }
}

private extension DefaultStoryRepository {
    func fetchStoriesFromLocal(_ page: Int = 0) async throws -> [UserStory]? {
        let lastPageIndex = await localStoryRepository.getLastPageIndex()
        var localData: [UserDTO] = []
        if page <= lastPageIndex {
            localData = await localStoryRepository.loadStories()
        }
        guard !localData.isEmpty else { return nil }
        return await localData.toDomain()
    }

    func fetchStoriesFromRemote(_ page: Int = 0) async throws -> [UserStory] {
        let remoteData = try await service.fetchStories(page)
        return await localStoryRepository.appendStories(stories: remoteData.users, forPage: page).toDomain()
    }
}
