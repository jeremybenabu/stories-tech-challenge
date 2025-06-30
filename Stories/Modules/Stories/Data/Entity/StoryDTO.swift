//
//  StoryDTO.swift
//  Stories
//
//  Created by Jeremy Ben Abu on 30/06/2025.
//
import Foundation

struct StoryDTO: Codable, Equatable {
    let id: String
    let mediaURL: URL
    let mediaType: MediaType
    let timestamp: Date
    let isSeen: Bool
    let isLiked: Bool?
    let duration: Int
}

extension StoryDTO {
    func copyWith(isSeen: Bool? = nil, isLiked: Bool? = nil) -> StoryDTO {
        StoryDTO(
            id: id,
            mediaURL: mediaURL,
            mediaType: mediaType,
            timestamp: timestamp,
            isSeen: isSeen ?? self.isSeen,
            isLiked: isLiked ?? self.isLiked,
            duration: duration
        )
    }
}
