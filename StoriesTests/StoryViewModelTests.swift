//
//  StoryViewModelTests.swift
//  Stories
//
//  Created by Jeremy Ben Abu on 30/06/2025.
//

import XCTest
@testable import Stories

final class StoryViewModelTests: XCTestCase {

    private var viewModel: StoryViewModel!
    private var mockUseCase: MockLikeStoryUseCase!
    private var didCallNextUserStory = false
    private var didCallPreviousUserStory = false
    private var appearedStoryID: String?

    override func setUp() {
        super.setUp()
        mockUseCase = MockLikeStoryUseCase()

        viewModel = StoryViewModel(
            userStory: .mock,
            likeStoryUseCase: mockUseCase,
            onNextUserStory: { self.didCallNextUserStory = true },
            onPreviousUserStory: { self.didCallPreviousUserStory = true },
            onStoryAppear: { self.appearedStoryID = $0 }
        )
    }

    func testInitialization_setsFirstUnseenStory() {
        XCTAssertEqual(viewModel.currentStory.id, UserStory.mock.stories.first?.id)
    }

    func testLikeStory_shouldUpdateUserStory() async {
        // given
        XCTAssertFalse(viewModel.currentStory.isLiked)
        mockUseCase.result = .mock3

        // when
        await viewModel.likeStory()

        // then
        XCTAssertTrue(viewModel.currentStory.isLiked)
    }

    func testProcessPress_quickTapLeft_callsGoToPreviousStory() {
        viewModel.processPress(true, zone: .left)
        viewModel.processPress(false, zone: .left)

        XCTAssertTrue(didCallPreviousUserStory)
        XCTAssertTrue(viewModel.currentStoryIndex == 0)
    }

    func testProcessPress_quickTapRight_callsGoToNextStory() async {
        // given tap 1
        viewModel.processPress(true, zone: .right)
        try? await Task.sleep(nanoseconds: 2_000)
        viewModel.processPress(false, zone: .right)

        // given tap 2
        viewModel.processPress(true, zone: .right)
        try? await Task.sleep(nanoseconds: 2_000)
        viewModel.processPress(false, zone: .right)

        // next user story called
        XCTAssertTrue(didCallNextUserStory)
    }

    func testNotifyStoryAppear_triggersCallback() {
        viewModel.notifyStoryAppear()

        XCTAssertEqual(appearedStoryID, viewModel.currentStory.id)
    }
}
