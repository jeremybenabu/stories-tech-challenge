//
//  StoryRepositoryTests.swift
//  Stories
//
//  Created by Jeremy Ben Abu on 30/06/2025.
//

import XCTest
import Combine
@testable import Stories

final class StoryRepositoryTests: XCTestCase {

    private var sut: DefaultStoryRepository!
    private var mockService: MockStoryService!
    private var mockDataSource: MockLocalStoryRepository!
    private var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        mockService = MockStoryService()
        mockDataSource = MockLocalStoryRepository()
        sut = DefaultStoryRepository(
            service: mockService,
            localStoryRepository: mockDataSource
        )
    }

    override func tearDown() async throws {
        sut = nil
        mockService = nil
        await mockDataSource.clearLocalStorage()
        mockDataSource = nil
        cancellables.removeAll()
        try await super.tearDown()
    }

    func testFetchStories_whenLocalDataIsEmpty_fetchesFromRemote() async throws {
        await mockDataSource.clearLocalStorage()
        // when fetching stories
        let result = try await sut.fetchStories(isFirstLoad: true)

        // then
        XCTAssertEqual(result, [.mock])
        XCTAssertTrue(mockService.fetchCalled)
        XCTAssertEqual(
            mockDataSource.invocations,
            [
                .clearLocalStorage,
                .getLastPageIndex,
                .loadStories,
                .appendStories(stories: [.mock], index: 0)
            ]
        )
    }

    func testFetchStories_whenLocalDataIsNotEmpty_returnsLocalData() async throws {
        // given
        _ = await mockDataSource.appendStories(stories: [.mock], forPage: 0)

        // when
        let result = try await sut.fetchStories(isFirstLoad: true)

        // then
        XCTAssertEqual(result, [.mock])
        XCTAssertFalse(mockService.fetchCalled)
        XCTAssertEqual(
            mockDataSource.invocations,
            [
                .appendStories(stories: [.mock], index: 0),
                .getLastPageIndex,
                .loadStories
            ]
        )
    }

    func testMarkStoryAsSeen_updatesCurrentStories() async {
        // given
        let expectation = expectation(description: "Wait for repository updates")
        _ = await mockDataSource.appendStories(stories: [.mock], forPage:  0)

        // when
        await sut.markStoryAsSeen(StoryDTO.mock.id)

        sut.storiesPublisher.sink { received in
            XCTAssertEqual(received, [.mock2])
            expectation.fulfill()
        }.store(in: &cancellables)

        await fulfillment(of: [expectation], timeout: 2.0)
        XCTAssertEqual(
            mockDataSource.invocations,
            [
                .appendStories(stories: [.mock], index: 0),
                .markStorySeen(id: StoryDTO.mock.id),
                .loadStories
            ]
        )
    }

    func testLikeStory_returnsUpdatedStory() async {
        // given
        _ = await mockDataSource.appendStories(stories: [.mock], forPage: 0)

        // when
        let result = await sut.likeStory(StoryDTO.mock.id)

        // then
        XCTAssertEqual(result, .mock3)
        XCTAssertEqual(
            mockDataSource.invocations,
            [
                .appendStories(stories: [.mock], index: 0),
                .likeStoryPressed(id: StoryDTO.mock.id),
                .loadStories
            ]
        )
    }
}
