//
//  ObserveStoriesUseCase.swift
//  Stories
//
//  Created by Jeremy Ben Abu on 30/06/2025.
//
import Combine

protocol ObserveStoriesUseCase {
    func execute() -> AnyPublisher<[UserStory], Never>
}

struct DefaultObserveStoriesUseCase: ObserveStoriesUseCase {
    let repository: StoryRepository

    func execute() -> AnyPublisher<[UserStory], Never> {
        repository.storiesPublisher
    }
}
