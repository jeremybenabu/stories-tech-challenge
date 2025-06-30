//
//  LocalStoryRepositoryTests.swift
//  Stories
//
//  Created by Jeremy Ben Abu on 30/06/2025.
//

import XCTest
@testable import Stories

final class LocalStoryRepositoryTests: XCTestCase {

    private var sut: LocalStoryRepository!

    override func setUpWithError() throws {
        sut = DefaultLocalStoryRepository(storage: StorageManager(baseFileName: "test_storage.json"))
    }

    override func tearDownWithError() throws {
    }

    func testStoreAndLoadStories() async throws {
        // given
        _ = await sut.appendStories(stories: [UserDTO.mock], forPage: 0)

        // when
        let loadedStories = await sut.loadStories()

        // then
        XCTAssertEqual(loadedStories.count, 1)
        XCTAssertEqual(loadedStories, [UserDTO.mock])
    }

    func testMarkStorySeen() async throws {
        // given
        _ = await sut.appendStories(stories: [UserDTO.mock], forPage: 0)

        // when
        await sut.markStorySeen("storyId1")
        let updatedUser = await sut.loadStories()

        // then
        XCTAssertTrue(updatedUser.first?.stories.first?.isSeen ?? false)
    }

    func testLikeStoryPressedTogglesLike() async throws {
        // given
        _ = await sut.appendStories(stories: [UserDTO.mock], forPage: 0)

        // when
        let likedOnce = await sut.likeStoryPressed("storyId1")

        // then
        XCTAssertEqual(likedOnce?.stories.first?.isLiked, true)

        // and  when
        let likedTwice = await sut.likeStoryPressed("storyId1")

        // then
        XCTAssertEqual(likedTwice?.stories.first?.isLiked, false)
    }

}
