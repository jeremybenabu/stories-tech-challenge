//
//  UserStory.swift
//  Stories
//
//  Created by Jeremy Ben Abu on 30/06/2025.
//
import Foundation

struct UserStory: Identifiable, Hashable, Equatable {
    let id: String
    let name: String
    let avatarURL: URL
    let stories: [Story]
    let allSeen: Bool
}
