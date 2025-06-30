//
//  MockStoryService.swift
//  Stories
//
//  Created by Jeremy Ben Abu on 30/06/2025.
//

@testable import Stories

final class MockStoryService: StoryService {
    var fetchCalled = false
    var remoteStories: StoryResponseDTO = .mock

    func fetchStories(_ index: Int?) async throws -> StoryResponseDTO {
        fetchCalled = true
        return remoteStories
    }
}
