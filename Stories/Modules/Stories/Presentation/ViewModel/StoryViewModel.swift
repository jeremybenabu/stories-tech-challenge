//
//  StoryViewModel.swift
//  Stories
//
//  Created by Jeremy Ben Abu on 30/06/2025.
//
import SwiftUI
import Combine

final class StoryViewModel: ObservableObject {

    enum PressZone {
        case left, right
    }

    @Published private(set) var userStory: UserStory
    @Published private(set) var currentStoryIndex: Int
    @Published private var storyProgress: Double = 0.0
    @Published private(set) var isPressing: Bool = false

    private let onNextUserStory: () -> Void
    private let onPreviousUserStory: () -> Void
    private let onStoryAppear: (String) -> Void

    private var progressPublisher: AnyCancellable?
    private var pressStartTime: Date?

    private let likeStoryUseCase: LikeStoryUseCase

    init(
        userStory: UserStory,
        likeStoryUseCase: LikeStoryUseCase,
        onNextUserStory: @escaping () -> Void,
        onPreviousUserStory: @escaping () -> Void,
        onStoryAppear: @escaping (String) -> Void
    ) {
        self.userStory = userStory
        self.likeStoryUseCase = likeStoryUseCase
        self.onNextUserStory = onNextUserStory
        self.onPreviousUserStory = onPreviousUserStory
        self.onStoryAppear = onStoryAppear
        self.currentStoryIndex = userStory.stories.firstIndex(where: { !$0.isSeen }) ?? userStory.stories.count - 1
    }

    var currentStory: Story {
        userStory.stories[currentStoryIndex]
    }

    func onMediaReady() {
        startTimer()
    }

    func progressValue(for index: Int) -> Double {
        index < currentStoryIndex ? 1.0 : (index == currentStoryIndex ? storyProgress : 0.0)
    }

    @MainActor
    func likeStory() async {
        userStory = await likeStoryUseCase.execute(storyId: currentStory.id) ?? userStory
    }
}

// MARK: - Story navigation
private extension StoryViewModel {
    private func goToNextStory() {
        resetTimerAndProgress()
        if currentStoryIndex < userStory.stories.count - 1 {
            currentStoryIndex += 1
        } else {
            onNextUserStory()
        }
    }

    private func goToPreviousStory() {
        resetTimerAndProgress()
        if currentStoryIndex > 0 {
            currentStoryIndex -= 1
        } else {
            onPreviousUserStory()
        }
    }
}

// MARK: - Story view lifecycle process
extension StoryViewModel {
    func notifyStoryAppear() {
        resetTimerAndProgress()
        onStoryAppear(currentStory.id)
    }

    func resetTimerAndProgress() {
        stopTimer()
        storyProgress = 0
    }
}

// MARK: - Story timer process
private extension StoryViewModel {
    private func startTimer() {
        guard progressPublisher == nil, !isPressing else { return }

        let interval = 0.01
        let increment = interval / Double(currentStory.duration)
        progressPublisher = Timer.publish(every: interval, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self else { return }
                self.storyProgress += increment
                if self.storyProgress >= 1.0 {
                    self.progressPublisher?.cancel()
                    self.progressPublisher = nil
                    self.storyProgress = 1.0
                    self.goToNextStory()
                }
            }
    }

    private func stopTimer() {
        progressPublisher?.cancel()
        progressPublisher = nil
    }
}

// MARK: - Press gesture processing
extension StoryViewModel {
    func processPress(_ pressing: Bool, zone: PressZone) {
        if pressing {
            pressStartTime = Date()
            stopTimer()
            isPressing = true
        } else {
            isPressing = false
            if let start = pressStartTime {
                let duration = Date().timeIntervalSince(start)
                if duration < 0.2 {
                    switch zone {
                    case .left:
                        goToPreviousStory()
                    case .right:
                        goToNextStory()
                    }
                } else {
                    startTimer()
                }
            }
            pressStartTime = nil
        }
    }
}
