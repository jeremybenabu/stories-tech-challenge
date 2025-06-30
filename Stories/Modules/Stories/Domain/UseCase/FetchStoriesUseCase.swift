//
//  FetchStoriesUseCase.swift
//  Stories
//
//  Created by Jeremy Ben Abu on 30/06/2025.
//

protocol FetchStoriesUseCase {
    func execute(isFirstLoad: Bool) async throws -> [UserStory]
}

struct DefaultFetchStoriesUseCase: FetchStoriesUseCase {
    private let repository: StoryRepository

    init(repository: StoryRepository) {
        self.repository = repository
    }

    func execute(isFirstLoad: Bool) async throws -> [UserStory] {
        try await repository.fetchStories(isFirstLoad: isFirstLoad)
    }
}
