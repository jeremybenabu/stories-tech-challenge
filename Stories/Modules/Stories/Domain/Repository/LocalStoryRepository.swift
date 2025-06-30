//
//  LocalStoryRepository.swift
//  Stories
//
//  Created by Jeremy Ben Abu on 30/06/2025.
//

protocol LocalStoryRepository {
    func loadStories() async -> [UserDTO]
    func appendStories(stories: [UserDTO], forPage index: Int) async -> [UserDTO]
    func markStorySeen(_ id: String) async
    func likeStoryPressed(_ id: String) async -> UserDTO?
    func clearLocalStorage() async
    func getLastPageIndex() async -> Int
}
