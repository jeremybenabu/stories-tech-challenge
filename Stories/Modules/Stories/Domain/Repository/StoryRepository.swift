//
//  StoryRepository.swift
//  Stories
//
//  Created by Jeremy Ben Abu on 30/06/2025.
//
import Combine

protocol StoryRepository {
    func fetchStories(isFirstLoad: Bool) async throws -> [UserStory]
    func markStoryAsSeen(_ id: String) async
    func likeStory(_ id: String) async -> UserStory?
    func clearLocalStorage() async
    var storiesPublisher: AnyPublisher<[UserStory], Never> { get }
}
