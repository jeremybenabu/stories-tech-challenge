//
//  ModelMapper.swift
//  Stories
//
//  Created by Jeremy Ben Abu on 30/06/2025.
//

extension Array where Element == UserDTO {
    func toDomain() async -> [UserStory] {
        // Execute treatment on background
        await Task.detached(priority: .userInitiated) {
            self.map { $0.toDomain }.sortedByLastStoryTimestamp()
        }.value
    }
}

extension UserDTO {
    var toDomain: UserStory {
        UserStory(
            id: id,
            name: name,
            avatarURL: avatarURL,
            stories: stories.map { $0.toDomain },
            allSeen: stories.allSatisfy((\.isSeen))
        )
    }
}

extension StoryDTO {
    var toDomain: Story {
        Story(
            id: id,
            mediaURL: mediaURL,
            mediaType: mediaType,
            timestamp: timestamp,
            isSeen: isSeen,
            isLiked: isLiked ?? false,
            duration: duration
        )
    }
}

private extension Array where Element == UserStory {
    func sortedByLastStoryTimestamp() -> [UserStory] {
        self.sorted {
            let lhsDate = $0.stories.max(by: { $0.timestamp < $1.timestamp })?.timestamp ?? .distantPast
            let rhsDate = $1.stories.max(by: { $0.timestamp < $1.timestamp })?.timestamp ?? .distantPast
            return lhsDate > rhsDate
        }
    }
}
