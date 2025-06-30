
import XCTest
import Combine
@testable import Stories

final class StoryListViewModelTests: XCTestCase {

    private var viewModel: StoryListViewModel!
    private var mockFetchStoriesUseCase: MockFetchStoriesUseCase!
    private var mockObserveStoriesUseCase: MockObserveStoriesUseCase!
    private var mockMarkStorySeenUseCase: MockMarkStorySeenUseCase!
    private var clearLocalStorageUseCase: MockClearLocalStoriesUseCase!
    private var cancellables = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()
        mockFetchStoriesUseCase = MockFetchStoriesUseCase()
        mockObserveStoriesUseCase = MockObserveStoriesUseCase()
        mockMarkStorySeenUseCase = MockMarkStorySeenUseCase()
        clearLocalStorageUseCase = MockClearLocalStoriesUseCase()

        viewModel = StoryListViewModel(
            fetchStoriesUseCase: mockFetchStoriesUseCase,
            observeStoriesUseCase: mockObserveStoriesUseCase,
            markStorySeenUseCase: mockMarkStorySeenUseCase,
            clearLocalStorageUseCase: clearLocalStorageUseCase
        )
    }

    func testInitialState_isIdleAndEmpty() {
        XCTAssertEqual(viewModel.state, .idle)
        XCTAssertTrue(viewModel.userStories.isEmpty)
    }

    func testFetchStories_success_setsLoadingAndThenReceivesUpdates() async {
        // Given
        let expectedStates: [StoryListViewModel.StoryListState] = [
            .idle,
            .loading,
            .loaded([.mock])
        ]
        var stateValues: [StoryListViewModel.StoryListState] = []
        viewModel.$state.sink { stateValues.append($0) }.store(in: &cancellables)

        // when
        await viewModel.fetchStories()

        // then
        XCTAssertEqual(stateValues, expectedStates)
        XCTAssertEqual(self.viewModel.userStories, [.mock])
    }

    func testMarkStoryAsSeen_executesUseCase() async {
        // given
        let expectation = expectation(description: "Wait for status updates")
        let expectedStates: [StoryListViewModel.StoryListState] = [
            .idle,
            .loading,
            .loaded([.mock]),
            .loaded([.mock2])
        ]
        var stateValues: [StoryListViewModel.StoryListState] = []
        viewModel.$state.sink { value in
            stateValues.append(value)
            if stateValues.count == expectedStates.count {
                // then
                XCTAssertEqual(stateValues, expectedStates)
                expectation.fulfill()
            }
        }.store(in: &cancellables)

        // when
        await viewModel.fetchStories()
        await viewModel.markStoryAsSeen(storyId: "storyId1")
        mockObserveStoriesUseCase.subject.send([.mock2])

        await fulfillment(of: [expectation], timeout: 20000.0)
    }

    func testSelectedUserStory_setsCorrectIndex() async {
        // given
        mockFetchStoriesUseCase.result = [.mock, .mock4]
        await viewModel.fetchStories()

        // when
        viewModel.selectedUserStory(.mock4)

        // then
        XCTAssertEqual(viewModel.selectedUserStoryIndex, 1)
    }

    func testMoveToNextUserStory_incrementsIndex() async {
        // given
        mockFetchStoriesUseCase.result = [.mock, .mock4]
        await viewModel.fetchStories()

        // when
        let moved = viewModel.moveToNextUserStory()

        // then
        XCTAssertTrue(moved)
        XCTAssertEqual(viewModel.selectedUserStoryIndex, 1)
    }

    func testMoveToPreviousUserStory_decrementsIndex() async {
        // given
        mockFetchStoriesUseCase.result = [.mock, .mock4]
        await viewModel.fetchStories()
        viewModel.selectedUserStoryIndex = 1

        // when
        let moved = viewModel.moveToPreviousUserStory()

        // then
        XCTAssertTrue(moved)
        XCTAssertEqual(viewModel.selectedUserStoryIndex, 0)
    }
}

// MARK: - Mocks

final class MockFetchStoriesUseCase: FetchStoriesUseCase {
    var result: [UserStory] = [.mock]
    func execute(isFirstLoad: Bool) async throws -> [UserStory] {
        return result
    }
}

final class MockObserveStoriesUseCase: ObserveStoriesUseCase {
    let subject = PassthroughSubject<[UserStory], Never>()
    func execute() -> AnyPublisher<[UserStory], Never> {
        return subject.eraseToAnyPublisher()
    }
}

final class MockMarkStorySeenUseCase: MarkStorySeenUseCase {
    var calledWithStoryId: String?

    func execute(storyId: String) async {
        calledWithStoryId = storyId
    }
}

final class MockClearLocalStoriesUseCase: ClearLocalStorageUseCase {
    func execute() async {}
}
