//
//  MarkStorySeenUseCase.swift
//  Stories
//
//  Created by Jeremy Ben Abu on 30/06/2025.
//

protocol MarkStorySeenUseCase {
    func execute(storyId: String) async
}

struct DefaultMarkStorySeenUseCase: MarkStorySeenUseCase {

    private let repository: StoryRepository

    init(repository: StoryRepository) {
        self.repository = repository
    }

    func execute(storyId: String) async {
        await repository.markStoryAsSeen(storyId)
    }
}
