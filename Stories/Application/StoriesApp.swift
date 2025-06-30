//
//  StoriesApp.swift
//  Stories
//
//  Created by Jeremy Ben Abu on 30/06/2025.
//

import SwiftUI

@main
struct StoriesApp: App {

    private let appDependencyInjection = AppDependencyInjection()

    var body: some Scene {
        WindowGroup {
            appDependencyInjection.storyListView
        }
    }
}
