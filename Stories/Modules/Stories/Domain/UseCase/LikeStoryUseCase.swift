//
//  LikeStoryUseCase.swift
//  Stories
//
//  Created by Jeremy Ben Abu on 30/06/2025.
//

protocol LikeStoryUseCase {
    func execute(storyId: String) async -> UserStory?
}

struct DefaultLikeStoryUseCase: LikeStoryUseCase {
    private let repository: StoryRepository

    init(repository: StoryRepository) {
        self.repository = repository
    }

    func execute(storyId: String) async -> UserStory? {
        await repository.likeStory(storyId)
    }
}
