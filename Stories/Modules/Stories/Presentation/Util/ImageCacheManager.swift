//
//  ImageCacheManager.swift
//  Stories
//
//  Created by Jeremy Ben Abu on 30/06/2025.
//
import Foundation
import SwiftUI

// MARK: - ImageCacheManager Protocol

/// A protocol defining methods for loading images with caching support.
protocol ImageCacheManager {
    /// Loads an image from the cache or downloads it if not available.
    ///
    /// - Parameter url: The URL of the image to fetch.
    /// - Returns: A `UIImage` object if found or downloaded successfully; otherwise, `nil`.
    func loadImage(from url: URL) async -> UIImage?
}

// MARK: - DefaultImageCacheManager

/// A default implementation of `ImageCacheManager` that uses `URLCache` for caching images.
final class DefaultImageCacheManager: ImageCacheManager {

    // MARK: - Properties

    /// The shared URL cache used to store and retrieve cached responses.
    private let cache = URLCache.shared

    /// The URL session used for network requests.
    private let session: URLSession

    // MARK: - Initialization

    /// Initializes the image cache manager with a custom URL session.
    ///
    /// - Parameter session: A URL session conforming to `URLSessionProtocol`.
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    // MARK: - Public Methods

    /// Loads an image from the cache or downloads it if not cached.
    ///
    /// - Parameter url: The URL of the image to fetch.
    /// - Returns: A `UIImage` if the image is found in the cache or successfully downloaded; otherwise, `nil`.
    func loadImage(from url: URL) async -> UIImage? {
        if let cachedResponse = cache.cachedResponse(for: URLRequest(url: url)),
           let image = UIImage(data: cachedResponse.data) {
            // Return cached image if available
            return image
        } else {
            // Download and cache the image if not found
            return await downloadImage(from: url)
        }
    }

    // MARK: - Private Methods

    /// Downloads the image from the given URL and stores it in the cache.
    ///
    /// - Parameter url: The URL of the image to download.
    /// - Returns: The downloaded `UIImage` if successful; otherwise, `nil`.
    private func downloadImage(from url: URL) async -> UIImage? {
        do {
            let (data, response) = try await session.data(for: URLRequest(url: url), delegate: nil)
            guard let image = UIImage(data: data) else {
                return nil
            }

            // Store the downloaded image in the cache
            let cachedData = CachedURLResponse(response: response, data: data)
            cache.storeCachedResponse(cachedData, for: URLRequest(url: url))

            return image
        } catch {
            return nil
        }
    }
}
