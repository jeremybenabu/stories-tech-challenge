//
//  Story.swift
//  Stories
//
//  Created by Jeremy Ben Abu on 30/06/2025.
//
import Foundation

struct Story: Identifiable, Hashable, Equatable {
    let id: String
    let mediaURL: URL
    let mediaType: MediaType
    let timestamp: Date
    let isSeen: Bool
    let isLiked: Bool
    let duration: Int
}
