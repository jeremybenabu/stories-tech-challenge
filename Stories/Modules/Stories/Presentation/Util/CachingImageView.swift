//
//  CachingImageView.swift
//  Stories
//
//  Created by Jeremy Ben Abu on 30/06/2025.
//

import SwiftUI

// MARK: - CachingImageView

/// A view that displays an image from a URL, using a caching mechanism to improve performance.
/// It first checks the cache; if the image is not cached, it downloads and caches it.
struct CachingImageView: View {

    // MARK: - Properties

    /// The string URL of the image to load.
    private let url: URL

    /// The image cache manager responsible for loading and caching the image.
    private let imageLoader: ImageCacheManager

    /// The loaded image, either from the cache or downloaded.
    @State private var loadedImage: UIImage?

    let imageLoaded: (() -> Void)?

    // MARK: - Initialization

    /// Initializes the caching image view.
    ///
    /// - Parameters:
    ///   - url: The URL of the image to display.
    ///   - imageLoader: An object conforming to `ImageCacheManager` to handle image loading and caching.
    init(url: URL,
         imageLoader: ImageCacheManager = DefaultImageCacheManager(),
         imageLoaded: (() -> Void)? = nil
    ) {
        self.url = url
        self.imageLoader = imageLoader
        self.imageLoaded = imageLoaded
    }

    // MARK: - Body

    var body: some View {
        Group {
            if let loadedImage = loadedImage {
                // Show the image if it has been loaded
                Image(uiImage: loadedImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                // Show a loading indicator while fetching the image
                ProgressView()
                    .onAppear {
                        Task {
                            await loadImage()
                        }
                    }
            }
        }.onAppear {
            if loadedImage != nil {
                Task {
                    await imageLoadingCompletion()
                }
            }
        }
    }

    // MARK: - Private Methods

    /// Loads the image from cache or downloads it if not available.
    @MainActor
    private func loadImage() async {
        self.loadedImage = await imageLoader.loadImage(from: url)
        await imageLoadingCompletion()
    }

    @MainActor
    private func imageLoadingCompletion() async {
        try? await Task.sleep(nanoseconds: 1_000)
        imageLoaded?()
    }
}
