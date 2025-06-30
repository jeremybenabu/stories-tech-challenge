//
//  StorageManager.swift
//  Stories
//
//  Created by Jeremy Ben Abu on 30/06/2025.
//

import Foundation

struct StorageManager {
    let baseFileName: String

    private func fileURL(for file: String) -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(file)
    }

    func load<T: Decodable>(file: String) -> T? {
        let url = fileURL(for: file)
        guard let data = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode(T.self, from: data) else {
            return nil
        }
        return decoded
    }

    func save<T: Encodable>(_ object: T, file: String) {
        let url = fileURL(for: file)
        guard let data = try? JSONEncoder().encode(object) else { return }
        try? data.write(to: url)
    }

    func clear(file: String) {
        let url = fileURL(for: file)
        if FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.removeItem(at: url)
        }
    }

    func latestPageIndex() -> Int {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let files = (try? FileManager.default.contentsOfDirectory(atPath: directory.path)) ?? []
        let indices = files.compactMap {
            $0.hasSuffix(".json") ? Int($0.replacingOccurrences(of: ".json", with: "")) : nil
        }
        return indices.max() ?? 0
    }
}
