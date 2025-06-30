//
//  MockLikeStoryUseCase.swift
//  Stories
//
//  Created by Jeremy Ben Abu on 30/06/2025.
//
@testable import Stories

final class MockLikeStoryUseCase: LikeStoryUseCase {
    var result: UserStory? = .mock

    func execute(storyId: String) async -> UserStory? {
        return result
    }
}
