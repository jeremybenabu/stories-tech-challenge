//
//  MockInMemoryStoryDataSource.swift
//  Stories
//
//  Created by Jeremy Ben Abu on 30/06/2025.
//

@testable import Stories

final class MockLocalStoryRepository: LocalStoryRepository {

    private let datasource = DefaultLocalStoryRepository(storage: StorageManager(baseFileName: "test_storage.json"))

    enum Invocations: Equatable {
        case loadStories
        case getLastPageIndex
        case appendStories(stories: [UserDTO], index: Int)
        case markStorySeen(id: String)
        case likeStoryPressed(id: String)
        case clearLocalStorage
    }

    private(set) var invocations: [Invocations] = []

    func loadStories() async -> [UserDTO] {
        invocations.append(.loadStories)
        return await datasource.loadStories()
    }

    func appendStories(stories: [Stories.UserDTO], forPage index: Int) async -> [Stories.UserDTO] {
        invocations.append(.appendStories(stories: stories, index: index))
        return await datasource.appendStories(stories: stories, forPage: index)
    }

    func getLastPageIndex() async -> Int {
        invocations.append(.getLastPageIndex)
        return await datasource.getLastPageIndex()
    }

    func markStorySeen(_ id: String) async {
        invocations.append(.markStorySeen(id: id))
        return await datasource.markStorySeen(id)
    }

    func likeStoryPressed(_ id: String) async -> UserDTO? {
        invocations.append(.likeStoryPressed(id: id))
        return await datasource.likeStoryPressed(id)
    }

    func clearLocalStorage() async {
        invocations.append(.clearLocalStorage)
        return await datasource.clearLocalStorage()
    }
}
