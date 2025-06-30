//
//  StoryService.swift
//  Stories
//
//  Created by Jeremy Ben Abu on 30/06/2025.
//
import Foundation

protocol StoryService {
    func fetchStories(_ index: Int?) async throws -> StoryResponseDTO
}

final class DefaultStoryService: StoryService {
    func fetchStories(_ index: Int? = 0) async throws -> StoryResponseDTO {
        let delay = UInt64.random(in: 100_000_000...1_000_000_000)
        try? await Task.sleep(nanoseconds: delay)
        guard let file = Bundle.main.url(forResource: "getStoriesPayload_\(index ?? 0)", withExtension: "json") else {
            //throw StoryError.noMoreStoriesAvailable
            return StoryResponseDTO.generateMockData(index: index ?? 0)
        }
        let data = try Data(contentsOf: file)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let dto = try decoder.decode(StoryResponseDTO.self, from: data)
        return dto
    }
}
