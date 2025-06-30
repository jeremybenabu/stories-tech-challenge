//
//  ScaledVideoPlayer.swift
//  Stories
//
//  Created by Jeremy Ben Abu on 30/06/2025.
//
import AVKit
import UIKit
import SwiftUI

// MARK: - ScaledVideoPlayer
struct ScaledVideoPlayer: UIViewRepresentable {

    let player: AVPlayer

    func makeUIView(context: Context) -> PlayerContainerView {
        let view = PlayerContainerView()
        view.player = player
        return view
    }

    func updateUIView(_ uiView: PlayerContainerView, context: Context) {
        uiView.player = player
    }

    class PlayerContainerView: UIView {
        private let playerLayer = AVPlayerLayer()

        var player: AVPlayer? {
            didSet {
                playerLayer.player = player
            }
        }

        override init(frame: CGRect) {
            super.init(frame: frame)
            playerLayer.videoGravity = .resizeAspectFill
            layer.addSublayer(playerLayer)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func willMove(toSuperview newSuperview: UIView?) {
            if newSuperview == nil {
                player?.pause()
                player = nil
            }
        }

        override func layoutSubviews() {
            super.layoutSubviews()
            playerLayer.frame = bounds
        }
    }
}
