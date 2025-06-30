//
//  TestData.swift
//  Stories
//
//  Created by Jeremy Ben Abu on 30/06/2025.
//
@testable import Stories
import Foundation

extension StoryResponseDTO {
    static var mock: StoryResponseDTO {
        .init(users: [.mock])
    }
}

extension UserDTO {
    static var mock: UserDTO {
        UserDTO(
            id: "123",
            name: "test",
            avatarURL: URL(string: "https://avatar.jpeg")!,
            stories: [.mock, .mock2]
        )
    }
}

extension StoryDTO {
    static var mock: StoryDTO {
        StoryDTO(
            id: "storyId1",
            mediaURL: URL(string: "https://media.jpeg")!,
            mediaType: .image,
            timestamp: Date(timeIntervalSince1970: 0),
            isSeen: false,
            isLiked: false,
            duration: 3
        )
    }

    static var mock2: StoryDTO {
        StoryDTO(
            id: "storyId2",
            mediaURL: URL(string: "https://media2.jpeg")!,
            mediaType: .image,
            timestamp: Date(timeIntervalSince1970: 1000),
            isSeen: false,
            isLiked: false,
            duration: 3
        )
    }
}


extension UserStory {
    static var mock: UserStory {
        UserDTO.mock.toDomain
    }

    static var mock2: UserStory {
        UserStory(
            id: "123",
            name: "test",
            avatarURL: URL(string: "https://avatar.jpeg")!,
            stories: [
                Story(
                    id: "storyId1",
                    mediaURL: URL(string: "https://media.jpeg")!,
                    mediaType: .image,
                    timestamp: Date(timeIntervalSince1970: 0),
                    isSeen: true,
                    isLiked: false,
                    duration: 3),
                Story(
                    id: "storyId2",
                    mediaURL: URL(string: "https://media2.jpeg")!,
                    mediaType: .image,
                    timestamp: Date(timeIntervalSince1970: 1000),
                    isSeen: false,
                    isLiked: false,
                    duration: 3
                )],
            allSeen: false
        )
    }

    static var mock3: UserStory {
        UserStory(
            id: "123",
            name: "test",
            avatarURL: URL(string: "https://avatar.jpeg")!,
            stories: [
                Story(
                    id: "storyId1",
                    mediaURL: URL(string: "https://media.jpeg")!,
                    mediaType: .image,
                    timestamp: Date(timeIntervalSince1970: 0),
                    isSeen: false,
                    isLiked: true,
                    duration: 3
                ),
                Story(
                    id: "storyId2",
                    mediaURL: URL(string: "https://media2.jpeg")!,
                    mediaType: .image,
                    timestamp: Date(timeIntervalSince1970: 1000),
                    isSeen: false,
                    isLiked: false,
                    duration: 3
                )],
            allSeen: false
        )
    }

    static var mock4: UserStory {
        UserStory(
            id: "234",
            name: "test2",
            avatarURL: URL(string: "https://avatar.jpeg")!,
            stories: [
                Story(
                    id: "storyId3",
                    mediaURL: URL(string: "https://media.jpeg")!,
                    mediaType: .image,
                    timestamp: Date(timeIntervalSince1970: 0),
                    isSeen: true,
                    isLiked: true,
                    duration: 3
                )
            ],
            allSeen: true
        )
    }
}
