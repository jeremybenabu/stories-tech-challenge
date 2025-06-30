//
//  ModelMapperTests.swift
//  Stories
//
//  Created by Jeremy Ben Abu on 30/06/2025.
//

import XCTest
@testable import Stories

final class ModelMapperTests: XCTestCase {

    func testUserStoriesDTO_toDomain_shouldMapCorrectly() async {
        let dto = UserDTO(
            id: "123",
            name: "Alice",
            avatarURL: URL(string: "https://example.com/avatar.jpg")!,
            stories: [
                StoryDTO(
                    id: "s1",
                    mediaURL: URL(string: "https://example.com/story1.mp4")!,
                    mediaType: .video,
                    timestamp: Date(timeIntervalSince1970: 1000),
                    isSeen: true,
                    isLiked: true,
                    duration: 5
                ),
                StoryDTO(
                    id: "s2",
                    mediaURL: URL(string: "https://example.com/story2.jpg")!,
                    mediaType: .image,
                    timestamp: Date(timeIntervalSince1970: 2000),
                    isSeen: true,
                    isLiked: nil,
                    duration: 3
                )
            ]
        )

        let domainModel = dto.toDomain

        XCTAssertEqual(domainModel.id, "123")
        XCTAssertEqual(domainModel.name, "Alice")
        XCTAssertEqual(domainModel.avatarURL, URL(string: "https://example.com/avatar.jpg")!)
        XCTAssertEqual(domainModel.allSeen, true)
        XCTAssertEqual(domainModel.stories.count, 2)

        let firstStory = domainModel.stories[0]
        XCTAssertEqual(firstStory.id, "s1")
        XCTAssertEqual(firstStory.mediaURL, URL(string: "https://example.com/story1.mp4")!)
        XCTAssertEqual(firstStory.mediaType, .video)
        XCTAssertEqual(firstStory.timestamp, Date(timeIntervalSince1970: 1000))
        XCTAssertEqual(firstStory.isSeen, true)
        XCTAssertEqual(firstStory.isLiked, true)
        XCTAssertEqual(firstStory.duration, 5)

        let secondStory = domainModel.stories[1]
        XCTAssertEqual(secondStory.id, "s2")
        XCTAssertEqual(secondStory.mediaURL, URL(string: "https://example.com/story2.jpg")!)
        XCTAssertEqual(secondStory.mediaType, .image)
        XCTAssertEqual(secondStory.timestamp, Date(timeIntervalSince1970: 2000))
        XCTAssertEqual(secondStory.isSeen, true)
        XCTAssertEqual(secondStory.isLiked, false) // default value
        XCTAssertEqual(secondStory.duration, 3)
    }

    func testUserStoriesDTOArray_toDomain_shouldSortByLatestStory() async {
        let dtoArray = [
            UserDTO(
                id: "1",
                name: "User A",
                avatarURL: URL(string: "https://avatar.jpeg")!,
                stories: [
                    StoryDTO(
                        id: "1a",
                        mediaURL: URL(string: "https://media.jpeg")!,
                        mediaType: .image,
                        timestamp: Date(timeIntervalSince1970: 1000),
                        isSeen: false,
                        isLiked: nil,
                        duration: 1
                    )
                ]
            ),
            UserDTO(
                id: "2",
                name: "User B",
                avatarURL: URL(string: "https://avatar2.jpeg")!,
                stories: [
                    StoryDTO(
                        id: "2a",
                        mediaURL: URL(string: "https://media2.jpeg")!,
                        mediaType: .image,
                        timestamp: Date(timeIntervalSince1970: 2000),
                        isSeen: false,
                        isLiked: nil,
                        duration: 1
                    )
                ]
            )
        ]

        let result = await dtoArray.toDomain()

        XCTAssertEqual(result.first?.id, "2")
        XCTAssertEqual(result.last?.id, "1")
    }
}
