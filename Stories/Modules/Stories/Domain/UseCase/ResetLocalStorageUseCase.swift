//
//  ResetLocalStorageUseCase.swift
//  Stories
//
//  Created by Jeremy Ben Abu on 30/06/2025.
//

protocol ClearLocalStorageUseCase {
    func execute() async
}

struct DefaultClearLocalStorageUseCase: ClearLocalStorageUseCase {

    private let repository: StoryRepository

    init(repository: StoryRepository) {
        self.repository = repository
    }

    func execute() async {
        await repository.clearLocalStorage()
    }
}
