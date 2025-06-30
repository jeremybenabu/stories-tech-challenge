//
//  UserStoriesDTO.swift
//  Stories
//
//  Created by Jeremy Ben Abu on 30/06/2025.
//
import Foundation

struct UserDTO: Codable, Equatable {
    let id: String
    let name: String
    let avatarURL: URL
    let stories: [StoryDTO]
}

extension UserDTO {
    func updateStoryWith(story: StoryDTO) -> UserDTO {
        var stories = stories
        if let index = stories.firstIndex(where: { $0.id == story.id }) {
            stories[index] = story
        }
        let updatedStories = stories
        return UserDTO(
            id: id,
            name: name,
            avatarURL: avatarURL,
            stories: updatedStories
        )
    }
}
