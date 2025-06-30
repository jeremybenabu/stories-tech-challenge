//
//  StoryMediaContentView.swift
//  Stories
//
//  Created by Jeremy Ben Abu on 30/06/2025.
//
import AVKit
import SwiftUI

// MARK: - StoryContentView

struct StoryMediaContentView: View {

    let story: Story
    @EnvironmentObject var module: StoriesModule
    let isPaused: Bool
    let onReady: () -> Void

    @State private var player = AVPlayer()
    @State private var isVideoReady: Bool = false
    @State private var playerItemToken: NSObjectProtocol?

    var body: some View {
        Group {
            switch story.mediaType {
            case .image:
                storyImageView
            case .video:
                storyVideoView
            }
        }
        .background(Color.black)
        .ignoresSafeArea()
    }

    private var storyImageView: some View {
        Color.clear
            .overlay (
                module.buildCacheImageView(url: story.mediaURL) {
                    onReady()
                }
            )
            .clipped()
    }

    private var storyVideoView: some View {
        ZStack {
            ScaledVideoPlayer(player: player)
                .edgesIgnoringSafeArea(.all)

            if !isVideoReady {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
            }
        }
        .onAppear {
            let playerItem = AVPlayerItem(url: story.mediaURL)

            playerItemToken = NotificationCenter.default.addObserver(forName: .AVPlayerItemNewAccessLogEntry, object: playerItem, queue: .main) { _ in
                isVideoReady = true
                onReady()
            }

            player.replaceCurrentItem(with: playerItem)

            if !isPaused {
                player.play()
            }
        }
        .onChange(of: isPaused) { _, paused in
            paused ? player.pause() : player.play()
        }
        .onDisappear {
            player.pause()
            player.replaceCurrentItem(with: nil)
            if let token = playerItemToken {
                NotificationCenter.default.removeObserver(token)
                playerItemToken = nil
            }
        }
    }
}
