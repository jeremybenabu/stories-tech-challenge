//
//  AppDependencyInjection.swift
//  Stories
//
//  Created by Jeremy Ben Abu on 30/06/2025.
//

final class AppDependencyInjection {

    lazy var storyListView: StoryListView = {
        let storiesModule = StoriesModule()
        return storiesModule.buildStoryListView()
    }()

}
