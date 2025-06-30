//
//  DefaultLocalStoryRepository.swift
//  Stories
//
//  Created by Jeremy Ben Abu on 30/06/2025.
//

import Combine

final actor DefaultLocalStoryRepository: LocalStoryRepository {

    private let storage: StorageManager
    private var inMemoryDataSource: [UserDTO] = []
    private var lastPageIndex: Int

    init(storage: StorageManager) {
        self.storage = storage
        self.lastPageIndex = storage.latestPageIndex()
    }

    func loadStories() async -> [UserDTO] {
        if inMemoryDataSource.isEmpty {
            inMemoryDataSource = storage.load(file: "\(lastPageIndex).json") ?? []
        }
        return inMemoryDataSource
    }

    func markStorySeen(_ id: String) async {
        _ = updateStory(id, isSeen: true)
        storage.save(inMemoryDataSource, file: "\(lastPageIndex).json")
    }

    func likeStoryPressed(_ id: String) async -> UserDTO? {
        let updatedStory = updateStory(id, likedStoryPressed: true)
        storage.save(inMemoryDataSource, file: "\(lastPageIndex).json")
        return updatedStory
    }

    func appendStories(stories: [UserDTO], forPage index: Int) async -> [UserDTO] {
        inMemoryDataSource.append(contentsOf: stories)
        lastPageIndex = index
        storage.save(inMemoryDataSource, file: "\(lastPageIndex).json")
        return inMemoryDataSource
    }

    func getLastPageIndex() async -> Int {
        lastPageIndex
    }

    func clearLocalStorage() async {
        storage.clear(file: "\(lastPageIndex).json")
        inMemoryDataSource = []
    }
}

private extension DefaultLocalStoryRepository {
    func updateStory(
        _ id: String,
        isSeen: Bool? = nil,
        likedStoryPressed: Bool? = nil
    ) -> UserDTO? {
        for i in inMemoryDataSource.indices {
            let user = inMemoryDataSource[i]
            if let index = user.stories.firstIndex(where: { $0.id == id }) {
                let story = user.stories[index]
                let updatedStory = story.copyWith(
                    isSeen: isSeen,
                    isLiked: (likedStoryPressed ?? false) ? !(story.isLiked ?? false) : story.isLiked
                )
                let updatedUser = user.updateStoryWith(story: updatedStory)
                inMemoryDataSource[i] = updatedUser
                return updatedUser
            }
        }
        return nil
    }
}
